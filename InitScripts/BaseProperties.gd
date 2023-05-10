extends Node2D

signal shootprojectile(origin,creature,script)
signal spawnEnemy(origin,group,seeker,creature,gun,script)
enum {
	SLEEPING,CHASING,ATTACKING,SEARCHING,DEAD
}

func GunAppearance(Sprite = null, Offset = Vector2(0,0), Scale = Vector2(1,1), shootsfx = null, cockSFX = null,pulloutsfx = null, reloadsfx = null ):
	var gunAppearance = {
		"Sprite":Sprite,
		"Offset":Offset,
		"Scale":Scale,
		"ShootSFX":shootsfx,
		"DrawSFX":pulloutsfx,
		"ReloadSFX":reloadsfx,
		"cockSFX":cockSFX,
	}
	return gunAppearance.duplicate()

func Gun(gunnode,bulletwait = 1,damage = 1,speed = 10000 ,maxdistance = 10000,basespread = 5,spreadmultiplier = 0.1, Magazine=30, ReloadWait = 1,SingleShotReload = false,bulletamount = 1, gunappearance = GunAppearance()):
			var gun = {
			"GunNode":gunnode,
			"CanFire":true,
			"InterruptReload":false,
			"BulletsRemaining":Magazine,
			"IsReloading":false,
			"BulletWait":bulletwait,
			"Damage": damage,
			"Speed":speed,
			"Range":maxdistance,
			"BaseSpread":basespread,  #expressed in degrees
			"SpreadMultiplier":spreadmultiplier,
			"Magazine":Magazine,
			"ReloadWait":ReloadWait,
			"SingleShotReload":SingleShotReload,
			"BulletAmount":bulletamount,
			"gunAppearance":gunappearance,
}
			return gun.duplicate()
				
func SKey(KEY, functioncheck):
	var key = {
		"Value":KEY,
		"FunctionCheck":functioncheck,
	}
	return key

func isObjectVisible(obj,obj2):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(obj.global_position,obj2.global_position)
	var result = space_state.intersect_ray(query)
	if result.collider == obj2:
		return true
	return false

func Creature(target,health = 100,movementforce = [10**4,10**4,10**4,10**4],mass = 100,turnforce =10000,rotationoffset=0,gun = null,projectileoffset = Vector2(50,0),team = "None"):
		var creature = {
		"State":0,
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
func setGunAppearance(GunNode, Gunappearance):
	GunNode.texture = Gunappearance.Sprite
	GunNode.position = Gunappearance.Offset
	GunNode.scale = Gunappearance.Scale
	
func BulletSpread(creature):
	var gun = creature.Gun
	var velocity = creature.Target.get_linear_velocity()
	var actualVelocity = sqrt(velocity.x**2+velocity.y**2)
	var Rand_angle = (actualVelocity*gun.SpreadMultiplier+gun.BaseSpread)/2
	return randf_range(-Rand_angle,Rand_angle)
	
func ShootProjectile(creature): 
	var gun = creature.Gun
	if gun.CanFire:
		if not gun.IsReloading:
			if gun.BulletsRemaining > 0:
				gun.CanFire = false
				var actual_rotation = creature.Target.global_rotation_degrees+creature.RotationOffset
				var rotatedOrigin = creature.Target.get_global_position() +(creature.ProjectileOffset.rotated(deg_to_rad(actual_rotation)))
				for i in range(gun.BulletAmount):
					var randomspread = BulletSpread(creature)
					shootprojectile.emit(rotatedOrigin,actual_rotation+randomspread,gun.Damage,gun.Speed,creature.Team,gun.Range)
				gun.BulletsRemaining-= 1
				await sleep(gun.BulletWait)
				gun.CanFire = true
			else:
				reloadGun(gun)
		else:
			gun.InterruptReload = true
func sleep(t):
	await get_tree().create_timer(t).timeout

	
func inRange(creature, point2):
	var actual_rotation = creature.Target.global_rotation_degrees+creature.RotationOffset
	var rotatedOrigin = creature.Target.get_global_position() +(creature.ProjectileOffset.rotated(deg_to_rad(actual_rotation)))
	if (rotatedOrigin).distance_to(point2)>creature.Gun.Range:
		return false
	else:
		return true

func reloadGun(gun):
	if not gun.IsReloading:
		gun.IsReloading = true
		if gun.SingleShotReload:
			print(gun.BulletsRemaining)
			while not gun.InterruptReload and gun.BulletsRemaining<gun.Magazine:
				await sleep(gun.ReloadWait/gun.Magazine)
				gun.BulletsRemaining += 1
				print(gun.BulletsRemaining)
			gun.InterruptReload = false
		else:
			print(gun.BulletsRemaining)
			await sleep(gun.ReloadWait)
			gun.BulletsRemaining = gun.Magazine
			print(gun.BulletsRemaining)
		gun.IsReloading = false

func SpawnEnemy(origin,creature,script,scriptToExec = null):
	spawnEnemy.emit(origin,creature,script,scriptToExec)

# Called when the node enters the scene tree for the first time.
func _Init():
	pass

func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
