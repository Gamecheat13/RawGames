#include maps\_utility;
main()
{
	//Crew standby, do not engage, do not engage, just monitor. Do not engage the moving targets.
	level.scr_sound["fco"]["ac130_fco_donotengage"] 			= "ac130_fco_donotengage";
	
	//Wildfire, we are moving up the road towards a town to the east. Confirm you have a visual on us.
	level.scr_sound["price"]["ac130_pri_towntoeast"] 		= "ac130_pri_towntoeast";
	
	//Copy. Request sparkle, over.
	level.scr_sound["fco"]["ac130_fco_requestsparkle"] 		= "ac130_fco_requestsparkle";
	
	//Copy we are now turning on our fireflies. Standby.
	level.scr_sound["price"]["ac130_pri_turnonfireflies"] 	= "ac130_pri_turnonfireflies";
	
	//Got eyes on friendlies!
	level.scr_sound["tvo"]["ac130_tvo_eyesonfriendlies"]	= "ac130_tvo_eyesonfriendlies";
	
	//Crew, do not fire on any target marked by a strobe, those are friendlies.
	level.scr_sound["fco"]["ac130_fco_nofirestrobe"] 		= "ac130_fco_nofirestrobe";
	
	//-------------------------------------------------------------------------------------------------
	
	//Uh, TV, confirm you see the church in the town.
	level.scr_sound["nav"]["ac130_nav_confirmchurch"] 		= "ac130_nav_confirmchurch";
	
	//We see it, start the clock.
	level.scr_sound["tvo"]["ac130_tvo_weseeit"] 			= "ac130_tvo_weseeit";
	
	//Roger that we're there, start talking.
	level.scr_sound["fco"]["ac130_fco_rogerwerethere"] 		= "ac130_fco_rogerwerethere";
	
	//You are not authorized to level the church. Do not fire directly on the church.
	level.scr_sound["nav"]["ac130_nav_notauthorizedchurch"] = "ac130_nav_notauthorizedchurch";
	
	//-------------------------------------------------------------------------------------------------
	
	//Got a vehicle moving now!
	level.scr_sound["tvo"]["ac130_tvo_vehiclemovingnow"] 	= "ac130_tvo_vehiclemovingnow";
	
	//One of the vehicles is moving right now.
	level.scr_sound["fco"]["ac130_fco_onevehiclemoving"] 	= "ac130_fco_onevehiclemoving";
	
	//Personnel coming out of the church.
	level.scr_sound["tvo"]["ac130_tvo_personnelchurch"] 	= "ac130_tvo_personnelchurch";
	
	//We have armed personnel approaching from the church, request permission to engage.
	level.scr_sound["fco"]["ac130_fco_armedpersonnelchurch"]= "ac130_fco_armedpersonnelchurch";
	
	//Copy. You are cleared to engage the moving vehicle, and any personnel around you see.
	level.scr_sound["pilot"]["ac130_plt_cleartoengage"]		= "ac130_plt_cleartoengage";
	
	//Affirmative. Crew you are cleared to engage but do not fire on the church.
	level.scr_sound["fco"]["ac130_fco_cleartoengage"] 		= "ac130_fco_cleartoengage";
	
	//-------------------------------------------------------------------------------------------------
	
	
	
	
	//CONTEXT SENSATIVE DIALOG
	//-------------------------------------------------------------------------------------------------
	add_context_sensative_dialog( "wounded_ai", "crawl", 0, "ac130_tvo_stillcrawlingthere1" );
	add_context_sensative_dialog( "wounded_ai", "crawl", 0, "ac130_tvo_stillcrawlingthere2" );
	add_context_sensative_dialog( "wounded_ai", "crawl", 0, "ac130_tvo_stillcrawlingthere3" );
	add_context_sensative_timeout( "wounded_ai", "crawl", undefined, 6 );
	
	add_context_sensative_dialog( "wounded_ai", "pain", 0, "ac130_tvo_downtoground1" );
	add_context_sensative_dialog( "wounded_ai", "pain", 0, "ac130_tvo_downtoground2" );
	add_context_sensative_dialog( "wounded_ai", "pain", 0, "ac130_tvo_downtoground3" );
	add_context_sensative_dialog( "wounded_ai", "pain", 1, "ac130_tvo_enemymoving1" );
	add_context_sensative_dialog( "wounded_ai", "pain", 1, "ac130_tvo_enemymoving2" );
	add_context_sensative_dialog( "wounded_ai", "pain", 1, "ac130_tvo_enemymoving3" );
	add_context_sensative_dialog( "wounded_ai", "pain", 2, "ac130_tvo_guysmovin1" );
	add_context_sensative_dialog( "wounded_ai", "pain", 2, "ac130_tvo_guysmovin2" );
	add_context_sensative_dialog( "wounded_ai", "pain", 2, "ac130_tvo_guysmovin3" );
	add_context_sensative_dialog( "wounded_ai", "pain", 3, "ac130_fco_yupguymoving1" );
	add_context_sensative_dialog( "wounded_ai", "pain", 3, "ac130_fco_yupguymoving2" );
	add_context_sensative_dialog( "wounded_ai", "pain", 3, "ac130_fco_yupguymoving3" );
	add_context_sensative_dialog( "wounded_ai", "pain", 4, "ac130_fco_okmovingagain1" );
	add_context_sensative_dialog( "wounded_ai", "pain", 4, "ac130_fco_okmovingagain2" );
	add_context_sensative_dialog( "wounded_ai", "pain", 4, "ac130_fco_okmovingagain3" );
	add_context_sensative_dialog( "wounded_ai", "pain", 5, "ac130_cw2_guymoving1" );
	add_context_sensative_dialog( "wounded_ai", "pain", 5, "ac130_cw2_guymoving2" );
	add_context_sensative_dialog( "wounded_ai", "pain", 5, "ac130_cw2_guymoving3" );
	add_context_sensative_timeout( "wounded_ai", "pain", undefined, 12 );
	
	add_context_sensative_dialog( "weapons", "105mm_ready", 0, "ac130_gnr_gunready1" );
	add_context_sensative_dialog( "weapons", "105mm_ready", 0, "ac130_gnr_gunready2" );
	add_context_sensative_dialog( "weapons", "105mm_ready", 0, "ac130_gnr_gunready3" );
	
	add_context_sensative_dialog( "weapons", "105mm_fired", 0, "ac130_gnr_itsshot1" );
	add_context_sensative_dialog( "weapons", "105mm_fired", 0, "ac130_gnr_itsshot2" );
	add_context_sensative_dialog( "weapons", "105mm_fired", 0, "ac130_gnr_itsshot3" );
	add_context_sensative_dialog( "weapons", "105mm_fired", 1, "ac130_gnr_shot1" );
	add_context_sensative_dialog( "weapons", "105mm_fired", 1, "ac130_gnr_shot2" );
	add_context_sensative_dialog( "weapons", "105mm_fired", 1, "ac130_gnr_shot3" );
	
	add_context_sensative_dialog( "plane", "rolling_in", 0, "ac130_plt_rollinin1" );
	add_context_sensative_dialog( "plane", "rolling_in", 0, "ac130_plt_rollinin2" );
	add_context_sensative_dialog( "plane", "rolling_in", 0, "ac130_plt_rollinin3" );
	
	add_context_sensative_dialog( "explosion", "secondary", 0, "ac130_nav_secondaries1" );
	add_context_sensative_dialog( "explosion", "secondary", 0, "ac130_nav_secondaries2" );
	add_context_sensative_dialog( "explosion", "secondary", 0, "ac130_nav_secondaries3" );
	add_context_sensative_dialog( "explosion", "secondary", 1, "ac130_tvo_directsecondary1" );
	add_context_sensative_dialog( "explosion", "secondary", 1, "ac130_tvo_directsecondary2" );
	add_context_sensative_dialog( "explosion", "secondary", 1, "ac130_tvo_directsecondary3" );
	add_context_sensative_timeout( "explosion", "secondary", undefined, 7 );
	
	add_context_sensative_dialog( "kill", "large_group", 0, "ac130_fco_hotdamn1" );
	add_context_sensative_dialog( "kill", "large_group", 0, "ac130_fco_hotdamn2" );
	add_context_sensative_dialog( "kill", "large_group", 0, "ac130_fco_hotdamn3" );
	add_context_sensative_dialog( "kill", "large_group", 1, "ac130_tvo_whoa1" );
	add_context_sensative_dialog( "kill", "large_group", 1, "ac130_tvo_whoa2" );
	add_context_sensative_dialog( "kill", "large_group", 1, "ac130_tvo_whoa3" );
	
	add_context_sensative_dialog( "kill", "small_group", 0, "ac130_fco_directhits1" );
	add_context_sensative_dialog( "kill", "small_group", 0, "ac130_fco_directhits2" );
	add_context_sensative_dialog( "kill", "small_group", 0, "ac130_fco_directhits3" );
	add_context_sensative_dialog( "kill", "small_group", 1, "ac130_tvo_therewego1" );
	add_context_sensative_dialog( "kill", "small_group", 1, "ac130_tvo_therewego2" );
	add_context_sensative_dialog( "kill", "small_group", 1, "ac130_tvo_therewego3" );
	
	add_context_sensative_dialog( "kill", "single", 0, "ac130_fco_yougotguy1" );
	add_context_sensative_dialog( "kill", "single", 0, "ac130_fco_yougotguy2" );
	add_context_sensative_dialog( "kill", "single", 0, "ac130_fco_yougotguy3" );
	add_context_sensative_dialog( "kill", "single", 1, "ac130_fco_gotem1" );
	add_context_sensative_dialog( "kill", "single", 1, "ac130_fco_gotem2" );
	add_context_sensative_dialog( "kill", "single", 1, "ac130_fco_gotem3" );
	add_context_sensative_dialog( "kill", "single", 2, "ac130_tvo_direct1" );
	add_context_sensative_dialog( "kill", "single", 2, "ac130_tvo_direct2" );
	add_context_sensative_dialog( "kill", "single", 2, "ac130_tvo_direct3" );
	add_context_sensative_dialog( "kill", "single", 3, "ac130_tvo_yougotem1" );
	add_context_sensative_dialog( "kill", "single", 3, "ac130_tvo_yougotem2" );
	add_context_sensative_dialog( "kill", "single", 3, "ac130_tvo_yougotem3" );
	add_context_sensative_timeout( "kill", "single", 0, 30 );
	
	add_context_sensative_dialog( "location", "car", 0, "ac130_fco_guybycar1" );
	add_context_sensative_dialog( "location", "car", 0, "ac130_fco_guybycar2" );
	add_context_sensative_dialog( "location", "car", 0, "ac130_fco_guybycar3" );
	add_context_sensative_dialog( "location", "car", 1, "ac130_tvo_guybycar1" );
	add_context_sensative_dialog( "location", "car", 1, "ac130_tvo_guybycar2" );
	add_context_sensative_dialog( "location", "car", 1, "ac130_tvo_guybycar3" );
	add_context_sensative_dialog( "location", "car", 2, "ac130_tvo_enemybycar1" );
	add_context_sensative_dialog( "location", "car", 2, "ac130_tvo_enemybycar2" );
	add_context_sensative_dialog( "location", "car", 2, "ac130_tvo_enemybycar3" );
	add_context_sensative_timeout( "location", "car", undefined, 20 );
	
	add_context_sensative_dialog( "location", "building", 0, "ac130_fco_nailbybuilding1" );
	add_context_sensative_dialog( "location", "building", 0, "ac130_fco_nailbybuilding2" );
	add_context_sensative_dialog( "location", "building", 0, "ac130_fco_nailbybuilding3" );
	add_context_sensative_dialog( "location", "building", 1, "ac130_tvo_runningforbuilding1" );
	add_context_sensative_dialog( "location", "building", 1, "ac130_tvo_runningforbuilding2" );
	add_context_sensative_dialog( "location", "building", 1, "ac130_tvo_runningforbuilding3" );
	add_context_sensative_timeout( "location", "building", undefined, 20 );
	
	add_context_sensative_dialog( "location", "wall", 0, "ac130_tvo_coverbywall1" );
	add_context_sensative_dialog( "location", "wall", 0, "ac130_tvo_coverbywall2" );
	add_context_sensative_dialog( "location", "wall", 0, "ac130_tvo_coverbywall3" );
	add_context_sensative_timeout( "location", "wall", undefined, 20 );
	
	add_context_sensative_dialog( "location", "truck", 0, "ac130_fco_onebytruck1" );
	add_context_sensative_dialog( "location", "truck", 0, "ac130_fco_onebytruck2" );
	add_context_sensative_dialog( "location", "truck", 0, "ac130_fco_onebytruck3" );
	add_context_sensative_dialog( "location", "truck", 1, "ac130_tvo_enemybytruck1" );
	add_context_sensative_dialog( "location", "truck", 1, "ac130_tvo_enemybytruck2" );
	add_context_sensative_dialog( "location", "truck", 1, "ac130_tvo_enemybytruck3" );
	add_context_sensative_timeout( "location", "truck", undefined, 12 );
	
	add_context_sensative_dialog( "vehicle", "incoming", 0, "ac130_fco_gotmovingvehicle1" );
	add_context_sensative_dialog( "vehicle", "incoming", 0, "ac130_fco_gotmovingvehicle2" );
	add_context_sensative_dialog( "vehicle", "incoming", 0, "ac130_fco_gotmovingvehicle3" );
	add_context_sensative_dialog( "vehicle", "incoming", 1, "ac130_tvo_gotvehiclemoving1" );
	add_context_sensative_dialog( "vehicle", "incoming", 1, "ac130_tvo_gotvehiclemoving2" );
	add_context_sensative_dialog( "vehicle", "incoming", 1, "ac130_tvo_gotvehiclemoving3" );
	add_context_sensative_dialog( "vehicle", "incoming", 2, "ac130_tvo_anothervehicle1" );
	add_context_sensative_dialog( "vehicle", "incoming", 2, "ac130_tvo_anothervehicle2" );
	add_context_sensative_dialog( "vehicle", "incoming", 2, "ac130_tvo_anothervehicle3" );
	add_context_sensative_dialog( "vehicle", "incoming", 3, "ac130_tvo_vehicleonmove1" );
	add_context_sensative_dialog( "vehicle", "incoming", 3, "ac130_tvo_vehicleonmove2" );
	add_context_sensative_dialog( "vehicle", "incoming", 3, "ac130_tvo_vehicleonmove3" );
	
	add_context_sensative_dialog( "vehicle", "clearengage", 0, "ac130_fco_clearengagevehicle1" );
	add_context_sensative_dialog( "vehicle", "clearengage", 0, "ac130_fco_clearengagevehicle2" );
	add_context_sensative_dialog( "vehicle", "clearengage", 0, "ac130_fco_clearengagevehicle3" );
	
	add_context_sensative_dialog( "misc", "action", 0, "ac130_cpl_nojoylock1" );
	add_context_sensative_dialog( "misc", "action", 0, "ac130_cpl_nojoylock2" );
	add_context_sensative_dialog( "misc", "action", 0, "ac130_cpl_nojoylock3" );
	add_context_sensative_timeout( "misc", "action", 0, 30 );
	add_context_sensative_dialog( "misc", "action", 1, "ac130_cpl_tenseconds1" );
	add_context_sensative_dialog( "misc", "action", 1, "ac130_cpl_tenseconds2" );
	add_context_sensative_timeout( "misc", "action", 1, 45 );
	add_context_sensative_dialog( "misc", "action", 2, "ac130_tvo_nobox1" );
	add_context_sensative_dialog( "misc", "action", 2, "ac130_tvo_nobox2" );
	add_context_sensative_dialog( "misc", "action", 2, "ac130_tvo_nobox3" );
	add_context_sensative_timeout( "misc", "action", 2, 25 );
	add_context_sensative_dialog( "misc", "action", 3, "ac130_plt_flaresaway1" );
	add_context_sensative_dialog( "misc", "action", 3, "ac130_plt_flaresaway2" );
	add_context_sensative_dialog( "misc", "action", 3, "ac130_plt_flaresaway3" );
	add_context_sensative_timeout( "misc", "action", 3, 15 );
	add_context_sensative_dialog( "misc", "action", 4, "ac130_gnr_offsettings1" );
	add_context_sensative_dialog( "misc", "action", 4, "ac130_gnr_offsettings2" );
	add_context_sensative_dialog( "misc", "action", 4, "ac130_gnr_offsettings3" );
	add_context_sensative_timeout( "misc", "action", 4, 20 );
	
	
	/*
	#RANDOM LINES THAT CAN BE SAID ( NOT PERTAINING TO SPECIFIC ENEMIES )
	
	
	
	#CONFIRMATIONS TO OTHER LINES
	ac130_tvo_roger1
	ac130_tvo_roger2
	ac130_tvo_roger3
	ac130_fco_copy
	ac130_fco_copy1
	ac130_fco_copy2
	ac130_fco_copy3
	ac130_fco_secondcopy1
	ac130_fco_secondcopy2
	ac130_fco_secondcopy3
	
	
	#CONFIRMATIONS TO ENGAGE LINES
	ac130_fco_copysmokeem1
	ac130_fco_copysmokeem2
	ac130_fco_copysmokeem3
	*/
	
	
	
	
	
	//incoming apc
	/*
	ac130_fco_vehicleonmove1
	ac130_fco_vehicleonmove2
	ac130_fco_vehicleonmove3
	*/
	
	
	
	
	
	/*
	#Flight Control Officer
	ac130_fco_getthatguy1
	ac130_fco_getthatguy2
	ac130_fco_getthatguy3
	ac130_fco_getthatperson1
	ac130_fco_getthatperson2
	ac130_fco_getthatperson3
	ac130_fco_doveonground1
	ac130_fco_doveonground2
	ac130_fco_doveonground3
	ac130_fco_tankonmove1
	ac130_fco_tankonmove2
	ac130_fco_tankonmove3
	ac130_fco_clearengageenemy1
	ac130_fco_clearengageenemy2
	ac130_fco_clearengageenemy3
	ac130_fco_clearengageallthose1
	ac130_fco_clearengageallthose2
	ac130_fco_clearengageallthose3
	ac130_fco_getback1
	ac130_fco_getback2
	ac130_fco_getback3
	ac130_fco_morepersonnelmove1
	ac130_fco_morepersonnelmove2
	ac130_fco_morepersonnelmove3
	ac130_fco_backotherguys1
	ac130_fco_backotherguys2
	ac130_fco_backotherguys3
	ac130_fco_headingforditch1
	ac130_fco_headingforditch2
	ac130_fco_headingforditch3
	ac130_fco_lineemup1
	ac130_fco_lineemup2
	ac130_fco_lineemup3
	ac130_fco_continueengaging1
	ac130_fco_continueengaging2
	ac130_fco_continueengaging3
	ac130_fco_yougonnagetthem1
	ac130_fco_yougonnagetthem2
	ac130_fco_yougonnagetthem3
	ac130_fco_rightthere1
	ac130_fco_rightthere2
	ac130_fco_rightthere3
	
	#TV Operator
	ac130_tvo_thatsnicetruck
	ac130_tvo_enemyinpersuit
	ac130_tvo_makinrunforit1
	ac130_tvo_makinrunforit2
	ac130_tvo_makinrunforit3
	ac130_tvo_enemytankmoving1
	ac130_tvo_enemytankmoving2
	ac130_tvo_enemytankmoving3
	ac130_tvo_runningforditch1
	ac130_tvo_runningforditch2
	ac130_tvo_runningforditch3
	ac130_tvo_movingtonext1
	ac130_tvo_movingtonext2
	ac130_tvo_movingtonext3
	
	#Price
	ac130_pri_hoodswithxs
	ac130_pri_takingheavyfire
	ac130_pri_capturedpersonnel
	ac130_pri_donotengage
	ac130_pri_remainingvehicles
	ac130_pri_capturedhvi
	
	#Flight Control Officer
	ac130_fco_alternatetransport
	ac130_fco_hesscared
	ac130_fco_weseexs
	ac130_fco_stickto25mm
	ac130_fco_readytoengage
	ac130_fco_clearengageroadblock
	ac130_fco_headedforstationary
	ac130_fco_needguyalive
	ac130_fco_doesntknowquit
	ac130_fco_engageallremaining
	ac130_fco_includingmovingvehicles
	
	#Navigator
	ac130_nav_roadblock
	ac130_nav_engageroadblock
	
	#Pilot
	ac130_plt_friendlyhelicopters
	ac130_plt_returntobase
	*/
}

add_context_sensative_dialog( name1, name2, group, soundAlias )
{
	assert( isdefined( name1 ) );
	assert( isdefined( name2 ) );
	assert( isdefined( group ) );
	assert( isdefined( soundAlias ) );
	assert( soundexists( soundAlias ) == true );
	
	if( ( !isdefined( level.scr_sound[ name1 ] ) ) || ( !isdefined( level.scr_sound[ name1 ][ name2 ] ) ) || ( !isdefined( level.scr_sound[ name1 ][ name2 ][group] ) ) )
	{
		// creating group for the first time
		level.scr_sound[ name1 ][ name2 ][group] = spawnStruct();
		level.scr_sound[ name1 ][ name2 ][group].played = false;
		level.scr_sound[ name1 ][ name2 ][group].sounds = [];
	}
	
	//group exists, add the sound to the array
	index = level.scr_sound[ name1 ][ name2 ][group].sounds.size;
	level.scr_sound[ name1 ][ name2 ][group].sounds[index] = soundAlias;
}

add_context_sensative_timeout( name1, name2, groupNum, timeoutDuration )
{
	if( !isdefined( level.context_sensative_dialog_timeouts ) )
		level.context_sensative_dialog_timeouts = [];
	
	createStruct = false;
	if ( !isdefined( level.context_sensative_dialog_timeouts[ name1 ] ) )
		createStruct = true;
	else if ( !isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ] ) )
		createStruct = true;
	if ( createStruct )
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ] = spawnStruct();
	
	if ( isdefined( groupNum ) )
	{
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups = [];
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ] = spawnStruct();
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v["timeoutDuration"] = timeoutDuration * 1000;
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v["lastPlayed"] = ( timeoutDuration * -1000 );
	}
	else
	{
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v["timeoutDuration"] = timeoutDuration * 1000;
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v["lastPlayed"] = ( timeoutDuration * -1000 );
	}
}