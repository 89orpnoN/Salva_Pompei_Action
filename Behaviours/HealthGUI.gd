extends RichTextLabel

var Player
# Called when the node enters the scene tree for the first time.
func _ready():
	Player = get_parent().get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = str(round(Player.creatureObject.Health.Health)) + "  " + str(round(Player.creatureObject.Health.TempHealth))
