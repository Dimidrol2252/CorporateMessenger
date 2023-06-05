extends Node

signal CreatingNewChat_selectionUsersSignal
signal CreatingNewChat_closeSelectionUsersSignal
signal addUserForNewChatSignal(idUser, nameUser)
signal closeCreatingNewChatSignal

var selectedUsersForNewChat = []
var listSelectedUsersForNewChat = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func emit_selectionUsersSignal():
	emit_signal("CreatingNewChat_selectionUsersSignal")
	
func addUserForNewChat(NodeRowUser):
	selectedUsersForNewChat.append(NodeRowUser)
	emit_signal("addUserForNewChatSignal", selectedUsersForNewChat.size() - 1, NodeRowUser.get_node("Panel/Name").text)
	pass
	
func removeUserForNewChat(nodeRow):
	var first = selectedUsersForNewChat.find(nodeRow)
	var second = listSelectedUsersForNewChat.find(nodeRow)
	print(first)
	print(second)
	if first >= 0:
		selectedUsersForNewChat.remove_at(first)
		listSelectedUsersForNewChat[first].queue_free()
		listSelectedUsersForNewChat.remove_at(first)
	elif second >= 0:
		nodeRow.queue_free()
		listSelectedUsersForNewChat.remove_at(second)
		selectedUsersForNewChat[second].get_node("Panel/ChekBox").button_pressed = false
		selectedUsersForNewChat.remove_at(second)

func closeCreatingNewChatAndFree():
	
	for i in selectedUsersForNewChat:
		if  i:
			i.get_node("Panel/ChekBox").button_pressed = false
	for i in listSelectedUsersForNewChat:
		i.queue_free()
	selectedUsersForNewChat.clear()
	listSelectedUsersForNewChat.clear()
	emit_signal("CreatingNewChat_closeSelectionUsersSignal")
	emit_signal("closeCreatingNewChatSignal")
