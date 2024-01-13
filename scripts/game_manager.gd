extends Node2D

func _ready():
    MessageBus.BLESS_BUTTON_PRESSED.connect(on_bless_button_pressed)

func on_bless_button_pressed(bless_amount: float):
    print("Bless button pressed. Blessing for ", bless_amount)