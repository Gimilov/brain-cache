---
tags:
  - "#AOS"
  - type/lecture
---
Created: 2025-02-21 15:19
Lecture: [[L05d - Active Networks]]
Summary source: [link](https://medium.com/@n.davis/paper-spotlight-active-network-vision-and-reality-david-wetherall-73436941961d)

# Introduction

Active networking has been proposed with two aims:

1. Enabling applications that leverage computation within the network.
2. Decoupling services from the underlying architecture.

The primary concern with active networks is untrusted code in the network. (There is a contrasting idea of active services that seek to gain the same benefits by using domain-specific proxies for the requisite services rather than touching the network layer.)

Some active networks provide extensibility to individual devices. Others provide programmability across multiple nodes for control tasks rather than data transfer services. Both of these restrict either where programs can execute or who can run them. The ANTS (Active Network Transport System) toolkit that implements the ideas in the paper, by contrast, does not impose either restriction a priori.
# ANTS 101

ANTS is based on a capsule approach in which code is associated with packets and executed at selected IP routers that are extensible. For security reasons, code for network services is signed by a trusted authority to certify it as a ‘reasonable’ use of network resources and registered with a directory service using a human-readable name to make it available to other users.

# Interface

Applications obtain customised network services by exchanging capsules via programmable routers (active nodes).

Capsules extend the IP packet and act like agents that direct themselves through the network.

Active nodes may be connected to other active nodes or conventional IP routers by link layer channels.

The selected forwarding routine (specified by the end-user software in the type field when injecting a capsule) is executed at each active node in a capsule’s path.

IP forwarding uses the IP header as usual.
![](/img/L05d_active_networks_8.png)
# The Active Node API
![](/img/L05d_active_networks_9.png)
# Implementation

ANTS separates the transfer of service code from the rest of the capsule and caches code at active nodes.

A lightweight code distribution system transfers the code along the path the capsule follows when the code is not already cached.

Code size is limited to limit the impact of code transfers on the network. When the forwarding code is not found in the cache, the previous node (from the previous address header field), which likely has the code in its cache because it recently executed it, is queried. The acquired code is cached for future use or, if the messages are lost or the code is unavailable, the capsule is discarded.

Received capsules are demultiplexed (using the type field) to the associated forwarded routine, which is executed safely in a sandbox.

By allowing for both active nodes and standard IP routers, ANTS is designed for incremental deployment. At a finer granularity, nodes can double as active nodes for some services and IP routers for others. The architecture leaves this decision to be local.
![](/img/L05d_active_networks_10.png)
# Performance — Capsules and Code Distribution

Capsules can be a competitive forwarding mechanism for two reasons:

- Capsule code can be carried by reference and loaded on demand. Fingerprinting code by the one-way MD5 is a secure technique.
- Capsule processing is only a small overhead over IP forwarding when both are implemented in software.

Caching helps keep loading code rare enough; its performance is therefore of little consequence as long as it is adequate.

# Performance — Forwarding

Processing at active nodes can be separated by granularity:

- Per-capsule forwarding
- Per-service code distribution
- Periodic node management

Only the first of these limits node performance in practice.

Measurements of the ANTS toolkit showed a processing cost of about 1ms per code distribution message, with up to 16 messages to transfer service code, which is approximately one order of magnitude more expensive than regular capsule forwarding. This implies that the cost of loading should be amortised over about 1000 capsules before its impact on network performance can be considered negligible (1%).

Periodic tasks, on the other hand, such as route updates and cleaning the soft-store, do not result in a noticeable slowdown because they occur at a much coarser granularity and their implementation does not block forwarding for their duration.

Because no tight synchronisation is required between the per port forwarding engines, capsule forwarding is readily parallelised on routers with one processor per port.

In the benchmarks reported in the paper, ANTS achieved similar latency and throughput to the equivalent Java relay, though the C relay performed significantly better. While not very impressive (from the perspective of production), the results do show a deployable performance. The similar slopes also indicate that there are no data-dependent costs in using ANTS.  
Looking at the steps noted in the ANTS profile, though, a lot of the overhead (relative to IP) is avoidable:

1. Receiving the message from the operating system: Avoidable if running in the kernel, like IP
2. Checking the message structure to check that it is a valid capsule: Also done in IP
3. Mapping the capsule type to the appropriate forwarding routine: No such requirement for IP
4. Decoding the packet representation of the capsule to an object representation: An artifact of the Java-based implementation rather than the ANTS architecture
5. Invoking the forwarding routine: ANTS incurs a small overhead to set up the call when using IP forwarding as the default
6. A rounding table lookup for the route: The ANTS prototype performs worse because of the simpler hash lookup; a production ANTS system may use the same longest matching prefix operation as IP
7. Encoding the capsule (object to packet translation): Like the reverse of this translation, not intrinsic to the ANTS architecture
8. Updating the header fields (decrement the TTL, setting the previous node, etc): ANTS incurs a slight overhead by processing more headers than IP
9. Sending the message to the outgoing network interface via the operating system: Avoidable if running in the kernel, like IP

From the profile, the four largest overheads — steps 1 (packet receive), 4 (capsule decode), 7 (capsule encode), and 9 (packet transmit) — are not intrinsic to the ANTS architecture, but costs from a user-level Java-based implementation.

# Who Can Introduce New Services?

The active networks vision is that all users should be able to customise processing within the network, which would foster third-party developers and a marketplace for new services that would accelerate innovation.

ANTS isolates the code and state of services like static and trusted protocols despite the fact that service code is mobile and untrusted. The certification mechanism slows the rate of change, but still potentially faster than the internet.

# Overview of Threats

There are two classes of threats relevant to ANTS:

- **Protection threats**: These impact the execution of a service within the network so that it is no longer isolated from other code, and hence no longer guaranteed to behave correctly.
- **Resource management threats**: These affect the performance of a service rather than its correctness by unreasonably consuming shared resources, starving legitimate users.

## Protection

A key requirement enforced by the ANTS runtime sandbox is that capsules cannot change their type to that of another service, or, equivalently, create new capsules of another service. This makes it impossible to construct services that, for instance, search the network for and interfere with capsules belonging to another service.

While this authentication-free model limits the kinds of services that can be constructed (e.g. no firewalls), as with a lot that concerns security, the benefits outweigh the costs.

This model implies that any protection threats that emerge must stem from the transfer and execution of code within the network. Whether accidental or malicious, there are only three kinds of threats that can occur in ANTS that do not also arise in the internet:

- The service code may corrupt the node runtime. This is met using safe evaluation techniques for executing service code.
- The service code distributed to an active node may be corrupted or spoofed. This is met through fingerprinting capsule types.
- The state cached at an active node on behalf of one service may be corrupted by another. This is prevented by a restricted node API, guarding access to state shared across services. Read and write sharing (e.g. one capsule sets a custom route for another to follow) is implemented using hierarchical fingerprinting.

## Resource Management

One ANTS service can interfere with the performance of another in three ways:

- A capsule consuming large (possibly unbounded) resources at a single node. Solves by enforcing resource bounds.
- A capsule (and any capsules it creates) consuming large (possibly unbounded) resources at multiple nodes. Per capsule hop limits and dividing the TTL between a capsule and its descendants, bounding the total resources consumed, are potential options (though potentially problematic with multicasts and ‘ping-pongs’). The prototype falls back to the certification mechanism to manage this, with throttled resource allocation to uncertified code to allow rapid experimentation.
- An application on an end-system injecting a large (possibly unbounded) number of capsules into the network. Not well addressed in either ANTS or the internet, because network-based resource allocation mechanisms are absent, expecting the users to cooperate.

The paper argues that certification may have a role to play in the active network vision, not as a hard barrier to entry, but as a trail to follow when problems arise, and as a means to establish a level of trust. More trusted users could be allowed access to wider and more powerful APIs. This implies the need for allowing revocation.

# Potential Services

The most compelling use of capsules is to rapidly upgrade the services of large, wide-area networks such as the internet. There is a clear need for this, seeing the slow and difficult deployment of IPv6. IPv6 is unlikely to be the last evolutionary step in the history of the internet, and today’s internet hampers experimentation. Active networks can fill the gap by facilitating widespread deployment of even a small number of services such as multicast, mobility, or IPv6.

Active networks could be useful for the experimentation necessary for designing new protocols. However, as of the paper’s publication, no single application could prove the value of extensibility such as provided by the active networks vision.

# Characterising Services

Unlike existing mechanisms that proceed one router at a time, capsules deploy processing along network paths independent of the details of the path itself. This is a key reason they are able to effect change.  
A service that can be introduced in ANTS should be:

- **Expressible**: The service code must be constructed using the node API
- **Compact**: The service code must be smaller than a self-imposed limit of 16 KB to limit the impact of code distribution on the rest of the network
- **Fast**: Each routine must run to completion at the forwarding rate, or it will be aborted by the node
- **Incrementally deployable**: The service must not fail in case not all nodes are active
The authors implemented five services as test cases:

- Host mobility
- Source-specific multicast
- Path Maximum Transmission Unit (MTU) queries
- Protocol-Independent Multicast (PIM)
- Web cache routing

Other work using ANTS included services such as an auction service, a reliable multicast protocol, and a network-level packet cache.

# Discussion

The strongest argument for ANTS can be made using services that have received serious consideration but are difficult to introduce on the internet in its present state, but can benefit from using capsules, such as:

- Multicast
- Reliable multicast support
- Explicit congestion modification
- PIP (considered for IPv6)
- Anycast

# Expressible

The small API has proved sufficient for developing a wide range of services. Many variations on a forwarding routine may be possible. Implementing them is straightforward with ANTS, because deployment is automatic. The ability to execute code also provides a better way to discover network properties than the black box model of the internet today (e.g. MTU estimates by recording the minimum MTU as a capsule forwarded along a path as opposed to using heuristics and error messages).

The API does not allow two kinds of services to be constructed, both falling outside the design space of ANTS — long-lived processes embedded in the network (web caches or transcoding engines), because the API does not support reliable storage or timers, and services which cut across many flows (firewall filtering), because network processing is explicitly selected for each capsule as it is injected into the network as per the security model.  
Both these kinds of services can be created using other means that ANTS (or active networks in general) can work in tandem with.

# Compact and Fast

Forwarding routines, being ‘glue’ code, fit easily within the 16 KB limit. Inevitably, though, the limit acts as a bound on the kinds of services that could be constructed with ANTS, despite being sufficient for the kinds of services that ANTS targets.

The forwarding routines also complete quickly, because none of the API operations block on disk or network access, and combining them is straightforward.

The slowdowns for realistic services is within a factor of 2 of the ‘null’ ANTS capsule, quantifying the impact of running a real routine more complex than IP forwarding.

# Incrementally Deployable

Given the highly decentralised nature of the internet, all new services must be deployed incrementally. ANTS requires that services be able to function even in networks where all nodes are not active, simplifying the process; the design of services for a partially-active network is challenging, but usually soluble.

Running services in an overlay or using the active nodes adjacent to ordinary ones to get good estimates are some of the ways to work with heterogeneous (active and non-active) networks.

# Upgrading ANTS

Services can be designed to upgrade ANTS, because the following parts of ANTS (shared assumptions across active nodes) would require some modification:

- The way capsule types are computed and carried
- The address format
- The code distribution mechanism
- Resource limiting via TTLs
- The node API

Modifying common assumptions throughout active networks would be difficult and is likely best done the same way as protocol upgrades in the internet — with backwards-compatibility, versioning, or overlays. ANTS capsules carry a version number to allow this in the future. Design workarounds often eliminate the need for a change in the basic assumptions.

# Architectural Observations

## Value of Systematic Change

The active networks vision emphasises systematic deployment of upgrades as opposed to depending on backwards-compatibility. ANTS makes the processing that a capsule undergoes explicit while implicitly extending old processing. Explicit extension results in cleaner semantics.

## Heterogeneous Nodes

IP defines the minimal forwarding that will be executed at all locations. ANTS cannot make that assumption and must account for different kinds and complexities of processing at different locations. The strategy taken in the paper is to bind capsule routines at runtime to those nodes that have sufficient forwarding resources (queried using capsule code) to execute them. Clean execution requires that active nodes that take too long to run a routine should be able to unload them. This implies the need for designing services in a way such that their correctness does not depend on running on all nodes.

## End-to-End Argument

With one exception — encryption — the active network approach does not conflict with the end-to-end argument. ANTS is simply a framework for expressing and deploying new services, and the services can be designed well or poorly. Good design should aim at avoiding conflict with the end-to-end argument and architectural features.

End-to-end encryption (e.g. in IPv6 IPSEC) poses a challenge to the active network approach. Making encryption compatible with active networks would require developing encryption standards that expose header fields.

## Localising Change

Regardless of the protocol layer of the change and the type of the underlying network (active or not), changes in network services must be localised in their implementation for easy deployment.

Capsules allow changes to be made along an entire network path at one time rather than at individual locations, expanding the scope of potential changes.

# Summary of Results

The experiments with ANTS implement key features of the original active networks vision:

- A clean means of upgrading processing along an entire path (capsules)
- A customisable network that untrusted users can customise freely (though protecting the network as a whole still relies on a certification system)
- Capsules are more useful for network layer service evolution (by being suitable for introducing many variations of a service) rather than migration of application code to locations within the network
- Capsule code can work well with network embedded devices (caches, transcoders)

# Zooming Out

Back in the 90s, active networking was a solution looking for a problem, but the ideas of virtualising the network to customise traffic flows to isolate colocated tenants has found a new relevance in the age of datacentres as software-defined networking.

## Paper:
See underlined sections for quick reading (if any).
![](04_ActiveNetworks.pdf)