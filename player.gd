extends Area2D

signal pickup
signal hurt

@export var speed = 350

var direction = Vector2.ZERO
var screen = Vector2(480, 720)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += direction * speed * delta
	position.x = clamp(position.x, 0, screen.x)
	position.y = clamp(position.y, 0, screen.y)
	if direction.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
	if direction.x != 0:
		$AnimatedSprite2D.flip_h = direction.x < 0

func start():
	set_process(true)
	position = screen / 2
	$AnimatedSprite2D.animation = "idle"

func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)

# When coin/obstacle collides with player, do this
func _on_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerup")
	if area.is_in_group("mobs"):
		hurt.emit()
		die()
