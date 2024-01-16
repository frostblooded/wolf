extends VBoxContainer

@export var game_end_button_text: String = "Finish game"

@onready var next_round_button: Button = find_child("NextRoundButton")
@onready var round_result_label: Label = find_child("RoundResultLabel")

var is_game_end: bool = false

func clear():
    for n in $OtherBlessResultsContainer.get_children():
        $OtherBlessResultsContainer.remove_child(n)

func show_bless_results(unit: Unit, bless_strength: int, total_strength: float, game_end: bool):
    $TotalStrengthLabel.text = "Total strength: %.2f" % total_strength
    self.is_game_end = game_end

    if self.is_game_end:
        next_round_button.text = game_end_button_text

    append_bless_result_label("Blessing for %d" % bless_strength)
    append_bless_result_label("Base strength %d" % unit.strength)

    for t in unit.positive_traits:
        if !is_equal_approx(t.mul_modifier, 1.0):
            append_bless_result_label("%s: x%.2f" % [t.name, t.mul_modifier])

        if t.add_modifier != 0:
            append_bless_result_label("%s: +%d" % [t.name, t.add_modifier])

    for t in unit.negative_traits:
        if !is_equal_approx(t.mul_modifier, 1.0):
            append_bless_result_label("%s: x%.2f" % [t.name, t.mul_modifier])

        if t.add_modifier != 0:
            append_bless_result_label("%s: %d" % [t.name, t.add_modifier])

func append_bless_result_label(message: String):
    var new_label: Label = Label.new()
    new_label.text = message
    $OtherBlessResultsContainer.add_child(new_label)

func _on_next_unit_button_pressed():
    if is_game_end:
        MessageBus.GAME_END.emit()
    else:
        MessageBus.ROUND_END.emit()
