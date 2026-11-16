extends Node

export(PackedScene) var mob_scene
var score


func _ready():
	randomize()


func _unhandled_input(event):
	# Amb Esc es torna al menú principal.
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://Menu.tscn")


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score("Zen" if Settings.zen else score)
	$HUD.show_message("Get Ready")
	$Music.play()


func _on_ScoreTimer_timeout():
	if Settings.zen:
		return # Mode Zen: sense puntuació.
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	# La dificultat canvia cada quant apareixen els Creeps.
	$MobTimer.wait_time = Settings.mob_spawn_time()
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
	var velocity = Vector2(rand_range(150.0, 250.0) * Settings.mob_speed_multiplier(), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Afegeix el mob a l'escena principal.
	add_child(mob)
