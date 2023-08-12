extends PanelContainer

@export var weapons : Array[PackedScene]

@onready var list = $MarginContainer/VBox/List

var selected_weapon


func _ready():
	for weapon in weapons:
		list.add_item(weapon.resource_path) 


func _on_list_item_selected(index):
	selected_weapon = index


func _on_list_item_activated(index):
	if selected_weapon != null:
		var weapon = weapons[selected_weapon].instantiate()
		var characters = get_tree().get_nodes_in_group("Character")
		if characters.size():
			characters[0].pick_weapon(weapon)
		visible = false
		list.deselect_all()
		selected_weapon = null
