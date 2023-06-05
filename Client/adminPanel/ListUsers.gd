extends Panel

var nodeRowSelectedUser = preload("res://adminPanel/row_selected_userr.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalAdmin.connect("addUserForNewChatSignal", _add_user)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _add_user(idUser, nameuser):
	var instanceRowUser = nodeRowSelectedUser.instantiate()
	instanceRowUser.get_node("NameUser").text = nameuser
	$MarginContainer/ScrollContainer/VBoxContainer.add_child(instanceRowUser)
	GlobalAdmin.listSelectedUsersForNewChat.append(instanceRowUser)
	
	
