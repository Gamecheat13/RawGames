level_init()
{
	level.allies_team = "specops";
	level.axis_team   = "russian";

	level.chopper_gunner_player_model["specops"] = "iw5_usa_cia_mp_body_armor";
	level.chopper_gunner_player_model["russian"] = "iw5_rus_spet_mp_body_armor";
	level.chopper_gunner_player_head["specops"] = "iw5_usa_cia_mp_head_1";
	level.chopper_gunner_player_head["russian"] = "iw5_rus_spet_mp_head_1";
	level.chopper_gunner_viewmodel["specops"] = "iw5_viewmodel_usa_cia_armor_arms";
	level.chopper_gunner_viewmodel["russian"] = "iw5_viewmodel_rus_spet_armor_arms";
}