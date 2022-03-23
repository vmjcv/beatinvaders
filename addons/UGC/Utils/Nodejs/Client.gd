tool
extends Node
var nodejs_constant = preload("res://addons/UGC/Utils/Nodejs/Constant.gd").new()

#var nodejs_path = OS.get_executable_path()
var nodejs_path = "C:\\Users\\mjc\\Desktop\\slimegame\\slime-game-node"

var ws = null
var server_call_func = {

}

signal nodejs_connected
signal nodejs_logouted
var nodejs_pid
var nodejs_cid

func _ready():
	server_call_register(nodejs_constant.PROTOCOL.S_C_LOGIN_NODEJS,[self,"logined_nodejs"])

func _process(delta):
	if not ws:
		return
	if ws.get_connection_status() == ws.CONNECTION_CONNECTING || ws.get_connection_status() == ws.CONNECTION_CONNECTED:
		ws.poll()

	if ws.get_peer(1).is_connected_to_host():
		if ws.get_peer(1).get_available_packet_count() > 0:
			server_call()


func init_nodejs_server():
	var output = []
#	nodejs_pid = OS.execute("CMD.exe", ["/C","cd %s && npm start"%nodejs_path], false, output)
	nodejs_pid = OS.execute(nodejs_path,[], false, output)
	print(nodejs_pid)
	
func login_node_server():
	ws = WebSocketClient.new()
	ws.connect("connection_established", self, "_connection_established")
	ws.connect("connection_closed", self, "_connection_closed")
	ws.connect("connection_error", self, "_connection_error")
	var url = "ws://localhost:%d"%[nodejs_constant.port]
	ws.connect_to_url(url)

func close_node_server():
	if not ws:
		return
	ws.disconnect_from_host()
	OS.kill(nodejs_pid)


func logined_nodejs(data):
	nodejs_cid = data[0]
	emit_signal("nodejs_connected")
	print("nodejs_connected")


func _connection_established(protocol):
	emit_signal("nodejs_connected")

func _connection_closed(was_clean_close):
	emit_signal("nodejs_logouted")

func _connection_error():
	emit_signal("nodejs_logouted")

func call_server(protocol:int,data:Array):
	var buffer = StreamPeerBuffer.new()
	var peer = ws.get_peer(1)
	buffer.put_var(protocol)
	for obj in data:
		buffer.put_var(obj)
	peer.put_packet(buffer.get_data_array())

func server_call_register(protocol:int,do_func):
	server_call_func[protocol] = do_func
	pass

## nodejs服务端call客户端
func server_call():
	var packet = ws.get_peer(1).get_packet()
	var buffer = StreamPeerBuffer.new()
	buffer.set_data_array(packet)
	var type = buffer.get_var()
	var ret = buffer.get_var()
	var data = []
	while ret:
		data.append(ret)
		ret = buffer.get_var()
	if type and server_call_func.get(type):
		var do_func = server_call_func[type]
		do_func[0].call(do_func[1],data)
