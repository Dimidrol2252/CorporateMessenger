extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	Client.connect("waiting_for_connection", waiting_for_connection)
	Client.connect("connection_server", connection_server)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#self.visible = false
	pass
	
func waiting_for_connection():
	self.visible = true
	
func connection_server():
	self.visible = false
