---
tags:
  - type/lecture
  - "#AOS"
---
Created: 2024-12-30 18:55
Source: [LINK](https://andrewrepp.com/aos_lec_L05)

# Distributed Systems

## Definitions

- What fundamentally distinguishes a distributed system from a parallel system is the degree of autonamy of the individual nodes of the system.
    - Also the fact that the interconnection system between the nodes of a distributed system is wide open to the worlds, instead of being confined to a rack or something
    - However, as hardware advances a lot of what have historically been “DS” problems are becoming relevant even at the single-chip level

### 3 Main Properties of a Distributed System

- A distributed system is a collection of nodes interconnected by a LAN or WAN
    - The LAN or WAN may be implemented with a variety of hardware (fiber, cable, satellite)
- No physical memory shared between nodes of a distributed system.
    - All communication must be done via messaging between nodes.
- Event computation time (time it takes on a single node to do some significant processing) is significantly less than the messaging time between nodes (Te « Tm)
    - Lamport definition: A system is distributed if the message transmission time is not negligible to the time between events in a single process
    - Interestingly, by this definition even a cluster is a distributed system (due to CPU speed being so good these days)
- ![](/img/L05a_definitions_1.png)
	- This indicates that A happened before B
	- This tells us that either A and B happened sequentially on the same process, or there is a communication event from A and B. Otherwise we would not know ordering and not be able to make this statement
- ![](/img/L05a_definitions_2.png)
	- “Happened before” relationship is transitive
	- “Concurrent” events are (basically) never actually at the exact same time, it’s just that we don’t have enough information to make a statement about which happened first based on the logic above
- ![](/img/L05a_definitions_3.png)
- Showing the logic for how to determine concurrent vs ordered events. Basically it reiterates above, about how we have ordering knowledge within a process, or if there are communication events between processes (which apply transitively when determining ordering). Anything where we don’t know gets lumped into “concurrent”, highlighted here with event M