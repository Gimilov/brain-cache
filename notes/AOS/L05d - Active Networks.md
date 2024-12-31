---
tags:
  - type/lecture
  - "#AOS"
---
Created: 2024-12-30 19:04
Source: [LINK](https://andrewrepp.com/aos_lec_L05)

## Active Networks

- This section covers the idea of providing quality of service for network communication in an Operating System by making the network “active”
- ![](/img/L05d_active_networks_1.png)
	- Routers normally don’t inspect packet in any way. Just figure out the next hop to send the packet to, and do so.
        - Done statically via table lookups
- So what does it mean to make a node “active”?
    - Instead of the next hop being done viaa static table lookups, it should be dynamically determined by the router.
    - This would allow each network to have its own flows, and to update those based on traffic or conditions.
- How should this be implemented?
	- ![](/img/L05d_active_networks_2.png)
	- OS must provide QoS APIs to the application
    - The application will provide hints that the OS will use in synthesizing code to give hints to the network on how to handle the packets
    - This code will be added to the payload of the packets
    - These changes are very difficult to actually implement in the protcol stacks of the OS
    - Routers are not open, not all of them will be able to use the code in question

### ANTS Toolkit
- ![](/img/L05d_active_networks_3.png)
- ![](/img/L05d_active_networks_4.png)
	- Type field identifies code that must be executed to process capsule
	    - MD5 hash of the code
	- Prev field is the identity of the upstream node that successfully processed a capsule of this type
	- Capsule does not contain the code, only a type that allows to identify the code needed
- ![](/img/L05d_active_networks_5.png)
	- Routing decisions can be made regardless of physical topology based on API
    - Soft-store is where necessary code is stored, in key-value store
    - Other things can be stored in soft-store too, as needed
    - Can also query node, possibly about the network or the node itself
- ANTS == Active Node Transfer System
- Application level package
- Creates a capsule of ANTS header and payload
- Allows for both “normal” and “active” nodes to act upon the packet. This helps with “closed” router problem by keeping active nodes at only edges of the network
- Capsule Implementation
	- ![](/img/L05d_active_networks_6.png)
	- Action taken on capsule arrival
        - Type field: fingerprint for the capsule code
            - Cryptographically strong hash
        - Demand load capsule code from previous node by sending request
            - If the node does not already have the code indicated by the type field from the node indicated by the prev node field
            - The locality of capsule processing is very high, likely to process many of the same kind of capsule in close time proximity. Thus this will be a proportionally small expense
            - Once gotten and hashed, store in soft-store for future use
        - Drop capsule if code is not in soft-store or previous node
            - Higher-level acks will indicate to source and cause a re-transmission
            - This might happen because, for example, soft-store is limited and the relevant code may have been deleted from soft-store on previous node to make space

### Potential Applications of Active Networks

- Protocol-independent multicast
- Reliable multicast
- Congestion notification
- Private IP (PIP)
- Anycasting

### Pros and Cons of Active Networks

- Pros
    - Flexibility from Application perspective
        - Can ignore physical layout of the network
- Cons
    - Protection threats => solutions
        - ANTS runtime safety => Java sandboxing
        - code spoofing => robust fingerprinting method
        - soft-store integrity => restricted API
    - Resource management threats => solutions
        - Executing code at each node => restricted API
        - Flooding the network => Internet already susceptible (though may exacerbate this issue)

### Feasibility of Active Networks

- Router makers loath to opening up the network
    - Only feasible at the edge of the network
- Software routing cannot match the performance of hardware routing
    - Only feasible at the edge of the network
- Social and Psychological Objections
    - Hard for user community to accept arbitrary code executing in the public routing fabric
- Active Networks were a bit ahead of their time and lacked a killer app. Modern cloud computing offers a better use case, and Software-Defined Networking has resurrected a lot of the ideas that Active Networking originally innovated.