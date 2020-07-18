extends KinematicBody2D

onready var nav = get_tree().get_nodes_in_group("Nav")[0]
var path = []

var Active = false
var Player

func _ready():
	$Sprite.rotation = rand_range(-PI, PI)

func _physics_process(delta):
	if Active:
		var pos = get_position()
		if path.size() > 0:
			var nextPos = path[0]
			var dirToNextPos = nextPos - pos
			if dirToNextPos.length() < 10.0:
				path.remove(0)
			move_and_slide(dirToNextPos.normalized() * 500.0)
			$Sprite.rotation = dirToNextPos.angle() + 1.570796
		else:
			path = nav.get_simple_path(pos, Player.get_position(), false)

func _on_Area2D_body_entered(body):
	if not Active:
		Active = true
		Player = body

func _on_Area2D2_body_entered(body):
	Global.Instability += 0.01
	call_deferred("queue_free")
