#using_animtree("generic_human");
main()
{	
	//Guy plants explosives on a Flak88
	level.scr_anim["soldier"]["plant"]										= (%brecourt_flak_foleyplantsbomb);
	level.scr_anim["soldier"]["loop"][0]									= (%brecourt_flak_foleyplantsbomb_loop);
	
	level.scr_anim["germankicker"]["kickladder"]							= (%toujane_ladder_kick_guy1);
	level.scr_anim["soldier"]["setupladder"]								= (%toujane_ladder_kick_guy2);
	
	level.scr_anim["soldier1"]["tankride_dialogue_body"]					= (%toujane_tankride_dialogue_macgregor);
	level.scr_anim["soldier2"]["tankride_dialogue_body"]					= (%toujane_tankride_dialogue_soldier2);
	
	level.scr_anim["soldier"]["comehere"]									= (%duhoc_assault_randall_waves);
	//level.scr_face["soldier"]["comehere"]									= (%toujaneride_pri_sc02_01_t5_head);
	
	level dialogue();
}

dialogue()
{
	level.scrsound["soldier1"]["toujane_macgregor_normansenthome"]			= "toujane_macgregor_normansenthome";
	level.scrsound["soldier1"]["toujane_macgregor_losthisleg"]				= "toujane_macgregor_losthisleg";
	level.scrsound["soldier"]["toujane_macgregor_flankthatgo"]				= "toujane_macgregor_flankthatgo";
	level.scrsound["soldier"]["toujane_macgregor_jerriesontheroof"]			= "toujane_macgregor_jerriesontheroof";
	level.scrsound["soldier"]["toujane_macgregor_captureit"]				= "toujane_macgregor_captureit";
	level.scrsound["soldier"]["toujane_macgregor_grenadeit"]				= "toujane_macgregor_grenadeit";
	level.scrsound["soldier"]["toujane_macgregor_useasmokegrenade"]			= "toujane_macgregor_useasmokegrenade";
	level.scrsound["soldier"]["toujane_macgregor_disableflakexplosives"]	= "toujane_macgregor_disableflakexplosives";
	level.scrsound["soldier"]["toujane_macgregor_imgoingimgoing"]			= "toujane_macgregor_imgoingimgoing";
	level.scrsound["soldier"]["toujane_macgregor_another88"]				= "toujane_macgregor_another88";
	level.scrsound["soldier"]["toujane_macgregor_oiourtanks"]				= "toujane_macgregor_oiourtanks";
	level.scrsound["soldier"]["toujane_macgregor_hurrylads"]				= "toujane_macgregor_hurrylads";
	level.scrsound["soldier"]["toujane_macgregor_jerriesholedup"]			= "toujane_macgregor_jerriesholedup";
	level.scrsound["soldier"]["toujane_macgregor_intothemosque"]			= "toujane_macgregor_intothemosque";
	level.scrsound["soldier"]["toujane_macgregor_mosqueisours"]				= "toujane_macgregor_mosqueisours";
	level.scrsound["soldier"]["toujane_macgregor_onthatmg"]					= "toujane_macgregor_onthatmg";
	level.scrsound["soldier"]["toujane_macgregor_usethe42"]					= "toujane_macgregor_usethe42";
	level.scrsound["soldier"]["toujane_macgregor_mountedmachinegun"]		= "toujane_macgregor_mountedmachinegun";
	level.scrsound["soldier"]["toujane_macgregor_takefieldglasses"]			= "toujane_macgregor_takefieldglasses";
	level.scrsound["soldier"]["toujane_macgregor_davistakeem"]				= "toujane_macgregor_davistakeem";
	level.scrsound["soldier"]["toujane_macgregor_spotthosekraut"]			= "toujane_macgregor_spotthosekraut";
	level.scrsound["soldier"]["toujane_macgregor_oidavislisten"]			= "toujane_macgregor_oidavislisten";
	level.scrsound["soldier"]["toujane_macgregor_panzerfromwest"]			= "toujane_macgregor_panzerfromwest";
	level.scrsound["soldier"]["toujane_macgregor_tankspottednorth"]			= "toujane_macgregor_tankspottednorth";
	level.scrsound["soldier"]["toujane_macgregor_jollygoodchrist"]			= "toujane_macgregor_jollygoodchrist";
	level.scrsound["soldier"]["toujane_macgregor_tankinfromnorth"]			= "toujane_macgregor_tankinfromnorth";
	level.scrsound["soldier"]["toujane_macgregor_damngother"]				= "toujane_macgregor_damngother";
	level.scrsound["soldier"]["toujane_macgregor_withouttanksupport"]		= "toujane_macgregor_withouttanksupport";
	level.scrsound["soldier"]["toujane_macgregor_takethosepanzers"]			= "toujane_macgregor_takethosepanzers";
	level.scrsound["soldier"]["toujane_macgregor_timetorest"]				= "toujane_macgregor_timetorest";
	level.scrsound["soldier"]["toujane_macgregor_bloodycrazywar"]			= "toujane_macgregor_bloodycrazywar";
	
	level.scrsound["soldier2"]["toujane_bs2_luckybastard"]					= "toujane_bs2_luckybastard";
	level.scrsound["soldier2"]["toujane_bs2_atleastoutofdesert"]			= "toujane_bs2_atleastoutofdesert";
	level.scrsound["soldier"]["toujane_bs1_anothermg"]						= "toujane_bs1_anothermg";
	level.scrsound["soldier"]["toujane_bs1_imonit"]							= "toujane_bs1_imonit";
	level.scrsound["soldier"]["toujane_bs1_getupladdercheck"]				= "toujane_bs1_getupladdercheck";
	level.scrsound["soldier"]["toujane_bs1_blowupthat88"]					= "toujane_bs1_blowupthat88";
	level.scrsound["soldier"]["toujane_bs1_bloodymg"]						= "toujane_bs1_bloodymg";
	level.scrsound["soldier"]["toujane_bs1_lookouttank"]					= "toujane_bs1_lookouttank";
	level.scrsound["soldier"]["toujane_bs1_panzer"]							= "toujane_bs1_panzer";
	level.scrsound["soldier"]["toujane_bs1_smashinggotone"]					= "toujane_bs1_smashinggotone";
	level.scrsound["soldier"]["toujane_bs2_hopeyourwrong"]					= "toujane_bs2_hopeyourwrong";
	level.scrsound["soldier"]["toujane_bs2_flakdeadahead"]					= "toujane_bs2_flakdeadahead";
	level.scrsound["soldier"]["toujane_bs2_enemymgnest"]					= "toujane_bs2_enemymgnest";
	level.scrsound["soldier"]["toujane_bs2_88destroyit"]					= "toujane_bs2_88destroyit";
	level.scrsound["soldier"]["toujane_bs2_mgnest"]							= "toujane_bs2_mgnest";
	level.scrsound["soldier"]["toujane_bs2_comingthisway"]					= "toujane_bs2_comingthisway";
	level.scrsound["soldier"]["toujane_bs2_counterattack"]					= "toujane_bs2_counterattack";
	level.scrsound["soldier"]["toujane_bs2_anothertank"]					= "toujane_bs2_anothertank";
	level.scrsound["soldier"]["toujane_bs3_gordonbennettwhat"]				= "toujane_bs3_gordonbennettwhat";
	level.scrsound["soldier"]["toujane_bs3_machinegun"]						= "toujane_bs3_machinegun";
	level.scrsound["soldier"]["toujane_bs3_thatsgotone"]					= "toujane_bs3_thatsgotone";
	level.scrsound["soldier"]["toujane_bs4_forwardobservation"]				= "toujane_bs4_forwardobservation";
	level.scrsound["soldier"]["toujane_bs4_jerriesintruck"]					= "toujane_bs4_jerriesintruck";
	level.scrsound["soldier"]["toujane_bs4_88destroyit"]					= "toujane_bs4_88destroyit";
	level.scrsound["soldier"]["toujane_bs1_panzershreck"]					= "toujane_bs1_panzershreck";
	level.scrsound["soldier"]["toujane_bs2_bastarddestroyed"]				= "toujane_bs2_bastarddestroyed";
	level.scrsound["soldier"]["toujane_bs3_panzershrecksoverhere"]			= "toujane_bs3_panzershrecksoverhere";
	level.scrsound["soldier"]["toujane_bs3_useontanks"]						= "toujane_bs3_useontanks";
	level.scrsound["soldier"]["toujane_bs3_heresthepanzershrecks"]			= "toujane_bs3_heresthepanzershrecks";
	level.scrsound["soldier"]["toujane_bs3_comeoverhere"]					= "toujane_bs3_comeoverhere";
	level.scrsound["soldier"]["UK_3_threat_vehicle_panzer"]					= "UK_3_threat_vehicle_panzer";
	
	//new ending
	//"Our reinforcements have arrived!!"
	level.scrsound["soldier"]["toujane_bs4_arrived"]						= "toujane_bs4_arrived";
	
	//"We've got the bastards on the run! Don't let up!!!"
	level.scrsound["soldier"]["toujane_bs1_gotthebastards"]					= "toujane_bs1_gotthebastards";
	
	//"Tell Rommel you've been beat by the boys of the 7th Armored!"
	level.scrsound["soldier"]["toujane_mcg_tellrommel"]						= "toujane_mcg_tellrommel";
	
	//"And come back any time, you Jerry bastards! We'll be waiting for you!"
	level.scrsound["soldier"]["toujane_bs4_comebackanytime"]				= "toujane_bs4_comebackanytime";
	
	//"Looks like that's the last of the huns, eh Davis?"
	level.scrsound["soldier"]["toujane_mcg_lastofthehuns"]					= "toujane_mcg_lastofthehuns";
}