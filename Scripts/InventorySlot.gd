extends Control

@onready var icon = $InnerBorder/ItemIcon
@onready var quantityLabel = $InnerBorder/ItemQuantity
@onready var detailsPanel = $DetailsPanel
@onready var itemName = $DetailsPanel/ItemName
@onready var itemType = $DetailsPanel/ItemType
@onready var itemEffect = $DetailsPanel/ItemEffect
@onready var usagePanel = $UsagePanel

var item = null # currently held item
var inContainer = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _get_minimum_size() -> Vector2:
	return Vector2(0, size.x)

func _on_item_button_pressed() -> void:
	if item != null:
		usagePanel.visible = !usagePanel.visible
		detailsPanel.visible = !detailsPanel.visible

func _on_item_button_mouse_entered() -> void:
	Globals.setGroupVisibility("InventoryPanels", false)
	if item != null:
		usagePanel.visible = false
		detailsPanel.visible = true

func _on_item_button_mouse_exited() -> void:
	detailsPanel.visible = false

func setEmpty():
	icon.texture = null
	quantityLabel.text = ""

func setItem(newItem):
	item = newItem
	icon.texture = newItem["texture"]
	quantityLabel.text = str(item["quantity"])
	itemName.text = str(item["name"])
	itemType.text = str(item["type"])
	itemEffect.text = str(item["effect"])
