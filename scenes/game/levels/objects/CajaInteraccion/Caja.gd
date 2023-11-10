extends StaticBody2D

var new_potion: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hitbox_area_entered(area):
	var potion = "scenes/game/levels/objects/red_potion/red_potion.tscn"
	new_potion=load(potion).instantiate()
	if area.name == "AreaSword" : 
		$anima.play("destruida")
		await $anima.animation_finished					
		new_potion.position.x=0
		add_child(new_potion)
		queue_free()	
		
		


