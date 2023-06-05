extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_item_selected()
	Client.connect("dataForAdmin", _on_item_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_item_selected(index = self.get_selected_id()):
	if index == 0:
		$"../../../../Main/List".placeUsers()
	elif index == 1:
		$"../../../../Main/List".placeChats()

