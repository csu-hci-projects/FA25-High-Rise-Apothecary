extends Control

@onready var icon = $InnerBorder/ItemIcon
@onready var quantityLabel = $InnerBorder/ItemQuantity
@onready var detailsPanel = $DetailsPanel
@onready var itemName = $DetailsPanel/ItemName
@onready var itemType = $DetailsPanel/ItemType
@onready var itemEffect = $DetailsPanel/ItemEffect
@onready var usagePanel = $UsagePanel
@onready var useButton = $UsagePanel/UseButton

var currentItem = null # currently held item

var shader = load("res://Assets/Shaders/outline.gdshader")
var shaderMaterial = ShaderMaterial.new()
var outlineColor: Color

signal pointsUpdated

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalInventory.pointsUpdated.connect(pointsUpdated.emit)
	pointsUpdated.connect(_on_pointsUpdated)
	
	shaderMaterial.shader = shader
	icon.material = shaderMaterial.duplicate(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _get_minimum_size() -> Vector2:
	return Vector2(0, size.x)

func _on_item_button_pressed() -> void:
	if currentItem != null:
		var iType = currentItem.itemType if currentItem is InventoryItem else currentItem["type"]
		if iType == "Potion" and Globals.openUI == "shop inv": 
			useButton.text = "Sell"
		elif iType.contains("Ingredient") and Globals.openUI == "pot inv":
			useButton.text = "Add"
		elif iType.contains("Seedling") and Globals.openUI == "planter inv":
			useButton.text = "Plant"
		elif iType == "Ingredient" and Globals.openUI == "station inv":
			useButton.text = "Choose"
		else:
			useButton.text = "Cannot use"
		usagePanel.visible = !usagePanel.visible
		detailsPanel.visible = !detailsPanel.visible

func _on_item_button_mouse_entered() -> void:
	Globals.setGroupVisibility("InventoryPanels", false)
	if currentItem != null:
		usagePanel.visible = false
		detailsPanel.visible = true

func _on_item_button_mouse_exited() -> void:
	detailsPanel.visible = false

func setEmpty():
	icon.texture = null
	quantityLabel.text = ""

func setItem(newItem):
	currentItem = newItem
	if newItem is InventoryItem:
		icon.texture = newItem.itemTexture
		quantityLabel.text = str(newItem.itemQuantity)
		itemName.text = str(newItem.itemName)
		itemType.text = str(newItem.itemType)
		if str(newItem.itemType).contains("Ingredient"):
			itemEffect.text = assignEffect(newItem.pointTotals)
		else:
			itemEffect.text = str(newItem.itemEffect)
			itemEffect.set_autowrap_mode(TextServer.AUTOWRAP_WORD)
		if str(newItem.itemType) == "Prepared Ingredient":
			if not outlineColor:
				outlineColor = Color(GlobalInventory.shaderColor)
			setShader(true, outlineColor)
	else:
		icon.texture = load(newItem["texturePath"])
		quantityLabel.text = str(newItem["quantity"])
		itemName.text = str(newItem["name"])
		itemType.text = str(newItem["type"])
		if str(newItem["type"]).contains("Ingredient"):
			itemEffect.text = assignEffect(newItem["pointTotals"])
		else:
			itemEffect.text = str(newItem["effect"])
			itemEffect.set_autowrap_mode(TextServer.AUTOWRAP_WORD)

func _on_use_button_pressed() -> void:
	usagePanel.visible = false
	if currentItem != null:
		var iType = currentItem.itemType if currentItem is InventoryItem else currentItem["type"]
		if Globals.openUI == "shop inv" and iType == "Potion": #TODO ADD FUNCTIONALITY FOR SHOPS
			GlobalInventory.removeItem(currentItem["name"], currentItem["type"])
		elif Globals.openUI == "pot inv" and iType.contains("Ingredient"):
			GlobalInventory.itemSent.emit(currentItem)
		elif Globals.openUI == "planter inv" and iType.contains("Seedling"):
			GlobalInventory.itemSent.emit(currentItem)
		elif Globals.openUI == "station inv" and iType == "Ingredient":
			GlobalInventory.itemSent.emit(currentItem)

func assignEffect(pointTotals):
	var effect = ""
	effect += "Water: " + str(pointTotals[0]) + ", "
	effect += "Earth: " + str(pointTotals[1]) + ", "
	effect += "Fire: " + str(pointTotals[2]) + ", \n"
	effect += "Air: " + str(pointTotals[3]) + ", "
	effect += "Light: " + str(pointTotals[4]) + ", "
	effect += "Dark: " + str(pointTotals[5]) + ", \n"
	effect += "Mind: " + str(pointTotals[6]) + ", "
	effect += "Body: " + str(pointTotals[7]) + ", "
	effect += "Spirit: " + str(pointTotals[8])
	return effect

func _on_pointsUpdated():
	if currentItem != null:
		itemEffect.text = assignEffect(currentItem.pointTotals)

func setShader(state: bool, color: Color):
	self.icon.material.set_shader_parameter("active", state)
	self.icon.material.set_shader_parameter("line_color", color)
	self.icon.material.set_shader_parameter("line_thickness", 1)
