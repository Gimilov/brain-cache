---
tags:
  - type/lecture
  - "#AOS"
Papers:
  - "[[Paper - L03b&c - Xen and the Art of Virtualization]]"
---
Created: 2024-12-30 17:10
Source: [LINK](https://andrewrepp.com/aos_lec_L03)
# Memory Virtualization

- Stacked viz of memory going rom CPU with TLB down through caches to main memory (RAM) and then to Virtual Memory on disk
- Thorny issue here is handling virtual memory (VA to PA mapping)
    - this is the key functionality of the memory management system on any OS
- In any OS each app is in its own protection domain (and usually its own hardware address space)
- Page table holds VA->PA mapping
- Physical memory is contiguous going from 0 to v(Max)
- Virtual address space of a given process is not (does not have to be) contiguous in physical memory (advantage of page-based memory management)
- In full virtualization example, each guest OS process is in its own protection domain
    - distinct page table in each guest OS
    - does hypervisor know about each page table? no!
- physical memory is thought to be contiguous by guest OS’s, but they don’t actually see physical memory, hypervisor does. and from the hypervisor’s point of view, the memory assigned out to VMs is not contiguous. similar to VA->PA mapping at OS level. terminology used for HV->VM layer is “machine memory” to “physical memory”, for convenience
- Hypervisor maintains its own page table, allocating machine memory out to guest OS’s. Physical page number to machine page number (MPN)
    - called the “shadow page table” (SPT)
    - so all mappings go: VPN->PT->PPN->SPT->MPN
    - open question: does guest OS or hypervisor keep the SPT (mapping PPNs to MPNs)?
        - in fully virtualized setting, must be kept with hypervisor as there is no guest OS code for handling this process
        - in paravirtualized setting, guest OS has been altered to know it is being run in a VM. In this case it can be either, but is usually housed within the guest OS
    - ![](/img/L03b_memory_virtualization.png)
## Efficient Memory Mapping

### Fully Virtualized

- in many architectures, CPU uses page table for address translation
- ![](/img/L03b_efficient_memory_mapping_1.png)
- hardware page table is really the SPT in a virtualized setting.
- How to make this efficient?
- ![](/img/L03b_efficient_memory_mapping_2.png)
- two levels of indirection, two lookups, for every mapping is wildly inefficient
- PT/TLB updates of guest OS are privileged, and therefore trapped to hypervisor.
- SPT updated by hypervisor instead.
- as a result, the actual translations are remembered in TLB/hardware PT. we bypass guest OS PT
- ![](/img/L03b_efficient_memory_mapping_3.png)
- This approach is, for example, used by VMWare’s ESX server
### Paravirtualized

- Shift the burden to guest OS
- Maintain contiguous “physical memory”
- map to dis-contiguous hardware pages
- More efficient than fully virtualized approach, and possible here because we’re “allowed” to alter the guest OS code.
- Example in Xen:
    - provides a set of “hypercalls” for guest OS to use to call to the hypervisor
    - Create PT hypercall allows guest OS to allocate and initialize a page frame it has previously acquired from the hypervisor as a hardware resource. It can then target that page frame as a page table data structure directly.
    - Switch PT hypercall requesting context switch to new page table from hypervisor.
    - Update PT hypercall allows updates in place to page tables on hardware, e.g. as a result of a page fault
    - Hypervisor doesn’t need to know details, can just take the requests from guest OS.
    - Everything an OS would need to do when running on bare metal must be provided for in this way.

## Dynamically Increasing Memory

- How do we increase the amount of physical memory available to a given guest OS?
- Memory requirements tend to be bursty, hypervisor must be able to allocate machine memory on demand
- What happens when guest OS requests memory but host has none to give.
    - One option is to claw back some of the memory allocated out to another guest OS that isn’t using it.
    - Instead of forced reclamation, a request might be better.
- This concept is called “ballooning”
    - the idea is to have a special device driver installed in every guest OS
    - Upon needing more memory, hypervisor will contact an under-utilizing guest OS, talking to the balloon driver through private channel.
    - Balloon device driver will request memory from guest OS, inflating the balloon and restricting “available” memory visible to guest OS as it pages out to disk other processes’ memory.
    - Balloon driver will then return that machine memory back to hypervisor.
    - The idea here is that the “balloon” inflates, taking up footprint in the guest OS.
    - The reverse of the above, where the hypervisor needs less memory, will deflate the balloon and return that footprint back to “available” status to the guest OS, which will then page in from disk the working sets of whatever processes would like it.
    - This model assumes cooperation between the hypervisor and the guest OS, despite the guest OS not actually knowing about the hypervisor. Therefore it is applicable to both fully virtualized and paravirtualized settings.

## Sharing Memory Across Virtual Machines

- Can we share memory across VMs without affecting the protection offered to them?
- If two apps have the same data (e.g. two instances of Firefox running on two different VMs), they could in theory share the same PPN.
    - The ‘core pages’ of apps are often the same, so this is a common case
- Guest OS has hooks that allow such page frames to be marked copy-on-write on the local page tables on guest OS, and therefore only make copies on machine page table when they diverge
    - This requires the guest OS and hypervisor to collaborate

### VM Oblivious Page Sharing

- Alternatively, achieve the same effect but without guest OS knowing anything about it
- The idea is to use content-based sharing
- VMWare keeps a hash table in the hypervisor, which contains a content hash of the machine pages.
    - ![](/img/L03b_oblivious_VM_page_sharing.png)
- To use, hash contents of page table, scan data structure for a match to the hash.
    - If you get a match, doesn’t mean it’s for sure match, page may be dirty
    - So do a full comparison between page table contents upon match.
    - If content matches, map both page tables to same machine page table, increment reference count in hint frame on hash structure. Mark both page tables being mapped to same machine page table as copy-on-write.
    - Free up page frame in machine memory, as we have doubled up somewhere else and don’t need it. This is the space savings we’re trying for.
- Scanning pages for such duplicates that we can double up on is done as background activity of the server, when load is low, as these are expensive operations.
- Applicable to both fully virtualized and paravirtualized environments

## Summary

- we have discussed mechanism here, but a higher-level issue is policies for how to do all the above.
- The goal of virtualization is maximizing utilization of the virtualized resources

### Example Policies

- Pure share based approach (pay less, get less)
    - problem is it leads to hoarding. largest share user may not actually need much
- Working-set based approach
    - allocation based on actual utilization.
- Dynamic idle-adjusted shares approach
    - tax idle pages more than active ones
    - determine best tax rate based on your business model or use case, could be 0%, could be 100%, those would be equivalent to the two approaches above
- Reclaim most idle memory (from VMs not actively using it)
    - allow for sudden working set increases, as we don’t reclaim _all_ idle memory

