extends Node2D

onready var player = $player
onready var roomSize = Vector2(global.ROOM_WIDTH, global.ROOM_HEIGHT)

var depth = 5
var roomsPerFloor = [1, 3, 4, 5, 8]
var rooms = []
var valveRooms = []
var downPassages = []
var brick = preload("res://nodes/aux/brick.tscn")
var initialRoom = preload("res://nodes/rooms/initial-room.tscn")
var finalRoom = preload("res://nodes/rooms/final-room.tscn")
var sideBar = preload("res://nodes/aux/side-bar.tscn")
var vertBar = preload("res://nodes/aux/vert-bar.tscn")

func _ready():
	for i in range(4):
		rooms.append(load("res://nodes/rooms/room" + str(i) + ".tscn"))
	valveRooms.append(load("res://nodes/rooms/valve-room1.tscn"))
	valveRooms.append(load("res://nodes/rooms/valve-room2.tscn"))
	generateRooms()

func generateRooms():
	randomize()
	var level_matrix = []
	var roomsMax = 0
	for i in roomsPerFloor:
		if i > roomsMax:
			roomsMax = i
	
	for i in range(depth):
		level_matrix.append([])
		for j in range(roomsMax):
			level_matrix[i].append(0)
	
	var selectedRoom = randi()%roomsMax
	level_matrix[0][selectedRoom] = 1
	var roomQueue = [selectedRoom]
	downPassages.append(selectedRoom)
	
	var i = 1
	while (i < depth):
		var j = 0
		while j < roomsPerFloor[i]:
			var selected = randi()%(roomQueue.size())
			if level_matrix[i][roomQueue[selected]] == 0:
				level_matrix[i][roomQueue[selected]] = 1
				var temp = roomQueue[selected]
				roomQueue.remove(selected)
				if j == roomsPerFloor[i] - 1:
					roomQueue.clear()
					roomQueue.append(temp)
					downPassages.append(temp)
				else:
					if temp > 0:
						roomQueue.append(temp - 1)
					if temp < (roomsMax - 1):
						roomQueue.append(temp + 1)
				j += 1
		i += 1
	
	# instantiate rooms
	var initial_room = initialRoom.instance()
	initial_room.position = Vector2(downPassages[0] * global.ROOM_WIDTH, 0.0)
	add_child(initial_room)
	player.position = initial_room.position - Vector2(300, 0)
	
	i = 1
	while i < depth:
		var roomsCovered = 0
		for j in range(roomsMax):
			if level_matrix[i][j] == 1:
				var newRoom
				if roomsCovered == 0:
					newRoom = valveRooms[randi()%valveRooms.size()].instance()
				elif roomsCovered == roomsPerFloor[i] - 1:
					newRoom = valveRooms[randi()%valveRooms.size()].instance()
				else:
					newRoom = rooms[randi()%rooms.size()].instance()
				newRoom.global_position = Vector2(j * global.ROOM_WIDTH, i * global.ROOM_HEIGHT)
				add_child(newRoom)
				# add walls
				if roomsCovered == 0:
					var newWall = sideBar.instance()
					newWall.global_position = newRoom.get_node("positions").get_children()[0].position
					newRoom.get_node("wall").add_child(newWall)
				elif roomsCovered == roomsPerFloor[i] - 1:
					var newWall = sideBar.instance()
					newWall.global_position = newRoom.get_node("positions").get_children()[1].position
					newRoom.get_node("wall").add_child(newWall)
				if j != downPassages[i-1]:
					var newWall = vertBar.instance()
					newWall.global_position = newRoom.get_node("vert-positions").get_children()[0].position
					newRoom.get_node("wall").add_child(newWall)
				if j != downPassages[i]:
					var newWall = vertBar.instance()
					newWall.global_position = newRoom.get_node("vert-positions").get_children()[1].position
					newRoom.get_node("wall").add_child(newWall)
				roomsCovered += 1
		i += 1
	var final_room = finalRoom.instance()
	final_room.position = Vector2(downPassages[depth - 1] * global.ROOM_WIDTH, depth * global.ROOM_HEIGHT)
	add_child(final_room)

func gameOver():
	global.gameOver()

func victory():
	global.victory()