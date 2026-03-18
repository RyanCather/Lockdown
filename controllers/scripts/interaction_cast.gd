extends RayCast3D


var collidedObject

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	collidedObject = get_collider()
	if collidedObject:
		if collidedObject.is_in_group("InteractableObject") and Global.myCurrentTeam == collidedObject.teamFilter:
			collidedObject.update()
			Global.interactionLabel.text = "Press F to interact with " + collidedObject.objectName
			if Input.is_action_just_pressed("interact"):
				collidedObject.interact()
	else:
		Global.interactionLabel.text = ""
