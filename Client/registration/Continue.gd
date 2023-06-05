extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	var idOptionChat = $"../../MarginChat/OptionListChats".selected
	var messageSend = {
			"type": "registrationUser", 
			"login": $"../../MarginLogin/Login".text,
			"password": $"../../MarginPassword/Password".text,
			"phone":  $"../../MarginPhone/Phone".text,
		}		
	if idOptionChat:
		messageSend["chat"] = $"../../MarginChat/OptionListChats".get_item_text(idOptionChat)

	Client.sendServer(messageSend)
