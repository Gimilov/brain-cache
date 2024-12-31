---
tags:
  - type/lecture
  - "#AOS"
---
Created: 2024-12-30 19:01
Source: [LINK](https://andrewrepp.com/aos_lec_L05)

## Latency Limits

- Given that network communication is the limiting factor for performance in distributed systems, the OS must strive hard to reduce the latency incurred in the system software for networked services
- Latency == elapsed time
- Throughput == events per unit of time
    - Bandwidth is a common measure of throughput
- RPC Performance
    - RPC is the basis for client-server based distributed systems
    - Two components to latency
        - Hardware overhead
            - Dependent on how the network is interfaced to the computer
            - Moving the bits from the memory to the node to the network controller. Usually accomplished using direct memory access (DMA)
                - There are some other types where the CPU steps in, too, but this is uncommon in modern systems
            - Then out onto the wire, where network bandwidth comes into play
            - ![](/img/L05c_latency_limits_1.png)
        - Software overhead
    - What the OS tacks on to the hardware overhead
    - Incurred to make message available in memory for transmission
- Latency as a whole is software + hardware overheads
- Focus of this lesson is how to reduce the software overhead to reduce latency
### Components of RPC Latency
- ![](/img/L05c_latency_limits_2.png)
	- Client call
    - client has to set up arguments for procedure call, and trap into kernel
    - kernel validates and then marshalls the arguments into a network packet.
    - kernel sets up controller to do the network transaction.
        1. Controller latency
    - Controller must DMA message into its buffer, and then put it out on the wire. Done in hardware.
        1. Time on wire
    - Depends on distance between client and server and on bandwidth. Limiting factor is the speed of light.
        1. Interrupt handling
    - Message arrives at destination node, as an interrupt. This must be handled by the OS.
    - Move bits from wire to controller buffer to memory.
        1. Server setup to execute call
    - Locate server procedure, dispatch server procedure, unmarshall network packet as arguments for call.
    - Actually execute the call.
        1. Server execution and reply
    - Not really under the control of the OS. Whatever the server does, it does.
- Controller latency again (omitted in numbering)
    - equivalent to step 2.
- Time on wire back (omitted in numbering)
    - equivalent to step 3, travel time on network
- Interrupt handling again (omitted in numbering)
    - equivalent to step 4
        1. Client setup to receive results and restart
    - Dispatch client. This again is really not under the control of the OS, all about how the client is implemented and what it’s doing.

### Sources of overhead in RPC

- Marshalling and data copying
    - Marshalling refers to semantics of RPC call being made is something that the OS knows nothing about. Arguments actually passed have semantic meaning only between the client and server.
    - Marshalling == accumulate all arguments from the call and make one contiguous network packet out of it.
    - Biggest source of overhead in marshalling is copying. Copying happens 3 times.
        1. Client stub takes arguments of the call from the stack and convert into contiguous sequence of bytes called an RPC message.
        2. Client is a user program, so RPC message must be copied into a kernel buffer in kernel space.
        3. Now the data must be copied by network controller out onto the wire using DMA
    - How can this be reduced?
        - Third copy via DMA is a hardware action and therefore unavoidable (at least from our OS perspective)
        - We could marshal into the kernel buffer directly, avoiding the second data copy
            - This would require allowing the client stub to work directly with kernel memory.
            - This means the stub would be installed directly inside the kernel at bind time. This is concerning, of course, as installing code into the kernel is a big risk.
        - Alternatively, have a structured mechanism for communication between client stub and the kernel
            - This might be a shared descriptor, where each entry is an argument for the rpc call.
            - Kernel doesn’t need to know what each entry is, just starting position and length.
- Control transfer
    - The context switches that have to happen in order to effect an RPC call and return
    - Potentially 4 context switches
        1. client makes call out to network via kernel to request from server
            - can be overlapped with network communication while rpc call is in transmission on the wire
        2. server makes call in from network via kernel to receive from client
            - this is in critical path of latency
        3. server makes call out to network via kernel to respond to client
            - can be overlapped with network communication while rpc call is in transmission on the wire
        4. client makes call back in from network via kernel to receive from kernel
            - this is in critical path of latency
    - Can latency be reduced down to 1 switch?
        - First switch may be unnecessary if time of network transit and server process is very short, and so client box would only be blocked for a short time and does not need to be switched away from.
            - Spin instead of switch
        - Then the only context switch is on server (switch 2) and so there’s only one switch that actually affects latency of RPC call
- Protocol processing
    - What transport should be used for RPC?
    - Latency and reliability are competing priorities.
    - If we are working on a LAN, then that is reliable so we should focus on reducing latency.
    - Choices for reducing latency in transport
        - No low-level ACKs
            - messages not going to get lost on a LAN, presumably. Result itself can serve as an ACK
        - Hardware checksum for packet integrity
            - A message is unlikely to be corrupted on a LAN, so checksums will not be needed to confirm message validity. Save the time spent calculating and comparing checksums in software, the hardware checksums will be sufficient.
        - No client side buffering since client is blocked
            - Do not need to buffer message if on a reliable LAN, as retransmission due to message loss is unlikely. In case of message loss, can reconstruct and re-send the call.
        - Overlap server-side buffering with result transmission
            - As above, message loss is unlikely but possible, so buffering on server side to avoid needing to reproduce the result is still a worthwhile precaution (processing is far more expensive than constructing the call so the penalty for message loss on the server->client trip is higher).
            - However, this can be done while message is in transit, overlapping to reduce latency.
- How to reduce kernel overhead
    - “Take what hardware gives you” to reduce latency
