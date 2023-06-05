extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _pressed():
	if len(GlobalAdmin.listSelectedUsersForNewChat) < 1:
		print("СПИСОК ПУСТ")
		return
	var listNameUsersForNewChat = []
	for row in GlobalAdmin.listSelectedUsersForNewChat:
		listNameUsersForNewChat.append(row.get_node("NameUser").text)
	var sendMessage = {
		"type": "createNewChat_admin",
		"chatName": $"../Labels/NameNewChat".text,
		"listUsers": listNameUsersForNewChat,
	}
	Client.sendServer(sendMessage)
	
	GlobalAdmin.closeCreatingNewChatAndFree()
