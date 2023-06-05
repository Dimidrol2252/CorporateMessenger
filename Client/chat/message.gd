extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(get_meta("count_images")):
		$HBoxContainer/VContainerMessage/ImagesContainer/HFlowContainer.get_child(i+1).visible = true
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

