extends VBoxContainer

var rowCHat = preload("res://main/row_chat_for_user.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Client.connect("getNewMessage", newMessage)
	placeChats(Global.listChats)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func placeChats(ListChats = Global.listChats):
	for n in get_children():
		remove_child(n)
		n.queue_free()
	for row in ListChats:
		var instancerowCHat = rowCHat.instantiate()
		instancerowCHat.get_node("Panel/Name").text = row[0]
		#instancerowCHat.get_node("Panel/CountUsers").text = str(row[1])
		self.add_child(instancerowCHat)
		
func newMessage(data):
	Global.messagesChats[data["chatName"]].append(data["newMessage"])
