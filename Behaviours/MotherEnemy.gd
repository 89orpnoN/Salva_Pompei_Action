extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	BaseClasses.connect("spawnEnemy", SpawnEnemy)
	var creatureObject = BaseItems.GetCreature("Soldier")
	BaseClasses.AddThingsToInventory(creatureObject,[BaseItems.getWeapon("Punch"),BaseItems.getWeapon("Knife"),BaseItems.getWeapon("Glock")])
	creatureObject.Team = "Criminals"
	var script = load("res://Behaviours/Enemy.gd")
	SpawnEnemy(Vector2(0,400),creatureObject,script,null)
	creatureObject = BaseItems.GetCreature("Zombie")
	BaseClasses.AddThingsToInventory(creatureObject,[BaseItems.getWeapon("Knife")])
	creatureObject.Team = "Undead"
	SpawnEnemy(Vector2(0,0),creatureObject,script,null)

func SpawnEnemy(origin,creature,script,scriptToExec = null):
	var clone_node = duplicate(1)
	clone_node.global_position = origin
	clone_node.set_script(script)
	BaseClasses.Morph(clone_node,clone_node.get_node("EnemyAppearance"),creature)
	BaseClasses.EquipGun(creature,BaseClasses.arrayAt(BaseClasses.GetAllThings(creature),0),clone_node,clone_node.get_node("EnemyAppearance/Gun"))
	get_parent().add_child.call_deferred(clone_node)
	if scriptToExec != null:
		scriptToExec.call(clone_node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
