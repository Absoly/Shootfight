extends Control

@onready var spawn_weapon = $CenterContainer/SpawnWeapon


func _input(event):
	if event.is_action("spawn_weapon") and event.is_pressed():
		spawn_weapon.visible = !spawn_weapon.visible
