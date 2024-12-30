---
tags:
  - type/lecture
  - "#AOS"
---
Created: 2024-12-30 17:00
Source: [LINK](https://andrewrepp.com/aos_lec_L02)

# The Exokernel Approach

## Exokernel Approach to Extensibility

- The name “Exokernel” comes from the fact that the kernel exposes hardware explicitly to the OS extensions living on top of it.
- ![[L02c_exokernel_approach.png]]
- The core principle is to decouple authorization to use the hardware from its actual use
- Exokernel validates requests for resources, then binds the request to the resource in question
- Semantics of use by a given library OS is up to the library itself. Conventions may apply, of course.
- Once a library OS has asked for a resource and the kernel has created the binding for the resource to the requester, then the library is ready to use the resource.
    - Library OS will present the encrypted key to the exokernel to validate usage but otherwise stay out of the way. “Doorman” sort of activity here.
- Establishing the secure binding is the heavy duty operation. Validation after that is quite fast, improving overall performance as you amortize the cost of the initial binding
### Examples of Candidate Resources

- TLB entry
    - virtual to physical mapping done by library OS
    - binding presented to exokernel
    - exokernel validates access and puts it into hardware TLB
        - this is a privileged operation so library OS cannot do it by itself
    - Process in library OS OS uses multiple times without exokernel intervention
        - this is, therefore, quite fast
- Packet Filter
    - to be executed every time a packet arrives
    - predicates are loaded into kernel by library OS
        - this is the heavy duty operation, needs kernel and library OS to communicate
    - checked on packet arrival by exokernel
        - very fast, no communication needed back to library OS
- Both of these are examples of “initial binding expensive and slow, subsequent use cheap and fast”

## Implementing Secure Bindings

- Three methods
    - Hardware mechanisms (e.g. TLB entry above)
        - physical page frames, portion of frame buffer. All examples of hardware resources that can be requested by library OS and can be bound to it by exokernel.
    - Software caching
        - “shadow” TLB in software for each library OS (aka caching hardware TLB into a software cache)
            - avoid context switch penalty for switching between library OS’s
    - Downloading code into kernel
        - avoid border crossing by inserting specific code an OS wants executed. example of packet filter above would fall into this implementation method.
        - functionally equivalent to SPIN extensions
        - A close comparison can be made between this implementation method and SPIN’s “extend logical protection domains”. This one compromises protection more, as the code added to kernel is arbitrary, whereas with SPIN benefits from the compile time enforcement and runtime verification

## Memory Management in Exokernel

- Given example: a page fault handled by library OS from an app running in threads on exokernel
    - exokernel passes fault up to library OS through registered handler
    - library OS knows about processes while exokernel does not. library OS services page fault. may require requesting resources such as page frame from exokernel
    - library OS does address mapping, and presents to exokernel along with TLB entry where mapping should be stored
        - presented along with encrypted key, as usual
    - exokernel will store mappings into TLB (privileged op)

### Software TLB

- During context switch, a big source of performance loss is losing locality for newly scheduled process
- address spaces for separate library OS’s are necessarily different, require full TLB flush, huge source of overhead
- S-TLB is a snapshot of the hardware TLB for each of the different library OS’s
- If exokernel switches from library OS1 to OS2:
    - dump TLB into S-TLB for Library OS1 (really only a subset, discussed more later)
    - preload TLB with S-TLB for OS2
    - OS2 will then have its mappings available in TLB when it goes to look for them
- if TLB miss happens anyway, page fault sequence happens as normal

## Code execution in Exokernel

- library OS is given permission to run arbitrary code in the kernel
- this is done to avoid the performance costs associated with context switching into/out of kernel space
- this presents a huge security risk to the kernel.
- while both SPIN and Exokernel favor extensibility, some restrictions must be considered for security’s sake

## CPU Scheduling in Exokernel

- Exokernel maintains linear vector of time slots
- Every time slot/quantum has a beginning and an end
- Time quanta represent time that is allocated to the library OS’s that live on top of exokernel
    - Each library OS gets to mark its slots on startup
- Control is passed to exokernel as each time slot expires, and then reassigned over to next slot owner.
    - This allows saving and such for context
    - Not actual preemption, OS will own the processor.
    - A misbehaving OS that does not relinquish processor will be penalized by removing time from future slots to make up the difference
- Processor kernel will only be handed back to exokernel on time slot expiration or in case of things like page faults where the exokernel needs to do some of the work

## Revocation of Resources

- Exokernel supports no abstractions, only mechanisms for giving over control to library OS’s (such as space, memory, hardware, etc)
- Therefore exokernel needs a means of revoking or reclaiming resources
    - Exokernel keeps track of what resources have been given out
    - However, exokernel has no means of knowing what the resources are actually being used for
- mechanism is revoke(repossession vector) passed to library OS
    - library OS is responsible for cleanup and corrective action
        - e.g. if page frame is being reclaimed, library OS must stash contents to disk
- library can “seed” exokernel for “autosave”
    - library OS can tell exokernel to save any reclaimed page frames to disk in advance
    - provides speedup, less back and forth with library OS
## Exokernel Summary
![[L01c_exokernel_summary.png]]
- Under “normal” operation, library OS passes execution threads down to exokernel, which passes down to the hardware, and runs until its done or the timeslice expires
- any discontinuities in thread running on hardware are kicked back up to exokernel, which must then pass up to library OS to handle as desired
- exokernel maintains state for each library OS to help handle these discontinuities properly

### State Maintained by Exokernel
![[L02c_state_maintained_by_exokernel.png]]
- maintains PE data structure on behalf of each library OS
    - PE contains entry points for each library OS for dealing with the different kinds of program discontinuities0
    - similar to event handler mechanism from SPIN section
- Also maintains S-TLB for each library OS

## Comparison of Exokernel and SPIN

- must always remember not to compare using absolutes. Instead compare trends, and compare against like competitors
- The comparison for Exokernel and SPIN (early to mid 90s) was monolithic (UNIX) and microkernel (Mach).
- Comparative metrics were space and time.
    - probably also security and extensibility, but those are harder to quantify?
- SPIN and Exokernel do much better than Mach for protected procedure calls
    - also both do as well as UNIX for dealing with system calls