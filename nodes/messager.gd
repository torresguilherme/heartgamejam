extends StaticBody2D

var inReach = false
var line = 0
var dialogueStarted = false

var dialogueLines = [
"So, finally an adventurer who's brave enough to retrieve\n the eternal flame from here, eh?",
"Watch out when you're underwater. The more you strain\nyourself, the less oxygen you have.",
"On the other hand, if you're underwater, you can swim\nup with Z.",
"Also, the rooms below are full of traps. Beware of the\nmines on the ground, they're pretty sneaky.",
"Each floor has two valves. You can use them to drain the\nwater, so no need to stay underwater everytime.",
"And don't forget to keep track of your HP and oxygen\non the top side of the screen.",
"Good luck. Fuhuhuhuhuhu..."
]

onready var rect = $"canvas/rect"
onready var text = $"canvas/rect/text"
onready var player = $"../../player"

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("useObject") && inReach:
		if !dialogueStarted:
			startDialogue()
		else:
			dialogueForward()

func startDialogue():
	player.canMove = false
	rect.visible = true
	text.text = dialogueLines[0]
	dialogueStarted = true

func dialogueForward():
	if line == dialogueLines.size() - 1:
		line = 0
		dialogueStarted = false
		rect.visible = false
		player.canMove = true
	else:
		line += 1
		text.text = dialogueLines[line]
