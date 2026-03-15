extends Node

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var hud = $UserInterface

@onready var Player = preload("res://controllers/fps_controller.tscn")

@onready var cop_spawns = $SpawnPoints2/Cops.get_children()
@onready var robber_spawns = $SpawnPoints2/Robber.get_children()

var tracked = false
var player
var teams = {}

const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()


func _ready():

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	Global.reserveLabel = %Reserve
	Global.interactionLabel = %InteractionLabel
	Global.clipLabel = %Clip
	Global.pointsLabel = %Points
	Global.healthLabel = %Health


func _on_host_button_pressed():

	main_menu.hide()
	hud.show()

	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)

	add_player(multiplayer.get_unique_id())


func _on_join_button_pressed():

	main_menu.hide()
	hud.show()

	enet_peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer


func _on_single_player_button_pressed():

	main_menu.hide()
	hud.show()

	var my_id = multiplayer.get_unique_id()
	add_player(my_id)


func add_player(peer_id):

	var player = Player.instantiate()
	player.name = str(peer_id)

	add_child(player)

	player.set_multiplayer_authority(peer_id)

	assign_team(peer_id)

	tracked = true


func remove_player(peer_id):

	var player = get_node_or_null(str(peer_id))

	if player:
		player.queue_free()


func assign_team(id):

	if !multiplayer.is_server():
		return

	var cop_count = 0
	var robber_count = 0

	for t in teams.values():

		if t == "Cop":
			cop_count += 1
		elif t == "Robber":
			robber_count += 1


	var team

	if cop_count > robber_count:
		team = "Robber"
	elif robber_count > cop_count:
		team = "Cop"
	else:
		team = "Cop" if randi() % 2 == 0 else "Robber"


	teams[id] = team

	print("Player ", id, " assigned to ", team)

	rpc("receive_team_assignment", id, team)

	spawn_player(id, team)


func spawn_player(id, team):

	var player = get_node(str(id))

	var spawn_point

	if team == "Cop":
		spawn_point = cop_spawns.pick_random()
	else:
		spawn_point = robber_spawns.pick_random()

	player.global_position = spawn_point.global_position


@rpc("any_peer", "reliable")
func receive_team_assignment(id, team):

	teams[id] = team

	print("Synced: Player ", id, " is ", team)

	if id == multiplayer.get_unique_id():
		Global.myCurrentTeam = team
