extends RigidBody2D


var MoveDirections
var ActionKeys
var creatureObject
var Guns
var Inventory
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
	Inventory = [BaseItems.getWeapon("Punch"),BaseItems.getWeapon("Knife"),BaseItems.getWeapon("Ak-47"),BaseItems.getWeapon("M16"),BaseItems.getWeapon("Deagle"),BaseItems.getWeapon("Magnum"),BaseItems.getWeapon("Glock"),BaseItems.getWeapon("M1911"),BaseItems.getWeapon("Itaca"),BaseItems.getWeapon("Spas")]
	
	ActionKeys = {
		"forward":[Key(KEY_W),Key(KEY_UP)],
		"backward":[Key(KEY_S),Key(KEY_DOWN)],
		"left":[Key(KEY_A),Key(KEY_LEFT)],
		"right":[Key(KEY_D),Key(KEY_RIGHT)],
		"reload":[Key(KEY_R)],
		"shoot":[Key(MOUSE_BUTTON_LEFT,Input.is_mouse_button_pressed),Key(KEY_ALT)],
		"NextGun":[Key(KEY_2,Input.is_key_pressed,true)],
		"PreviousGun":[Key(KEY_1,Input.is_key_pressed,true)],
		"CheckAndExecuteKey": func (KeyArr, func_to_apply):
				for i in KeyArr:
					if i.FunctionCheck.call(i.Value):
						if i.UpNDown:
							if i.WasDown == false:
								func_to_apply.call()
								i.WasDown = true
						else:
							func_to_apply.call()
						break
						
					else:
						if i.UpNDown:
							i.WasDown = false
				
	}
	
	Guns = {
		"Keys":["Punch","Knife","Ak-47","M16","Deagle","Magnum","Glock","M1911","Itaca","Spas"],
		"CurrentIdx":0,
	}
	BaseClasses.Morph(self,get_node("PlayerAppearance"),BaseItems.GetCreature("Goon"),"Players")
	BaseClasses.EquipGun(creatureObject,BaseItems.getWeapon("Glock"),self,get_node("PlayerAppearance/Gun"))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if creatureObject.Health <= 0:
		queue_free()
		print("dead")
	Actions(delta)
	BaseClasses.DissipateRecoil(delta,creatureObject.Gun)

func Actions(delta):
	MoveDirections = Vector2(0,0)
	var MVMForce = creatureObject.MovementForce
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.forward,func (): MoveDirections.y += -1*MVMForce[0])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.backward,func (): MoveDirections.y += 1*MVMForce[1])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.right,func (): MoveDirections.x += 1*MVMForce[2])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.left,func (): MoveDirections.x += -1*MVMForce[3])
	apply_force(MoveDirections*delta*60)
	PointToPoint( get_global_mouse_position(),delta)
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.shoot,ShootTry)
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.reload,ReloadTry)
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.PreviousGun,Prevgun)
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.NextGun,Nextgun)
	
	
func Prevgun(): 
	BaseClasses.ChangeGun(creatureObject,BaseClasses.arrayAt(Inventory,Inventory.find(creatureObject.Gun)-1))

func Nextgun(): 
	BaseClasses.ChangeGun(creatureObject,BaseClasses.arrayAt(Inventory,Inventory.find(creatureObject.Gun)+1))


func ShootTry():
	BaseClasses.ShootProjectile(creatureObject)

func ReloadTry():
	BaseClasses.reloadGun(creatureObject)

func PointToPoint(pos,delta):
	var look_dir = pos - global_position
	look_dir = look_dir.normalized()
	var angle = atan2(look_dir.y, look_dir.x) - rotation + deg_to_rad(90)
	angle = wrap(angle,-PI,PI)
	apply_torque(angle*delta*(creatureObject.TurnForce*(abs(angle/PI)**abs(angle/PI))))

	
