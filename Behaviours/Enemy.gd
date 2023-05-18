extends RigidBody2D

#variabili da dare allo script
var creatureObject


#queste variabili se le setta da solo
var Enemies
var Victim
var ActionsArr
var ActionKeys
var MVMForce
var Navigator
var path = Array()
var MoveDirections = Vector2()
var damageTaken = false
var LastFrameHP
var reactionTime = 0.4

func _ready():
	set_lock_rotation_enabled(false)
	
	Navigator = get_node("PathMaker")
	ActionKeys = {
		"forward":[Key(10),Key(11)],
		"backward":[Key(20),Key(21)],
		"left":[Key(30),Key(31)],
		"right":[Key(40),Key(41)],
		"shoot":[Key(50),Key(51)],
		"reload":[Key(60)],
		"NextGun":[Key(70,isInActions,true)],
		"CheckAndExecuteKey": func (KeyArr, func_to_apply,arguments = null):
			for i in KeyArr:
					if i.FunctionCheck.call(i.Value):
						if i.UpNDown:
							if i.WasDown == false:
								if arguments != null:
									func_to_apply.callv(arguments)
								else:
									func_to_apply.call()
								i.WasDown = true
						else:
							func_to_apply.call()
						break
						
					else:
						if i.UpNDown:
							i.WasDown = false
	}
	
	BaseClasses.Morph(self,get_node("EnemyAppearance"),creatureObject)
	BaseClasses.EquipGun(creatureObject,creatureObject.Gun,self,get_node("EnemyAppearance/Gun"))
	MVMForce = creatureObject.MovementForce
	Enemies = BaseClasses.get_nodes_with_groups(BaseItems.ActiveTeams,[creatureObject.Team])
	BaseClasses.UpdateEveryX(1,self,func (): Enemies = BaseClasses.get_nodes_with_groups(BaseItems.ActiveTeams,[creatureObject.Team]))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	damageTaken = false
	if LastFrameHP != creatureObject.Health:
		damageTaken = true
	LastFrameHP = creatureObject.Health
	BaseClasses.Stepping(creatureObject)
	if creatureObject.Health <= 0:
		queue_free()
	
	if Victim != null and self !=null:
		ActionsArr = []
		
		if creatureObject.State == BaseClasses.CHASING: 
			chasephase(delta)

		elif creatureObject.State == BaseClasses.SLEEPING:
			sleepPhase(delta)
		elif creatureObject.State == BaseClasses.ATTACKING:
			attackphase(delta)
		Actions(delta)
	else:
		Victim = get_closest_node(Enemies)
	BaseClasses.DissipateRecoil(delta,creatureObject.Gun)

func attackphase(delta):
	if BaseClasses.isObjectVisible(self,Victim) and BaseClasses.inRange(creatureObject,Victim.global_position):
		PointToPoint(Victim.global_position,delta)
		if creatureObject.Gun.AmmoType != null and creatureObject.Inventory[creatureObject.Gun.AmmoType][0] < 1:
			ActionsArr.append(70)
		else:
			ActionsArr.append(50)
	else:
		Victim = GetNewVictim()
		creatureObject.State = BaseClasses.CHASING
		

func GetNewVictim():
	for i in Enemies:
		if i !=null:
			if BaseClasses.isObjectVisible(self,i):
				return i
	return Victim

func chasephase(delta):
	if BaseClasses.isObjectVisible(self,Victim):
		var currentpath = Navigator.get_current_navigation_path()
		var lenght = len(currentpath)
		if len(currentpath) <= 1:
			MoveDirections = CreatePath()
		else:
			var optimalPoint = currentpath[lenght-2]
			if BaseClasses.inRange(creatureObject,Victim.global_position):
				if global_position.distance_to(optimalPoint) > 5:
					MoveDirections = ((optimalPoint-global_position).floor() ).normalized()
					if creatureObject.Gun.IsMelee:
						attackphase(delta)
					BaseClasses.DoAfterX(self,reactionTime, func (): creatureObject.State = BaseClasses.ATTACKING)
					MoveDirections = Vector2()
			else:
				MoveDirections = CreatePath()
				PointToPoint(MoveDirections+global_position ,delta)
	else:
		if damageTaken:
			Victim = GetNewVictim()
			
		PointToPoint(MoveDirections+global_position ,delta)
		MoveDirections = CreatePath()
			
	apply_force(MoveDirections*delta*60*MVMForce[0])

func sleepPhase(delta):
	var space_state = get_world_2d().direct_space_state
	for i in Enemies:
		if i!= null:
			var query = PhysicsRayQueryParameters2D.create(global_position,i.global_position)
			var result = space_state.intersect_ray(query)
			if result:
				if result.collider == i:
					
					BaseClasses.DoAfterX(self,reactionTime, func (): creatureObject.State = BaseClasses.CHASING)
					Victim = i
					break
	if damageTaken:
		Victim = get_closest_node(Enemies)
		BaseClasses.DoAfterX(self,reactionTime, func (): creatureObject.State = BaseClasses.CHASING)
				

		
func CreatePath():
	Navigator.set_target_position(Victim.global_position)
	path = (-global_position+Navigator.get_next_path_position()).normalized()
	return path

func Key(KEY, functioncheck = isInActions, ArgsArr = null):
	return BaseClasses.SKey(KEY, functioncheck, ArgsArr)



func isInActions(i):
	if i in ActionsArr:
		return true
	return false

func PointToPoint(pos,delta):
	var look_dir = pos - global_position
	look_dir = look_dir.normalized()
	var angle = atan2(look_dir.y, look_dir.x) - rotation + deg_to_rad(90)
	angle = wrap(angle,-PI,PI)
	apply_torque(angle*delta*(creatureObject.TurnForce*(abs(angle/PI)**abs(angle/PI))))

func Actions(delta):
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.forward,func (): MoveDirections.y += -1*MVMForce[0])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.backward,func (): MoveDirections.y += 1*MVMForce[1])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.right,func (): MoveDirections.x += 1*MVMForce[2])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.left,func (): MoveDirections.x += -1*MVMForce[3])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.shoot,ShootTry)
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.NextGun,BaseClasses.ChangeGun,[creatureObject,1])


func ShootTry():
	creatureObject.Gun.OnShoot.callv(creatureObject.Gun.OnShootParams)

func ReloadTry():
	BaseClasses.Reload(creatureObject)
	
func get_closest_node(nodes):
	var min = null
	var a 
	var temp
	for i in nodes:
		if i != null:
			if min == null:
				a = i
				temp = global_position.distance_to(i.global_position)
			else:
				if global_position.distance_to(i.global_position) < temp:
					temp = global_position.distance_to(i.global_position)
					a = i
	return a
	


