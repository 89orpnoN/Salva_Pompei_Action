extends Node

signal shootprojectile(origin,angle,DMG,Speed,group)

func Gun(bulletwait = 1,damage = 1,speed = 10000 ,maxdistance = 10000,basespread = 5 ,spreadmultiplier = 0.1,bulletamount = 1):
			var gun = {
			"BulletDelta":0,
			"BulletWait":bulletwait,
			"Damage": damage,
			"Speed":speed,
			"Range":maxdistance,
			"BaseSpread":basespread,  #expressed in degrees
			"SpreadMultiplier":spreadmultiplier,
			"BulletAmount":bulletamount,
}
			return gun.duplicate()
				

func Creature(target,health = 100,movementforce = [10**4,10**4,10**4,10**4],mass = 100,turnforce =10000,rotationoffset=0,gun = Gun(),projectileoffset = Vector2(50,0),team = "None"):
		var creature = {
		"Target":target,
		"Health":health,
		"MovementForce":movementforce,
		"Mass":mass,
		"TurnForce":turnforce,
		"RotationOffset":rotationoffset,
		"Gun": gun,
		"ProjectileOffset":projectileoffset,
		"Team":team,
}
		return creature.duplicate()

func BulletSpread(creature, gun):
	var velocity = creature.Target.get_linear_velocity()
	var actualVelocity = sqrt(velocity.x**2+velocity.y**2)
	var Rand_angle = (actualVelocity*gun.SpreadMultiplier+gun.BaseSpread)/2
	return randf_range(-Rand_angle,Rand_angle)
	
func ShootProjectile(creature,gun):
	if gun.BulletDelta>gun.BulletWait:
		var actual_rotation = creature.Target.global_rotation_degrees+creature.RotationOffset
		var rotatedOrigin = creature.Target.get_global_position() +(creature.ProjectileOffset.rotated(deg_to_rad(actual_rotation)))
		for i in range(gun.BulletAmount):
			var randomspread = BulletSpread(creature, gun)
			shootprojectile.emit(rotatedOrigin,actual_rotation+randomspread,gun.Damage,gun.Speed,creature.Team,gun.Range)
		gun.BulletDelta = 0
	
# Called when the node enters the scene tree for the first time.
func _Init():
	pass

func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
