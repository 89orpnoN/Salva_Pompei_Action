extends RigidBody2D

var speed
var damage
var Team #da usare per determinare quali oggetti deve ignorare
var rotationValue
var range
var team
var originPosition

func _init():
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	set_rotation_degrees(rotation)

func _physics_process(delta):
	var body
	var collision = move_and_collide(speed * delta)
	if collision:
		body = collision.get_collider()
		var a = get_groups()
		if not "creatureObject" in body:
			queue_free()
		else:
			if not team == body.creatureObject.Team:
				body.creatureObject.Health -= damage
				queue_free()
			else:
				translate(speed * delta)
			
	if global_position.distance_to(originPosition) > range:
		queue_free()

func _process(delta):
	pass
