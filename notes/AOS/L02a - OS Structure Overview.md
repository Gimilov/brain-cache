---
tags:
  - type/lecture
  - "#AOS"
---
Created: 2024-12-30 16:52
Source: [LINK](https://andrewrepp.com/aos_lec_L02)

# OS Structure Overview

- OS Structure Definition: The way the OS software is organized with respect to the applications that it serves and the underlying hardware that it manages
- OS must protect integrity of resources it manages
- However, some things do **have** to run in privileged mode. OS must permit this, flexibly.
- Goals of OS Structure:
    - Protection: within and across users and the OS itself
    - Performance: time taken to perform the required services
    - Flexibility: extensibility. not one size fits all, but the ability to add or adapt to what a given use case needs
    - Scalability: performance improves as hardware resources improve.
    - Agility: adapting to changes in application needs and/or resource availability
    - Responsiveness: reacting to external events quickly (e.g. peripheral inputs, network inputs, etc)
- Some of the above goals seem to conflict with each other. e.g. performance and protection
    - we will explore ways in which OS researchers satisfy these seemingly conflicting goals
- Commercial Operating Systems
    - Linux
    - MacOS
    - Windows
## Monolithic Structure
![[L02a_monolithic_structure.png]]
- Hardware all managed by the OS
- Each App in its own hardware address space
    - allows protection between applications
- OS in its own hardware address space
    - all of it: filesystem, scheduler, memory management unit, network, etc.
- when an app needs any OS-provided service, must context switch between address spaces

### DOS-like structure

- DOS looks, at first glance, very similar to a monolith
- Key difference is that line dividing apps from OS is dotted, instead of solid
    - Main difference is no protection between the application and the OS.
- Pros
    - performance => access to system services like a procedure call
    - no context switching!
- Cons
    - an errant application can corrupt the OS
    - trampling the OS address space is very easy
- This was a single-user approach, really designed for running a single app at a time. Protection was seen as less important.
- Loss of protection in DOS-like structure is simply unacceptable for a modern OS.
- Monolithic structure reduces performance loss by consolidation all services into one structure, preventing the need for context switching to multiple address spaces for different services required.
- But, monolithic structure limits ability to customize the OS for different needs.
    - Some examples make this limitation more visible. Provided example is video games, which have very strict and unique requirements. Computing prime numbers would have very different requirements than an interactive video game.

### Opportunities for Customization

- Memory Management – how should an OS handle page faults
    - OS actions
        1. find a free page frame
            - page replacement algorithm would run to free up page frames to have them ready for this point
            - the OS over-commits available physical memory, similar to an airline overbooking
            - this cleanup is a general fit, the optimal memory cleanup would be custom-fit to the memory use patterns of a given app. a This presents an opportunity for customization.
        2. OS initiates disk IO to move page from virtual memory to free page frame
        3. update page table for faulting process
        4. resume process
- The above is one example of opportunity for optimization, but there are many others, such as CPU scheduling, filesystem, etc.
## Microkernel Structure

- The missed opportunities for customization prompted OS designers to consider alternative structures that would more easily allow the OS to be tweaked to various use cases.
- ![[L02a_microkernel_structure.png]]
- As with a monolith, each app goes in its own address space
- The microkernel runs in a privileged mode and provides only very simple abstractions
    - threads, address space, IPC
    - mechanisms provided, **not policies**
- Each service then goes in its own address space, sitting on top of the microkernel as server processes.
    - execute with the same privilege as the apps themselves. in principle there is no distinction between apps and services
    - this protects the services from each other, and the microkernel from the services.
- The microkernel must provide IPC abstraction to allow the apps to request services from the server processes, and the server processes to communicate between each other
- Pros
    - Extensibility. Because OS services are implemented as server processes, these server processes can be replicated with different characteristics. FS1 and FS2 can run alongside each other, and an app can request from whichever one is better suited to its use case.
- Cons
    - Potential for performance loss
    - In monolithic structure, app calls for a service, one context switch to OS privileged mode. All needed services can now be accessed at normal procedure call speed
        - In a microkernel structure, app must make IPC call to contact filesystem. App must go to microkernel, microkernel calls filesystem server process, and then two hops back the other way.
        - may have to context switch far more often than otherwise needed
        - ![[L02a_microkernel_structure_2.png]]
### Why performance Loss?

- Border crossings – the sheer time spent in context switches
- Change in locality – cold caches everywhere
- User space<->system space copying of data (required for protection of separate address spaces)
- We will later discuss an example of a microkernel that was carefully designed to minimize this performance loss

## So what do we want?

- Performance
- Extensibility
- Protection
- These three are conflicting goals, that various designs balance against each other to try and achieve best overall experience. Throughout this course we will discuss approaches that try to accomplish this
![[L02_what_do_we_want.png]]
