extends Node

var level1 = preload("res://levels/level.tscn")
var pause_menu_screen = preload("res://ui/PauseMenu.tscn")
var main_menu_screen = preload("res://ui/MainMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.44,0.12,0.15,1.00))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func start_game():
	if get_tree().paused:
		continue_game()
		return
	transition_to_scene(level1.resource_path)
	
func exit_game():
	get_tree().quit();
	
func pause_game():
	get_tree().paused = true
	var pause_menu_screen_instance = pause_menu_screen.instantiate()
	get_tree().get_root().add_child(pause_menu_screen_instance)
	
func continue_game():
	get_tree().paused = false
	
func main_menu():
	var main_menu_screen_instance = main_menu_screen.instantiate()
	get_tree().get_root().add_child(main_menu_screen_instance)
	
func transition_to_scene(path):
	await get_tree().create_timer(.5).timeout
	get_tree().change_scene_to_file(path)
