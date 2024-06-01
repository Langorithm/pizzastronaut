extends Node

const MENU_MUSIC_LOOP = preload("res://¡placeholders/menu_music_loop.ogg")
@onready var credits_container: TabContainer = %CreditsContainer
@onready var start_buttons: VBoxContainer = %StartButtons
@onready var options_menu: HBoxContainer = %OptionsMenu


func _ready() -> void:
	SM.play(MENU_MUSIC_LOOP, SM.CH_MUSIC)
	start_buttons.grab_focus()


func _input(event):
	if event.as_text() == "Q":
		get_tree().quit()


func _on_start_button_pressed() -> void:
	pass


func _on_options_button_pressed() -> void:
	start_buttons.hide()
	options_menu.show()



func _on_credits_button_pressed() -> void:
	start_buttons.hide()
	credits_container.show()


func _on_close_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _on_credits_back_button_pressed() -> void:
	credits_container.hide()
	start_buttons.show()


func _on_start_buttons_visibility_changed() -> void:
	if start_buttons and start_buttons.visible:
		start_buttons.grab_focus()
