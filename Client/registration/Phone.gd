extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_text_changed(new_text):
	for ch in new_text:
		if not (ch >= char(48) and ch <= char(57)):
			self.delete_char_at_caret()
		
