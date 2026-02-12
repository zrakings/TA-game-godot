extends Control

# Referensi node
@onready var username_input = $VBoxContainer/UsernameInput
@onready var password_input = $VBoxContainer/PasswordInput
@onready var role_option = $VBoxContainer/RoleOption
@onready var status_label = $VBoxContainer/statusLabel
@onready var register_button = $VBoxContainer/RegistrationButton
@onready var http = $HTTPRequest

func _ready():
	print("Register scene ready")

	# Pastikan role_option adalah OptionButton sebelum dipakai
	if role_option is OptionButton:
		if role_option.get_item_count() == 0:
			role_option.add_item("player")
			role_option.add_item("admin")
	else:
		print("Error: RoleOption bukan OptionButton!")

	# Connect tombol register
	register_button.pressed.connect(_on_register_button_pressed)

	# Connect HTTPRequest signal
	http.request_completed.connect(_on_request_completed)

# Tombol register ditekan
func _on_register_button_pressed():
	if role_option is not OptionButton:
		status_label.text = "RoleOption salah tipe!"
		return

	var username = username_input.text.strip_edges()
	var password = password_input.text.strip_edges()
	var role = role_option.get_item_text(role_option.selected)

	if username == "" or password == "":
		status_label.text = "Username dan Password wajib diisi"
		return

	# Data yang dikirim ke server
	var data = {
		"username": username,
		"password": password,
		"role": role
	}
	var json_string = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	var url = "http://localhost/ta_api/register.php"

	var err = http.request(url, headers, HTTPClient.METHOD_POST, json_string)
	if err != OK:
		status_label.text = "Gagal mengirim request"
		print("HTTP Request error:", err)
	else:
		status_label.text = "Mengirim data..."

# Response dari server
func _on_request_completed(_result, response_code, _headers, body):
	var response_text = body.get_string_from_utf8()
	print("Server response:", response_text)

	if response_code != 200:
		status_label.text = "Server error: %d" % response_code
		return

	var response = JSON.parse_string(response_text)
	if response == null:
		status_label.text = "Respon server tidak valid"
		return

	match response.get("status", ""):
		"success":
			status_label.text = "Register berhasil!"
			await get_tree().create_timer(1.5).timeout
			get_tree().change_scene_to_file("res://login.tscn")
		"exists":
			status_label.text = "Username sudah digunakan"
		_:
			status_label.text = "Terjadi kesalahan"
