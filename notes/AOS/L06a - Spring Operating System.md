---
tags:
  - type/lecture
  - "#AOS"
---
Created: 2024-12-30 19:17
Source: [LINK](https://andrewrepp.com/aos_lec_L06)
Read more here: [[Illustrated Notes for AOS by Bhavin Thaker]]

# Distributed Objects and Middleware

- How should we design for the continuous and incremental evolution of complex distributed software systems, both in terms of functionality and performance?
    - Distributed objects!

## Spring Operating System

- Later marketed as Solaris OS by Sun Microsystems
- How best to innovate OS?
    - Brand new OS? Or better implementation of known OS?
    - Usually constrained by marketplace needs
        - Large complex server software
        - There are probably legacy programs already running on your existing OS that you really would like to keep
        - So take the “intel inside” approach…. in this case “unix inside” for box makers like Sun

### Object-Based vs Procedural Design

- Procedural
	- ![](/img/L06a_spring_os_1.png)
	- Shared state (often global)
    - code written as one monolithic entity
- Objects
	- ![](/img/L06a_spring_os_2.png)
	- Objects contain state, not visible outside
    - Methods inside object that manipulate the state that is part of the object. Only these methods are exposed to the outside world
- The above are well understood for writing code. Spring applied them to the OS itself. So did Tornado, covered earlier in the class

### Spring Approach
- ![](/img/L06a_spring_os_3.png)
- Spring was Sun’s answer to building a network operating system, using the Unix interface. Its design reflects that
- Strong interfaces for each subsystem
- Open, flexible, and exentisble
    - Allows multiple languages to be used for system components
    - Used IDL (interface definition language) to facilitate this
    - This borrows a lot from microkernel design philosophies
- Nucleus == the “microkernel” of Spring
	- ![](/img/L06a_spring_os_4.png)
	- Abstractions are:
        - Domain (similar to a UNIX process)
            - threads execute in a particular domain. threads are similar to e.g. pthread
        - Door is a software capability to a domain (opening a door to get into a room == entering target domain) * Doors function via handles, can interact with e.g. fopen()
    - Spring kernel is the combination of the nucleus plus the memory management for handling the domain and door objects
    - This structure allows for very performant cross-domain protected procedure calls
### Object invocation across the network
- ![](/img/L06a_spring_os_5.png)
	- Proxy A: Export net handle embedding Door X to Proxy B
    - Proxy B: establishes Door Y locally so client can communicate with it.
    - Proxy B: use net handle to connect nuclei
    - When client accesses Door Y it thinks it is accessing server domain, it has no knowledge of any underlying mechanisms intervening
    - Likewise the Server interacting with door X thinks it’s being talked to directly by the client
- Doors are confined to the nucleus on a single node
- Object invocation is therefore extended using network proxies
- Proxies can potentially employ different protocols for different connections (e.g. LAN vs WAN nodes)
- Proxies are invisible to the client and servers. They are unaware whether they are on same or different machines, and don’t care.
### Secure Object Invocation
- ![](/img/L06a_spring_os_6.png)
- May be necessary for a server object to provide different privilege levels to different clients
- Security provided via a “front object” that is outside the Spring semantics for object invokation.
- The connection between front object and underlying object is entirely in the purview of the creator of the service object. Not part of Spring door mechanism
- Underlying object checks access control list, and passes appropriate methods or data back to front object. ACL checked before the invokation is allowed to proceed at all
    - Can use one-time references to limit access by preventing re-use of privileged access handles

### Virtual Memory Management in Spring
- ![](/img/L06a_spring_os_7.png)
- Memory management is part of the kernel in Spring
- There is a per-machine virtual memory manager
    - VMM breaks the linear address space into regions
        - Regions: set of pages
- Memory Objects
    - Regions are mapped to different memory objects
    - Different regions of the address space can also be mapped to the same region
    - Abstraction of a “region” may map to files, swap spaces, etc
- Memory Object Specific Paging
	- ![](/img/L06a_spring_os_8.png)
	- object must be brought into DRAM
        - pager object does this
            - makes or establishes relationship between virtual and physical memory
            - pager object creates a cache object in the DRAM
    - There can be multiple managers, memory objects, pager objects, etc. Only one DRAM though

### Spring System Summary

- Oboject-oriented kernel
- nucleus -> threads and IPC
- microkernel -> nucleus and address space
- doors and door tables -> basis for cross domain calls
- object invocation and cross machine calls
- Virtual memory management
    - address space object, memory object, external pagers, cache objects

### Dynamic Client-Server Relationship on Spring

- Client and server can be on the same or different machines, without change to implementation
- This is done using “subcontracts”
	- ![](/img/L06a_spring_os_9.png)
	- The subcontract is the interface provided for realizing the IDL contract between the client and server
- Hides the runtime behavior of the object from the actual interface
- Client side stub generation is thus simplified, with the specific subcontract used responsible for the details
    - Subcontract can be changed at any time as needed
- Subcontract interface for stubs
	- ![](/img/L06a_spring_os_10.png)
	- First interface is for marshaling/unmarshaling
    - all details such as server location are buried in the subcontract
    - client stub just calls subcontract
        - also true on server side
- Client and server stubs are thus the same for all instances of client and server. Only subcontracts differ.
    - This does seem to me like just shuffling the complexity around. Presumably does actually reduce overall complexity required, though.