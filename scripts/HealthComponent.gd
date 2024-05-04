extends Node2D
class_name HealthComponent

@export var animation_component : AnimationComponent
@export var hitbox_component : HitboxComponent
@export var parent : CharacterBody2D
@export var MAX_HEALTH := 10.0
var health : float
var dead = false

func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	health -= attack.attack_damage
	
	if health > 0 && animation_component:
		animation_component.hurt(attack)
	elif health <= 0:
		if dead != true:
			if parent.has_method("death"):
				parent.death()
				dead = true
			if animation_component:
				animation_component.death(attack)
			hitbox_component.death(attack)
