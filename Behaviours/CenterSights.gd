extends Sprite2D

var Parentcreature
var parent
var children
# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	
	children = get_children()
	children[1].set_flip_v(true)
	children[3].set_flip_v(true)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Parentcreature == null:
		Parentcreature = parent.creatureObject
	var deltapos = parent.get_global_position().distance_to(get_global_mouse_position())
	var Of = Parentcreature.ProjectileOffset
	Of = sqrt(Of.y**2 + Of.x**2)
	if deltapos < Of:
		deltapos = Of
		
	var velocity = parent.get_linear_velocity()
	var actualVelocity = sqrt(velocity.x**2+velocity.y**2)
	var dist = deltapos*(BaseClasses.MaxBulletSpread(parent.creatureObject)/90)
	position = Vector2()
	children[0].position = Vector2(-dist,-dist)
	children[1].position = Vector2(-dist,dist)
	children[2].position = Vector2(dist,dist)
	children[3].position = Vector2(dist,-dist)
	set_position(Vector2(deltapos,0).rotated(deg_to_rad(Parentcreature.RotationOffset)))
