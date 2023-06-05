extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	if len($textMessage.text) < 20:
		if $"../..".get_meta("left"):
			self.size_flags_horizontal = 2
		else:
			self.size_flags_horizontal = 10




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
