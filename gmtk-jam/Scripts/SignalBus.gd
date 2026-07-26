extends Node

# base_node signals
signal selec_base(base_node)
signal prepare_defense(base_node)
signal send_rocket(base_node)
signal radar_search(base_node)
signal base_destroyed(base_node)

# rocket_node signals
signal rocket_destroyed()

#difficulty change
signal difficulty_changed(difficulty)

# Endings
signal ending(ending_name: String)
signal ending_watch(friendly_base: int, enemy_base: int)

#enemy rocket
signal enemy_rocket_launch(start, target)

# Clock
signal lastMinute
