class Logger
  class EmptyQueueError < StandardError
    def initialize(timestamp: Time.now)
      message = "Trying to read from an empty queue at #{timestamp}"
      super(message)
    end
  end
  
  attr_accessor :queue, :source, :sources
  
  def self.instance
    @@logger ||= Logger.new
  end

  def add_source(source)
    return if subscribed?(source)
    
    puts "#{source.name} subscribed"
    sources << source
  end

  def remove_source(source)
    return unless subscribed?(source)
    
    sources.delete(source)
    puts "#{source.name} unsubscribed"
  end

  def log(source, message)
    queue << message if subscribed?(source)
  end

  def subscribed?(source)
    sources.include?(source)
  end

  def read
    raise EmptyQueueError if queue.empty?
    
    "#{Time.now} : #{queue.pop}"
  end
  
  private

  def initialize
    @queue = Queue.new
    @sources = [:error]
  end
end

class FileLoggerAdapter
  def self.format(file_name)
    File.read(file_name)
  end
end

class FileSource
  def self.produce 
    file_name = generate_file_name
    
    File.open(file_name, "w") do |f|
      f.write generate_content
    end
    
    file_name
  end

  def self.generate_file_name
    "log#{rand(5)}.txt"
  end

  def self.generate_content
    "This is file #{name} #{rand(10)} and I say #{rand_string}"
  end

  def self.rand_string
    (65..127).to_a.sample(8).map(&:chr).join('')
  end
end

class NetworkLoggerAdapter
  def self.format(raw)
    raw.map {|key, value| "#{key}: #{value}"}.join("; ")
  end
end

class NetworkSource
  def self.produce 
    { ip: "#{ip_rand}", msg: "#{rand(100)}" }
  end

  def self.ip_rand
    Array.new(4) { rand(256) }.join('.')
  end
end

class ConsoleLoggerAdapter
  def self.format(raw)
    raw.split(" saying ").join(" > ")
  end
end

class ConsoleSource
  def self.produce
    "#{%W(zsh bash sh).sample} saying ECHO sed & done"
  end
end

class SourceSubscriber
  attr_reader :source, :logger
  
  def initialize(source)  
    @source = source
    @logger = Logger.instance 
  end

  def toggle
    case rand(5)
    when 0
      logger.remove_source(source)
    when 1
      logger.add_source(source)
    end
  end
end

# Runner

logger = Logger.instance
threads = []

logger_thread = Thread.new do
  loop do
    begin
      puts logger.read
    rescue Logger::EmptyQueueError => e
      puts e.message
      sleep(1)
    end
  end
end

threads << logger_thread

[
  [FileLoggerAdapter,    FileSource],
  [NetworkLoggerAdapter, NetworkSource], 
  [ConsoleLoggerAdapter, ConsoleSource]
].each do |adapter, source|
  threads << Thread.new do 
    source_subscriber = SourceSubscriber.new(source)
    
    loop do 
      source_subscriber.toggle
      raw = source.produce
      formatted = adapter.format(raw)

      logger.log(source, formatted)
      sleep(rand(3))
    end
  end
end

# at_exit { Dir.glob("*log*.txt").each { |path| p "remove"; File.delete(path) } }

threads.each(&:join)