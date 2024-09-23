extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display7

#@Pre item must to be an Inventory Item InvItem
func update(item: InvItem):
	# if there is no item, then item_visual is not visible because there is no item to show
	if !item:
		item_visual.visible = false
	# else if there is an item, set visible to true
	# and set it to the corresponding texture
	else:
		item_visual.visible = true
		item_visual.texture = item.texture
		
