extends RigidBody2D
## Clase que controla animación y configuración del objeto cañón
##
## Setea la animación del objeto 
## Cambia animación de idle a disparado, elimina la bala de la escena


# Definimos la escena de destrucción del objeto
@onready var _cannon_animation = $AnimatedSprite2D
# Definimos el sprite animado de efectos
@onready var _animated_sprite_effects = $AnimatedSprite2DEffects
# Definimos el sprite del simbolo de interacción
@onready var animated_interaction = $AnimatedInteraction
# Definimos el sprite de apuntado
@onready var animated_aiming = $AnimatedAiming
@onready var aiming_position = $"AnimatedAiming/Node2D"
# Definimos la bala de cañón
var new_ball: RigidBody2D

# Declaración del main character
var main_character

# Called when the node enters the scene tree for the first time.
func _ready():
	# Disparamos
	fire()
		
func fire():
	# Reproducimos la animación de disparo
	var verification = true if Input.is_action_pressed("hit") && character_in_area else false
	if(direction.x < 0 || verification):
		_cannon_animation.play("fire")

var direction = Vector2(1,0)
# Función que calcula el vector dirección entre dos puntos
func get_direction(point_a: Vector2, point_b: Vector2) -> Vector2:
	return point_a - point_b

func _on_animated_sprite_2d_frame_changed():
	# Validamos si el frame de animación es 3
	if _cannon_animation.frame == 3:
		# Inicializar la referencia al character
		main_character = get_node_or_null("../MainCharacter")
		# Según la escena se cambia el path de la referencia 
		if(main_character == null):
			main_character = get_node("../../MainCharacter")
		
		# Obtener el vector dirección entre el character y la bala de cañón
		direction = get_direction(main_character.position, self.position)
		# Cargamos la escena de bala
		var ball = "scenes/game/levels/objects/damage_object/cannon/cannon_ball.tscn"
		new_ball = load(ball).instantiate()
		new_ball.position.x = -20
		
		# Aplicar impulso a la bala de cañón
		# //El valor de multiplicación afecta la velocidad
		new_ball.apply_impulse(direction.normalized() * 500)
		if(impulse != 0):
			direction = get_direction(aiming_position.global_position, self.global_position)
			new_ball.apply_impulse(direction.normalized() * (impulse*200))
		impulse = 0
		
		# Agregamos la bala a la escena
		self.add_child(new_ball)
		# Agregamos la animación de humo
		_animated_sprite_effects.play("fire_effect")


func _on_animated_sprite_2d_animation_finished():
	# Validamos si la animación es de fuego
	if _cannon_animation.get_animation() == 'fire':
		# Esperamos un segundo
		await get_tree().create_timer(1).timeout
		# Eliminamos la bala
		if(new_ball != null):
			new_ball.queue_free()
		# Disparamos otra vez
		fire()


# Control de interacción con el cañón
var character_in_area = false
	# Gravedad agregada a la bala 
var impulse = 0
func _on_area_2d_body_entered(body):
	if(body.is_in_group("player")):
		character_in_area = true
		animated_interaction.play("in")
		animated_interaction.play("active")

func _on_area_2d_body_exited(body):
	if(body.is_in_group("player")):
		character_in_area = false
		animated_interaction.play("out")
		animated_interaction.play("inactive")

func _input(event):
	if event.is_action_pressed("ui_interact") && character_in_area:
		animated_aiming.play("charging")
		
	if event.is_action_pressed("hit"):
		impulse = animated_aiming.frame
		fire()

func _process(delta):
	if Input.is_action_pressed("up"):
		if animated_aiming.rotation_degrees < 45:
			animated_aiming.rotation_degrees += 50 * delta
	if Input.is_action_pressed("down"):
		if animated_aiming.rotation_degrees > -45:
			animated_aiming.rotation_degrees -= 50 * delta
