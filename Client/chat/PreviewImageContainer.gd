extends HBoxContainer

var plugin
var plugin_name = "GodotGetImage"
var img_preview = preload("res://chat/img_preview.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.has_singleton(plugin_name):
		plugin = Engine.get_singleton(plugin_name)
		
	if plugin:
		plugin.connect("image_request_completed", Callable(self, "_on_image_request_completed"))
		plugin.connect("error", Callable(self, "_on_error"))
		plugin.connect("permission_not_granted_by_user", Callable(self, "_on_permission_not_granted_by_user"))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $"../..".visible and not $".".get_child_count():
		$"../..".visible = false
	
func _on_ButtonGalleryMulti_pressed():
	if plugin:
		plugin.getGalleryImages()
	else:
		print(plugin_name, " plugin not loaded!")

func _on_image_request_completed(dict):
	$"../..".visible = true
	var count = 0
	for img_buffer in dict.values():
		if count == 9:
			break
		count += 1

		var preview_size = Vector2(128, 128) # Размер превью
		var preview_image = Image.new()
		var error = preview_image.load_jpg_from_buffer(img_buffer)
		
		preview_image.resize(preview_size.x, preview_size.y * preview_image.get_height()/preview_image.get_width(),4)
		var instance_img_preview = img_preview.instantiate()
		instance_img_preview.set_texture(ImageTexture.new().create_from_image(preview_image))
		instance_img_preview.set_meta("imageBuffer", img_buffer)
		add_child(instance_img_preview)

func _on_error(e):
	var dialog = get_node("AcceptDialog")
	dialog.window_title = "Error!"
	dialog.dialog_text = e
	dialog.show()

func _on_permission_not_granted_by_user(permission):
	print("User won't grant permission, explain why it's important!")
	var dialog = get_node("AcceptDialog")
	dialog.window_title = "Permission necessary"
	var permission_text = permission.capitalize().split(".")[-1]
	dialog.dialog_text = permission_text + "\n permission is necessary"
	dialog.show()
	
	# Set the plugin to ask user for permission again
	plugin.resendPermission()

