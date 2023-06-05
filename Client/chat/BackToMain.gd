extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../../../Panel/VBoxContainer/nameChat".text = Global.currentOpenChat
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	get_tree().change_scene_to_file("res://main/main.tscn")
