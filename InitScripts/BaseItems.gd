extends Node

"""var GunAppearance = BaseClasses.GunAppearance(load("res://Sprites/Guns/ak47.bmp"),Vector2(1,-21.3333),Vector2(1,1),)
	var Gun = BaseClasses.Gun(GunNode,0.89,140,10000,10,10,0.15,8,10,true,9,GunAppearance)
	var creatureObject = BaseClasses.Creature(null,100,[300000,250000,250000,250000],100,100000,-90,Gun,Vector2(100,0),"Enemies")"""

var Weapons = {
	"punch":BaseClasses.Gun(null,0.33,20,4000,25,0.1,0.15,1,0.33,true,15,null),
	"ak-47":BaseClasses.Gun(null,0.1,34,8000,10000,10,0.15,30,3.5,false,1,BaseClasses.GunAppearance(load("res://Sprites/Guns/ak47.bmp"),Vector2(1,-21.3333),Vector2(1,1),null,load("res://SFX/ak-47/Gunshot.mp3"),null,null,load("res://SFX/glock/Pullout.mp3"))),
}
