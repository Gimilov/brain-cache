---
tags:
  - type/lecture
  - "#AOS"
---
Created: 2024-12-30 19:04
Source: [LINK](https://andrewrepp.com/aos_lec_L05)

## Systems From Components

- VLSI technology uses component based approach to build large, complex hardware systems. Can we do the same for software?
    - Instead of starting from a clean slate, re-use software components?
    - Easier in a lot of ways, if possible. Lots of challenges, though, such as locality, redundancies, etc. 
### Design Framework
- ![](/img/L05e_systems_from_components_1.png)
- Design cycle
	- specify -> code -> optimize -> deploy
	- Specify: IOA (IO Automata)
	    - c-like syntax
	    - composition operator
	        - allows expressing specification of entire subsystem to be built
	- Code: ocaml
	    - object oriented
	        - also functional (no side effects)
	    - efficient code, similar to C
	        - important for systems programming, performance matters a lot.
	    - nice complemnet to IOA
	        - formal semantics available line up well
	- Optimize: NuPrl
	    - Framework for automatic optimization of ocaml code
	    - output verified to be functionally equivalent to the original ocaml code
	    - There’s no easy (formal) way to show that the ocaml implementation is the same as the IOA specification
### Implementing TCP/IP Stack Using Components

- Start with IOA Spec
    - Abstract Spec
    - Concrete Spec
- How to synthesize stack from concrete spec? Getting to an unoptimized ocaml implementation
    - Ensemble suite of microprotocols
        - flow control, sliding window, encryption, scatter/gather, etc
            - well-defined interfaces allowing composition
        - This allows flexibility and customization, and a component-based design
        - Needed protocols are selected using a heuristic and the provided behavior spec. This results in a functional but unoptimized protocol stack
            - Layering could lead to inefficiences. This is where the analogy to VSLI component-based design breaks down for software
- Optimizing
    - Several sources of optimization are available
        - Use explicit memory management instead of implicit garbage collection in ocaml
        - Avoid marshaling/unmarshaling across layers
        - Buffering in parallel with transmission
        - Header compression
            - Layers may each get their own headers with lots of shared fields that could be compressed into single representations
        - Locality enhancement for common code sequences
            - colocate code paths common across layers to improve cache hit rate
    - But manually doing all this would be very tedious. How to automate?
    - NuPrl to the rescue!
        - Static optimization
            - NuPrl expert and an ocaml expert sit together and work layer by layer through the protocol stack to use the above optimizations
            - Within each layer, not across layers at this stage.
            - Only a semi-automatic process
        - Dynamic optimizationm
            - Collapse layers
            - Uses the theorem-proving framework
                - Identifies common work happening in multiple layers
            - completely automatic
            - Generate bypass code if common case predicate (ccp) satisfied
	            - ![](/img/L05e_systems_from_components_2.png)
	            - CCP is basically how the protocol is supposed to react to any given event
        - Theorem prover framework can automatically prove that the bypass code creates the equivalent result as all the layers being bypassed would have. This means we get the same result but much faster.
- Final step – convert back to ocaml
    - Theorem prover framework can show that original and optimized ocaml code are equivalent, automatically
    - Again, though, this says nothing about verification of the code against the original IOA specs