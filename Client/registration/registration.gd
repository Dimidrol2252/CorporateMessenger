extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Client.connect("resultRegistration", _resultRegistration)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _resultRegistration(result):
	if result == -1:
		$Panel/ScrollContainer/VBoxContainer/MarginLogin/Login/Error.visible = true
	elif result == -2:
		$Panel/ScrollContainer/VBoxContainer/MarginPhone/Phone/Error.visible = true
	else:
		$Panel/ScrollContainer/VBoxContainer/MarginLogin/Login/Error.visible = false
		$Panel/ScrollContainer/VBoxContainer/MarginPhone/Phone/Error.visible = false
		get_tree().change_scene_to_file("res://adminPanel/adminPanel.tscn")
