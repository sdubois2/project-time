extends RigidBody2D

@export var speed: float = 700
@export var direction: Vector2 = Vector2.UP
@export var damage = 15

func _ready():
	apply_impulse(direction * speed)


func _on_body_entered(body):
	#print("impact")
	queue_free()  # Destroy the bullet on impact


func _on_bullet_timeout_timeout() -> void:
	queue_free()
