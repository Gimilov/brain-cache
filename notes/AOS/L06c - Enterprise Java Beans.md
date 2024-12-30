---
tags:
  - type/lecture
  - "#AOS"
---
Created: 2024-12-30 19:30
Source: [LINK](https://andrewrepp.com/aos_lec_L06)
Read more here: [[Illustrated Notes for AOS by Bhavin Thaker]]
## Enterprise Java Beans

- How do we structure the system software for a large-scale distributed system service?
- Java Bean == reusable software component
- N-tier applications
	- ![[L06c_enterprise_java_beans_1.png]]
	- application comprised of a stack of layers that each perform separate responsibilities
    - Can reuse components for each layer of the stack, as at each layer there are many similarities across applications and across requests for any given application
    - Reduce network communication (latency), security risks, increase concurrency for handling an individual request.
        - Many such applications are embarassingly parallel, can leverage this for performance
- Example framework
    - There are four containers (roughly equivalent to protection domains)
        - Client container
        - Applet container
            - resides on web server
            - interacts with the browser
        - Web container
            - contains presentation logic (e.g. web pages)
        - EJB container
            - contains business logic
            - Talks to DB server as needed
    - Beans – a unit of reuse
        - Example – the shopping cart function
        - Containers above host the beans
        - 3 types of beans
            - Entity
                - e.g. a row in a database
                - usually persistent objects with primary keys
                - persistence may be built into the bean itself or built into the container into which the entity bean is instantiated
            - Session
                - Associated with a particular client and session (temporal window over which a client is interacting with the service)
                - Can be a stateful session bean or a stateless session bean
            - Message
                - Useful for asynchronous behavior
                - example: stock ticker, RSS feed
        - Can be more or less granular, which affects reusability
            - finer grained is better for reusability, but requires more complex business logic
            - ![[L06c_enterprise_java_beans_2.png]]
	            - Does not allow appropriate concurrency for this use case
			- ![[L06c_enterprise_java_beans_3.png]]
				- Entity bean may be responsible for one row of the DB, or a set of rows. Up to the designer.
				- CMP == container-managed persistence
				- BMP == bean-managed persistence
			- ![[L06c_enterprise_java_beans_4.png]]
				- Associate a session facade with each client session. This allows you to construct a session and associate it with a particular client
				- Using RMI allows entity bean to be placed wherever we want in network. Using local requires colocation with business logic and session facade, but avoids network communication and so improves performance.