extends Camera2D

onready var player = $"../../player"
var rot_speed = 0
var shake_intensity = 12
var rot_dir = 1

func _ready():
	pass

func _process(delta):
	if abs(global_position.x - player.position.x) < (global.ROOM_WIDTH/2) && abs(global_position.y - player.position.y) < (global.ROOM_HEIGHT/2 + 200):
		current = true 
	else:
		current = false
	
	if rot_speed > 0:
		rot_speed -= delta * 20
	elif rot_speed < 0:
		rot_speed = 0
	
	if rot_speed == 0:
		offset = Vector2(0.0, -32.0)
	else:
		offset += Vector2(0.0, rot_dir * rot_speed)
		rot_dir *= -1

func screen_shake():
	rot_speed = shake_intensity