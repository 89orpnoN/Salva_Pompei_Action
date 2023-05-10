extends RigidBody2D

var MoveDirections
var MVMForce
var mouse_pos
var ActionKeys
var TurnForce
var shootbreak
var wait_shootbreak
var creatureObject
var Gun
var keyidentifier 
var GunAppearance
var GunNode
# Called when the node enters the scene tree for the first time.

func Key(KEY, functioncheck = Input.is_key_pressed):
	var key = {
		"Value":KEY,
		"FunctionCheck":functioncheck,
	}
	return key

func _ready():

	set_position(Vector2(0,0))
	set_lock_rotation_enabled(false)
	
	
	ActionKeys = {
		"forward":[Key(KEY_W),Key(KEY_UP)],
		"backward":[Key(KEY_S),Key(KEY_DOWN)],
		"left":[Key(KEY_A),Key(KEY_LEFT)],
		"right":[Key(KEY_D),Key(KEY_RIGHT)],
		"shoot":[Key(MOUSE_BUTTON_LEFT,Input.is_mouse_button_pressed),Key(KEY_ALT)],
		"CheckAndExecuteKey": func (KeyArr, func_to_apply):
			for i in KeyArr:
				if i.FunctionCheck.call(i.Value):
					func_to_apply.call()
					break
	}
	MVMForce = [250000,250000,250000,250000]
	TurnForce = 100000
	GunAppearance = BaseClasses.GunAppearance(load("res://Sprites/Guns/ak47.bmp"),Vector2(1,-21.3333),Vector2(1,1),)
	GunNode = get_node("PlayerAppearance/Gun")
	BaseClasses.setGunAppearance(GunNode,GunAppearance)
	Gun = BaseClasses.Gun(GunNode,0.08,12,10000,10000,10,0.15,30,false,1,1)
	creatureObject = BaseClasses.Creature(self,100,MVMForce,100,TurnForce,-90,Gun,Vector2(100,0),"Player")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if creatureObject.Health <= 0:
		queue_free()
	Actions(delta)
	
func Actions(delta):
	MoveDirections = Vector2(0,0)
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.forward,func (): MoveDirections.y += -1*MVMForce[0])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.backward,func (): MoveDirections.y += 1*MVMForce[1])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.right,func (): MoveDirections.x += 1*MVMForce[2])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.left,func (): MoveDirections.x += -1*MVMForce[3])
	apply_force(MoveDirections*delta*60)
	PointToPoint( get_global_mouse_position(),delta)
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.shoot,ShootTry)
	Gun.BulletDelta += delta
	
func ShootTry():
	BaseClasses.ShootProjectile(creatureObject,Gun)

func PointToPoint(pos,delta):
	var look_dir = pos - global_position
	look_dir = look_dir.normalized()
	var angle = atan2(look_dir.y, look_dir.x) - rotation + deg_to_rad(90)
	angle = wrap(angle,-PI,PI)
	apply_torque(angle*delta*(TurnForce*(abs(angle/PI)**abs(angle/PI))))

	
