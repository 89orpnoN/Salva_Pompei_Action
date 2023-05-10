extends RigidBody2D

var scene
 
# Called when the node enters the scene tree for the first time.
func _ready():
	
	BaseClasses.connect("shootprojectile", OnBulletFired)

	scene = load("res://MainGame.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func OnBulletFired(origin,angle,DMG,Speed,group,range):
	var clone_node = duplicate(0)
	clone_node.set_script(load("res://Behaviours/ChildBullet.gd"))
	clone_node.speed = Vector2(Speed,0).rotated(deg_to_rad(angle))
	clone_node.damage = DMG
	clone_node.range = range
	clone_node.team = group
	clone_node.originPosition = origin
	get_parent().add_child(clone_node)
	clone_node.set_global_position(origin)
	clone_node.set_global_rotation_degrees(angle)
	clone_node.add_to_group(group)
	#clone_node.Team






