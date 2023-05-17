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
}

var Weapons = {
	"Punch":BaseClasses.Gun(null,0.33,25,1000,15,1,5,0.15,1,0.33,false,1,GunAppearances["Punch"],true,"Melee"),
	"Knife":BaseClasses.Gun(null,0.24,20,1000,30,1,3,0.15,1,0.24,false,1,GunAppearances["Knife"],true,"Melee"),
	"Ak-47":BaseClasses.Gun(null,0.11,26,7000,2200,8.1,7,0.11,30,2.2,false,1,GunAppearances["Ak-47"],false,"Rifle"),
	"M16":BaseClasses.Gun(null,0.1,22,8000,2400,7.8,6,0.09,30,2,false,1,GunAppearances["M16"],false,"Rifle"),
	"Deagle":BaseClasses.Gun(null,0.27,32,5500,1500,24.4,10,0.06,7,1.7,false,1,GunAppearances["Deagle"],false,"Pistol"),
	"Magnum":BaseClasses.Gun(null,0.46,45,5700,1800,31.5,8,0.07,6,3.5,false,1,GunAppearances["Magnum"],false,"Pistol"),
	"Glock":BaseClasses.Gun(null,0.19,18,6000,1450,15.1,15,0.05,17,2.1,false,1,GunAppearances["Glock"],false,"Pistol"),
	"M1911":BaseClasses.Gun(null,0.24,24,5900,1450,17.2,13,0.06,8,2.1,false,1,GunAppearances["M1911"],false,"Pistol"),
	"Itaca":BaseClasses.Gun(null,0.86,15,5200,1400,32.7,20,0.04,6,3.5,true,8,GunAppearances["Itaca"],false,"Rifle"),
	"Spas":BaseClasses.Gun(null,0.26,13,5200,1400,30.1,24,0.06,5,3.5,true,8,GunAppearances["Spas"],false,"Rifle"),
}

func getWeapon(key):
	return Weapons[key].duplicate(true)



var CreatureAppearances = {
	"Goon":BaseClasses.CreatureAppearance(null,load("res://Sprites/Creatures/Goon/Idle.tres"),"Idle","Melee","Reload",Vector2(0,0),Vector2(3,3),load("res://SFX/Human/Hit.wav"),null,null,[load("res://SFX/Human/Footstep_L.mp3"),load("res://SFX/Human/Footstep_R.mp3")]),
	"Soldier":BaseClasses.CreatureAppearance(null,load("res://Sprites/Creatures/Soldier/Idle.tres"),"Idle","Melee","Reload",Vector2(0,0),Vector2(3,3),load("res://SFX/Human/Hit.wav"),null,null,[load("res://SFX/Human/Footstep_L.mp3"),load("res://SFX/Human/Footstep_R.mp3")]),
	"Terrorist":BaseClasses.CreatureAppearance(null,load("res://Sprites/Creatures/terrorist/Idle.tres"),"Idle","Melee","Reload",Vector2(0,0),Vector2(3,3),load("res://SFX/Human/Hit.wav"),null,null,[load("res://SFX/Human/Footstep_L.mp3"),load("res://SFX/Human/Footstep_R.mp3")]),
	"Zombie":BaseClasses.CreatureAppearance(null,load("res://Sprites/Creatures/Zombie/Idle.tres"),"Idle","Melee","Reload",Vector2(0,0),Vector2(3,3),load("res://SFX/Zombie/Hit.wav"),load("res://SFX/Zombie/Pain.wav"),null,[load("res://SFX/Zombie/Footstep_L.mp3"),load("res://SFX/Zombie/Footstep_R.mp3")]),
	"Heavy":BaseClasses.CreatureAppearance(null,load("res://Sprites/Creatures/Heavy/Idle.tres"),"Idle","Melee","Reload",Vector2(0,0),Vector2(3,3),load("res://SFX/Human/Hit.wav"),null,null,[load("res://SFX/Human/Footstep_L.mp3"),load("res://SFX/Human/Footstep_R.mp3")]),
}

var Creatures = {
	"Goon":BaseClasses.Creature(null,110,BaseClasses.Inventory(),[200000,200000,200000,200000],80,110000,-90,null,Vector2(50,0),"Enemies",CreatureAppearances["Goon"]),
	"Soldier":BaseClasses.Creature(null,140,BaseClasses.Inventory(),[200000,200000,200000,200000],90,100000,-90,null,Vector2(50,0),"Enemies",CreatureAppearances["Soldier"]),
	"Terrorist":BaseClasses.Creature(null,120,BaseClasses.Inventory(),[200000,200000,200000,200000],85,110000,-90,null,Vector2(50,0),"Enemies",CreatureAppearances["Terrorist"]),
	"Zombie":BaseClasses.Creature(null,70,BaseClasses.Inventory(0,0,1,0,[],[],[getWeapon("Punch")]),[190000,190000,190000,190000],75,50000,-90,null,Vector2(50,0),"Enemies",CreatureAppearances["Zombie"]),
	"Heavy":BaseClasses.Creature(null,230,BaseClasses.Inventory(2,1),[200000,200000,200000,200000],130,70000,-90,null,Vector2(50,0),"Enemies",CreatureAppearances["Heavy"]),
}

func GetCreature(creaturekey):
	return Creatures[creaturekey].duplicate(true)



var Props = {
	"Box":BaseClasses.Creature(null,60,null,30,null,null,null,null,"Boxes",null),
}

func GetProp(key):
	return Props[key].duplicate(true)



var ActiveTeams = Array()
