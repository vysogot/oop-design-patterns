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
    
    yield(worker) ? worker : (next_one { |w| yield(w) } if has_next?)
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

WORKERS = [
  Worker.new(speciality: "Bricks", weekdays: [1, 3, 4], working_hours: (9..17), type: "Mason"),
  Worker.new(speciality: "Bricks", weekdays: [1, 2, 5], working_hours: (6..12), type: "Mason"),
  Worker.new(speciality: "Pumps",  weekdays: [1, 3, 6], working_hours: (9..17), type: "Plumber"),
  Worker.new(speciality: "Taps",   weekdays: [1, 2, 5], working_hours: (7..15), type: "Plumber"),
  Worker.new(speciality: "HighVo", weekdays: [1, 3, 4], working_hours: (8..15), type: "Electrician"),
  Worker.new(speciality: "LowVol", weekdays: [1, 2, 5], working_hours: (9..12), type: "Electrician"),
]

cs = ConstructionSite.new(WORKERS)
wi = cs.iterator

while wi.has_next?
  
  # Dynamic filters. Previous version has static filters
  worker = wi.next_one { |w| 
    w.weekdays.include?(4) && 
    !(w.working_hours.to_a & (10..12).to_a).empty?
  }
  
  puts worker.to_s if worker
end

# =>
# Mason-Bricks: works on Mon, Wed, Thu from 9 to 17
# Electrician-HighVo: works on Mon, Wed, Thu from 8 to 15

require 'minitest/autorun'

class ConstructionSiteTest < Minitest::Test
  def test_iterator_filter_weekday
    cs = ConstructionSite.new(WORKERS)
    wi = cs.iterator
    worker = wi.next_one { |w| w.weekdays.include?(2) }

    assert_match "Mason-Bricks", worker.to_s
  end

  def test_iterator_filter_working_hours
    cs = ConstructionSite.new(WORKERS)
    wi = cs.iterator
    
    worker = wi.next_one { |w| w.working_hours.include?(10) }
    assert_match "Mason-Bricks", worker.to_s
    
    worker = wi.next_one { |w| w.working_hours.include?(10) }
    assert_match "Mason-Bricks", worker.to_s
    
    worker = wi.next_one { |w| w.working_hours.include?(10) }
    assert_match "Plumber-Pumps", worker.to_s
  end

  def test_iterator_filter_type
    cs = ConstructionSite.new(WORKERS)
    wi = cs.iterator
    worker = wi.next_one { |w| w.type == "Plumber" }

    assert_match "Plumber-Pumps", worker.to_s
  end

  def test_iterator_filter_no_match
    cs = ConstructionSite.new(WORKERS)
    wi = cs.iterator
    worker = wi.next_one { |w| w.weekdays.include?(7) }

    assert_nil worker
  end
end