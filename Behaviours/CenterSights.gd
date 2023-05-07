extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	children[0].pos =[0,0]
	children[1].pos =[0,1]
	children[1].set_flip_v(true)
	children[2].pos =[1,0]
	children[2].set_flip_v(true)
	children[3].pos =[1,1]
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var parent = get_parent()
	var deltapos = parent.get_global_position().distance_to(get_global_mouse_position())
	set_position(Vector2(deltapos,0).rotated(deg_to_rad(parent.creatureObject.RotationOffset)))
