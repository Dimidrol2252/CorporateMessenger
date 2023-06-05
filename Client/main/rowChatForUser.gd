extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			self.modulate = Color("c5c5c5")
		else:
			self.modulate = Color("ffffff")
			Global.currentOpenChat = $Name.text
			get_tree().change_scene_to_file("res://chat/chat.tscn")
			
