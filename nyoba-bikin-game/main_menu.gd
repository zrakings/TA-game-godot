extends Control


# Called when the node enters the scene tree for the first time.
@onready var mainbuttons: VBoxContainer = $mainbuttons
@onready var settings: Panel = $settings


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _ready():
	mainbuttons.visible = true
	settings.visible = false


func _on_start_pressed() -> void:
	print("Start ditekan")


func _on_settings_pressed() -> void:
	mainbuttons.visible = false
	settings.visible = true


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_back_settings_pressed() -> void:
	_ready()
