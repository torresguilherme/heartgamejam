extends RayCast2D

var player

func _ready():
	player = $"../"

func _process(delta):
	if is_colliding():
		player.onGround = true
	else:
		player.onGround = false