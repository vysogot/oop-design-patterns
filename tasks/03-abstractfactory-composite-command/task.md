# Set 3:
C - Abstract Factory
S - Composite
B - Command

## Client
You work for a company that assembles products using various components. The components come in different sizes, colors, and types, and need to be managed efficiently to ensure smooth assembly. Currently, the component management system is manual and time-consuming, leading to mistakes and delays.

To solve this problem, you are tasked with implementing a component management system that automates the process and eliminates manual errors. The system should be able to create different types of components, manage them as a group, and perform actions on them such as adding, removing, and updating.

## Coding Task: Implement a Component Management System

Use the following object-oriented patterns to design and implement a component management system:
* Abstract Factory: Design a factory class that creates different types of components based on input parameters (e.g. type, size, color, etc.).
* Composite: Implement a composite class that represents a group of components and provides an interface for accessing and manipulating these components as a single object.
* Command: Implement a command class that represents an action to be performed on components, including adding, removing, and updating components.

### Implement the following functionalities in the Component class:
* Provide an interface for accessing and manipulating components.
* Support adding and removing components.
* Support updating components.

### Implement the following functionalities in the Factory class:
* Create different types of components based on input parameters.
* Provide a method to retrieve the created components.

### Implement the following functionalities in the Command class:
* Represent an action to be performed on components.
* Support undo and redo operations.