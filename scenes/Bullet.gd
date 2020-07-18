extends KinematicBody2D

var Direction = Vector2(0.0, 0.0)

func _ready():
	Direction = Direction.normalized() * 100.0
	$Sprite.rotation += Direction.angle()

func _physics_process(delta):
	var collision = move_and_collide(Direction)
	if collision:
		var body = collision.collider
		if body.is_in_group("Enemy"):
			body.queue_free()
			Global.Instability = max(Global.Instability - 0.02, 0.0)
		else:
			Global.Instability += 0.01
		queue_free()
