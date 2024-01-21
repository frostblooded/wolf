extends Node

@export var possible_level_1_facts: Array[Fact] = []
@export var possible_level_2_facts: Array[Fact] = []
@export var possible_level_3_anomalies: Array[Anomaly] = []
@export var possible_level_1_unit_types: Array[UnitType] = []
@export var possible_level_2_unit_types: Array[UnitType] = []

var min_goals_per_level: Dictionary = {
    1: 70,
    2: 85,
    3: 100,
}

var facts_count_per_level: Dictionary = {
    1: 1,
    2: 3,
    3: 0,
}

var current_level = 1

func get_possible_facts():
    if current_level == 1:
        return possible_level_1_facts
    elif current_level == 2:
        return possible_level_2_facts
    else:
        return []

func get_possible_unit_types():
    if current_level == 1:
        return possible_level_1_unit_types
    elif current_level == 2:
        return possible_level_2_unit_types
    else:
        return []

func get_anomaly(win_streak: int) -> Anomaly:
    if current_level == 3:
        return possible_level_3_anomalies[win_streak]
    else:
        return null

func get_min_goal() -> int:
    return min_goals_per_level[current_level]

func get_facts_count() -> int:
    return facts_count_per_level[current_level]
