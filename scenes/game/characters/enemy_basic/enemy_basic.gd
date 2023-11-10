extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var character_in_range = false

func _on_area_2d_body_entered(body):
	if(body.is_in_group("player")):
		character_in_range = true

func _on_area_2d_body_exited(body):
	if(body.is_in_group("player")):
		character_in_range = false
	
func _input(event):
	if event.is_action_pressed("hit") && character_in_range:
		self.queue_free()
