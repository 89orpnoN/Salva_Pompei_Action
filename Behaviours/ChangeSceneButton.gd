extends Button

var levelportal
# Called when the node enters the scene tree for the first time.
func _ready():
	levelportal = get_meta("LevelPortal")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	get_tree().change_scene_to_file(levelportal)
