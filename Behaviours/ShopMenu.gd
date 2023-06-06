extends Node2D

var Opener
var ShopButton
var GunList
var ItemsList = []
# Called when the node enters the scene tree for the first time.


func _ready():
	ShopButton = get_node("ShopButton")
	GunList = get_node("GunList")
	for i in BaseItems.ShopGunObject:
		ItemsList.append(BaseItems.ShopGunObject[i].duplicate(true))
	GunList.clear()
	for i in ItemsList:
		GunList.add_item(i.DisplayName,i.Sprite)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation = deg_to_rad(0)


func _on_gun_list_item_selected(index):
	ShopButton.text = "$ " + str(ItemsList[index].Price)
	if Opener.Money <= ItemsList[index].Price:
		ShopButton.add_theme_color_override("font_color", Color.DARK_RED)
	else:
		ShopButton.add_theme_color_override("font_color", Color.WHITE)


func _on_shop_button_pressed():
	var selected = GunList.get_selected_items()
	if len(selected)>=1:
		BaseClasses.BuyItem(Opener,get_node("/root/World"),ItemsList[GunList.get_selected_items()[0]].duplicate(true))
		
