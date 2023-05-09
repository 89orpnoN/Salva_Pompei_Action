extends RigidBody2D

var MoveDirections = Vector2()
var creatureObject
var Gun 
var ActionKeys
var ActionsArr
var seeker
var MVMForce
var path = Array()
var Navigator
var state  = BaseClasses.SLEEPING
# Called when the node enters the scene tree for the first time.
func _ready():
	seeker = get_closest_node(get_tree().get_nodes_in_group("Players"))
	set_lock_rotation_enabled(false)
	Navigator = get_node("PathMaker")
	MoveDirections = CreatePath()
	ActionKeys = {
		"forward":[Key(10),Key(11)],
		"backward":[Key(20),Key(21)],
		"left":[Key(30),Key(31)],
		"right":[Key(40),Key(41)],
		"shoot":[Key(50),Key(51)],
		"CheckAndExecuteKey": func (KeyArr, func_to_apply):
			for i in KeyArr:
				if i.FunctionCheck.call(i.Value):
					func_to_apply.call()
					break
	}

	Gun = BaseClasses.Gun(0.7,0,10000,10000,30,0.05,7)
	creatureObject = BaseClasses.Creature(self,100,[250000,250000,250000,250000],100,100000,-90,Gun,Vector2(100,0),"Enemies")
	MVMForce = creatureObject.MovementForce

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ActionsArr = []
	if creatureObject.Health <= 0:
		queue_free()

	if state == BaseClasses.CHASING: 
		chasephase(delta)

	elif state == BaseClasses.SLEEPING:
		sleepPhase(delta)
	elif state == BaseClasses.ATTACKING:
		attackphase(delta)
	Actions(delta)

func attackphase(delta):
	if BaseClasses.isObjectVisible(self,seeker):
		PointToPoint(seeker.global_position,delta)
		ActionsArr.append(50)
	else:
		state = BaseClasses.CHASING

func chasephase(delta):
	if BaseClasses.isObjectVisible(self,seeker):
		var currentpath = Navigator.get_current_navigation_path()
		
		if len(currentpath) < 2:
			MoveDirections = Vector2()
		else:
			
			if global_position.distance_to(currentpath[len(currentpath)-2]) > 5:
				MoveDirections = ((currentpath[len(currentpath)-2]-global_position).floor() ).normalized()
				state = BaseClasses.ATTACKING
				MoveDirections = Vector2()
				
	else:
		MoveDirections = CreatePath()
			
	apply_force(MoveDirections*delta*60*MVMForce[0])

func sleepPhase(delta):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position,seeker.global_position)
	var result = space_state.intersect_ray(query)
	if result:
		if result.collider == seeker:
			state = BaseClasses.CHASING
			
func _physics_process(delta):
	pass
		
func CreatePath():
	Navigator.set_target_position(seeker.global_position)
	path = (-global_position+Navigator.get_next_path_position()).normalized()
	return path

func Key(KEY, functioncheck = isInActions):
	return BaseClasses.SKey(KEY, functioncheck)

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
	PointToPoint(seeker.global_position ,delta)
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.shoot,ShootTry)
	Gun.BulletDelta += delta

func ShootTry():
	BaseClasses.ShootProjectile(creatureObject,Gun)

func get_closest_node(nodes):
	var min = null
	var a 
	var temp
	for i in nodes:
		if min == null:
			a = i
			temp = global_position.distance_to(i.global_position)
		else:
			if global_position.distance_to(i.global_position) < temp:
				temp = global_position.distance_to(i.global_position)
				a = i
	return a
	


