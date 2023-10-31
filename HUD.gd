extends Control

signal paused(button_pressed)

@onready var score = $ScoreLabel:
	set(value):
		score.text = 'SCORE: ' + str(value)

