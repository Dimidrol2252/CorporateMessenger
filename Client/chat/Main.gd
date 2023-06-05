extends ScrollContainer

var scrollbar

# Called when the node enters the scene tree for the first time.
func _ready():
	scrollbar = self.get_v_scroll_bar()
	print("ready", scrollbar)
	$List.placeMessages()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func visibleLastMessage(lastMessage = false):
	print("visibleLastMessage", scrollbar)
	print(scrollbar.value, ",", scrollbar.get_page(),",", scrollbar.max_value)
	#if scrollbar.value + scrollbar.get_page() >= scrollbar.max_value:
	await get_tree().process_frame

	if lastMessage:
		self.ensure_control_visible(lastMessage)
	else:
		self.ensure_control_visible($List.get_child($List.get_child_count()-1))
