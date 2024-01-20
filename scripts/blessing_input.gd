extends HBoxContainer

@onready var bless_amount_label: Label = find_child("BlessAmountLabel")
@onready var bless_goal_label: Label = find_child("BlessGoalLabel")

func _ready():
    update_bless_amount_label(1)
    bless_goal_label.text = "Goal: %d to 100" % DifficultyManager.get_min_goal()

func _on_button_pressed():
    MessageBus.BLESS_BUTTON_PRESSED.emit($VBoxContainer/BlessAmountSlider.value)
    SoundFx.play_bless_sfx()

func _on_bless_amount_slider_value_changed(value: int):
    update_bless_amount_label(value)

func update_bless_amount_label(value: int):
    bless_amount_label.text = "Blessing: %d" % value

