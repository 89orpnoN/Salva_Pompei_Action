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

""""Sprite":Sprite,
		"Offset":Offset,
		"Scale":Scale,
		"ShootSFX":shootsfx,
		"DrawSFX":pulloutsfx,
		"ReloadSFX":reloadsfx,
		"cockSFX":cockSFX,"""
		

var Weapons = {
	"punch":BaseClasses.Gun(null,0.33,20,4000,25,0.1,0.15,1,0.33,true,15,null),
	"ak-47":BaseClasses.Gun(null,0.1,34,8000,10000,10,0.15,30,3.5,false,1,BaseClasses.GunAppearance(load("res://Sprites/Guns/ak47.bmp"),Vector2(1,-21.3333),Vector2(1,1),null,load("res://SFX/ak-47/Gunshot.mp3"),null,load("res://SFX/ak-47/Pullout.mp3"),load("res://SFX/ak-47/Reload.mp3"))),
}
