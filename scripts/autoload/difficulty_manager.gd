extends Node

enum Difficulty {EASY, NORMAL, HARD}

var min_goals_per_difficulty: Dictionary = {
    Difficulty.EASY: 70,
    Difficulty.NORMAL: 85,
    Difficulty.HARD: 95,
}

var facts_count_per_difficulty: Dictionary = {
    Difficulty.EASY: 1,
    Difficulty.NORMAL: 3,
    Difficulty.HARD: 3,
}

var current_difficulty = Difficulty.NORMAL

func get_min_goal() -> int:
    return min_goals_per_difficulty[current_difficulty]

func get_facts_count() -> int:
    return facts_count_per_difficulty[current_difficulty]
