extends Resource
class_name CharacterStats

signal levelUpNotification

class Ability:
	
	var minModifier: float
	var maxModifier: float
	
	var abilityScore: int = 25:
		set(value):
			abilityScore = clamp(value, 0, 100)
			
	func _init(minValue: float, maxValue: float) -> void:
		minModifier = minValue
		maxModifier = maxValue
		
	func PercentileLerp(minBound: float, maxBound: float) -> float:
		return lerp(minBound, maxBound, abilityScore / 100.0)
		
	func GetModifier() -> float:
		return PercentileLerp(minModifier, maxModifier)
		
	func Increase() -> void:
		abilityScore += randi_range(2, 5)

var level := 1
var nextLevel: int
var xp := 0:
	set(value):
		xp = value

		while(xp >= nextLevel):
			xp -= nextLevel
			LevelUp()
			nextLevel = PercentageLevelUpBoundary()

const MIN_DASH_COOLDOWN := 1.5
const MAX_DASH_COOLDOWN := 0.5

#Damage bonus on attack
var strength := Ability.new(2.0, 12.0)
#Movement speed in m/s
var speed := Ability.new(3.0, 7.0)
#HP bonus per level
var endurance := Ability.new(5.0, 25.0)
#Crit chance
var agility := Ability.new(0.05, 0.25)

func _init() -> void:
	nextLevel = PercentageLevelUpBoundary()

func GetBaseSpeed() -> float:
	return speed.GetModifier()
	
func GetDamageModifier() -> float:
	return strength.GetModifier()
	
func GetCritChance() -> float:
	return agility.GetModifier()
	
func GetMaxHP() -> int:
	return 20 + int(level * endurance.GetModifier())
	
func GetDashCooldown() -> float:
	return agility.PercentileLerp(MIN_DASH_COOLDOWN, MAX_DASH_COOLDOWN)
	
func LevelUp() -> void:
	level += 1
	strength.Increase()
	speed.Increase()
	endurance.Increase()
	agility.Increase()
	levelUpNotification.emit()

	
func PercentageLevelUpBoundary() -> int:
	return int(50 * pow(1.2, level))
