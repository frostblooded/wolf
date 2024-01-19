class_name BlessingUnitUI
extends CanvasLayer

@export var fact_ui_scene: PackedScene = null

@onready var bless_amount_slider = find_child("BlessAmountSlider")

func initialize(unit: Unit):
    var facts_container: Control = find_child("FactsContainer")

    for fact in unit.facts:
        var fact_ui: FactUI = fact_ui_scene.instantiate()
        fact_ui.initialize(fact)
        facts_container.add_child(fact_ui)
