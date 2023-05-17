extends RigidBody2D

var creatureObject
# Called when the node enters the scene tree for the first time.
func _ready():
	creatureObject = BaseItems.GetProp("Box")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if creatureObject.Health <= 0:
		queue_free()
