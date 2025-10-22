extends Control

@onready var icon = $InnerBorder/ItemIcon
@onready var quantityLabel = $InnerBorder/ItemQuantity
@onready var detailsPanel = $DetailsPanel
@onready var itemName = $DetailsPanel/ItemName
@onready var itemType = $DetailsPanel/ItemType
@onready var itemEffect = $DetailsPanel/ItemEffect
@onready var usagePanel = $UsagePanel

var currentItem = null # currently held item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _get_minimum_size() -> Vector2:
	return Vector2(0, size.x)

func _on_item_button_pressed() -> void:
	if currentItem != null and currentItem["type"] == "Potion": #and Globals.openUI == "shop"
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
	icon.texture = newItem["texture"]
	quantityLabel.text = str(newItem["quantity"])
	itemName.text = str(newItem["name"])
	itemType.text = str(newItem["type"])
	itemEffect.text = str(newItem["effect"])

func _on_use_button_pressed() -> void:
	usagePanel.visible = false
	if currentItem != null: #TODO ADD FUNCTIONALITY FOR SHOPS
		GlobalInventory.removeItem(currentItem["name"], currentItem["type"])
		pass
