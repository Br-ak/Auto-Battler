extends Area2D
class_name HitboxComponent

@export var health_component : HealthComponent
@onready var hitbox = $CollisionShape2D
#This collision shape is used only for damage/hit detection

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)

func death(attack: Attack):
	hitbox.set_deferred("disabled", true)
