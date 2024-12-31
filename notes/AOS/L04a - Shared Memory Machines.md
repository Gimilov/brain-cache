---
tags:
  - type/lecture
  - "#AOS"
---
Created: 2024-12-30 17:20
Source: [LINK](https://andrewrepp.com/aos_lec_L04)

# Shared Memory Machines

- Three structures:
    - In every structure there will be CPU’s, memory and an IC network.
        - Also, full address space of all memories accessible from any of the CPU’s
        - Also, cache associated with each CPU
    - Dance Hall Architecture
        - CPU’s on one side, memory on other, of an IC network
        - ![](/img/L04a_shared_memory_machines_1.png)
    - Symmetric Multiprocessor (SMP) Architecture
	    - Access time from any CPU to memory is the same
	    - ![](/img/L04a_shared_memory_machines_2.png)
	- Distributes Shared Memory (DSM) Architecture
		- A piece of memory associated with each CPU
		- Each CPU can still access all memory, but the piece that is closest will be fastest.
		- ![](/img/L04a_shared_memory_machines_3.png)
- Shared Memory and Caches
	- SMP example for simplicity
	- cache serves exact same purpose in multiprocessor as it does in uniprocessor
	    - CPU, when accessing memory, preferentially accesses cache. If cache miss, go to main memory, and add to cache.
	- Cache in MP associated with each CPU performs as it does in uniprocessor
	    - however there is a unique problem with an MP system – caches are unique to each CPU but memory is shared among them
	    - If a value is updated in one cache, but is outdated in other caches, what should happen? This is the “cache coherence problem”
	    - Hardware and software must agree on memory consistency model (developer using this system must know the rules the system is playing by to write correct software)
## Memory Consistency Model

- The model dictates what expectations the developer can have around ordering of memory reads and writes
- Example given is that the memory accesses on a given processor will always happen in the same order, but the interleaving across multiple processors is arbitrary
    - This is called Sequential Consistency (SC)
    - covered in more detail in [[P4L3 - Distributed Shared Memory]]
- Memory Consistency and Cache Coherence go hand in hand
    - Memory consistency: What is the model presented to the programmer?
    - Cache coherence: How is the system implementing the model in the presence of private caches?
## Hardware Cache Coherence

- If the hardware is going to handle this, there are two approaches possible
- Write invalidate
    - If a processor writes to a memory location in its own cache, the hardware will ensure that location is invalidated in all other caches
    - This is done by broadcasting a signal on the IC Bus, “invalidate memory location X”. This propagates, and caches are watching on the bus for this, and will handle it if seen
- Write update
    - If a processor writes to a memory location in its own cache, the hardware will ensure that location is updated to the new value on all other caches
    - Same propagation and cache snooping on Bus to accomplish this
- Both of these approaches do involve overhead, however. Further, this overhead grows with number of processes, and with complexity of interconnect medium
- So how does this scale? If you add more processors, does performance increase?
    - Pro in adding more processors is that it allows you to exploit parallelism
    - Con is the increased overhead discussed.
    - This flattens the scalability curve of adding processors to a system to increase performance.
    - ![](/img/L04a_hardware_cache_coherence.png)
- Honest solution is “don’t share memory across cores”, there’s always going to be some cost if you do.
    
- Synchronization
- Going to focus on sync algorithms
- Key for parallel programming.

