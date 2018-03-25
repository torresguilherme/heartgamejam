extends Area2D

var value = 4
var activeTime = 2
var inactiveTime = 1
var counter = 1
var active = false

func _ready():
	pass

func _process(delta):
	if active:
		visible = true
	else:
		visible = false
	counter -= delta
	if counter <= 0:
		if active:
			active = false
			counter = inactiveTime
		else:
			active = true
			counter = activeTime
			$sfx.play()

func _on_spark_body_entered( body ):
	if body.is_in_group(global.PLAYER_GROUP) && visible:
		body.takeDamage(value)
