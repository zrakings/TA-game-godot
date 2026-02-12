extends Control

@onready var username_input = $Username
@onready var password_input = $Password
@onready var status_label = $StatusLabel
@onready var http = $HTTPRequest

func _ready():
	http.request_completed.connect(_on_request_completed)

func _on_Button_pressed():
	var url = "http://localhost/ta_api/login.php"

	var data = {
		"username": username_input.text,
		"password": password_input.text
	}

	var json_string = JSON.stringify(data)
	print("JSON dikirim:", json_string)

	var headers = ["Content-Type: application/json"]

	var err = http.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		json_string
	)

	print("Error request:", err)

func _on_request_completed(result, response_code, headers, body):
	print("Response:", body.get_string_from_utf8())
	status_label.text = body.get_string_from_utf8()
