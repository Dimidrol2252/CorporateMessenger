extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Client.connect("dataForAdmin", _changeSceneAdminPanel)
	Client.connect("authorization", _changeSceneMain)
	

func _changeSceneAdminPanel():
	get_tree().change_scene_to_file("res://adminPanel/adminPanel.tscn")
	
func _changeSceneMain(result):
	if result == 1:
		$MarginError/Error.visible = false
		get_tree().change_scene_to_file("res://main/main.tscn")
	elif result == 0 or result == 2:
		$MarginError/Error.visible = true
