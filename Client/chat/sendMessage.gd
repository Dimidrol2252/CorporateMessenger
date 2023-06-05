extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	var messageSend = null
	if $"../../../../PreviewImageScroll".visible:
		var all_count_chanks_image = 0
		var chunk_size = 16384
		var list_sizes_imgs = []
		for img in $"../../../../PreviewImageScroll/ScrollContainer/PreviewImageContainer".get_children():
			var img_size = img.get_meta("imageBuffer").size()
			list_sizes_imgs.append(img_size)
			all_count_chanks_image += ceil(img_size / chunk_size)
		messageSend = {
			"type": "sendMessage", 
			"chatName": Global.currentOpenChat,
			"user_id": Global.userID,
			"content": $"../inputTextMessage".text,
			"list_sizes_imgs": list_sizes_imgs,
			"all_count_chanks_image": all_count_chanks_image
		}
		Client.sendServer(messageSend)
		for img in $"../../../../PreviewImageScroll/ScrollContainer/PreviewImageContainer".get_children():
			var img_size = img.get_meta("imageBuffer").size()
			var num_chunks = ceil(img_size / chunk_size)
			for i in range(num_chunks+1):
				var chunk = img.get_meta("imageBuffer").slice(i * chunk_size, min((i + 1) * chunk_size, img_size))
				Client.sendServer(chunk)
			img.queue_free()

	else:
		messageSend = {
			"type": "sendMessage", 
			"chatName": Global.currentOpenChat,
			"user_id": Global.userID,
			"content": $"../inputTextMessage".text
		}
		
		Client.sendServer(messageSend)
	$"../inputTextMessage".clear()
