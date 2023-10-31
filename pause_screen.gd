extends Control

signal unpause_game()

func _on_button_pressed():
	unpause_game.emit()

func _on_quit_pressed():
	get_tree().quit()
