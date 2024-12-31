---
tags:
  - type/lecture
  - "#AOS"
---
Created: 2024-12-30 17:07
Source: [LINK](https://andrewrepp.com/aos_lec_L03)

# Introduction to Virtualization

- The drive for extensibility in OS services leads to innovations in the internal structure of OS’s.
- We will cover the concept of virtualization and how it extends the concept of extensibility, allowing the simultaneous coexistence of entire OS’s.

## Platform Virtualization
![](/img/L03a_platform_virtualization.png)
- Goal is to provide a “virtual” platform at a fraction of the cost, by eliding over providing specific hardware.
- Predicated on the assumption that the end user doesn’t generally care how an app is run, so long as it does what the user wants
    - amortize cost of ownership, use economies of scale and use patterns to find a lot of margin here.
- However, we as developers care quite a bit.
- Key challenge is that usage is usually very **bursty**
- ![](/img/L03a_platform_virtualization_2.png)
- This means that we need to be mindful of overlaps.
    - We need far more resource than the need of any individual platform user.
    - However each user then has access to far more resource than they could possibly have afforded on their own
- **Virtualization** is the concept of extensibility, but applied to an entire OS instead of just the services provided by an OS
## Hypervisors

- How do we isolate/protect/run multiple OS’s running on the same hardware?
- What allocates resources? We need an OS of OS’s
- Hypervisor! aka VMM (Virtual Machine Monitor), with OS’s on it referred to as VMs or Guest OS’s
- ![](/img/L03a_hypervisors.png)
- Two types of hypervisor
    - Native (bare metal)
        - runs on top of bare hardware
        - We’ll focus mostly on these
        - interfere minimally with guest OS’s. Similar in philosophy to extensible OS’s
        - offer best performance
    - Hosted
        - runs on top of host OS. Allows users to emulate the functionality of other OS’s
        - VMWare Workstation, VirtualBox

### Connecting the Dots

- IBM VM370 (1970’s)
    - origin of the concept of Virtualization
    - intent was to give the intent to all users that the computer was exclusively theirs
        - also to provide binary support for older versions of IBM computers
- Microkernels (late 1980’s and 1990’s)
- Extensibility of OS (1990’s)
- SIMOS (late 1990’s)
    - laid the groundwork for the modern resurgence of virtualization tech at the OS level
    - Was the basis for VMWare
- Xen + VMWare (early 2000’s)
    - proposed originally in the pursuit of supporting application mobility, server consolidation, co-location, distributed web services
- Today – accountability for usage in data centers
    - Margin for device making companies is very small. Everyone wants instead to provide “services” for end users
    - Companies can now provide resources with complete isolation, and bill users appropriately
        - i.e. cloud providers billing app developers who are in turn selling SAAS apps.

## Full Virtualization

- The ideal is to leave the guest OS untouched, running exactly as it would itself on bare metal
- Must be a bit clever to manage this, though, as the guest OS’s must still run as user-level processes. The hypervisor must still mediate access to the underlying hardware.
    - When guest OS executes privileged instructions, those instructions must trap into hypervisor, which will then emulate the intended functionality of the OS. This is called the _trap and emulate_ strategy.
    - Each guest OS thinks it is running on bare metal, and acts accordingly, trying to execute privileged instructions.
        - Some privileged instructions may fail silently. Covered in more depth in my [GIOS Notes](https://andrewrepp.com/gios_lec_P3L6.html)
            - Hypervisor will resort to a binary translation strategy
                - look for such instructions in guest OS, and through binary editing, ensure that those instructions are dealt with appropriately.
            - This has since been fixed for Intel and AMD architectures, where it was a big problem.

## Paravirtualization

- Not fully virtualized, OS’s know they’re on VMs. Modify the source code of guest OS
- Avoid problematic instructions, and include possible optimizations
    - allow guest OS see real hardware resources, employ page coloring, etc.
- No different for the applications running on guest OS, they only know they’re running on whatever OS.
- Xen product family uses this approach.
- How much modification is actually needed for guest OS binaries with this approach?
    - Xen showed, by proof of construction, that it is less than 2% of the guest OS’s code
    - ![](/img/L03a_how_many_lines_to_change.png)