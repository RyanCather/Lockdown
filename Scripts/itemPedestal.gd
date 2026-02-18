extends Node3D

@onready var dropLocation = $"Item Spawn Location"
var rng = RandomNumberGenerator.new()
var weaponDrop = preload("res://scenes/Weapon Drop.tscn")
var itemPaths = [
	"res://Weapons/Blaster.tres",
	"res://Weapons/Revolver.tres"
	
]



func _ready() -> void:
	rng.randomize()
	call_deferred("spawnItem")

func spawnItem():
	var dropInstance = weaponDrop.instantiate()
	get_tree().get_root().add_child(dropInstance)
	var loadedItem = itemPaths[rng.randi_range(0, itemPaths.size()-1)]
	dropInstance.global_position = dropLocation.global_position
	dropInstance.setWeapon(loadedItem)
	dropInstance.setModel(loadedItem)
	dropInstance.setAttribute("isItem", true)
