extends KinematicBody2D

signal died
var playerDeathScene = preload("res://scenes/PlayerDeath.tscn")
var footstepParticles = preload("res://scenes/FootstepParticles.tscn")
enum State { NORMAL, DASHING, INPUT_DISABLED }

export (int, LAYERS_2D_PHYSICS) var dashHazardMask

var maxDashSpeed = 500
var minDashSpeed = 200
var gravity = 900
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 150
var horizontalAcceleration = 2000
var jumpSpeed = 300
var jumpTerminationMultiplier = 1
var hasDoubleJump = false;
var hasDash = false;
var currentState = State.NORMAL
var isStateNew = true
var defaultHazardMask = 0
var isDying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.connect("frame_changed", self, "on_animated_frame_changed")
	defaultHazardMask = $HazardArea.collision_mask
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_dash(delta)
		State.INPUT_DISABLED:
			process_input_disabled(delta)
	isStateNew = false

func change_state(newState):
	currentState = newState;
	isStateNew = true

func process_dash(delta):
	if (isStateNew):
		$DashParticles.emitting = true
		$"/root/Helpers".apply_camera_shake(.85)
		$DashArea/CollisionShape2D.disabled = false
		$AnimatedSprite.play("jump")
		$HazardArea.collision_mask = dashHazardMask
		var moveVector = get_movement_vector()
		var velocityMod = 1
		if (velocity.x != 0):
			velocityMod = sign(moveVector.x)
		else:
			velocityMod = 1 if $AnimatedSprite.flip_h else - 1
		velocity = Vector2(maxDashSpeed * velocityMod, 0)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(0, velocity.x, pow(2, -8 * delta))
	
	if (abs(velocity.x) < minDashSpeed):
		call_deferred("change_state", State.NORMAL)

func process_normal(delta):
	if (isStateNew):
		$DashParticles.emitting = false
		$DashArea/CollisionShape2D.disabled = true;
		$HazardArea.collision_mask = defaultHazardMask
	var moveVector = get_movement_vector()
	velocity.x += moveVector.x * horizontalAcceleration * delta
	if (moveVector.x == 0):
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))

	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	if (moveVector.y < 0 && (is_on_floor() || !$CayoteTimer.is_stopped() || hasDoubleJump)):
		velocity.y = moveVector.y * jumpSpeed
		
		if (!is_on_floor() and $CayoteTimer.is_stopped()):
			$"/root/Helpers".apply_camera_shake(.85)
			hasDoubleJump = false
		$CayoteTimer.stop()

	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta
		
	var was_on_floor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if (was_on_floor and !is_on_floor()):
		$CayoteTimer.start()
	if (!was_on_floor and is_on_floor() and !isStateNew):
		spawn_footsteps(1.5)
	
	if (is_on_floor()):
		hasDoubleJump = true
		hasDash = true
	
	if (hasDash and Input.is_action_just_pressed("dash")):
		change_state(State.DASHING);
		hasDash = false;
		call_deferred("change_state", State.DASHING);
	updateAnimation()

func process_input_disabled(delta):
	if (isStateNew):
		$AnimatedSprite.play("idle")
	velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func get_movement_vector():
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move-right") - Input.get_action_strength("move-left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return moveVector
	
func updateAnimation():
	var moveVector = get_movement_vector()
	
	if (!is_on_floor()):
		$AnimatedSprite.play("jump")
	elif (moveVector.x != 0):
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")
	
	if (moveVector.x != 0):	
		$AnimatedSprite.flip_h = true if moveVector.x > 0 else false

func kill():
	if (isDying):
		return
	isDying = true
	var playerDeathInstance = playerDeathScene.instance()
	playerDeathInstance.velocity = velocity
	get_parent().add_child_below_node(self, playerDeathInstance)
	playerDeathInstance.global_position = global_position
	emit_signal("died")

func _on_HazardArea_area_entered(area):
	$"/root/Helpers".apply_camera_shake(.85)
	call_deferred("kill")

func spawn_footsteps(scale = 1):
	var footstep = footstepParticles.instance()
	footstep.scale = Vector2.ONE * scale
	get_parent().add_child(footstep)
	footstep.global_position = global_position
	$FootstepAudioPlayer.play()

func on_animated_frame_changed():
	if ($AnimatedSprite.frame == 0 and $AnimatedSprite.animation == "run"):
		spawn_footsteps();

func disable_player_input():
	change_state(State.INPUT_DISABLED)
