extends Node


# Called when the node enters the scene tree for the first time.

var ZombieSquad = []
var root = self
var MarineSquad = []
var soldierthings = [BaseItems.getWeapon("Punch"),BaseItems.getWeapon("Medkit"),BaseItems.getWeapon("M1911")]

func setEnemy(creature,gunArr,Team):
	BaseClasses.AddThingsToInventory(creature,gunArr)
	creature.Team = Team
	return creature
	

func _ready():
	AddComponentsToLevel.main(self)
	for i in range(6):
		ZombieSquad.append(setEnemy(BaseItems.GetCreature("Zombie"),[BaseItems.getWeapon("Punch")],"Zombie"))
	
	for i in range(5):
		MarineSquad.append(setEnemy(BaseItems.GetCreature("Soldier"),soldierthings.duplicate(true),"Soldiers"))
	MarineSquad.append(setEnemy(BaseItems.GetCreature("Heavy"),[BaseItems.getWeapon("M16"),BaseItems.getWeapon("Punch")],"Soldiers"))
	SpawnSquad(ZombieSquad,Vector2(-1879,-769))
	SpawnSquad(ZombieSquad,Vector2(-3903,-187))
	SpawnSquad(MarineSquad,Vector2(-5883,-219))
	BaseClasses.SpawnGroundObj(root,Vector2(-360,-60),BaseItems.GetGroundObj("Adrenaline"))
	BaseClasses.SpawnGroundObj(root,Vector2(-2328,-167),BaseItems.GetGroundObj("Itaca"))
	BaseClasses.SpawnGroundObj(root,Vector2(-2328,-167+40),BaseItems.GetGroundObj("BuckshotAmmo"))
	BaseClasses.SpawnGroundObj(root,Vector2(-2328+40,-167),BaseItems.GetGroundObj("PistolAmmo"))
	BaseClasses.SpawnGroundObj(root,Vector2(-3192,-206),BaseItems.GetGroundObj("Ak-47"))
	BaseClasses.SpawnGroundObj(root,Vector2(-3192+80,-206),BaseItems.GetGroundObj("RifleAmmo"))
	BaseClasses.SpawnGroundObj(root,Vector2(-3192,-206-50),BaseItems.GetGroundObj("Medkit"))
	BaseClasses.CreateBuyArea(root,BaseClasses.BuyArea("res://Sprites/MarketBorder.png"),Vector2(300,300),Vector2(-3792,-206))
	
	
	

func SpawnSquad(creatureArr,coords):
	var script = load("res://Behaviours/Enemy.gd")
	var len = len(creatureArr)
	var halflen = roundi(len(creatureArr)/2)
	for i in range(len(creatureArr)):
		if i < halflen:
			BaseClasses.SpawnEnemy(coords+Vector2(i*100,0),creatureArr[i].duplicate(true),script,null)
		else:
			BaseClasses.SpawnEnemy(coords+Vector2((i-halflen)*100,100),creatureArr[i].duplicate(true),script,null)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
