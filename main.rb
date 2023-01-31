# 16:20 – First I choke. Anxiety, imposter syndrome, and fear of failure. Then I say, have fun :-)
# 16:50 - I got all but adapter and error messaging and throwing some errors
# 17:01 - I have error handling with a wait on empty queue but nothing about the adapter
# 17:07 - What I think about most is how to handle the adapter, should I make many of them to avoid switch
# 17:21 - my throat hurts. My breath is not conrolled, it's shallow when I do it. It's been an hour, all the adapters are done.
# 17:34 - okay it's finished

class Logger
  class EmptyQueueError < StandardError; end
  
  attr_accessor :queue, :sources
  
  def self.instance
    @@logger ||= Logger.new
  end

  def log(message)
    queue << message   
  end

  def read
    raise EmptyQueueError if queue.empty?
    "#{Time.now} : #{queue.pop}"
  end
  
  private

  def initialize
    @queue = Queue.new
    @sources = []
  end
end

class FileLoggerAdapter
  attr_reader :file_name
  
  def initialize(file_name)
    @file_name = file_name
  end

  def format
    File.read(file_name)
  end
end

class FileSource
  def self.produce 
    name = "log#{rand(5)}.txt"
    
    file = File.open(name, "w") do |f|
      f.write "This is file #{name} #{rand(10)} and I say " \
        "#{(65..127).to_a.shuffle.sample(8).map(&:chr).join('')}"
    end
    
    name
  end
end

class NetworkLoggerAdapter
  attr_reader :payload
  
  def initialize(payload)
    @payload = payload
  end

  def format
    payload.map {|k, v| "#{k}: #{v}"}.join("; ")
  end
end

class NetworkSource
  def self.produce 
    {
      ip: "#{Array.new(4) { ip_rand }.join('.')}",
      msg: "#{rand(100)}"
    }
  end

  def self.ip_rand
    rand(256)
  end
end

class ConsoleLoggerAdapter
  attr_reader :command
  
  def initialize(command)
    @command = command
  end

  def format
    command.split(" saying ").join(" > ")
  end
end

class ConsoleSource
  def self.produce
    "#{%W(zsh bash sh).sample} saying ECHO sed & done"
  end
end

logger = Logger.instance
threads = []

logger_thread = Thread.new do
  loop do
    begin
      puts logger.read
    rescue Logger::EmptyQueueError
      sleep(1)
    end
  end
end

threads << logger_thread

[
  [FileLoggerAdapter, FileSource],
  [NetworkLoggerAdapter, NetworkSource], 
  [ConsoleLoggerAdapter, ConsoleSource]
].each do |adapter_class, source|
  threads << Thread.new do 
    loop do 
      logger.log(adapter_class.new(source.produce).format)
      sleep(rand(3))
    end
  end
end

threads.each(&:join)
