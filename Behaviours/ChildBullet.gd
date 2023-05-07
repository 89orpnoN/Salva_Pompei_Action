extends RigidBody2D

var speed
var damage
var Team #da usare per determinare quali oggetti deve ignorare
var rotationValue
var range
var team
var originPosition
func _init():
	originPosition = get_global_position()
# Called when the node enters the scene tree for the first time.
func _ready():
	set_rotation_degrees(rotation)


func body_entered(body):
	print("collisone con proiettile")
	if not body.is_in_group(get_groups()[0]):
		print("è del team")
		if not body.creatureObject == null:
			print("salute sottratta")
			body.creatureObject.Health -= damage

func _process(delta):
	var body
	var collision = move_and_collide(speed * delta)
	if collision:
		body = collision.get_collider()
		print("collisone con proiettile")
		var a = get_groups()
		if body.is_in_group(a[1]):
			print("è del team")
			
		else:
			if "creatureObject" in body:
				print("salute sottratta")
				body.creatureObject.Health -= damage
			queue_free()
	var deltaPosition = get_global_position()-originPosition
	if deltaPosition.y**2+deltaPosition.x**2 > range**2:
		print("bro eliminati")
		queue_free()

		
