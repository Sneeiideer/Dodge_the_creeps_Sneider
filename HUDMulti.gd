extends "res://HUD.gd"
# HUD del mode multijugador local.
# Hereta tot el HUD normal (missatges, botó Start, senyal start_game)
# i afegeix dues puntuacions independents i la pantalla de guanyador.


func update_scores(score1, score2):
	$ScoreLabel1.text = "P1: " + str(score1)
	$ScoreLabel2.text = "P2: " + str(score2)


func show_winner(text):
	# Mostra qui ha guanyat el duel durant 3 segons.
	$Message.text = text
	$Message.show()
	yield(get_tree().create_timer(3), "timeout")

	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
