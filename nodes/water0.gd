extends Area2D

var bubbles = preload("res://nodes/aux/bubbles.tscn")

func _ready():
	add_to_group(global.WATER_GROUP)

func drain():
	$Tween.interpolate_property(self, "position", position, position + Vector2(0.0, global.ROOM_HEIGHT/2), 2.0, Tween.TRANS_BACK, Tween.TRANS_LINEAR)
	$Tween.start()

func _on_water0_body_entered( body ):
	var b = bubbles.instance()
	b.position = body.position + Vector2(0.0, 64.0)
	$"../".add_child(b)

func _on_water0_body_exited( body ):
	var b = bubbles.instance()
	b.position = body.position + Vector2(0.0, 64.0)
	$"../".add_child(b)

func _on_water0_area_entered( area ):
	if area.is_in_group(global.PLAYER_HEAD_GROUP):
		area.get_node("../").underWater = true

func _on_water0_area_exited( area ):
	if area.is_in_group(global.PLAYER_HEAD_GROUP):
		area.get_node("../").underWater = false
