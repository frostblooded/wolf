extends VBoxContainer

@export var game_end_button_text: String = "Finish game"

@onready var next_round_button: Button = find_child("NextRoundButton")
@onready var round_result_label: Label = find_child("RoundResultLabel")

var is_game_end: bool = false

func clear():
    clear_container($OtherBlessResultsContainer/GeneralResultsContainer)
    clear_container($OtherBlessResultsContainer/MultiplicationResultsContainer)
    clear_container($OtherBlessResultsContainer/AdditionResultsContainer)

func clear_container(container: Control):
    var results_container: Control = container.get_node("Results")

    for n in results_container.get_children():
        results_container.remove_child(n)

func show_bless_results(unit: Unit, bless_strength: int, total_strength: float, game_end: bool):
    self.is_game_end = game_end

    if self.is_game_end:
        next_round_button.text = game_end_button_text

    append_bless_result_label("Blessing for %d" % bless_strength)
    append_bless_result_label("Base strength %d" % unit.strength)

    var multiplier: float = 1
    var has_multipliers: bool = false

    for t in unit.positive_traits:
        if !is_equal_approx(t.mul_modifier, 1.0):
            multiplier *= t.mul_modifier
            append_mul_bless_result_label("%s: x%.2f" % [t.name, t.mul_modifier])
            has_multipliers = true

    for t in unit.negative_traits:
        if !is_equal_approx(t.mul_modifier, 1.0):
            multiplier *= t.mul_modifier
            append_mul_bless_result_label("%s: x%.2f" % [t.name, t.mul_modifier])
            has_multipliers = true

    if !has_multipliers:
        append_mul_bless_result_label("None")

    append_mul_bless_result_label("Total multiplier: x%.2f" % multiplier)
    append_mul_bless_result_label("Addition from multilpiers: %d x %.2f: +%.2f" % [bless_strength, multiplier, bless_strength * multiplier])

    var has_additions: bool = false

    for t in unit.positive_traits:
        if t.add_modifier != 0:
            append_add_bless_result_label("%s: +%d" % [t.name, t.add_modifier])
            has_additions = true

    for t in unit.negative_traits:
        if t.add_modifier != 0:
            append_add_bless_result_label("%s: %d" % [t.name, t.add_modifier])
            has_additions = true
    
    if !has_additions:
        append_add_bless_result_label("None")

    $TotalStrengthLabel.text = "Final strength: %.2f (goal is %d to %d)" % [total_strength, DifficultyManager.get_min_goal(), 100]

func append_mul_bless_result_label(message: String):
    var new_label: Label = Label.new()
    new_label.text = message
    $OtherBlessResultsContainer/MultiplicationResultsContainer.get_node("Results").add_child(new_label)

func append_add_bless_result_label(message: String):
    var new_label: Label = Label.new()
    new_label.text = message
    $OtherBlessResultsContainer/AdditionResultsContainer.get_node("Results").add_child(new_label)

func append_bless_result_label(message: String):
    var new_label: Label = Label.new()
    new_label.text = message
    $OtherBlessResultsContainer/GeneralResultsContainer.get_node("Results").add_child(new_label)

func _on_next_unit_button_pressed():
    if is_game_end:
        MessageBus.GAME_END.emit()
    else:
        MessageBus.ROUND_END.emit()
