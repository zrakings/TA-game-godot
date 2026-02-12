extends Control

@onready var user_list = $VBoxContainer/user_list
@onready var http = $HTTPRequest

func _ready():
	http.request_completed.connect(_on_request_completed)
	load_users()

func load_users():
	var url = "http://localhost/ta_api/get_users.php"
	var error = http.request(url)

	if error != OK:
		print("Gagal request:", error)

func _on_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		print("Server error:", response_code)
		return

	var text = body.get_string_from_utf8()
	print("Response:", text)

	var data = JSON.parse_string(text)

	if data == null:
		print("JSON tidak valid")
		return

	user_list.clear()

	for user in data:
		var info = "ID: %s | Username: %s | Role: %s" % [
			user.get("id", ""),
			user.get("username", ""),
			user.get("role", "")
		]

		user_list.add_item(info)
