---
tags:
  - "#AOS"
  - type/lecture
---
Created: 2025-02-21 15:17
Lecture: [[L05d - Active Networks]]
Summary source: [link](https://medium.com/ra-1/the-x-kernel-77742ad049ae)

# Introduction

The paper describes a new operating system kernel, called the x-kernel which:

1. provides an explicit architecture for constructing and implementing network protocols
2. is general enough to accommodate a wide range of protocols while being efficient enough to perform competitively with less structured operating systems
# Background

The paper discusses two types of operating system kernels with respect to the implementation of network protocols:

1. Systems like V-kernel, which support a fixed set of protocols known a priori
2. Systems like Mach, which view every protocol as an application implemented on top of the kernel

The systems of the first type provide no flexibility in extending the capabilities of the operating system later, whereas, systems of the second type, though provide full flexibility, lack the backbone infrastructure for the efficient implementation of network protocols, and are unable to leverage the kernel support not available to user-space applications
# Key Architectural Contributions

## System calls and Upcalls

The x-kernel is symmetric in the sense that a process running in user mode is allowed to change to the kernel mode by a system call, and a process executing in kernel mode is allowed to invoke a user-level procedure through an upcall.

Since the user-level procedures are untrusted and may run into infinite loops, the number of outstanding upcalls to a user address space is limited

## Support Routines

**Buffer Manager:** To manipulate messages sent and received over the network in adding or truncating headers, fragment or combine messages, etc

**Map Manager:** To provide a facility to map identifiers from one to another. This enables x-kernel to maintain constant performance as the number of ports increases by maintaining a map from the participating entities to the corresponding session.

**Event Manager:** To specify a timer event to be called at some future time

The x-kernel provides efficient support for these routines which are used by all protocols. In other systems like Unix, such support is ad hoc
## Communication Objects

The x-kernel views a protocol as a specification of a communication abstraction, though which systems or processes exchange messages or data. It makes little to no assumptions about a protocol beyond this primary consideration, thereby laying down only the basic structure which can be used for the development of a wide variety of protocols. It provides three primitive communication objects to support this model

1. Each **protocol object** corresponds to a network protocol. They are created and initialized at the kernel boot time
2. A **session object** corresponds to the end-point of a network connection, that is, it interprets messages and maintains state information associated with a connection
3. **Message objects** are active objects that move through the session and protocol objects in the kernel. The data they contain corresponds to the protocol headers and the user data
## Process Per Message Paradigm

1. Processes are associated with messages rather than protocols
2. Enables the delivery of messages from a user process to a network device (and vice versa) with no context switches (as opposed to the process per protocol paradigm)
3. In process per protocol, the message queue enforces a linear ordering of messages, which is suitable for TCP, but overly restrictive for protocols like UDP. In comparison, the process per message paradigm enforces no order on the receipt of messages.
4. Permits more parallelism, and hence, better suited for multiprocessor environments
# Performance Comparison
![](/img/L05d_active_networks_7.png)
Hence, we observe that the implemented architecture outperforms the existing common architecture on almost all parameters. The incremental cost on TCP (in Table IV) is nearly same because the Unix socket abstraction is specially tailored for TCP, and in fact, coercing other protocols like IP and UDP into this abstraction involves additional cost.

Also, the structure and the uniform interface to protocols provided by x-kernel makes it possible to estimate and predict the performance while designing new protocols

# Shortcomings

1. Crossing from kernel to user mode by an upcall is expensive (an order of magnitude higher than from user to kernel) because there is no hardware analog of a system trap in the case of upcalls
2. Despite the many advantages, however, the x-kernel’s architecture limits a given protocol’s ability to access information about other protocols. Instead of some direct mechanism to look up such information (like global data structures), it relies on invoking control operations to obtain this information. But since in most cases, a relatively small number of control operations are sufficient, this is often overlooked.
3. The support to such a wide range of protocols is extremely valuable in a research environment. However, it may not be very relevant in everyday use to regular users and we may have a better-optimized kernel system supporting a smaller set of selected protocols.

## Paper:
See underlined sections for quick reading (if any).
![](03_xkernel.pdf)