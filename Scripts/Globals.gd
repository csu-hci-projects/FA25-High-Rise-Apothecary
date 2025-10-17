extends Node

@onready var openUI = "none"

func setGroupVisibility(groupName: String, visible: bool):
	var nodesInGroup = get_tree().get_nodes_in_group(groupName)
	for node in nodesInGroup:
		if visible:
			node.show()
		else:
			node.hide()
