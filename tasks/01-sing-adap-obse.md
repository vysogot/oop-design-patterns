## Coding Task: Implement a Logger System
Use the following object-oriented patterns to design and implement a logger system:

1. Singleton: Design the Logger class as a singleton, which means only one instance of the class can exist in the system.

2. Adapter: Implement an adapter class that will translate different log message sources (e.g. file, network, console) into a standard format that can be used by the Logger.

3. Observer: Design the Logger class to be an observer, which can observe different log message sources and log messages as they become available.

### Implement the following functionalities in the Logger class:
1. Get the singleton instance of the Logger class.
2. Store the log messages in a data structure (e.g. list, queue, etc.).
3. Provide a method to retrieve the log messages.
4. Support adding and removing log message sources.
5. Log messages from log message sources as they become available.

### Implement the following functionalities in the Adapter class:
Translate log messages from different sources into a standard format.
Provide a method to retrieve the translated log messages.

### Notes:
* You can use any programming language of your choice to implement the solution.
* You can use any data structure or library for storing the log messages, but make sure to implement the data structure or library yourself.
Deliverables:

* Source code.
* A brief explanation of the solution.
* A test plan and test results.

## Evaluation

### Time Expectation:
* Junior developer: 2-4 hours
* Mid-level developer: 1-2 hours
* Senior developer: 30 minutes to 1 hour


### Acceptable and Expected from each:

* Junior developer: A working implementation with basic functionalities described in the task. They should demonstrate a clear understanding of the singleton and adapter patterns.
* Mid-level developer: A working implementation with proper error handling and robustness. They should demonstrate a good understanding of the observer pattern and show how it can be used in the Logger system.
* Senior developer: A working implementation with high performance, scalability, and maintainability.

They should provide optimized solutions and demonstrate an in-depth understanding of the OOP patterns and how they can be applied in the Logger system.

### Note
The above time and expectations may vary based on the developer's individual skills and experience.