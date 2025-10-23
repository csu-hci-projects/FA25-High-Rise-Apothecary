extends Control

@onready var gridContainer = %GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalInventory.inventoryUpdated.connect(_on_inventoryUpdated)
	_on_inventoryUpdated()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_inventoryUpdated(): # update inventory UI
	clearGridContainer()
	for item in GlobalInventory.inventory:
		var slot = GlobalInventory.inventorySlotScene.instantiate()
		gridContainer.add_child(slot)
		if item != null:
			slot.setItem(item)
		else:
			slot.setEmpty()
	GlobalInventory.sortInv2()

func clearGridContainer(): # clear inventory grid
	while gridContainer.get_child_count() > 0:
		var child = gridContainer.get_child(0) # take first child
		gridContainer.remove_child(child) # remove it
		child.queue_free() # unload it
