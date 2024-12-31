---
tags:
  - type/lecture
  - "#AOS"
---
Created: 2024-12-30 18:57
Source: [LINK](https://andrewrepp.com/aos_lec_L05)

## Lamport Clocks

- What does each node know?
    - Its own events
    - Communication events
- Lamport’s Logical Clock
    - Monotonic increase of own event times (increment amount does not matter)
        - Condition 1: Ci(a) < Ci(b)
    - Message receipt time greater than send time
        - Condition 2: Ci(a) < Cj(d)
    - Timestamps of concurrent events are arbitrary
    - The above describes a “partial ordering” of events
    - What to do if you need a total order?
- Lamport’s Total Order
    - If there are two events, A and B, that are concurrent by the above definition, then you can use and arbitrary “well known” condition to break the tie
    - The corrolary of this is that there is no single “total order” universally. It is a function of whatever condition you choose to break ties
    - Once a total order is determined, the actual timestamps are no longer relevant. Only Lamport ordering actually matters for application logic
- Distributed M.E. Lock Algorithm
	- ![](/img/L05b_Lamport_Clocks_1.png)
	- Each node maintains a queue of requests for the lock
    - Whenever a node wants the lock, adds it to its own queue and sends a request to all other nodes, which add the request to their queue. All such messages/queue entries include timestamp of the request.
    - Every process orders their queue by lamport’s clock
    - Ties broken by process ID
    - Queues across processes may not match each other, due to travel time of messages
    - Processes know that they have the lock if:
        - Their own request is at the top of the queue (again, ordered by Lamport order with PID as tiebreaker)
        - They have acks or later lock requests from all other nodes in the system
    - Lock release:
        - P1 removes its request from its own queue and sends unlock message to all other nodes
        - When peers receive the unlock message, P1s request is removed from their queues
    - Correctness is based on the following assumptions
        - Messages arrive in order
        - There is no message loss
        - Queues are totally ordered => by Lamport’s logical clocks plus PID to break ties
    - Message Complexity
        - How many messages are exchanged among all the nodes for each lock acquisition followed by a lock release
            - 3 * (N-1)
            - N-1 Lock request messages
            - N-1 Lock ack messages
            - N-1 Unlock messages
                - No acks due to above assumption that no messages are lost
        - Can we do better? Yes.
            - Defer acks if my req precedes yours
                - Combining with unlock reduces to 2 * (N-1)
- Lamport’s Physical Clock
    - How should we handle individual clock drift between nodes?
    - Use arrows to indicate real time relationships (e.g. a->b means that a happened before b in terms of real time)
    - Physical clock conditions
        - PC1(bound on individual clock drift)
            - individual drifts are small
        - PC2 (bound on mutual drift)
            - differences between the drifts of individual clocks will be small
        - ![](/img/L05b_Lamport_Clocks_2.png)
    - IPC time and clock drift
		- To avoid anomalies:
		    - Disparity of mutual drift must not be longer than IPC time
		    - Amount of individual clock drift should be negligible compared to IPC time
		- ![](/img/L05b_Lamport_Clocks_3.png)
	