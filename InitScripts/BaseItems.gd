extends Node

var GunAppearances = {
	"Ak-47":BaseClasses.GunAppearance(load("res://Sprites/Guns/Memeoji/ak47.png"),load("res://Sprites/Guns/Memeoji/ak47_d.png"),load("res://Sprites/Guns/Memeoji/ak47_m.png"),load("res://Sprites/Guns/Memeoji/ak47_k.png"),Vector2(0,-20),Vector2(1,1),load("res://SFX/ak-47/Gunshot.mp3"),null,load("res://SFX/ak-47/Pullout.mp3"),load("res://SFX/ak-47/Reload.mp3")),
	"Deagle":BaseClasses.GunAppearance(load("res://Sprites/Guns/Axel340/deagle.png"),load("res://Sprites/Guns/Axel340/deagle_d.png"),load("res://Sprites/Guns/Axel340/deagle_m.png"),load("res://Sprites/Guns/Axel340/deagle_k.png"),Vector2(0,-20),Vector2(1,1),load("res://SFX/DesertEagle/Gunshot.mp3"),null,load("res://SFX/DesertEagle/Pullout.mp3"),load("res://SFX/DesertEagle/Reload.mp3")),
	"Glock":BaseClasses.GunAppearance(load("res://Sprites/Guns/Axel340/glock.png"),load("res://Sprites/Guns/Axel340/glock_d.png"),load("res://Sprites/Guns/Axel340/glock_m.png"),load("res://Sprites/Guns/Axel340/glock_k.png"),Vector2(0,-20),Vector2(1,1),load("res://SFX/glock/Gunshot.mp3"),null,load("res://SFX/glock/Pullout.mp3"),load("res://SFX/glock/Reload.mp3")),
	"M1911":BaseClasses.GunAppearance(load("res://Sprites/Guns/bamg/1911.png"),load("res://Sprites/Guns/bamg/m1911_d.png"),load("res://Sprites/Guns/bamg/1911_m.png"),load("res://Sprites/Guns/bamg/1911_k.png"),Vector2(0,-20),Vector2(1,1),load("res://SFX/m1911/Gunshot.mp3"),null,load("res://SFX/m1911/Pullout.mp3"),load("res://SFX/m1911/Reload.mp3")),
	"M16":BaseClasses.GunAppearance(load("res://Sprites/Guns/Captione/m4a1.png"),load("res://Sprites/Guns/Captione/m4a1_d.png"),load("res://Sprites/Guns/Captione/m4a1_m.png"),load("res://Sprites/Guns/Captione/m4a1_k.png"),Vector2(0,-20),Vector2(1,1),load("res://SFX/m16/Gunshot.mp3"),null,load("res://SFX/m16/Pullout.mp3"),load("res://SFX/m16/Reload.mp3")),
	"Spas":BaseClasses.GunAppearance(load("res://Sprites/Guns/Captione/spas.png"),load("res://Sprites/Guns/Captione/spas_d.png"),load("res://Sprites/Guns/Captione/spas_m.png"),load("res://Sprites/Guns/Captione/Spas_k.png"),Vector2(0,-20),Vector2(1,1),load("res://SFX/spas/Gunshot.mp3"),null,load("res://SFX/spas/Pullout.mp3"),load("res://SFX/spas/Reload.mp3")),
	"Magnum":BaseClasses.GunAppearance(load("res://Sprites/Guns/EquinoX/44magnum.bmp"),load("res://Sprites/Guns/EquinoX/44magnum_d.bmp"),load("res://Sprites/Guns/EquinoX/44magnum_m.bmp"),load("res://Sprites/Guns/EquinoX/44magnum_k.bmp"),Vector2(0,-20),Vector2(1,1),load("res://SFX/44 magnum/Gunshot.mp3"),null,load("res://SFX/44 magnum/Pullout.mp3"),load("res://SFX/44 magnum/Reload.mp3")),
	"Itaca":BaseClasses.GunAppearance(load("res://Sprites/Guns/M5H4cK/m3.png"),load("res://Sprites/Guns/M5H4cK/m3_d.png"),load("res://Sprites/Guns/M5H4cK/m3_m.png"),load("res://Sprites/Guns/M5H4cK/m3_k.png"),Vector2(0,-20),Vector2(1,1),load("res://SFX/mossberg/Gunshot.mp3"),load("res://SFX/mossberg/Cock.mp3"),load("res://SFX/mossberg/Pullout.mp3"),load("res://SFX/mossberg/Reload.mp3")),
	"Knife":BaseClasses.GunAppearance(load("res://Sprites/Guns/Yates/knife.png"),load("res://Sprites/Guns/Yates/knife_d.png"),null,null,Vector2(0,-20),Vector2(1,1),load("res://SFX/fists/Gunshot.wav"),null,null,null),
	"Punch":BaseClasses.GunAppearance(null,null,null,null,Vector2(0,-20),Vector2(1,1),load("res://SFX/fists/Gunshot.wav"),null,null,null),
	"Adrenaline":BaseClasses.GunAppearance(load("res://Sprites/HealthPacks/Adrenaline.png"),null,null,null,Vector2(0,-15),Vector2(0.5,0.5),load("res://SFX/fists/Gunshot.wav"),null,null,null),
	"Medkit":BaseClasses.GunAppearance(load("res://Sprites/HealthPacks/MedPack.png"),null,null,null,Vector2(0,-20),Vector2(0.33,0.33),load("res://SFX/fists/Gunshot.wav"),null,null,null),
}



var Weapons = {
	"Punch":BaseClasses.Gun(null,"Punch",0.33,25,1000,50,1,5,0.15,1,null,0.33,false,1,GunAppearances["Punch"],true,"Melee"),
	"Knife":BaseClasses.Gun(null,"Knife",0.24,20,1000,50,1,3,0.15,1,null,0.24,false,1,GunAppearances["Knife"],true,"Melee"),
	"Ak-47":BaseClasses.Gun(null,"Ak-47",0.11,26,7000,2200,8.1,7,0.11,30,"RifleAmmo",2.2,false,1,GunAppearances["Ak-47"],false,"Rifles"),
	"M16":BaseClasses.Gun(null,"M16",0.1,22,8000,2400,7.8,6,0.09,30,"RifleAmmo",2,false,1,GunAppearances["M16"],false,"Rifles"),
	"Deagle":BaseClasses.Gun(null,"Deagle",0.27,32,5500,1500,24.4,10,0.06,7,"PistolAmmo",1.7,false,1,GunAppearances["Deagle"],false,"Pistols"),
	"Magnum":BaseClasses.Gun(null,"Magnum",0.46,45,5700,1800,31.5,8,0.07,6,"PistolAmmo",3.5,false,1,GunAppearances["Magnum"],false,"Pistols"),
	"Glock":BaseClasses.Gun(null,"Glock",0.19,18,6000,1450,15.1,15,0.05,17,"PistolAmmo",2.1,false,1,GunAppearances["Glock"],false,"Pistols"),
	"M1911":BaseClasses.Gun(null,"M1911",0.24,24,5900,1450,17.2,13,0.06,8,"PistolAmmo",2.1,false,1,GunAppearances["M1911"],false,"Pistols"),
	"Itaca":BaseClasses.Gun(null,"Itaca",0.86,15,5200,1400,32.7,20,0.04,6,"BuckshotAmmo",3.5,true,8,GunAppearances["Itaca"],false,"Rifles"),
	"Spas":BaseClasses.Gun(null,"Spas",0.26,13,5200,1400,30.1,24,0.06,5,"BuckshotAmmo",3.5,true,8,GunAppearances["Spas"],false,"Rifles"),
	"Adrenaline":BaseClasses.merge_dict(BaseClasses.Gun(null,"Adrenaline",1,0,0,0,0,0,0,0,null,0,false,0,GunAppearances["Adrenaline"],false,"Items",BaseClasses.DropHeldGun),BaseClasses.HealthPack(120,2,true)),
	"Medkit":BaseClasses.merge_dict(BaseClasses.Gun(null,"Medkit",1,0,0,0,0,0,0,0,null,0,false,0,GunAppearances["Medkit"],false,"Items",BaseClasses.DropHeldGun),BaseClasses.HealthPack(200,0,false)),
}

func getWeapon(key):
	return Weapons[key].duplicate(true)

func getWeapons():
	return Weapons.duplicate(true)

var CreatureAppearances = {
	"Goon":BaseClasses.CreatureAppearance(null,load("res://Sprites/Creatures/Goon/Idle.tres"),"Idle","Melee","Reload",Vector2(0,0),Vector2(3,3),load("res://SFX/Human/Hit.wav"),null,null,[load("res://SFX/Human/Footstep_L.mp3"),load("res://SFX/Human/Footstep_R.mp3")]),
	"Soldier":BaseClasses.CreatureAppearance(null,load("res://Sprites/Creatures/Soldier/Idle.tres"),"Idle","Melee","Reload",Vector2(0,0),Vector2(3,3),load("res://SFX/Human/Hit.wav"),null,null,[load("res://SFX/Human/Footstep_L.mp3"),load("res://SFX/Human/Footstep_R.mp3")]),
	"Terrorist":BaseClasses.CreatureAppearance(null,load("res://Sprites/Creatures/terrorist/Idle.tres"),"Idle","Melee","Reload",Vector2(0,0),Vector2(3,3),load("res://SFX/Human/Hit.wav"),null,null,[load("res://SFX/Human/Footstep_L.mp3"),load("res://SFX/Human/Footstep_R.mp3")]),
	"Zombie":BaseClasses.CreatureAppearance(null,load("res://Sprites/Creatures/Zombie/Idle.tres"),"Idle","Melee","Reload",Vector2(0,0),Vector2(3,3),load("res://SFX/Zombie/Hit.wav"),load("res://SFX/Zombie/Pain.wav"),null,[load("res://SFX/Zombie/Footstep_L.mp3"),load("res://SFX/Zombie/Footstep_R.mp3")]),
	"Heavy":BaseClasses.CreatureAppearance(null,load("res://Sprites/Creatures/Heavy/Idle.tres"),"Idle","Melee","Reload",Vector2(0,0),Vector2(3,3),load("res://SFX/Human/Hit.wav"),null,null,[load("res://SFX/Human/Footstep_L.mp3"),load("res://SFX/Human/Footstep_R.mp3")]),
}


var CreatureHealths = {
	"PlayerSoldier":BaseClasses.Health(460,230,1,3,100,3), #probabilmente finirà inutilizzata
	"Goon":BaseClasses.Health(110,0, 1, 1,30,7),
	"Soldier":BaseClasses.Health(140,0, 1, 1,40,7),
	"Terrorist":BaseClasses.Health(120,0, 1, 1,36,7),
	"Zombie":BaseClasses.Health(70,0),
	"Heavy":BaseClasses.Health(230,0, 1, 1,70,7),
}

func GetCreatureHealth(key):
	if CreatureHealths.has(key):
		return CreatureHealths[key].duplicate(true)
	else:
		print("CreatureHealths " + key + " does not exist")
		return false

var Creatures = {
	"Goon":BaseClasses.Creature(null,GetCreatureHealth("Goon"),BaseClasses.Inventory(),[200000,200000,200000,200000],80,110000,-90,null,Vector2(50,0),"Enemies",CreatureAppearances["Goon"]),
	"Soldier":BaseClasses.Creature(null,GetCreatureHealth("Soldier"),BaseClasses.Inventory(),[200000,200000,200000,200000],90,100000,-90,null,Vector2(50,0),"Enemies",CreatureAppearances["Soldier"]),
	"Terrorist":BaseClasses.Creature(null,GetCreatureHealth("Terrorist"),BaseClasses.Inventory(),[200000,200000,200000,200000],85,110000,-90,null,Vector2(50,0),"Enemies",CreatureAppearances["Terrorist"]),
	"Zombie":BaseClasses.Creature(null,GetCreatureHealth("Zombie"),BaseClasses.Inventory(0,0,1,0,0,0,0,[],[],[getWeapon("Punch")]),[190000,190000,190000,190000],75,50000,-90,null,Vector2(50,0),"Enemies",CreatureAppearances["Zombie"]),
	"Heavy":BaseClasses.Creature(null,GetCreatureHealth("Heavy"),BaseClasses.Inventory(2,1),[200000,200000,200000,200000],130,70000,-90,null,Vector2(50,0),"Enemies",CreatureAppearances["Heavy"]),
}

func GetCreature(key):
	if Creatures.has(key):
		return Creatures[key].duplicate(true)
	else:
		print("Creatures " + key + " does not exist")
		return false



var GroundObj = {
	"Knife":BaseClasses.GroundObject(getWeapon("Knife"),load("res://Sprites/Guns/Yates/knife_d.png"),load("res://SFX/ItemEquip/Item Pickup.mp3"),Vector2(3,3),load("res://Behaviours/GunGroundObject.gd")),
	"Ak-47":BaseClasses.GroundObject(getWeapon("Ak-47"),load("res://Sprites/Guns/Memeoji/ak47_d.png"),load("res://SFX/ItemEquip/Item Pickup.mp3"),Vector2(3,3),load("res://Behaviours/GunGroundObject.gd")),
	"M16":BaseClasses.GroundObject(getWeapon("M16"),load("res://Sprites/Guns/Captione/m4a1_d.png"),load("res://SFX/ItemEquip/Item Pickup.mp3"),Vector2(3,3),load("res://Behaviours/GunGroundObject.gd")),
	"Deagle":BaseClasses.GroundObject(getWeapon("Deagle"),load("res://Sprites/Guns/Axel340/deagle_d.png"),load("res://SFX/ItemEquip/Item Pickup.mp3"),Vector2(3,3),load("res://Behaviours/GunGroundObject.gd")),
	"Magnum":BaseClasses.GroundObject(getWeapon("Magnum"),load("res://Sprites/Guns/EquinoX/44magnum_d.bmp"),load("res://SFX/ItemEquip/Item Pickup.mp3"),Vector2(3,3),load("res://Behaviours/GunGroundObject.gd")),
	"Glock":BaseClasses.GroundObject(getWeapon("Glock"),load("res://Sprites/Guns/Axel340/glock_d.png"),load("res://SFX/ItemEquip/Item Pickup.mp3"),Vector2(3,3),load("res://Behaviours/GunGroundObject.gd")),
	"M1911":BaseClasses.GroundObject(getWeapon("M1911"),load("res://Sprites/Guns/bamg/m1911_d.png"),load("res://SFX/ItemEquip/Item Pickup.mp3"),Vector2(3,3),load("res://Behaviours/GunGroundObject.gd")),
	"Itaca":BaseClasses.GroundObject(getWeapon("Itaca"),load("res://Sprites/Guns/M5H4cK/m3_d.png"),load("res://SFX/ItemEquip/Item Pickup.mp3"),Vector2(3,3),load("res://Behaviours/GunGroundObject.gd")),
	"Spas":BaseClasses.GroundObject(getWeapon("Spas"),load("res://Sprites/Guns/Captione/spas_d.png"),load("res://SFX/ItemEquip/Item Pickup.mp3"),Vector2(3,3),load("res://Behaviours/GunGroundObject.gd")),
	"PistolAmmo":BaseClasses.GroundObject(BaseClasses.AmmopackInit(BaseClasses.AmmoPack("PistolAmmo"),30),load("res://Sprites/Ammopacks/PistolAmmo.png"),load("res://SFX/ItemEquip/Item Pickup.mp3"),Vector2(1,1),load("res://Behaviours/AmmoGroundObject.gd")), 
	"RifleAmmo":BaseClasses.GroundObject(BaseClasses.AmmopackInit(BaseClasses.AmmoPack("RifleAmmo"),30),load("res://Sprites/Ammopacks/RifleAmmo.png"),load("res://SFX/ItemEquip/Item Pickup.mp3"),Vector2(1,1),load("res://Behaviours/AmmoGroundObject.gd")),
	"BuckshotAmmo":BaseClasses.GroundObject(BaseClasses.AmmopackInit(BaseClasses.AmmoPack("BuckshotAmmo"),15),load("res://Sprites/Ammopacks/BuckshotAmmo.png"),load("res://SFX/ItemEquip/Item Pickup.mp3"),Vector2(1,1),load("res://Behaviours/AmmoGroundObject.gd")),
	"Adrenaline":BaseClasses.GroundObject(BaseClasses.HealthPack(120,2,true),load("res://Sprites/HealthPacks/Adrenaline.png"),load("res://SFX/HealingPacks/Adrenaline Shot.mp3"),Vector2(2,2),load("res://Behaviours/HealthPackGroundObject.gd")),
	"Medkit":BaseClasses.GroundObject(BaseClasses.HealthPack(200,0,false),load("res://Sprites/HealthPacks/MedPack.png"),load("res://SFX/HealingPacks/Medkit.mp3"),Vector2(1,1),load("res://Behaviours/HealthPackGroundObject.gd")),
	"MedPack":BaseClasses.GroundObject(BaseClasses.HealthPack(100,0,false),load("res://Sprites/HealthPacks/MedPack.png"),load("res://SFX/HealingPacks/Medkit.mp3"),Vector2(0.7,0.7),load("res://Behaviours/HealthPackGroundObject.gd")),
}

func GetGroundObj(key):
	if GroundObj.has(key):
		return GroundObj[key].duplicate(true)
	elif key != null:
		print("GroundObj " + key + " does not exist")
		return false
	else:
		print("GroundObj null does not exist")
		return false

func GetGroundObjects():
	return GroundObj.duplicate(true)

var Props = {
	"Box":BaseClasses.Creature(null,BaseClasses.Health(0,0,0,0,0,3,100,0),null,30,null,null,null,null,"Boxes",null),
}

func GetProp(key):
	if Props.has(key):
		return Props[key].duplicate(true)
	else:
		print("Props " + key + " does not exist")
		return false

var ShopGunObject = {
	"Knife":BaseClasses.ShopGunObject("Knife","Knife",500,load("res://Sprites/Guns/Yates/knife.png"),getWeapon("Knife"),GetGroundObj("Knife")),
	"Ak-47":BaseClasses.ShopGunObject("Ak-47","Ak-47",5300,load("res://Sprites/Guns/Yates/knife.png"),getWeapon("Ak-47"),GetGroundObj("Ak-47")),
	"M16":BaseClasses.ShopGunObject("M16","M16",5600,load("res://Sprites/Guns/Yates/knife.png"),getWeapon("M16"),GetGroundObj("M16")),
	"Deagle":BaseClasses.ShopGunObject("Deagle","Deagle",1800,load("res://Sprites/Guns/Yates/knife.png"),getWeapon("Deagle"),GetGroundObj("Deagle")),
	"Magnum":BaseClasses.ShopGunObject("Magnum","Magnum",2500,load("res://Sprites/Guns/Yates/knife.png"),getWeapon("Magnum"),GetGroundObj("Magnum")),
	"Glock":BaseClasses.ShopGunObject("Glock","Glock",1400,load("res://Sprites/Guns/Yates/knife.png"),getWeapon("Glock"),GetGroundObj("Glock")),
	"M1911":BaseClasses.ShopGunObject("M1911","M1911",800,load("res://Sprites/Guns/Yates/knife.png"),getWeapon("M1911"),GetGroundObj("M1911")),
	"Itaca":BaseClasses.ShopGunObject("Itaca","Itaca",3200,load("res://Sprites/Guns/Yates/knife.png"),getWeapon("Itaca"),GetGroundObj("Itaca")),
	"Spas":BaseClasses.ShopGunObject("Spas","Spas",5000,load("res://Sprites/Guns/Yates/knife.png"),getWeapon("Spas"),GetGroundObj("Spas")),
	"PistolAmmo":BaseClasses.ShopGunObject("PistolAmmo","Pistol Ammo",150,load("res://Sprites/Guns/Yates/knife.png"),null,GetGroundObj("PistolAmmo")),
	"RifleAmmo":BaseClasses.ShopGunObject("RifleAmmo","Rifle Ammo",200,load("res://Sprites/Guns/Yates/knife.png"),null,GetGroundObj("RifleAmmo")),
	"BuckshotAmmo":BaseClasses.ShopGunObject("BuckshotAmmo","Shotgun Ammo",200,load("res://Sprites/Guns/Yates/knife.png"),null,GetGroundObj("BuckshotAmmo")),
	"Adrenaline":BaseClasses.ShopGunObject("Adrenaline","Adrenaline",800,load("res://Sprites/Guns/Yates/knife.png"),getWeapon("Adrenaline"),GetGroundObj("Adrenaline")),
	"Medkit":BaseClasses.ShopGunObject("Medkit","Medkit",700,load("res://Sprites/Guns/Yates/knife.png"),getWeapon("Medkit"),GetGroundObj("Medkit")),
	"MedPack":BaseClasses.ShopGunObject("MedPack","MedPack",400,load("res://Sprites/Guns/Yates/knife.png"),null,GetGroundObj("MedPack")),
}

func GetShopGunObject(key):
	if ShopGunObject.has(key):
		return ShopGunObject[key].duplicate(true)
	else:
		print("ShopGunObject " + key + " does not exist")
		return false

var ActiveTeams = Array()
