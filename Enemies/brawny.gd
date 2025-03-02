extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

@export var patrol_points : Node
@export var speed : int = 1000
@export var wait_time : int = 2.5

const GRAVITY = 1000.0

enum state {idle, walk, shoot}
var current_state : state

var direction : Vector2 = Vector2.LEFT
var number_of_points : int
var point_positions : Array[Vector2]
var current_point : Vector2
var current_point_possition : int
var can_walk : bool

func _ready():
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in  patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_possition]
	else:
		print("No patrol point")
		
	timer.wait_time = wait_time

func _physics_process(delta : float):
	gravity(delta)
	enemy_idle(delta)
	enemy_walk(delta)
	#player_shoot(delta)
	
	move_and_slide()
	enemy_animations()

@onready var bullet_scene = preload("res://Projectiles/bullet.tscn")

#func player_shoot(delta):
	#if Input.is_action_just_pressed("shoot"):
		#current_state = state.shoot
		#print("is shooting")
		#var bullet = bullet_scene.instantiate()
		#var muzzle_position = $Muzzle.position  # Set bullet spawn position
		#print(muzzle_position)
		#print(global_position)
		#if direction > 0:
			#bullet.position = global_position + muzzle_position;
			#bullet.direction = Vector2.RIGHT
		#else:
			#bullet.position.y = global_position.y + muzzle_position.y;
			#bullet.position.x = global_position.x - muzzle_position.x;
			#bullet.direction = Vector2.LEFT;
		#get_tree().current_scene.add_child(bullet)  # Add bullet to the scene


func gravity(delta : float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta


func enemy_idle(delta : float):
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		current_state = state.idle

func enemy_walk(delta : float):
	if !can_walk:
		return
		
	if abs(position.x -current_point.x) > 0.5:
		velocity.x = direction.x * speed * delta
		current_state = state.walk
	else:
		can_walk = false
		timer.start()
		current_point_possition += 1
		
		if current_point_possition >= number_of_points:
				current_point_possition = 0
		
		current_point = point_positions[current_point_possition]
		
		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
		
	
	animated_sprite_2d.flip_h = direction.x < 0
	
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	#
	#if direction != 0:
		#current_state = state.run
		#animated_sprite_2d.flip_h = direction < 0


func enemy_animations():
	if current_state == state.idle && !can_walk:
		animated_sprite_2d.play("idle")
	elif current_state == state.walk && can_walk:
		animated_sprite_2d.play("walk")
		

#func input_movment():
	#var direction : float = Input.get_axis("move_left","move_right")
	#if direction != 0:
		#player_direction = direction
		#print(player_direction)
	#return direction

func _on_timer_timeout() -> void:
	can_walk = true


func _on_hurt_box_area_entered(area: Area2D) -> void:
	print("area entered")

func _on_hurt_box_body_entered(body: Node2D) -> void:
	print("Son of a bitch that hurt")
