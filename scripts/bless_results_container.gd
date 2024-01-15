extends VBoxContainer

func clear():
    for n in $OtherBlessResultsContainer.get_children():
        $OtherBlessResultsContainer.remove_child(n)

func show_bless_results(unit: Unit, bless_strength: int, total_strength: float):
    $TotalStrengthLabel.text = "Total strength: %.2f" % total_strength

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
    MessageBus.ROUND_END.emit()
