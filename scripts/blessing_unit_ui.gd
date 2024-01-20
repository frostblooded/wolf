class_name BlessingUnitUI
extends CanvasLayer

@export var fact_ui_scene: PackedScene = null

func initialize(unit: Unit, wins_in_a_row: int):
    var facts_container: Control = find_child("FactsContainer")

    for fact in unit.facts:
        var fact_ui: FactUI = fact_ui_scene.instantiate()
        fact_ui.initialize(fact)
        facts_container.add_child(fact_ui)
    
    find_child("UnitTypeUI").initialize(unit.type)
    find_child("WinsInARowLabel").text = "Wins in a row: %d/3" % wins_in_a_row
