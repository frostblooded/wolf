extends CanvasLayer

@export var game_win_label: String = "You WIN the game!"
@export var game_win_color: Color = Color.YELLOW

@export var round_win_label: String = "Round WIN!"
@export var round_win_color: Color = Color.GREEN

@export var round_loss_label: String = "Round LOSS!"
@export var round_loss_color: Color = Color.RED

@onready var regular_round_result_label: Label = find_child("RegularRoundResultLabel")
@onready var anomaly_round_result_label: Label = find_child("AnomalyRoundResultLabel")
@onready var bless_results_container: Control = find_child("BlessResultsContainer")

func _ready():
    MessageBus.ROUND_END.connect(on_round_end)
    hide()

func on_round_end():
    hide()
    bless_results_container.clear()

func show_bless_results(unit: Unit, bless_strength: float, total_strength: float, won: bool, is_game_end: bool):
    if is_game_end:
        regular_round_result_label.text = game_win_label
        regular_round_result_label.add_theme_color_override("font_color", game_win_color)
        anomaly_round_result_label.text = game_win_label
        anomaly_round_result_label.add_theme_color_override("font_color", game_win_color)
    elif won:
        regular_round_result_label.text = round_win_label
        regular_round_result_label.add_theme_color_override("font_color", round_win_color)
        anomaly_round_result_label.text = round_win_label
        anomaly_round_result_label.add_theme_color_override("font_color", round_win_color)
    else:
        regular_round_result_label.text = round_loss_label
        regular_round_result_label.add_theme_color_override("font_color", round_loss_color)
        anomaly_round_result_label.text = round_loss_label
        anomaly_round_result_label.add_theme_color_override("font_color", round_loss_color)
    
    bless_results_container.show_bless_results(unit, bless_strength, total_strength, is_game_end)
    show()
