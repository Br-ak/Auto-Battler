extends Area2D
const WEAPON_NAME = "staff"

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var animSprite = $Marker2D/AnimatedSprite2D
@onready var animPlayer = $Marker2D/AnimatedSprite2D/AnimationPlayer
@onready var hitbox = $Marker2D/AnimatedSprite2D/hitbox/CollisionShape2D
@onready var timer = $Timer
@onready var timer_2 = $Timer2
@onready var marker_2d = $Marker2D
@onready var shooting_point = %ShootingPoint
@onready var area_2d = $"."


var mousePosition : Vector2
var can_attack = true
var baseDamage = 5
var currentDamage = baseDamage
var local_mouse_position : Vector2
var adjusted_mouse_position : Vector2
var attack_speed_mod = 1
var attack_over = false
var charging = true
var button_released = false
const projectile = preload("res://tscn/staff-projectile.tscn")
var primary_attack
var secondary_attack
func _ready():
	init_attacks()
	hitbox.disabled = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.time_scale == 1:
		getMousePosition()
		if Input.is_action_just_released("attack_secondary"):
			button_released = true

func getMousePosition():
	mousePosition = get_global_mouse_position()
	
	if mousePosition.x > player.position.x: ##### looking right
		marker_2d.scale.x = 1
		look_at(mousePosition)
	elif mousePosition.x < player.position.x: ##### looking left
		# adjusted mouse position should return inverted mousePosition
		# coupled with the marker's x value being inverted it should mirror any animation in the animation player
		# no need to created 2 animations for each attack
		local_mouse_position = (mousePosition - global_position)
		adjusted_mouse_position = global_position - local_mouse_position
		marker_2d.scale.x = -1
		look_at(adjusted_mouse_position)

func attack():
	if can_attack:
		can_attack = false
		hitbox.disabled = false
		animPlayer.play("primary_attack")
		await animPlayer.animation_finished
		hitbox.disabled = true
		timer.start(animPlayer.get_animation("primary_attack").length * attack_speed_mod)

func attack_secondary():
	attack_over = false
	if can_attack and not animPlayer.is_playing():
		button_released = false
		can_attack = false
		animPlayer.play("secondary_attack")
		await animPlayer.animation_finished
		animPlayer.play("secondary_attack_charge")
		await animPlayer.current_animation_length
		timer_2.start(0.1)

func attack_secondary_fire():
	var attack = Attack.new()
	#pass attack variables
	SharedFunctions.fork_projectile(projectile, get_tree().root, shooting_point, get_global_mouse_position(), 3, 10.0)
	animSprite.set_visible(false)
	timer.start(animPlayer.get_animation("secondary_attack").length * attack_speed_mod)

func _on_hitbox_area_entered(area):
	if area is HitboxComponent:
		if area.get_parent().type == "Enemy":
			var newHitbox : HitboxComponent = area
			var newAttack = primary_attack
			newHitbox.damage(newAttack)

func _on_timer_timeout():
	if !animSprite.is_visible():
		animPlayer.play_backwards("Idle")
		animSprite.set_visible(true)
		animPlayer.play_backwards("Idle")
	timer.stop()
	can_attack = true

func _on_timer_2_timeout():
	if button_released && animPlayer.current_animation == "secondary_attack_charge":
		animPlayer.stop()
		attack_secondary_fire()
		button_released = false
		timer.start(animPlayer.get_animation("secondary_attack").length * attack_speed_mod)
	else:
		timer_2.start(0.1)

func init_attacks():
	var returned_info = SharedFunctions.init_attacks(WEAPON_NAME)
	print(returned_info)
	if returned_info[0] is String: print("No attacks found")
	elif returned_info.size() == 1: # 1 atttack found
		primary_attack = returned_info[0]
	elif returned_info.size() == 2: # 2 atttacks found
		primary_attack = returned_info[0]
		secondary_attack = returned_info[1]
