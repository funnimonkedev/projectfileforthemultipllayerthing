extends Area2D

@onready var sprite2d = $Sprite2D
@onready var deathtimer = %deathtimer
var speed = -560
var direction = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite2d.show()
	deathtimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta


#func _on_body_entered(body):
	#if not body.is_in_group("player"):
		#if is_multiplayer_authority():
			#queue_free()


func _on_deathtimer_timeout():
	sprite2d.hide()
	queue_free()
