### Soft
1. Relax. There are so many factors that affect memory and productivity. One of them is being too anxious. So thirst thing, it's okay not to know. It's okay to try.

### Hard
1. Singleton is easy to implement and remember.
2. Adapter can be done in a couple of ways. But it's good to have a Single Responsibility adapter. And then the client code picks the one they want.
3. Similar story with the sources. Each source can pick their own adapter. They should be totally decoupled. So your guesses were right.
4. To generate an array of random values you need to instantiate it with a block.
5. Queue is a thread safe FIFO data structure that you can easily pop from. Good choice as your solution was in threads.
6. The easiest way to read all stuff from a file is just `File.read(file_name)`. I should have read it line by line I guess to avoid an issue with a big file.
7. \d for number, \w for letters numbers and underscores, \s for whitespace characters
8. Remember about error handing in such tasks. Make a nice error class, read the message in the rescue and ensure what's needed. Pass message to the parent in constructor.

### Improve
1. Remove all log files at exit of the program
2. Rework the observer direction