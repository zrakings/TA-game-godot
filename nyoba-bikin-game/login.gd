extends Control

@onready var username_input = $VBoxContainer/username
@onready var password_input = $VBoxContainer/password
@onready var status_label = $VBoxContainer/status
@onready var http = $VBoxContainer/HTTPRequest


func _ready():
	http.request_completed.connect(_on_request_completed)


func _on_login_pressed():
	var username = username_input.text.strip_edges()
	var password = password_input.text.strip_edges()

	if username == "" or password == "":
		status_label.text = "Username dan Password wajib diisi"
		return

	var url = "http://localhost/ta_api/login.php"

	var data = {
		"username": username,
		"password": password
	}

	var json_string = JSON.stringify(data)

	var headers = [
		"Content-Type: application/json"
	]

	var error = http.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		json_string
	)

	if error != OK:
		status_label.text = "Gagal mengirim request"
		print("Error code:", error)
	else:
		status_label.text = "Mengirim data..."
		print("JSON terkirim:", json_string)


func _on_request_completed(_result, response_code, _headers, body):
	var response_text = body.get_string_from_utf8()
	print("Response:", response_text)

	if response_code != 200:
		status_label.text = "Server error: " + str(response_code)
		return

	var response = JSON.parse_string(response_text)

	if response == null:
		status_label.text = "Respon server tidak valid"
		return

	match response.get("status", ""):
		"success":
			status_label.text = "Login Berhasil!"
			await get_tree().create_timer(1.0).timeout
			get_tree().change_scene_to_file("res://main_menu.tscn")

		"wrong_password":
			status_label.text = "Password Salah"

		"not_found":
			status_label.text = "User tidak ditemukan"

		_:
			status_label.text = "Terjadi kesalahan"
			
			


func _on_register_pressed() -> void:
	get_tree().change_scene_to_file("res://register.tscn")
