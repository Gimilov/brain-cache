---
tags:
  - type/lecture
  - "#AOS"
---
Created: 2024-12-30 19:24
Source: [LINK](https://andrewrepp.com/aos_lec_L06)
Read more here: [[Illustrated Notes for AOS by Bhavin Thaker]]

## Java RMI
This topic is also partially covered in [[P4L1 - Remote Procedure Calls]].

### Java History

- Inveted by James Gosling at Sun
- Originally called Oak, later Java
- Originally intended for use with PDAs, then for set-top boxes, and then onto the Internet for e-commerce

### Java Distributed Object Model

- Remote Object
    - Accessible from different address spaces
- Remote Interface
    - Declarations for methods in a remote object
- Failure Semantics
    - Clients deal with RMI exceptions
- Similarities/differences to local objects
    - Similarity: object references can be passed as parameters
    - Difference: parameters only passed as value/result in the distributed object model

### Implementation in Java of Distributed Object Model

#### Bank Example 1 - Reuse a local implementation

- ![[L06b_java_rmi_1.png]]
- The remote publication of the interface is easy, using Java’s magic “remote” interface. The heavy lifting here is all done by the implementation of the bank account. Must find a way to make the location of the service visible by the clients on the network.

#### Bank Example 2 - Reuse of “Remote” (better approach)
- ![[L06b_java_rmi_2.png]]
- As before, publish methods to network using Remote interface
- When you instantiate the implementation object, it becomes instantly visible because we inherit from the remote object classes. Heavy lifting is done by the Java runtime with this approach.
    - This is not overly clear, even in the video. Review the GIOS notes for more detail.
    - Server Side
	    - ![[L06b_java_rmi_3.png]]
	- Client Side
		- ![[L06b_java_rmi_4.png]]
		- This has one big problem: if the invokation fails, it is not always possible to tell where in the process it failed. This is a common problem in networked applications
### RMI Implementation - RRL
- ![[L06b_java_rmi_5.png]]
- Remote Reference Layer (RRL)
	- Where the magic happens. All the marshaling/unmarshaling of arguments done here.
	- RRL functions similarly to a subcontract. All the complexity and detail hidden there, tucked away from the clients and servers.
### RMI Implementation - Transport
- ![[L06b_java_rmi_6.png]]
- Endpoint
    - Protection domain (or a JVM)
    - Has a table of remote objects it can access
- Connection Management
    - Responsible for setup, teardown, listen
        - Responsible for locating correct dispatcher that can handle a given invokation
    - Liveness monitoring
    - Coice of transport mechanism
        - e.g. UDP vs TCP
        - Decided by RRL, communicated to connection manager