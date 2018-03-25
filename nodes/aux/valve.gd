extends Area2D

var inReach = false
var flipped = false

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("useObject") && inReach && !flipped:
		flipped = true
		$"../../water0".drain()
		$sfx.play()

func _on_valve_area_entered( area ):
	if area.is_in_group(global.PLAYER_HEAD_GROUP):
		inReach = true

func _on_valve_area_exited( area ):
	if area.is_in_group(global.PLAYER_HEAD_GROUP):
		inReach = false
