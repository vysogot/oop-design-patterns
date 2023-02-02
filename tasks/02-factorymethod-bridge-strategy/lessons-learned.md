### Soft
Feelings of discomfort will come. Especially when you try to be quick and you don't know the patterns well enough. So you need to make it through this. Heaviness in the chest may be there together with the enthusiasm. When your self-evaluation is negative the problem is soon to emerge. Talk back positively whatever tries to play you down.

### Hard
Factory Method pattern looks silly with the case (switch). You can add some polymorphism with `Module.const_get` to get the class from it's name. But be careful not to rescue it with the `NameError` cause it may supress bad method calls. Better to come up with your own error class (btw. people love it on the interviews).

To titleize, which is a Rails term, is simply to join the first uppercased element (if many then split by space) and join it with rest of the string. It's an array so it's instant.

Now, Bridge. So bridge is like when you have a gap and you need some object to fill it. For example a `Cup` can have many things inside. It may have an attribute `:content` in it. But with bridge pattern you'd need a `content_manager` so to speak, or `ContentService`. It will do all the stuff that you'd do with the content. So then you simply delegate to these from the `Cup`.

Strategy is when you want to change the service. So you can connect it, like the `ContentService` may use different `ContentProviders` or the `Cup` may have different `ContentServices`. It about how you handle the substitution of that service that makes it a Strategy pattern. It's more behavioral than the Bridge cause you can do it on the fly. And of course you can join these two in one class.

Bridge is essencially when you delegate. Your call drives through the bridge from the abstract class to the implementation class.