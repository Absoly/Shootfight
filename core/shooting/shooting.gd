extends Node2D

@export var projectile : PackedScene
@export var power : float = 30.0
@export var power_torque : float = 0.0
@export var reload_time : float = 1.1
@export var damage : float = 40.0
@export var range : float = 4000.0
@export var aim_rate : float = 1000.0
@export var recoil : float = 0.1
@export var bullet_life_time : float = 0.2

var is_loaded = true
var reloading_progress = 0.0

signal hand_shake(offset, torque)
signal action_success()


func action(who_shot):
	if not $Barrel.has_overlapping_bodies() and is_loaded:
		var proj = projectile.instantiate()
		get_tree().root.add_child(proj)
		proj.who_shot = who_shot
		proj.global_transform = $Muzzle.global_transform
		proj.push(Vector2(power, 0), power_torque)
		proj.damage = damage
		proj.life_time = bullet_life_time
		is_loaded = false
		hand_shake.emit(Vector2(randf() * recoil, randf() * recoil), randf() * recoil)
		action_success.emit()


func _process(delta):
	if not is_loaded:
		reloading_progress += delta
		if reloading_progress > reload_time:
			reloading_progress = 0.0
			is_loaded = true
