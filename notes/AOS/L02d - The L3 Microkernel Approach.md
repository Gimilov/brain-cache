---
tags:
  - type/lecture
  - "#AOS"
---
Created: 2024-12-30 17:03
Source: [LINK](https://andrewrepp.com/aos_lec_L02)

# The L3 Microkernel Approach

- Both SPIN and Exokernel begin with the assumption that microkernel must have poor performance
    - assumption based on Mach, but portability was a key goal for mach.
    - if performance was the only goal, would it be possible? L3 will provide us the answer
- Core idea of a microkernel is that microkernel provides small number of simple abstractions. all system services are each in their own address space. only microkernel runs as privileged as covered in prior section

## Potentials for Performance Loss

- Border crossings
    - implicit and explicit costs
        - explicit cost is the context switch required for an app to trap into the microkernel. many extra border crossings going from app to kernel to services and back
- Protected procedure calls
    - run at 100x the time cost of normal procedure calls because they are going across address spaces
    - implicit cost of border crossings is the fact that crossing address spaces completely loses locality in TLB and cache

## L3 Microkernel Goal

- Proof by construction to debunk myths about microkernel-based OS structure
- Still has minimal services provided
    - Address space
    - Threads
    - IPC
    - Generate Unique IDs
- System services are still distinct protection domains, protected from each other and applications, and separate from the kernel.
- What’s different about L3 is that each services is in their own protection domain, not necessarily distinct address spaces.
    - There are ways to construct system efficiently, knowing the features of the hardware platform
    - Key thesis for L3 is that it’s all about efficient implementation

## Strikes Against Microkernel Design

- Kernel-user switches
    - border crossing cost
    - required for every syscall
- Address space switches
    - basis for Protected Procedure Calls for cross protection domain calls
    - a result of each system service living in its own address space
    - minimally involves flushing TLB, which is costly
- Thread switches and IPC
    - thread switches + IPC must be mediated by kernel
    - system services must talk to each other through kernel, requiring many extra border crossings, which is very costly
- All the above are explicit costs tied to microkernel design
- Memory Effects
    - locality loss in cache and TLB
    - an additional implicit cost, driven by separate address spaces for services

## L3 Debunking Myths about Microkernel Slowness

### Debunking user-kernel border crossing myth

- L3 accomplishes user-kernel border crossing in 123 processor cycles
    - this includes TLB and cache misses
- Also counts the minimal cost involved in a border crossing, show that theoretical minimum is 107. 123 is therefore pretty close to optimal
- Mach took 900 cycles for the same, making it a very unfavorable point of comparison. This weakens the argument that SPIN and exokernel used.

### Debunking address space switches myth

- Going across address spaces is expensive? Explicit costs addressed as myth
- Review of address space switch:
    - Virtual address consists of tag and index
        - Index is used to look up in TLB
        - tag is used to match against tag in TLB. match == hit
    - retrieve PFN from TLB
- On context switch, VA -> PA mapping will obviously change
    - so all stored translations are useless and must be cleared? It depends!
    - if the TLB has a way of recognizing that VA->PA mapping is valid for currently used VA, maybe not?
    - tags for address spaces to the rescue! contain process ID for which TLB entry is valid. Flushing no longer needed!
    - ![](/img/L04d_l3_microkernel_approach.png)
    - this does require hardware support, though, so not always an option. if you’re on Intel, for example, what should you do instead?
- Liedtke’s suggestion for avoiding TLB-flush when hardware support for AS-tagging is absent:
    - Exploit architectural features – e.g. segment registers in x86 + PowerPC
        - specify the range of addresses that can be legally accessed by the currently running process.
        - carve up linear address space using segment registers
    - share hardware address space for protection domains
    - this approach is actually quite fast, as it skips looking at TLB at all if the requested address is ’illegal’
    - works best with smaller address spaces, as hardware address space is being divvied up, you lose the “infinite virtual memory” perk of common monolithic kernel systems
    - What if the needed protection domains are large? What if it needs all of hardware address space?
        - In this case, and there is no support for AS-tagging in TLB, you’re just stuck doing a TLB-flush on address space switch
        - Costs above are explicit costs. In the case of large protection domains those are much smaller than the implicit costs.
            - Loss of locality is complete in this case, all caches are ice cold. This is a much bigger hit. Explicit cost here is 864 cycles for TLB flush in pentium, but loss of locality will be far more significant.
	- ![](/img/L04d_l3_microkernel_approach_2.png)
### Debunking thread switches and IPC myth

- Switch involves saving all volatile state of processor – explicit cost
- By construction shown to be competitive to SPIN and Exokernel
    - Uh…. not a lot of detail provided here. They built it, it was just as fast, the end?

### Debunking memory effects myth

- This was the big “implicit cost” hit discussed above
- Loss of locality in microkernel is much bigger than monolith/SPIN/Exokernel?
- ![](/img/L04d_debunking_memory_effects_myth.png)
- Hardware address space may not all be in physical memory, may be demand paged from disk
- Working set slowly dragged up into higher level caches as a process runs
- memory effects == how warm are caches when we context switch?
    - with small protection domains, all can share address space through segment registers as suggested above. This results in very warm caches
    - if protection domains are large, can’t be helped. it’s going to need to be flushed out. This is true even for monolithic kernel. Cache pollution must be incurred.
    - Thus the only place where monolithic/SPIN/Exokernel can really differentiate is in cases with small protection domains, and Liedtke’s suggestion means that there is no real advantage for them there either
- So why was Mach so bad?
    - border crossings cost 800 more cycles
    - due to: focus on portability (run on any architecture) => code bloat => large memory footprint => lesser locality => more cache misses => longer latency for border crossing
    - Therefore the kernel memory footprint is the culprit, not the architecture itself!
        - Corollary: portability and performance are in contradiction with each other

## Thesis of L3 for OS Structuring

- Minimal abstractions in microkernel
- Microkernels are processor-specific in implementation => non-portable!
- Right set of microkernel abstractions and processor-specific implementation => efficient processor-independent abstractions can be implemented at higher layer