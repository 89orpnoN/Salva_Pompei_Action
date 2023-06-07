extends Node2D

var Player
var PlayercreatureObject
var Healthtext
var Ammotext
var SuperHealthtext
var Moneytext
var InventoryList 
# Called when the node enters the scene tree for the first time.
func _ready():
	Player = get_parent().get_parent()
	PlayercreatureObject = Player.creatureObject
	Healthtext = get_node("Health")
	Ammotext = get_node("Ammo")
	SuperHealthtext = get_node("SuperHealth")
	Moneytext =get_node("Money")
	InventoryList = get_node("InventoryList")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if PlayercreatureObject == null:
		PlayercreatureObject = Player.creatureObject
	if Player != null:
		Healthtext.text = str(round(Player.creatureObject.Health.Health))
		SuperHealthtext.text = str(round(Player.creatureObject.Health.TempHealth))
		var str = str(PlayercreatureObject.Gun.BulletsRemaining)
		if	PlayercreatureObject.Gun.AmmoType != null:
			str += " / " + str(PlayercreatureObject.Inventory[PlayercreatureObject.Gun.AmmoType][0])
		
		Ammotext.text = str
		Moneytext.text = "$" +str(Player.creatureObject.Money)
