extends CollisionPolygon2D

var radius = 38
var shape = PackedVector2Array()
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(360):
		var rads = deg_to_rad(i)
		shape.append(Vector2(cos(rads)*radius,sin(rads)*radius))
		print(Vector2(cos(rads)*radius,sin(rads)*radius))
	set_polygon(shape)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
