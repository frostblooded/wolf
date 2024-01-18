extends CanvasLayer

@export var game_win_label: String = "You WIN the game!"
@export var game_win_color: Color = Color.YELLOW

@export var round_win_label: String = "Round WIN!"
@export var round_win_color: Color = Color.GREEN

@export var round_loss_label: String = "Round LOSS!"
@export var round_loss_color: Color = Color.RED

@onready var round_result_label: Label = find_child("RoundResultLabel")
@onready var win_streak_reminder_label: Label = find_child("WinStreakReminderLabel")
@onready var bless_results_container: Control = find_child("BlessResultsContainer")

func _ready():
    MessageBus.ROUND_END.connect(on_round_end)
    hide()

func on_round_end():
    hide()
    bless_results_container.clear()

func show_bless_results(unit: Unit, bless_strength: float, total_strength: int, won: bool, is_game_end: bool, win_streak: int):
    win_streak_reminder_label.text = "Win 3 times in a row to win the game (%d/3)" % win_streak

    if is_game_end:
        round_result_label.text = game_win_label
        round_result_label.add_theme_color_override("font_color", game_win_color)
        win_streak_reminder_label.hide()
    elif won:
        round_result_label.text = round_win_label
        round_result_label.add_theme_color_override("font_color", round_win_color)
    else:
        round_result_label.text = round_loss_label
        round_result_label.add_theme_color_override("font_color", round_loss_color)
    
    bless_results_container.show_bless_results(unit, bless_strength, total_strength, is_game_end)
    show()