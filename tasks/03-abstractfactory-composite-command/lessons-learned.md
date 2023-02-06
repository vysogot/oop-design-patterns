### Soft
This time I had no inauspicious bodily reactions. I just learned about all three patterns and implemented them to solve the problem. Very good experience, I think it took me like 40 minutes.

### Hard
Abstract factory returns factories, just as factory method returns objects wanted.
Then composite is a collection of components. It's a wrapper for managing such collection. It's like a specialized but standalone bridge.
And then command. I guessed I learned most about command here. Command classes take an object on which they will execute their logic, a composite in this example. There can be many commands around the same object so a parent command class can encapsulate many methods, and `execute` or `call` etc. is the method to be implemented in its child classes.

But!

Doing the undo operation on the command needed some thought. First of all, how to implement it? Should I duplicate the composite in each command. And if so, then what about the versioning? Running another command and then undoing the first one would update the current version. Hmmm...

And with this I learned a lot about deep copying of the objects. I didn't use Marshalling as I want to keep it simple. So the trick was to copy both, the component object and its attributes. Also, as now the `object_ids` are different in the snapshots and in the actual composite, the `ids` had to be introduced.

This way, because I had to change the way I create objects in the component class, I also understood why making factories is important. The client code didn't change in terms of passing the color. All I had to do was adjusting the way objects are created in the factory. That is nice creational decoupling.