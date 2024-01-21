class_name AbsolutistAnomaly
extends Anomaly

func is_complete(context: BlessContext):
    return context.bless_amount == 1 || context.bless_amount == 150

