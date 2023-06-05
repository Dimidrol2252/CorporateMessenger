extends MarginContainer

var old_size_y


func _ready():
	old_size_y = self.size.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var is_supported = DisplayServer.has_feature(DisplayServer.FEATURE_VIRTUAL_KEYBOARD)
	if is_supported:
		var keyboard_height = DisplayServer.virtual_keyboard_get_height() / get_viewport_transform().y[1]
		if keyboard_height:
			self.size.y = old_size_y - keyboard_height
		else:
			self.size.y = old_size_y


