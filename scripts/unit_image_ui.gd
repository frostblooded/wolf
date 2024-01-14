class_name UnitImageUI
extends PanelContainer

@export var animated_label_scene: PackedScene = null

var bless_results: Array[String] = []

func show_animated_bless_results(unit: Unit, bless_strength: int, total_strength: float):
    bless_results.push_back("Blessing for %d" % bless_strength)
    bless_results.push_back("Base strength %d" % unit.strength)

    for t in unit.positive_traits:
        if !is_equal_approx(t.mul_modifier, 1.0):
            bless_results.push_back("%s: x%.2f" % [t.name, t.mul_modifier])

        if t.add_modifier != 0:
            bless_results.push_back("%s: %d" % [t.name, t.add_modifier])

    for t in unit.negative_traits:
        if !is_equal_approx(t.mul_modifier, 1.0):
            bless_results.push_back("%s: x%.2f" % [t.name, t.mul_modifier])

        if t.add_modifier != 0:
            bless_results.push_back("%s: %d" % [t.name, t.add_modifier])

    bless_results.push_back("Total: %.2f" % total_strength)
    $BlessResultSpawnDelay.start()


func _on_bless_result_spawn_delay_timeout():
    if bless_results.is_empty():
        $BlessResultSpawnDelay.stop()
        return

    var label: AnimatedLabel = animated_label_scene.instantiate() as AnimatedLabel
    var bless_res: String = bless_results.pop_front()
    label.text = bless_res
    $AnimatedTraitsPanel.add_child(label)
