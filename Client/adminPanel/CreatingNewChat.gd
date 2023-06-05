extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalAdmin.connect("closeCreatingNewChatSignal", _closeCreatingNewChat)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func start():
	$"../../../WindowEditNameChat".visible = true
	$"../Header/Panel2/MarginOption/OptionView".selected = 0
	$"../Header/Panel2/MarginOption/OptionView".disabled = true

func stop():
	$"../../../WindowEditNameChat".visible = false
	$"../Header/Panel2/MarginOption/OptionView".selected = 1
	$"../Header/Panel2/MarginOption/OptionView".disabled = false
	
func selectionUsers(nameChat):
	$"../../../WindowEditNameChat".visible = false
	$"../Footer".visible = false
	self.visible = true
	$Head/VBoxContainer/HBoxContainer/Labels/NameNewChat.text = nameChat
	$"../Main/List".placeUsers()
	GlobalAdmin.emit_selectionUsersSignal()

func _closeCreatingNewChat():
	$"../Footer".visible = true
	self.visible = false
	$"../Main/List".placeChats()
	$"../Header/Panel2/MarginOption/OptionView".selected = 1
	$"../Header/Panel2/MarginOption/OptionView".disabled = false
