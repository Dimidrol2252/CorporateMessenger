extends Node

var userID
var listChats = []
var messagesChats = {}
var currentOpenChat

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_listChats(list):
	for i in range(list):
		listChats.append(list[0])
