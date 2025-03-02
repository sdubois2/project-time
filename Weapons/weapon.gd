extends Node2D  
@export var bullet_scene : PackedScene 

#Changed on call
@export var muzzle_position : Vector2 = Vector2(1,1)
@export var muzzle_direction : Vector2 = Vector2.RIGHT
@onready var player = get_parent()
#Change per weapon
@export var fire_rate : float = 0.3  # Time between each shot (in seconds)
@export var reload_time : float = 2; # Reload time (s)

@export var bullet_damage : float = 15
@export var magazine_size : int = 12
@export var bullets_remaining : int = magazine_size;

enum weapon_states {reloading, firing, cooldown, idle}
var current_weapon_state : weapon_states = weapon_states.idle

# Fire function
func fire():
	if current_weapon_state != weapon_states.idle:
		print(current_weapon_state)
		return  # Prevent firing if not in idle state

	if bullets_remaining <= 0:
		print("Out of ammo, reloading!")
		reload()
		return  # Prevent firing with zero bullets

	current_weapon_state = weapon_states.firing

	# Spawn and shoot bullet
	var bullet = bullet_scene.instantiate()
	bullet.position = muzzle_position
	bullet.direction = muzzle_direction
	bullet.damage = bullet_damage
	get_tree().current_scene.add_child(bullet)

	bullets_remaining -= 1
	print("Fired! Bullets left:", bullets_remaining)

	# Cooldown before next shot
	current_weapon_state = weapon_states.cooldown
	await get_tree().create_timer(fire_rate).timeout
	current_weapon_state = weapon_states.idle

# Reload function
func reload():
	if current_weapon_state == weapon_states.reloading or bullets_remaining == magazine_size:
		return  # Prevent unnecessary reloads
	
	print("Reloading...")
	current_weapon_state = weapon_states.reloading
	await get_tree().create_timer(reload_time).timeout
	bullets_remaining = magazine_size
	print("Reload complete!")

	current_weapon_state = weapon_states.idle
