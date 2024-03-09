extends Sprite2D

var mouse = get_global_mouse_position()

func _process(_delta):
	mouse = get_global_mouse_position()
	look_at(mouse)
