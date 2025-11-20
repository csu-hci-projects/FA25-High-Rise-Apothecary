extends Node

@onready var openUI = "none"

func setGroupVisibility(groupName: String, visible: bool):
	var nodesInGroup = get_tree().get_nodes_in_group(groupName)
	for node in nodesInGroup:
		if visible:
			node.show()
		else:
			node.hide()

func changeUI(UI):
	match UI:
		"inv":
			if openUI == "none": #if no UI is open
				openUI = "inv"
			elif openUI == "inv": #if inventory UI is open
				openUI = "none"
			elif openUI == "shop": #if shop UI is open
				openUI = "shop inv"
			elif openUI == "shop inv": #if shop and inventory UI is open
				openUI = "shop"
			elif openUI == "pot": #if pot UI is open
				openUI = "pot inv"
			elif openUI == "pot inv": #if pot and inventroy UI is open
				openUI = "pot"
			elif openUI == "planter": #if planter UI is open
				openUI = "planter inv"
			elif openUI == "planter inv": #if planter and inventory UI is open
				openUI = "planter"
		"shop":
			if openUI == "none":
				openUI = "shop"
			elif openUI == "shop":
				openUI = "none"
		"pot":
			if openUI == "none":
				openUI = "pot"
			elif openUI == "pot":
				openUI = "none"
		"planter":
			if openUI == "none":
				openUI = "planter"
			elif openUI == "planter":
				openUI = "none"
	print("Current UI = ", openUI)
