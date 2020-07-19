extends Node2D

func SetLowPassEnabled(value):
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, value)

func PlayPlayerHit():
	$PlayerHit.play()
	
func PlayEnemyHit():
	$EnemyHit.play()
	
func PlayWallHit():
	$WallHit.play()
