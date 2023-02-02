## Client
As a growing company, we need to have a reliable and efficient logging system to keep track of our operations. Currently, we are facing difficulties in managing log messages from various sources and retrieving them in a standardized format.

We need a solution that can store log messages from different sources, translate them into a standard format, and provide a method to retrieve the logs. It is important that the solution can support adding and removing log message sources, and log messages as they become available.

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