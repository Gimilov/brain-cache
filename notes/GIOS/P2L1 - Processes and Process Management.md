---
tags:
  - GIOS
  - type/lecture
---
Created: 2024-08-26 17:13
# Lecture Notes

A **process** is an instance of an executing program and is synonymous to "task" or "job". It is like an order of toys:
- **state of execution**:
	- **PROCESS:**
		- program counter, stack
	- **ORDER OF TOYS:**
		- completed toys, waiting to be built
- **parts & temporary holding area**:
	- **PROCESS:**
		- data, register state occupies state in memory
	- **ORDER OF TOYS:**
		- plastic pieces, containers
- **may require special hardware**:
	- **PROCESS:**
		- I/O devices
	- **ORDER OF TOYS**:
		- sewing machine, glue gun


### What is a process?
![[P2L1-process.png]]
OS manages hardware on behalf of applications. An application is some program on disk or flash memory (i.e, it's a static entity). A **process**, however, is a state of a program when executing and loaded in memory (i.e. it's an active entity).

If the same program is launched more than once then multiple processes will be created. They will be executing the same program, but have different states. For example, if you had two Word files opened, then you have two instances created (i.e., two processes). Thus, a **process** represents the execution state of an **active** application - it doesn't necessarily mean that it's running, it may be waiting for input or for some other process to finish. 



### What does a process look like?
![[P2L1-process-look.png]]
A process encapsulates all of this data of running application (the code, the data, all the variables that application needs to allocate). Every single element has to be uniquely identified by its address - thus OS abstraction used to encapsulate of all the process state is an **address space**. The range of these addresses are defined to be from $V_0$ to $V_{max}$ . It includes the following types of state:
- **text and data**:
	- static state when process first loads
- **heap**
	- dynamically created during execution. The process dynamically creates some state (allocates memory, stores temp results, reads data from files). It may have holes in it, or even inaccessible memory. 
- **stack**:
	- grows and shrinks according to LIFO queue. If we execute a particular portion of the process (X) and we need to call some procedure to jump to some other part of the address space (Y). The state is saved at that point (before the call) and then it will be restored when we come back from the execution of Y.


### Process Address Space and Memory Management
![[P2L1-process-address.png]]
As we mentioned, **address space** is an "in memory" representation of a process. These are called **virtual**, because they do not have to correspond to physical memory (i.e., DRAM). Instead, memory management hardware and OS components responsible for memory management like page tables make a mapping between virtual addresses and physical addresses. It's completely decoupled and it allows to keep physical memory management simple, and not dictated by data layout of processes that are executed.

![[P2L1-process-address-2.png]]
Not all  processes require entire entire address space from $V_0$ to $V_{max}$ (there may be portions of this address space that is not allocated). Also, we may not have enough physical memory to store all this state even if we need it (32bits $\to$ 4GB).

OS dynamically decides what portion of which address space will be present where in physical memory.
-  P1 and P2 may share memory like in the image above.
	- some portions of address space may be swapped temporarily on disc. It'll be brought in whenever it's needed and perhaps it may cost some other parts of P1 of P2 to be swapped to disc (to make room).
	- OS must maintain information where these virtual addresses actually are (memory, disc), since it maintains the mapping between the virtual addresses and physical location of every part of the process address space.



### Process Execution State
![[P2L1-how-does-OS-know-process.png]]
For OS to manage processes, it has to has to have some idea what they are doing. If it stops the process, it must know what it was doing when it was stopped, so it can be restarted from the exact same point.

Before applications are execute, its source code must be compiled, and binaries are produced (which do not have to be executed sequentially - jumps, loops, interrupts).
- **program counter** (PC)- at any point the CPU must know where in these instructions (binaries) sequence the process currently is
- **CPU registers** - PC is maintained on CPU while process is executing in the register and there are other registers that are maintained on the CPU. These hold values necessary during the execution. They may have information like addresses for data, status information that effects the execution of the sequence etc.
- **stack pointer** - process stack, the top of this stack is defined by the stack pointer. Whatever item is the last one to come on top of the stack needs to be the very first item to retrieve from this stack.
- ... there are other, to help OS know what a process is doing at a given time. 
To maintain all the information about it, for every single process, OS maintains **Process Control Block (PCB).** 



### Process Control Block
![[P2L1-PCB.png]]
It's a data structure that OS maintains for every one of processes that it manages. 
- It is created when a process initially created itself, and it's also initialized at that time (i.e., program counter set to point to the very first instruction in this process). 
- Certain fields are updated when process state changes. For example, when a process request more memory, OS will allocate more memory and will establish new valid virtual-to-physical memory mapping for this process (this will reflect memory limits information, valid virtual address regions for this process etc.)
- Other fields change too frequently, just like program counter that updates each instruction. Since we don't want OS for every instruction to spend time to write new value to PCB program counter. Instead, the CPU has a dedicated register that it uses to track the current program counter for the currently executed process. This PC register will get automatically updated by CPU on every new instruction.
It's OS job to make sure to collect and save all information that CPU tracks for a process and to store it in a PCB structure, whenever the process is no longer running on the CPU.



### How is PCB used?
![[P2L1-PCB-usage.png]]
Let's assume OS manages two processes: P1 and P2. It has already created them, and their PCB_P1, PCB_P2 are stored somewhere in the memory.
- When, initially, P1 is running, then the CPU registers will hold the values that correspond to the state of P1, so they will need to be stored in PCB_P1.  
- At some point OS decides to interrupt P1 and it becomes idle. All the state information regarding P1 (including registers) into the PCB_P1.  Next, the OS must restore the state of P2. It has to update CPU registers with values corresponding to PCB_P2.
- If P2 needs some more memory, it can make a request (i.e., malloc) and OS will allocate that memory and establish new virtual-to-physical memory mapping and update, as appropriate, PSB_P2. 
- When P2 is done executing or OS interrupts it, it goes the same as P1 did above.
Each time the swapping between processes is performed, OS performs **context switch**.


### Context Switch
![[P2L1-context-switch.png]]
The **context switch** is a mechanism used by OS to switch the execution context from the one process to another process (P1  $\to$ P2 and the reverse).  It can get expensive.
- **direct costs**: number of cycles for loading & storing instructions (all values from PCBs )
- **indirect costs**: when P1 is running on CPU, a lot of its data will be stored on processor's cache. As long as P1 is executing, a lot of its data is slightly present somewhere in cache hierarchy (L1, L2, etc.). Accessing cache is muuuuch faster (cycles vs. hundreds of cycles on MM). 
	- when the data we need is present in the cache (like P1 data), we call this that the **cache is hot**
	- if it's not, some or all of the data belonging to P1 will be replaced to make room for data needed for P2. Next time P1 is scheduled to execute, its data will not be in the cache as well! Much more time will be spent to read from memory (cache misses incurred). We call it **cold cache**.
Therefore we want to **LIMIT HOW FREQUENTLY CONTEXT SWITCHING IS DONE!**



### Process Lifecycle
![[P2L1-PLC.png]]
When a process is running, it may be interrupted and context-switched. In that case it is in idle state, but is in "ready-state". It's ready to execute, but it's not the current process running on a CPU.  

*What other states can the process be in and how is that determined?* The image above is a good summary.

Initially, when a process is created, it enters the "new" state. It is when OS will perform the admission control and if it's determined to be okay, OS will allocate and initiate the PCB and some initial resources for this process. Assuming that there are some available resources, the process is admitted and is "ready" to start executing.

In the "ready" state, it's not yet executing in CPU. It'll have to wait until the scheduler is ready to move it into the "running" state, when it schedules it on the CPU. 

In the "running" state it may be interrupted and get back to "ready" state. It may also initiate some longer operation (reading data from disc, waiting for timer or keyboard input) and thus enters a "waiting" state. When it completes, it'll become "ready" again. Finally, when "running" process finishes all operations in the program or an error occurs, the process is "terminated".



### Process Lifecycle: Creation
![[P2L1-Process-Creation.png]]
In OS, a process can create child processes. In the diagram, we can see that all processes with come from a single root and they will have some relation with each other, where the creating process is the **parent** and the created process is a **child**. Some of these are privileged processes (like three first nodes in the diagram). When OS is booted, it will create some number of initial processes. When user logs in to the system, an user shell process is created, and when any command is executed (ls, emacs), then new processes are spawned from this shell parent process.

Mechanisms for process creation:
- fork 
	- copies the process PCB into new child PCB
	- child continues execution at instruction immediately after the fork
	- have exact same PCB values as its parent, including the program counter
- exec
	- replace child image
	- load new program and start from first instruction
	- it takes PCB created from *fork* but do not leave these values to match parent's
	- instead it place the child's image, load new program and child's PCB will now describe (point to) values that describe this new program
	- program counter points to first instruction of the new program
... but the behavior of actually creating a new program is like you call a *fork* that creates the initial process and then you call *exec* that replaces the child's image (created in the *fork*) with the image of this new program.



### Role of CPU Scheduler
![[P2L1-CPU-scheduler.png]]
A **CPU scheduler** determines **which one** of the currently **ready** processes will be **dispatched** to the CPU to start running, and **how long** it should run for.

OS must.. **BE EFFICIENT**, because CPU resources are precious! It is thus important for OS to perform these tasks as fast as possible:
- **preempt** - interrupt and save current context
- **schedule** - run scheduler (scheduling algorithm) to choose next process
- **dispatch** - dispatch process & switch into its context

Efficient designs, algorithms and data structures that are used to represent ready processes or any information used to make scheduling decisions (priority, history).



### Length of Process
![[P2L1-process-timeslice.png]]
How long should a process run for? How frequently should we run the scheduler? The longer the process runs, the less times we need to actually use the scheduler. The more frequently we run scheduler, the more time is "wasted" on running it instead of applications' processes.

Given that $timeslice = \text{time } T_p \text{ allocated to a process on the CPU}$ , there are some **Scheduling Design Decisions**:
- What are appropriate timeslice values?
- Metrics to choose next process to run?

Given that the intervals between $T_p$ are scheduling times (denoted as $t_{sched}$ ), we can calculate **useful  CPU work**:
$$
	\text{Useful CPU work} = \frac{\text{Total processing time}} {\text{Total time}}  
$$
If we assume $T_p = t_{sched}$ , then: 
$$
\text{Useful CPU work} = \frac{2 * T_p}{2*T_p + 2*t_{sched}} = 0.50
$$
... that means that only 50% of CPU time is spent on useful work. If we assume $T_p = 10*t_{sched}$ , then the result will be ~91% of the time spent on useful work!



### What about I/O?
![[P2L1-ready-process-path.png]]
The diagram shows how a running process may end up in being a ready process again.

But how I/O operations affects schedule? 
- when a process has made I/O request (i.e., read from disc), the process enters "waiting" state and puts the request on the associated I/O queue of this specific device. This way, the process is now "waiting" in the I/O queue.
- the process remains "waiting" until the device completes the operations that the I/O event is complete and responds to that particular request.
- once the I/O request is dismissed, the process is put back on the "ready" queue or even scheduled to run if there's nothing else waiting on the ready queue before it. 

Let's go back to describing how a process may go back to "ready" state from "running" as described in the image above.
- it may go as described with I/O operations above
- a process that was running on CPU has its time slice expired and goes back to "ready" queue
- when a new process is created via the **fork** call it ultimately ends its way on the ready queue  
- the process that was waiting for the interrupt and the interrupt finally occurs.


### Inter Process Communication
 Most applications comprise of multiple processes that communicate with each other.
 ![[P2L1-IPC-example.png]]
 In this example, we have two processes:
 - P1 (web server) - frontend, accepts customers' requests
 - P2 (database) - backend, database that stores customers' profiles and other information
OS go through a lot deal to protect and isolate processes from one another (separate address space, controlling CPU usage, memory allocated and accessible), so the following communication mechanisms have to be built around these protection mechanisms. 

##### **Inter-Process Communication (IPC)** mechanisms do:
- transfer data/info between address spaces
- maintain protection and isolation
- provide flexibility and performance

One mechanism that OS support is **message-passing IPC**:
- OS provides communication channel, like shared buffer
- processes write (send) / read (recv) messages to/from each channel
 ![[P2L1-IPC-example,message-passing.png]]
It's "message-passing" because every process has to put the information that it want to send to the other process explicitly in the message and send it to this dedicated communication channel.
+OS manages the channel and OS provide the exact same APIs / system calls of writing/sending data to/from this operation channel 
-overheads. Every piece of information needs to be copied from the user space of the first process into the channel that's sitting in the OS (kernel) memory and then back to address space of the second process.

##### Shared Memory IPC
- OS establishes a shared memory channel and maps it into each process address space
- processes directly read/write from this memory
- OS is out of the way!
![[P2L1-IPC-example,shared-memory.png]]
+OS is out of the way. It means no overheads from the OS during communicating
-(re-)implement code. Since OS is out of the way, it no longer supports fixed and well-defined APIs how this particular shared memory is used. Thus, sometimes it becomes more error-prone or developers have to re-implement code to use this shared memory region in a correct way.

