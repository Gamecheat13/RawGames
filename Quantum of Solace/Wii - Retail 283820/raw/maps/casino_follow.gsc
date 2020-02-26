#include maps\_utility;
#include maps\_bossfight;
#include common_scripts\utility;


















e1_main()
{
	thread challenge_achievement();
	level thread disable_compass();
	
	if ( level.play_cutscenes )
	{
		level thread e1_igc();
	}
	else
	{
		level.player playersetforcecover( true, (1,0,0) );
		balc_guy = maps\casino_util::spawn_guys( "cai_e1_balcony", true, "e1_ai", "thug" );
		balc_guy SetIgnoreThreatType("corpse", true);

		maps\casino_util::reinforcement_update( "cai_e1_reinforcements", "e1_ai", false );

		patroller = maps\casino_util::spawn_guys( "cai_e1", true, "e1_ai", "thug" );
		
		level.patroller_ears = patroller;
		level thread maps\casino_amb::thug_ears_1();
	}
	level thread maps\casino_util::driveway_vehicles( "e3_start" );

	
	SetSavedDVar( "ai_ChatEnable", "0" );

	
	
	level thread maps\casino_pip::ledge();

	

	mr_body = maps\casino_util::spawn_guys( "cai_e1_body", true, "e1_ai", "civ" );
	mr_body DoDamage( mr_body.health + 1, mr_body.origin);
	mr_body StartRagDoll();
	
	wait 4;

	
	SetSavedDVar( "ai_ChatEnable", "1" );


	
	talker_thugs = maps\casino_util::spawn_guys_ordinal( "cai_e1_talker", 0, true, "e1_ai", "thug" );
	array_thread(talker_thugs, ::talker_thug);
	level.thug_tv_ears = talker_thugs[1];

	
	elight = GetEntArray( "light_e1_elev", "targetname" );
	for ( i=0; i<elight.size; i++ )
	{
		elight[i] setlightintensity( 0.5 );
	}

	if ( level.play_cutscenes )
	{
		level waittill("e1_igc_finished");
	}
	wait( 1.0 );
	flag_set( "obj_start");




	

	level thread e1_conversation( talker_thugs );
	
	

	
	while(1) {
		if (level.player buttonPressed("APAD_DOWN")) {
			level.player playerSetForceCover(false, false);
			break;
		}
		else wait (0.01);
	}
	
	
	
	
	trig = GetEnt("e1_outside_elevator", "targetname" );
	trig waittill( "trigger" );
	level notify( "playmusicpackage_start" );

	
	trig = GetEnt("ctrig_e1_balcony", "targetname" );
	trig waittill( "trigger" );


	SetExpFog(0, 37364, 0.375, 0.382813, 0.648438, 0);

	flag_set( "obj_detour_start");	

	trig delete();
	maps\casino_util::reinforcement_update( "", "", false );
	

	
	trig = GetEnt("ctrig_e2_outer_suite", "targetname" );
	trig waittill( "trigger" );


	level thread e1_withdrawl();
	level thread e2_main();

	
	
	level.special_autosavecondition = maps\casino_util::check_no_enemies_alerted;
	level thread maps\_autosave::autosave_by_name( "e1", 5.0 );

	
	trig = GetEnt( "ctrig_e2_balcony", "targetname" );
	trig waittill( "trigger" );

	level thread maps\_autosave::autosave_by_name( "e1", 5.0 );

	
	trig = GetEnt( "ctrig_e2_suite", "targetname" );
	trig waittill( "trigger" );

	
	level.special_autosavecondition = undefined;

	level waittill( "e3_start" );

	maps\casino_util::delete_group( "e1_ai" );
}

talker_thug()
{
	self SetIgnoreThreatType("corpse", true);

	if (IsDefined(self.script_noteworthy) && (self.script_noteworthy == "typer"))
	{
		self maps\_utility::gun_remove();
		self waittill("alert_yellow");
		self maps\_utility::gun_recall();
	}
}




e1_igc( )
{
	
	door_left  = GetEnt( "csbm_e_door_left",  "targetname" );
	door_right = GetEnt( "csbm_e_door_right", "targetname" );
	
	

	
	
	door_left  MoveY( -52, 1, 0.1, 0.7 );
	door_right MoveY(  52, 1, 0.1, 0.7 );
	

	
	level.hud_black.alpha = 1;	

	
	wait(0.1);
	setDvar( "cg_disableHudElements", 1 );
	level thread letterbox_on( false, true, undefined, false );

	
	wait( 1 ); 

	level.player playersetforcecover( true, (1,0,0) );

	wait( 2 );

	

	
	balc_guy = maps\casino_util::spawn_guys( "cai_e1_balcony", true, "e1_ai", "thug" );
	balc_guy SetIgnoreThreatType("corpse", true);

	maps\casino_util::reinforcement_update( "cai_e1_reinforcements", "e1_ai", false );

	
	
	
	
	
	
	
	

	

	

	
	level.hud_black fadeOverTime(5);
	level.hud_black.alpha = 0;

	level thread display_chyron();

	
	
	level thread maps\casino_amb::elevator_moving_stop();

	
	door_left	playsound ("CAS_elevator_bell");
	wait(1);
	

	
	
	

	
	thugs		= maps\casino_util::spawn_guys_ordinal( "cai_e1_escort_", 0,	true, "e1_ai_igc", "thug" );
	lechiffre	= maps\casino_util::spawn_guys( "cai_e1_lechiffre",	true, "e1_ai_igc", "civ" );
	thugs[0].targetname		= "thug1";
	thugs[1].targetname		= "thug3";
	thugs[2].targetname		= "thug4";
	lechiffre.targetname	= "lechiffre";

	
	door_left  MoveY(  47, 2.0, 0.1, 0.7 );
	door_right MoveY( -47, 2.0, 0.1, 0.7 );
	door_left	playsound ("CAS_elevator_doors_open");

	
	
	
	
	
	
	

	

	wait(2);	

	
	level.player customcamera_checkcollisions( 0 );

	
	elevator_cam = level.player customCamera_Push( "world", ( -680, 887, 760), (0,0,0) , 5.0);
	wait(1);	

	lechiffre play_dialogue( "LECH_CasiG01A_002A" );	

	PlayCutscene("LeChiffre", "cutscene_done" );
	SetDVar("cg_pip_buffering","0");

	level thread intro_cutscene_dialog( thugs );

	level.player customCamera_pop( elevator_cam, 0.1 );

	
	
	level waittill( "cutscene_done" );

	maps\casino_util::delete_group( "e1_ai_igc" );	

	
	level.player customcamera_checkcollisions( 1 );

	
	
	

	patroller = maps\casino_util::spawn_guys( "cai_e1", true, "e1_ai", "thug" );
	
	level.patroller_ears = patroller;
	level thread maps\casino_amb::thug_ears_1();

	
	level.player thread play_dialogue( "TANN_CasiG01A_006A", true );	

	
	patroller e1_patroller();


	

	level.hud_black fadeOverTime(1);
	level.hud_black.alpha = 0;

	level notify( "musicstinger_start", 0 );
	letterbox_off( true );

	player_stick( false );	
	new_spot = GetEnt( "cso_playerstart", "targetname" );
	


	
	
	wait(0.5);

	player_unstick();
	wait(0.1);

	setDvar( "cg_disableHudElements", 0 );	

	
	level thread maps\_autosave::autosave_now( "e1" );
	level notify("e1_igc_finished");
	
	level.player freezecontrols(false);
}


e1_patroller()
{
	self SetIgnoreThreatType("corpse", true);
	
	self waittill( "facing_node" );
	self cmdaction( "fidget" );
	self waittill( "cmd_done" );
	self StartPatrolRoute( "cpat_e1_start2" );
	wait(1);	
}




intro_cutscene_dialog( thugs )
{
	thugs[2] playsound( "CAS_lechiffre_escort" );		

	
	thugs[2] play_dialogue( "OBG2_CasiG01A_003A", true );		
	thugs[2] play_dialogue( "OBG1_CasiG01A_001A", true );		
}





fade_to_black()
{
	wait( 4 );
	level.hud_black fadeOverTime(2);
	level.hud_black.alpha = 1;
}
































































































































































e1_tv_flicker()
{
	level endon( "e3_start" );

	while (1)
	{
		intensity = RandomFloatRange( 1.0, 1.5 );
		
		iterations = RandomIntRange(8,20);
		for ( i = 0; i<iterations; i++ )
		{
			self setlightintensity( intensity );
			wait( 0.05 + randomfloat( 0.1 ) );
			self setlightintensity( intensity + 0.1 );
			wait( 0.05 + randomfloat( 0.1 ) );
		}
	}
}




e1_conversation( talkers )
{
	level endon( "e2_start" );
	

	for ( i=0; i<talkers.size; i++ )
	{
		
		if ( talkers[i] GetAlertState() != "alert_green" )
		{
			return;
		}

		talkers[i] endon( "alert_yellow" );
		talkers[i] endon( "alert_red" );
		talkers[i] endon( "death" );
		talkers[i] thread maps\casino_util::play_dialog_monitor( "conversation_done" );
	}

	trig = GetEnt( "ctrig_e1_conversation", "targetname" );
	trig waittill( "trigger" );

	talkers[0] maps\casino_util::play_dialog( "OBR2_CasiG01A_008A" );	
	wait(0.5);

	talkers[1] maps\casino_util::play_dialog( "OBR1_CasiG01A_009A" );	
	wait(0.5);

	talkers[0] maps\casino_util::play_dialog( "OBR2_CasiG01A_010A" );	
	wait(0.5);

	talkers[1] maps\casino_util::play_dialog( "OBR1_CasiG01A_011A" );	
	talkers[1] notify( "conversation_done" );
	wait(0.5);

	talkers[0] maps\casino_util::play_dialog( "OBR2_CasiG01A_012A" );	
	talkers[0] notify( "conversation_done" );
	wait(0.5);
}




e1_set_balcony_qk()
{
	self endon("death");
	
	wait( 1.5 );
	if ( !IsDefined(self.new_qk_anim) )
	{
		self.new_qk_anim = true;
		self SetCtxParam("Interact", "SpecialQKAnim", "Skylight_QK");
	}
	for(;;)
	{
		if ( self GetAlertState() != "alert_green" )
		{
			self SetCtxParam("Interact", "SpecialQKAnim", "None");		
		}
		wait(0.1);
	}
}





e1_withdrawl()
{
	node = GetNode( "cn_e1_withdrawl", "targetname" );

	ents = GetAIArray();
	for ( i=0; i<ents.size; i++ )
	{
		if ( ents[i] GetAlertState() != "alert_red" )
		{
			ents[i] SetGoalNode( node );
			ents[i] thread maps\casino_util::delete_on_goal();
		}
	}
}



SetPerfectSenseOnRed()
{
	self endon("death");

	self waittill("alert_red");

	self SetPerfectSense(1);

}




e2_main( )
{
	level notify( "e2_start" );

	
	level notify("drapes_1_start");


	
	blockercart_sbm		= GetEnt( "csbm_e2_blockercart", "targetname" );
	blockercart_model	= GetEnt( "csm_e2_blockercart", "targetname" );
	blockercart_model	LinkTo( blockercart_sbm );

	
	
	blockercart_start	= GetEnt( "cso_e2_blockercart_start", "targetname" );
	blockercart_sbm.origin = blockercart_start.origin;
	blockercart_sbm.angles = blockercart_start.angles;
	

	maps\_playerawareness::setupSingleUseOnly( 
		"csbm_e2_blockercart",			
		::e2_push_blocker_cart,			
		&"CASINO_HINT_MOVE_CART",		
		0,								
		"",								
		true,						   	
		true,							
		undefined,		   				
		level.awarenessMaterialNone,	
		true,							
		false,						   	
		false );					   	


	
	
	thugs = maps\casino_util::spawn_guys_ordinal( "cai_e2_", 0, true, "e2_ai", "thug" );
	maps\casino_util::reinforcement_update( "cai_e2_reinforcements", "e2_ai", false );

	
	thugs[0] thread check_sight(60, 200);	
	thugs[0] thread SetPerfectSenseOnRed();

	thugs[1] thread check_sight(60, 200);
	thugs[1] thread SetPerfectSenseOnRed();

	thread e2_conversation( thugs );
	level thread e2_tanner();

	
	trig = GetEnt( "ctrig_e2_suite", "targetname" );
	trig waittill( "trigger" );

	for ( i=0; i<thugs.size; i++ )
	{
		if ( IsAlive(thugs[i]) &&
			IsDefined(thugs[i].script_noteworthy) &&
			thugs[i].script_noteworthy == "bathroom" )
		{
			bathroom_guy = thugs[i];
			if ( IsAlive( bathroom_guy ) && bathroom_guy GetAlertState() == "alert_green" )
			{
				origin = GetEnt( "cso_toilet", "targetname" );
				origin playsound ("CAS_toilet_flush");
			}
		}
	}

	
	flag_wait( "obj_detour_end");

	maps\casino_util::reinforcement_update( "", "", false );
	level thread e3_main();

	
	level waittill( "e3_vent_start" );

	maps\casino_util::delete_group( "e2_ai" );
}





e2_conversation( thugs )
{
	thugs[0] endon( "death" );
	thugs[0] endon( "alert_yellow" );
	thugs[0] endon( "alert_red" );
	thugs[0] thread maps\casino_util::play_dialog_monitor( "conversation_done" );
	thugs[1] endon( "death" );
	thugs[1] endon( "alert_yellow" );
	thugs[1] endon( "alert_red" );
	thugs[1] thread maps\casino_util::play_dialog_monitor( "conversation_done" );
	thugs[1] maps\_utility::play_dialogue( "OBR4_CasiG01A_013A" );	

	thugs[0] maps\_utility::play_dialogue( "OBR5_CasiG01A_014A" );	
	thugs[0] notify( "conversation_done" );
	thugs[1] maps\_utility::play_dialogue( "OBR4_CasiG01A_015A" );	
	thugs[1] notify( "conversation_done" );

	
	trig = GetEnt( "ctrig_e2_suite", "targetname" );
	trig waittill( "trigger" );

	thugs[2] maps\_utility::play_dialogue( "OBBR_CasiG01A_023A" );	
	thugs[2] notify( "conversation_done" );
	wait( 0.3 );

	thugs[1] maps\_utility::play_dialogue( "OBR4_CasiG01A_022A" );	
	thugs[1] notify( "conversation_done" );
}



e2_set_balcony_qk()
{
	self endon("death");
	
	wait( 1.5 );
	self SetCtxParam("Interact", "SpecialQKAnim", "Skylight_QK");

	done = false;
	while( !done )
	{
		wait(0.1);

		if ( self GetAlertState() != "alert_green" )
		{		
			self SetCtxParam("Interact", "SpecialQKAnim", "None");	
			done = true;
		}
	}
}


change_fog()
{
	fog_trig = getent("fog_set_change" , "targetname");

	
	while(true)
	{

		if(level.player istouching(fog_trig) )
		{
			SetExpFog(13312, 37364, 0.375, 0.382813, 0.648438, 6.3);

			
		}
		else 
		{
			
			SetExpFog(0, 532.172, 0.44, 0.41, 0.36, 6.3, 0.626);


			
		}
		wait(0.2);


	}




}

disable_compass()
{

	trigger = getent("compass_gone", "targetname");

	while(true)
	{
		if (isdefined(trigger)) 
		{
			trigger waittill("trigger");
			setdvar("ui_hud_showcompass", 0);
				
			while(level.player istouching(trigger))
			{
				wait(0.1);
			}
			setdvar("ui_hud_showcompass", 1);
		}
		else {
			break;
		}

	}


}








e2_conversation2( thugs )
{
	thugs[0] endon( "death" );
	thugs[0] endon( "alert_yellow" );
	thugs[0] endon( "alert_red" );
	thugs[0] thread maps\casino_util::play_dialog_monitor( "conversation_done" );
	thugs[2] endon( "death" );
	thugs[2] endon( "alert_yellow" );
	thugs[2] endon( "alert_red" );
	thugs[2] thread maps\casino_util::play_dialog_monitor( "conversation_done" );

	
	if ( thugs[0] GetAlertState() != "alert_green" || 
		thugs[2] GetAlertState() != "alert_green" )
	{
		return;
	}

	thugs[0] maps\_utility::play_dialogue( "OBBR_CasiG01A_021A" );	
	thugs[2] maps\_utility::play_dialogue( "OBR4_CasiG01A_022A" );	

	thugs[0] maps\_utility::play_dialogue( "OBBR_CasiG01A_023A" );	
	thugs[0] notify( "conversation_done" );

	thugs[2] maps\_utility::play_dialogue( "OBBR_CasiG01A_024A" );	
	thugs[2] notify( "conversation_done" );
}





e2_tanner()
{
	trig = getent( "move_pip3", "targetname" );
	trig waittill( "trigger" );

	level.player maps\_utility::play_dialogue( "TANN_CasiG01A_019A" );	
	level.player maps\_utility::play_dialogue( "BOND_CasiG01A_020A" );	
}




e2_push_blocker_cart( object )
{
	cart = object.primaryEntity;

	destination = GetEnt( "cso_e2_blockercart_stop", "targetname" );
	cart MoveTo( destination.origin, 1.5, 0.1, 1.0 );
	cart RotateTo( destination.angles, 1.5, 0.1, 1.0 );
	cart playsound( "CAS_tall_cart_roll" );

	wait(1.25);

	clip = GetEnt( "csbm_e2_locker_blocker", "targetname" );
	clip delete();
	
	
}





e3_main()
{
	level notify( "e3_start" );

	
	level notify("casino_pool_steam");	
	level notify("casino_sauna_steam");	
	level notify("vent_rattle_1_start");	
	level notify("vent_rattle_2_start");	

	
	
	
	
	
	

	
	vent_fans = GetEntArray( "vent_fan", "targetname" );
	for ( i=0; i<vent_fans.size; i++ )
	{
		vent_fans[i] thread e3_spin_fan();
	}

	
	cart_mantle	= GetEnt( "csbm_e3_cart_clip", "targetname" );	
	cart_mantle trigger_off();

	maps\_playerawareness::setupSingleUseOnly(
		
		"pushing_cart_trigger",					
		::e3_push_cart,					
		&"CASINO_HINT_MOVE_CART",		
		
		0,								
		"",								
		true,						   	
		true,							
		undefined,						
		level.awarenessMaterialNone,	
		true,							
		false,						   	
		false );					   	

		
	
	vent_clip = GetEnt( "csbm_e3_vent_clip", "targetname" );	
	vent_clip trigger_off();

	maps\_playerawareness::setupArray( 
		"vent_open_locker",				
		::e3_open_vent_locker,			
		true,							
		::e3_open_vent_locker,			
		&"CASINO_HINT_OPEN_VENT",		
		0,								
		"",								
		true,							
		true,							
		undefined,						
		level.awarenessMaterialNone,	
		true,							
		false );					   	

	
	
	
	
	
	
	
	
	
	
	
	
	
	

	flag_wait( "obj_detour2_start");

	
	
	level thread e3_tanner();		
	thread e3_vent();
	thread e3_confrontation();	

	flag_wait( "flag_in_spa_lobby" );

	level.player AllowStand( true );
	
	vent = GetEnt("fxanim_vent_2", "targetname" );
	level thread e3_open_vent_spa( vent );

	
	
	
	
	
	level thread display_map_spa();
	

	unholster_weapons();


	
	trig = GetEnt("ctrig_e4_courtyard", "targetname" );
	trig waittill( "trigger" );

	level thread e4_main();
	level thread maps\_autosave::autosave_now("e4");

	
	level waittill( "e5_start" );

	maps\casino_util::delete_group( "e3_ai" );
	maps\casino_util::delete_group( "e3_obanno_ai" );
}



e3_tanner()
{

	trig = GetEnt( "trig_e3_spa_area", "targetname" );
	trig waittill( "trigger" );

	wait(1);	
	level.player maps\_utility::play_dialogue( "BOND_CasiG01A_025A" );	
	level.player maps\_utility::play_dialogue( "TANN_CasiG01A_026A" );	
}



e3_vent()
{
	level endon( "flag_in_spa_lobby" );

	level thread e3_unholster();
	trig = GetEnt( "trig_e3_vent", "targetname" );
	trigger_level_1 = getent("level_1_map_switch", "targetname");
	
	
		trig waittill( "trigger" );

		level.player AllowStand(false);
		SetSavedDVar("cover_dash_fromCover_enabled",false);
		SetSavedDVar("cover_dash_from1stperson_enabled",false);
		holster_weapons();

		
		
		
		
		
		setSavedDvar( "sf_compassmaplevel",  "level2" );
		

		trigger_level_1 waittill("trigger");
		level.player AllowStand(true);
		
		
		
		
		
		setSavedDvar( "sf_compassmaplevel",  "level1" );
		
	
}





e3_unholster()
{
	level endon( "flag_in_spa_lobby" );
	trig = GetEnt( "trig_e3_spa_area", "targetname" );

	
	
		trig waittill("trigger");

		if ( IsDefined(level.player.weapons_holstered) && level.player.weapons_holstered )
		{
			unholster_weapons();
		}
	
}




e3_push_cart( object )
{

	
	mantle_clip = getent("mantle_lock_clip", "targetname");
	mantle_clip delete();

	cart = object.primaryEntity;
	
	cart		= GetEnt( "csbm_e3_cart", "targetname" );
	cart_model	= GetEnt( "csm_e3_cart", "targetname" );
	cart_bag1	= GetEnt( "csm_e3_cart_bag1", "targetname" );
	cart_bag2	= GetEnt( "csm_e3_cart_bag2", "targetname" );
	cart_model	LinkTo( cart );
	cart_bag1	LinkTo( cart );
	cart_bag2	LinkTo( cart );

	destination = GetEnt( cart.target, "targetname" );

	physicsJolt( cart.origin, 64, 0, (0.0, 0.7, 0.0) );
	cart MoveTo( destination.origin, 0.5, 0.1, 0.0 );
	cart RotateTo( destination.angles, 1.0, 0.1, 0.0 );
	cart playsound ("CAS_laundry_cart_roll");

	wait(0.5);

	wait(0.5);
	
	push_pt = GetEnt( "cso_e3_locker_topple", "targetname" );
	physicsJolt( push_pt.origin, 32, 0, (0.1, -0.1, 0.0) );
	destination = GetEnt( destination.target, "targetname" );
	cart MoveTo( destination.origin, 0.3, 0.0 , 0.3 );
	cart RotateTo( destination.angles, 0.3, 0.0, 0.3 );

	
	cart_mantle	= GetEnt( "csbm_e3_cart_clip", "targetname" );	
	cart_mantle trigger_on();
}




e3_push_cart_filter( object )
{
	cart = object.primaryEntity;

	dot = VectorDot(AnglesToForward(cart.angles), AnglesToForward(level.player.angles));
	if ( dot > 0.7 )
	{
		return true;
	}
	else
	{
		return false;
	}
}




e3_push_blocker_cart( object )
{
	cart = object.primaryEntity;

	destination = GetEnt( "cso_e3_blockercart_stop", "targetname" );
	cart MoveTo( destination.origin, 2.0, 0.1, 1.0 );
	cart RotateTo( destination.angles, 2.0, 0.1, 1.0 );

	wait(1.0);

	door = GetEnt( "door_lockerroom", "targetname" );
	door._doors_barred = false;
}




e3_open_vent_locker( object )
{
	vent = object.primaryEntity;
	vent RotateTo( (0, 0, 90), 1.0, 0.5, 0 );
	maps\casino_amb::vent_rattle_locker_stop();
	vent playsound ("CAS_vent_open");
	vent notsolid();
	level notify( "vent_open_1_start" );
	wait(0.5);

	

	vent_clip = GetEnt( "csbm_e3_vent_clip", "targetname" );	
	vent_clip trigger_on();
}




e3_open_vent_spa( vent )
{
	
	vent RotateTo( (-90, 0, 0), 1.0, 0.5, 0 );
	maps\casino_amb::vent_rattle_spa_stop();
	
	vent playsound ("CAS_vent_fall");	

	level notify( "vent_open_2_start" );
	vent notsolid();
	level notify( "vent_open_1_start" );
	fx = playfx( level._effect["casino_fallthroughvent"], vent.origin ); 

	wait(0.5);

	SetSavedDVar("cover_dash_fromCover_enabled",true);
	SetSavedDVar("cover_dash_from1stperson_enabled",true);
}





display_map_spa()
{	
	wait( 1 );
	setSavedDvar( "sf_compassmaplevel",  "level3" );
}





e3_spin_fan()
{
	level endon( "flag_in_spa_lobby" );

	rotation = AnglesToForward( self.angles );
	pitch = self.angles[0];
	yaw = self.angles[1];
	roll = self.angles[2];
	
	if ( yaw > -5 && yaw < 5 )				
	{
		rotation = (  1,   0,   0);
	}
	
	else if ( yaw > 85 && yaw < 95  )
	{
		if ( int(roll) == 0 )
		{
			rotation = (  -1,   0,   0);
		}
		else if ( int(self.angles[2]) == 90 )
		{
			rotation = (  0,   1,   0);
		}
	}
	
	else if ( yaw > 175 && yaw < 185 )
	{
		rotation = ( -1,   0,   0);
	}
	
	else if ( yaw > 265 && yaw < 275 )
	{
		rotation = (  -1,  0,  0);
	}
	else
	{
		/#
			print("Invalid angle: " + yaw );
#/
		return;
	}

	rotation = rotation * 500.0;
	while ( 1 )
	{
		self rotateVelocity( rotation, 10.0 );
		wait(10.0);
	}
}





















































e3_confrontation()
{
	
	trig = GetEnt("trig_e3_vent", "targetname" );
	trig waittill( "trigger" );


	level thread maps\_autosave::autosave_now( "E3_vent" );


	
	
	
	
	
	setSavedDvar( "sf_compassmaplevel",  "level2" );
	

	level notify( "e3_vent_start" );

	
	level.oguy = maps\casino_util::spawn_guys( "cai_e3_oguy_die", true, "e3_ai", "thug_yellow" );
	level.oguy LockAlertState("alert_yellow" );
	level.oguy SetEnableSense( false );
	level.oguy thread e3_aimat_lcguy();

	
	trig = GetEnt("ctrig_e3_vent0", "targetname" );
	trig waittill( "trigger" );

	level thread maps\casino_pip::split_screen_spa_1();

	

	sorigin = GetEnt( "cso_door_crash", "targetname" );
	if ( IsDefined(sorigin) )
	{
		sorigin playsound( "CAS_door_crash" );
	}

	
	level.lcguys = maps\casino_util::spawn_guys_ordinal( "cai_e3_lcguy", 0, true, "e3_ai", "thug_yellow" );

	
	
	for ( i=0; i<level.lcguys.size; i++ )
	{
		if ( IsAlive(level.lcguys[i]) )	
		{
			level.lcguys[i]	setforcethreat( level.player,  true );
			level.lcguys[i]	thread magic_bullet_shield();
			level.lcguys[i]	LockAlertState("alert_yellow" );
			level.lcguys[i]	SetEnableSense( false );
		}
	}

	
	flag_init( "e3_player_hidden" );
	trig = GetEnt( "ctrig_e3_vent3", "targetname" );
	trig thread e3_magic_bullets();

	GetEnt( "ctrig_e3_vent0", "targetname" ) thread shoot_player_in_vent();
	GetEnt( "ctrig_e3_vent3", "targetname" ) thread shoot_player_in_vent();
	GetEnt( "ctrig_e3_vent4", "targetname" ) thread shoot_player_in_vent();
	GetEnt( "ctrig_e3_vent5", "targetname" ) thread shoot_player_in_vent();

	e3_faceoff( level.oguy, level.lcguys );
	
	thread e3_fight( level.oguy, level.lcguys );

	

}





e3_doorway_runner()
{
	

	


}


e3_aimat_oguy()
{
	if ( IsAlive(level.oguy) )
	{
		self CmdAimatEntity( level.oguy, true, -1 );
	}
}



e3_aimat_lcguy()
{
	while( !IsDefined(level.lcguys) )
	{
		wait( 0.1 );
	}
	if ( IsAlive(level.lcguys[1]) )
	{
		self CmdAimatEntity( level.lcguys[1], true, -1, 1 );
	}
}




e3_faceoff( oguy, lcguys )
{
	oguy endon( "alert_red" );
	oguy endon( "death" );

	for ( i=0; i<lcguys.size; i++ )
	{
		lcguys[i] endon( "alert_red" );
		lcguys[i] endon( "death" );
	}

	
	lcguys[1] CmdAction( "TalkA2", true );
	lcguys[1] maps\_utility::play_dialogue( "CMRC_CasiG01A_031A" );	
	lcguys[1] maps\_utility::play_dialogue( "CMRC_CasiG01A_032A" );	
	lcguys[1] StopCmd();

	
	oguy StopCmd();
	oguy CmdAction( "TalkA1", true );
	oguy maps\_utility::play_dialogue( "OBR6_CasiG01A_033A" );			
	oguy StopCmd();

	
	lcguys[1] maps\_utility::play_dialogue( "CMRC_CasiG01A_034A" );	
	lcguys[1] playsound( "wpn_a3raker_fire_ai" );
	lcguys[0] StopCmd();
	lcguys[2] StopCmd();
	

	
	flag_set( "e3_player_hidden" );
}





e3_announce_arrival()
{
	self endon( "death" );

	if ( RandomInt(100) < 50 )
	{
		self PlaySound( "CAS_big_door_01" );
		level.player PlaySound( "CAS_big_door_01" );	
	}
	else
	{
		self PlaySound( "CAS_big_door_02" );
		level.player PlaySound( "CAS_big_door_02" );	
	}

	wait( 1.0 );

	if ( self GetAlertState() == "alert_red" )
	{
		self thread maps\_utility::play_dialogue( "OSR3_CasiG01A_040A" );	
	}
}





e3_fight( oguy_die, lcguys )
{
	
	for ( i=0; i<lcguys.size; i++ )
	{
		lcguys[i].team = "allies";
	}

	
	tether_node = GetNode("cn_e3_lcguy_tether", "targetname" );
	if ( IsAlive( oguy_die ) )
	{
		
		
		oguy_die SetEnableSense( true );

		
		for ( i=0; i<lcguys.size; i++ )
		{
			if ( IsAlive( lcguys[i] ) )
			{
				lcguys[i] StopPatrolRoute();
				wait(0.05);
				lcguys[i] SetEnableSense( true );
				lcguys[i] cmdshootatentity( oguy_die, true, 1, 1 );
				lcguys[i] UnlockAlertState();
				lcguys[i] SetShootAllowed(false);

				node = GetNode( "LcGoal"+i, "targetname" );
				lcguys[i] SetGoalNode( node );
				
				lcguys[i].tetherradius	= 12*1;
				lcguys[i] SetPerfectSense(true);
				lcguys[i] SetIgnoreThreat(level.player, true );
				
				lcguys[i] LockAlertState("alert_red");
				lcguys[i] AddEngageRule("TgtPerceive");
			}
		}
	}

	if ( IsAlive(oguy_die) )
	{
		oguy_die DoDamage(1000, oguy_die.origin );
	}
	wait( 1 );

	ent = GetEnt( "cso_e3_splash", "targetname" );
	ent playsound( "CAS_pool_splash" );

	maps\casino_util::spawn_guys( "cai_e3_oguy_start", true, "e3_obanno_ai", "thug_red" );
	
	maps\casino_util::Ai_SetEveryAiAccuracy(GetAIArray(), 0);

	
	wait(0.1);
	level.oguys = [];
	ents = GetAIArray();
	ents = array_removedead(ents);
	for ( i=0; i<ents.size; i++ )
	{
		if ( IsDefined(ents[i].groupname) && ents[i].groupname == "e3_obanno_ai" )
		{
			level.oguys[level.oguys.size] = ents[i];
			ents[i] thread magic_bullet_shield();			
		}
	}
	wait( 1 );	

	
	if ( flag( "e3_player_hidden" ) )
	{
		wait( 1.0 );
		for ( i=0; i<lcguys.size; i++ )
		{
			if ( IsAlive(lcguys[i]) )	
			{
				level.lcguys[i] thread maps\casino_util::play_dialog( "CMRC_CasiG01A_036A" );	
				break;
			}
		}
	}

	

	trig = GetEnt( "trig_e3_prep_spa_scene", "targetname" );
	trig waittill( "trigger" );

	
	if (!IsDefined(lcguys[1]) || !IsAlive(lcguys[1]))
	{
		spawner = GetEnt("cai_e3_lcguy1", "targetname");
		spawner.count++;
		lcguys[1] = spawner StalingradSpawn();

		if (!spawn_failed(lcguys[1]))
		{
			lcguys[1] thread magic_bullet_shield();
		}
	}

	if (!IsDefined(lcguys[2]) || !IsAlive(lcguys[2]))
	{
		spawner = GetEnt("cai_e3_lcguy2", "targetname");
		spawner.count++;
		lcguys[2] = spawner StalingradSpawn();

		if (!spawn_failed(lcguys[2]))
		{
			lcguys[2] thread magic_bullet_shield();
		}
	}

	lcguys[1] thread e3_spa_death( "cn_e3_lcguy_death" );
	lcguys[2] thread e3_spa_death( "cn_e3_lcguy2_death" );

	
	flag_wait( "flag_in_spa_lobby" );

	
	wait(0.5); 

	
	level thread help_function();

	
	level notify("spa_wall_start");
	level notify("playmusicpackage_spa");

	
	
	wait(2.3);
	lcguys[1].targetname = "thug1";
	lcguys[2].targetname = "thug2";
	
	PlayCutscene("two_thug_death", "scene_anim_done");
	wall = GetEnt( "fxanim_spa_wall", "targetname" );
	wall playsound( "CAS_spa_wall" );

	level waittill( "scene_anim_done" );
	level thread maps\_autosave::autosave_now( "E3");	
	

	
	

	if( IsDefined( level.lcguys[0] ) )
	{
		
		level.lcguys[0].health = 1;
	}
	

	wait( 1.5 );
	
	
	for( i=0; i<level.oguys.size; i++ )
	{
		level.oguys[i] notify( "stop magic bullet shield" );
		level.oguys[i] thread maps\casino_util::Ai_SetPerfectSenseUntillThreatIsPlayer(5);
	}

	level.lcguys[0] notify( "stop magic bullet shield" );
	
	maps\casino_util::Ai_SetEveryAiAccuracy(GetAIArray(), 1);
	level thread e3_remove_tethers(); 

	
	oguys = maps\casino_util::spawn_guys( "cai_e3_oguy_right", true, "e3_obanno_ai", "thug_red" );
	
	for( i=0; i<oguys.size; i++ )
	{
		oguys[i] thread maps\casino_util::Ai_SetPerfectSenseUntillThreatIsPlayer(5);
	}

	level.oguys = maps\casino_util::array_add_Ex( level.oguys, oguys );
	while (1)
	{
		level.oguys = array_removeDead( level.oguys );

		if ( level.oguys.size <= 2 )
		{
			wait( 1.0 );

			
			
			GetEnt("force_next_wave", "targetname") wait_for_trigger_or_timeout(5); 

			new_guys = maps\casino_util::spawn_guys( "cai_e3_oguy_barricade2", true, "e3_ai", "thug_red");
			for (i = 0; i < new_guys.size; i++)
			{
				new_guys[i] thread spa_hack();
				new_guys[i] maps\casino_util::SetPerfectSenseTimer(5.0);
			}
			level.oguys = maps\casino_util::array_add_Ex( level.oguys, new_guys );

			wait( 2.0 );
			break;
		}

		wait (0.25);
	}

	
	last_guy = false;
	while (1)
	{
		level.oguys = array_removeDead( level.oguys );

		if ( level.oguys.size <= 0 )
		{
			level thread e3_final_spawn();
			flag_set( "obj_spa_exit_open" );
			break;
		}

		wait( 1.0 );
	}

}



spa_hack()
{
	self endon("death");
	self waittill("goal");

	if (!IsDefined(level.spa_hack))
	{
		level.spa_hack = 0;
	}

	level.spa_hack++;

	if (level.spa_hack == 3)
	{
		blocker = GetEnt("spa_exit_blocker", "targetname");
		blocker trigger_on();
		blocker DisconnectPaths();
		blocker trigger_off();
	}
}


e3_remove_tethers()
{
	GetEnt("spa_exit", "targetname") waittill("trigger");

	ai = GetAIArray();
	for (i = 0; i < ai.size; i++)
	{
		ai[i] SetTetherRadius(2000);
	}

	GetEnt("spa_exit2", "targetname") waittill("trigger");

	blocker = GetEnt("spa_exit_blocker", "targetname");
	blocker trigger_on();
	blocker ConnectPaths();
	blocker delete();
}





help_function()
{
	


	


	
	level.player playsound ("CAS_big_door_01");
	wait( 0.2 );

	level.player playsound ("CAS_chandelier_fancy_sml_crash");
	earthquake( 0.3, 2.5, level.player.origin, 850 );
	level.player shellshock("default", 6);
	wait( 0.2 );
	

	
	wait( 0.1 );
	earthquake( 0.3, 2.5, level.player.origin, 850 );

	
	
	wait( 0.4 );

	
	level.player setorigin((-624.0, 1664.0, 736.0));
}







e3_magic_bullets()
{
	self waittill ( "trigger" );
	

	start_ent	= GetEnt( "cso_e3_bullet_hole", "targetname" );
	
	for ( i=0; i<5; i++ )
	{
		x = randomfloatrange(0.0,30.0);
		z = randomfloatrange(-8.0, 8.0);
		
		
		firepos = start_ent.origin + ( (i*40.0)+x+3, 0, 15-(i*8) );
		hitpos = firepos + ( 0, -3, 0);
		magicbullet("SAF9_Casino_s", firepos, hitpos);

		fx_spawn = Spawn( "script_model", hitpos+(0,4,0) );	
		fx_spawn SetModel( "tag_origin" );
		fx_spawn.angles = start_ent.angles+( randomfloatrange(-5.0, 5.0), 0,0);
		fx = playfxontag( level._effect["casino_vent_bullet_vol"], fx_spawn, "tag_origin" );
		fx_spawn thread impact_bullet_sound();

		wait( 0.1 );
	}
	
	start_ent	= GetEnt( "cso_e3_bullet_hole2", "targetname" );
	
	for ( i=0; i<1; i++ )
	{
		x = randomfloatrange(0.0,30.0);
		z = randomfloatrange(-5.0, 5.0);
		
		
		firepos = start_ent.origin + ( (i*40.0)+x+3, 0, 15-( (i+4)*8) );
		hitpos = firepos + ( 0, -3, 0);
		magicbullet("SAF9_Casino_s", firepos, hitpos);

		fx_spawn = Spawn( "script_model", hitpos+(0,1,0) );	
		fx_spawn SetModel( "tag_origin" );
		fx_spawn.angles = start_ent.angles+( randomfloatrange(-5.0, 5.0), 0,0);
		fx = playfxontag( level._effect["casino_vent_bullet_vol"], fx_spawn, "tag_origin" );
		fx_spawn thread impact_bullet_sound();

		wait( 0.1 );
	}
}




shoot_player_in_vent()
{
	level endon("flag_in_spa_lobby");

	if ( !IsDefined( level.player_seen_in_vent ) )
	{
		level.player_seen_in_vent = 0;
	}

	while ( 1 )
	{
		self waittill( "trigger" );

		time_start = GetTime();
		while ( level.player IsTouching(self) )
		{
			if ( GetTime() > time_start + 10000 )
			{
				level.player_seen_in_vent++;

				level.player PlaySound("VENT_CasiG02A_999A");	
				old_player_pos = level.player.pos;
				wait 3.0;

				hitpos = undefined;
				for ( i=0; i<5; i++ )
				{
					x = randomfloatrange(-5.0, 5.0);
					y = randomfloatrange(-5.0, 5.0);
					
					
					
					if ( level.player IsTouching(self) || level.player_seen_in_vent >= 3 )
					{
						firepos = level.player.origin + AnglesToForward(level.player.angles) * (i * 6 + RandomInt(6));
					}
					else
					{
						firepos = old_player_pos + (-1,0,0) * (i * 40 + RandomInt(20));
					}
					trace = bullettrace(firepos + (0, 0, 10), firepos + (0, 0, -100), false, undefined);
					hitpos = trace["position"] + (x, y, -3);
					magicbullet("SAF9_Casino_s", firepos, hitpos);

					fx_spawn = Spawn( "script_model", hitpos+(0,0,4) );	
					fx_spawn SetModel( "tag_origin" );
					
					fx_spawn.angles = (-90, x, x);
					fx = playfxontag( level._effect["casino_vent_bullet_vol"], fx_spawn, "tag_origin" );
					fx_spawn thread impact_bullet_sound();

					if ( level.player IsTouching(self) || level.player_seen_in_vent >= 3 )
					{
						level.player DoDamage(20, hitpos);
					}
					wait( 0.1 );
				}

				
				if ( level.player_seen_in_vent == 3 )
				{
					level.player DoDamage(level.player.health * 2, level.player.origin);
				}

				break;
			}

			wait( 0.05 );
		}
	}
}





impact_bullet_sound()
{
	wait( 0.2 );
	level.player playsound ("bulletspray_large_metal");
	level.player playsound ("whizby");
}





e3_spa_death( nodename )
{
	node = GetNode(nodename, "targetname" );

	
	
	wait(0.05);
	self.tetherpt = node.origin;
	self.tetherradius = 100;

	
	

	sticky_origin = Spawn("script_origin", self.origin);
	sticky_origin.angles = self.angles;
	self LinkTo(sticky_origin);
	sticky_origin MoveTo(   node.origin, 1.0 );
	wait( 1.0 );

	
	self Unlink();
	sticky_origin delete();
	self.tetherradius = 16;
	flag_wait( "flag_in_spa_lobby" );

	self teleport( node.origin, node.angles );
	
	level waittill( "scene_anim_done" );
	
	
	if ( IsAlive(self) )
	{
		self notify( "stop magic bullet shield" );
	}
	self SetDeathEnable(false);
	self SetPainEnable(false);
	
	
	
	

	self SetDeathEnable(true);
	self SetPainEnable(true);
	self DoDamage( 10000, self.origin );
}





e3_final_spawn()
{
	wait( 1.0 );

	
	

	new_guys = maps\casino_util::spawn_guys( "cai_e3_oguy_doormen", true, "e3_ai", "thug_red" );

	for(i=0;i<new_guys.size; i++)
	{
		new_guys[i] maps\casino_util::SetPerfectSenseTimer(5.0);
	}

	wait(3);

	if (IsDefined(new_guys[0]) && IsAlive(new_guys[0]))
	{
		new_guys[0] maps\_utility::play_dialogue( "OSR3_CasiG01A_040A" );	
		wait(0.5);

		if (IsDefined(new_guys[1]) && IsAlive(new_guys[1]))
		{
			new_guys[1] maps\_utility::play_dialogue( "OSR4_CasiG01A_041A" );	
			wait(0.5);
		}
	}

	while (1)
	{
		enemies = GetAIArray();
		if ( enemies.size == 0 )
		{
			wait( 2.0 );

			enemies = GetAIArray();
			if ( enemies.size == 0 )
			{
				level notify("endmusicpackage");
				break;
			}
		}
		wait( 1.0 );
	}
}





e4_main()
{
	level notify( "e4_start" );

	
	level notify("drapes_2_start");

	
	thugs = maps\casino_util::spawn_guys( "cai_e4", true, "e4_ai", "thug" );
	maps\casino_util::reinforcement_update( "cai_e4_reinforcements", "e4_ai", false );
	thread e4_conversation( thugs );
	if (isdefined(thugs[1]))	thugs[1] e2_set_balcony_qk(); 

	
	flag_wait( "obj_detour2_end");
	level thread e4_force_cover();

	
	level thread e5_main();

	
	level waittill( "e6_start" );
	maps\casino_util::delete_group( "e4_ai" );
	maps\casino_util::delete_group( "e4_ai_ledge" );
}
e4_force_cover()
{

	trigger = getent("balcony_2_force_cover", "targetname");
	trigger waittill("trigger");

	while ( !level.player isOnGround() )
	{
		wait( 0.05 );
	}

	
	
	
	
	
	level.player setstance("crouch");
}



e4_conversation( talkers )
{
	for ( i=0; i<talkers.size; i++ )
	{
		talkers[i] endon( "alert_yellow" );
		talkers[i] endon( "alert_red" );
		talkers[i] endon( "death" );
		talkers[i] thread maps\casino_util::play_dialog_monitor( "conversation_done" );
		talkers[i] thread e4_kill_conversation(talkers);
	}

	talkers[1] maps\_utility::play_dialogue( "BCR2_CasiG01A_043A" );	
	talkers[0] maps\_utility::play_dialogue( "BCR1_CasiG01A_044A" );	

	talkers[1] maps\_utility::play_dialogue( "BCR2_CasiG01A_045A" );	
	talkers[1] notify( "conversation_done" );

	talkers[0] maps\_utility::play_dialogue( "BCR1_CasiG01A_046A" );	
	talkers[0] notify( "conversation_done" );

}

e4_kill_conversation(talkers)
{
	self endon("conversation_done");
	self waittill_any("death", "alert_red", "alert_yellow");
	
	for ( i=0; i<talkers.size; i++ )
	{	
		if(isdefined(talkers[i]))
		{
		talkers[i] playsound("null_voice");
		}
	}
}	




e4_set_combat_tether( )
{
	level endon( "e5_start" );

	
	level waittill( "reinforcement_spawn" );

	wait(1.0);	

	
	tether = GetNode( "pn_e4_balcony", "targetname" );
	ents = GetAIArray();
	for ( i=0; i<ents.size; i++ )
	{
		if ( IsDefined(ents[i].groupname) && ents[i].groupname == "e4_ai" )
		{
			ents[i].tetherpt = tether.origin;
			ents[i].tetherradius = 500;
		}
	}
}





e5_main()
{
	level notify( "e5_start" );

	wait( 0.1 );
	
	thugs = maps\casino_util::spawn_guys_ordinal( "cai_e5_", 0, true, "e5_ai", "thug" );

	
	
	
	
	

	level thread e5_conversation( thugs );

	level notify("playmusicpackage_stealth");

	flag_wait("cf_e5_patrol" );

	
	level.special_autosavecondition = maps\casino_util::check_no_enemies_alerted;
	level thread maps\_autosave::autosave_by_name( "e5", 5.0 );

	wait( 0.1 );	
	maps\casino_util::reinforcement_update( "cai_e5_reinforcements", "e5_ai", false );

	
	
	
	
	

	
	lock = GetEnt( "e6_door_button", "targetname" ) maps\_unlock_mechanisms::setup_lock("eleclock_1");
	

	
	trig = GetEnt("ctrig_e6_hallway", "targetname" );
	trig waittill( "trigger" );

	
	level.special_autosavecondition = undefined;

	level thread e5_tanner();

	level thread e6_main();

	
	level waittill( "e6_inside_ballroom" );

	maps\casino_util::delete_group( "e5_ai" );
}





e5_conversation( thugs )
{
	for ( i=0; i<thugs.size; i++ )
	{
		thugs[i] endon("death");
		thugs[i] endon("alert_yellow");
		thugs[i] endon("alert_red");
	}
	flag_wait("cf_e5_patrol" );

	level notify( "playmusicpackage_stealth" );

	
	if ( level.reinforcement_activated )
	{
	thugs[0] maps\_utility::play_dialogue( "STR1_CasiG01A_048A" );	
	thugs[1] maps\_utility::play_dialogue( "STR2_CasiG01A_049A" );	
	thugs[0] maps\_utility::play_dialogue( "STR1_CasiG01A_050A" );	
	}
	else
	{
		for ( i=0; i<thugs.size; i++ )
		{
			thugs[i] endon("death");
			thugs[i] endon("alert_yellow");
			thugs[i] endon("alert_red");
		}

		thugs[1] maps\_utility::play_dialogue( "STR2_CasiG01A_051B" );	
		thugs[0] maps\_utility::play_dialogue( "STR1_CasiG01A_052B" );	
		thugs[1] maps\_utility::play_dialogue( "STR2_CasiG01A_053B" );	
		thugs[0] maps\_utility::play_dialogue( "STR1_CasiG01A_054B" );	
	}

	thugs[0] StartPatrolRoute( "cpat_e5_northroom" );
	thugs[1] StartPatrolRoute( "cpat_e5_patrolintro" );
	thugs[1] thread e5_alter_route();
}



e5_tanner()
{
	level.player maps\_utility::play_dialogue( "TANN_CasiG01A_055A" );	
	wait(0.5);
	level.player maps\_utility::play_dialogue( "BOND_CasiG01A_056A" );	
	wait(0.5);
	level.player maps\_utility::play_dialogue( "TANN_CasiG01A_057A" );	
}





e5_alter_route()
{
	self endon("death");
	self endon("alert_yellow");
	self endon("alert_red");

	trig = GetEnt( "ctrig_e5_start_patrol", "targetname" );
	trig waittill( "trigger" );

	
	
	self StartPatrolRoute( "cpat_e5_patrol1" );
}





e6_main()
{
	level notify( "reinforcement_stop" );
	level notify( "e6_start" );

	
	entrance_door1 = GetEnt( "door_e6_ballroom_entrance", "targetname" );
	entrance_door2 = GetEnt( "door_e6_ballroom_entrance2", "targetname" );
	
	
	entrance_door1 maps\_doors::barred_door();
	entrance_door2 maps\_doors::barred_door();

	flag_init( "e6_start_shooting" );
	flag_init( "e6_start_dialog" );

	

	level thread kickover_table_setup();
	level thread e6_chandelier_trap();
	
	array_thread( GetEntArray("fxtrig_damage", "targetname"), ::e6_banner_drop );

	
	maps\_playerawareness::setupSingleUseOnly(
		"e6_door_button",				
		::e6_hack_door_control,			
		&"CASINO_HINT_OPEN_ENTRANCE",	
		0,								
		"",								
		false,						   	
		true,							
		undefined,						
		level.awarenessMaterialNone,	
		true,							
		false,						   	
		false );					   	

	
	flag_wait( "obj_unlock_entrance_end" );

	
	
	
	
	entrance_door1 maps\_doors::unbarred_door();
	entrance_door2 maps\_doors::unbarred_door();


	
	e6_thugs	= maps\casino_util::spawn_guys( "cai_e6", true, "e6_ai", "thug_yellow" );
	
	thugs		= maps\casino_util::spawn_guys( "cai_e6_delayed", true, "e6_ai", "thug_yellow" );
	
	
	
	
	

	e6_thugs	= maps\casino_util::array_add_Ex( e6_thugs, thugs );

	blockers = GetEnt("ballroom_ai_blockers", "targetname");
	blockers ConnectPaths();
	blockers trigger_off();


	
	
	level.e6_runner = maps\casino_util::spawn_guys( "cai_e6_runner", true, "e6_ai", "thug_yellow" );

	
	
	level.e6_leader	= maps\casino_util::spawn_guys( "cai_e6_leader", true, "e6_ai", "thug_yellow" );

	
	

	
	wait(0.1);	
	level thread e6_intro_setup();

	
	level e6_intro( e6_thugs );
	level notify( "lechiffre_exit" );

	level thread e6_ballroom_fight( e6_thugs );

	trig = GetEnt( "ctrig_e6_final_door", "targetname" );
	trig waittill( "trigger" );

	flag_set("obj_hack_door_end");

	
	trig = GetEnt("ctrig_e7_obanno", "targetname" );
	trig waittill( "trigger" );

	SaveGame("e7");
	level thread e7_main();

	
	maps\casino_util::delete_group( "e6_ai" );
}



e6_hack_door_control(strcObject)
{
	if ( !flag( "obj_unlock_entrance_start" ) )
	{
		flag_set( "obj_unlock_entrance_start" );
	}

	level.byPassPhoneIsRaised = true;
	
	control = strcObject.primaryEntity;
	control endon( "hacked" );

	entOrigin = spawn("script_origin", level.player.origin + ( 0, 0, 7 ));
	entOrigin.targetname = "special_lockpick_origin";
	entOrigin.angles = level.player GetPlayerAngles();

	control.lockparams = "complexity:2 speed:3 code:6";

	if( control maps\_unlock_mechanisms::unlock_electronic() )
	{
		wait( 0.15 );

		entOrigin Delete();

		flag_set( "obj_unlock_entrance_end" );

		control notify( "hacked" );
		control notify( "sound_done" );
	}
	else
	{
		wait( 0.15 );

		entOrigin Delete();

		maps\_playerawareness::setupSingleUseOnly( 
			"e6_door_button",				
			::e6_hack_door_control,			
			&"CASINO_HINT_OPEN_ENTRANCE",	
			0,								
			"",								
			true,						   	
			true,							
			undefined,						
			level.awarenessMaterialNone,	
			true,							
			false,						   	
			false );					   	
	}
}





e6_chandelier_drop()
{
	level endon("cf_e6_chandelier_fell");

	trig = GetEnt( "ctrig_e6_chandelier_lookat", "targetname" );
	trig waittill( "trigger" );

	dmg_trig = GetEnt( "trap_e6_chandelier", "targetname" );
	dmg_trig notify( "trigger" );
}





e6_chandelier_trap()
{
	flag_init("cf_e6_chandelier_fell");

	before_sbm	= GetEnt("csbm_e6_piano", "targetname" );
	after_sbm	= GetEnt("csbm_e6_piano_dmg", "targetname" );
	after_sbm ConnectPaths();
	after_sbm trigger_off();

	trig = GetEnt( "trap_e6_chandelier", "targetname" );
	trig waittill( "trigger" );

	flag_set("cf_e6_chandelier_fell");
	trig playsound( "CAS_piano_crash" );
	chandelier_light = GetEnt( "light_e6_chandelier", "targetname" );
	chandelier_light setlightintensity( 0.0 );

	level notify( "piano_chandelier_start" );	
	level notify("piano_chandelier_d_start");

	wait(2.6);
	damage_spot = GetEnt( "cso_e6_chandelier_trap", "targetname" );
	if ( IsDefined( damage_spot ) )
	{
		RadiusDamage( damage_spot.origin, 125, 200, 100 );
		earthquake( 0.2, 1, damage_spot.origin, 5000);
	}

	after_sbm trigger_on();
	after_sbm DisConnectPaths();

	if (level.player IsTouching(after_sbm))
	{
		level.player DoDamage(level.player.health * 2, (0, 0, 0));	
	}

	before_sbm delete();
}






e6_banner_drop()
{
	if ( IsDefined(self.script_parameters) )
	{
		self waittill( "trigger" );

		level notify( self.script_parameters );
		self playsound( "CAS_banner_big_fall" );
		
	}
}





e6_lechiffre()
{

	
	
	lechiffre_guards	= maps\casino_util::spawn_guys_ordinal( "cai_e6_lechiffre_escort", 1, true, "e6_ai", "thug" );
	for ( i=0; i<lechiffre_guards.size; i++ )
	{
		lechiffre_guards[i] LockAlertState("alert_yellow");
		lechiffre_guards[i] thread maps\casino_util::delete_on_goal();
	}
	
	lechiffre_guards[1] setenablesense( false );


	
	
	lechiffre			= maps\casino_util::spawn_guys( "cai_e6_lechiffre", true, "e6_ai", "civ" );
	lechiffre LockAlertState("alert_yellow");
	lechiffre thread maps\casino_util::delete_on_goal();
	lechiffre setenablesense( false );

	level waittill( "lechiffre_exit" );

	
	node = GetNode( "cn_e6_lechiffre_suite", "targetname" );
	lechiffre SetGoalNode( node );
	for ( i=0; i<lechiffre_guards.size; i++ )
	{
		lechiffre_guards[i] SetGoalNode( node );
	}

	wait( 8 );
	exit_door1 = GetEnt( "door_e6_ballroom", "targetname" );
	exit_door2 = GetEnt( "door_e6_ballroom2", "targetname" );

	
	
	exit_door1 maps\_doors::barred_door();
	exit_door2 maps\_doors::barred_door();
	
}





e6_intro( e6_thugs )
{
	level endon( "reinforcement_spawn" ); 

	level notify( "e6_intro_start" );

	
	ballroom_speaker = undefined;	
	for ( i=0; i<e6_thugs.size; i++ )
	{
		if ( IsDefined( e6_thugs[i].script_parameters ) &&
			e6_thugs[i].script_parameters == "intro_speaker" )
		{
			ballroom_speaker = e6_thugs[i];
			ballroom_speaker endon( "death" );
			break;
		}
	}

	wait(5.0);

	level.e6_runner maps\_utility::play_dialogue( "SRC1_CasiG01A_058A" );	
	ballroom_speaker maps\_utility::play_dialogue( "BRR1_CasiG01A_059A" );	
	level.e6_runner maps\_utility::play_dialogue( "SRC1_CasiG01A_062A" );	
	level.e6_leader maps\_utility::play_dialogue( "OBAN_CasiG01A_063A" );	
	ballroom_speaker maps\_utility::play_dialogue( "BRR1_CasiG01A_064A" );	
}


e6_intro_setup()
{
	
	skipto = GetDVar( "skipto" );
	
	






	
	level.player freezeControls(true);
	level.player playerSetForceCover( true, (0, -1, 0) );
	level.player setstance("crouch");

	start_pos = GetNode( "cn_e6_start", "targetname" );
	level.player setorigin(start_pos.origin);
	level.player setplayerangles(start_pos.angles);

	wait( 1 );	
	
	preballroom_cam = level.player customCamera_Push( "world", ( -3715.0, 1788, 835), (0,235,0) , 0.0);
	wait(1.5); 
	
	
	
	
	
	level.player customcamera_change(preballroom_cam, "world", ( -3775.0, 1700.0, 800.0), (0.0,180.0,0.0), 3.5);

	level waittill("lechiffre_exit");


	level.player playerSetForceCover( false, false ); 
	level.player freezeControls(false);

	level.player customCamera_pop( preballroom_cam, 1.0 );
	
	level thread maps\_autosave::autosave_now( "e6" );
}





e6_ballroom_watcher()
{
	level endon( "reinforcement_spawn" );

	
	
	

	
	while (Isalive(	level.e6_runner ) )
	{
		wait( 0.1 );
	}

	if( !	flag( "e6_start_dialog" ))
	{
		flag_set( "e6_start_dialog" );
		level.player maps\_utility::play_dialogue( "BRR2_CasiG01A_065A" );	
		level.player maps\_utility::play_dialogue( "BRR3_CasiG01A_066A" );	
	}

	ais = GetAIArray();
	for ( i=0; i<ais.size; i++ )
	{
		ais[i] thread maps\casino_util::reinforcement_awareness();
	}
}




e6_ballroom_fight( e6_thugs )
{
	level thread e6_ballroom_doors();	

	level thread e6_ballroom_watcher();
	level waittill( "reinforcement_spawn" );

	flag_set( "e6_start_shooting" );
	flag_set("obj_hack_door_start");


	level thread e6_enemy_controller( e6_thugs );
	
	
	level notify( "playmusicpackage_ballroom" );

	if(!flag( "e6_start_dialog" ))
	{
		flag_set( "e6_start_dialog" );
	
		level.player maps\_utility::play_dialogue( "BRR2_CasiG01A_065A" );	
		level.player maps\_utility::play_dialogue( "BRR3_CasiG01A_066A" );	
	}

}



e6_ballroom_doors()
{
	
	trig = GetEnt("ctrig_e6_con_room_inside", "targetname" );
	trig waittill( "trigger" );

	level notify( "e6_inside_ballroom" );

	
	entrance_door1 = GetEnt( "door_e6_ballroom_entrance", "targetname" );
	entrance_door2 = GetEnt( "door_e6_ballroom_entrance2", "targetname" );

	level thread display_map_mainhall_second_floor();

	
	entrance_door1 thread maps\_doors::close_door();
	entrance_door2 thread maps\_doors::close_door();

	
	
	
	entrance_door1 maps\_doors::barred_door();
	entrance_door2 maps\_doors::barred_door();

	
	if( !	flag( "e6_start_shooting" ))
	{
		ais = GetAIArray();
		for ( i=0; i<ais.size; i++ )
		{
			ais[i] thread maps\casino_util::reinforcement_awareness();
		}
	}
	
	if( !	flag( "e6_start_dialog" ))
	{
		flag_set( "e6_start_dialog" );
		level.player maps\_utility::play_dialogue( "BRR2_CasiG01A_065A" );	
		level.player maps\_utility::play_dialogue( "BRR3_CasiG01A_066A" );	
	}
}



kickover_table_setup( )
{

	table_origins = GetEntArray( "kickover_table_origin", "targetname" );
	for ( i=0; i<table_origins.size; i++)
	{
		table = GetEnt( table_origins[i].target, "targetname" );

		
		attachments = GetEntArray( table.target, "targetname" );
		for ( j=0; j<attachments.size; j++ )
		{
			attachments[j] LinkTo(table);
		}

		
		yaw = table_origins[i].angles[1];
		while ( yaw > 359 )
		{
			yaw = yaw - 360;
		}
		while ( yaw < 0 )
		{
			yaw = yaw + 360;
		}
		
		if ( yaw > -5 && yaw < 5 )				
		{
			rotate_angles = (  -90,   0,   0);
		}
		
		else if ( yaw > 40 && yaw < 50  )
		{
			rotate_angles = ( 315, 315,   90);
		}
		
		else if ( yaw > 85 && yaw < 95  )
		{
			rotate_angles = (   0,   0, 90);
		}
		
		else if ( yaw > 130 && yaw < 140  )
		{
			rotate_angles = (  45,  45,  90);
		}
		
		else if ( yaw > 175 && yaw < 185 )
		{
			rotate_angles = ( 90,   0,   0);
		}
		
		else if ( yaw > 220 && yaw < 230  )
		{
			rotate_angles = (  45, 315, -90);
		}
		
		else if ( yaw > 265 && yaw < 275 )
		{
			rotate_angles = (   0,   0, -90);
		}
		
		else if ( yaw > 310 && yaw < 320 )
		{
			rotate_angles = ( 315,  45, -90);
		}
		else
		{
			/#
				
#/
			return;
		}
		table RotateTo( rotate_angles, 0.05, 0.0, 0.0 );

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		table_origins[i] thread kickover_table();
		
	}
}





use_kickover_table( player )
{
	script_origin = self.entity;

	table = GetEnt( script_origin.target, "targetname" );
	switch( RandomInt(3) )
	{
	case 0:
		table playsound( "CAS_table_01" );
		break;
	case 1:
		table playsound( "CAS_table_02" );
		break;
	case 2:
		table playsound( "CAS_table_03" );
		break;
	}
	table RotateTo( (0,0,0), 0.5, 0.2, 0.0 );
	force = AnglesToForward( (0, script_origin.angles[1], 45) ) * 1.5;
	physicsJolt( script_origin.origin, 64, 0, force );
}






kickover_table( )
{
	table = GetEnt( self.target, "targetname" );

	
	
	
	
	wait( RandomFloatRange(0.1, 1.0) );	
	table RotateTo( (0,0,0), 0.5, 0.2, 0.0 );
	force = AnglesToForward( (0, self.angles[1], 45) ) * 1.5;
	physicsJolt( self.origin, 64, 0, force );
}





e6_aimat_player()
{
	self endon( "death" );

	self SetPerfectSense( true );
	wait( 2.0 );

	self SetPerfectSense( false );
	self SetScriptSpeed( "run" );
	self setignorethreat( level.player, true );
	self waittill("goal");

	self CmdAimatEntity( level.player, true, -1 );
	flag_wait( "e6_start_shooting" );

	self stopallcmds();
	self setignorethreat( level.player, false );
}





e6_lock_lechiffre_doors()
{
	trig = GetEnt( "ctrig_e6_final_door", "targetname" );
	trig waittill( "trigger" );

	wait(10.0);	

	
	
	exit_door1 = GetEnt( "door_e6_ballroom", "targetname" );
	exit_door2 = GetEnt( "door_e6_ballroom2", "targetname" );
	exit_door1._doors_locked = true;
	exit_door2._doors_locked = true;
}


WaitLessThanEqualAlive(thugs, count, timeout)
{	
	waitTime = 0.1;

	if( !IsDefined(timeout) )
	{
		timeout = 10000000;		
	}

	while ( thugs.size > count && timeout > 0 )
	{
		wait(waitTime);

		thugs = array_removeDead( thugs );
		
		timeout -= waitTime;
	}
}




E6Wave2Rusher()
{
	self endon("death");

	
	self SetPerfectSense(1);		

	self.tetherradius = -1;

}




E6Wave2PickRusher( wave_2 )
{		
	chosen = wave_2[0];
	for( i=0; i<10; i++ )
	{
		attempt = wave_2[randomint(wave_2.size)];
		if( IsDefined(chosen) && chosen.tetherradius > 0 )
		{
			chosen = attempt;
		}
	}

	return chosen;
}




E6Wave2TetherTweaker(time0, time1, rate0, rate1)
{
	self endon("death");

	
	wait( RandomFloatRange( time0, time1 ) );

	while(1)
	{
		self.tetherradius += RandomFloatRange( rate0, rate1 );		

		wait(1);
	}
}




E6Wave2AutoRusher( wave_2, time0, time1, rate0, rate1)
{
	for( i=0; i < wave_2.size ; i++ )
	{	
		if( IsDefined(wave_2[i]) )
		{		
			wave_2[i] thread E6Wave2TetherTweaker( time0, time1, rate0, rate1);
		}
		
		
	}
}




 
 _IsLeftFarter( spawnersLeftName, spawnersRightName )
 { 
	spawnersLt = GetEntArray( spawnersLeftName, "targetname" );
	distLt     = DistanceSquared(spawnersLt[0].origin, self.origin);

	spawnersRt = GetEntArray( spawnersRightName, "targetname" );
	distRt     = DistanceSquared(spawnersRt[0].origin, self.origin);

	return distLt > distRt;
 }







e6_enemy_controller( enemies )
{
	level endon( "e7_start" );

	trig_east		= GetEnt( "ctrig_e6_east_side",			"targetname" );
	trig_west		= GetEnt( "ctrig_e6_west_side",			"targetname" );
	trig_northwest	= GetEnt( "ctrig_e6_northwest_side",	"targetname" );

	
	

	
	

	
	wait 1;
	center_of_room = GetEnt("center_of_room", "targetname").origin;
	for (i = 0; i < enemies.size; i++)
	{
		if (IsDefined(enemies[i]))
		{
			enemies[i].tetherpt = center_of_room;
			enemies[i].tetherradius = 450; 
			
		}
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	
	
	
	
	
	blockers = GetEnt("ballroom_ai_blockers", "targetname");
	blockers trigger_on();
	blockers DisconnectPaths();

	flag_wait("cai_e6_wave1_cleared");

	
	blockers ConnectPaths();
	blockers delete();

	

	
	next_wave_trig = Spawn("trigger_radius", center_of_room, 0, 300, 100);	

	
	
	
	
	
	
	

	

	

	level thread maps\_autosave::autosave_now( "E6B" );

	wait( 2.0 );	

	
	if( level.player _IsLeftFarter("cai_e6_wave2a", "cai_e6_wave2b") )
	{
		wave_2a   = maps\casino_util::spawn_guys( "cai_e6_wave2a", true, "e6_ai", "thug_red" );

		WaitLessThanEqualAlive(wave_2a, 1, 10);
		
		

		wave_2b = maps\casino_util::spawn_guys( "cai_e6_wave2b", true, "e6_ai", "thug_red" );
	}
	else
	{	
		wave_2b  = maps\casino_util::spawn_guys( "cai_e6_wave2b", true, "e6_ai", "thug_red" );		

		WaitLessThanEqualAlive( wave_2b, 1, 10);
		
		

		wave_2a = maps\casino_util::spawn_guys( "cai_e6_wave2a", true, "e6_ai", "thug_red" );
	}

	wave_2  = maps\casino_util::array_add_Ex( wave_2a, wave_2b );

	thread E6Wave2AutoRusher( wave_2, 15.0, 30.0, 12*0.5, 12*3 );

	enemies = maps\casino_util::array_add_Ex( enemies, wave_2    );

	
	
	
	enemies = array_removeDead( enemies);
	
	
	
	level.player PlaySound("CAS_secondwave_door_crash");

	enemies[ RandomInt(enemies.size)] thread e6_announce_arrival();

	wait( 3.0 );	

	
	
	

	wait 1.0;
	


	


	
	
	watch_chandelier = true;
	while (1)
	{
		enemies = array_removeDead( enemies );
		if ( watch_chandelier && enemies.size < 4 )
		{
			watch_chandelier = false;
			if ( !flag("cf_e6_chandelier_fell") )
			{
				level thread e6_chandelier_drop();
			}
			break;
		}
		
		
		
		
		
		
		
		
		
		
		wait(0.5);
	}

	
	while (1)
	{
		enemies = array_removeDead( enemies );
		if ( enemies.size < 3 )
		{
			
			trig = GetEnt("lookat_glass_shooters", "targetname");
			trig wait_for_trigger_or_timeout(15);
			trig delete();

			
			escort  = maps\casino_util::spawn_guys( "cai_e6_glass_escort", true, "e6_ai", "thug_red" );
			shooter = maps\casino_util::spawn_guys( "cai_e6_glassshooter", true, "e6_ai", "thug_red" );
			shooter thread e6_shoot_ceiling();
			
			enemies = maps\casino_util::array_add_Ex( enemies, escort  );
			enemies = maps\casino_util::array_add_Ex( enemies, shooter );

			break;
		}

		wait 0.5;
	}
	
	while (1)
	{
		wait( 0.5 );
		
		

		enemies = array_removeDead( enemies );

		
		if ( enemies.size < 2 )
		{		
			level thread maps\_autosave::autosave_now("e6-Last");

			
			exit_door1 = GetEnt( "door_e6_ballroom", "targetname" );
			
			exit_door1 maps\_doors::unbarred_door();
			exit_door1._doors_auto_close	= false;

			exit_door2 = GetEnt( "door_e6_ballroom2", "targetname" );
			
			exit_door2 maps\_doors::unbarred_door();

			exit_door2._doors_auto_close	= false;
			flag_set("obj_hack_door_end");

			wait( 1.0 );

			
			
			
			
			
			

			enemies = maps\casino_util::spawn_guys( "cai_e6_wave3", true, "e6_ai", "thug_red" ); 
			
			thread e6_announce_arrivalFinal(enemies);
			
			
			
			

			
			
			
			
		
			break;
		}
	}

	
	
	
	
	
	
	
	
	
	

	
	

	
	

	
	
	
	
	
	

	
	
	
	
	

	
	
	

	
	
	
	
	

	
	
	while (1)
	{
		ents = GetAIArray();
		if ( ents.size == 0 )
		{				
			
			level notify("playmusicpackage_start");
			
			trig = GetEnt( "ctrig_e6_chandelier_lookat", "targetname" );	
			if (IsDefined(trig))
			{
				trig notify( "trigger" );
			}
		}
		

		if ( ents.size == 0 )
		{
			flag_set("obj_hack_door_end");
			
			break;
		}
		else {
			trig = GetEnt("ctrig_e7_obanno", "targetname" );
			trig waittill( "trigger" );
			level thread e7_main();
			break;
		}
		wait( 0.1 );
	}
}

play_door_sounds()
{
	for (i = 0; i < 10; i++)
	{
		level.player PlaySound( "CAS_big_door_01" );
		wait RandomFloatRange(.5, 1.5);
	}
}

e6_announce_arrival()
{
	self endon( "death" );

	wait( 2.0 );
	if ( RandomInt(100) < 50 )
	{
		self thread maps\casino_util::play_dialog( "BRR6_CasiG01A_069A" );	
	}
	else
	{
		self thread maps\casino_util::play_dialog( "BRR5_CasiG01A_068A" );	
	}

}





e6_announce_arrival2( thug )
{
	self endon( "death" );

	if ( RandomInt(100) < 50 )
	{
		self thread maps\_utility::play_dialogue( "BRR6_CasiG01A_069A" );	
	}
	else
	{
		self thread maps\_utility::play_dialogue( "BRR8_CasiG01A_071A" );	
	}
}




e6_announce_arrivalFinal( thugs )
{
	wait(2);

	

	level.player PlaySound( "CAS_big_door_01" );	

	wait( 2 );

	for( i = 0 ; i < thugs.size; i++ )
	{	
		if( IsDefined(thugs[i]) )
		{
			thugs[i] thread maps\_utility::play_dialogue( "BRR7_CasiG01A_070A" );	
			break;
		}
	}
}



e6_party_time()
{
	level endon( "e6_end_sparks" );

	level notify("ballroom_sparks1_fx");
	wait(0.5);
	level notify("ballroom_sparks2_fx");
	wait(0.5);

	num_fx = 2;
	while(1)
	{
		for ( i=1; i<num_fx; i++ )
		{
			level notify("ballroom_confetti"+i+"_fx");
			wait(0.5);
		}
		wait(6); 
	}
}




e6_shoot_ceiling()
{
	wait( 0.1 );
	self thread magic_bullet_shield();

	self waittill( "goal" );	

		
		self CmdPlayAnim( "Thug_ShootAirDeath", false, true );
		wait(0.05);

		self StartRagdoll();
		self waittill( "cmd_done" );
		self becomecorpse();




		alpha[0] = "a";
		alpha[1] = "b";
		alpha[2] = "c";
		alpha[3] = "d";
		glass = [];	
		for ( i=1; i<=4; i++ )
		{
			for( j=0; j<=3; j++ )
			{
				glass[ glass.size ] = "" + i + alpha[j];
			}
		}

		array_randomize( glass );	

		for (i=0; i<13; i++ )
		{
			level notify( "ballroom_glass_burst" + glass[i] );	
			wait(0.2);
		}

		
		if ( !flag("cf_e6_chandelier_fell") )
		{
			
			

			level thread e6_chandelier_drop(); 
		}

		
		
		
			
		level waittill( "demo_end" );

		
		if( i >= 16 ) 
		{
			for (i=13; i<16; i++ )
			{
				level notify( "ballroom_glass_burst" + glass[i] );	
				wait(0.2);
			}
		}
}




e6_last_stand( )
{
	wait(1.0);	

	
	tether = GetNode( "cn_e6_rallypoint", "targetname" );
	ents = GetAIArray();
	ents[0] thread maps\_utility::play_dialogue( "BRR7_CasiG01A_070A" );	

	for ( i=0; i<ents.size; i++ )
	{
		if ( IsDefined(ents[i].groupname) && ents[i].groupname == "e6_ai" )
		{
			ents[i].tetherpt = tether.origin;
			ents[i].tetherradius = 350;
		}
	}
}






e6_final_spawn()
{
	level endon( "e7_start" );
	
	exit_door1 = GetEnt( "door_e6_ballroom", "targetname" );
	
	exit_door1 maps\_doors::unbarred_door();

	exit_door1._doors_auto_close	= false;

	exit_door2 = GetEnt( "door_e6_ballroom2", "targetname" );
	
	exit_door2 maps\_doors::unbarred_door();

	exit_door2._doors_auto_close	= false;

	
	
	
	killaz = maps\casino_util::spawn_guys( "cai_e6_reinforcements_final", true, "e6_ai", "thug_red" );
	trig = GetEnt("ctrig_e6_final_door", "targetname" );



	while ( 1 )
	{
		trig waittill( "trigger" );

		killaz = array_removeDead( killaz );
		if ( killaz.size == 0 )
		
		{
			
	
			return;
		}

		for ( i=0; i<killaz.size; i++ )
		{
			if ( isalive( killaz[i] ) )
			{
				killaz[i] cmdshootatentity( level.player, true, -1, 1 );
			}
		}

		wait( 1.0 );

		if ( level.player IsTouching(trig) )
		{
			
			level.player DoDamage( 10000, self.origin );
		}
	}
}


e6_finale()
{
	level.player maps\_utility::play_dialogue( "BOND_End_1" );	
	level.player maps\_utility::play_dialogue( "TANN_End_2" );	

	
	level notify( "demo_end" );
}	





e7_main()
{
	
	level thread check_mop();
	

	level thread maps\_autosave::autosave_now("e7");
	level notify( "e7_start" );
	
	

	org = GetEnt("obanno_fight_org", "targetname");
	vesper		= GetEnt("vesper_spawner", "targetname")		StalingradSpawn("vesper");
	obanno		= GetEnt("obanno_spawner", "targetname")		StalingradSpawn("obanno");
	level.obanno = obanno; 
	lieutenant	= GetEnt("obanno_thug_spawner", "targetname")	StalingradSpawn("thug");
	
	obanno thread maps\_bossfight::boss_transition();
	level.player maps\_gameskill::saturateViewThread(false);

	setdvar("ui_hud_showcompass", 0);
	
	wait(0.1);
	obanno gun_remove();
	obanno attach( "w_t_machette", "TAG_WEAPON_RIGHT" );
	
	
	
	level.player freezeControls(true);
	
	PlayCutScene("Obanno_Fight_Intro", "obanno_intro_done");

	level.player waittillmatch("anim_notetrack", "vision_stairs");
	visionsetnaked("casino_obanno", 0.5);

	wait(2.0);
	
	
	level notify( "playmusicpackage_boss" );

	level waittill("obanno_intro_done");
	
	
	
	level.player freezeControls(false);
	
	lieutenant dodamage(500, (0, 0, 0));
	


	level.player takeallweapons();
	start_interaction(level.player, obanno, "BossFight_Obanno");
	PlayCutScene("Obano_Fight_Vesper_01", "vesper_done");
	level.player waittillmatch("anim_notetrack", "switch_to_gun");

	level.player attach( "w_t_p99", "TAG_UTILITY2" );

	

	level.player waittill("interaction_done");
	EndCutScene("Obano_Fight_Vesper_01");
	if (level.boss_laststate == 1)
	{
		PlayCutScene("Obanno_Fight_Final_Success", "obanno_fight_done");
		thread e6_finale();
		wait(4.5); 
	}
	else
	{
		PlayCutScene("Obanno_Fight_Fail", "obanno_fight_done");
	}
	level.player waittillmatch("anim_notetrack", "fade_out");

	if (level.boss_laststate == 0)
	{
		level.player uideath();
		missionfailed();
	}

	level.player setorigin( (-6891, 2126, -119) );
	
	if (isdefined(level.hud_black)) level.hud_black fadeOverTime(3.25);
	level notify( "endmusicpackage" );
	
	wait(2.75);
	obanno delete(); 
	level.obanno delete(); 
	
	
	
	
	maps\_endmission::nextmission();
}

check_mop()
{
	trigger = getent("set_mop_physic", "targetname");
	origin = getent("mop_phsic_origin", "targetname");
	trigger waittill("trigger");

	physicsExplosionSphere( origin.origin, 30, 1, 1);
}










display_map_mainhall_first_floor()
{
	level endon( "map_ballroom" );

	trigger = GetEnt( "ctrig_e6_con_room_inside", "targetname" );
	while( true )
	{
		trigger waittill( "trigger" );

		
		
		
		
		
		setSavedDvar( "sf_compassmaplevel",  "level4" );
		

		while ( level.player IsTouching( trigger ) )
		{
			wait( 0.1 );
		}
		
		
		
		
		
		setSavedDvar( "sf_compassmaplevel",  "level3" );
		
	}
}





display_map_mainhall_second_floor()
{
	level notify( "map_ballroom" );

	trigger = GetEnt( "ctrig_ballroom_lower", "targetname" );
	while( true )
	{
		trigger waittill( "trigger" );

		
		
		
		
		
		setSavedDvar( "sf_compassmaplevel",  "level5" );
		

		while ( level.player IsTouching( trigger ) )
		{
			wait( 0.1 );
		}
		
		
		
		
		
		setSavedDvar( "sf_compassmaplevel",  "level4" );
		
	}
}






challenge_achievement()
{
	level.broke_stealth = false;
	level.guy_killed = false;

	trig = GetEnt("ctrig_e3_vent0", "targetname" );
	trig waittill( "trigger" );

	if ( !level.broke_stealth && !level.guy_killed )
	{
		
		level waittill( "e5_start" );

		level.broke_stealth = false;
		level.guy_killed = false;

		level waittill( "e6_inside_ballroom" );

		if ( !level.broke_stealth && !level.guy_killed )
		{
			GiveAchievement( "Challenge_Casino" );
		}
	}
}

display_chyron()
{
	wait(.05);
	maps\_introscreen::introscreen_chyron(&"CASINO_INTRO_01", &"CASINO_INTRO_02", &"CASINO_INTRO_03");
}
