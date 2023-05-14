extends Sprite2D
var parent
var Root
var pos
var velocity
# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	Root = parent.get_parent()
	set_position(position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Root.get_linear_velocity()
	var actualVelocity = sqrt(velocity.x**2+velocity.y**2)
	var dist = BaseClasses.RotatedOrigin(Root.creatureObject).distance_to(get_global_mouse_position())*(BaseClasses.MaxBulletSpread(Root.creatureObject)/90)
	var position = Vector2()
	
	
	if pos[0]:
		position.y= - dist
		
	else:
		position.y=  dist
		
	if pos[1]:
		position.x= - dist
	else:
		position.x=  dist
	set_position(position)
