extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _pressed():
	if validateLogin($"../../MarginForInputLogin/LineEdit".text) and validatePassword($"../../MarginForInputPassword/LineEdit".text):
		print('Login send server')
		$"../../MarginError/Error".visible = false
		var messageSend = {
			"type": "login", 
			"login": $"../../MarginForInputLogin/LineEdit".text,
			"pass": $"../../MarginForInputPassword/LineEdit".text
		}		
		Client.login = $"../../MarginForInputLogin/LineEdit".text
		Client.password = $"../../MarginForInputPassword/LineEdit".text
		Client.loadUser = false
		Client.sendServer(messageSend)
	else:
		$"../../MarginError/Error".visible = true
	
	
func validateLogin(login):
	if login and not int(login[0]) and len(login) <= 16:
		return true
	else:
		return false
		
func validatePassword(password):
	if password and len(password) <= 16:
		return true
	else:
		return false

