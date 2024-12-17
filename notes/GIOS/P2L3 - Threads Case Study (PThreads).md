---
tags:
  - GIOS
  - type/lecture
---
Created: 2024-09-11 10:01
# Lecture Notes
- `PThreads` == POSIX Threads`
- `POSIX` == Portable Operating System Interface. It basically describes the system call interface that OS need to support. Its intent is to increase interoperability among OSes.
- `POSIX Threads` 
	- POSIX versions of Birell's API
	- specifies syntax and semantics of operations
	- describes threading-related API that OS need to support


### PThread Creation
![](/img/P2L3-pthread-creation-comparison.png)
- in `pthread_create`: 
	- `start_routine` is equivalent to `proc` in `Fork`.  
	- `arg` is equivalent to `args` in `Fork`.
	- `attr` is used to specify certain things about the thread that the pthreads library will need to take into consideration when managing the thread. 
	- returns status information (`int`)
-  in `pthread_join`:
	- takes in thread structure to be joined
	- as well as the status variable `status`. It captures all of the relevant return information, as well as the results that are returned from the thread. 
	- returns a status that indicates whether the join was successful.

##### PThread Attributes
As shown above, in:
```c
int pthread_create(pthread_t *thread,
				  const pthread_attr_t *attr,
				  void * (*start_routine)(void *),
				  void *arg)); 
```
 ... we have `pthread_attr_t *attr` . This type:
 - specified in `pthread_create`
 - defines features of the new thread. For example:
	 - stack size, inheritance, **joinable**, scheduling policy, priority, system/process scope etc.
- has default behavior with `NULL` in `pthread_create` ($\uparrow$)

There are several calls that support operations on Pthread Attributes:
- `int pthread_attr_init(pthread_attr_t *attr);` - create and initialize attribute data structure
- `int pthread_attr_destroy(pthread_attr_t *attr);` - destroy it and free that data structure from memory
- `pthread_attr_{set/get}{attribute}` - allows us to either set the value of an attribute field or to read that value.

 One attribute that requires specific attention is attribute "**joinable**". See below.

##### Detaching Pthreads
This mechanism was not considered by Birrell. In there, the parent thread should not exit until the children threads have completed their execution and have been joined via the explicit `join` operation.  Children may turn into zombies!
![](/img/P2L3-detaching-pthreads-birrell-comp.png)
In PThreads, there's a possibility for the children threads to be detached from the parent. **Once detached, these threads cannot be joined**. If a parent exits, these children are free to continue their execution. These threads are basically the same, with the exception of the parent having some additional information on the children they've created. We can using `int pthread_detach();` or we can create threads as detached threads using the attribute DETACHED state:
```c
pthread_attr_setdetachstate(attr,
						   PTHREAD_CREATE_DETACHED);

// ...
// ...

pthread_create(..., attr, ...);
```
Since the parent thread do not need now for the child to complete, it can simply call `void pthread_exit();`.

Example of using PThreads attributes:
```c
#include <stdio.h>
#include <pthread.h>

void *foo (void *arg) { /* thread main */
	printf("Foobar!\n");
	pthread_exit(NULL);
}

int main (void) { 
	int i;
	pthread_t tid;

	pthread_attr_t attr;
	pthread_attr_init(&attr); /* required!!! */
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
	pthread_attr_setscope(&attr, PTHREAD_SCOPE_SYSTEM);
	pthread_create(&tid, &attr, foo, NULL);

	return 0;
}
```



### Compiling PThreads
1. `#include <pthread.h>` in main file
2. Compile source with `-lpthread` or `-pthread`:
```c
Intro to OS ~ ==> gcc -o main main.c -lpthread
Intro to OS ~ ==> gcc -o main main.c -pthread
```
3. Check the return values of common functions.


### PThread Creation Example 1
```c
#include <stdio.h>
#include <pthread.h>
#define NUM_THREADS 4

void *hello (void *arg) { /* thread main */
	printf("Hello Thread \n");
	return 0;
}

int main (void) {
	int i;
	pthread_t tid[NUM_THREADS];
	for (i = 0; i < NUM_THREADS; i++) { /* create/fork threads */
		pthread_create(&tid[i], NULL, hello, NULL);
	}
	for (i = 0; i < NUM_THREADS; i++) { /* wait/join threads */
		pthread_join(tid[i], NULL);
	}
	return 0;
}
```

### PThread Creation Example 2
```c
#include <stdio.h>
#include <pthread.h>
#define NUM_THREADS 4

void *threadFunc(void *pArg) { /* thread main */
	int *p = (int *)pArg; // private var
	int myNum = *p;       // private var
	printf("Thread number %d\n", myNum);
	return 0;
}

int main(void) {
	int i;
	pthread_t tid[NUM_THREADS];
	for(i = 0; i < NUM_THREADS; i++) { /* create/fork threads */
		pthread_create(&tid[i], NULL, threadFunc, &i);	
	}
	for(i = 0; i < NUM_THREADS; i++) { /* wait/join threads */
		pthread_join(tid[i], NULL);
	}
	return 0;
}
```

### PThread Creation Example 3
From the previous quiz, we saw it was possible that the code above (example 2) could have printed `i=2` twice! It could yield the result such as:
```c
Thread number 0
Thread number 2
Thread number 2
Thread number 3
```
Why?
- `i` is defined in main => **it's globally visible variable!**
- when it changes in one thread => all other threads see new value!
- the above case may happen when before the thread executes (and print), the loop in main may be already in the next iteration!
- **data race** or **race condition** => **a thread tries to read a value, while another thread modifies it!**
To correct the problem, let's implement the private copy of the index `i` in the form of `tNum`:
```c
// ...
#define NUM_THREADS 4

void *threadFunc(void *pArg) { /* thread main */
	int myNum = *((int *)pArg);       // private var
	printf("Thread number %d\n", myNum);
	return 0;
}

int main(void) {
	int tNum[NUM_THREADS];
	// ...
	for (i = 0; i < NUM_THREADS; i++) {/* create/fork threads */
		tNum[i] = i;
		pthread_create(&tid[i], NULL, threadFunc, &tNum[i]);
	}
	// ...
}
```


### PThread Mutexes
"to solve mutual exclusion problems among concurrent threads".
![](/img/P2L3-pthreads-vs-birell.png)
... for example:
```c
// BIRRELL
list<int> my_list;
Mutex m;
void safe_insert(int i) {
	Lock(m) {
		my_list.insert(i);
	}
}

// PTHREADS
list<int> my_list;
pthread_mutex_t m;
void safe_insert(int i) {
	pthread_mutex_lock(m);
	my_list.insert(i);
	pthread_mutex_unlock(m);
}
```
PThreads supports a number of other mutex-related operations. For example:
- mutexes must be explicitly initialized. The following operation allocates a mutex data structure and also specifies its behaviour.
```c
int pthread_mutex_init(pthread_mutex_t *mutex,
					  const pthread_mutexattr_t *attr);
// mutex attributes == specifies mutex behavior when 
// a mutex is shared among processes. NULL for default values.
// Default behaviour would make mutex private to the process,
// thus only visible among the threads among the process.
// We can change that and make sure that mutex can be shared with 
// other processes.
```
- unlike the lock operation which will block the calling thread if the mutex is in use, the **trylock** will check the mutex and if it isn't used, it will actually return immediaely and it will notify the calling thread that the mutex is not available. If the mutex is free, trylock will result in the mutex successfully being locked. However, if the mutex is locked, trylock wil not block the calling thread. This gives the calling thread an option to go and do something else and perhaps come back a little bit later to check if the mutex is free
```c
int pthread_mutex_trylock(pthread_mutex_t *mutex);
```
- we should also make sure that we free up any PThread-related data structures and for mutexes. For mutexes, for instance, we have the following:
```c
int pthread_mutex_destroy(pthread_mutex_t *mutex);
```
- ... and many others.

##### PThreads - Mutex Safety Tips
1. **shared data should always be accessed through a single mutex!**
2. mutex scope must be visible to all! (global variable)
3. globally order locks
	- for all threads, lock mutexes in order
4. always unlock a mutex
	- always unlock the **correct mutex**.



### PThread Condition Variables
![](/img/P2L3-pthreadsvs-birell-condition-variables.png)
There also some other operations used in conjunction with condition variables. For example:
- init to allocate the data structure for the condition and in order to initialize its attributes. Similarly to mutexes, we can specify the behavior that PThreads provides with conditions. For example, whether the condition variable will be used only within threads that belong to a single process or also shared across processes. NULL will result in default behaviour (condition variable private to a process).
```c
int pthread_cond_init(pthread_cond_t *cond,
					 const pthread_condattr_t *attr);
// attributes -- e.g., if it's shared
```
- free resources allocated for condition variable
```c
int pthread_cond_destroy(pthread_cond_t *cond);
```

##### Condition Variable Safety Tips
1. Don't forget to notify waiting threads!
	- **predicate change** => signal/broadcast **correct** condition variable
2. When in doubt => broadcast
	- but **performance loss**
3. You do not need a mutex to signal/broadcast. It may sometimes be appropriate to remove that signal and broadcast operation until after we've unlocked the mutex.


### Producer/Consumer Example in PThreads

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define BUF_SIZE 3		/* Size of shared buffer */

int buffer[BUF_SIZE];  	/* shared buffer */
int add = 0;  			/* place to add next element */
int rem = 0;  			/* place to remove next element */
int num = 0;  			/* number elements in buffer */

pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;  	/* mutex lock for buffer */
pthread_cond_t c_cons = PTHREAD_COND_INITIALIZER; /* consumer waits on this cond var */
pthread_cond_t c_prod = PTHREAD_COND_INITIALIZER; /* producer waits on this cond var */

void *producer (void *param);
void *consumer (void *param);

int main(int argc, char *argv[]) {

	pthread_t tid1, tid2;  /* thread identifiers */
	int i;

	/* create the threads; may be any number, in general */
	if(pthread_create(&tid1, NULL, producer, NULL) != 0) {
		fprintf(stderr, "Unable to create producer thread\n");
		exit(1);
	}

	if(pthread_create(&tid2, NULL, consumer, NULL) != 0) {
		fprintf(stderr, "Unable to create consumer thread\n");
		exit(1);
	}

	/* wait for created thread to exit */
	pthread_join(tid1, NULL);
	pthread_join(tid2, NULL);
	printf("Parent quiting\n");

	return 0;
}

/* Produce value(s) */
void *producer(void *param) {

	int i;
	for (i=1; i<=20; i++) {
		
		/* Insert into buffer */
		pthread_mutex_lock (&m);	
			if (num > BUF_SIZE) {
				exit(1);  /* overflow */
			}

			while (num == BUF_SIZE) {  /* block if buffer is full */
				pthread_cond_wait (&c_prod, &m);
			}
			
			/* if executing here, buffer not full so add element */
			buffer[add] = i;
			add = (add+1) % BUF_SIZE;
			num++;
		pthread_mutex_unlock (&m);

		pthread_cond_signal (&c_cons);
		printf ("producer: inserted %d\n", i);
		fflush (stdout);
	}

	printf("producer quiting\n");
	fflush(stdout);
	return 0;
}

/* Consume value(s); Note the consumer never terminates */
// the consumer **never terminates** because it operates in a continuous while(1) loop.
void *consumer(void *param) {

	int i;

	while(1) {

		pthread_mutex_lock (&m);
			if (num < 0) {
				exit(1);
			} /* underflow */

			while (num == 0) {  /* block if buffer empty */
				pthread_cond_wait (&c_cons, &m);
			}

			/* if executing here, buffer not empty so remove element */
			i = buffer[rem];
			rem = (rem+1) % BUF_SIZE;
			num--;
		pthread_mutex_unlock (&m);

		pthread_cond_signal (&c_prod);
		printf ("Consume value %d\n", i);  fflush(stdout);

	}
	return 0;
}
```