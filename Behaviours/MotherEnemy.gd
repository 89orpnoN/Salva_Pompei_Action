extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	BaseClasses.connect("spawnEnemy", SpawnEnemy)
	
		
	var creatureObject = BaseItems.GetCreature("Soldier")
	creatureObject.Gun = BaseItems.getWeapon("M1911")
	creatureObject.Team = "Criminals"
	var script = load("res://Behaviours/Enemy.gd")
	SpawnEnemy(Vector2(0,400),creatureObject,script,null)
	creatureObject = BaseItems.GetCreature("Zombie")
	creatureObject.Gun = BaseItems.getWeapon("Knife")
	creatureObject.Team = "Undead"
	SpawnEnemy(Vector2(0,0),creatureObject,script,null)

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
