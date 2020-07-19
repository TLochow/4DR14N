extends Control

func _input(event):
	if event.is_action_pressed("mouse_left"):
		SceneChanger.ChangeScene("res://scenes/Instructions.tscn")
	elif event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()
