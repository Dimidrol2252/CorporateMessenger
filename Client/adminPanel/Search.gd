extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
'''
func _on_text_changed(new_text):
	var listForSearch = []
	var newList = []
	if not $"../../../Panel2/MarginOption/OptionView".get_selected_id():
		listForSearch = Client.listUsers_admin
		for row in listForSearch:
			print(new_text, row[1], listForSearch)
			if not ( new_text and row[1].findn(new_text) < 0):
				newList.append(row)
		$"../../../../Main/List".placeUsers(newList, $"../../../Panel2/MarginOption/OptionView".disabled)

	else:
		listForSearch = Client.listChats_admin
		for row in listForSearch:
			if not(new_text and row[0].findn(new_text) < 0):
				newList.append(row)
		$"../../../../Main/List".placeChats(newList)
			
	print(new_text, listForSearch)
'''
func _on_text_changed(new_text):
	for child in $"../../../../../Main/List".get_children():
		child.visible = true
	for child in $"../../../../../Main/List".get_children():
		if new_text and child.get_node("Panel/Name").text.findn(new_text) < 0:
			child.visible = false

