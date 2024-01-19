extends VBoxContainer

@export var game_end_button_text: String = "Finish game"
@export var fact_ui_scene: PackedScene = null
@export var unit_type_ui_scene: PackedScene = null

@onready var next_round_button: Button = find_child("NextRoundButton")
@onready var round_result_label: Label = find_child("RoundResultLabel")

var is_game_end: bool = false

func clear():
    clear_container($OtherBlessResultsContainer/GeneralResultsContainer)
    clear_container($OtherBlessResultsContainer/FactsResultsContainer)

func clear_container(container: Control):
    var results_container: Control = container.get_node("Results")

    for n in results_container.get_children():
        results_container.remove_child(n)

func show_bless_results(unit: Unit, bless_strength: int, total_strength: float, game_end: bool):
    self.is_game_end = game_end

    if self.is_game_end:
        next_round_button.text = game_end_button_text

    append_bless_result_label("Blessing: %d" % bless_strength)
    append_unit_type_ui_label(unit.type, ": %.2f" % unit.type.multiplier)

    for t in unit.facts:
        if t.value != 0:
            append_fact_result_label(t, ": %d" % t.value)

    $TotalStrengthLabel.text = "Final strength: %.2f (goal is %d to %d)" % [total_strength, DifficultyManager.get_min_goal(), 100]

func append_unit_type_ui_label(unit_type: UnitType, message: String):
    var unit_type_ui: UnitTypeUI = unit_type_ui_scene.instantiate()
    unit_type_ui.initialize_with_additional_text(unit_type, message)
    $OtherBlessResultsContainer/GeneralResultsContainer.get_node("Results").add_child(unit_type_ui)

func append_fact_result_label(fact: Fact, message: String):
    var fact_ui: FactUI = fact_ui_scene.instantiate()
    fact_ui.initialize_with_additional_text(fact, message)
    $OtherBlessResultsContainer/FactsResultsContainer.get_node("Results").add_child(fact_ui)

func append_bless_result_label(message: String):
    var new_label: Label = Label.new()
    new_label.text = message
    $OtherBlessResultsContainer/GeneralResultsContainer.get_node("Results").add_child(new_label)

func _on_next_unit_button_pressed():
    if is_game_end:
        MessageBus.GAME_END.emit()
    else:
        MessageBus.ROUND_END.emit()
