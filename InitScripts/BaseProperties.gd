extends Node2D

signal shootprojectile(origin,creature,script)

signal spawnEnemy(origin,creature,script,function)

enum {SLEEPING,CHASING,ATTACKING,SEARCHING,DEAD} #states of behaviour for AI creatures.

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


func Gun(gunnode = null,bulletwait = 1,damage = 1,speed = 10000 ,maxdistance = 10000,Recoil = 1,basespread = 5,spreadmultiplier = 0.1, Magazine=30, ReloadWait = 1,SingleShotReload = false,bulletamount = 1, gunappearance = GunAppearance()):
	var gun = {
	"GunNode":gunnode,
	"CanFire":true,
	"AdditiveRecoil":0,
	"InterruptReload":false,
	"BulletsRemaining":Magazine,
	"IsReloading":false,
	"BulletWait":bulletwait,
	"Damage": damage,
	"Speed":speed,
	"Range":maxdistance,
	"BulletRecoil":Recoil,
	"BaseSpread":basespread,  #expressed in degrees
	"SpreadMultiplier":spreadmultiplier,
	"Magazine":Magazine,
	"ReloadWait":ReloadWait,
	"SingleShotReload":SingleShotReload,
	"BulletAmount":bulletamount,
	"gunAppearance":gunappearance,
	}
	return gun.duplicate()


func EquipGun(creature,gun,target,gunnode): #for first time equip only
	creature.Gun = gun
	CreatureLink(creature,target,gunnode)
	PlaySound(creature.Target,creature.Gun.gunAppearance.DrawSFX)


func ChangeGun(creature,Newgun): #can be called if the gun and the creature have been paired with the instance
	Newgun.CanFire = false
	var GunNode = creature.Gun.GunNode
	creature.Gun = Newgun
	CreatureLink(creature,creature.Target,GunNode)
	PlaySound(creature.Target,creature.Gun.gunAppearance.DrawSFX)
	var TrueReloadWait = Newgun.ReloadWait
	if Newgun.SingleShotReload:
		TrueReloadWait = Newgun.ReloadWait/Newgun.Magazine
	await sleep(TrueReloadWait)
	Newgun.CanFire = true


func CreatureAppearance(AnimNode,AnimFile,IdleAnim = "Idle",MeleeAnim = "Melee",ReloadAnim = "Reload",Offset = Vector2(0,0), Scale = Vector2(1,1),HitSfx = null,PainSfx = null,deathsfx = null,stepsfx = null):
	var CreatureAppearance = {
		"LastStep":[Vector2(),false],
		"AnimNode":AnimNode,
		"AnimFile":AnimFile,
		"IdleAnim":IdleAnim,
		"MeleeAnim":MeleeAnim,
		"ReloadAnim":ReloadAnim,
		"Offset":Offset,
		"Scale":Scale,
		"HitSfx":HitSfx,
		"PainSfx":PainSfx,
		"deathsfx":deathsfx,
		"stepsfxS":stepsfx,
	}	
	return CreatureAppearance.duplicate()


func Creature(target,health = 100,movementforce = [250000,250000,250000,250000],mass = 100,turnforce =100000,rotationoffset=0,gun = null,projectileoffset = Vector2(50,0),team = "None",CreatureAppearance = null):
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
	"CreatureAppearance":CreatureAppearance
	
	}
	return creature.duplicate()


func Morph(Target,AnimNode,Creature,NewTeam = Creature.Team): #to only use once in the same instance, if used more times the effect can be unpredictable
	Target.creatureObject = Creature
	Target.creatureObject.Team = NewTeam
	Target.add_to_group(NewTeam)
	if not (NewTeam in BaseItems.ActiveTeams):
		BaseItems.ActiveTeams.append(NewTeam)
	Target.scale = Target.creatureObject.CreatureAppearance.Scale
	Target.mass = Target.creatureObject.Mass
	Target.creatureObject.CreatureAppearance.AnimNode = AnimNode
	AnimNode.set_sprite_frames(Target.creatureObject.CreatureAppearance.AnimFile)
	AnimNode.set_animation(Target.creatureObject.CreatureAppearance.IdleAnim)


func CreatureLink(Creature,target,gunnode): #to use with the gun alredy paired to the Creature, can be used to set up the target and gun node
	Creature.Target = target
	Creature.Gun.GunNode = gunnode
	setGunAppearance(gunnode,Creature.Gun.gunAppearance)


func setGunAppearance(GunNode, Gunappearance): #makes the gun visibly change
	GunNode.texture = Gunappearance.Sprite
	GunNode.position = Gunappearance.Offset
	GunNode.scale = Gunappearance.Scale


func isObjectVisible(obj,obj2): #checks if there are nodes between first node and second node
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(obj.global_position,obj2.global_position)
	var result = space_state.intersect_ray(query)
	if result.collider == obj2:
		return true
	return false


func SKey(KEY, functioncheck): #key value paired with the function used to check if it is being pressed
	var key = {
		"Value":KEY,
		"FunctionCheck":functioncheck,
	}
	return key
	


func Stepping(Creature): #used to detect if a Creature should do the stepping sound
	var LastFootstep = Creature.CreatureAppearance.LastStep
	if LastFootstep[0].distance_to(Creature.Target.global_position)>50:
		if LastFootstep[1]:
			BaseClasses.PlaySound(self,Creature.CreatureAppearance.stepsfxS[0])
		else:
			BaseClasses.PlaySound(self,Creature.CreatureAppearance.stepsfxS[1])
		LastFootstep[1] = !LastFootstep[1]
		LastFootstep[0] = Creature.Target.global_position


func get_nodes_with_groups(groups,ExcludedGroups = null): #get all nodes that have these groups
	var nodes = Array()
	for i in groups:
		if i != null:
			if not (i in ExcludedGroups):
				nodes.append_array(get_tree().get_nodes_in_group(i))
	return nodes


func UpdateEveryX(secs,instance,function,arguments = null): #function that cycles forever if the instance exists and calls the function at regular intervals
	while instance !=null:
		
		if arguments != null:
			function.call(arguments)
		else:
			function.call()
		await sleep(secs)


func arrayAt(arr,idx): #gets the item in the array even if it's out of range
	if idx >= len(arr):
		return arr[idx-len(arr)]
	if idx < 0:
		return arr[idx+len(arr)]
	return arr[idx]


func DissipateRecoil(delta,gun): #makes the recoil variable reduce, should be called every frame
	if gun.AdditiveRecoil>0:
		gun.AdditiveRecoil -=60*delta


func MaxBulletSpread(creature): #gets the possible spred of directions for the bullets
	var gun = creature.Gun
	var velocity = creature.Target.get_linear_velocity()
	var actualVelocity = sqrt(velocity.x**2+velocity.y**2)
	var Inaccuracy = (actualVelocity*gun.SpreadMultiplier+gun.BaseSpread+gun.AdditiveRecoil)/2
	return Inaccuracy


func BulletSpread(creature): #randomizes the direction of the bullets
	var bulletSpread = MaxBulletSpread(creature)
	return randf_range(-bulletSpread,bulletSpread)


func meleeAnim(creature): #makes the node rotate to give the impression it's swinging a weapon
	var rotation = creature.CreatureAppearance.AnimNode.rotation
	var itime = Time.get_ticks_msec()
	var delta = 0
	var max = 100
	while delta < max and creature.Target!=null:
		delta = ((Time.get_ticks_msec()-itime)/2)
		creature.CreatureAppearance.AnimNode.rotation = rotation + sin((delta%max)*(PI/max))
		print(rad_to_deg(sin(Time.get_ticks_msec()-itime)))
		await sleep(0.016)
	if creature.Target!=null:
		creature.CreatureAppearance.AnimNode.rotation = rotation


func ShootProjectile(creature): #function that triggers each time a creature tries to shoot, and determines various outcomes
	var gun = creature.Gun
	var MeleeMaxRange = 100
	if gun.CanFire:
		if not gun.IsReloading:
			if gun.BulletsRemaining > 0:
				if gun.Range < MeleeMaxRange:
					meleeAnim(creature)
					reloadGun(creature)
				gun.CanFire = false
				var actual_rotation = creature.Target.global_rotation_degrees+creature.RotationOffset
				var rotatedOrigin = creature.Target.get_global_position() +(creature.ProjectileOffset.rotated(deg_to_rad(actual_rotation)))
				PlaySound(creature.Gun.GunNode,creature.Gun.gunAppearance.ShootSFX)
				for i in range(gun.BulletAmount):
					var randomspread = BulletSpread(creature)
					shootprojectile.emit(rotatedOrigin,actual_rotation+randomspread,gun.Damage,gun.Speed,creature.Team,gun.Range)
				gun.AdditiveRecoil += gun.BulletRecoil
				gun.BulletsRemaining-= 1
				if gun.Range < MeleeMaxRange:
					reloadGun(creature)
				var cockwait = 0
				if creature.Gun.SingleShotReload:
					cockwait = 0.4
					await sleep(cockwait)
					PlaySound(creature.Gun.GunNode,creature.Gun.gunAppearance.CockSFX)
				await sleep(gun.BulletWait-cockwait)
				gun.CanFire = true
			else:
				reloadGun(creature)
		else:
			gun.InterruptReload = true


func sleep(t): #makes function wait
	await get_tree().create_timer(t).timeout


func PlaySound(node,sound): #creates a child audio player and makes it play the determined sound, after that it dies.
	if sound != null and node != null:
		var audio_player = AudioStreamPlayer2D.new()
		audio_player.stream = sound
		node.add_child(audio_player)
		audio_player.play(0)
		audio_player.connect("finished",audio_player.queue_free)
		await sleep(10)
	else:
		print("sound: " + str(sound) + " is null")
		

func RotatedOrigin(creature): #function that determines the rotation to use in calculations, as the visible sprite may not be accurate
	var actual_rotation = creature.Target.global_rotation_degrees+creature.RotationOffset
	var rotatedOrigin = creature.Target.get_global_position() +(creature.ProjectileOffset.rotated(deg_to_rad(actual_rotation)))
	return rotatedOrigin


func inRange(creature, point2): #checks if the creature's gun can reach the determined point, uses the rotated origin for more accurate calculations
	var rotatedOrigin = RotatedOrigin(creature)
	if (rotatedOrigin).distance_to(point2)>creature.Gun.Range:
		return false
	else:
		return true


func ChangeAnimation(creature,NewAnimation): #sets a new animation for the animated sprite
	if creature.CreatureAppearance != null and creature.Target!=null:
		creature.CreatureAppearance.AnimNode.set_animation(NewAnimation)
	else:
		print("CreatureAppearance is Null")


func reloadGun(creature): #reloads the gun, if it can, and makes visible and acoustic changes
	var gun = creature.Gun
	if not gun.IsReloading and gun.BulletsRemaining<gun.Magazine:
		gun.IsReloading = true
		ChangeAnimation(creature,"Reload")
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
		ChangeAnimation(creature,"Idle")
		gun.InterruptReload = false


func SpawnEnemy(origin,creature,script,scriptToExec = null): #sends the message to motherenemy to spawn a creature
	spawnEnemy.emit(origin,creature,script,scriptToExec)

