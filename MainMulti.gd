extends Node

export(PackedScene) var mob_scene
var score1 = 0 # Puntuació del jugador 1.
var score2 = 0 # Puntuació del jugador 2.
var alive1 = false # El jugador 1 segueix viu?
var alive2 = false # El jugador 2 segueix viu?


func _ready():
	randomize()


func _unhandled_input(event):
	# Amb Esc es torna al menú principal.
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://Menu.tscn")


func _on_player_hit(player_id):
	# Quan un jugador mor deixa de sumar punts.
	if player_id == 1:
		alive1 = false
	else:
		alive2 = false
	# La partida s'acaba quan han mort els dos jugadors.
	if not alive1 and not alive2:
		game_over()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	# Guanya qui ha resistit més temps (més punts).
	if score1 > score2:
		$HUD.show_winner("Guanya el\nJugador 1!")
	elif score2 > score1:
		$HUD.show_winner("Guanya el\nJugador 2!")
	else:
		$HUD.show_winner("Empat!")
	$Music.stop()
	$DeathSound.play()


func new_game():
	get_tree().call_group("mobs", "queue_free")
	score1 = 0
	score2 = 0
	$Player1.start($StartPosition1.position)
	$Player2.start($StartPosition2.position)
	alive1 = true
	alive2 = true
	$StartTimer.start()
	$HUD.update_scores(score1, score2)
	$HUD.show_message("Get Ready")
	$Music.play()


func _on_ScoreTimer_timeout():
	# Cada jugador suma punts només mentre segueix viu.
	if alive1:
		score1 += 1
	if alive2:
		score2 += 1
	$HUD.update_scores(score1, score2)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_MobTimer_timeout():
	# Crea una nova instància de l'escena Mob.
	var mob = mob_scene.instance()

	# Tria una ubicació aleatòria a Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	# Direcció del mob perpendicular a la direcció del camí.
	var direction = mob_spawn_location.rotation + PI / 2

	# Posició del mob a la ubicació aleatòria.
	mob.position = mob_spawn_location.position

	# Una mica d'aleatorietat a la direcció.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Velocitat del mob.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Afegeix el mob a l'escena principal.
	add_child(mob)
