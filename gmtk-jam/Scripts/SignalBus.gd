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

#level select
signal level_relay(level)

# Endings
signal ending(ending_name)
signal ending_watch(friendly_base, enemy_base)

#enemy rocket
signal enemy_rocket_launch(start, target)

# Clock
signal lastMinute

#tutorial
signal tutorial_activated()
