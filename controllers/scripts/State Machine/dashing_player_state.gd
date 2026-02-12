class_name DashingPlayerState 

extends PlayerMovementState

@export var speed: float = 8.0
@export var acceleration: float = 0.1
@export var deceleration: float = 0.05
@export var Camera: Camera3D

func enter(previous_state) -> void:
	PLAYER.velocity += -Camera.global_transform.basis.z.normalized() * speed
	PLAYER.stamina -= 33
	print(-Camera.global_transform.basis.z.normalized() * speed)

func exit() -> void:
	pass

func update(delta: float) -> void:
	PLAYER.updateGravity(delta)
	PLAYER.updateInput(speed, acceleration, deceleration)
	PLAYER.updateVelocity()
	
	if !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")
	
	if PLAYER.is_on_floor():
		transition.emit("IdlePlayerState")
