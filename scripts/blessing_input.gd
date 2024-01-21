extends HBoxContainer

@onready var bless_amount_label: Label = find_child("BlessAmountLabel")
@onready var bless_goal_label: Label = find_child("BlessGoalLabel")

var autocomplete_seconds: float = 0
var last_interact_time: float = 0
var already_autocompleted: bool = false

func _ready():
    last_interact_time = Time.get_unix_time_from_system()
    update_bless_amount_label(1)
    bless_goal_label.text = "Goal: %d to 100" % LevelManager.get_min_goal()

func _on_button_pressed():
    var bless_context: BlessContext = BlessContext.new()
    bless_context.autocompleted = false
    bless_context.bless_amount = $VBoxContainer/BlessAmountSlider.value
    MessageBus.BLESS_BUTTON_PRESSED.emit(bless_context)
    SoundFx.play_bless_sfx()

func _on_bless_amount_slider_value_changed(value: int):
    last_interact_time = Time.get_unix_time_from_system()
    update_bless_amount_label(value)

func _process(_delta):
    if already_autocompleted:
        return

    if !is_equal_approx(autocomplete_seconds, 0):
        var seconds_since_last_interact: float = Time.get_unix_time_from_system() - last_interact_time
        print("Seconds since last interact: %.2f" % seconds_since_last_interact)

        if seconds_since_last_interact >= autocomplete_seconds:
            var bless_context: BlessContext = BlessContext.new()
            bless_context.autocompleted = true
            bless_context.bless_amount = 0
            MessageBus.BLESS_BUTTON_PRESSED.emit(bless_context)
            already_autocompleted = true

func update_bless_amount_label(value: int):
    bless_amount_label.text = "Blessing: %d" % value

