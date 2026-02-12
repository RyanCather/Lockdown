class_name SlammingPlayerState 

extends PlayerMovementState

@export var speed: float = 9.0
@export var slamSpeed: float = -24.0
@export var acceleration: float = 0.1
@export var deceleration: float = 0.05
@export var Camera: Camera3D

func enter(previous_state) -> void:
	PLAYER.velocity = Vector3(0,0,0)
	PLAYER.velocity.y = slamSpeed

func exit() -> void:
	pass

func update(delta: float) -> void:
	PLAYER.updateGravity(delta)
	PLAYER.updateInput(speed, acceleration, deceleration)
	PLAYER.updateVelocity()
	weapon.sway_weapon(delta, false)
	
	if PLAYER.is_on_floor():
		transition.emit("IdlePlayerState")
