---
tags:
  - "#AOS"
  - type/lecture
---
Created: 2025-01-19 18:20
Lecture: [[L02d - The L3 Microkernel Approach]]
Source: [link](https://www.seltzer.com/margo/teaching/CS508.19/notes/liedtke-1995.html)

## What kind of paper is this?
- Refute conventional wisdom.
- Big idea (µ-kernels are fast enough).

## The Story
- µ-Kernels have gotten a bad rap.
- They are considered inefficient and inflexible.
- The problem is not the µ-kernel idea but the implementation.
- µ-Kernel should **not** be portable.
- If you build a µ-kernel correctly, then you get good performance **and** flexibility.
- So, what should you do?
  - Reason about µ-Kernel concepts.
  - Only put in the kernel that which, if moved outside the kernel, would prohibit functionality.

### Assumptions
- Require security.
- Require page-based VM.

### Requirements
- Subsystems must be able to be isolated from one another.
- Must be able to communicate between two subsystems without interference from a third.

### Components
- Address spaces.
- Threads and IPC.
- Unique IDs (not much more to say here, but you need to be able to identify address spaces, threads, and messages).

---

## Address Spaces
- All through inheritance.
- One master address space (physical memory).
- All others are selections from this space.

### Interface
- **Grant**: Move a page from your address space to a new one.
- **Map**: Share a page with another address space.
- **Flush**: Remove a page from someone’s address space.

- These three operations are the only functionality required by the microkernel.
- All other functionality (e.g., paging, general memory management, controlling IO device rights, and IO drivers) are done **outside** the kernel.

---

## So, what is a microkernel
- Minimal interface to address space construction (grant, map, flush).
- Threads.
- IPC.
- Unique identifiers.

---

## Implementing user-level services on a µ-kernel

### Memory manager/Pager
- Grant, map, flush are the basic mechanisms.
- Policies for how and when you issue these calls can be made in a user-level manager.
- Each address space can have its own manager.
- Can have application-specific managers (e.g., multimedia resource allocator) that must, itself, coordinate with other managers to make appropriate guarantees.

### Device Drivers
- Can live outside the kernel, because they don't access hardware directly; they send/receive messages from the thread that represents the hardware.

### Cache and TLB handling
- User pagers to implement whatever policies you like.
- In practice, first-level TLB handling still needs to be in the kernel for performance.

### Unix server
- Simply a user-level server that creates and manages its own Unix address spaces.

---

## Performance
Refute the question of why results in the literature suggest that microkernels are inherently slower.

### Context Switches
- Context switches (e.g., system calls) shouldn’t be that expensive.
- Conventional systems pay almost 90% of their context switch time in "overhead."
- L3 does not.
- Why? What is being ignored?
  - Parameter checking?
  - Parameter passing?
  - Saving kernel state?
  - What else?

### Switching between address spaces
- Similarly, switching between address spaces shouldn’t be so expensive.
- Include thread and address space switching in the discussion (because that's what people measure).
- If caches are physical, these don’t affect context switch time.
- If TLBs are untagged, an address space switch requires a flush of the TLB (and subsequent TLB faults to establish new entries).
- Use PowerPC hacks to get rid of TLB reload problems, by use of segment registers.
- Tailor context switch code to the HW and figure out how to get it fast.
- Basic approach suggested is actually placing all processes in a large (e.g., 52-bit address space) so that by changing a segment register, you essentially fake a tagged TLB. Essentially this is reminiscent of Multics—you are (sort of) mapping things like device drivers and small servers into every address space (with appropriate permissions).

### Thread switches and IPC
- Empirically show that L3 has fast IPC.

### Memory Effects
- Chen and Bershad "showed" that microkernels had significantly worse memory behavior.
- Liedtke shows that the difference is entirely in the cache miss behavior.
- What kinds of misses are these (capacity or conflict)?
  - Conflict: Might imply structure.
  - Capacity: Code is just too big.
- Chen and Bershad show that self-interference causes more misses than user/kernel.
- Ratio of conflict to capacity is much lower in Mach.
- Liedtke concludes that the problem is simply too much code, and that most of that code is in Mach.

Conclusion: The slowness of microkernels is really just problems of implementation.

---

## Portability
- µ-kernels should not be portable; they are the hardware compatibility layer.
- Example: Implementation decision between 486 and Pentium is different if you are going for high performance. This difference suggests significant rewriting to achieve high performance.


## Paper:
![][03_microkernel.pdf]