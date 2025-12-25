extends CharacterBody3D


@export var moveSpeed := 5.0
@export var jumpSpeed := 4.5
@export var mouseSensitivity := 0.0014
@export var minMouseBoundary := -60.0
@export var maxMouseBoundary := 10.0
@export var animationDecay := 20.0

var mouseLook := Vector2.ZERO

@onready var horizontalPivot: Node3D = $HorizontalPivot
@onready var verticalPivot: Node3D = $HorizontalPivot/VerticalPivot
@onready var rigPivot: Node3D = $RigPivot

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	MoveCamera()
	
	# Add the gravity.
	if(!is_on_floor()):
		velocity += get_gravity() * delta

	# Handle jump.
	if(Input.is_action_just_pressed("jump") and is_on_floor()):
		velocity.y = jumpSpeed

	# Get the input direction and handle the movement/deceleration.
	var direction := GetMovementDirection()
	if(direction):
		velocity.x = direction.x * moveSpeed
		velocity.z = direction.z * moveSpeed
		LookTowardDirection(direction, delta)
	else:
		velocity.x = move_toward(velocity.x, 0, moveSpeed)
		velocity.z = move_toward(velocity.z, 0, moveSpeed)

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_cancel")):
		if(Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			get_tree().quit()
		
	if(Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		if(event is InputEventMouseMotion):
			mouseLook += -event.relative * mouseSensitivity
	elif(event is InputEventMouseButton):
		if(event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func MoveCamera() -> void:
	horizontalPivot.rotate_y(mouseLook.x)
	verticalPivot.rotate_x(mouseLook.y)
	verticalPivot.rotation.x = clampf(
		verticalPivot.rotation.x, 
		deg_to_rad(minMouseBoundary), 
		deg_to_rad(maxMouseBoundary)
		)
	mouseLook = Vector2.ZERO
	
func GetMovementDirection() -> Vector3:
	var inputVector := Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBackward")
	return horizontalPivot.global_transform.basis * (Vector3(inputVector.x, 0, inputVector.y)).normalized()

func LookTowardDirection(direction: Vector3, delta: float) -> void:
	var targetTransform := rigPivot.global_transform.looking_at(
		rigPivot.global_position + direction, Vector3.UP, true
	)

	rigPivot.global_transform = rigPivot.global_transform.interpolate_with(
		targetTransform, 1.0 - exp(-animationDecay * delta)
	)
