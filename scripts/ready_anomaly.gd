class_name ReadyAnomaly
extends Anomaly

@export var seconds_for_autocompletion: float = 30

func is_complete(context: BlessContext):
    return context.autocompleted == true

