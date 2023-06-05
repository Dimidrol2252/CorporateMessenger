extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 1
	for row in Client.listChats_admin:
		self.add_item(row[0], i)
		i += 1
	self.select(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
