extends Control

signal reset_score()

func set_score(value):
	$Score.text = 'SCORE: ' + str(value)
	
func set_high_score(value):
	$Highscore.text = 'HI-SCORE: ' + str(value)

func _on_restart_btn_pressed():
	get_tree().reload_current_scene()

func _on_quit_btn_pressed():
	get_tree().quit()

func _on_reset_hi_score_pressed():
	reset_score.emit()
