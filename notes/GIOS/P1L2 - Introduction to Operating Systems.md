---
tags:
  - type/lecture
  - GIOS
---
Created: 2024-08-25 15:41
# Lecture Notes

In simple terms, an operating system is a piece of software that **abstracts** and **arbitrates** the use of computer system. By abstraction, it means to simplify what the hardware actually looks like, while by arbitration, it means that it manages, control and oversees the use of hardware.

An **operating system** is like a toy shop manager:
- directs operational resources (control use of CPU, memory, peripheral devices..)
- enforces working policies (e.g., fair resource access, limits to resource usage)
- mitigates difficulty of complex tasks (abstract hardware details: system calls)

![](/img/P1L2-OS.png)

Assuming that a machine runs multiple applications, operating system:
- **hides hardware complexity**: instead, you can use system calls to perform tasks on hardware abstractions (i.e., read/write to your storage device, send/recv or socket abstractions).
- **resource management:** i.e, allocates memory for applications, schedules the CPU usage, control the usage of various devices of the system.
- **provide isolation & protection**: for example, each application is allocated different parts of physical memory with (usually) isolation ensured.

In summary, an operating system is a layer of systems software that resides between hardware and applications that:
- directly has **privileged access to the underlying hardware** and manipulates its state (application software can't do that)
- hides the **hardware complexity**
- **manages** hardware on behalf of one or more applications according to some predefined **policies**
- also, it ensures that applications are **isolated and protected** from one another.


### OS Elements
To achieve the above, an operating system makes us of:
- **abstractions** - like a higher-level concepts. For example, a *process*, *thread*, *file*, *socket*, *memory page*. Thanks to this, we deal with (let's say) a memory page as an abstraction instead of physical hardware resource.
- **mechanisms** - means to deal with abstractions. For example, *create*, *schedule*, *open*, *write*, *allocate*.
- **policies** - to determine how these mechanisms will be used to manage the underlying hardware (through abstractions). For example, "what is the maximum number of sockets that a process can have access to?"

For example, let's consider memory management.
![](/img/P1L2-OS-Elements-Example.png)
Here, a memory page is used as an abstraction of physical memory. It corresponds to some addressable region of memory, of fixed size. An exemplary mechanism can be *allocate* that allocates that memory page in DRAM or *map to a process* that maps that page to the address space of the process. This way, an application (i.e. a process) can access the physical memory through this abstraction. In fact, this page may be moved across different locations in physical memory, or it can be stored on disk, if we need to make a room on memory.  For that, we have **policies**. A common one is that when the **least  recently used (LRU)** pages on physical memory are the ones copied on disc. It's also called swapping. 


### OS Design Principles
When designing OS, there are some good guiding policies, first of them is **separation between mechanism & policy**. It strives to implement flexible mechanisms to support many policies, such as LRU, LFU, random for memory management. 

The other one is to **optimize for the common case**. It aims to understand what the OS will need to provide and how it will be used:
- Where will the OS be used?
- What will the user want to execute on that machine?
- What are the workload requirements?


### User/Kernel Protection Boundary
For OS to manage hardware resources on behalf of applications, OS must have special privileges that have direct access to the hardware. Computer platforms distinguish between at least two modes: 
- unprivileged **user-level** - applications
- privileged **kernel-level** - OS kernel, privileged direct hardware access
![](/img/P1L2-OS-user-kernel-protection-boundary.png)
*Note that the image should mention mmap(memory) instead of malloc(memory)*

The user-kernel switch (or distinguishing) is typically supported by hardware. For example, CPU may have privilege bit that if set (in kernel-mode), any instruction that directly manipulates hardware is permitted to execute. In user-mode, it's not set and therefore such operation would be forbidden. Such attempts will cause a **trap** - the application will be interrupted and the hardware will switch the control to OS at the specific location. The OS will have a chance to check what caused the trap to occur, and to verify if it should to grant the access or to terminate the process if it was to perform something illegal. 

Moreover, in addition to trap instructions, the interaction between application and OS can be conducted through **system calls**. The OS export a system call interface (the set of operations the application can explicitly invoke if the want the OS to performance certain service or to perform some privileged access.).

Also **signals** are a way to send notifications to applications from OS. 


### System Call Flowchart
![](/img/P1L2-System-Call-Flowchart.png)The flowchart (left-side) includes mode bit switching and jumping across the memory (the kernel passes any arguments back to the user's address space and then jumps to the exact same location in the execution of the user process where the system call was made from).

To make a system call, an application must:
- write arguments
- save relevant data at well-defined location. It's necessary so the OS kernel, based on specific system call number, can determine which and how many arguments it should retrieve, and where are they.
- make system call (using the specific system call number)

The arguments can be passed directly (lower arrow, right side) or indirectly by specific their address (upper arrow, right side).  In synchronous mode, the process will wait until the syscall completes. 



### User/Kernel Transitions
- hardware supported
	- e.g. traps on illegal instructions or memory accesses requiring a special privilege. For example, application cannot access certain registers and just give itself more CPU or memory - only OS can do that! The result of the trap is the transfer of control to the OS/kernel, and marks it by the privilege bit. The OS checks what caused the trap and what is the appropriate thing to do (deny/grant request). However, it depends on specific policies on the OS.
- involves a number of instructions
	- e.g., ~50-100ns on a 2GHz machine running Linux
- switches locality
	- affects hardware cache! Since context switches will swap the data/addresses currently in **cache**, the performance of applications can benefit or suffer based on how a context switch changes what is in **cache** at the time they are accessing it.
		- A **cache** would be considered **hot** if an application is accessing the **cache** when it contains the data/addresses it needs
		- A **cache** would be considered **cold** if an application is accessing the **cache** when it does not contain the data/addresses it needs -- forcing it to retrieve data/addresses from main memory. 
- not cheap!


### OS Services
![](/img/P1L2-Basic-OS-Services.png)
OS provides applications with access to underlying hardware. It does so by exporting a number of services. In the most basic level these services are directly linked to some of the components of the hardware, for example:
- scheduler controlling access to CPU
- memory manager responsible for allocating physical memory to one or more running applications. It also makes sure that multiple applications don't override each other's access to memory
- block device driver responsible for access to block device like disc

Moreover, OS exports even higher-level services that are linked with higher-level abstractions, as opposed to these abstractions that really map to the hardware (like these above). For instance:
- file system - supported by virtually all OS. 

In summary, OS will have to incorporate number of services in order to provide applications and application developers a number of useful types of functionality. This includes:
- process management
- file management
- device management
- memory management
- storage management
- security
- and so on...

Below, you can see a comparison of Windows vs. Linux system calls. Notice how these different OS have similar types of system calls and abstractions around them. 
![](/img/P1L2-Windows-Linux-System-Calls.png)



### Monolithic OS
![](/img/P1L2-Monolithic-OS.png)
Historically, OS had monolithic design. That means that any type of service that an application may require (or that any type of hardware will demand) is already part of the OS. For example, there may be several file systems included, like one for sequential access and the other for random I/O (like in databases).
>+ everything is included
>+ inlining, compile-time optimizations
>- customization, portability, manageability
>- memory footprint
>- performance



### Modular OS
![](/img/P1L2-Modular-OS.png) 
Nowadays, modular OS delivers significant improvements over monolithic OS and is more commonly used. 

As opposed to monolithic OS, modular OS has already basic services and APIs as a part of it, but (as the name suggests) everything can be added as a module. It's possible because OS specifies certain interfaces that a module must implement in order to be considered a part of OS. These can be based on the workload required for the system. For example, are there some kinds of computations that would benefit from sequential file access system? 
> + maintainability
> + smaller footprint
> + less resource needs
> - indirection can impact performance (it has to communicate through the interface first before it goes to the specific implementation)
> - maintenance can still be an issue



### Microkernel
![](/img/P1L2-Microkernel.png)
Another example of OS design is what we call a **microkernel**. It only requires basic primitives at the OS level. It may only support some basic services for representation of address space, executing application and its context (i.e. a thread). Everything else, any other software component, database, or a software that we normally think of as OS elements are at the user level. Therefore, it requires lots of inter process interaction. That's why **IPC** (inter-process communications) will typically be supported by the microkernel as one of its abstractions/mechanisms.
> + size
> + verifiability. Small means it may be easy to verify that code exactly behaves as it should (i.e., embedded devices, control systems).
> - portability (very specialized for the underlying hardware)
> - complexity of software development
> - cost of user/kernel crossing.



### Linux Architecture
![](/img/P1L2-Linux-Architecture.png)
while the Linux kernel architecture looks as follows:
![](/img/P1L2-Linux-Kernel-Architecture.png)
... each of these separate components can be independently modified or replaced, hence the modular approach of Linux.


### Mac OS Architecture
![](/img/P1L2-Mac-OS-Architecture.png)
- I/O kit for device drivers
- Kernel extension kit for dynamic loading of kernel components
- Mach microkernel - memory management, thread scheduling, IPC
- BSD component - _Unix interoperability_ via POSIX API support, Network I/O interface
- All applications sit above this layer