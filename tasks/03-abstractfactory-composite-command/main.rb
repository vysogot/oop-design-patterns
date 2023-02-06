class Factory
  def self.create(type)  
    case type
    when :jet
      JetFactory.new
    when :shield
      ShieldFactory.new
    end
  end
end

class JetFactory
  def create(size, color)
    case size
    when :big
      BigJet.new(color: color)
    when :small
      SmallJet.new(color: color)
    end
  end
end

class ShieldFactory
  def create(size, color)
    case size
    when :big
      WideShield.new(color: color)
    when :small
      TinyShield.new(color: color)
    end
  end
end

class Composite 
  attr_accessor :components
  
  def initialize
    @components = [] 
  end

  def add_component(component)
    component.parent = self
    components << component
  end
  
  def remove_component(component)
    child = find(component.id)
    return unless child
    
    child.parent = nil
    components.delete(child)
  end

  def update_component(component, attributes)
    child = find(component.id)
    return unless child

    child.update(attributes)
  end

  def build
    components.each { |component| component.build }
  end

  def make_snapshot
    components_copy = components.map(&:deep_copy)
    { components: components_copy }
  end

  def find(id)
    components.find { |component| component.id == id }
  end

  def recover(snapshot)
    snapshot.each do |attr, value|
      self.send("#{attr}=", value)
    end
  end
end

class Component
  attr_reader :id
  attr_accessor :parent, :attributes

  @@id = 1

  def initialize(attributes = {})
    @id = new_id 
    @attributes = attributes
  end

  def deep_copy
    self_copy = self.dup 
    self_copy.attributes = attributes.dup
    
    self_copy
  end
  
  def build
    NotImplementedError
  end

  def update(new_attributes)
    self.attributes.merge!(new_attributes)
  end

  def to_s
    "#{self.class.name} #{attributes}"
  end

  private

  def new_id
    @@id += 1
  end
end

class BigJet < Component;     def build; puts "#{self} engine plan" end; end
class SmallJet < Component;   def build; puts "#{self} construction" end; end
class WideShield < Component; def build; puts "#{self} harting" end; end
class TinyShield < Component; def build; puts "#{self} cutting" end; end

class ComponentCommand
  attr_reader :composite
  attr_accessor :snapshot
  
  def initialize(composite)
    @composite = composite
  end

  def execute(child, attributes = {})
    save_snapshot
    attributes.empty? ? call(child) : call(child, attributes)
  end

  def save_snapshot
    self.snapshot = composite.make_snapshot
  end
  
  def undo
    composite.recover(snapshot)
  end
  
  def call; NotImplementedError; end
end

class AddComponent < ComponentCommand
  def call(child)
    composite.add_component(child)
  end
end

class RemoveComponent < ComponentCommand
  def call(child)
    composite.remove_component(child)
  end
end

class UpdateComponent < ComponentCommand
  def call(child, attributes)
    composite.update_component(child, attributes)
  end
end

jet_factory = Factory.create(:jet)
shield_factory = Factory.create(:shield)

big_jet = jet_factory.create(:big, :blue)
wide_shield1 = shield_factory.create(:big, :yellow)
wide_shield2 = shield_factory.create(:big, :dark)

# without commands 
composite = Composite.new
composite.add_component(big_jet)
composite.add_component(wide_shield1)
composite.add_component(wide_shield2)
composite.remove_component(wide_shield1)

p composite.components.map(&:to_s)

# with commands
puts "adding yellow wide shield"
adding = AddComponent.new(composite)
adding.execute(wide_shield1)
p composite.components.map(&:to_s)

puts "undo adding"
adding.undo
p composite.components.map(&:to_s)

puts "removing dark wide shield"
removing = RemoveComponent.new(composite)
removing.execute(wide_shield2)
p composite.components.map(&:to_s)

puts "undo removing"
removing.undo
p composite.components.map(&:to_s)

puts "updating big jet color"
updating = UpdateComponent.new(composite)
updating.execute(big_jet, color: :cream)
p composite.components.map(&:to_s)

puts "undo updating"
updating.undo
p composite.components.map(&:to_s)

composite.build