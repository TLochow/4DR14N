extends Node2D

var GameOver = false

var MapColor = 0.0

func _init():
	randomize()

func _ready():
	Global.Instability = 0.0
	MapColor = randf()

func _process(delta):
	if GameOver:
		Global.Instability = min(Global.Instability + delta, 1.0)
	else:
		Global.Instability += delta * 0.0001
		
		MapColor += delta * 0.1
		if MapColor > 1.0:
			MapColor -= 1.0
		$Navigation2D/TileMap.modulate = Color.from_hsv(MapColor, 0.2, 1.0)
		
		if Global.Instability > 0.04:
			GameOver = true
	$CanvasLayer/ColorRect.get_material().set_shader_param("Intensity", Global.Instability)
	print(Global.Instability)
