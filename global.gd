extends Node

var PLAYER_GROUP = "player"
var WATER_GROUP = "water"
var PLAYER_HEAD_GROUP = "player-head"

var ROOM_HEIGHT = 64 * 8
var ROOM_WIDTH = 64 * 16

var scenes = []

func _ready():
	scenes.append(load("res://levels/main.tscn"))
	scenes.append(load("res://levels/game-over-screen.tscn"))
	scenes.append(load("res://levels/credits.tscn"))

func gameOver():
	get_tree().change_scene_to(scenes[1])

func victory():
	get_tree().change_scene_to(scenes[2])
