class CharacterFactory
  class AbilityNotFound < StandardError; end
  
  def self.create(type)
    begin 
      title = titleize(type)
      abilities_bridge = Module.const_get("#{title}Abilities")
      
      Character.new(type, abilities_bridge.new)
    rescue AbilityNotFound 
      raise AbilityNotFound, "No abilities known for a #{title}"
    end
  end

  private

  def self.titleize(string)
    string[0].upcase + string[1..-1]
  end
end

class CharacterAbilities
  attr_accessor :abilities, :current_ability
  
  def initialize
    @abilities = []
  end

  def add_ability(ability)
    abilities << ability
  end

  def remove_ability(ability)
    abilities.delete(ability)
  end

  def switch_ability(new_ability) 
    self.current_ability = abilities.find { |a| a.class == new_ability } 
  end
end

class Ability; end
class SwordStrike < Ability; end
class HelmetRush < Ability; end
class Fireball < Ability; end
class IceShower < Ability; end
class BowHit < Ability; end
class DeadlyArrow < Ability; end

class WarriorAbilities < CharacterAbilities
  def initialize
    super
    add_ability SwordStrike.new
    add_ability HelmetRush.new
    switch_ability SwordStrike
  end
end

class MageAbilities < CharacterAbilities
  def initialize
    super
    add_ability Fireball.new
    add_ability IceShower.new
    switch_ability IceShower 
  end
end

class ArcherAbilities < CharacterAbilities
  def initialize
    super
    add_ability DeadlyArrow.new
    add_ability BowHit.new
    switch_ability DeadlyArrow 
  end
end

class Character
  attr_reader :type, :abilities_bridge

  def initialize(type, abilities_bridge)
    @type = type
    @abilities_bridge = abilities_bridge
  end

  def current_ability
    abilities_bridge.current_ability
  end

  def abilities 
    abilities_bridge.abilities
  end

  def switch_ability(ability)
    abilities_bridge.switch_ability(ability)
  end
end

warrior = CharacterFactory.create(:warrior)
mage = CharacterFactory.create(:mage)
archer = CharacterFactory.create(:archer)

puts warrior.current_ability
warrior.switch_ability(HelmetRush)
puts warrior.current_ability