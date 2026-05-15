extends Node2D

@onready var Message = $Message          
@onready var Send = $Send                
@onready var Messages = $Messages        
@onready var Chatbox = self       


func _ready():
	#Chatbox.hide() #Doesnt work right now. Working on a fix. 
	Send.pressed.connect(_on_send_pressed)


func _process(delta):
	if Input.is_action_just_pressed("chatbox"):
		Chatbox.visible = !Chatbox.visible   # Toggle visibility


func _on_send_pressed() -> void:
	var text = Message.text.strip_edges()

	if text == "":
		return  # Don't send empty messages

	# Create a new label for the message
	var new_message = Label.new()
	new_message.text = text

	# Add it to the message box
	Messages.add_child(new_message)

	
	Message.text = ""
