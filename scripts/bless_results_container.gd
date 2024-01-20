extends VBoxContainer

@export var game_end_button_text: String = "Finish game"
@export var fact_value_ui_scene: PackedScene = null

@onready var next_round_button: Button = find_child("NextRoundButton")
@onready var round_result_label: Label = find_child("RoundResultLabel")

var is_game_end: bool = false

func clear():
    for n in $FactsContainer.get_children():
        $FactsContainer.remove_child(n)

func show_bless_results(unit: Unit, bless_strength: int, total_strength: float, game_end: bool):
    self.is_game_end = game_end

    if self.is_game_end:
        next_round_button.text = game_end_button_text

    $UnitTypeBlessingContainer/UnitTypeUI.initialize(unit.type)
    $UnitTypeBlessingContainer/BlessingStrengthLabel.text = str(bless_strength)
    $UnitTypeBlessingContainer/UnitTypeMultiplierLabel.text = "%.2f" % unit.type.multiplier
    $UnitTypeBlessingContainer/MultipliedBlessingLabel.text = "%.2f" % (bless_strength * unit.type.multiplier)

    for fact in unit.facts:
        append_fact_value_ui(fact)

    $TotalStrengthLabel.text = "Final strength: %.2f" % total_strength

func append_fact_value_ui(fact: Fact):
    var fact_value_ui: FactValueUI = fact_value_ui_scene.instantiate()
    fact_value_ui.initialize(fact)
    $FactsContainer.add_child(fact_value_ui)

func _on_next_round_button_pressed():
    SoundFx.play_select_sfx()

    if is_game_end:
        MessageBus.GAME_END.emit()
    else:
        MessageBus.ROUND_END.emit()
