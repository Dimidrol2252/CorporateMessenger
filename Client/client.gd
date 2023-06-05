extends Node

var URL = "109.111.185.221:8080" #"127.0.0.1:8080"
var socket
var login
var password
var online = false
var loadUser = false
var userID = null

var listChats_admin
var listUsers_admin

signal dataForAdmin
signal resultRegistration(result)
signal authorization(result)
signal getNewMessage(data)
signal waiting_for_connection
signal connection_server

func _ready():
	socket = WebSocketPeer.new()
	socket.connect_to_url(URL)
	socket.encode_buffer_max_size = 10000000
	socket.max_queued_packets = 20000
	socket.outbound_buffer_size = 10000000
	#online = true
	
	if FileAccess.file_exists("user://saveUser.save"):
		var load_user = FileAccess.open("user://saveUser.save", FileAccess.READ)
		login = load_user.get_line()
		password = load_user.get_line()
		load_user = null
		if login and password:
			print("LOAD GOOD", login, password)
			loadUser = true
	
	

func _process(delta):
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		emit_signal("connection_server")
		if loadUser:
			if login and password:
				var messageSend = {
				"type": "login", 
				"login": login,
				"pass": password
				}
				sendServer(messageSend)
				#online = true
				loadUser = false
		while socket.get_available_packet_count():
			var getMessage = socket.get_packet().get_string_from_utf8()
			var test_json_conv = JSON.new()
			test_json_conv.parse(getMessage)
			getMessage = test_json_conv.get_data()
			print("Packet: ", getMessage)
			print(getMessage["type"])
			match getMessage["type"]:
				"dataForAdmin":
					listChats_admin = getMessage["infoAllChats"]
					listUsers_admin = getMessage["infoAllUsers"]
					emit_signal("dataForAdmin")
				"resultRegistration":
					emit_signal("resultRegistration", getMessage["result"])
				"login":
					if getMessage['res'] == 1:
						Global.userID = getMessage['userId']
						Global.listChats = getMessage['listChats']
					emit_signal("authorization", getMessage["res"])
					saveUser()
				"allMessagesChats":
					Global.messagesChats = getMessage.duplicate()
				"getMessage":
					emit_signal("getNewMessage", getMessage)
					
				
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		#online = false
		loadUser = true
		socket.connect_to_url(URL)
		#set_process(false) # Stop processing.
	else:
		emit_signal("waiting_for_connection")
		pass
		# ЗАСТАВКА
		
func sendServer(message):
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		if message is Dictionary:
			socket.send(JSON.stringify(message).to_utf8_buffer())
		elif message is PackedByteArray:
			while socket.get_current_outbound_buffered_amount() > 8388608:
				await get_tree().create_timer(0.1).timeout
			socket.send(message)
			
func saveUser():
	var save_user = FileAccess.open("user://saveUser.save", FileAccess.WRITE)
	save_user.store_line(login)
	save_user.store_line(password)
	#login = null
	#password = null
	save_user = null
	print("SAVE GOOD")

