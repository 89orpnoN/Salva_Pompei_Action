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
	Gun = BaseClasses.Gun(0.7,100,10000,10000,30,0.05,7)
	creatureObject = BaseClasses.Creature(self,100,MVMForce,100,TurnForce,-90,Gun,Vector2(100,0),"Player")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	MovementActions(delta)
	PointToMouse(delta)
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.shoot,ShootTry)
	Gun.BulletDelta += delta
	
func MovementActions(delta):
	MoveDirections = Vector2(0,0)
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.forward,func (): MoveDirections.y += -1*MVMForce[0])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.backward,func (): MoveDirections.y += 1*MVMForce[1])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.right,func (): MoveDirections.x += 1*MVMForce[2])
	ActionKeys.CheckAndExecuteKey.call(ActionKeys.left,func (): MoveDirections.x += -1*MVMForce[3])
	apply_force(MoveDirections*delta*60)
	
func ShootTry():
	BaseClasses.ShootProjectile(creatureObject,Gun)

func PointToMouse(delta):
	mouse_pos = get_global_mouse_position()
	var look_dir = mouse_pos - global_position
	look_dir = look_dir.normalized()
	var angle = atan2(look_dir.y, look_dir.x) - rotation + deg_to_rad(90)
	angle = wrap(angle,-PI,PI)
	apply_torque(angle*delta*(TurnForce*(abs(angle/PI)**abs(angle/PI))))

	
