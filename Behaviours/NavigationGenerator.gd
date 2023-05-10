extends NavigationRegion2D

#@onready var Intendedplayarea = get_node("../CollisionShape2D").shape.get_rect().size
var FrictionCanvas
var CollisionShape
var Intendedplayarea 
var new_navigation_polygon = NavigationPolygon.new()
var f = new_navigation_polygon
var GodNode 

func get_all_children(node,arr:=[]):
	var nodes = arr

	for N in node.get_children():
		if N.get_child_count() > 0:
			nodes.append(N)
			nodes.append_array(get_all_children(N))
		else:
			nodes.append(N)
	return nodes
# Called when the node enters the scene tree for the first time.

func get_all_Physics_nodes():
	var arr = get_all_children(GodNode)
	var farr = []
	for i in arr:
		if i is CollisionPolygon2D or i is CollisionShape2D:
			farr.append(i)
	return farr

func _ready():
	GodNode = get_tree().get_nodes_in_group("GodNode")[0]
	var CollisionShapes = get_all_Physics_nodes()
	
	FrictionCanvas = get_parent()
	CollisionShape = get_node("../CollisionShape2D")
	Intendedplayarea = CollisionShape.scale*CollisionShape.shape.size/2
	
	var polygon = NavigationPolygon.new()
	
	var polygon = NavigationPolygon.new()
	var outline = PackedVector2Array([Vector2(-Intendedplayarea.x, -Intendedplayarea.y), Vector2(-Intendedplayarea.x, Intendedplayarea.y), Vector2(Intendedplayarea.x, Intendedplayarea.y), Vector2(Intendedplayarea.x, -Intendedplayarea.y)])
	polygon.add_outline(outline)
	polygon.make_polygons_from_outlines()
	for i in CollisionShapes:
		if i is CollisionShape2D and not i.get_parent() is RigidBody2D and not i.get_parent() == get_parent():
			var global_pos = i.global_position
			var size = i.shape.size/2
			var packedarr = PackedVector2Array([Vector2(global_pos.x-size.x,global_pos.y-size.y),Vector2(global_pos.x+size.x,global_pos.y-size.y),Vector2(global_pos.x+size.x,global_pos.y+size.y),Vector2(global_pos.x-size.x,global_pos.y+size.y)])
			
			polygon.add_outline(packedarr)
			print(i.get_parent())
	navigation_polygon = polygon
	for i in range(polygon.get_outline_count()):
		print(polygon.get_outline(i))
	print("pollo")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
