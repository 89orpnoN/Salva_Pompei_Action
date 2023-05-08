extends NavigationRegion2D

#@onready var Intendedplayarea = get_node("../CollisionShape2D").shape.get_rect().size
var Intendedplayarea = 1000000
var new_navigation_polygon = NavigationPolygon.new()
var f = new_navigation_polygon


func parse_2d_collisionshapes(root_node: Node2D):

	for node in root_node.get_children():

		if node.get_child_count() > 0:
			parse_2d_collisionshapes(node)

		if node is CollisionPolygon2D:

			var collisionpolygon_transform: Transform2D = node.get_global_transform()
			var collisionpolygon: PackedVector2Array = node.polygon

			var new_collision_outline: PackedVector2Array = collisionpolygon_transform * collisionpolygon

			new_navigation_polygon.add_outline(new_collision_outline)
# Called when the node enters the scene tree for the first time.
func _ready():
	new_navigation_polygon.add_outline(PackedVector2Array([[0,0],[0,Intendedplayarea],[Intendedplayarea,Intendedplayarea],[Intendedplayarea,0]]))
	new_navigation_polygon.make_polygons_from_outlines()
	#parse_2d_collisionshapes(self)

	#new_navigation_polygon.make_polygons_from_outlines()
	#set_navigation_polygon(new_navigation_polygon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
