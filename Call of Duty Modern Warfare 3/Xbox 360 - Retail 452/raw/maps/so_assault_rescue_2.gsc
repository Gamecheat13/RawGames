#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\_hud_util;

main()
{
	init_so_flags();
	preache_please();
	maps\so_assault_rescue_2_precache::main();
	maps\createart\rescue_2_art::main();
	maps\createart\so_assault_rescue_2_fog::main();
	maps\_utility::vision_set_fog_changes( "mine_exterior", 0 );
	ac130_vo();
	
	//beefs up ground player health
	set_custom_gameskill_func( maps\_gameskill::solo_player_in_coop_gameskill_settings );
	
	level.ground_player = undefined;
	level.ac130_player = undefined;
	level.pmc_alljuggernauts = false;
	
	level.enemy_ai_killed = false;
	level.enemy_vehicle_killed = false;
	level.enemy_btr_killed = false;
	level.enemy_hind_killed = false;
	level.enemy_mi17_killed = false;
	level.enemy_t72_killed = false;
	level.enemy_kill_dialogue_enabled = true;
	level.c130_missile_fired = 0;
	
	level._effect[ "floor_breach" ]							= loadfx( "explosions/breach_wall_concrete_berlin" );
	level._effect[ "wall_explosion" ]						= loadfx( "explosions/wall_explosion_small" );
	level._effect[ "bomb_explosion_ac130" ] = loadfx( "explosions/bomb_explosion_ac130" );
		
	// Start functions
	default_start( ::start_entrance );
	add_start( "start_entrance",		::start_entrance );
	add_start( "start_tunnel",		::start_tunnel );
	add_start( "start_rappel",   ::start_rappel );
	add_start( "start_rappel_bottom",   ::start_rappel_bottom );
	
	level.temp_obj_ent = spawn("script_model", (0,0,0) );
	level.temp_obj_ent setmodel("tag_origin");
	
	maps\_load::main();
	maps\_compass::setupMiniMap( "compass_map_rescue_outside", "outside_minimap_corner" );
	
	foreach( player in level.players )
	{
		player freezecontrols( true );
	}	
	
	setup_difficulty_settings();
	thread init_player_roles();
	level thread setup_c4_door();
	
	setup_anims();
	setup_so();
	
	// Custom end of game logic
	level.custom_eog_no_defaults			= true;
	level.eog_summary_callback 				= ::custom_eog_summary;
	
	// Override the amount given for kills because so many
	// kills can happen in this map
	thread override_score_info();
	
	//cave_door_destruction = getent( "cave_door_destruction", "targetname" );	
	//cave_door_destruction hide();
	
	//thread setup_timer();	
	thread maps\_util_carlos::kick_double_door_open( maps\rescue_2_cavern_code::get_door_from_targetname( "cavern_door_l" ), maps\rescue_2_cavern_code::get_door_from_targetname( "cavern_door_r" ), "metal_door_kick", undefined );
	
	level thread set_flag_on_targetname_trigger("construction_approach");
	level thread set_flag_on_targetname_trigger("player_on_road");
	level thread set_flag_on_targetname_trigger("player_entered_basement");
	level thread set_flag_on_targetname_trigger("player_in_trailer" );
	level thread set_flag_on_targetname_trigger("front_yard_halfway");
	
	setsaveddvar("fx_alphathreshold",10);
	
	//open doors from SP
	thread move_me_connect_paths("block_player_door");		
	
	//damage portion of large tanks
	hide_me( "silo_1_damage" );
	hide_me( "silo_2_damage" );	
	
	thread ac130_so_on_terminated();
}

ac130_so_on_terminated()
{
	level waittill( "special_op_terminated" );
	wait 0.05;
	level notify( "LISTEN_end_ac130" );
	wait 0.05;
	
	if ( IsDefined( level.ac130player ) )
		level.ac130player stop_loop_sound_on_entity( "ac130_25mm_fire_loop" );
}

override_score_info()
{
	if ( !IsDefined( level.scoreInfo ) )
	{
		level waittill( "rank_score_info_defaults_set" );
	}
	maps\_rank::registerScoreInfo( "kill", 25 );
}

hide_me( the_targetname )
{
	ents = getentarray( the_targetname, "targetname" );
	foreach(ent in ents)
	{
		ent hide();		
	}	
}

ai_enemy_kill_dialogue_monitor()
{	
	self waittill("death", attacker);
	if ( isdefined(attacker)  && attacker == level.ac130_player )
	{
		level.enemy_ai_killed = true;
	}	
}

vehicle_kill_dialogue_monitor()
{	
	self waittill("death", attacker);
	if ( isdefined(attacker)  && attacker == level.ac130_player )
	{	
		level.enemy_vehicle_killed = true;
		level.enemy_mi17_killed = true;
	}	
}

ac130_vo()
{
	
	//OVERLORD
	// "SAM sites in the area are targeting our air-support.  Shut them down before they can lock on."
	level.scr_radio[ "so_aslt_rescue2_hqr_samsites" ] = "so_aslt_rescue2_hqr_samsites";

	// "Missiles in the air!  Repeat, missiles in the air!"
	level.scr_radio[ "so_aslt_rescue2_hqr_missles" ] = "so_aslt_rescue2_hqr_missles";
	
	// "Defense system is down.  Good job."
	level.scr_radio[ "so_aslt_rescue2_hqr_systemsdown" ] = "so_aslt_rescue2_hqr_systemsdown";

	// "There's a security lock on the main entrance.  You'll have to override the door if you want to proceed."
	level.scr_radio[ "so_aslt_rescue2_hqr_securitylock" ] = "so_aslt_rescue2_hqr_securitylock";

	// "Nice work.  You're clear to proceed."
	level.scr_radio[ "so_aslt_rescue2_hqr_nicework" ] = "so_aslt_rescue2_hqr_nicework";
	
	//AC130
	
	// "Missiles inbound. Brace for impact!"	
	level.scr_radio[ "so_aslt_rescue2_plt_brace" ] = "so_aslt_rescue2_plt_brace";
	
	//KILL CONFIRMS	
	    // 3-23 Good kill.  Good kill.
    level.scr_sound[ "tvo" ][ "ac130_tvo_goodkill" ]			= "ac130_tvo_goodkill";  
        // 4-19 Ka-boom.
    //level.scr_sound[ "fco" ][ "ac130_fco_kaboom" ]				= "ac130_fco_kaboom";
        // 4-20 Niiiiiiiice.
    level.scr_sound[ "fco" ][ "ac130_fco_nice" ]				= "ac130_fco_nice";
        // 4-22 You got em.
    level.scr_sound[ "fco" ][ "ac130_fco_yougotem" ]			= "ac130_fco_yougotem";
        // 4-23 Yeah, direct hits right there.
    level.scr_sound[ "fco" ][ "ac130_fco_directhits" ]			= "ac130_fco_directhits";
        // 4-24 Theeeere we go.
    level.scr_sound[ "fco" ][ "ac130_fco_therewego" ]			= "ac130_fco_therewego";
   		 // 4-25 Good shot.
    level.scr_sound[ "fco" ][ "ac130_fco_goodshot" ]			= "ac130_fco_goodshot";
        // ** 100-23 That's one down.
    //level.scr_sound[ "tvo" ][ "ac130_tvo_onedown" ]				= "ac130_tvo_onedown";
        // 8-9 Daaaaaaamn.
    level.scr_sound[ "tvo" ][ "ac130_tvo_damn" ]				= "ac130_tvo_damn";
        // ** 8-24 Yeah, he's toast. <-- needs to be recorded to be fco
    level.scr_sound[ "hit" ][ "ac130_hit_hestoast" ]			= "ac130_hit_hestoast";
    
    //VEHICLE DEATH
    
        // 16-17 That hind's toast.
    level.scr_sound[ "fco" ][ "ac130_fco_hindistoast" ]			= "ac130_fco_hindistoast";
        // 16-2 Enemy bird is down.
    level.scr_sound[ "fco" ][ "ac130_fco_birddown" ]			= "ac130_fco_birddown";
    
    //GENERAL
    
    	//decending crew
    level.scr_sound[ "pilot" ][ "ac130_plt_descending" ]     = "ac130_plt_descending";   
   		 //tapes rollin crew
    level.scr_sound[ "fco" ][ "ac130_fco_tapesrollin" ]     = "ac130_fco_tapesrollin";    
        // 17-4 Targeting system online.  TV, verify you see our friendlies.
    level.scr_sound[ "plt" ][ "ac130_plt_seefriendlies" ]	= "ac130_plt_seefriendlies";    
    // 17-5 Roger that.  Friendlies are marked with white diamonds.
    level.scr_sound[ "tvo" ][ "ac130_tvo_whitediamonds" ]	= "ac130_tvo_whitediamonds";
        // 2-23 Got eyes on friendlies.
    level.scr_sound[ "tvo" ][ "ac130_tvo_eyesonfriendlies" ]	= "ac130_tvo_eyesonfriendlies";
        // 2-17 They're going to town down there, man.
    level.scr_sound[ "tvo" ][ "ac130_tvo_goingtotown2" ]		= "ac130_tvo_goingtotown2";
    
     // 2-17 enemy birds inbound
    //level.scr_sound[ "fco" ][ "ac130_plt_birdsinbound" ]		= "ac130_plt_birdsinbound";
    
    level.scr_radio[ "ac130_plt_birdsinbound" ]		= "ac130_plt_birdsinbound";
    
    // Metal zero one enemy hinds inbound
    level.scr_radio[ "incoming_hind_warning" ]		= "incoming_hind_warning";
      
    //KILL PROMPTs
    // 3-8 Go for the vehicles.
    level.scr_sound[ "fco" ][ "ac130_fco_goforvehicles" ]		= "ac130_fco_goforvehicles";
    
   
} 



level_enemy_killed()
{
	level.ground_player endon ("death");
	
	sounds_both = [];
  
	// 3-23 Good kill.  Good kill.
	sounds_both[ sounds_both.size ] = level.scr_sound[ "tvo" ][ "ac130_tvo_goodkill" ];
	// 4-19 Ka-boom.
	//sounds_both[ sounds_both.size ] = level.scr_sound[ "fco" ][ "ac130_fco_kaboom" ];
    // 4-20 Niiiiiiiice.
    sounds_both[ sounds_both.size ] = level.scr_sound[ "fco" ][ "ac130_fco_nice" ];
    // 4-22 You got em.
 	sounds_both[ sounds_both.size ] = level.scr_sound[ "fco" ][ "ac130_fco_yougotem" ];
    // 4-23 Yeah, direct hits right there.
    sounds_both[ sounds_both.size ] = level.scr_sound[ "fco" ][ "ac130_fco_directhits" ];
    // 4-24 Theeeere we go.
    sounds_both[ sounds_both.size ] = level.scr_sound[ "fco" ][ "ac130_fco_therewego" ]; 
    // 4-25 Good shot.
    sounds_both[ sounds_both.size ] = level.scr_sound[ "fco" ][ "ac130_fco_goodshot" ];
    // 100-23 That's one down.
    //sounds_both[ sounds_both.size ] = level.scr_sound[ "tvo" ][ "ac130_tvo_onedown" ];
    // 8-9 Daaaaaaamn.
    sounds_both[ sounds_both.size ] =  level.scr_sound[ "fco" ][ "ac130_tvo_damn" ];
    // 8-24 Yeah, he's toast.
    sounds_both[ sounds_both.size ] =  level.scr_sound[ "hit" ][ "ac130_hit_hestoast" ];
    
    array_both = [];
    for ( i = 0; i < sounds_both.size; i++ )
    	array_both[ array_both.size ] = i;
    
    // T72
    
    sounds_t72 = [];
    
    // 16-1 Good. You got the tank.
    sounds_t72[ sounds_t72.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_gotthetank" ];
    // 16-18 Yeah, that tank isn't going anywhere.
    sounds_t72[ sounds_t72.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_goinganywhere" ];
    
    array_t72 = [];
    for ( i = 0; i < sounds_t72.size; i++ )
    	array_t72[ array_t72.size ] = i;
    
    // MI17
    	
   	sounds_mi17 = [];
    
    // 16-2 Enemy bird is down.
    sounds_mi17[ sounds_mi17.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_birddown" ];
    
    array_mi17 = [];
    for ( i = 0; i < sounds_mi17.size; i++ )
    	array_mi17[ array_mi17.size ] = i;
    
    // BTR
    
    sounds_btr = [];
    
    // 16-16 BTR is down.
    sounds_btr[ sounds_btr.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_btrisdown" ];
    
    array_btr = [];
    for ( i = 0; i < sounds_btr.size; i++ )
    	array_btr[ array_btr.size ] = i;
    
    // HIND
    	
    sounds_hind = [];
    
    // 16-2 Enemy bird is down.
    sounds_hind[ sounds_hind.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_birddown" ];
    // 16-17 That hind's toast.
    sounds_hind[ sounds_hind.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_hindistoast" ];
    
    array_hind = [];
    for ( i = 0; i < sounds_hind.size; i++ )
    	array_hind[ array_hind.size ] = i;
    				
    delay = 0.5;
    confirm_delay = 0.25;
    index_both = 0;
    index_t72 = 0;
    index_mi17 = 0;
    index_btr = 0;
    index_hind = 0;
	
	for ( ; ; )
	{
		if ( flag( "ac130_setup_complete" ) && 
		     level.enemy_kill_dialogue_enabled && 
		     ( level.enemy_ai_killed || level.enemy_vehicle_killed ) )
		{
			both = ter_op( random_chance( 0.9 ), 1, 0 );
			
			if ( !both && level.enemy_vehicle_killed )
			{
				if ( level.enemy_t72_killed )
				{
					if ( array_t72.size == 0 )
					{
						for ( i = 0; i < sounds_t72.size; i++ )
			    			array_t72[ array_t72.size ] = i;
			    		if ( array_t72.size > 1 )
			    			array_t72 = array_remove_index( array_t72, index_t72 );
			    	}
					
					index_t72 = RandomInt( array_t72.size );
					
					wait confirm_delay;
					thread vehicle_scripts\_ac130::playSoundOverRadio( sounds_t72[ array_t72[ index_t72 ] ], false, 4.0 );
			    	array_t72 = array_remove_index( array_t72, index_t72 );
				}
				else
				if ( level.enemy_mi17_killed )
				{
					if ( array_mi17.size == 0 )
					{
						for ( i = 0; i < sounds_mi17.size; i++ )
			    			array_mi17[ array_mi17.size ] = i;
			    		if ( array_mi17.size > 1 )
			    			array_mi17 = array_remove_index( array_mi17, index_mi17 );
			    	}
					
					index_mi17 = RandomInt( array_mi17.size );
					
					wait confirm_delay;
					thread vehicle_scripts\_ac130::playSoundOverRadio( sounds_mi17[ array_mi17[ index_mi17 ] ], false, 4.0 );
			    	array_t72 = array_remove_index( array_mi17, index_mi17 );
				}
				else
				if ( level.enemy_btr_killed )
				{
					if ( array_btr.size == 0 )
					{
						for ( i = 0; i < sounds_btr.size; i++ )
			    			array_btr[ array_btr.size ] = i;
			    		if ( array_btr.size > 1 )
			    			array_btr = array_remove_index( array_btr, index_btr );
			    	}
					
					index_btr = RandomInt( array_btr.size );
					
					wait confirm_delay;
					thread vehicle_scripts\_ac130::playSoundOverRadio( sounds_btr[ array_btr[ index_btr ] ], false, 4.0 );
			    	array_btr = array_remove_index( array_btr, index_btr );
				}
				else
				if ( level.enemy_hind_killed )
				{
					if ( array_hind.size == 0 )
					{
						for ( i = 0; i < sounds_hind.size; i++ )
			    			array_hind[ array_hind.size ] = i;
			    		if ( array_hind.size > 1 )
			    			array_hind = array_remove_index( array_hind, index_hind );
			    	}
					
					index_hind = RandomInt( array_hind.size );
					
					wait confirm_delay;
					thread vehicle_scripts\_ac130::playSoundOverRadio( sounds_hind[ array_hind[ index_hind ] ], false, 4.0 );
			    	array_hind = array_remove_index( array_hind, index_hind );
				}
				else
				{
					if ( array_both.size == 0 )
		    		{
						for ( i = 0; i < sounds_both.size; i++ )
			    			array_both[ array_both.size ] = i;
			    		if ( array_both.size > 1 )
			    			array_both = array_remove_index( array_both, index_both );
			    	}
					
					index_both = RandomInt( array_both.size );
					
					wait confirm_delay;
					thread vehicle_scripts\_ac130::playSoundOverRadio( sounds_both[ array_both[ index_both ] ], false, 4.0 );
			    	array_both = array_remove_index( array_both, index_both );
		    	}
	    	}
	    	else
	    	{
	    		if ( array_both.size == 0 )
	    		{
					for ( i = 0; i < sounds_both.size; i++ )
		    			array_both[ array_both.size ] = i;
		    		if ( array_both.size > 1 )
		    			array_both = array_remove_index( array_both, index_both );
		    	}
				
				index_both = RandomInt( array_both.size );
				
				wait confirm_delay;
				thread vehicle_scripts\_ac130::playSoundOverRadio( sounds_both[ array_both[ index_both ] ], false, 4.0 );
		    	array_both = array_remove_index( array_both, index_both );
	    	}
			wait delay;
			level.enemy_ai_killed = false;
			level.enemy_vehicle_killed = false;
			level.enemy_btr_killed = false;
			level.enemy_hind_killed = false;
			level.enemy_mi17_killed = false;
			level.enemy_t72_killed = false;
		}
		else
			wait 0.05;
	}
}


init_player_roles()
{
	AssertEx( IsSplitScreen() || is_coop(), "AC130 Mine is only playable in co-op." );
	
	level.specops_character_selector = GetDvar( "coop_start" );
	//AssertEx( IsDefined( level.specops_character_selector ) && level.specops_character_selector != "", "Coop player role dvar not set." );
	
	if ( level.specops_character_selector == "so_char_host" )
	{
		level.ac130_player 	= level.players[ 0 ];
		level.ground_player	= level.players[ 1 ];
		
	}
	else
	{
		level.ac130_player 	= level.players[ 1 ];
		level.ground_player	= level.players[ 0 ];
	}
	
	level.ground_player LaserForceOn();	
	level.ground_player	maps\_coop::FriendlyHudIcon_Disable();	
	flag_set( "player_roles_chosen" );	
}

move_me_connect_paths(the_targetname)
{
	brushmodel = getent( the_targetname, "targetname" );
	brushmodel.origin = brushmodel.origin -(0,0,2000);
	brushmodel connectpaths();
}	

#using_animtree( "generic_human" );
setup_anims()
{
	//tunnel slowmo breach enemy anims
	level.scr_anim[ "generic" ][ "breach_react_blowback_v2" ]			= %breach_react_blowback_v2;
	level.scr_anim[ "generic" ][ "exposed_flashbang_v3" ]					= %exposed_flashbang_v3;
	level.scr_anim[ "generic" ][ "breach_react_push_guy2" ]				= %breach_react_push_guy2;
	level.scr_anim[ "generic" ][ "breach_react_push_guy1" ]				= %breach_react_push_guy1;
	
}	

start_entrance()
{
		
	//flag_wait( "player_roles_chosen" );
	//level.ground_player thread arm_player(1);
	thread setup_timer();
	level.ground_player ent_flag_init("player_in_basement");
	
	level thread obj1_fail_monitor();
	level thread setup_c130();


	setup_hud();
	level thread setup_objectives("start_entrance");
	
	thread enemy_logic("start_entrance");
	//thread c130_player_transition();
	//thread missile_launchers();
	flag_clear( "laststand_on" );
	
	rescue_laptops = getentarray("rescue_laptops", "targetname");
	array_thread(rescue_laptops, ::laptop_logic);
	
	level thread player_basement_check();
	
	//block_player_door = GetEnt( "block_player_door", "targetname" );
	//block_player_door.origin = block_player_door.origin - (0,0,500);

}	

start_tunnel()
{
	//players[0] is ac130 for now. Need menu to let players pick. 
	flag_set( "first_enemies_spawned" );
	if(level.players.size > 1)
	{
		level.ground_player = level.players[0];
		level.ac130_player = level.players[1];
	}
	else 
	{
		level.ground_player = level.players[0];
	}	
	
	level.ground_player thread arm_player(1);
	level thread setup_c130();
	setup_hud();
	
	thread c130_player_transition();
	struct = getstruct( "so_tunnel_start", "targetname");
	level.ground_player setorigin( struct.origin );
	
	level.ground_player LaserForceOff();	
	if(level.players.size > 1)
	{
		level.ground_player maps\_coop::FriendlyHudIcon_Enable();
	}	
	level thread setup_objectives("start_tunnel");
	level thread enemy_logic( "start_tunnel" );
	
	drop_down_trig = getent("hallway_dropdown", "targetname");		
	level.temp_obj_ent.origin = drop_down_trig.origin;
	objective_add( obj("laptop_2"), "current", &"SO_ASSAULT_RESCUE_2_OBJ_1_INTEL_1", level.temp_obj_ent.origin);
	objective_position( obj("laptop_2"), level.temp_obj_ent.origin );
	objective_onentity( obj("laptop_2"), level.temp_obj_ent );
	//breach_fx = script_origin

}	

start_rappel()
{
	start_cavern_rappel = getstructarray("so_rappel_start", "targetname");
	setup_hud();
	foreach(i, player in level.players)
	{
		player setorigin(start_cavern_rappel[i].origin);
		wait(.05);
		player thread arm_player();
	}	
	
	level thread setup_objectives("start_rappel");
	level thread enemy_logic( "start_rappel" );
		

}	

start_rappel_bottom()
{
	start_cavern_rappel = getstructarray("so_rappel_bottom", "targetname");
	setup_hud();
	foreach(i, player in level.players)
	{
		player setorigin(start_cavern_rappel[i].origin);
		wait(.05);
		player thread arm_player();
	}	
	
	level thread setup_objectives("start_rappel_bottom");
	level thread enemy_logic( "start_rappel_bottom" );
		

}	

setup_c4_door()
{
	//ents
	model = getent ("basement_door_model", "targetname");	//door model
	clip = getent ("basement_door_clip_new", "targetname");	 //script_brushmodel clip
	//clip thread Print3d_on_me( "!!" );
	clip solid();
	level.c4 = getent ("basement_door_c4", "targetname"); //c4 model
	
	//spawn the glowy c4 model
	c4_obj = spawn( "script_model", level.c4.origin); //spawn the glowy c4
	c4_obj.angles = level.c4.angles;
	c4_obj setmodel ("weapon_c4_obj");
	
	c4_obj SetHintString(&"SCRIPT_PLATFORM_HINT_PLANTEXPLOSIVES");
	c4_obj MakeUsable();
	flag_set("c4_setup_complete");
	
	c4_obj waittill ("trigger");	
	flag_set( "player_planted_c4");
	
	//PLAYER HAS PLANTED
	c4_obj SetHintString("");
	c4_obj delete();
	level.c4 thread playC4Effects();
	
	//COUNTDOWN TICKER
	play_sound_in_space("cobra_aquiring_lock", level.c4.origin );
	play_sound_in_space("cobra_aquiring_lock", level.c4.origin );
	play_sound_in_space("missile_lock_loop", level.c4.origin );
	
	//DETONATION
	flag_set ("door_detonated");
	playfx( getfx("wall_explosion"), level.c4.origin );
	level thread play_sound_in_space( "detpack_explo_default", level.c4.origin );
	earthquake(.6, .5, level.ground_player.origin, 200 );
	level.c4 radiusdamage(level.c4.origin, 100, 50, 20 );
	level.c4 hide();
	model delete();
	clip notsolid();
	//clip.origin = clip.origin -(0,0,2000);
	clip connectpaths();	
}	

playC4Effects()
{
	playFXOnTag( getfx( "c4_light_blink" ), self, "tag_fx" );
	flag_wait ("door_detonated");
	stopFXOnTag( getfx( "c4_light_blink" ), self, "tag_fx" );	
}


setup_objectives(skipto)
{
	level endon( "special_op_terminated" );
	
	switch ( skipto )
		{
		  case "start_entrance":
		  	//wait to spawn c4
		  	flag_wait("c4_setup_complete");
		  	
		  	//spot close to c4
		  	c4_obj_spot = ( 6294.5, -2807.43, -8790.8 );
		  	
		  	//trig radius inside basement 
		  	basement_entrance_trig = GetEnt( "player_entered_basement", "targetname" );
		  	level.temp_obj_ent.origin = c4_obj_spot;
		  	
		  	//plant the c4 on the door
		  	objective_add( obj("laptop_1"), "current", &"SO_ASSAULT_RESCUE_2_OBJ_1_C4", level.temp_obj_ent.origin);				
			objective_position( obj("laptop_1"), level.temp_obj_ent.origin );
			objective_onentity( obj("laptop_1"), level.temp_obj_ent );
			
		  	//wait for player to get close to the spot
		  	dist = distancesquared( level.temp_obj_ent.origin, level.ground_player.origin );
			while( dist > 120*120 )
			{
				dist = distancesquared(level.temp_obj_ent.origin, level.ground_player.origin);
				wait(.10);
			}
		  	//move obj to actual c4 on door	  	  		
		  	level.temp_obj_ent.origin = level.c4.origin;
		  	objective_position( obj("laptop_1"), level.temp_obj_ent.origin );
		  	
		  	//wait for player to plant
		  	flag_wait("player_planted_c4");
		  	level.temp_obj_ent.origin = (0,0,0);			
			objective_position( obj("laptop_1"), level.temp_obj_ent.origin );
		  	
		  	//wait for detonation	  	
			flag_wait("door_detonated");
					
			//change string to hacking the laptop 
			objective_string( obj("laptop_1"), &"SO_ASSAULT_RESCUE_2_OBJ_1");	
			
			//breadcrumb the obj spot inside the basement			
			level.temp_obj_ent.origin = (6500.48, -3042.67, -8756.74);			
			objective_position( obj("laptop_1"), level.temp_obj_ent.origin );
			
			//wait for player to get close
			dist = distancesquared( level.temp_obj_ent.origin, level.ground_player.origin );
			while( dist > 90*90 )
			{
				dist = distancesquared(level.temp_obj_ent.origin, level.ground_player.origin);
				wait(.10);
			}	
			
			//put obj on laptop inside		
			laptop_1 = getent("laptop_1", "script_noteworthy");		
			objective_position( obj("laptop_1"), laptop_1.origin );
			objective_onentity( obj("laptop_1"), laptop_1 );
			
			//wait for laptop to get hacked
			flag_wait("laptop_1_hacked");
			
			// "Defense system is down.  Good job."
			radio_dialogue( "so_aslt_rescue2_hqr_systemsdown" );
			
			//thread maps\_specialops_code::so_dialog_play( "so_tf_1_progress_1more", 0.5 );
			
			objective_complete( obj("laptop_1") );	
			laptop_2 = getent("laptop_2", "script_noteworthy");
			objective_add( obj("laptop_2"),  "current", &"SO_ASSAULT_RESCUE_2_OBJ_2", laptop_2.origin);
			objective_position( obj("laptop_2"), laptop_2.origin );
			objective_onentity( obj("laptop_2"), laptop_2 );
			
			wait(3);
			
			// "There's a security lock on the main entrance.  You'll have to override the door if you want to proceed."
			radio_dialogue( "so_aslt_rescue2_hqr_securitylock" );
			
			flag_wait("laptop_2_hacked");
			
			objective_complete( obj("laptop_2") );				
			garage_entrance_trig = getent("garage_entrance_trig", "targetname");
			level.temp_obj_ent.origin = garage_entrance_trig.origin;
			objective_add( obj("exit"), "current",  &"SO_ASSAULT_RESCUE_2_OBJ_3", level.temp_obj_ent.origin);
			objective_position( obj("exit"), level.temp_obj_ent.origin );
			objective_onentity( obj("exit"), level.temp_obj_ent );
			
			//"Good work, you're clear to proceed."
			radio_dialogue( "so_aslt_rescue2_hqr_nicework" );
					
			doors = getentarray( "cave_door_prestine", "targetname" );	
			door_open = getstruct("door_open", "targetname");	
			player_sees_door = getstruct("player_sees_door", "targetname");	
					
			while(!player_can_see( player_sees_door.origin) )
			{
				wait(.25);
			}	
			
			flag_set("garage_opening");	
			
			foreach(brushmodel in doors)
			{	
				brushmodel moveto( door_open.origin, 4, 2, 2);
				brushmodel connectpaths();
			}
			
			// Remove invisible clip so player can run through open door
			door_clip = getent( "new_cave_door_collision", "targetname" );
			door_clip connectpaths();
			door_clip NotSolid();
			
			wait(3);
								
			flag_set("garage_opened");
						
			garage_entrance_trig waittill("trigger");
			//END OF MISSSION!!!
	
			flag_set("so_assault_rescue_2_complete");
			objective_complete( obj("exit") );	
			
			level notify ("LISTEN_end_ac130");
			battlechatter_off();
	  	
		 }	
}

player_can_see( origin )
{
	//this is way to generous
	if( SightTracePassed( level.ground_player GetEye(), origin, false, level.ground_player ) )
	{
		return true;
	}	
	return false;
}	

setup_hud()
{		
	// 	progress bar settings
    level.secondaryProgressBarY = 75;
    level.secondaryProgressBarHeight = 14;
    level.secondaryProgressBarWidth = 152;
    level.secondaryProgressBarTextY = 45;
    level.secondaryProgressBarFontSize = 2;
}

setup_timer()
{
	level endon( "special_op_terminated" );
	
	//Make timer always on
	level.challenge_time_force_on = true;

	// LAPTOP 1		
	level.challenge_time_limit = level.obj1_time;
	//level.so_deadquote_time = "@SO_AC130_PARIS_AC130_MISSION_FAIL_BRIDGE";
	thread enable_challenge_timer( "so_assault_rescue_2_start", "so_assault_rescue_2_complete", &"SO_ASSAULT_RESCUE_2_TIMER_OBJ1" );
	start_time = GetTime();
	
	thread fade_challenge_in();
	thread fade_challenge_out( "so_assault_rescue_2_complete" );
		
	flag_wait( "laptop_1_hacked" );	
	foreach ( player in level.players )
		player.so_infohud_toggle_state = "off";
		
	level notify( "challenge_timer_passed" );
	level notify( "new_challenge_timer" );
	
	// LAPTOP 2
	
	wait(3);	
	foreach ( player in level.players )
		player.so_infohud_toggle_state = "on";
	
	level.challenge_time_limit = level.obj2_time;
	//level.so_deadquote_time = "@SO_AC130_PARIS_AC130_MISSION_FAIL_CHASE";
	thread enable_challenge_timer( "so_assault_rescue_2_start", "so_assault_rescue_2_complete");
	
}

setup_difficulty_settings()
{
	switch( level.gameSkill )
	{
		case 0:// easy
		case 1:// regular
			level.obj1_time = 110;
			level.obj2_time = 75; //2:00
			break;
		case 2:// hardened
			level.obj1_time = 95; 
			level.obj2_time = 70; 
			break;
		case 3:// veteran
			level.obj1_time = 87; 
			level.obj2_time = 65; 
			break;
		default:
			AssertMsg( "Invalid difficulty setting: " + level.gameSkill );
			level.obj1_time = 110; //1:30
			level.obj2_time = 65; //1:30
			break;
	}
}


preache_please()
{
	PreCacheShellShock( "default" );
	PreCacheShellShock( "paris_ac130_thermal" );
	PreCacheShellShock( "paris_ac130_enhanced" );
	
	PreCacheShader( "remotemissile_infantry_target" );
	PreCacheShader( "ac130_hud_diamond" );
	PreCacheShader( "ac130_hud_tag" );
	PreCacheShader( "hud_fofbox_self_sp" );
	PreCacheShader( "uav_vehicle_target" );
	PreCacheShader( "veh_hud_target" );
	PreCacheShader( "overlay_static" );
	PrecacheShader( "compass_map_rescue_outside" );
	
	precachemodel( "com_laptop_2_open_obj" );
	precachemodel( "weapon_minigun" );
	precachemodel( "weapon_c4" );
	precachemodel( "weapon_c4_obj" );
	
	precachestring( &"SO_ASSAULT_RESCUE_2_OBJ_1");
	precachestring( &"SO_ASSAULT_RESCUE_2_OBJ_1_C4");
	precachestring( &"SO_ASSAULT_RESCUE_2_OBJ_2"); 
	precachestring( &"SO_ASSAULT_RESCUE_2_OBJ_3");
	precachestring( &"SO_ASSAULT_RESCUE_2_LAPTOP1_STATUS"); 
	precachestring( &"SO_ASSAULT_RESCUE_2_LAPTOP2_STATUS");
	precachestring( &"SO_ASSAULT_RESCUE_2_TIMER_OBJ1");
	precachestring( &"SO_ASSAULT_RESCUE_2_TIMER_OBJ1_A");

	precacheitem( "m4_grunt_acog");
	precacheitem( "g36c_reflex");
	precacheitem( "stinger" );
	precacheitem( "stinger_speedy" );
	precacheitem( "zippy_rockets" );

	Maps\rescue_2_precache::Main();
}
	
init_so_flags()
{
	flag_init("so_assault_rescue_2_start");
	flag_init("so_assault_rescue_2_complete");
	flag_init("laptop_1_hacked");
	flag_init("laptop_2_hacked");
	flag_init("first_enemies_spawned");
	flag_init("ac130Player_on_ground");
	flag_init("player_transition_started");
	flag_init("construction_approach");
	flag_init("torture_room_cleared");
	flag_init("player_on_road");
	flag_init("player_entered_basement");
	flag_init("player_in_trailer");
	flag_init("front_yard_halfway");
	flag_init("missile_launcher_destroyed");
	flag_init("player_roles_chosen");
	flag_init("garage_opened");
	flag_init("garage_opening");
	flag_init("ac130_setup_complete");
	flag_init("FLAG_ac130_context_sensitive_dialog_guy_in_sight");
	flag_init("allow_context_sensative_dialog");
	flag_init("FLAG_ac130_changed_weapons");	
	flag_init("FLAG_ac130_changed_vision");
	flag_init("FLAG_ac130_using_zoom");
	flag_init("c130_destroyed");
	flag_init("missile_launch");
	flag_init("c4_setup_complete");
	flag_init("door_detonated");
	flag_init("player_planted_c4");

}	

setup_so()
{
	//so_delete_all_triggers();
	so_delete_all_spawntriggers();
	//so_delete_all_spawners();
	so_delete_all_by_type( ::type_goalvolume, ::type_infovolume, ::type_weapon_placed, ::type_turret );	
	//trigger_multiple_spawn
}	


arm_player(ac130_active)
{
	//self = a player
	self takeallweapons();
	
	if(isdefined( ac130_active ) )
	{
		self LaserForceOn();	
		self maps\_coop::FriendlyHudIcon_Disable();
	}	

	level.default_weapon = "m4_grunt_acog";
	self GiveWeapon( level.default_weapon );
	self GiveMaxAmmo( level.default_weapon );
	self GiveWeapon( "g36c_reflex" );
	self GiveMaxAmmo( "g36c_reflex" );
	self GiveWeapon( "fraggrenade" );
	self GiveWeapon( "flash_grenade" );
	self SetOffhandPrimaryClass( "frag" );
	self SetOffhandSecondaryClass( "flash" );
	self SwitchToWeapon( level.default_weapon );
	
}	

setup_c130()
{
	//flag_wait("player_roles_chosen");
	ac130_start_node = getvehiclenode ("loop1_start", "targetname");
	
	ac130_spawner = GetEnt( "so_ac130", "targetname" );
	ac130_spawner.origin = ac130_start_node.origin;
	ac130_spawner.angles = ac130_start_node.angles;
	ac130_spawner.target = "loop1_start";
	
	level.ac130_vehicle = vehicle_spawn( ac130_spawner );
	wait (.10);
	
	//level.ac130_vehicle Hide();
	ac130_spawner Delete();

	vehicle_scripts\_ac130::ac130_set_thermal_vision_set("so_assault_rescue_2_ac130");//so_assault_rescue_2_ac130
	vehicle_scripts\_ac130::ac130_set_enhanced_vision_set( "so_rescue_2_enhanced" );
	vehicle_scripts\_ac130::ac130_set_thermal_shock( "paris_ac130_thermal" );
	vehicle_scripts\_ac130::ac130_set_enhanced_shock( "paris_ac130_enhanced" );
	
	level.ac130_vehicle Vehicle_Teleport( ac130_start_node.origin, ac130_start_node.angles );
	/*
	level.ac130_vehicle.attachedpath = ac130_start_node;
	level.ac130_vehicle StartPath( ac130_start_node );
	level.ac130_vehicle  Vehicle_SetSpeed(10, 5, 5);
	*/
	
	flag_wait("first_enemies_spawned");
	thread gopath( level.ac130_vehicle );
	
	if(isdefined( level.ac130_player ))
	{
		level.ac130_vehicle vehicle_scripts\_ac130::_ac130_init_player( level.ac130_player, "thermal" );
		level.ac130_player setplayerangles( (45, 181.9, 0) );
		level.ac130_player LerpViewAngleClamp( 0, 0, 0, 50, 55, 60, 50 );//t a, d, r, l t, b
	}	
	
	level.weapon_enemy_close_distance[ "ac130_25mm" ] 		= 100;
	level.weapon_enemy_close_distance[ "ac130_40mm" ]	 	= 200;
	level.weapon_enemy_close_distance[ "ac130_105mm" ] 		= 500;
	level.weapon_enemy_close_distance[ "ac130_25mm_alt2" ]  = level.weapon_enemy_close_distance[ "ac130_25mm" ];
	level.weapon_enemy_close_distance[ "ac130_40mm_alt2" ]  = level.weapon_enemy_close_distance[ "ac130_40mm" ];
	level.weapon_enemy_close_distance[ "ac130_105mm_alt2" ] = level.weapon_enemy_close_distance[ "ac130_105mm" ];
	
	flag_set("FLAG_ac130_clear_to_engage");
	
	flag_set ("so_assault_rescue_2_start");
	
	flag_set ("ac130_setup_complete");
	
	foreach( player in level.players )
	{
		player freezecontrols( false );
	}
	
	wait(1.6);
	
	// "SAM sites in the area are targeting our air-support.  Shut them down before they can lock on."
	radio_dialogue("so_aslt_rescue2_hqr_samsites");
	
	thread vehicle_scripts\_ac130::playSoundOverRadio( "ac130_plt_descending", false, 4.0 );
	
	//vehicle_scripts\_ac130::playSoundOverRadio( "ac130_plt_seefriendlies", true, 4.0 );	 
	//vehicle_scripts\_ac130::playSoundOverRadio( "ac130_tvo_whitediamonds", true, 4.0 );
	
	flag_set( "allow_context_sensative_dialog" );
	flag_set("FLAG_ac130_context_sensitive_dialog_guy_in_sight");		
	level thread level_enemy_killed();

	wait(1);	
	timeout = 8;
	
	level.ac130_player display_hint_timeout( "HINT_ac130_using_zoom", timeout );
	level.ac130_player delaythread( 8, ::display_hint_timeout, "HINT_ac130_change_weapons", timeout );
	
	wait(10);
	
	//Only display vision change hint of player is not in the hinted mode
	if(!flag("FLAG_ac130_enhanced_vision_enabled"))
	{
		level.ac130_player display_hint_timeout( "HINT_ac130_enhanced_vision", timeout );
	}	
	
	while(isdefined(level.current_hint) )
	{
		wait(.5);
	}	
	
	wait(5);
	
	if(flag("FLAG_ac130_enhanced_vision_enabled"))
	{
		level.ac130_player display_hint_timeout( "HINT_ac130_thermal_vision", timeout );
	}	

	// Shadows
    //SetSavedDvar( "sm_sunenable", 1.0 );
   // SetSavedDvar( "sm_sunsamplesizenear", 2.9 );
}
	

laptop_logic()
{
	level endon("c130_destroyed");
	
	trigger = Spawn( "script_model", self.origin );	
	
	self.trigger = trigger;

    interval = .05;
    timesofar = 0;
    planttime = 2;

	trigger.angles = self.angles;
	trigger setModel( "com_laptop_2_open_obj" );
	trigger makeUsable();
	trigger SetHintString( &"PLATFORM_HOLD_TO_USE" );
	
	while ( true )
    {
        trigger waittill( "trigger", activator );
		activator disableweapons();
        activator freezeControls( true );

		//activator playsound( "scn_enter_code_typing" );

        // set hint string on trigger
        trigger trigger_off();
		
        activator startProgressBar( planttime );
        
        if(!flag("laptop_1_hacked") )
        {
        	activator.progresstext settext( &"SO_ASSAULT_RESCUE_2_LAPTOP1_STATUS" );
        }
        else
        {
        	activator.progresstext settext( &"SO_ASSAULT_RESCUE_2_LAPTOP2_STATUS" );	
        }	
        
        success = false;

        while ( true )
        {
            if ( !activator useButtonPressed() )
                break;

            timesofar += interval;
            activator setProgressBarProgress( timesofar / planttime );
           // level.turret_player setProgressBarProgress( timesofar / planttime );

            if ( timesofar >= planttime )
            {
                success = true;
                break;
            }
            wait interval;
        }

        activator endProgressBar();
        //level.turret_player endProgressBar();

        if ( success )
            break;

        // give information that input failed.
       // activator stopsounds( "scn_enter_code_typing" );
        trigger trigger_on();
		activator freezeControls( false );
        activator enableweapons();
    }

	activator enableweapons();
	activator freezeControls( false );

    activator stopsounds( "scn_enter_code_typing" );
    
	// Something like: laptop_0_hacked
	flag_comp_hacked = self.script_noteworthy + "_hacked";
	
	AssertEx( flag_exist( flag_comp_hacked ), "The following generated flag does not exist: " + flag_comp_hacked );
	if ( flag_exist( flag_comp_hacked ) )
	{
		flag_set( flag_comp_hacked );
	}

	level notify( "computer_hacked" );
	
	trigger delete();
	//terminal = self get_linked_ent();
	//level.turret_player maps\_remoteturret::transfer_to_new_terminal( level.turret_player.terminal, terminal );
	//level.turret_player.terminal = terminal;
	
	
	
}

startProgressBar( planttime )
{
    // show hud elements
    self.progresstext = self createSecondaryProgressBarText();
    self.progressbar = self createSecondaryProgressBar(); 
}

setProgressBarProgress( amount )
{
    if ( amount > 1 )
        amount = 1;

    self.progressbar updateBar( amount );
}

endProgressBar()
{
    self notify( "progress_bar_ended" );
    self.progresstext destroyElem();
    self.progressbar destroyElem();
}

// should be moved to _hud.gsc
createSecondaryProgressBar()
{
    bar = self createClientBar( "white", "black", level.secondaryProgressBarWidth, level.secondaryProgressBarHeight );
    bar setPoint( "CENTER", undefined, 0, level.secondaryProgressBarY );
    return bar;
}

// should be moved to _hud.gsc
createSecondaryProgressBarText()
{
    text = self createClientFontString( "default", level.secondaryProgressBarFontSize );
    text setPoint( "CENTER", undefined, 0, level.secondaryProgressBarTextY );
    return text;
}

enemy_logic(skipto)
{
	switch ( skipto )
	{
	  case "start_entrance":
	  	//8 enemies in construction site
	  	level thread spawn_attack_hinds();
	  	level thread chopper_dropoffs();
	
		so_construction_floods = getentarray("so_construction_floods", "targetname" );
		array_spawn_function_targetname( "so_construction_floods",::construction_floods_logic);
		array_spawn_function_targetname( "front_yard_floods",::construction_floods_logic);
				
		suburban_two = spawn_vehicle_from_targetname_and_drive("suburban_two");
		wait(.10);
		suburban_two thread make_my_riders_c130_targets();
		suburban_two veteran_gunner();
		//suburban_two Vehicle_SetSpeed(10, 5);
		suburban_two thread unload_at_end_node();
		
		j_suburban_four = spawn_vehicle_from_targetname ("suburban_four");
		j_suburban_five = spawn_vehicle_from_targetname("suburban_five");
		j_suburban_four thread gopath_on_flag( "player_on_road", 3 );
		j_suburban_five thread gopath_on_flag( "player_on_road", 5 );
	
		//13 one time spawners on the ground and top of construction
		roof_spots = getstructarray("construction_roof", "targetname");
		
		onetime_spawners = getentarray("onetime_spawners", "targetname");
		array_spawn_function_targetname( "onetime_spawners",::make_me_ac130_target);
		array_spawn_function_targetname( "onetime_spawners",::ai_enemy_kill_dialogue_monitor);
		array_spawn_function_noteworthy("construction_roof", ::retreat_to_area, roof_spots);
		array_spawn( onetime_spawners, true, true );
		
		//couple of flood spawners in shipping container approaching construction site	
		front_yard_floods = getentarray("front_yard_floods", "targetname" );
		maps\_spawner::flood_spawner_scripted( front_yard_floods );
							
		suburban_four = spawn_vehicle_from_targetname_and_drive("so_road_suburban");	
		wait(.10);
		suburban_four thread make_my_riders_c130_targets();
				
		flag_set( "first_enemies_spawned" );	
		array_delete( onetime_spawners );
		
		wait(4);
		//floods basement, back of construction  	
		maps\_spawner::flood_spawner_scripted( so_construction_floods );
		
		balcony_goalstructs = getstructarray("balcony_goalstruct", "targetname");	
		tunnel_entrance_balcony_spawners = getentarray("tunnel_entrance_balcony", "targetname");
		array_thread(tunnel_entrance_balcony_spawners, ::add_spawn_function, ::retreat_to_area, balcony_goalstructs, 1);
		
		array_spawn_function_targetname( "basement_riotshield", ::riotshield_guy_logic);
		
		flag_wait("player_entered_basement");
		
		//3 spawners in shipping container outside
		array_spawn_function_targetname("objective1_chasers", ::make_me_ac130_target);
		player_chase_spawners = getentarray("objective1_chasers", "targetname");		
		array_spawn( player_chase_spawners, true, true );
		
		wait(3);
		array_spawn( player_chase_spawners, true, true );
		
		//FIRST OBJECTIVE DONE
		flag_wait("laptop_1_hacked");
		obj2_balcony_structs = getstructarray("objective2_balcony", "targetname");
		array_spawn_function_targetname( "objective2_balcony", ::retreat_to_area, obj2_balcony_structs, 1);
		
		rear_yard = getstructarray("rear_yard", "targetname");
		array_spawn_function_targetname( "obj2_intercept", ::retreat_to_area, rear_yard, 1);
		array_spawn_function_targetname( "garage_enemies", ::retreat_to_area, rear_yard, 1);
	
		//spawn guys on blacony to right of tunnel entrance
		array_spawn( tunnel_entrance_balcony_spawners, true, true );
		wait(1);
		//6 spawners under that same garage, move to the area by the trailer
		obj2_intercepts = GetEntArray( "obj2_intercept", "targetname" );
		array_spawn( obj2_intercepts, true, true );
		
		//player in trailer for obj2..flood guys from where obj1 is
		flag_wait( "player_in_trailer" );
		array_spawn_function_targetname( "construction_floods_backend",::construction_floods_logic);
		construction_floods_backend  = GetEntarray( "construction_floods_backend", "targetname" );
		maps\_spawner::flood_spawner_scripted( construction_floods_backend );
	
		//SECOND OBJECTIVE DONE
		flag_wait("laptop_2_hacked");
		array_spawn_targetname( "objective2_balcony", true, true );
		
		//player sees main garage where next objective is:
		flag_wait ("garage_opening");	
		
		//2 suburbans come out of garage
		trucks = spawn_vehicles_from_targetname_and_drive( "garage_suburban" );
		wait(.15);
		array_thread( trucks, ::unload_at_end_node);
		array_thread( trucks, ::make_my_riders_c130_targets);
		
		delaythread(.05, ::array_spawn_targetname, "garage_enemies", true, true );
	
		
	
	 case "start_tunnel":		
		
	 case "start_rappel":	
	 	
	 case "start_rappel_bottom":	
	
	}
}

gopath_on_flag( the_flag, optional_delay )
{
	self endon("death");
	self mgoff();
	flag_wait( the_flag );
	
	if(isdefined( optional_delay ) )
	{
		wait( optional_delay );
	}	
	
	self mgon();
	self thread make_my_riders_c130_targets();
	gopath(self);

}	

missile_launchers()
{	
	flag_wait ("first_enemies_spawned");
	wait(10);
	missile_launchers = [];
	missile_launchers[0] = getent("missile_launcher1", "script_noteworthy");
	missile_launchers[1] = getent("missile_launcher2", "script_noteworthy");
	
	missile_launchers = array_randomize( missile_launchers );
	foreach(launcher in missile_launchers)
	{
		launcher thread missile_launcher_attack();
		launcher waittill("destroyed");
		flag_set( "missile_launcher_destroyed" );
	}	
	
}

missile_launcher_attack()
{	
	//self = destructible missile_launcher
	self endon("destroyed");
	level.ground_player endon( "death" );
	structs = getstructarray (self.script_noteworthy +"_source", "targetname");
	while(1)
	{
		foreach(struct in structs)
		{
			struct thread shoot_missile_from_me();
			wait(.5);
		}	
		wait(25);
	}	
		
}	

shoot_missile_from_me()
{	
	//self = ent to magic_bullet FROM
	//psuedo javelin type missile:
	
	random_offset = randomintrange( 80, 300 );
	above_player  = level.ground_player.origin +(0,0,5000);	
	missile = magicbullet("stinger", self.origin, level.ground_player.origin);
	missile missile_settargetpos( above_player );
	missile missile_setflightmodetop();
	//level thread draw_line_for_time( missile.origin, above_player, 1, 0, 0, 3 );	
	wait(2);
	
	if(isdefined(missile) )
	{
		missile missile_settargetent ( level.ground_player, (random_offset,random_offset,random_offset) );
	}	
	//looping sound on missile? missile_lock_loop		
}	

obj1_fail_monitor()
{
	//player didnt make it in time, launch AA at c130
	level endon("laptop_1_hacked");
	launch_time = level.obj1_time - 11;
	//launch_time = 10; //TESTING
	flag_wait("so_assault_rescue_2_start");
	
	wait( launch_time );
	if(!flag("laptop_1_hacked")) 
	{
		flag_set("missile_launch");	
		level thread c130_missile_launch();
		level thread launch_vo();
	}	

}	

launch_vo()
{
	level endon( "laptop_1_hacked");	
	// "Missiles in the air!  Repeat, missiles in the air!"
	radio_dialogue( "so_aslt_rescue2_hqr_missles" );			
	thread vehicle_scripts\_ac130::playSoundOverRadio( "so_aslt_rescue2_plt_brace", false, 4.0 );	
}	

c130_missile_launch()
{
	//missiles have launched. Change Timer label to DEOTANTE instead of Launch
	foreach( player in level.players )
	{
		player.hud_so_timer_msg.label = &"SO_ASSAULT_RESCUE_2_TIMER_OBJ1_A";
	}
	
	struct= getstruct ("missile_launch", "targetname");
	thread missile_announcements();
	
	for(i = 0; i < 3; i++)
	{
		struct thread shoot_c130_missile_from_me();
		wait(1);
	}
		
}	
	
missile_announcements()
{		
	pa_speakers = getstructarray ("pa_speaker", "targetname");
	//foreach(speaker in pa_speakers)
		//level thread play_sound_in_space ("prague_loud_speaker", speaker.origin );
	ent = spawn ("script_origin", pa_speakers[0].origin);
	ent.angles = (0,10,0);
	ent thread play_loop_sound_on_entity ("emt_alarm_base_alert");
	
	flag_wait_any("c130_destroyed", "laptop_1_hacked");	
	
	ent thread stop_loop_sound_on_entity("emt_alarm_base_alert");			
	level.ac130_player thread stop_loop_sound_on_entity("missile_warning");		
}	



shoot_c130_missile_from_me()
{	
	//self = ent to magic_bullet FROM
	
	above_me  = self.origin +(0,0,1000);	
	missile = magicbullet("stinger", self.origin, level.coop_ac130_vehicle.origin);
	//zippy_rockets
	if(!level.c130_missile_fired )
	{
		level thread missile_det_check();
		level.c130_missile_fired = 1;
	}		
	
	missile missile_settargetpos( level.coop_ac130_vehicle.origin);
	missile missile_setflightmodetop();
	//level thread draw_line_for_time( missile.origin, above_player, 1, 0, 0, 3 );	
	wait(.5);
	
	if(isdefined(missile) )
	{
		missile missile_settargetent ( level.coop_ac130_vehicle, (0,0,0) );
	}	
}		

missile_det_check()
{
	//self = missile	
	level endon( "laptop_1_hacked" );
	level thread c130_detonation();
	/*
	self endon( "death" );
	dist = Distance2D( self.origin, level.ac130_player.origin );
	while(dist > 600)
	{
		dist = Distance2D( self.origin, level.ac130_player.origin );
		//iprintlnbold (dist);	
		wait(.05);
	}
	
	flag_set("c130_destroyed");
	*/
}

c130_detonation()
{
	level endon ("laptop_1_hacked"); //obj completed
	level.ac130_player thread play_loop_sound_on_entity("missile_warning");
	
	wait(11);
	
	//MISSION FAILED AT THIS POINT
	flag_set("c130_destroyed");
	level thread play_sound_in_space( "c130_blows_up", level.coop_ac130_vehicle.origin );
	playfx ( getfx("bomb_explosion_ac130"), level.ac130_vehicle.origin );
	wait(.2);
	level.coop_ac130_vehicle hide();
	earthquake(.4, .4, level.ground_player.origin, 200);	
	earthquake(1, .5, level.ac130_player.origin, 200);
	
	//creates the staticFX shader in PIP
	static = newclienthudelem(level.ac130_player);
	static.alpha = .6;
	static.horzAlign = "fullscreen";
	static.vertAlign = "fullscreen";
	//hud.sort = -50;
	static.hidewheninmenu = false;
	static SetShader( "overlay_static", 640, 480 ); //shader needs to be in CSV and precached		
	wait(1);
	missionFailedWrapper();
}


riotshield_guy_logic()
{
	self endon("death");
	
	org = self get_Target_ent();
	self.goalradius = 32;
	self setGoalPos( org.origin );
		
	while(1)
	{
		if(level.ground_player ent_flag("player_in_basement"))
		{
			self setGoalPos( level.ground_player.origin );
		}
		else
		{
			self setGoalPos( org.origin );
		}
		wait(1);
	}
			
}

player_basement_check()
{
	//TODO ENDON
	trigger_wait_targetname("player_entered_basement");
	trig = getent("construction_basement", "targetname");
	
	while(1)
	{
		if(level.ground_player istouching(trig))
		{		
			level.ground_player ent_flag_set("player_in_basement");
		}
		else
		{
			level.ground_player ent_flag_clear("player_in_basement");
		}
		wait(1);
	}
}	
		
delete_on_flag(the_flag)
{
	flag_wait( the_flag );
	if(isdefined( self) )
	{
		self delete();
	}	
	
}	

make_me_ac130_target()
{
	self endon("death");
	wait( randomintrange(1, 5) ); //need to throttle this
	vehicle_scripts\_ac130::hud_add_targets( [ self ] );	
}	


retreat_to_area(spots, c130_target)
{	
	//spots = array of structs
	self endon("death");
	if(isdefined(c130_target))
	{
		vehicle_scripts\_ac130::hud_add_targets( [ self ] );
	}	
	self thread ai_enemy_kill_dialogue_monitor();
	
	self notify ("new_retreat_pos");
	self endon ("new_retreat_pos");	
	
	spot = random(spots);	
	self.goalradius = randomintrange(150, 200);
	wait(randomfloatrange(.2, 1) );
	self notify( "stop_going_to_node" );
	self.ignoresuppression = 1;
	self setgoalpos (spot.origin);
	//self thread draw_line_for_time( self.origin, spot.origin, 1, 0, 0, 1 );	

	self waittill ("goal");
	self.ignoresuppression = 0;
	self.goalradius = 400;
}	

construction_floods_logic()
{	
	self endon ("death");
	self thread ai_enemy_kill_dialogue_monitor();
	self thread make_me_ac130_target();
	//TODO balance for gameskill
	if(randomint(100) <50)
	{
		self.grenadeammo = 0;
	}	
	
	self.goalradius = randomintrange(1000, 1500);
	self setgoalentity(level.ground_player);
	//self waittill("goal");
	//self thread Print3d_on_me("!");	
}	

chopper_dropoffs()
{
	//a few mi17's dropping off enemies
	//TOODO ENDON
	wait(8);
	chopper1 = getent("chopper_dropoff1", "targetname");
	chopper2 = getent("chopper_dropoff2", "targetname");

	level.dropoff_chopper = chopper1 spawn_vehicle_and_gopath();
	wait(.10);
	level.dropoff_chopper thread make_my_riders_c130_targets();
	level.dropoff_chopper thermaldrawenable();	
	level.dropoff_chopper thread vehicle_kill_dialogue_monitor();
	
	while(isdefined(level.dropoff_chopper))
	{
		wait(1);
	}
	
	wait(10);	
	level.dropoff_chopper = chopper2 spawn_vehicle_and_gopath();
	wait(.10);
	level.dropoff_chopper thread make_my_riders_c130_targets();
	level.dropoff_chopper thermaldrawenable();	
	level.dropoff_chopper thread vehicle_kill_dialogue_monitor();	

}

make_my_riders_c130_Targets()
{
	self thermaldrawenable();
	
	if ( self Vehicle_IsPhysVeh() )
	{
		self.veh_pathtype = "constrained";
	}	
	
	wait( randomfloatrange(.1, .5) );
	self thread vehicle_scripts\_ac130::hud_add_targets( [ self ] );
	foreach(rider in self.riders)
	{
		if ( !IsAlive( rider ) )
		{
			continue;
		}
		
		if ( !IsDefined( rider ) )
		{
			continue;
		}
				
		rider thread make_me_ac130_target();
		rider thread ai_enemy_kill_dialogue_monitor();
	}	
	
	self waittill("death");
	if( IsDefined( self ) )
	{
		self thermaldrawdisable();
	}	
	
}	
	

spawn_attack_hinds()
{
	//gets closest of 4 hind spawners and spawns one
	flag_wait("player_on_road");
	level endon ("so_assault_rescue_2_complete" );
	//level endon("missile_launch");
	//=-=-=-=-=-=-
	//Ent for Hind to chase
	//=-=-=-=-=-=-
	random_z = 1200;//randomintrange(1000, 2000);
	random_fwd = randomintrange(1800, 2500);
	random_side = randomintrange(800, 1600);
	
	fwd = anglestoforward( level.ground_player getplayerangles() );
	front = (fwd) * (random_fwd);	
	in_front_of_player = level.ground_player.origin + front;
	
	target_pos = ( in_front_of_player[0], in_front_of_player[1], in_front_of_player[2] + random_z);  
	
	level.ground_player.target_ent = spawn("script_origin", target_pos);
	level.ground_player.target_ent linkto( level.ground_player );

	//level thread draw_line_from_ent_to_ent_for_time( level.ground_player, level.ground_player.target_ent, 0, 0, 1, 10000 );
	
	//easy or less
	if( level.gameSkill < 2 )
	{
		time_between_hinds = 45;
	}	
	//hard 
	else if( level.gameSkill == 2 )
	{
		time_between_hinds = 30;
	}	
	//veteran 
	else
	{
		time_between_hinds = 25;
	}
	
	musicplaywrapper("specops_ac130_over_mine_music");
	
	while(1)
	{
		hind_spawners = getentarray("so_attack_hind", "targetname");
		closest_hind  = getClosest( level.ground_player.origin, hind_spawners );
		closest_hind.count = 1;
		attack_hind_1 = closest_hind spawn_vehicle();
		wait(.10);
			
		thread maps\_specialops_code::so_dialog_play( "ac130_plt_birdsinbound", 1 );	//incoming_hind_warning
	
		//thread maps\_specialops_code::so_dialog_play( "incoming_hind_warning", 1);	
		
		attack_hind_1 thread make_me_ac130_target();
		attack_hind_1 thread chopper_attack_logic();
		attack_hind_1 thermaldrawenable();		
		attack_hind_1 waittill("death");	
		level.enemy_hind_killed = 1;
		wait( time_between_hinds );
	}	
	
}		

Chopper_Attack_Logic()
{
	//self = enemy chopper 
	self endon ("death");
	//self.enableRocketDeath = true;
	self.preferred_crash_style = 2;
	self thread hind_attach_turret();

	self thread hind_attack_player(level.ground_player);
	
	//large trigger in the sky 
	hind_safe_zone = getent("hind_safe_zone", "targetname");
	
	while(1)
	{	
		if( level.ground_player.target_ent isTouching( hind_safe_zone ) )
		{
			self SetVehGoalPos( level.ground_player.target_ent.origin, 1 );
			self setlookatent( level.ground_player );
			self waittill ( "goal" );
			wait( randomfloatrange(3, 5) );
		}			
		else
		{
			wait(1);
		}	
	}	

}	

hind_attack_player(target_player)
{
	//self = hind
	self endon("death");
	level endon("so_assault_rescue_2_complete");
	//level endon("missile_launch");
	level endon( "challenge_timer_expired" );
	level endon( "special_op_failed" );
	target_player endon("death");
	
	wait(5);
	//how many times it uses the MG before using rockets
	//offset is for MG here
	self.attack_turns = 0;
	self.turns_before_using_rockets = undefined; //how many times it attacks with MG before using rockets too
	offset = undefined;
	
	if(level.gameskill < 2)
	{
		self.turns_before_using_rockets = 3;
		//offset = randomintrange(150, 200);	
	}
	else if(level.gameskill == 2)
	{
		self.turns_before_using_rockets = 2;
		//offset = randomintrange(100, 120);
	}	
	else
	{
		self.turns_before_using_rockets = 2;
		//offset = randomintrange(50, 100);
	}
	
	while(1)
	{	
		//self.minigun settargetentity ( target_player, (offset, offset, offset) );
		////self thread draw_line_for_time( self.origin, spot.origin, 1, 0, 0, 1 );	
		wait(randomfloatrange(.5, 1.4) );
		if(!level.ground_player ent_flag( "player_in_basement" ) )
		{
			self.attack_turns ++;
			if( self.attack_turns >= self.turns_before_using_rockets)
			{
				self thread hind_fire_rockets();
				self.attack_turns = 0;
			}
		
			self.minigun burst_fire();
			//self burst_fire();
			wait(randomintrange(5, 8) );	
		}
		else
		{
			wait(1);
		}				
	}	

}	
 
 
burst_fire()
{
	// self = hind minigun
	self endon("so_assault_rescue_2_complete");
	self thread stop_shooting_on_death();
	bullet_count = randomintrange(80, 170);
	self startbarrelspin();	
	
	if(level.gameskill < 2)
	{		
		offset_min = 150;
		offset_max = 200;

	}
	else if(level.gameskill == 2)
	{	
		offset_min = 100;
		offset_max = 120;	
	}	
	else
	{
		offset_min = 50;
		offset_max = 100;
	}
		
	wait(1);
		
	for(i = 0; i< bullet_count; i++)
	{
		offset = randomintrange( offset_min, offset_max );
		//self thread draw_line_for_time( self.origin,  level.ground_player.origin + (offset, offset, 0), 1, 0, 0, 1 );	
		if( cointoss() )
		{
			offset = offset * -1;
		}	
		self settargetentity( level.ground_player,  (offset, offset, 0) );
		wait(.05);
		self shootturret();		
	}	
	
	self stopbarrelspin();		
	self notify("done_shooting");
}	

stop_shooting_on_death()
{
	//the hind notifies "death" to his self.minigun when the hind dies
	//self endon("done_shooting");
	self waittill("death");
	self stopbarrelspin();	
}	

Hind_fire_rockets()
{
	//self = hind
	self thread play_sound_on_entity ("missile_lock_loop");
	self endon("death");
	pair_of_rockets = undefined;	
	offset = undefined;
	
	if(level.gameskill < 2)
	{
		offset = randomintrange(300, 400);
		pair_of_rockets = 2;
	}
	else if(level.gameskill == 2)
	{
		offset = randomintrange(250, 300);
		pair_of_rockets = 2;
	}	
	else
	{
		offset = randomintrange(200, 250);
		pair_of_rockets = 3;
	}
	
	opposite_offset = offset*-1;
	
	for(i = 0; i<pair_of_rockets; i++)
	{
		target_spot = level.ground_player.origin + (offset, offset, 0);
		magicbullet("zippy_rockets", self gettagorigin("tag_missile_left"), target_spot );
		wait(.3);
		
		target_spot = level.ground_player.origin + (opposite_offset, opposite_offset, 0);
		magicbullet("zippy_rockets", self gettagorigin("tag_missile_right"), target_spot );
		wait(.8);
	}
			
	/*
	weapon,sp/stinger
	weapon,sp/stinger_speedy
	weapon,sp/zippy_rockets
	*/
	//tag_missile_left
	//tag_missile_right
	//tag_flash_22
	//tag_flash_2
	
}	

hind_attach_turret()
{
	//self = hind
	//self endon("death");
	self.minigun = spawnturret("misc_turret", self gettagorigin("tag_turret"), "suburban_minigun");//btr80_ac130_turret minigun_littlebird suburban_minigun
	self.minigun.angles = self gettagangles("tag_turret") -(0,0,180) ;
	self.minigun setmodel("weapon_minigun");//weapon_minigun //weapon_saw_MG_setup
	self.minigun linkto(self, "tag_turret");
	self.minigun setmode("manual");
	self.minigun setturretteam("axis");
	self.minigun setdefaultdroppitch(0);
	self.minigun SetAISpread(5); //6 = shot but not killed
	
	self waittill("death");
	self.minigun notify( "death" );
}	
	

unload_at_end_node()
{
	self endon ("death");
	self waittill("reached_end_node");
	self vehicle_unload("all");
}		
		
veteran_gunner()
{
	self endon ("death");
	//self = suburban
	if(level.gameskill !=3)
	{
		foreach(rider in self.riders)
		{
			if(isdefined (rider.script_noteworthy) )
			{
				if(rider.script_noteworthy == "minigun_guy")
				{
					rider delete();
				}
			}
		}			
	}
}		
	

c130_player_transition()
{
	trig = getent("hallway_dropdown", "targetname");
	bridge_struct = getstruct("c130_player_start", "targetname");
	trig waittill("trigger");
	
	if(!isDefined(level.ac130_player))
	{
		return;
	}
	 
	flag_set("player_transition_started");
	level thread client_fade_out_in_on_flag(level.ac130_player, "black", "ac130Player_on_ground");
	wait(.5);
	
	level.ac130_player freezeControls( true );
	origin = bridge_struct.origin;
	ent = spawn( "script_model", level.ac130_player.origin);
	ent setmodel ("tag_origin");
	ent.angles = level.ac130_player.angles;
	vehicle_scripts\_ac130::end_ac130(); 
	
	level.ac130_player enableinvulnerability();
	level.ac130_player playerlinktoabsolute( ent, "tag_origin" );
	
	ent moveto( bridge_struct.origin, .5);
	ent rotateto( bridge_struct.angles, .5); //0 277.739 0

	//level.player VisionSetNakedForPlayer( "coup_sunblind", 1.3 );
	wait(1);
	
	level.ac130_player unlink();
	level.ac130_player setplayerangles(bridge_struct.angles);
	level.ac130_player allowcrouch(true);
	level.ac130_player allowprone(true);
	level.ac130_player setstance( "stand" );
	level.ac130_player.ignoreme = 0;

	
	level.default_vision = GetDvar( "vision_set_current" );
	level.ac130_player VisionSetNakedForPlayer( level.default_vision, .05 );
	level.ac130_player freezeControls( false );
	level.ac130_player show();
	wait(.05);

	//level arm_player();	
	flag_set("ac130Player_on_ground");
	
	level.ground_player maps\_coop::FriendlyHudIcon_Enable();
	level.ac130_player thread arm_player();
	
	//god mode buffer time
	wait(5);
	ent delete();
	//level.player enabledeathshield(false);
	level.player disableinvulnerability();

}	

	

client_fade_out_in_on_flag(the_player, fade_color, flag_notify)
{
	//fade out/fade in on flag
	overlay = newclienthudelem(the_player);
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( fade_color, 640, 480 );//"black", "white"
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;

	overlay fadeOverTime( .5 );
	overlay.alpha = 1;
	
	wait(.5);
	
	flag_wait( flag_notify );
	//this value is "8" while in the ac130. TODO change back when we return to ac130
	SetSavedDvar("sm_SunSampleSizeNear", "0.25");
	
	wait( .5);
	
	overlay fadeOverTime( .5);
	overlay.alpha = 0;	
	wait(1);

	overlay destroy();

}

Print3d_on_me( msg ) 
{ 
 /# 
	self endon( "death" );  
	self notify( "stop_print3d_on_ent" );  
	self endon( "stop_print3d_on_ent" );  

	while( 1 ) 
	{ 
		print3d( self.origin + ( 0, 0, 0 ), msg );  
		wait( 0.05 );  
	} 
 #/ 
 }
 
 //Chetan Util stuff
random_chance( percent )
{
    precent = clamp_op( percent, 0, 1 );
    return ter_op( ( RandomFloatRange( 0, 1 ) >= ( 1 - percent ) ), 1, 0 );
}

clamp_op( x, a, b, _clamp, _default )
{
	// 0 - floor, if x undefined
	// 1 - ceil, if x undefined
	
	_clamp = ter_op( IsDefined( _clamp ), _clamp, 0 );
	
	if ( IsDefined( x ) && IsDefined( a ) && IsDefined( b ) )
		return Clamp( x, a, b );
	if ( IsDefined( x ) )
		if ( IsDefined( a ) && !IsDefined( b ) )
			return ter_op( a <= x, a, b );
		else
		if ( !IsDefined( a ) && IsDefined( b ) )
			return ter_op( x <= b, x, b );
		else
			return x;
	if ( !_clamp && IsDefined( a ) )
		return a;
	if ( IsDefined( b ) )
		return b;
	if ( IsDefined( a ) )
		return a;
	return _default;
}

// -.-.-.-.-.-.-.-.-.-.-.-. Custom End of Game Summary  -.-.-.-.-.-.-.-.-.-.-.-. //

custom_eog_summary()
{	
	// Total Score Calculations
	time_mil	= level.challenge_end_time - level.challenge_start_time;
	time_sec	= time_mil / 1000;
	time_string	= convert_to_time_string( time_sec, true );
	
	score_diff	= level.specops_reward_gameskill * 10000;
	score_max	= score_diff + 9999;
	
	// Score Time out of 6000 (though 6000 is from beating the mission in 0 seconds)
	time_mil_max	= ( level.obj1_time + level.obj2_time ) * 1000;
	time_mil_remain = time_mil_max - time_mil;
	score_time		= ( time_mil_remain / time_mil_max ) * 6000;
	score_time		= Int( Min( score_time, 4999 ) );
	
	// Score Kills out of 6000 allows for 
	// a max of 240 guys at 25 points a guy
	score_kills	= 0;
	foreach ( player in level.players )
	{
		score_kills += player.stats[ "kills" ] * 25;
	}
	score_kills = Int( Min( score_kills, 4999 ) );
	
	score_final = Int( Min( score_diff + score_time + score_kills, score_max ) );
	
	//  This mission is only co-op
	foreach ( player in level.players )
	{
		setdvar( "ui_hide_hint", 1 );
		
		p1_gameskill	= so_get_difficulty_menu_string( player.gameskill );
		p1_kills		= player.stats[ "kills" ];
		p2_gameskill	= so_get_difficulty_menu_string( get_other_player( player ).gameskill );
		p2_kills		= get_other_player( player ).stats[ "kills" ];
		
		if ( IsDefined( level.MissionFailed ) && level.MissionFailed == true )
		{
			player add_custom_eog_summary_line( "",									"@SPECIAL_OPS_PERFORMANCE_YOU",	"@SPECIAL_OPS_PERFORMANCE_PARTNER" );
			player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY",		p1_gameskill,					p2_gameskill );
			player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS",			p1_kills,						p2_kills );
			player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME",		 		time_string,					time_string );
		}
		else
		{
			player add_custom_eog_summary_line( "",									"@SPECIAL_OPS_PERFORMANCE_YOU",	"@SPECIAL_OPS_PERFORMANCE_PARTNER", "@SPECIAL_OPS_UI_SCORE" );
			player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY",		p1_gameskill,					p2_gameskill,						score_diff );
			player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS",			p1_kills,						p2_kills,							score_kills );
			player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME",		 		time_string,					time_string,						score_time );
			player add_custom_eog_summary_line_blank();
			player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TEAM_SCORE",																			score_final );
			
			// Override each player's time and score
			player override_summary_time( time_mil );
			player override_summary_score( score_final );
		}
	}
}
