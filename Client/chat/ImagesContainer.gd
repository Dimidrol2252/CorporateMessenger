extends MarginContainer

var view = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	await get_tree().create_timer(1).timeout
	var viewport_rect = get_viewport_rect()
	var node_rect = get_global_rect()
	
	if not view and viewport_rect.intersects(node_rect):
		view = true
	elif view and not viewport_rect.intersects(node_rect):
		view = false
		



