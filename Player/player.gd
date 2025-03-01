extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const GRAVITY = 1000.0
const JUMP = -400.0

enum state {idle, run, jump}
var current_state

#func _ready():


func _physics_process(delta):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	
	move_and_slide()
	player_animations()


func player_falling(delta):
	if !is_on_floor():
		velocity.y += GRAVITY * delta


func player_idle(delta):
	if is_on_floor():
		current_state = state.idle


func player_run(delta):
	var direction := Input.get_axis("move_left","move_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction != 0:
		current_state = state.run
		animated_sprite_2d.flip_h = false if direction > 0 else true
		

func player_jump(delta):
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP
		current_state = state.jump
		
	if !is_on_floor() and current_state == state.jump:
		var direction := Input.get_axis("move_left","move_right")
		velocity.x += direction * 100 * delta


func player_animations():
	if current_state == state.idle:
		animated_sprite_2d.play("idle")
	elif current_state == state.run:
		animated_sprite_2d.play("run")
		
