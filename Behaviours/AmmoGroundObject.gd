extends Area2D

var GroundObj
var area 
# Called when the node enters the scene tree for the first time.
func _ready():
	await BaseClasses.sleep(0.2)
	self.body_entered.connect(NodeEntered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func NodeEntered(node):
	if node.creatureObject != null and node.creatureObject.Inventory!=null:
		var AmmoBefore = GroundObj.Item.Amount
		if BaseClasses.AddAmmoPackToInventory(node.creatureObject,GroundObj.Item):
			BaseClasses.PlaySound(node,GroundObj.PickupSFX)
			queue_free()
		if AmmoBefore != GroundObj.Item.Amount:
			BaseClasses.PlaySound(node,GroundObj.PickupSFX)
