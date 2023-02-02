class CharacterFactory
  class AbilityNotFound < StandardError; end
  
  def self.create(type)
    begin 
      title = titleize(type)
      abilities_service = Module.const_get("#{title}Abilities")
      
      Character.new(type, abilities_service.new)
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
  attr_reader :type, :abilities_service

  def initialize(type, abilities_service)
    @type = type
    @abilities_service = abilities_service
  end

  delegate :current_ability, :abilities, :switch_ability, 
    to: abilities_service
end

warrior = CharacterFactory.create(:warrior)
mage = CharacterFactory.create(:mage)
archer = CharacterFactory.create(:archer)

puts warrior.current_ability
warrior.switch_ability(HelmetRush)
puts warrior.current_ability