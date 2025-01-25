---
tags:
  - type/lecture
  - "#AOS"
Papers:
  - "[[Paper - L02b - Extensibility, Safety and Performance in the SPIN OS]]"
---
Created: 2024-12-30 16:56
Source: [LINK](https://andrewrepp.com/aos_lec_L02)

# The SPIN Approach

- Trying to resolve the opposing weaknesses of microkernel and monolith OS designs
- What are we trying to achieve
    - OS structure should be thin (like a microkernel), having only ****mechanisms**** and not ****policies****
    - OS should allow fine-grained access to resources without border crossing (like DOS)
    - flexibility for resource management to suit needs of the application (like microkernel) without sacrificing protection and performance (like monolithic)

## Approaches to Extensibility

- capability-based [Hydra OS (Wulf ’81)]
    - kernel mechanisms for resource allocation (not policies)
    - capability-based resource access
        - lots of abstraction and context loaded into the term ’capability’ in the OS world
        - capability is a very heavyweight abstraction
    - resource managed as course-grained objects to reduce border crossing overhead
        - heavyweight capability means context switching would be extra expensive
        - this approach reduced flexibility and extensibility
        - the coarser you make these objects, the less opportunity you have for customizing the services
- Microkernel-based (e.g. Mack from CMU in 90’s)
    - Mach focused on extensibility and portability
    - implemented all services as server processes that run as normal user-level processes above kernel
    - achieved its goals, but performance was sacrificed too much

## SPIN Approach to Extensibility

- Co-location of kernel and extensions in same address space
    - avoids border crossing
    - this raises DOS-style concerns about protection of the kernel
    - Make extensions as cheap as a procedure call
        - because we have co-located the kernel and extensions in the same address space
- Compiler-enforced modularity
    - this addresses protection by relying on the characteristics of a strongly-typed programming language to guarantee protection
    - Done in MODULA 3, more on this later
    - Kernel provides well-defined interfaces, similar in principle to function prototypes in a header file
    - Data abstractions provided by the programming language, such as an object, serve as containers for logical protection domains
        - removes reliance on hardware address spaces for protection
        - kernel provides only interfaces, these logical protection domains implement the functionality that is enshrined in the interfaces
    - Dynamic call bindings
        - provide multiple implementations of the interface functions
        - applications can dynamically bind to the different implementations, whichever one suits them best

## Logical Protection Domains

- Modula-3 Safety and Encapsulation Mechanisms
    - a strongly typed language
        - type safety, encapsulation
    - automatic storage management
    - objects
        - good encapsulation. only the entry points are visible outside the object, not the implementation
        - enforces good practices, does not allow “cheating” as is possible with e.g. C
    - threads
    - exceptions
    - generic interfaces
    - All of these serve well in implementing system protections as objects
        - the entry points serving as gates to what can be done allows protection of the object, in this case the kernel components
        - Generic interface mechanism allows multiple implementations of the same service, allowing apps to use whichever is best for them
- Fine-grained protection via capabilities
    - you can conceptualize various granularities of service/capability as objects or hierarchical objects
        - hardware resources (e.g. page frame)
        - interfaces (e.g. page allocation module)
        - collection of interfaces (e.g. entire VM)
- Capabilities as language-supported pointers
    - as noted above, the term ’capabilities’ in OS research refers to a heavyweight mechanism
    - however, because we are dealing here with a strongly-typed language bent to serve as an OS, capabilities to objects can be supported as pointers.
    - Thus, access to the resources (entry points to an object that is representing a specific resource) is provided via capabilities that are simply language-supported pointers
    - Therefore, these capabilities are much cheaper than those used by the Hydra OS
- Note (Quiz):
    - the difference between pointers in C and in Modula-3 is that Modula-3 pointers are type-specific
    - Modula-3 pointers cannot be forged. The only way you can use a pointer is to point to the same type of thing it was originally constructed with. No casting.
    - This is what provides the logical protection in the SPIN OS described above

## SPIN Mechanisms for Protection Domains

- create
    - init with object file contents and export names contained as entry point methods inside the object to be visible outside
        - example: memory management service can be created and names for it exported out to the rest of the OS
- Resolve
    - resolve names between source and target domains
        - very similar to linking two separately compiled files together, so they can access the names/symbols used in each other
        - Once resolved, resource sharing can be done at memory speeds.
- Combine
    - to create an aggregate domain from two smaller protection domains. union of all entry points of component domains.
- All the SPIN secret sauce comes from the compile-time checking of the MODULA-3 language allowing the enforcement of the protection of these domains and mechanisms.
## Customized OS with SPIN
![](/img/L02b_Customized_OS_with_SPIN.png)
- The upshot of the logical protection domain is the ability to extend SPIN to include OS services and make it all part of the same hardware address space
    - no border crossing between the services or the mechanisms provided by SPIN
- Above image shows example of multiple OS’s with different service selections implementing the same functionality differently, but using some shared extensions
## Example Extensions
![](/img/L02b_example_extension.png)
- UNIX Server implemented as an app on top of a normal UNIX OS on top of a SPIN extension
- A client-server application implemented directly on top of SPIN with extension interfaces to provide only functionality actually needed for client or server to function
## SPIN Mechanisms for Events

- An OS has to field external events
    - e.g. interrupts or a process incurring exceptions
- SPIN supports events using an event-based communication model
- Services register ’event handlers’ with the SPIN event dispatcher
    - SPIN supports both 1:1, 1:many, and many:1 mappings between events and handlers
- Walkthrough example of packet handling from ethernet or ATM via IP protocol, and may be passed to various paths (ICMP, TCP, UDP) and from there on out to various places as needed
    - these subsequent destinations may cause events themselves, and be passed on to their own handlers
- Order of handlers being scheduled is not reliable, in the case of multiple handlers for a given event (similar to POSIX thread ordering not being reliable)

## Default Core Services in SPIN

### Memory Management

- SPIN wants to allow extension to handle memory, and allocates it to them to do so
- Physical address
    - allocate, de-allocate, reclaim
- Virtual address
    - allocate, de-allocate
- Translation
    - create/destroy address spaces, add/remove mapping
- Event handlers
    - page fault, access fault, bad address

### CPU Scheduling

- SPIN global scheduler
    - SPIN only decides at a macro level the amount of time that is given to a particular extension
    - interacts with application threads package
- SPIN abstraction: strand
    - actual OS that extend SPIN map their threads to strands
    - unit of scheduling
    - semantics defined by extension
- event handlers
    - block, unblock, checkpoint resume

### Overall

- Each of the above should be instantiated as a logical protection domain, allowing address space sharing and the optimization that brings
- These functions are defined by core OS, but implemented by extensions. As in “header file” analogy above, where the extensions are the actual code, SPIN only provides the definitions
- Final note, somewhat unrelated: core services implemented as extensions are obviously high-risk and their applications must trust them, but one additional protection offered is that this trust must only be given to the specific extensions an app relies upon. Problems in other extensions do not affect that app.