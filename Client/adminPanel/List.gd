extends VBoxContainer

var rowCHat = preload("res://adminPanel/rowChat.tscn")
var rowUsers = preload("res://adminPanel/rowUser.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	placeUsers()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func placeChats(ListChats = Client.listChats_admin):
	for n in get_children():
		remove_child(n)
		n.queue_free()
	for row in ListChats:
		var instancerowCHat = rowCHat.instantiate()
		instancerowCHat.get_node("Panel/Name").text = row[0]
		instancerowCHat.get_node("Panel/CountUsers").text = str(row[1])
		self.add_child(instancerowCHat)

func placeUsers(ListUsers = Client.listUsers_admin, onCheckBox = false):
	for n in get_children():
		remove_child(n)
		n.queue_free()
	for row in ListUsers:
		var instancerowUser = rowUsers.instantiate()
		instancerowUser.get_node("Panel/Name").text = row[1]
		self.add_child(instancerowUser)
		if onCheckBox:
			instancerowUser._visible_check_box() #Так можно?
