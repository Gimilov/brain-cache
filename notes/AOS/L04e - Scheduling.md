---
tags:
  - type/lecture
  - "#AOS"
---
Created: 2024-12-30 18:08
Source: [LINK](https://github.com/mohamedameen93/CS-6210-Advanced-Operating-Systems-Notes/blob/master/L04e.%20Scheduling.pdf)

## Introduction:

- How should the scheduler choose the next thread to run on the CPU?
  - First come first serve.
  - Highest static priority.
  - Highest dynamic priority.
  - Thread whose memory contents are in the CPU cache.

## Cache Affinity:
![[L04e_cache_affinity_scheduling.png]]

- If a thread ( $T_1$ ) is running on a particular CPU ( $P_1$ ), it’s recommended to run the next call of that thread on the same CPU.
  - The reason behind this is that ( $T_1$ ) is likely to find its working set in the caches of ( $P_1$ ), which in turn saves time.
  - This can be inefficient if another thread ( $T_2$ ) polluted the cache of ( $P_1$ ) between the two calls of ( $T_1$ ).

## Scheduling Policies:

### First come first serve (FCFS):
- The CPU scheduling depends on the order of arrival of the threads.
- This policy ignores affinity in favor of fairness.

### Fixed processor (Thread-centric):
- For the first run of a thread, the scheduler will pick a CPU and will always attach this thread to that CPU.
- Selecting the processors might depend on the CPU load.

### Last processor (Thread-centric):
- Each CPU will pick the same thread that used to run on it in the last operation cycle.
- This policy favors affinity.

### Minimum Intervening (MI) (Processor-centric):
- Save the affinity of each thread with respect to every processor.
- A thread ( $T_1$ )'s affinity is saved as an affinity index representing the number of threads that ran on the CPU between ( $T_1$ )'s different calls. The smaller the index, the higher the affinity.
- Whenever a processor is free, it will pick the thread with the highest affinity to its cache.
- **Limited Minimum Intervening**: If many processors are running on the system, keep only the affinity of the top few processors.

### Minimum Intervening + queue (Processor-centric):
- This policy considers both the affinity index and the number of threads in the queue of the CPU when making scheduling decisions.
![[L04e_minimum_intervening.png]]
## Scheduling Policies Summary:
![[L04e_scheduling_policies_summary.png]]

## Implementation Issues:

- The operating system should maintain a global queue containing all the threads available to all the CPUs. This queue will become very large if the system has many threads.
- To solve this issue, the OS would maintain local policy-based queues for every processor.
- A thread’s position in the queue is determined by its priority:
  - **Thread priority** = Base priority + thread age + affinity.
- If a specific processor runs out of threads, it will pull some threads from other processors.
![[L04e_implementation_issues.png]]

## Performance:

- **Throughput**: How many threads get executed and completed per unit time.  
  → *System-centric*.
- **Response time**: When a thread is started, how long it takes to complete execution.  
  → *User-centric*.
- **Variance**: Does the response time change over time?  
  → *User-centric*.
- When picking a scheduling policy, you need to pay attention to:
  - The load on each CPU.
  - To boost performance, a CPU might choose to stay idle until the thread with the highest affinity becomes available.
![[L04e_performance.png]]

## Cache Aware Scheduling:
![[L04e_cache_affinity_and_multicore.png]]
![[L04e_cache_aware_scheduling.png]]

- In a modern multicore system, we have multiple cores on a single processor, and the cores themselves are hardware multi-threaded (switching between the core’s threads based on latency).
- We need to ensure that all the threads on a specific core can find their contents in either the core’s L1 cache or, at most, the L2 cache.
- For each core, the OS schedules some cache frugal threads along with some cache hungry threads.  
  - This ensures that the amount of cache needed by all threads is less than the total size of the last-level cache of the CPU (e.g., L2).
- Determining if a thread is cache frugal or hungry can be done through system profiling, which introduces additional overhead.


## Conclusion (source: [link](https://github.com/audrey617/CS6210-Advanced-Operating-Systems-Notes/blob/main/L04_Parallel%20System.pdf))
Since it is well known that processes scheduling is NP-complete (nondeterministic
polynomial-time complete) we have to resort to heuristics to come up with good scheduling algorithms. the literature is ripe with such heuristics, as the workload changes, and the details of the parallel system, namely how many processors does it have, how many cores does it have, how many levels of caches does it have, and how are the caches organized. There's always a need for coming up with better heuristics. In other words, we've not seen the last word yet on scheduling algorithms for parallel systems.