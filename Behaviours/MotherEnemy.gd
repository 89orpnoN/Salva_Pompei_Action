extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	BaseClasses.connect("spawnEnemy", SpawnEnemy)
	
		
	var Gun = BaseItems.getWeapon("Knife")
	var creatureObject = BaseClasses.Creature(null,100,[300000,250000,250000,250000],100,100000,-90,Gun,Vector2(100,0),"Enemies")
	var script = load("res://Behaviours/Enemy.gd")
	SpawnEnemy(Vector2(0,400),creatureObject,script,null)

func SpawnEnemy(origin,creature,script,scriptToExec = null):
	var clone_node = duplicate(1)
	creature.Target = clone_node
	clone_node.add_to_group(creature.Team)
	clone_node.global_position = origin
	clone_node.set_script(script)
	clone_node.creatureObject = creature
	get_parent().add_child.call_deferred(clone_node)
	if scriptToExec != null:
		scriptToExec.call(clone_node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
