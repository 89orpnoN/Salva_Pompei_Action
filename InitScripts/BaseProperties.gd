extends Node2D

signal shootprojectile(origin,creature,script)
signal spawnEnemy(origin,group,seeker,creature,gun,script)
enum {
	SLEEPING,CHASING,ATTACKING,SEARCHING,DEAD
}

func GunAppearance(Sprite = null,DropSprite = null, BuySprite=null,KillSprite=null, Offset = Vector2(0,0), Scale = Vector2(1,1), shootsfx = null, cockSFX = null,pulloutsfx = null, reloadsfx = null ):
	var gunAppearance = {
		"Sprite":Sprite,
		"DropSprite":DropSprite,
		"BuySprite":BuySprite,
		"KillSprite":KillSprite,
		"Offset":Offset,
		"Scale":Scale,
		"ShootSFX":shootsfx,
		"DrawSFX":pulloutsfx,
		"ReloadSFX":reloadsfx,
		"CockSFX":cockSFX,
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

func CreatureLink(Creature,target,gunnode):
	Creature.Target = target
	Creature.Gun.GunNode = gunnode
	setGunAppearance(gunnode,Creature.Gun.gunAppearance)

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
	
func EquipGun(creature,gun,target,gunnode):
	creature.Gun = gun
	CreatureLink(creature,target,gunnode)
	setGunAppearance(creature.Gun.GunNode, creature.Gun.gunAppearance)
	PlaySound(creature.Target,creature.Gun.gunAppearance.DrawSFX)
	
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
				PlaySound(creature.Gun.GunNode,creature.Gun.gunAppearance.ShootSFX)
				for i in range(gun.BulletAmount):
					var randomspread = BulletSpread(creature)
					shootprojectile.emit(rotatedOrigin,actual_rotation+randomspread,gun.Damage,gun.Speed,creature.Team,gun.Range)
				gun.BulletsRemaining-= 1
				var cockwait = 0
				if creature.Gun.SingleShotReload:
					cockwait = 0.4
					await sleep(cockwait)
					PlaySound(creature.Gun.GunNode,creature.Gun.gunAppearance.CockSFX)
				await sleep(gun.BulletWait-cockwait)
				gun.CanFire = true
			else:
				reloadGun(gun)
		else:
			gun.InterruptReload = true
			
func sleep(t):
	await get_tree().create_timer(t).timeout


func PlaySound(node,sound):
	if sound != null:
		var audio_player = AudioStreamPlayer2D.new()
		audio_player.stream = sound
		node.add_child(audio_player)
		audio_player.play(0)
		audio_player.connect("finished",audio_player.queue_free)
		await sleep(10)
	else:
		print("sound: " + str(sound) + " is null")

func inRange(creature, point2):
	var actual_rotation = creature.Target.global_rotation_degrees+creature.RotationOffset
	var rotatedOrigin = creature.Target.get_global_position() +(creature.ProjectileOffset.rotated(deg_to_rad(actual_rotation)))
	if (rotatedOrigin).distance_to(point2)>creature.Gun.Range:
		return false
	else:
		return true

func reloadGun(gun):
	if not gun.IsReloading and gun.BulletsRemaining<gun.Magazine:
		gun.IsReloading = true
		if gun.SingleShotReload:
			print(gun.BulletsRemaining)
			while not gun.InterruptReload and gun.BulletsRemaining<gun.Magazine:
				print(gun.InterruptReload)
				PlaySound(gun.GunNode,gun.gunAppearance.ReloadSFX)
				await sleep(gun.ReloadWait/gun.Magazine)
				if not gun.InterruptReload or gun.BulletsRemaining==0:
					gun.BulletsRemaining += 1
					print(gun.BulletsRemaining)
				
		else:
			PlaySound(gun.GunNode,gun.gunAppearance.ReloadSFX)
			print(gun.BulletsRemaining)
			await sleep(gun.ReloadWait)
			gun.BulletsRemaining = gun.Magazine
			print(gun.BulletsRemaining)
		gun.IsReloading = false
		gun.InterruptReload = false

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
