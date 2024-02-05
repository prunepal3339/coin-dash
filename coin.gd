extends Area2D

var screen = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(randf_range(3, 8))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pickup():
	$CollisionShape2D.set_deferred("disabled", true)
	
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", scale * 3, 0.3)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	await tween.finished
	
	queue_free() # remove this node

func _on_timer_timeout():
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play()
	

func _on_area_entered(area):
	if area.is_in_group("mobs") or area.is_in_group("coins"):
		position = Vector2(randi_range(0, screen.x), randi_range(0, screen.y))
