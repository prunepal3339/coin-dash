extends Area2D

var screen = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_lifetime_timeout():
	queue_free()
	
func pickup():
	$CollisionShape2D.set_deferred("disabled", true)
	
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", scale * 3, 0.3)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	await tween.finished
	
	queue_free()



func _on_area_entered(area):
	if area.is_in_group("mobs"):
		position = Vector2(randi_range(0, screen.x), randi_range(0, screen.y))
