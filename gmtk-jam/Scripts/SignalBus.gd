extends Node

# base_node signals
signal selec_base(base_node)
signal prepare_defense(base_node)
signal send_rocket(base_node)
signal radar_search(base_node)

# rocket_node signals
signal rocket_destroyed()

#difficulty change
signal difficulty_changed(difficulty)

#Level select
signal level1_selected
signal level2_selected
signal level3_selected
signal level4_selected

#enemy rocket
signal enemy_rocket_launch(start, target)
