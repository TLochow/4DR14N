extends Node2D

var ENEMYSCENE = preload("res://scenes/Enemy.tscn")

var GameOver = false

var MapColor = 0.0

onready var GameCamera = $Camera2D
onready var Player = $Player

onready var SpawnPoints = $SpawnPoints.get_children()

var Bullet

var SlowDownTime = 0.1

func _init():
	randomize()

func _ready():
	SoundController.SetLowPassEnabled(false)
	Global.Instability = 0.0
	Global.GameSpeed = 1.0
	Global.Score = 0
	Global.BulletTime = false
	MapColor = randf()
	_on_Timer_timeout()

func _process(delta):
	if GameOver:
		Global.Instability = min(Global.Instability + delta, 1.0)
	else:
		Global.Instability += delta * 0.0001 * Global.GameSpeed
		$Timer.wait_time = max($Timer.wait_time - (delta * 0.01), 1.0)
		
		MapColor += delta * 0.1
		if MapColor > 1.0:
			MapColor -= 1.0
		$Navigation2D/TileMap.modulate = Color.from_hsv(MapColor, 0.2, 1.0)
		
		if Global.Instability > 0.04:
			GameOver = true
			$CanvasLayer2/Control/Label2.text = "You terminated " + str(Global.Score) + " Bad Subroutines."
			$CanvasLayer2/Control.visible = true
	if Global.BulletTime:
		GameCamera.set_position(Bullet.get_position())
	else:
		GameCamera.set_position(Player.get_position())
	GameCamera.zoom = Vector2(1.0, 1.0) * range_lerp(Global.GameSpeed, 0.2, 1.0, 0.6, 1.0)
	$CanvasLayer/ColorRect.get_material().set_shader_param("Intensity", Global.Instability)

func _input(event):
	if GameOver and event.is_action_pressed("mouse_left"):
		SceneChanger.ChangeScene("res://scenes/Main.tscn")
	elif event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()

func _on_Player_Shoot(bullet):
	Global.BulletTime = true
	Bullet = bullet
	bullet.connect("Hit", self, "_on_Bullet_Hit")
	$Tween.interpolate_property(Global, "GameSpeed", 1.0, SlowDownTime, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	SoundController.SetLowPassEnabled(true)

func _on_Bullet_Hit():
	Global.BulletTime = false
	$Tween.interpolate_property(Global, "GameSpeed", SlowDownTime, 1.0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	SoundController.SetLowPassEnabled(false)

func _on_Timer_timeout():
	var playerPos = Player.get_position()
	var valid = false
	while not valid:
		var pos = SpawnPoints[randi() % SpawnPoints.size()].get_position()
		if (playerPos - pos).length() > 850.0:
			valid = true
			var enemy = ENEMYSCENE.instance()
			enemy.set_position(pos)
			$Enemies.add_child(enemy)
