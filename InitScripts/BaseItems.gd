extends Node

""""GunNode":gunnode,
			"CanFire":true,
			"InterruptReload":false,
			"BulletsRemaining":Magazine,
			"IsReloading":false,
			"BulletWait":bulletwait,
			"Damage": damage,
			"Speed":speed,
			"Range":maxdistance,
			"BaseSpread":basespread,  #expressed in degrees
			"SpreadMultiplier":spreadmultiplier,
			"Magazine":Magazine,
			"ReloadWait":ReloadWait,
			"SingleShotReload":SingleShotReload,
			"BulletAmount":bulletamount,
			"gunAppearance":gunappearance,"""

""""var gunAppearance = {
		"Sprite":Sprite,
		"DropSprite":DropSprite,
		"BuySprite":BuySprite,
		"KillSprite":KillSprite,
		"Offset":Offset,
		"Scale":Scale,
		"ShootSFX":shootsfx,
		"DrawSFX":pulloutsfx,
		"ReloadSFX":reloadsfx,
		"CockSFX":cockSFX,
	}"""
""" "Template":BaseClasses.GunAppearance(load(),load(),load(),load(),Vector2(0,0),Vector2(1,1),load(),null,load(),load()), """

func getWeapon(key):
	return Weapons[key].duplicate()

var GunAppearances = {
	"Ak-47":BaseClasses.GunAppearance(load("res://Sprites/Guns/Memeoji/ak47.png"),load("res://Sprites/Guns/Memeoji/ak47_d.png"),load("res://Sprites/Guns/Memeoji/ak47_m.png"),load("res://Sprites/Guns/Memeoji/ak47_k.png"),Vector2(1,-21.3333),Vector2(1,1),load("res://SFX/ak-47/Gunshot.mp3"),null,load("res://SFX/ak-47/Pullout.mp3"),load("res://SFX/ak-47/Reload.mp3")),
	"Deagle":BaseClasses.GunAppearance(load("res://Sprites/Guns/Axel340/deagle.png"),load("res://Sprites/Guns/Axel340/deagle_d.png"),load("res://Sprites/Guns/Axel340/deagle_m.png"),load("res://Sprites/Guns/Axel340/deagle_k.png"),Vector2(1,-20),Vector2(1,1),load("res://SFX/DesertEagle/Gunshot.mp3"),null,load("res://SFX/DesertEagle/Pullout.mp3"),load("res://SFX/DesertEagle/Reload.mp3")),
	"Glock":BaseClasses.GunAppearance(load("res://Sprites/Guns/Axel340/glock.png"),load("res://Sprites/Guns/Axel340/glock_d.png"),load("res://Sprites/Guns/Axel340/glock_m.png"),load("res://Sprites/Guns/Axel340/glock_k.png"),Vector2(1,-20),Vector2(1,1),load("res://SFX/glock/Gunshot.mp3"),null,load("res://SFX/glock/Pullout.mp3"),load("res://SFX/glock/Reload.mp3")),
	"M1911":BaseClasses.GunAppearance(load("res://Sprites/Guns/bamg/1911.png"),load("res://Sprites/Guns/bamg/m1911_d.png"),load("res://Sprites/Guns/bamg/1911_m.png"),load("res://Sprites/Guns/bamg/1911_k.png"),Vector2(1,-20),Vector2(1,1),load("res://SFX/m1911/Gunshot.mp3"),null,load("res://SFX/m1911/Pullout.mp3"),load("res://SFX/m1911/Reload.mp3")),
	"M16":BaseClasses.GunAppearance(load("res://Sprites/Guns/Captione/m4a1.png"),load("res://Sprites/Guns/Captione/m4a1_d.png"),load("res://Sprites/Guns/Captione/m4a1_m.png"),load("res://Sprites/Guns/Captione/m4a1_k.png"),Vector2(1,-20),Vector2(1,1),load("res://SFX/m16/Gunshot.mp3"),null,load("res://SFX/m16/Pullout.mp3"),load("res://SFX/m16/Reload.mp3")),
	"Spas":BaseClasses.GunAppearance(load("res://Sprites/Guns/Captione/spas.png"),load("res://Sprites/Guns/Captione/spas_d.png"),load("res://Sprites/Guns/Captione/spas_m.png"),load("res://Sprites/Guns/Captione/Spas_k.png"),Vector2(1,-20),Vector2(1,1),load("res://SFX/spas/Gunshot.mp3"),null,load("res://SFX/spas/Pullout.mp3"),load("res://SFX/spas/Reload.mp3")),
	"Magnum":BaseClasses.GunAppearance(load("res://Sprites/Guns/EquinoX/44magnum.bmp"),load("res://Sprites/Guns/EquinoX/44magnum_d.bmp"),load("res://Sprites/Guns/EquinoX/44magnum_m.bmp"),load("res://Sprites/Guns/EquinoX/44magnum_k.bmp"),Vector2(1,-20),Vector2(1,1),load("res://SFX/44 magnum/Gunshot.mp3"),null,load("res://SFX/44 magnum/Pullout.mp3"),load("res://SFX/44 magnum/Reload.mp3")),
	"Itaca":BaseClasses.GunAppearance(load("res://Sprites/Guns/M5H4cK/m3.png"),load("res://Sprites/Guns/M5H4cK/m3_d.png"),load("res://Sprites/Guns/M5H4cK/m3_m.png"),load("res://Sprites/Guns/M5H4cK/m3_k.png"),Vector2(1,-20),Vector2(1,1),load("res://SFX/mossberg/Gunshot.mp3"),load("res://SFX/mossberg/Cock.mp3"),load("res://SFX/mossberg/Pullout.mp3"),load("res://SFX/mossberg/Reload.mp3")),
	"Knife":BaseClasses.GunAppearance(load("res://Sprites/Guns/Yates/knife.png"),load("res://Sprites/Guns/Yates/knife_d.png"),null,null,Vector2(1,-20),Vector2(1,1),load("res://SFX/fists/Gunshot.wav"),null,null,null),
	"Punch":BaseClasses.GunAppearance(null,null,null,null,Vector2(1,-20),Vector2(1,1),load("res://SFX/fists/Gunshot.wav"),null,null,null),
}

var Weapons = {
	"Punch":BaseClasses.Gun(null,0.33,25,1000,15,10,0.15,1,0.33,false,1,GunAppearances["Punch"]),
	"Knife":BaseClasses.Gun(null,0.24,20,1000,30,0.01,0.15,1,0.24,false,1,GunAppearances["Knife"]),
	"Ak-47":BaseClasses.Gun(null,0.11,26,7000,2200,7,0.11,30,2.2,false,1,GunAppearances["Ak-47"]),
	"M16":BaseClasses.Gun(null,0.1,22,8000,2400,6,0.09,30,2,false,1,GunAppearances["M16"]),
	"Deagle":BaseClasses.Gun(null,0.27,32,5500,1500,10,0.06,7,1.7,false,1,GunAppearances["Deagle"]),
	"Magnum":BaseClasses.Gun(null,0.55,45,5700,1800,8,0.07,6,3.5,false,1,GunAppearances["Magnum"]),
	"Glock":BaseClasses.Gun(null,0.19,18,6000,1450,15,0.05,17,2.1,false,1,GunAppearances["Glock"]),
	"M1911":BaseClasses.Gun(null,0.24,24,5900,1450,13,0.06,8,2.1,false,1,GunAppearances["M1911"]),
	"Itaca":BaseClasses.Gun(null,0.86,15,5200,1400,20,0.04,6,3.5,true,8,GunAppearances["Itaca"]),
	"Spas":BaseClasses.Gun(null,0.26,13,5200,1400,24,0.06,5,3.5,true,8,GunAppearances["Spas"]),
}

var Creatures = {
	
}
