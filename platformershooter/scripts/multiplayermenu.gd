extends Node2D


var peer =  ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
@onready var menu = $CanvasLayer/PanelContainer/HBoxContainer/VBoxContainer

#---boolet---#
const bullet_scene = preload("res://scenes/bullet.tscn")
#@onready var bullet_parent = $"/root/Multiplayermenu/BulletParent"

func _on_host_pressed():
	menu.hide()
	peer.create_server(8120)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player(multiplayer.get_unique_id())


func add_player(id):
	var player = player_scene.instantiate()
	player.name = str(id)
	add_child(player)

func _on_join_pressed():
	menu.hide()
	peer.create_client("localhost",8120)
	multiplayer.multiplayer_peer = peer


func _on_button_pressed():
	menu.show()
	

@rpc("any_peer", "call_local", "reliable")
func create_bullet(bullet_position, bullet_direction):
	var bullet = bullet_scene.instantiate()
	bullet.direction = bullet_direction
	bullet.position = bullet_position
	
	#bullet_parent.add_child(bullet)
	add_child(bullet)
