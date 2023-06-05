extends Node2D

var ShopButton
var GunList
var ItemsList = []
# Called when the node enters the scene tree for the first time.
func _ready():
	ShopButton = get_node("ShopButton")
	GunList = get_node("GunList")
	for i in BaseItems.ShopGunObject:
		ItemsList.append(BaseItems.ShopGunObject[i].duplicate(true))
	for i in ItemsList:
		GunList.add_item(i.DisplayName,i.Sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation = deg_to_rad(0)
	


func _on_gun_list_item_clicked(index, at_position, mouse_button_index):
	pass
