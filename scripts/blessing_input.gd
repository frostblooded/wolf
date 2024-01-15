extends HBoxContainer

@onready var bless_amount_label: Label = find_child("BlessAmountLabel")

func _ready():
    update_bless_amount_label(1)

func _on_button_pressed():
    MessageBus.BLESS_BUTTON_PRESSED.emit($VBoxContainer/BlessAmountSlider.value)

func _on_bless_amount_slider_value_changed(value: int):
    update_bless_amount_label(value)

func update_bless_amount_label(value: int):
    bless_amount_label.text = "Blessing for: %d" % value

