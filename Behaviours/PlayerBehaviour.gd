extends RigidBody2D


var MoveDirections
var ActionKeys
var creatureObject
var Guns
var Inventory
var damageTaken = false 
var LastFrameHP
var LastFootstep
var root 
# Called when the node enters the scene tree for the first time.

func Key(KEY, functioncheck = Input.is_key_pressed, UpNDown=false):
	var key = {
		"WasDown":false,
		"Value":KEY,
		"FunctionCheck":functioncheck,
		"UpNDown":UpNDown,
	}
	return key

func _ready():
	root = get_node("/root/World/")
	Inventory = [BaseItems.getWeapon("Punch"),BaseItems.getWeapon("Knife"),BaseItems.getWeapon("Magnum"),BaseItems.getWeapon("Adrenaline")]
	LastFootstep = [global_position,false]
	ActionKeys = {
		"forward":[Key(KEY_W)],
		"backward":[Key(KEY_S)],
		"left":[Key(KEY_A)],
		"right":[Key(KEY_D)],
		"walk":[Key(KEY_SHIFT)],
		"drop":[Key(KEY_G,Input.is_key_pressed,true)],
		"reload":[Key(KEY_R)],
		"shoot":[Key(MOUSE_BUTTON_LEFT,Input.is_mouse_button_pressed),Key(KEY_ALT)],
		"NextGun":[Key(KEY_2,Input.is_key_pressed,true)],
		"PreviousGun":[Key(KEY_1,Input.is_key_pressed,true)],
		"OpenBuyMenu":[Key(KEY_B,Input.is_key_pressed,true)],
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
							i.WasDown = false,
				
	}
	var Creature = BaseItems.GetCreature("Soldier")
	Creature.Health = BaseItems.GetCreatureHealth("PlayerSoldier")
	BaseClasses.Morph(self,get_node("PlayerAppearance"),Creature,"Police")
	var a = creatureObject.CreatureAppearance
	BaseClasses.AddThingsToInventory(creatureObject,Inventory)
	BaseClasses.EquipGun(creatureObject,BaseClasses.arrayAt(BaseClasses.GetAllThings(creatureObject),0),self,get_node("PlayerAppearance/Gun"))
	LastFrameHP = creatureObject.Health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

		
	if creatureObject.Health.Health <= 0:
		Die()

	if creatureObject.IsAlive:
		BaseClasses.Stepping(creatureObject)
		Actions(delta)
		BaseClasses.DissipateRecoil(delta,creatureObject.Gun)


func Die(killer = null):
	
	if creatureObject.IsAlive:
		bloodPuddle()
		var camera = get_node("MainCamera")
		remove_child(camera)
		get_node("../DeathMenu").global_position = global_position
		get_node("..").add_child(camera)
		camera.global_position = global_position
		creatureObject.IsAlive = !creatureObject.IsAlive
		queue_free()

func bloodPuddle():
	var blood = Sprite2D.new()
	blood.global_position = global_position
	blood.scale = Vector2(0.1,0.1)
	blood.texture = load("res://Sprites/DeathReactions/Blood splatter.png")
	get_node("/root/World").add_child(blood)

func Actions(delta):
	MoveDirections = Vector2(0,0)
	var MVMForce = creatureObject.MovementForce
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.forward,func (): MoveDirections.y += -1*MVMForce[0])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.backward,func (): MoveDirections.y += 1*MVMForce[1])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.right,func (): MoveDirections.x += 1*MVMForce[2])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.left,func (): MoveDirections.x += -1*MVMForce[3])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.walk,func (): MoveDirections /=2)
	apply_force(MoveDirections*delta*60)
	PointToPoint( get_global_mouse_position(),delta)
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.shoot,ShootTry)
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.reload,ReloadTry)
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.PreviousGun,BaseClasses.ChangeGun,[creatureObject,-1])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.NextGun,BaseClasses.ChangeGun,[creatureObject,1])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.drop,BaseClasses.DropGun,[creatureObject,creatureObject.Gun])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.OpenBuyMenu,BaseClasses.SwitchOpenBuyMenu,[root,self])



func ShootTry():
	
	creatureObject.Gun.OnShoot.callv(creatureObject.Gun.OnShootParams)

func ReloadTry():
	creatureObject.Gun.OnReload.callv(creatureObject.Gun.OnReloadParams)

func PointToPoint(pos,delta):
	var look_dir = pos - global_position
	look_dir = look_dir.normalized()
	var angle = atan2(look_dir.y, look_dir.x) - rotation + deg_to_rad(90)
	angle = wrap(angle,-PI,PI)
	apply_torque(angle*delta*(creatureObject.TurnForce*(abs(angle/PI)**abs(angle/PI))))

	
