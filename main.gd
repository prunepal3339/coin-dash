extends Node2D

@export var coin_scene : PackedScene
@export var powerup_scene: PackedScene
@export var mob_scene: PackedScene
@export var playtime = 30

var level = 1
var score = 0
var time_left = 0
var screen = Vector2.ZERO
var playing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body
	screen = get_viewport().get_visible_rect().size - Vector2(10, 10)
	$Player.screen = screen
	$Player.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		clear_grouped_entity("mobs")
		$PowerupTimer.start()
		spawn_coins()
		spawn_mobs()

func clear_grouped_entity(group):
	get_tree().call_group(group, "queue_free")

func start_new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)

func spawn_mobs():
	for i in level + 1:
		var m = mob_scene.instantiate()
		add_child(m)
		m.screen = screen
		m.position = Vector2(randi_range(0, screen.x), randi_range(0, screen.y))

func spawn_coins():
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screen = screen
		c.position = Vector2(randi_range(0, screen.x), randi_range(0, screen.y))
	$LevelSound.play()

func _on_game_timer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

func _on_player_hurt():
	game_over()

func _on_player_pickup(type):
	match type:
		"coin":
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$PowerSound.play()
			time_left += 5
			$HUD.update_timer(time_left)

func game_over():
	playing = false
	$GameTimer.stop()
	clear_grouped_entity("coins")
	$HUD.show_game_over()
	$Player.die()
	$EndSound.play()

func _on_hud_start_game():
	start_new_game()

func _on_powerup_timer_timeout():
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screen = screen
	p.position = Vector2(randi_range(0, screen.x), randi_range(0, screen.y))
