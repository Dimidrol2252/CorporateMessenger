extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalAdmin.connect("CreatingNewChat_selectionUsersSignal", _visible_check_box)
	GlobalAdmin.connect("CreatingNewChat_closeSelectionUsersSignal", _unVisible_check_box)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _visible_check_box():
	$Panel/DelUser.visible = false
	$Panel/Info.visible = false
	$Panel/ChekBox.visible = true
	
func _unVisible_check_box():
	$Panel/DelUser.visible = true
	$Panel/Info.visible = true
	$Panel/ChekBox.visible = false
	
