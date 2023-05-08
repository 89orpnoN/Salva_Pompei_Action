extends RigidBody2D

var creatureObject
var Gun
var keyidentifier 
var ActionKeys

func Key(KEY, functioncheck = Input.is_key_pressed):
	var key = {
		"Value":KEY,
		"FunctionCheck":functioncheck,
	}
	return key

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_position(Vector2(100,100))
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
	Gun = BaseClasses.Gun(0.7,100,10000,10000,30,0.05,7)
	creatureObject = BaseClasses.Creature(self,100,[250000,250000,250000,250000],100,100000,-90,Gun,Vector2(100,0),"Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if creatureObject.Health <= 0:
		queue_free()
