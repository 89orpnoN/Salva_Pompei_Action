extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_position(Vector2(0,0))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		translate(Vector2(0*delta,0.1*delta))
		
	if Input.is_key_pressed(KEY_D):
		rotate(0.1*delta)
