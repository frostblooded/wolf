extends Node2D

@export var unit_ui_scene: PackedScene = null
@export var possible_positive_traits: Array[Trait] = []
@export var possible_negative_traits: Array[Trait] = []

func _ready():
	show_unit()

func show_unit():
	var unit_ui: BlessingUnitUI = unit_ui_scene.instantiate() as BlessingUnitUI
	var unit: Unit = generate_unit()
	unit_ui.initialize(unit)
	get_tree().root.add_child.call_deferred(unit_ui)

func generate_unit() -> Unit:
	var unit: Unit = Unit.new()
	unit.strength = randi_range(0, 80)

	var MIN_TRAITS: int = 1
	var MAX_TRAITS: int = 3
	assert(MIN_TRAITS <= MAX_TRAITS);
	assert(possible_positive_traits.size() >= MAX_TRAITS);
	assert(possible_negative_traits.size() >= MAX_TRAITS);

	var positive_traits_amount: int = randi_range(MIN_TRAITS, MAX_TRAITS)
	var positive_traits_shuffled_copy: Array[Trait] = possible_positive_traits
	positive_traits_shuffled_copy.shuffle()

	for i in range(0, positive_traits_amount):
		unit.positive_traits.push_back(positive_traits_shuffled_copy[i])

	var negative_traits_amount: int = randi_range(MIN_TRAITS, MAX_TRAITS)
	var negative_traits_shuffled_copy: Array[Trait] = possible_negative_traits
	negative_traits_shuffled_copy.shuffle()

	for i in range(0, negative_traits_amount):
		unit.negative_traits.push_back(negative_traits_shuffled_copy[i])

	return unit
