extends KinematicBody2D

signal Shoot(bullet)
var BULLETSCENE = preload("res://scenes/Bullet.tscn")

onready var BulletsNode = get_tree().get_nodes_in_group("BulletsNode")[0]

func _physics_process(delta):
	var motion = Vector2(0.0, 0.0)
	
	if Input.is_action_pressed("ui_left"):
		motion += Vector2(-1.0, 0.0)
	if Input.is_action_pressed("ui_right"):
		motion += Vector2(1.0, 0.0)
	if Input.is_action_pressed("ui_up"):
		motion += Vector2(0.0, -1.0)
	if Input.is_action_pressed("ui_down"):
		motion += Vector2(0.0, 1.0)
	
	motion = motion.normalized() * 300.0 * Global.GameSpeed
	
	move_and_slide(motion)
	
	var mousePos = .get_global_mouse_position()
	var pos = get_position()
	var dirToMouse = mousePos - pos
	
	$Sprite.rotation = dirToMouse.angle() + 1.570796
	
	if Input.is_action_just_pressed("mouse_left") and not Global.BulletTime:
		$Shoot.play()
		var bullet = BULLETSCENE.instance()
		bullet.Direction = dirToMouse
		bullet.set_position(pos + dirToMouse.normalized() * 60.0)
		BulletsNode.add_child(bullet)
		emit_signal("Shoot", bullet)
