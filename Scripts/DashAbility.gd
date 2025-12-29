extends Node3D

@export var player: Player
@export var dashSpeedMultiplier := 3.0

@onready var cooldownTimer: Timer = $CooldownTimer
@onready var dashParticles: GPUParticles3D = $GPUParticles3D

var direction := Vector3.ZERO
var dashDuration := 0.1
var timeRemaining := 0.0

func _ready() -> void:
	dashParticles.emitting = false

func _physics_process(delta: float) -> void:
	if(direction.is_zero_approx()):
		return
	
	player.velocity = direction * player.moveSpeed * dashSpeedMultiplier
	timeRemaining -= delta
	
	if(timeRemaining <= 0):
		direction = Vector3.ZERO
		dashParticles.emitting = false

func _unhandled_input(event: InputEvent) -> void:
	if(!cooldownTimer.is_stopped() or player.healthComponent.IsDead()):
		return
	
	if(!event.is_action_pressed("dash")):
		return
		
	direction = player.GetMovementDirection()
	
	if(direction.is_zero_approx()):
		return
			
	player.rig.Travel("Dash")
	cooldownTimer.start(player.stats.GetDashCooldown())
	timeRemaining = dashDuration
	dashParticles.emitting = true
