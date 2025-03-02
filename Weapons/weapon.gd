extends Node2D  # Or any other node type based on your needs

@export var bullet_scene : PackedScene  # A reference to the bullet scene (to be instanced)
@export var fire_rate : float = 0.5  # Time between each shot (in seconds)
@export var muzzle_position : Vector2 = Vector2(1,1)  # Position offset for where the bullets spawn
@export var muzzle_direction : Vector2 = Vector2.RIGHT
var can_fire : bool = true  # A flag to prevent spamming the fire button

@onready var player = get_parent()
# Call this function to fire a bullet
func fire():
	if can_fire:
		can_fire = false  # Prevent firing immediately again
		
		var bullet = bullet_scene.instantiate()  # Create a new bullet instance
		bullet.position = muzzle_position  # Set the bullet's spawn position based on muzzle offset
		bullet.direction = muzzle_direction
		get_tree().current_scene.add_child(bullet)
		
		# Optional: Start a cooldown to prevent immediate firing again
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true
