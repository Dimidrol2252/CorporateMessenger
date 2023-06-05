extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _pressed():
	var nameChat = $"../../NameNewChat".text
	if len(nameChat) > 3 and len(nameChat) < 32:
		$"../../../../../PanelAdminPanel/VBoxContainer/CreatingNewChat".selectionUsers(nameChat)
		$"../../NameNewChat".clear()
	else:
		print("Ошибка названия чата")
