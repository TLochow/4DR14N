extends KinematicBody2D

signal Hit

var Direction = Vector2(0.0, 0.0)

func _ready():
	$Sprite.rotation += Direction.angle()

func _physics_process(delta):
	var pos = get_position()
	var mousePos = .get_global_mouse_position()
	Direction = mousePos - pos
	var angle = lerp_angle($Sprite.rotation - deg2rad(90.0), Direction.angle(), 0.1)
	Direction = Vector2(cos(angle), sin(angle))
	var collision = move_and_collide(Direction.normalized() * 10.0 * range_lerp(Global.GameSpeed, 0.2, 1.0, 0.6, 1.0))
	$Sprite.rotation = angle + deg2rad(90.0)
	if collision:
		emit_signal("Hit")
		var body = collision.collider
		if body.is_in_group("Enemy"):
			SoundController.PlayEnemyHit()
			body.queue_free()
			Global.Instability = max(Global.Instability - 0.02, 0.0)
			Global.Score += 1
		elif body.is_in_group("Player"):
			Global.Instability += 0.005
			SoundController.PlayPlayerHit()
		else:
			Global.Instability += 0.0025
			SoundController.PlayWallHit()
		queue_free()

static func lerp_angle(a: float, b: float, t: float, reset_rotation: bool = false) -> float:
	if reset_rotation:
		a = adjust_rotation_for_a_round(a)
	if abs(a-b) >= PI:
		if a > b:
			a = normalize_angle(a) - 2.0 * PI
		else:
			b = normalize_angle(b) - 2.0 * PI
	return lerp(a, b, t)

static func normalize_angle(x: float)  -> float:
	return fposmod(x + PI, 2.0*PI) - PI

static func adjust_rotation_for_a_round(rotation: float) -> float:
	if rotation > 2 * PI:
		return 2 * PI - rotation
	if rotation < -2 * PI:
		return 2 * PI + rotation
	return rotation
