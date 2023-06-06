extends RigidBody2D

var speed
var damage
var Team #da usare per determinare quali oggetti deve ignorare
var rotationValue
var range
var team
var originPosition
var Father
var genericHitSound
func _init():
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	set_rotation_degrees(rotation)
	genericHitSound = load("res://SFX/BulletImpact/Wallmpact.wav")

func _physics_process(delta):
	var body
	var collision = move_and_collide(speed * delta)
	if collision:
		body = collision.get_collider()
		if not "creatureObject" in body:
			BaseClasses.PlaySound(body,genericHitSound)
			queue_free()
		else:
			if not team == body.creatureObject.Team:
				if !BaseClasses.ScaleHealth(body.creatureObject.Health,damage):
					body.Die(Father)
				if body.creatureObject.CreatureAppearance != null:
					BaseClasses.PlaySound(body,body.creatureObject.CreatureAppearance.HitSfx)
				else:
					BaseClasses.PlaySound(body,genericHitSound)
				queue_free()
			else:
				translate(speed * delta)
			
	if global_position.distance_to(originPosition) > range:
		queue_free()

func _process(delta):
	pass
