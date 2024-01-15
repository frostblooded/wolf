extends HBoxContainer


func _on_button_pressed():
    MessageBus.BLESS_BUTTON_PRESSED.emit($VBoxContainer/BlessAmountSlider.value)


func _on_bless_amount_slider_value_changed(value: float):
    $VBoxContainer/Label.text = "Blessing for: %.0f" % value
