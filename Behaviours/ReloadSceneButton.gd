extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	
	connect("pressed",onpress)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func onpress():
	get_tree().reload_current_scene()
