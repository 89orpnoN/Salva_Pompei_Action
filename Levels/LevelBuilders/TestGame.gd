extends Node

var root = self
# Called when the node enters the scene tree for the first time.
func _ready():
	AddComponentsToLevel.main(self)
	spawnenemies()
	spawnItems()

func spawnItems():
	BaseClasses.SpawnGroundObj(root,Vector2(-360,-60),BaseItems.GetGroundObj("Adrenaline"),load("res://Behaviours/HealthPackGroundObject.gd"))
	BaseClasses.SpawnGroundObj(root,Vector2(-360,-60),BaseItems.GetGroundObj("Medkit"),load("res://Behaviours/HealthPackGroundObject.gd"))
	BaseClasses.SpawnGroundObj(root,Vector2(-60,-60),BaseClasses.AmmopackInit(BaseItems.GetGroundObj("BuckshotAmmo"),7),load("res://Behaviours/AmmoGroundObject.gd"))
	BaseClasses.SpawnGroundObj(root,Vector2(30,30),BaseClasses.AmmopackInit(BaseItems.GetGroundObj("RifleAmmo"),30),load("res://Behaviours/AmmoGroundObject.gd"))
	BaseClasses.SpawnGroundObj(root,Vector2(-30,-30),BaseClasses.AmmopackInit(BaseItems.GetGroundObj("PistolAmmo"),30),load("res://Behaviours/AmmoGroundObject.gd"))
	BaseClasses.SpawnGroundObj(root,Vector2(0,0),BaseItems.GetGroundObj("M16"),load("res://Behaviours/GunGroundObject.gd"))
	BaseClasses.CreateBuyArea(root,BaseClasses.BuyArea("res://Sprites/MarketBorder.png"),Vector2(1000,1000),Vector2(-200,-200))

func spawnenemies():
	var creatureObject = BaseItems.GetCreature("Soldier")
	BaseClasses.AddThingsToInventory(creatureObject,[BaseItems.getWeapon("Punch"),BaseItems.getWeapon("Knife"),BaseItems.getWeapon("Glock")])
	creatureObject.Team = "Criminals"
	var script = load("res://Behaviours/Enemy.gd")
	BaseClasses.SpawnEnemy(Vector2(0,400),creatureObject,script,null)
	creatureObject = BaseItems.GetCreature("Zombie")
	BaseClasses.AddThingsToInventory(creatureObject,[BaseItems.getWeapon("Knife")])
	creatureObject.Team = "Undead"
	BaseClasses.SpawnEnemy(Vector2(0,0),creatureObject,script,null)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
