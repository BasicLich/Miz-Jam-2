extends Control
onready var jumpgame = get_node("ViewportContainer1/Viewport/JumpGame")
onready var squidgame = get_node("ViewportContainer2/Viewport/SquidGame")
onready var dodgegame = get_node("ViewportContainer3/Viewport/DodgeGame")
onready var truckgame = get_node("ViewportContainer4/Viewport/TruckGame")
onready var games = [jumpgame, squidgame, truckgame, dodgegame]
var starttime = OS.get_ticks_msec()
var currentScore = 0
var game_paused = false

func _ready():
	get_tree().paused = true
	Physics2DServer.set_active(true)
	game_paused = false
	restart()

func loose():
	game_paused = true
	for game in games:
		game.setPaused(true)
	$GameOver.visible = true
	$GameOver/VBoxContainer/YourScore.text = "Score: "+str(currentScore)
	if currentScore > HighScore.highscore:
		HighScore.highscore = currentScore
	$GameOver/VBoxContainer/Highscore.text = "Highscore: "+str(HighScore.highscore)
	

func restart():
	for game in games:
		game.setPaused(true)
	jumpgame.setPaused(false)
	starttime = OS.get_ticks_msec()
	currentScore = 0
	game_paused = false

func _process(_delta):
	if !game_paused:
		currentScore = OS.get_ticks_msec()-starttime
		if currentScore >= 15000 && squidgame.paused:
			squidgame.setPaused(false)
			$AnimationPlayer.play("SquidGame")
		if currentScore >= 30000 && dodgegame.paused:
			dodgegame.setPaused(false)
			$AnimationPlayer.play("DodgeGame")
		if currentScore >= 45000 && truckgame.paused:
			truckgame.setPaused(false)
			$AnimationPlayer.play("TruckGame")
		$ScoreLabel.text = str(currentScore)
	
	if(game_paused && Input.is_action_just_pressed('restart')):
		get_tree().reload_current_scene()
		restart()
