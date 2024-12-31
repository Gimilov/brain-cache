---
tags:
  - type/lecture
  - "#AOS"
---
Created: 2024-12-30 17:30
Source: [LINK](https://andrewrepp.com/aos_lec_L04)

# Synchronization
## Locks

- Protects shared data structures from multiple threads. Allows thread to make sure that when accessing shared data, it is not being interfered with
- Two kinds:
    - Exclusive lock: mutex, one thread at a time
    - Shared lock: multiple threads can access data at same time
        - e.g. multiple readers, single write

## Barriers

- Multiple threads all doing computation, but on reaching a given point wait for every other thread to reach that before proceeding
- Analogy is waiting at a restaurant for your entire party before you can be seated

## Read/Write to Implement a Mutex

- Example is given where process2 wants to use a struct, but wants to wait until it’s done being modified by process1. The question is posed as to whether this is possible given only read/write atomics available.
    - The answer is yes, as a simple flag variable can serve, with each process checking the flag, and updating it to 0/1 to signal the other.

## Atomic Operations

- Instructions needed to implement a mutex
- Lock/Unlock operations displayed here, using simple flag, if/while ops
- The challenge though is that read and write group for the lock check need to happen at once – be atomic
- so, we need a new Read/Modify/Write (RMW) semantic, a new atomic instruction
    - Test_and_set instruction takes a memory location as input, returns current value in that memory location, and sets that location to desired value (1 in this example). Atomically!
    - Fetch_and_inc takes a memory location as input, returns current value in that location, and increments the value in that location. Atomically!
    - Generically the above are referred to as “Fetch_and_Phi”. There are many similar such instructions.

## Scalability Issues with Synchronization

- Sources of inefficiencies are:
    - Latency: time spent by thread in acquiring a lock
    - Waiting time: how long must you wait to get a lock (partially a function of whatever use pattern the application has, OS can’t do much here)
    - Contention: when lock is released, how long does it take, in presence of contention, for one thread to get lock and the others to stop trying to acquire

## Naive Spinlock (Spin on Test and Set)
![](/img/L04a_naive_spinlock_spinning_on_test_and_set.png)
- rocessor will spin waiting to get lock
- initialize lock to unlocked
- spin on T+S atomic instruction

### Problems with this approach

- too much contention – all threads go after lock when released even though only one can get
- does not exploit caches – spinning on an atomic goes to main memory every single iteration
- disrupts useful work – when a processor acquires the lock it wants to continue doing work, but the IC contention from other processors vying for lock reduces effectiveness of the winner

## Caching Spinlock (Spin on Read)
![](/img/P04a_caching_spinlock_spinning_on_read.png)
- Spin on cached value of lock (leverage cache coherence of architecture to ensure other caches also see correct value of lock)

### Problems with this approach
- too much contention – when cached lock value changes, every CPU hits bus all at once, floods the bus
- disrupts useful work – same issues as Spin on Test and Set

## Spinlock with Delay
- on lock release, delay a while before vying for lock

### Two alternatives
- Delay after lock release
- ![](/img/L04a_spinlock_with_delay_1.png)
-  delay chosen differently for each processor, so even though all see the lock value change at once, only one will go check it
    - this is a static delay, though, so you will waste time on longer-delayed processors

- Delay with exponential backoff
- ![](/img/L04a_spinlock_with_delay_2.png)
- initial value of delay is small, but if lock is not free when check, increase value exponentially
- this allows contention to be managed, as more contention will result in longer delays, reducing contention on future rounds of checking
- This works even on NCC architectures as we are always checking with T+S, thus not relying on cache values being kept in agreement with each other

## Ticket Lock

- Above solutions to do not consider “fairness”, only latency and contention.
- Should we not try to give lock to the process that requested it first?
- ![](/img/L04a_ticket_lock.png)
- check lock after appropriate delay, estimated by difference between “my_ticket” and “now_serving”
- Achieves fairness, but still have issues with contention when lock is released

## Spinlock Summary

- Read & T+S & T+S with Delay: no fairness
- Ticket Lock: fair but still has problems with contention

## Array-based Queuing Lock (Anderson’s Lock)
![](/img/P04a_array_based_queueing_lock.png)
- array of flags associated with each lock – size of array is number of processes
- array serves as circular queue
- each element in flag array is either “has-lock” (hl) or “must-wait” (mw) state (obvious what those indicate)
- only one processor can be in hl state
- initialize array by marking one slot as hl and all others as mw
- slots are not statically associated with any one processor, dynamically populated as request comes in. enough spaces that there’s one available per processor, but not static.
- circular queue means you must keep track of where the end is, as future requests will loop around to beginning of queue1:w
- Addresses contention by virtue of unlock function handing access to next position in the queue. Also by having each lock requester spinning on its own variable (array slot flag).
- Addresses fairness by iterating through the queue addressing requests in the order received
- In situation where there is a small subset of processors requesting this lock, the array is unnecessarily large and so wastes space. This is the only downside to this approach.

## Linked List-based Queuing Lock
![](/img/P04a_linked_list_based_queueing_lock.png)
- To avoid space complexity in Anderson Lock, we will use a linked list instead of an array for the queue
- Sometimes referred to as MCS lock based on authors
- Every lock starts with a dummy node to indicate no lock requesters
    - dummy node has one member: a pointer “l”, to indicate last_requester
- Every node object will have two fields, “got it” and “next’
    - got_it is a boolean
    - next_is a successor
- Queue means that fairness is assured, same as Anderson lock
- next_is being set to null indicates no requesters waiting for the lock
- nodes/processors spin on got_it field, unlock sets next_is node to true breaking its spin
- joining queue requires atomic fetch_and_store of node pointer into next_is field of appropriate predecessor, and to last_requester field of dummy node
    - obviously most (all?) architectures will not have fetch_and_store, so you must simulate with test_and_set
- in special case when there is no successor to currently running process, last_requester on dummy node is set to null to indicate nobody holds the lock
    - new requests arriving while this is happening can run into a race condition where last_requester is set to new request but next_is on currently running process is null, and then currently running process sets last_requester to null, effectively erasing the new request from the waiting process
    - solution here is for currently running process to atomically comp_and_swap last_requester on dummy node, such that it will set last_requester to null only if last_requester is still pointing to current process node. This means that it cannot overwrite the new requests pointer
        - comp_and_swap may also need to be simulated with test_and_set if it isn’t available on target architecture
        - if comp_and_swap fails it returns false. in this circumstance the current process will spin on its next_is member being null, waiting for the new request to finish forming to unlock and hand the lock over to the new process
- This has all the benefits of the array-based queuing lock, with the addition of wasting less space in circumstances where there are far fewer requesters than processors on average.
- Downside is some increased overhead around linked-list maintenance. So while it’s smaller than Anderson’s lock, it’s often also slower
    - both Anderson’s Lock and this lock also both take a hit if the architecture doesn’t support the more exotic atomics and you’re stuck simulating with test_and_set

## Summary of Lock Performance
![](/img/L04a_summary_of_lock_performance.png)
