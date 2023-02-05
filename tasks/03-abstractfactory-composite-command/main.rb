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
      BigJet.new(color)
    when :small
      SmallJet.new(color)
    end
  end
end

class ShieldFactory
  def create(size, color)
    case size
    when :big
      WideShield.new(color)
    when :small
      TinyShield.new(color)
    end
  end
end

class Composite 
  attr_accessor :components
  
  def initialize
    @components = [] 
  end

  def add_component(child)
    child.parent = self
    components << child
  end
  
  def remove_component(child)
    child.parent = nil
    components.delete(child)
  end

  def update_component(child, attributes)
    child.update(attributes)
  end

  def build
    components.each { |component| component.build }
  end
end

class Component
  attr_accessor :parent
  attr_accessor :attributes

  def initialize(color)
    @attributes = { color: color }
  end
  
  def build
    NotImplementedError
  end

  def update(attributes)
    self.attributes.merge!(attributes)
  end
end

class BigJet < Component; def build; puts "Big jet plan" end; end
class SmallJet < Component; def build; puts "Small jet plan" end; end
class WideShield < Component; def build; puts "Wide shield plan" end; end
class TinyShield < Component; def build; puts "Tiny shield plan" end; end

class ComponentCommand
  attr_reader :composite
  
  def initialize(composite)
    @composite = composite
  end
  
  def execute; NotImplementedError; end
  def un_do; NotImplementedError; end
  def re_do; NotImplementedError; end
end

class AddComponent < ComponentCommand
  def execute(child)
    composite.add_component(child)
  end

  def un_do(child)
    composite.remove_component(child)
  end
end

class RemoveComponent < ComponentCommand
  def execute(child)
    composite.remove_component(child)
  end
end

class UpdateComponent < ComponentCommand
  def execute(child, attributes)
    composite.update_component(child, attributes)
  end
end

jet_factory = Factory.create(:jet)
shield_factory = Factory.create(:shield)

big_jet = jet_factory.create(:big, :blue)
wide_shield = shield_factory.create(:big, :yellow)

composite = Composite.new
composite.add_component(big_jet)
composite.add_component(wide_shield)

composite.build
