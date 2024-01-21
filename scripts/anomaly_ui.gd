class_name AnomalyUI
extends Control

func initialize(anomaly: Anomaly):
	$Label.text = anomaly.name
	$TextureRect.texture = anomaly.image

func initialize_with_additional_text(anomaly: Anomaly, text: String):
	$Label.text = anomaly.name + text
	$TextureRect.texture = anomaly.image
