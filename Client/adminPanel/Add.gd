extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _pressed():
	var index_option = $"../../../../Header/Panel2/MarginOption/OptionView".get_selected_id()
	if index_option == 0:
		get_tree().change_scene_to_file("res://registration/registration.tscn")
	elif index_option == 1:
		$"../../../../CreatingNewChat".start()
		

