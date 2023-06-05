extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	get_tree().change_scene_to_file("res://login/login.tscn")
	var nullify_save = FileAccess.open("user://saveUser.save", FileAccess.WRITE)
	nullify_save = null
	Client.login = null
	Client.password = null
	Client.loadUser = false
	var messageSend = {
		"type": "logout", 
	}		
	Client.sendServer(messageSend)
