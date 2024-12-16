---
tags:
  - type/moc
  - "#math"
---
Created: 2024-12-16 12:25
Source: [Readings in the course of Math for CS on MIT OCW](https://ocw.mit.edu/courses/6-042j-mathematics-for-computer-science-fall-2010/pages/readings/)

*"Many proofs follow one of a handful of standard templates."* ([source](https://ocw.mit.edu/courses/6-042j-mathematics-for-computer-science-fall-2010/resources/mit6_042jf10_chap02/)) 

*"Logical deductions or inference rules are used to prove new propositions using previously proved ones. A fundamental inference rule is 'modus ponens'. This rule says that a proof of $\mathit{P}$ together with a proof that $\mathit{P} \implies \mathit{Q}$  is a proof of $\mathit{Q}$ . Inference rules are sometimes written in a funny notation. For example, 'modus ponens' is written:
$$
\frac{\mathit{P}, \qquad \mathit{P} \implies \mathit{Q}}{\mathit{Q}}
$$
When statements above the line, called the 'antecedents', are proved, then we can consider the statement below the line, called the 'conclusion' or 'consequent', to also be proved."* ([source](https://ocw.mit.edu/courses/6-042j-mathematics-for-computer-science-fall-2010/resources/mit6_042jf10_chap02/))


# Templates:
### 1. Proof by Cases
##### Example
Every collection of 6 people includes a club of 3 people or a group of 3 strangers.

---

**Proof.**  
The proof is by case analysis. Let $x$ denote one of the six people. There are two cases:

1. Among the other 5 people besides $x$, at least 3 have met $x$.
2. Among the other 5 people, at least 3 have not met $x$.

Now we have to be sure that at least one of these two cases must hold, but that’s easy: we’ve split the 5 people into two groups, those who have shaken hands with $x$ and those who have not, so one of the groups must have at least half the people.

---

###### **Case 1**
Suppose that at least 3 people have met $x$.  
This case splits into two subcases:

- **Case 1.1**: Among the people who have met $x$, none have met each other.  
    Then the people who have met $x$ are a group of at least 3 strangers. So the Theorem holds in this subcase.
    
- **Case 1.2**: Among the people who have met $x$, some pair have met each other.  
    Then that pair, together with $x$, form a club of 3 people. So the Theorem holds in this subcase.
    

This implies that the Theorem holds in **Case 1**.

---

###### **Case 2**
Suppose that at least 3 people have not met $x$. 
This case also splits into two subcases:

- **Case 2.1**: Among the people who have not met $x$, every pair has met each other.  
    Then the people who have not met $x$ are a club of at least 3 people. So the Theorem holds in this subcase.
    
- **Case 2.2**: Among the people who have not met $x$, some pair have not met each other.  
    Then that pair, together with $x$, form a group of at least 3 strangers. So the Theorem holds in this subcase.
    
This implies that the Theorem also holds in **Case 2**, and therefore holds in all cases.

### 2. Proving an implication
##### 2.1 Assume $P$ is true
1. Write, "Assume $P$".
2. Show that $Q$ logically follows

##### 2.2 Prove by Contrapositive
$P \implies Q$ is logically equivalent to its *contrapositive* $¬Q \implies ¬P$ 
1. Write, "We prove the contrapositive:" and then state the contrapositive.
2. Proceed as in 2.1. 

### 3. Proving an "If and Only If"
##### 3.1 Prove Each Statement Implies the Other
The statement $P \iff Q$ is equivalent to the two statements $P \implies Q$ and $Q \implies P$. So you can prove an "iff" by proving two implications:
1. Write, "We prove P implies Q and vice-versa."
2. Write, "First, we show $P \implies Q$." Do this by one of the methods in section 2. 
3. Write "Now, we show $Q \implies P. Again, do this by one of the methods in section 2."

##### 3.2 Construct a Chain of IFFs
In order to prove that $P$ is true iff $Q$ is true:
1. Write, "We construct a chain of if-and-only-if implications."
2. Prove $P$ is equivalent to a second statement which is equivalent to a third statement and so forth until you reach $Q$. 
This method sometimes requires more ingenuity than 3.1, but the result can be a short, elegant proof.

### 4. Proof by Contradiction
1. Write, "We use proof by contradiction."
2. Write, "Suppose $P$ is false."
3. Deduce something known to be false (a logical contradiction)
4. Write, "This is a contradiction. Therefore, $P$ must be true."

### 5. Proof by Induction ([src](https://ocw.mit.edu/courses/6-042j-mathematics-for-computer-science-fall-2010/resources/mit6_042jf10_chap03/))
##### 5.1 The Well Ordering Principle
*"Every nonempty set of nonnegative integers has a smallest element."*

In general, to prove that "$P(n)$ is true for all $n \in \mathit{N}$ ", you:
1. Define the set, $\mathbb{C}$, of counterexamples to $P$ being true. Namely, define
$$
\mathbb{C} ::= \{n \in \mathbb{N} \quad | \quad P(n) \text{ is false}\}
$$
2. Use a proof by contradiction and assume that $\mathit{C}$  is nonempty.
3. By the Well Ordering Principle, there will be a smallest element, $n$, in $\mathbb{C}$.  
4. Reach a contradiction (somehow) - often by showing how to use $n$ to find another member of $\mathbb{C}$ that is smaller than $n$. (This is open-ended part of the proof task.)
5. Conclude that $\mathbb{C}$ must be empty, that is, no counterexamples exist. QED.

##### 5.2 Ordinary Induction
1. **State that the proof uses induction**. This immediately conveys the overall structure of the proof, which helps the reader understand your argument.
2. **Define an appropriate predicate $P(n)$.** The eventual conclusion of the induction argument will be that $P(n)$ is true for all nonnegative $n$. Thus, you should define the predicate $P(n)$ so that your theorem is equivalent to (or follows from) this conclusion. Often the predicate can be lifted straight from the proposition that you are trying to prove, as in the example above. The predicate $P(n)$ is called the *induction hypothesis.* Sometimes the induction hypothesis will involve several variables, in which case you should indicate which variable serves as $n$.
3. **Prove that $P(0)$ is true.** This is usually easy, as in the example above. This part of the proof is called the *base case* or *basis step.*
4. **Prove that $P(n)$ implies $P(n+1)$ for every nonnegative integer $n$.** This is called the *inductive step.* The basic plan is always the same: assume that $P(n)$ is true and then use this assumption to prove that $P(n+1)$ is true. These two statements should be fairly similar, but bridging the gap may require some ingenuity. Whatever argument you give must be valid for every nonnegative integer $n$, since the goal is to prove the implications $P(0) \rightarrow P(1)$, $P(1) \rightarrow P(2)$, $P(2) \rightarrow P(3)$, etc. all at once.
5. **Invoke induction.** Given these facts, the induction principle allows you to conclude that $P(n)$ is true for all nonnegative $n$. This is the logical capstone to the whole argument, but it is so standard that it’s usual not to mention it explicitly.

##### 5.3 Invariants
If you would like to prove that some property *NICE* holds for every step of a process, then it is often helpful to use the following method:
1. Define $P(t)$ to be the predicate that *NICE* holds immediately after step $t$ .
2. Show that $P(0)$ is true, namely that *NICE* holds for the start state.
3. Show that 
$$
\forall t \in \mathbb{N}. P(t) \implies P(t + 1)
$$
namely, that for any $t \ge 0$, if *NICE* holds immediately after step $t$, it must also hold after the following step.   

##### 5.4 Strong Induction
The only change from the ordinary induction principle (5.2.) is that strong induction allows you to assume more stuff in the inductive step of your proof! These extra assumptions can only make your job easier. Hence the name: **strong** induction.

Formulated as a proof:
$$
\text{Rule. Strong Induction Rule}
$$
$$
\frac{P(0), \qquad \forall n \in \mathbb{N}. (P(0) \land P(1) \land \cdots \land P(m)) \implies P(n+1)}{\forall m \in \mathbb{N}. P(m)}
$$
The template for strong induction proofs is identical to the template given in 5.2 for ordinary induction except for two things:
1. you should state that your proof is by strong induction, and
2. you can assume that $P(0), P(1), \cdots , P(n)$ are all true instead of only $P(n)$ during the inductive step. 

##### 5.5 Structural Induction
Structural induction is a method for proving that some property, $P$, holds for all the elements of a recursively-defined data type. The proof consists of two steps:
1. Prove $P$ for the **base cases** of the definition
2. Prove $P$ for the **constructor cases** of the definition, assuming that it is true for the component data items.

An example of the constructor case is seen in a very simple application of structural induction that proves that (recursively-defined) matched strings always have an equal number of left and right brackets. Let predicate $P$ be:
$$
P(s) ::= s \text{ has an equal number of left and right brackets}
$$
- **base case**: $P(\lambda)$ holds because the empty string has zero left and zero right brackets
- **constructor case**: For $r = [ s ] t$ , we must show that $P(r)$ holds, given that $P(s)$ and $P(t)$ holds.








# How to write a good proof?

1. State your game plan  
A good proof begins by explaining the general line of reasoning. For example, “We use case analysis” or “We argue by contradiction.”

2. Keep a linear flow  
Sometimes proofs are written like mathematical mosaics, with juicy tidbits of independent reasoning sprinkled throughout. This is not good. The steps of an argument should follow one another in an intelligible order.

3. A proof is an essay, not a calculation  
Many students initially write proofs the way they compute integrals. The result is a long sequence of expressions without explanation, making it very hard to follow. This is bad. A good proof usually looks like an essay with some equations thrown in. Use complete sentences.

4. Avoid excessive symbolism  
Your reader is probably good at understanding words but much less skilled at reading arcane mathematical symbols. So use words where you reasonably can.

5. Revise and simplify  
Your readers will be grateful.

6. Introduce notation thoughtfully  
Sometimes an argument can be greatly simplified by introducing a variable, devising a special notation, or defining a new term. But do this sparingly since you’re requiring the reader to remember all that new stuff. And remember to actually define the meanings of new variables, terms, or notations; don’t just start using them!

7. Structure long proofs  
Long programs are usually broken into a hierarchy of smaller procedures. Proofs are much the same. Facts needed in your proof that are easily stated, but not readily proved, are best pulled out and proved in their own lemmas. Also, if you are repeating essentially the same argument over and over, try to capture that argument in a general lemma, which you can invoke wherever you need it.

8. Be wary of the “obvious”  
When familiar or truly obvious facts are needed in a proof, it’s OK to label them as such and not to prove them. But remember that what’s obvious to you may not be—and typically is not—obvious to your reader.

Most especially, don’t use phrases like “clearly” or “obviously” in an attempt to bully the reader into accepting something you’re having trouble proving. Also, go on the alert whenever you see one of these phrases in someone else’s proof.

9. Finish  
At some point in a proof, you’ll have established all the essential facts you need. Resist the temptation to quit and leave the reader to draw the “obvious” conclusion. Instead, tie everything together yourself and explain why the original claim follows.