extends Node

var BasicComponents = load("res://Levels/Basic Components.tscn")
var Instance = BasicComponents.instantiate()
var children = Instance.get_children()

func main(scenenode):
	for i in children:
		var node = i.duplicate(15)
		scenenode.add_child(node)
