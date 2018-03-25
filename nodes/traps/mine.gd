extends Area2D

var value = 5
var enabled = true

func _ready():
	pass

func _on_mine_body_entered( body ):
	if enabled:
		if body.is_in_group(global.PLAYER_GROUP):
			body.takeDamage(value)
		$anim.play("destroy")
		$sfx.play()
		$"../../camera".screen_shake()

func disable():
	enabled = false