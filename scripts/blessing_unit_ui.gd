class_name BlessingUnitUI
extends CanvasLayer

@export var fact_ui_scene: PackedScene = null
@export var anomaly_ui_scene: PackedScene = null

func initialize(unit: Unit, wins_in_a_row: int):
	if unit.facts.is_empty():
		find_child("FactsContainerPanel").hide()
	else:
		var facts_container: Control = find_child("FactsContainer")

		for fact in unit.facts:
			var fact_ui: FactUI = fact_ui_scene.instantiate()
			fact_ui.initialize(fact)
			facts_container.add_child(fact_ui)

	if unit.anomaly == null:
		find_child("AnomalyContainerPanel").hide()
	else:
		var anomaly_container: Control = find_child("AnomalyContainer")

		var anomaly_ui: AnomalyUI = anomaly_ui_scene.instantiate()
		anomaly_ui.initialize(unit.anomaly)
		anomaly_container.add_child(anomaly_ui)

		if unit.anomaly is ReadyAnomaly:
			find_child("BlessingInput").autocomplete_seconds = unit.anomaly.seconds_for_autocompletion
	
	if unit.type == null:
		find_child("UnitTypeUI").hide()
	else:
		find_child("UnitTypeUI").initialize(unit.type)

	find_child("WinsInARowLabel").text = "Wins in a row: %d/3" % wins_in_a_row
