extends Node2D

signal shootprojectile(origin,angle,DMG,Speed,group,FatherCreature,range)

signal spawnEnemy(origin,creature,script,function)

enum {SLEEPING,CHASING,ATTACKING,SEARCHING,DEAD} #states of behaviour for AI creatures.

var GarbageCoords = Vector2(-100000000000,-100000000000)
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

func BuyArea(sprite = null,Baseprice = 1):
	var buyarea = {
		"Sprite":sprite,
		"Enabled":true, 
		"Baseprice":Baseprice,
	}
	return buyarea.duplicate(true)

func Gun(gunnode = null,Name = "Punch",bulletwait = 1.0,damage = 1.0,speed = 10000.0 ,maxdistance = 10000.0,Recoil = 1.0,basespread = 5.0,spreadmultiplier = 0.1, Magazine=30.0,AmmoType ="RifleAmmo" ,ReloadWait = 1.0,SingleShotReload = false,bulletamount = 1.0, gunappearance = GunAppearance(),IsMelee=false,Category="Rifle", OnShoot = ShootProjectile, OnShootParams = [],OnReload = reloadGun,OnReloadParams = []):
	var gun = {
	"GunNode":gunnode,
	"CanFire":true,
	"InHands":false,
	"AdditiveRecoil":0.0,
	"InterruptReload":false,
	"BulletsRemaining":Magazine,
	"IsReloading":false,
	"Name":Name,
	"BulletWait":bulletwait,
	"Damage": damage,
	"Speed":speed,
	"Range":maxdistance,
	"BulletRecoil":Recoil,
	"BaseSpread":basespread,  #expressed in degrees
	"SpreadMultiplier":spreadmultiplier,
	"Magazine":Magazine,
	"AmmoType":AmmoType,
	"ReloadWait":ReloadWait,
	"SingleShotReload":SingleShotReload,
	"BulletAmount":bulletamount,
	"gunAppearance":gunappearance,
	"IsMelee":IsMelee,
	"Category":Category,
	"OnShoot":OnShoot,
	"OnShootParams":OnShootParams,
	"OnReload":OnReload,
	"OnReloadParams":OnReloadParams,
	}
	return gun.duplicate()


func EquipGun(creature,gun,target,gunnode): #for first time equip only
	creature.Gun = gun
	gun.InHands = true
	CreatureLink(creature,target,gunnode)
	PlaySound(creature.Target,creature.Gun.gunAppearance.DrawSFX)

func GetAllThings(creature):
	var Items = []
	Items.append_array(creature.Inventory.Rifles[0])
	Items.append_array(creature.Inventory.Pistols[0])
	Items.append_array(creature.Inventory.Melee[0])
	Items.append_array(creature.Inventory.Items[0])
	return Items

func merge_dict(dict_1, dict_2):
	var new_dict = dict_1.duplicate(true)
	for key in dict_2:
		new_dict[key] = dict_2[key]
	return new_dict

func ChangeGun(creature,Idx): #can be called if the gun and the creature have been paired with the instance
	var Items = GetAllThings(creature)
	var Newgun = arrayAt(Items,(Items.find(creature.Gun))+Idx)
	Newgun.CanFire = false
	creature.Gun.InHands = false
	ChangeAnimation(creature,"Reload")
	DestroyChildrenAudioPlayers(creature.Gun.GunNode)
	var GunNode = creature.Gun.GunNode
	creature.Gun = Newgun
	Newgun.InHands = true
	CreatureLink(creature,creature.Target,GunNode)
	PlaySound(creature.Target,creature.Gun.gunAppearance.DrawSFX)
	var TrueReloadWait = Newgun.ReloadWait
	if Newgun.SingleShotReload:
		TrueReloadWait = Newgun.ReloadWait/Newgun.Magazine
	await sleep(sqrt(TrueReloadWait)/3.0+0.4 )
	Newgun.CanFire = true
	ChangeAnimation(creature,"Idle")

func Inventory(RifleLimit = 1, PistolLimit= 1,MeleeLimit=2 ,ItemLimit = 2,BigAmmoLimit = 240,SmallAmmoLimit = 120,BuckAmmoLimit = 70,Rifles = [],Pistols = [],Melees=[],Items=[],MiscItems=[],Armor = null , BigAmmo = 40, SmallAmmo = 36, BuckshotAmmo = 15):
	var inventory = {
		"Rifles":[Rifles,RifleLimit],
		"Pistols":[Pistols,PistolLimit],
		"Melee":[Melees,MeleeLimit],
		"Items":[Items,ItemLimit],
		"Armor":Armor,
		"RifleAmmo":[BigAmmo,BigAmmoLimit],
		"PistolAmmo":[SmallAmmo,SmallAmmoLimit],
		"BuckshotAmmo":[BuckshotAmmo,BuckAmmoLimit],
		"MiscItems":[MiscItems,-1],
		"Equipped":[],
	}
	return inventory.duplicate(true)

func SetInventory(creature,Inventory):
	creature.Inventory = Inventory
	
func AddThingsToInventory(Creature,ItemArr):
	for i in ItemArr:
		if not AddThingToInventory(Creature,i):
			return false
	return false
	
func AddThingToInventory(Creature,item):
	var Inv = Creature.Inventory
	if item.Category == null:
		print("item does not have category")
		return false
	if typeof(Inv[item.Category][0]) == TYPE_INT:
		AddAmmoToInventory(Creature,item.Category,item.Magazine)
	elif len(Inv[item.Category][0])<Inv[item.Category][1]:
		Inv[item.Category][0].append(item)
	else:
		return false
	return true


func AddAmmoToInventory(creature,AmmoType,amount): #to use as an "admin" give, without reprecussions. does not interact properly with ammopacks instances
	var delta = creature.Inventory[AmmoType][1]-creature.Inventory[AmmoType][0]
	if delta < amount:
		creature.Inventory[AmmoType][0] += delta
	else:
		creature.Inventory[AmmoType][0] += amount

func AddAmmoPackToInventory(creature,AmmoPack): #literally the above, but is suited for use with ammopacks as it scales the ammo contents.
	var delta = creature.Inventory[AmmoPack.Type][1]-creature.Inventory[AmmoPack.Type][0]
	if delta < AmmoPack.Amount:
		creature.Inventory[AmmoPack.Type][0] += delta
		AmmoPack.Amount-=delta
	else:
		creature.Inventory[AmmoPack.Type][0] += AmmoPack.Amount
		AmmoPack.Amount = 0
		return true

func SpawnGroundObj(Scene,Coords,GroundObj,Behaviour = GroundObj.Behaviour):
		var sprt = Sprite2D.new()
		var shape = CollisionShape2D.new()
		var circleshape =  CircleShape2D.new()
		var area = Area2D.new()
		sprt.z_index = 3
		circleshape.radius = 10
		shape.shape = circleshape
		sprt.texture = GroundObj.GroundSprite
		sprt.scale = GroundObj.Scale
		if Behaviour == null:
			print("giving behaviours to ground objects is necessary to mek them interact with instances")
		else:
			area.set_script(Behaviour)
			area.GroundObj = GroundObj
			area.area = shape
		area.global_position = Coords
		area.global_rotation = randf_range(-PI,PI)
		area.add_child(shape)
		area.add_child(sprt)
		Scene.add_child.call_deferred(area)

func DeleteGun(creature,Deletegun):
	var gun = creature.Gun
	if Deletegun == gun:
		ChangeGun(creature,1)
	var category = creature.Inventory[Deletegun.Category]
	category[0].erase(Deletegun)

func DropGun(creature,Dropgun):
	var gun = creature.Gun
	var groundobj = BaseItems.GetGroundObj(Dropgun.Name)
	if typeof(groundobj)!=TYPE_BOOL:
		var category = creature.Inventory[Dropgun.Category]
		category[0].erase(Dropgun)
		groundobj.Item = Dropgun
		SpawnGroundObj(creature.Target.get_node("/root"),creature.Target.global_position,groundobj,groundobj.Behaviour)
	else:
		print("Item could not be dropped")
	if Dropgun == gun:
		ChangeGun(creature,1)
	
	
func DropHeldGun(creature):
	var Dropgun = creature.Gun
	ChangeGun(creature,1)
	var category = creature.Inventory[Dropgun.Category]
	category[0].erase(Dropgun)
	var groundobj = BaseItems.GetGroundObj(Dropgun.Name)
	groundobj.Item = Dropgun
	SpawnGroundObj(creature.Target.get_node("/root"),creature.Target.global_position,groundobj,groundobj.Behaviour)

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

func GroundObject(Item,groundSprite,pickupsfx = null, Scale = Vector2(3,3),Behaviour = load("res://Behaviours/GunGroundObject.gd")):
	var groundobject = {
		"Item":Item,
		"GroundSprite":groundSprite,
		"PickupSFX":pickupsfx,
		"Scale":Scale,
		"Behaviour":Behaviour,
	}
	return groundobject


func Health(MaxHealth = 100.0, MaxTempHealth = 100.0, TempHealthDegen = 1.0, HealthRegen = 0.0,HealthRegenCap = 30.0,HealthRegenWait = 3.0,Health = MaxHealth,TempHealth = 0.0):
	var health = {
		"Health":Health,
		"HealthRegenTime":HealthRegenWait,
		"TempHealth":TempHealth,
		"MaxHealth":MaxHealth,
		"HealthRegen":HealthRegen,
		"HealthRegenCap":HealthRegenCap,
		"HealthRegenWait":float(HealthRegenWait),
		"MaxTempHealth":MaxTempHealth,
		"TempHealthDegen":TempHealthDegen,
		"HealthRegenScript": func (Health,updateTime):

			if Health.HealthRegenTime < Health.HealthRegenWait:
				Health.HealthRegenTime += updateTime
			else:
				if Health.Health < Health.HealthRegenCap:
					Health.Health += Health.HealthRegen*updateTime
			return,
		"TempHealthDegenScript": func (Health,updateTime):
			if Health.TempHealth > 0:
				Health.TempHealth -= Health.TempHealthDegen*updateTime
	}
	return health.duplicate(true)
	
func ScaleHealth(Healthobj, damage):
	if damage < 0: 
		print("damage less than zero, unpredictable behaviour")
	if damage == 0:
		return true
	Healthobj.HealthRegenTime = 0.0
	if Healthobj.TempHealth > 0:
		if Healthobj.TempHealth > damage:
			Healthobj.TempHealth -= damage
			return true
		else:
			damage -= Healthobj.TempHealth
			Healthobj.TempHealth = 0
	if Healthobj.Health > 0:
		if Healthobj.Health > damage:
			Healthobj.Health -= damage
			return true
		else:
			Healthobj.Health = 0
	return false



func Creature(target,health = null,inventory = Inventory(),movementforce = [250000.0,250000.0,250000.0,250000.0],mass = 100.0,turnforce =100000.0,rotationoffset=0.0,gun = null,projectileoffset = Vector2(50,0),team = "None",CreatureAppearance = null,Money = 0):
	var creature = {
	"State":0,
	"Target":target,
	"IsAlive":true,
	"Health":health,
	"Inventory":inventory,
	"MovementForce":movementforce,
	"Mass":mass,
	"TurnForce":turnforce,
	"RotationOffset":rotationoffset,
	"Gun": gun,
	"ProjectileOffset":projectileoffset,
	"Team":team,
	"CreatureAppearance":CreatureAppearance,
	"Money":Money,
	}
	return creature.duplicate(true)


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
	UpdateEveryX(0.016,Target,Creature.Health.HealthRegenScript,[Creature.Health,0.016])
	UpdateEveryX(0.016,Target,Creature.Health.TempHealthDegenScript,[Creature.Health,0.016])


func CreatureLink(Creature,target,gunnode,onshootparams = [Creature],onreloadparams = [Creature]): #to use with the gun alredy paired to the Creature, can be used to set up the target and gun node
	Creature.Target = target
	Creature.Gun.GunNode = gunnode
	Creature.Gun.OnShootParams  = onshootparams
	Creature.Gun.OnReloadParams  = onreloadparams
	setGunAppearance(gunnode,Creature.Gun.gunAppearance)


func setGunAppearance(GunNode, Gunappearance): #makes the gun visibly change
	GunNode.texture = Gunappearance.Sprite
	GunNode.position = Gunappearance.Offset
	GunNode.scale = Gunappearance.Scale

func AmmoPack(Type,Amount=0):
	var ammopack = {
		"Type":Type,
		"Amount":Amount,
	}
	return ammopack.duplicate(true)

func AmmopackInit(AmmoPack,amount):
	AmmoPack.Amount = amount
	return AmmoPack

func HealthPack(Amount,RegenTime = 0.0, IsStim = false):
	var healthpack = {
		"IsStim":IsStim,
		"Amount":Amount,
		"RegenTime":RegenTime,
	}
	return healthpack.duplicate(true)

func HealthPackHeal(creatureobj,Healthpack):
	var Healthobj = creatureobj.Health
	var maxprefix = "Max"
	var category
	if Healthpack.IsStim:
		category = "TempHealth"
	else:
		category = "Health"
	if Healthpack.RegenTime == 0:
		var actualHealing = Healthobj[maxprefix+category]-Healthobj[category]
		if actualHealing <= 0:
			return false
		if actualHealing > Healthpack.Amount:
			Healthobj[category] += Healthpack.Amount
		else:
			Healthobj[category] = Healthobj[maxprefix+category]
	else:
		if Healthobj[maxprefix+category] == 0:
			return false
		var updatetime = 0.032
		var a = func (Healthobj,category,maxcategory,addhealth):
			if Healthobj[category]+addhealth <= Healthobj[maxcategory]:
				Healthobj[category]+=addhealth
			else:
				Healthobj[category] = Healthobj[maxcategory]
		UpdateEveryXthenStop(updatetime,Healthpack.RegenTime,creatureobj.Target,a,[Healthobj,category,maxprefix + category,Healthpack.Amount*(updatetime/Healthpack.RegenTime)])
	return true
func isObjectVisible(obj,obj2): #checks if there are nodes between first node and second node
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(obj.global_position,obj2.global_position)
	var result = space_state.intersect_ray(query)
	if len(result)>0 and result.collider == obj2:
		return true
	return false


func SKey(KEY, functioncheck, UpNDown=false): #key value paired with the function used to check if it is being pressed
	var key = {
		"WasDown":false,
		"Value":KEY,
		"FunctionCheck":functioncheck,
		"UpNDown":UpNDown,
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
	var a
	while instance !=null:
		
		if arguments != null:
			a = function.callv(arguments)
			
		else:
			a = function.call()
		if typeof(a) == TYPE_BOOL and !a:
			return
		await sleep(secs)
		
func UpdateEveryXthenStop(secs,stopSecs,instance,function,arguments = null): #function that cycles forever if the instance exists and calls the function at regular intervals
	var timepassed = 0.0
	while instance !=null:
		
		if arguments != null:
			function.callv(arguments)
		else:
			function.call()
		await sleep(secs)
		timepassed += secs
		if timepassed > stopSecs:
			return

func DoAfterX(instance,time,function,arguments = null):
	await BaseClasses.sleep(time)
	if instance != null:
		if arguments != null:
			function.callv(arguments)
		else:
			function.call()

func arrayAt(arr,idx): #gets the item in the array even if it's out of range
	if idx < 0:
		idx = idx%(len(arr))
	else:
		idx = idx%(len(arr))
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
	var rotation = 0
	var itime = Time.get_ticks_msec()
	var delta = 0
	var max = 100
	while delta < max and creature.Target!=null:
		delta = ((Time.get_ticks_msec()-itime)/2)
		creature.CreatureAppearance.AnimNode.rotation = rotation + sin((delta%max)*(PI/max))
		await sleep(0.016)
	if creature.Target!=null:
		creature.CreatureAppearance.AnimNode.rotation = rotation


func ShootProjectile(creature): #function that triggers each time a creature tries to shoot, and determines various outcomes
	var gun = creature.Gun
	if gun.CanFire:
		if not gun.IsReloading:
			if gun.BulletsRemaining > 0:
				if gun.IsMelee:
					meleeAnim(creature)
					reloadGun(creature)
				gun.CanFire = false
				var actual_rotation = creature.Target.global_rotation_degrees+creature.RotationOffset
				var rotatedOrigin = creature.Target.get_global_position() +(creature.ProjectileOffset.rotated(deg_to_rad(actual_rotation)))
				PlaySound(creature.Gun.GunNode,creature.Gun.gunAppearance.ShootSFX)
				for i in range(gun.BulletAmount):
					var randomspread = BulletSpread(creature)
					shootprojectile.emit(rotatedOrigin,actual_rotation+randomspread,gun.Damage,gun.Speed,creature.Team,creature,gun.Range)
				gun.AdditiveRecoil += gun.BulletRecoil
				gun.BulletsRemaining-= 1
				if gun.IsMelee:
					reloadGun(creature)
				var cockwait = 0.0
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
		print("CreatureAppearance is Null, cannot change animation")


func reloadGun(creature): #reloads the gun, if it can, and makes visible and acoustic changes
	var gun = creature.Gun
	if not gun.IsReloading and gun.BulletsRemaining<gun.Magazine and (gun.AmmoType==null or creature.Inventory[gun.AmmoType][0]>0):
		gun.IsReloading = true
		ChangeAnimation(creature,"Reload")
		if gun.SingleShotReload:
			while (not gun.InterruptReload) and (gun.BulletsRemaining<gun.Magazine) and (creature.Inventory[gun.AmmoType][0]>0) and (gun.InHands):
				PlaySound(gun.GunNode,gun.gunAppearance.ReloadSFX)
				await sleep(gun.ReloadWait/gun.Magazine)
				if not gun.InterruptReload or gun.BulletsRemaining==0:
					gun.BulletsRemaining += 1
					if gun.AmmoType != null:
						creature.Inventory[gun.AmmoType][0]-=1
					
		else:
			PlaySound(gun.GunNode,gun.gunAppearance.ReloadSFX)
			await sleep(gun.ReloadWait)
			if gun.InHands:
				if gun.AmmoType != null:
					var deltabul = gun.Magazine - gun.BulletsRemaining
					if deltabul>creature.Inventory[gun.AmmoType][0]:
						gun.BulletsRemaining += creature.Inventory[gun.AmmoType][0]
						creature.Inventory[gun.AmmoType][0] = 0
					else:
						gun.BulletsRemaining = gun.Magazine
						creature.Inventory[gun.AmmoType][0] -= deltabul
				else:
					gun.BulletsRemaining = gun.Magazine
		gun.IsReloading = false
		ChangeAnimation(creature,"Idle")
		gun.InterruptReload = false


func SpawnEnemy(origin,creature,script,scriptToExec = null): #sends the message to motherenemy to spawn a creature
	spawnEnemy.emit(origin,creature,script,scriptToExec)

func DestroyChildrenAudioPlayers(node):
	var child_count = node.get_child_count()
	var i = 0
	while i < child_count:
		var child = node.get_child(i)
		if child is AudioStreamPlayer2D:
			child.queue_free()
			child_count -= 1
		else:
			i += 1

func AddHealth(creature,addhealth,regenTime = 0):
	var updatetime = 0.032
	if regenTime == 0:
		if creature.Health+addhealth > creature.MaxHealth:
			creature.Health =  creature.MaxHealth
		else:
			creature.Health += addhealth
	else:
		var a = func (creature,addHealth):
			if creature.Health + addHealth <= creature.MaxHealth:
				creature.Health += addHealth
	
		UpdateEveryXthenStop(updatetime,regenTime,creature.Target,a,[creature,addhealth*(updatetime/regenTime)])
		
	
func MenaceRating(Creature):
	var Points = 0
	Points +=(Creature.MovementForce[0]/20000)*(100/Creature.Mass)-5
	var HealthPoints = 0
	if Creature.Health != null:
		HealthPoints += Creature.Health.MaxHealth/10
		HealthPoints += Creature.Health.MaxTempHealth/12
		HealthPoints += Creature.Health.HealthRegen/Creature.Health.HealthRegenWait
		HealthPoints += Creature.Health.HealthRegenCap/7
	var GunPoints = 0
	if Creature.Gun != null:
		if Creature.Gun.Range > 800:
			GunPoints += 20
		GunPoints += ((Creature.Gun.Damage*Creature.Gun.BulletAmount)/Creature.Gun.BulletWait)/5
		GunPoints +=  Creature.Gun.SpreadMultiplier*70-Creature.Gun.BaseSpread
	Points += HealthPoints+GunPoints
	return Points
	
func CreateBuyArea(scene,areaobject,size,coords):
		var sprt = Sprite2D.new()
		var shape = CollisionShape2D.new()
		var rectangleshape =  RectangleShape2D.new()
		var area = Area2D.new()
		sprt.z_index = 0
		rectangleshape.size = size
		shape.shape = rectangleshape
		if areaobject.Sprite != null:
			sprt.texture = load(areaobject.Sprite)
			sprt.scale = (size/sprt.texture.get_size())
		area.set_script(load("res://Behaviours/BuyArea.gd"))
		area.AreaObject = areaobject
		area.global_position = coords
		area.add_to_group("BuyArea")
		area.add_child(shape)
		area.add_child(sprt)
		scene.add_child.call_deferred(area)

func ShopGunObject(Name,DisplayName,Price,Sprite,Gun,GroundObject):
	var shopgunobject = {
		"Name":Name,
		"DisplayName":DisplayName,
		"Price":Price,
		"Sprite":Sprite,
		"Gun":Gun,
		"GroundObject":GroundObject,
	}
	return shopgunobject.duplicate(true)


func IsInActiveBuyArea(playerNode):
	var buyareas = get_tree().get_nodes_in_group("BuyArea")
	for i in buyareas:
		if i.tryOpen(playerNode):
			return true
	return false
		
func SwitchOpenBuyMenu(root,playerNode):
	if playerNode.get_node("MainCamera").get_node("ShopMenu") != null:
		CloseBuyMenu(root,playerNode)
	elif root.get_node("ShopMenu")!= null:
		OpenBuyMenu(root,playerNode)

func OpenBuyMenu(root,playerNode):
	if IsInActiveBuyArea(playerNode):
		var playercamera = playerNode.get_node("MainCamera")
		var shopmenu = root.get_node("ShopMenu").duplicate(5)
		shopmenu.Opener = playerNode.creatureObject
		playercamera.add_child(shopmenu)
		shopmenu.global_position = playerNode.global_position
		var a = func(root,playerNode):
			if !IsInActiveBuyArea(playerNode):
				CloseBuyMenu(root,playerNode)
		UpdateEveryX(0.5,shopmenu,a,[root,playerNode])

func CloseBuyMenu(root,playerNode):
	var playercamera = playerNode.get_node("MainCamera")
	var shopmenu = playercamera.get_node("ShopMenu")
	playercamera.remove_child(shopmenu)

func BuyItem(creature,root,Item):
	if creature.Money >= Item.Price:
		creature.Money -= Item.Price
		BaseClasses.SpawnGroundObj(root,creature.Target.global_position,Item.GroundObject)
