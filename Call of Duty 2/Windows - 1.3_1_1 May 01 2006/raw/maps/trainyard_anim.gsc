#using_animtree("generic_human");
main()
{
	level.scr_anim["soldier1"]["idle"][0] = (%downtown_sniper_blocking_door_idle);
	level.scr_anim["soldier1"]["idle"][1] = (%downtown_sniper_blocking_door_idle);
	level.scr_anim["soldier1"]["idle"][2] = (%downtown_sniper_blocking_door_idle);
	level.scr_anim["soldier1"]["idle"][3] = (%downtown_sniper_blocking_door_twitch);
	
	level.scrsound["soldier4"]["allclear"]	= "trainyard_rs4_allclear";
	level.scrsound["soldier1"]["clearhere"]	= "trainyard_rs1_clearhere";
	level.scrsound["soldier1"]["okcomrade"]	= "trainyard_rs3_okcomrade";
	level.scr_anim["soldier1"]["okcomrade"]	= %trainyard_intro;
	level.scrsound["soldier1"]["goodluck"]	= "trainyard_rs1_goodluck";
	level.scrsound["soldier4"]["stationhouse"]	= "trainyard_rs4_stationhouse";
	level.scrsound["soldier4"]["letsgocomrades"]	= "trainyard_rs4_letsgocomrades";

	level.scrsound["soldier4"]["panzerse"]	= "trainyard_rs4_panzerse";
	level.scrsound["soldier4"]["stickybombs"]	= "trainyard_rs4_stickybombs";
	level.scrsound["soldier4"]["tanktose"]	= "trainyard_rs4_tanktose";
	level.scrsound["soldier4"]["atallcosts"]	= "trainyard_rs4_atallcosts";
	level.scrsound["soldier4"]["supplyobjective"]	= "trainyard_rs4_supplyobjective";
	level.scrsound["soldier4"]["hardpointobjective"]	= "trainyard_rs3_hardpointobjective";

	level.scrsound["soldier3"]["backtostation"]	= "trainyard_rs3_backtostation";
	level.scrsound["soldier3"]["mgobjective"]	= "trainyard_rs3_mgobjective";

	level.scrsound["german3"]["pipeshout"]	= "trainyard_gs3_pipeshout";
	
	level.scrsound["soldier5"]["whispergo"]	= "trainyard_rs5_whispergo";
}

