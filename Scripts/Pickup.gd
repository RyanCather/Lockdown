extends RigidBody3D


var type = "ammo"
var types = ["ammo", "health", "points"]
var rng = RandomNumberGenerator.new()
@onready var meshInstance: MeshInstance3D = $MeshInstance3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	type = types[rng.randi_range(0,2)]
	if type == "points":
		var orignalMaterial = meshInstance.mesh.surface_get_material(0)
		var newMaterial = orignalMaterial.duplicate(true)
		newMaterial.albedo_color = Color("#00f0ec")
		meshInstance.set_surface_override_material(0, newMaterial)
	if type == "health":
		var orignalMaterial = meshInstance.mesh.surface_get_material(0)
		var newMaterial = orignalMaterial.duplicate(true)
		newMaterial.albedo_color = Color("#63f800")
		meshInstance.set_surface_override_material(0, newMaterial)
	if type == "ammo":
		var orignalMaterial = meshInstance.mesh.surface_get_material(0)
		var newMaterial = orignalMaterial.duplicate(true)
		newMaterial.albedo_color = Color("#fdcc00")
		meshInstance.set_surface_override_material(0, newMaterial)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_area_3d_body_entered(body: Node3D) -> void:
	if (body == Global.player):
		if type == "points":
			Global.playerPoints += 10
		if type == "health":
			Global.playerHealth += 5
		if type == "ammo":
			Global.weaponManager.addAmmo(5,5)
		queue_free()
