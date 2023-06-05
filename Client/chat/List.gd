extends VBoxContainer

var rowMyMessage = preload("res://chat/my_message.tscn")
var rowNotMyMessage = preload("res://chat/not_my_message.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Client.connect("getNewMessage", newMessage)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func placeMessages(ListMessages = Global.messagesChats[Global.currentOpenChat]):
	for n in get_children():
		remove_child(n)
		n.queue_free()
	var instanceRowMessage
	for row in ListMessages:
		if row[3] == Client.login:
			instanceRowMessage = rowMyMessage.instantiate()
		else:
			instanceRowMessage = rowNotMyMessage.instantiate()
		instanceRowMessage.get_node("HBoxContainer/VContainerMessage/textMessage").text = row[1]
		instanceRowMessage.get_node("HBoxContainer/VContainerMessage/Header/MarginContainer/HBoxContainer/VBoxContainer/date").text = row[2]
		instanceRowMessage.get_node("HBoxContainer/VContainerMessage/Header/MarginContainer/HBoxContainer/Name").text = row[3]
		instanceRowMessage.set_meta("message_id", row[4])
		instanceRowMessage.set_meta("count_images", row[5])
		self.add_child(instanceRowMessage)
	$"..".visibleLastMessage(instanceRowMessage)
		
func newMessage(data):
	Global.messagesChats[data["chatName"]].append(data["newMessage"])
	if Global.currentOpenChat == data["chatName"]:
		var instanceRowMessage
		if data["newMessage"][3] == Client.login:
			instanceRowMessage = rowMyMessage.instantiate()
		else:
			instanceRowMessage = rowNotMyMessage.instantiate()
		instanceRowMessage.get_node("HBoxContainer/VContainerMessage/textMessage").text = data["newMessage"][1]
		instanceRowMessage.get_node("HBoxContainer/VContainerMessage/Header/MarginContainer/HBoxContainer/VBoxContainer/date").text = data["newMessage"][2]
		instanceRowMessage.get_node("HBoxContainer/VContainerMessage/Header/MarginContainer/HBoxContainer/Name").text = data["newMessage"][3]
		instanceRowMessage.set_meta("message_id", data["newMessage"][4])
		instanceRowMessage.set_meta("count_images", data["newMessage"][5])
		self.add_child(instanceRowMessage)
		$"..".visibleLastMessage(instanceRowMessage)

