extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $PlayerSprite
@onready var bullet_scene = preload("res://Projectiles/bullet.tscn")
@onready var weapon = $Weapon
@onready var ammo_counter = $AmmoCount
@onready var jump_audio: AudioStreamPlayer2D = $JumpAudio

const SPEED = 300.0
const GRAVITY = 1000.0
const JUMP = -400.0

enum state {idle, run, jump, shoot}
var current_state : state

var player_direction = 1
var jump_ctr = 0
#func _ready():


func _physics_process(delta : float):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	player_shoot(delta)
	player_reload(delta)
	if weapon.current_weapon_state != weapon.weapon_states.reloading :
		ammo_counter.update_text(str(weapon.bullets_remaining))
	elif weapon.current_weapon_state == weapon.weapon_states.reloading :
		ammo_counter.reload_animation()
	
	move_and_slide()
	player_animations()


func player_shoot(delta):
	if Input.is_action_just_pressed("shoot"):
		current_state = state.shoot
		var muzzle_position = $Muzzle.position;
		#print("is shooting")
		if player_direction > 0:
			weapon.muzzle_position = global_position + muzzle_position;
			weapon.muzzle_direction = Vector2.RIGHT
		else:
			weapon.muzzle_position.y = global_position.y + muzzle_position.y;
			weapon.muzzle_position.x = global_position.x - muzzle_position.x;
			weapon.muzzle_direction = Vector2.LEFT;
		weapon.fire()
		
func player_reload(delta):
	if Input.is_action_just_pressed("reload"):
		weapon.reload()

func player_falling(delta : float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta


func player_idle(delta : float):
	if is_on_floor():
		current_state = state.idle


func player_run(delta : float):
	var direction = input_movment()
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction != 0:
		current_state = state.run
		animated_sprite_2d.flip_h = direction < 0
		

func player_jump(delta : float):
	
	if Input.is_action_just_pressed("jump") && jump_ctr == 0:
		jump_audio.play()
		jump_ctr+=1
		velocity.y = JUMP
		current_state = state.jump
		
	if is_on_floor() and current_state != state.jump:
		jump_ctr = 0;
		
	if !is_on_floor() and current_state == state.jump:
		var direction = input_movment()
		velocity.x += direction * 100 * delta


func player_animations():
	if current_state == state.idle:
		animated_sprite_2d.play("idle")
	elif current_state == state.run:
		animated_sprite_2d.play("run")
		

func input_movment():
	var direction : float = Input.get_axis("move_left","move_right")
	if direction != 0:
		player_direction = direction
	return direction
