---
tags:
  - GIOS
  - type/lecture
Papers:
  - "[[Paper - P2L2 - Intro to Programming with Threads (Andrew D. Birrel)]]"
---
Created: 2024-08-29 11:09
# Lecture Notes

### Visual metaphor of a thread
A **thread** is like... a **a worker in a toy shop**.
![](/img/P2L2-thread-visual-metaphor.png)


### Process vs Thread
![](/img/P2L2-process-vs-thread.png)
A single thread of process is represented by its address space.  It will contain all the virtual-to-physical address mapping for the process (for its code, data, heap section files etc.). The process is also represented by its execution context (value of the registers, stack pointers, program counter etc.). OS represents all this information in PCB (Process Control Block).

Threads represent **multiple, independent execution contexts**. They are part of the same virtual address space so they share all of the virtual-to-physical address mappings (code, data files etc.). However, they will potentially execute different instructions, access different portions of the address space (or the input) and differ in other ways.  Thus, for each thread, they will have different data structures to represent this per-thread information (register values, stack pointers etc.). 

The OS representation of multi-threaded process will be a more complex PCB structure.


### Benefits of Multithreading
![](/img/P2L2-benefits-of-multithreading.png)
At any point of time, there may be multiple threads running for a single process, each running concurrently on a different processor. It may, for example,execute the same code, but the different subset of the input (i.e. different portion of input array or an input matrix).

Threads won't necessarily run exactly the same instructions at the given point of time. Thus, **they will keep a copy of the stack, registers, program counters, etc.**

1.  by **parallelization**, we obviously obtain **speed-up**
2. by **specialization** (threads being specific for a task), it results in differentiating how we manage those threads (higher/lower priority etc.). Also, it'll allow to **hit hot cache more often** (more state will be present in the cache, since the executed tasks will be smaller).

Why not just write a multi-process application for that? Since processes do not share an address space, we have to **allocate for every single one of these contexts an address space and execution context**! Thus, memory requirements, in this case on the image, are higher, as we'd need four separate **address spaces allocations** and **execution contexts allocations.** In contrast, a multi-threaded implementation results in threads **sharing an address space**, so we don't need to allocate memory for all of the address space information for these remaining execution contexts. **This implies it's more memory efficient.** As a result, an application is more likely to fit in memory and do not require as many swaps form disk compared to multi-processed alternative. Finally, passing data among process requires IPC mechanisms that are more costly. Thus,
3. efficiency $\to$ lower memory requirement & cheaper IPC (with inter-thread communication).
##### - Are Threads useful when there are more threads than CPUs?
![](/img/P2L2-t-idle.png)
- if $(t_{idle}) > 2 * (t_{\text{ctx\_switch}})$ , then context switch to **hide** idling time
- $t_{\text{ctx\_switch}}$ of threads < $t_{\text{ctx\_switch}}$ of processes, as one of the most costly steps during the context switch is the time that's required to create the new virtual-to-physical address mappings for the new process that will be scheduled. **Threads share the address space.**
- **hides latency**. For example with I/O operations, and this is useful even on a single CPU.

##### - Benefits to applications and OS code
![](/img/P2L2-benefits-applications-and-code.png)
While the benefits for applications have already been discussed, by multithreading the OS kernel, we allow OS to support multiple execution contexts (especially useful when there are multiple CPUs, so OS contexts can execute concurrently on different CPUs in a multi-processor, multi-core platform).

OS threads may run on behalf of different applications, or they may also run some OS-level services like certain daemons or device drivers.


### Basic Threads Mechanisms
What do we need to support threads?
- **thread data structure**
	- identify threads, keep track of resource usage...
- mechanisms to **create** and **manage** threads
- mechanisms to safely **coordinate** among threads running **concurrently** in the same address space.

![](/img/P2L2-threads-and-concurrency.png)
When **processes** run concurrently, they run in their own independent **address spaces**. OS with underlying hardware will make sure that **no access from one address space is allowed to be performed on memory that belongs to the another (or state that belongs to the other address space)**.

- For processes, no two virtual address (belonging to different processes) will be mapped to the same physical address. In other words, virtual memory of P2 will not be able to perform a valid access to physical address of P1. 
- Threads however, share the same physical address mappings, but data races may happen. 

To deal with these concurrency issues, we need some mechanisms for threads to execute in an exclusive manner. For this, we need **SYNCHRONIZATION MECHANISMS**:
- **MUTUAL EXCLUSION**
	- exclusive access to only one thread at a time. Remaining threads (that want to perform the same operation) will wait for their turn
	- **mutex** is used for this
- **WAITING** on other threads
	- specific conditions before proceeding
	- **condition variable** - instead of repeatedly checking if the remaining threads are done, it may just wait until it's explicitly notified to proceed. 
- **WAKING UP** other threads from a wait state.


### Thread Creation
![](/img/P2L2-thread-creation.png)**THREAD TYPE**
- thread data structure to contain all information about a thread .

**Fork(proc, args)**
- create a thread
- not UNIX fork  
- when it's called a thread data structure of thread type is created and is initialized so that its program counter will point to the first instruction of procedure *proc* and these *args* will be available on the stack of the thread.
- the process has now two threads. T0 will execute the next instruction after the fork() call, while T1 will start executing with the first instruction in *proc* and with specified *args*.

When T1 finishes with some kind of result, one solution could be to store that result in some well-defined address space location and you have some mechanisms to notify a parent that the result is available. However, we need some mechanism to determine that T1 is done and, if necessary, to retrieve its results or at least to determine the status of the computation (success/error etc.).

To deal with this issue, Birrel proposes a mechanism called **Join()**.
**Join(thread)**
- terminate a thread
- when a parent calls it, it will be blocked until child completes. Join() will return to the parent the result of the child's computation. At that point, a child for real exits the system and any allocated data structure, state, all of the resources allocated for its execution will be free and the child is terminated.  

Apart from these calls, T0 is exactly the same as T1. They can all access the resources available to the process as a whole and share them. It's true both with respect to hardware resources (CPU memory etc) or actual state within the process.
##### Thread creation example
![](/img/P2L2-thread-creation-example.png)

### Mutexes
##### How is the list updated?
![](/img/P2L2-linkedlist-example.png)
In here, we consider a linked list where we try to insert new element. Without mutex, two different thread executing this procedure may result in two list elements pointing to NULL, while only one of them is successfully referenced by the head element. 

##### Mutual Exclusion
![](/img/P2L2-mutual-exclusion.png)
We mentioned the danger in the previous example of parent and child trying to update the same list, potentially overriding the list elements. Thus, there's a need for mutual exclusion mechanism among the execution of concurrent threads.

To do this, OS and threading libraries in general support a construct called **MUTEX**. It is like a lock that should be used whenever accessing data/state that's shared among threads. 
- when a thread locks mutex , it has exclusive access to the shared resources. 
- other threads attempting to lock the same mutex are not going to be successful
- we also use the term "**acquire** the lock" or "**acquire** the mutex" to refer to this operation 
- these "unsuccessful" threads will be blocked on the lock operation, that is they will be suspended until the **mutex owner (lock holder)** releases it
- thus, as a data structure, a mutex should at least contain information about its **status** (is it locked or free?), and have some type of list of **all the threads that are blocked on the mutex and are waiting for it to be free**. Another common element of thus data structure is to maintain some information about the owner of the mutex (who currently has the lock?). 
- The portion of the lock protected by a mutex is called a **critical section**.

Even though we use Birrel's Lock API (where critical section is enclosed in curly braces and the mutex is released when leaving the curly brackets), in Common Thread API the equivalent is lock(m) and unlock(m).

##### Mutex Example
Recall the example above, and here's the solution:
![](/img/P2L2-mutex-example.png)

##### Producer/Consumer Example
What if the processing that we wish to perform with **mutual exclusion** needs to occur only under certain **conditions?** 
![](/img/P2L2-producer-consumer-example.png)
![](/img/P2L2-producer-consumer-example-2.png)
It's sub-optimal since the consumer as print_and_clear rechecks if it should print and clear the list. To solve for this, we'll need **condition variables**.

##### Condition Variable
![](/img/P2L2-condition-variable.png)
 Now, when the producer inserts an element and checks if the list is full, it may send a signal to the waiting thread (consumer) by using *Signal()*. A consumer suspends itself when the list is not full and just waits for the signal. 
 
 Note that when the thread holds the mutex and **calls Wait(), it has to release the mutex**, since the only way for the underlying list to be changed is to have safe_insert go and lock that mutex to add an element.
 
 In summary, wait stipulates the mutex and the conditional variable it will wait on. The mutex is re-acquired by the consumer when it leaves the waiting state.

##### Condition Variable API
![](/img/P2L2-condition-variable-api.png)
It must be able to:
- **create data structures** that corresponds to the condition variable (list of waiting threads, reference to the mutex etc.).
- **Wait(mutex, cond)**
	- mutex is automatically released & re-acquired on wait
- **Signal(cond)**
	- notify only one thread waiting on condition
- **Broadcast(cond)**
	- notify all waiting threads

##### Reader/Writer Problem
![](/img/P2L2-readers-writer-problem.png)
At any point of time 0 or more reader threads can access a resource while only 0 or 1 write threads can access the same resource.

Naively we could simply lock the resource. It would be okay for the writer, but not for the readers (since only one could access it at the time).

A better solution would be tracking the number of active readers and writers (left-side of the image). Given these statements, we could represent the **state in which the shared file/resource is in** (right-side of the image above). 

There's a saying in CS that all problems can be solved with one level of indirection. The "resource_counter" variable is basically a proxy resource (variable).  It reflects the state that the resource is in. Instead of controlling the file, we will control who has access to update that "resource_counter" variable. This way,  we could use a mutex to control how this variable is accessed and that way monitor, control, and coordinate among the different accesses that we actually want to allow in the shared file.

##### Reader/Writer Example
![](/img/P2L2-reader-writer-example-1.png)


##### Critical Section Structure
Basically, the code above has critical section, obviously, within the Lock statements. However, it can be perceived as the `//... read data ...` is the actual critical section of these blocks (same goes for `// ... write data ...` ).  Namely:
![](/img/P2L2-reader-writer-critical-section.png)

Nevertheless, the typical Lock(mutex) block looks as follows (in pseudocode):
``` c
Lock(mutex) {
	while(!predicate_indicating_access_ok)
		wait(mutex, cond_var)
	update state => update predicate
	signal and/or broadcast
		(cond_var_with_correct_waiting_threads)
} // unlock
```


##### Critical Section Structure with Proxy Variable
![](/img/P2L2-critical-section-structure-with-proxy-var.png)
Such structure allow us to achieve more complicated logic (like multiple readers, single writer) that would be otherwise impossible with just plain simple mutex mechanisms.

### Avoiding Common Pitfalls
 1. keep track of mutex/cond.variables used with a resource
	 - e.g., `mutex_type m1; // mutex for a file1`
2. check that you are always (and correctly) using lock & unlock.  
	- e.g., did you forget to lock/unlock? What about complilers (they may generate warnings)?
3. use a single mutex to access a single resource!
4. check that you are signaling a correct condition.
5. check that you are not using signal when broadcast is needed
	- signal: only 1 thread will proceed... remaining threads will continue to wait... **possibly indefinitely!!!**
6. ask yourself: do you need priority guarantees?
	- thread execution order not controlled by signals to condition variables
7. **spurious wake ups**
8. **dead locks**


### Spurious Wake Ups
![](/img/P2L2-spurious-wakeups.png)
If the unlock happens after the **broadcast/signal**, then **no other thread can get lock!** Thus, spurious wake-ups happen when we wake threads up knowing they may not be able to proceed. In case of image above, the queue shifted from `read_phase` to `counter_mutex`. Though it will still execute correctly, there is a redundant cost of scheduling their execution just to be put on waiting queue again.

Could we unlock the mutex before broadcast/signal? In some cases, we can, as shown here:
``` c
// OLD WRITER
Lock(counter_mutex) {
	resource_counter = 0;
	Broadcast(read_phase);
	Signal(write_phase);
} // unlock;

// NEW WRITER
Lock(counter_mutex) {
	resource_counter = 0;
} // unlock
Broadcast(read_phase);
Signal(write_phase);
```
In other cases, however, it'd not be possible, as here:
```c
// IN READERS
Lock(counter_mutex) {
	resource_counter--;
	if(resource_counter == 0)
		Signal(write_phase);
} // unlock;
``` 
... since the signal operation is embedded in the `if` clause.


### Deadlocks 
Definition: `Two or more competing threads are waiting on each other to complete, but none of them ever do.` 

![](/img/P2L2-deadlock.png)
Okay, but how to avoid this?

1. Unlock A before locking B
	- results in **fine-grained locking** 
	- but **IT WON'T WORK** in this case as the threads need both A & B
2. Get all locks upfront, then release at the end. Alternatively, use one MEGA lock.
	- it'd be okay for some applications (+)
	- but in general, it'd be **too restrictive => limits parallelism!** (-)
3. **The most widely accepted solution is to MAINTAIN LOCK ORDER**.
	- first `m_A` 
	- then `m_B` 
	- it'll prevent cycles in wait graph (+)
	- it'll result in the following:
![](/img/P2L2-deadlock-lock-order.png)
- as a technique, it is foolproof. The only concern is the head-ache when making sure the order is preserved when many threads and shared variables/resources are in play.

In summary, a cycle in the wait graph is **necessary** and **sufficient** for a deadlock to occur. This graph has edges from thread waiting on a resource to thread owning a resource. What can we do about it?
- **deadlock prevention** - every time a thread is going to issue request for a lock, we need to see if that operation will cause a cycle in this graph. If so, we must somehow delay this operation, or we may even change some code so that the thread first releases some resources and then it tries to perform that lock request. As we can see, it is **EXPENSIVE**.
-  **deadlock detection and recovery** - we analyze if any cycles have occurred in the graph and recover from them. It may not be as bad as monitoring and analyzing every single lock request to see whether it will cause future deadlocks, but it's still expensive as it requires us to have ability to **ROLLBACK** the execution, so we can recover. Moreover, it's only possible if we've maintained enough state during the execution so that we can figure out how to recover. Sometimes, it's not even possible to do a rollback, since some operations may require I/O so that we don't have ways to roll back their execution.
- **apply the Ostrich Algorithm... DO NOTHING!** Just hope for the best, and that deadlock will not happen!

IF ALL ELSE FAILS... JUST REBOOT.


### Kernel vs User-level Threads
![](/img/P2L2-kernel-user-level-threads.png)
Kernel-level threads imply that OS itself is multi-threaded. These are visible to the kernel, and are managed by kernel-level components like the kernel-level scheduler. So it's a OS scheduler that will decide how these kernel-level threads will be mapped onto the underlying physical CPUs, and which one of them will execute at any given point of time. Some of these threads may be there to directly support some of the processes, so they may execute some of the user-level threads, and other kernel-level threads may be there just to run certain OS-level services, like daemons.

At the user-level, the processes themselves are multi-threaded and these are the user-level threads. For an user-level thread to actually execute, first, it must be associated with a kernel-level thread, and then OS-level scheduler must schedule that kernel-level thread onto a CPU.  

What's the relationship between the user- and kernel-level threads? We'll see below.

### Multithreading Models
- ##### One-to-One Model:
![](/img/P2L2-one-to-one-model.png)
Here, each user-level thread has a kernel-level thread associated with it. When a user process creates a new user-level thread, there is a kernel-level thread that either is created or there's available kernel-level thread, then a kernel-level thread is associated with the user-level thread. 
`(+)` **OS sees/understands threads, synchronization, blocking.** Since the OS already supports multi-threading, user-level processes can directly benefit from the threading support that's available in the kernel
`(-)` **must go to OS for all operations (may be expensive)**
`(-)` **OS may have limits on policies, thread #**. Since we are relying on the kernel to do the thread-level management (synchronization, scheduling etc.), we're limited by the policies that are already supported at the kernel level.
`(-)` **portability**. We are limited to running only on the kernels that provide exactly that same support (see $\uparrow$ )

- ##### Many-to-One Model:
![](/img/P2L2-many-to-one-model.png)
Here, all of the user-level threads are supported (or mapped) to a single kernel-level thread. It means that at the user-level there's a thread management library that decides which one of the user-level threads will be mapped onto the kernel-level thread at any given point of time. That user-level thread will run only once the kernel-level thread is actually scheduled on the CPU. 
`(+)` **totally portable, doesn't depend on OS limits and policies** as everything is done at the user-level thread library (scheduling, synchronization etc.).  We don't have to make system calls and we don't have to rely on the user-kernel transitions in order to make decisions regarding scheduling, synchronization, blocking etc. 
`(-)` **OS has no insights into application needs**. It doesn't even know that the process is multi-threaded.
`(-)` **OS may block entire process if one user-level thread blocks on I/O**. Since all the OS sees is the kernel-level thread, it may block the entire process if one user-level thread waits on something (like I/O).

- ##### Many-to-Many Model:
![](/img/P2L2-many-to-many-model.png)
`(+)` **can be best of both worlds.** The kernel knows that the process is multi-threaded since it has assigned multiple threads to it. Even if one of the user-level thread blocks on I/o and as a result the kernel-level thread is blocked as well, the process overall will have other kernel-level threads onto which the remaining user-level threads will be scheduled.
`(+)` **can have bound or unbound threads**. The user-level threads may be scheduled on any of the underlying kernel-level threads (UNBOUND), or we can have a certain user-level thread that's basically mapped one-to-one permanently onto a kernel-level thread (BOUND). The bound mapping is just another benefit of this model (for example a separate thread for I/O interface).
`(-)` **requires coordination between user- and kernel-level thread managers**.  In one-to-one model everything was up to kernel-level thread manager, while for many-to-one model it was all up to the user-level manager. In many-to-many model it is often the case that we require certain coordination between the kernel- and user-level managers (mostly) to take advantage of some performance opportunities.


### Scope of Multi-threading
There are different levels at which multi-threading is supported, at the **entire system** or **within a process**. Each level affects the scope of the thread management system. 
1. **System Scope (kernel-level)**
	- System-wide thread management by OS-level thread managers (e.g., CPU scheduler)  
	- looks at entire platforms when making decisions as how to allocate resources to the threads
2. **Process Scope (user-level)**
	- User-level library manages threads within a single process
	- Different processes will be managed by different instances of the same library or even different processes may link entirely different user-level libraries
##### Example
- Process scope:
![](/img/P2L2-process-scope-threads.png)
If `webserver` has twice the number of threads that `database` has, the OS doesn't see all of them. Thus, at the OS-level, the available resources will be (maybe) managed 50/50 among the two different processes. In this way, both processes will be allocated equal share of the kernel-level threads (so 2 for each).  Then, the OS-level scheduler will manage these threads by splitting the underlying CPUs among them. The end result of this, however, is that the `webserver`'s user level threads will have half of the amount of the CPU cycles that's allocated to the `database` threads.
- System score:
![](/img/P2L2-system-scope-threads.png)
Here, all user-level threads will be visible at the kernel-level. Thus, kernel will allocate to every one of its kernel-level threads and, therefore, to every one of the user-level threads across the two applications, an equal portion of the CPU (if that happens to be a policy that the kernel implements).  If `webserver` happens to use more user-level threads, it will receive a larger share of underlying physical resources, since every one of its user-level threads will get equal share of the physical resources as the user-level threads in the other process. 


### Multi-threading patterns
We move forward with a visual metaphor of toy-shop. For each wooden toy order, we...
1. accept the order
2. parse the order
3. cut wooden parts
4. paint and add decorations
5. assemble the wooden toys
6. ship the order

### 1. Boss-Workers Pattern
![](/img/P2L2-boss-workers-pattern.png)
- **boss**: assigns work to workers
- **worker:** performs entire task
A throughput of the system is limited by boss thread $\to$ must keep boss efficient. $$
Throughput = \frac{1}{\text{boss\_time\_per\_order}}
$$But how? 
1. Boss assigns work by directly signalling a specific worker:
	- boss needs to keep track of workers, potentially waiting for a particular worker to accept the order 
	- `(+)` workers don't need to synchronize, as boss tells them what to do
	- `(-)` boss must track what each worker is doing
	- `(-)` throughput will go down!
2. Boss assigns work by placing work in **producer/consumer queue**:
   ![](/img/P2L2-boss-workers-pattern-queue.png)
	- boss is the only producer, and the workers are consumers picking up work from the queue and proceed to do the work they're supposed to perform
	- `(+)` boss doesn't need to know details about workers
	- `(-)` queue synchronization. All of the workers may contend to gain access to the front of the queue, and any one work item can only be assigned to one worker thread. Also, worker and the boss may need to synchronize when they need to compare the front and the end pointer of this queue, for instance, when they need to determine that a queue is full or that a queue is empty.
	-   this patters is more desired since it results in higher throughput as boss needs less time to spend on processing a single order.

##### How many workers for Boss-Workers pattern?
What if the producer/consumer queue is full? Well, then the boss has to wait, and it's inefficient - the throughput will go down! Clearly, adding more threads would help, but adding arbitrarily more threads to the systems will incur other overheads in the system. So, how many workers?
1. **on demand** - whenever we have yet another order, we go and call yet another worker to join the crew (thread).
	- It is clearly inefficient if we have to wait a long time for a worker to arrive.
2. **pool of workers**  - more common and efficient - a pool of workers that is created upfront.
	- we don't need to wait for a new thread to be created every single time we start seeing that order start piling up on the queue.
	-  how do we know how many workers to create up-front? See the next suggestion.
3. **static vs. dynamic** - use the **pool of workers** model, but as opposed to deciding statically what the size of the pool should be, allow the pool to be dynamically increased in size. 
	- this tends to be the most effective approach in the managing of threads in the boss-workers pattern.

##### Summary of Boss-Workers:
- boss: assigns work to workers
- worker: performs entire task
- boss-workers communicate via producer/consumer queue
- worker poo: static or dynamic
`(+)` simplicity
`(-)` thread pool management
`(-)` locality. The boss doesn't keep track of what the worker was doing last (more rare hot caches).

##### Variants of Boss-Workers Pattern
1. all workers created equal ($\uparrow$)
vs.
2. workers specialized for certain tasks
   - now the boss has a little bit more work to do since it also has to look at the work and decide which set of workers should it be passed to. 
   - `(+)` - **better locality**, more hot cache hits, **better QoS (Quality of Service) management** (i.e. assign more threads to tasks where we need higher quality of service).
   - `(-)` - **load balancing** - how many threads should we assign to different tasks?


### 2. Pipeline Pattern
![](/img/P2L2-pipeline-pattern.png)
Here, the overall task is divided into sub-tasks, and each of the sub-tasks is performed by a separate thread.
- threads assigned one sub-task in the system
- entire tasks == pipeline of threads
- multiple tasks, concurrently in the system, in different pipeline stages
- throughput == weakest link (longest stage in the pipeline) 
	- => pipeline stage == thread pool. If one of the pipeline stages take more amount of time longer, then we can assign multiple threads to this particular stage
- shared-buffer based communication between stages (similar to producer/consumer pattern). It helps preventing the particular stages to wait for the next ones. Think of it as putting the results on the drawer instead of waiting for the next worker to pick it up.  
- `(+)` - specialization and locality
- `(-)` - balancing and synchronization overheads


### 3. Layered Pattern
![](/img/P2L2-layered-pattern.png)
**LAYERED:**
- each layer group of related subtasks. Threads assigned to a layer can perform any one of sub-tasks that correspond to it.
- end-to-end task must pass up and down through all layers. Unlike pipeline pattern, we must be able to go in both directions across the stages 
- `(+)` specialization and locality
- `(+)` less fine-grained than pipeline. It may thus become easier to decide how many threads should we allocate per layer.
- `(-)` not suitable for all applications since not for all apps it may make sense for the first layer to group first and last steps of the process.  
- `(-)` synchronization (even more problematic than before). Every layer has to coordinate with both the layer below and above to both receive inputs as well as pass results.