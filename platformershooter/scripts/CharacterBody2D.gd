extends CharacterBody2D
var health = 10
@onready var cooldown = %Cooldown
var canshoot = true
func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

@onready var camera = %Camera2D
const SPEED = 330.0
const JUMP_VELOCITY = -400.0
#@onready var main = $"."
@onready var maingame = get_node("/root/main")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if not is_multiplayer_authority(): camera.enabled = false
	if is_multiplayer_authority(): 
		if Input.is_action_pressed("use_shoot") && canshoot == true:
			rpc("shoot")
			canshoot = false
			cooldown.start()
			
		
	#if not is_multiplayer_authority(): return
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if is_multiplayer_authority(): 
		if Input.is_action_pressed("i_up") and is_on_floor():
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("i_left", "i_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
					
func take_damage(amount):
	print("YOUCH")
	print("YOUCH")
	health -= amount
	if health <= 0:
		queue_free()
		
@rpc("authority", "call_local", "reliable")
func shoot():
	if is_multiplayer_authority():
		var mouse_pos = get_viewport().get_mouse_position()
		var shoot_direction = (mouse_pos - position).normalized()
		maingame.create_bullet.rpc(position, shoot_direction)



func _on_area_2d_body_entered(body):
	if body.is_in_group("Arbullet"):
		queue_free()


func _on_cooldown_timeout():
	canshoot = true
