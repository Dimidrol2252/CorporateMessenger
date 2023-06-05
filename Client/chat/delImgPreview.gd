extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	var tween = get_tree().create_tween()
	tween.tween_property($"..", "scale", Vector2(), 0.4)
	tween.tween_callback($"..".queue_free)
