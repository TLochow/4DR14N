extends KinematicBody2D

onready var nav = get_tree().get_nodes_in_group("Nav")[0]
var path = []

onready var Player = get_tree().get_nodes_in_group("Player")[0]
onready var FreeCast = $RayCast2D

var Speed = 100.0

func _physics_process(delta):
	var pos = get_position()
	var playerPos = Player.get_position()
	FreeCast.cast_to = to_local(playerPos)
	if path.size() > 0:
		var nextPos = path[0]
		var dirToNextPos = nextPos - pos
		if dirToNextPos.length() < 10.0:
			path.remove(0)
		if FreeCast.is_colliding():
			Speed = lerp(Speed, 100.0, 0.1)
		else:
			Speed = lerp(Speed, 800.0, 0.1)
		move_and_slide(dirToNextPos.normalized() * Speed * Global.GameSpeed)
		$Sprite.rotation = dirToNextPos.angle() + 1.570796
	else:
		path = nav.get_simple_path(pos, playerPos, false)

func _on_Area2D2_body_entered(body):
	Global.Instability += 0.005
	SoundController.PlayPlayerHit()
	call_deferred("queue_free")
