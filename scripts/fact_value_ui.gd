class_name FactValueUI
extends Control

func initialize(fact: Fact):
    $FactUI.initialize(fact)

    if fact.value > 0:
        $ValueLabel.text = "+" + str(fact.value)
    else:
        $ValueLabel.text = str(fact.value)

