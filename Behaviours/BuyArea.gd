extends Area2D

var AreaObject
var insidenodes = []
# Called when the node enters the scene tree for the first time.
var ItemButtons
func _ready():
	self.body_entered.connect(NodeEntered)
	self.body_exited.connect(NodeExited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func NodeEntered(node):
	insidenodes.append(node)

func NodeExited(node):
	insidenodes.erase(node)
	
func tryOpen(playernode):
	if AreaObject.Enabled:
		if playernode in insidenodes:
			return true
	return false

