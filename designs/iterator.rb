# PL: Napisz program, który będzie symulował plac budowy. Na placu budowy pracują różni pracownicy, którzy mogą być murarzami, elektrykami, czy hydraulikami. Program powinien udostępniać interfejs do przeglądania listy pracowników, oraz pozwalać na filtrowanie ich według różnych kryteriów takich jak: specjalności, dni tygodnia, czy godziny pracy.
# EN: Write a program to simulate a construction site. A variety of workers work on a construction site, who may be bricklayers, electricians or plumbers. The program should provide an interface for browsing the list of employees and filtering them according to various criteria, such as: specialties, days of the week, or working hours.

class ConstructionSite
  attr_reader :workers, :worker_types
  
  def initialize(workers)
    @workers = workers
  end

  def iterator
    WorkersIterator.new(workers)
  end
end

class WorkersIterator
  attr_reader :workers
  attr_accessor :index
  
  def initialize(workers)
    @workers = workers   
    @index = 0
  end

  def has_next?
    index < workers.size 
  end

  def next_one(filters = {})
    worker = workers[index]
    @index += 1
    
    matches?(worker, filters) ? worker : (next_one(filters) if has_next?)
  end

  def matches?(worker, filters)
    if filters[:working_hours]
      return false if (worker.working_hours.to_a & filters[:working_hours].to_a).empty?
    end
    
    if filters[:weekdays]
      return false if (worker.weekdays & filters[:weekdays]).empty?
    end

    true
  end
end

DAYNAMES = %W(Mon Tue Wed Thu Fri Sat Sun)

class Worker
  attr_reader :speciality, :weekdays, :working_hours, :type

  def initialize(speciality:, weekdays:, working_hours:, type:)
    @speciality = speciality
    @weekdays = weekdays
    @working_hours = working_hours
    @type = type
  end

  def to_s
    "#{type}-#{speciality}: works on #{weekday_names} #{working_hours_string}"
  end

  def weekday_names
    weekdays.map { |wd| DAYNAMES[wd - 1] }.join(', ')
  end

  def working_hours_string
    "from #{working_hours.first} to #{working_hours.last}"
  end
end

workers = [
  Worker.new(speciality: "Bricks", weekdays: [1, 3, 4], working_hours: (9..17), type: "Mason"),
  Worker.new(speciality: "Bricks", weekdays: [1, 2, 5], working_hours: (6..12), type: "Mason"),
  Worker.new(speciality: "Pumps",  weekdays: [1, 3, 6], working_hours: (9..17), type: "Plumber"),
  Worker.new(speciality: "Taps",   weekdays: [1, 2, 5], working_hours: (7..15), type: "Plumber"),
  Worker.new(speciality: "HighVo", weekdays: [1, 3, 4], working_hours: (8..15), type: "Electrician"),
  Worker.new(speciality: "LowVol", weekdays: [1, 2, 5], working_hours: (9..12), type: "Electrician"),
]

cs = ConstructionSite.new(workers)
wi = cs.iterator
filters = { weekdays: [4], working_hours: (10..12) }

while wi.has_next?
  worker = wi.next_one(filters)
  puts worker.to_s if worker
end

# =>
# Mason-Bricks: works on Mon, Wed, Thu from 9 to 17
# Electrician-HighVo: works on Mon, Wed, Thu from 8 to 15