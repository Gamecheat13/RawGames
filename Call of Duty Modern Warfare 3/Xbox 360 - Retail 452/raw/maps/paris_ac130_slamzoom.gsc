#include maps\_hud_util;
#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;

#using_animtree("generic_human");
start_intro()
{

	init_intro_flags();
	init_intro_radio();

	level thread intro_vo();
	level thread intro_fx();
	level thread fade_in_on_flag("black", "intro_setup_complete", 2);
	level thread new_intro_ambient_jets();
	level thread new_intro_slamzoom();
	level thread intro_osprey();
	level thread intro_friendly_init();
	level thread intro_enemies();
	level thread osprey_crash();
	level thread osprey_crash_player_knockout();
	level thread thermal_ents();
	
	intro_aa_fire_ents = getentarray("intro_aa_fire", "targetname");
	array_thread( intro_aa_fire_ents, ::aa_fire, "intro_osprey_hit");
	
	flag_wait("new_intro_complete");
	level thread intro_enemy_vehicles();
	battlechatter_off("allies");
	
	level.scr_anim[ "generic" ][ "run_reaction_180" ]	=%run_reaction_180;
	level.scr_anim[ "generic" ][ "run_turn_180" ]	=%run_turn_180;
	level.scr_anim[ "generic" ][ "corner_stand_explosion_B" ]	=%corner_standL_explosion_B;
	level.scr_anim[ "generic" ][ "intro_wave" ]	=%payback_escape_start_wave_soap;
	
	ambient_bombing_run_structs = getstructarray("intro_ambient_bombing_run", "targetname");
	level thread ambient_bombing_runs( ambient_bombing_run_structs, "intro_osprey_hit" );
	
}


intro_fx()
{   
	level thread spawn_looping_fx_delete_on_flag( ( -6844.95, 49043.9, 4389.57 ), ( 271.964, 298.249, -104.603 ), "FX_c130_paratroop_aircaft", 8, "intro_osprey_hit", 1);
}	

init_intro_radio()
{
	// "Overlord, this is Metal Zero One.  Objective "Gray Wolf" secure - we're moving to the LZ.  "
	level.scr_radio[ "ac130_snd_volksecure" ] = "ac130_snd_volksecure";
	
	// "Solid copy, Metal Zero One.  Raptor Two Four will be on station for evac in two minutes."
	level.scr_radio[ "ac130_hqr_raptor24" ] = "ac130_hqr_raptor24";
	
	// "There's our ride!"
	level.scr_radio[ "ac130_snd_ourride" ] = "ac130_snd_ourride";
	
	// "Get Volk!  Let's go!"
	level.scr_radio[ "ac130_snd_getvolkletsgo" ] = "ac130_snd_getvolkletsgo";
	
	// "Get Volk!  We gotta go!  NOW!"
	level.scr_sound[ "sandman" ][ "ac130_snd_gottagonow" ] = "ac130_snd_gottagonow";
	
	// "Move.  MOVE!"
	level.scr_sound[ "grinch" ][ "ac130_rno_move" ] = "ac130_rno_move";
	
	// "Get your hands off me you bastard!"
	level.scr_sound[ "volk" ] [ "ac130_vlk_handsoffme" ] = "ac130_vlk_handsoffme";

	// "Try any shit and I'll put a bullet through you."
	level.scr_sound[ "grinch" ][ "ac130_rno_tryany" ] = "ac130_rno_tryany";
	
	// "Fuck you!"
	level.scr_sound[ "volk" ][ "ac130_vlk_fyou" ] = "ac130_vlk_fyou";
	
	// "Let's go, let's go!  C'mon!"
	level.scr_sound[ "sandman" ][ "ac130_snd_letsgocmon" ] = "ac130_snd_letsgocmon";

	// "This is Raptor Two Four, we're hit!  We're going down!  We're going down!"
	level.scr_radio[ "ac130_osp_goingdown" ] = "ac130_osp_goingdown";
	
	// "Brace!"
	level.scr_radio[ "ac130_osp_brace" ] = "ac130_osp_brace";
	
	// "Overlord,  primary LZ is compromised.  Raptor Two Four is down.  Moving to alternate LZ."
	level.scr_radio[ "ac130_snd_alternate" ] = "ac130_snd_alternate";
	
	//Blue One: Gator Six, Blue One, over.
	level.scr_radio[ "ac130_bl1_blueone" ] = "ac130_bl1_blueone";
	
	//Gator Six: Long knife, this is Gator Six.  Need you to screen SOUTH two hundred meters.  You can identify those guys in contact, over.
	level.scr_radio[ "ac130_gt6_longknife" ] = "ac130_gt6_longknife";

}	

new_intro_slamzoom()
{
	arm_player(1);
	intro_slamzoom_start = getent ( "intro_slamzoom_start", "targetname" );
	level.player setplayerangles(intro_slamzoom_start.angles);
	ent = spawn( "script_model", intro_slamzoom_start.angles );
	ent setmodel ("tag_origin" ); 
	ent.origin = level.player.origin;
	ent setmodel( "tag_origin" );
	ent.angles = level.player.angles;
	level.player playerlinkto(ent);
	ent moveto(intro_slamzoom_start.origin, .05);
	ent rotateto(intro_slamzoom_start.angles, .05);
	ent waittill ("rotatedone");
	level.player unlink();
	flag_set ("new_intro_complete");
	
}

new_intro_ambient_jets()
{
	intro_sonic_boom_nodes = getvehiclenodearray("intro_sonic_boom", "script_noteworthy");
	array_thread( intro_sonic_boom_nodes, vehicle_scripts\_f15::plane_sound_node);
	
	intro_jets = getentarray("new_intro_opening_bomber", "targetname");
	array_thread(intro_jets, ::add_spawn_function, ::vehicle_delete_at_end_node );
	
	intro_explosion = getstruct("intro_explosion", "targetname");
	
	wait(2.3);
	
	while(!flag("FLAG_intro_slamout_start"))
	{
		foreach (jet in intro_jets)
		{
			jet.count = 1;
			jet spawn_vehicle_and_gopath();			
			wait(randomintrange(5, 8));
		}
	}
	
	foreach(spawner in intro_jets)
	{
		spawner delete();
	}	

}	
	
vehicle_delete_at_end_node()
{
	self waittill("reached_end_node");
	if(isDefined(self))
	{
		self delete();
	}
}		
		
	
intro_vo()
{

	set_ambient("paris_ac130_groundbegin_ext");
	wait(.5);
	// "There's our ride!"
	level.sandman play_sound_on_entity("ac130_snd_ourride");
	// "Get Volk!  Let's go!"
	level.sandman play_sound_on_entity("ac130_snd_getvolkletsgo");
	
	// "Move.  MOVE!"
	level.bishop play_sound_on_entity("ac130_rno_move");
	// "Get your hands off me you bastard!"
	level.makarov_number_2 play_sound_on_entity("ac130_vlk_handsoffme");
	// "Try any shit and I'll put a bullet through you."
	//level.bishop play_sound_on_entity("ac130_rno_tryany");
	// Fuck you!
	level.makarov_number_2 play_sound_on_entity("ac130_vlk_fyou");
	// "Let's go, let's go!  C'mon!"
	level.sandman play_sound_on_entity("ac130_snd_letsgocmon");
	
	flag_wait("intro_setup_complete");
	
	flag_set("intro_vo_complete");
    flag_set ("FLAG_intro_osprey_event" );
 	autosave_by_name ("paris_ac130__start");
    
	flag_wait("intro_osprey_hit");
	radio_dialogue( "ac130_osp_goingdown" );
	radio_dialogue( "ac130_osp_brace" );
	wait(6);
	musicstop(3);
	radio_dialogue( "ac130_snd_alternate" );
}	

bloom_out_til_flag(bloom_out_time, flag_ender)
{
	
	level.player VisionSetNakedForPlayer( "coup_sunblind", bloom_out_time );
	flag_wait(flag_ender);
	level.player VisionSetNakedForPlayer( "paris_ac130", .2);

}	

intro_enemy_vehicles()
{	
	intro_enemy_chopper_spawners = getentarray( "intro_enemy_choppers", "targetname");
	
	flag_wait("intro_osprey_hit");
	wait(2.5);
	foreach(intro_enemy_chopper_spawner in intro_enemy_chopper_spawners)
	{
		intro_chopper_ai =  intro_enemy_chopper_spawner spawn_vehicle_and_gopath();
		wait(.5);
		intro_chopper_ai thread kill_me_on_flag("FLAG_intro_slamout_start");

/*		foreach(rider in intro_chopper_ai.riders)
		{
			rider thread delete_me_on_flag("FLAG_intro_slamout_start");
		} */
	}	
}

delete_me_on_flag(the_flag)
{
	flag_wait( the_flag );
	if(isdefined(self))
	{
		self delete();
	}	
}

kill_me_on_flag(the_flag)
{
	flag_wait( the_flag );
	if(isdefined(self))
	{
		self kill();
	}	
}
	
intro_osprey_fx()
{
	//wait 2.0	
	smoke_signal_end = GetEnt( "new_intro_smoke", "targetname" );

	fx = getfx( "FX_signal_ac130" );
	fdr_signal_ac130_ref = GetEnt( "new_intro_smoke", "targetname" );
	Assert( IsDefined( fdr_signal_ac130_ref ) );
	fdr_signal_ac130 = Spawn( "script_model", fdr_signal_ac130_ref.origin );
	fdr_signal_ac130.angles = fdr_signal_ac130_ref.angles;
	fdr_signal_ac130 SetModel( "tag_origin" );
	
//	PlayFxOnTag( fx, fdr_signal_ac130, "tag_origin" );

	exploder( "smoke_signal_mellow" );
		
	wait 5.0;
	
	flag_wait( "FLAG_fdr_enemy_vehicles_killed" );
//	StopFXOnTag( fx, fdr_signal_ac130, "tag_origin" );
	fdr_signal_ac130 Delete();

}

init_intro_flags()
{
	flag_init("new_intro_complete");
	flag_init( "intro_setup_complete" );
	flag_init( "intro_top_area_clear" );
	flag_init( "intro_vo_complete" );
	flag_init( "intro_osprey_hit" );
	flag_init("slamzoom_building_hit");
	flag_init("start_flyin");
	flag_init("start_car_crash");
	flag_init("new_player_drop");

	//intro_player_outside set by trig when player exits building
}	


intro_missile_attack(osprey)
{
	
	r_offset_m = ( 76,-74, 25 );//lower for missile
	l_offset_m = ( 76, 74, 25 );
	
	fx_spot = getstruct ("jet_fx", "targetname");
	node = getvehiclenode( "missile_launch", "script_noteworthy" );

	spot1 = getstruct("intro_bomb_explosion_1", "targetname");
	spot2 = getstruct("intro_bomb_explosion_2", "targetname");
	intro_opening_bomber_spawner = getent("intro_opening_bomber", "targetname");
	
	for(i=0; i<2; i++)
	{		
		jet = spawn_vehicle_from_targetname_and_drive("intro_opening_bomber");
		wait(.10);
		jet thread jet_dog_fight();
		
		node waittill( "trigger" );
		jet thread play_sound_in_space( "veh_f15_sonic_boom" );
		intro_opening_bomber_spawner.count = 1;
		wait(1.3);
	}	
}	


	
intro_friendly_init()
{
	// Spawn Delta + Makarov #2
    level.player freezecontrols(true);
	Maps\_utility_chetan::array_spawn_function_pass_prefix_del_key( "delta_", "targetname", 0, Maps\paris_ac130_code::ai_friendly_init );
	Maps\_utility_chetan::array_spawn_function_prefix( "delta_", "targetname", 0, Maps\paris_ac130_code::ai_friendly_on_damage, 1 );
    delta_spawners = Maps\_utility_chetan::get_ent_array_with_prefix( "delta_", "targetname", 0 );
    
    foreach ( i, spawner in delta_spawners )
    {
    	level.delta[ i ] = spawner StalingradSpawn();
    	level.delta[ i ].ignoreall = 1;
    	fail = spawn_failed( level.delta[ i ] );
    	Assert( !fail );
    }	
    
    makarov_number_2_spawner = GetEnt( "makarov_number_2", "targetname" );
    Assert( IsDefined( makarov_number_2_spawner ) );
   	makarov_number_2_spawner add_spawn_function( Maps\paris_ac130_code::ai_friendly_init, "makarov_number_2", "targetname" );
    makarov_number_2_spawner add_spawn_function( Maps\paris_ac130_code::ai_friendly_on_damage, 0 );
    level.makarov_number_2 = makarov_number_2_spawner StalingradSpawn();
    fail = spawn_failed( level.makarov_number_2 );
    Assert( !fail );
    level.makarov_number_2 HidePart( "tag_weapon", "defaultweapon" );
    level.makarov_number_2.ignoreall = true;
    level.makarov_number_2.ignoreme = true;

	level.sandman = level.delta[ 0 ];
    level.sandman.script_noteworthy = "san dman";
    
    level.frost  = level.delta[ 1 ];
    level.frost.script_noteworthy = "frost";
   	level.frost.name = "";
   		
    level.hitman = level.delta[ 2 ];
    level.hitman.script_noteworthy = "hitman";
    level.gator = level.delta[ 3 ];
    level.gator.script_noteworthy = "gator";
    level.bishop = level.delta[ 4 ];
    level.bishop.script_noteworthy = "bishop";
	
    
    level.sandman thread crash_react_left();
    level.gator thread crash_react_stairs();
     
	wait 0.05;
	
    group = level.delta;
    group[ group.size ] = level.makarov_number_2;
    
    foreach ( guy in group )
    {
    	guy Maps\paris_ac130_code::ai_friendly_set_default();
    	guy set_goal_radius( 32.0 );
    	guy.baseaccuracy = 0.2;
    	guy enable_sprint();
    	guy set_force_color("y");
    	//guy.ignoreall = true;
    	guy enable_sprint();
    }
    
    level.hitman thread crash_react_right();
    	
    level.frost Hide();
    level.frost.ignoreme = true;
    level.frost.ignoreall = true;

    Maps\paris_ac130::setup_friendly_pip();
	wait(.10);
	// Sandman intro
	level.sandman.animname = "generic";

    thread intro_delta_guard_and_makarov_number_2_init();
      
    // Set Delta color Nodes
    //level.sandman set_force_color( "y" );
   	level.hitman set_force_color( "y" );
    //level.gator set_force_color( "y" );
    level.bishop set_force_color( "y" );
 
    flag_set ("intro_setup_complete");
    activate_trigger_with_targetname("intro_squad_pos1");
    level.player freezecontrols(false);
    
    flag_wait ("intro_osprey_hit");
    activate_trigger_with_targetname( "crash_retreat" );
    
    Objective_Position(  obj( "OBJ_osprey" ), (0,0,0) );  
    flag_wait("FLAG_intro_slamout_start");
    objective_state( obj("OBJ_osprey"), "done" );
    
    
}

crash_react_left()
{
	self endon ("death");
	//self = level.sandman
	self.ignoreall = true; 
	self.ignoreme = 1;
	flag_wait("FLAG_intro_osprey_1_crash_start");
	self.animname = "generic";
	self.goalradius = 12;
	self disable_ai_color();
	ent = getstruct( "run_turn_180", "targetname");
	
	//flag_wait("new_intro_complete");
	wait(.5);
	ent anim_reach_solo( self, "run_turn_180" );
	//iprintlnbold("Get back!!! INCOMING!!");
	ent thread anim_single_solo_run(self, "run_turn_180");
	wait(.10);
	self set_force_color("y");
	wait(3);
	//self.ignoreall = 0;
	self.ignoreme = 0;
}
	
crash_react_stairs()
{
	self endon ("death");
	flag_wait("FLAG_intro_osprey_1_crash_start");
	self.goalradius = 50;
	self.animname = "generic";
	//self disable_ai_color();
	ent = getstruct("corner_stand_explosion_B", "targetname"); 
	corner_explosion_node = getnode ("corner_explosion_node", "targetname");
	
	flag_wait("intro_osprey_hit");
	wait(6.5);
	ent anim_reach_solo( self, "corner_stand_explosion_B" );
	ent thread anim_single_solo(self, "corner_stand_explosion_B");
	wait(.10);
	self setgoalnode(corner_explosion_node);

}		

crash_react_right()
{
	//self = level.hitman
	self endon ("death");	
	self.animname = "generic";
	self.goalradius = 12;
	self.ignoreall = 1;
	self disable_ai_color();
	ent = getstruct( "run_reaction_180", "targetname");
	intro_wave_ent = getstruct("payback_escape_start_wave_soap", "targetname");
	
	//flag_wait( "intro_setup_complete" );
	wait(1.5);
	intro_wave_ent anim_reach_solo( self, "intro_wave" );
	intro_wave_ent  anim_single_solo_run(self, "intro_wave");
	self enable_ai_color();
	
	flag_wait("FLAG_intro_osprey_1_crash_start");
	ent anim_reach_solo( self, "run_reaction_180" );
	ent thread anim_single_solo_run(self, "run_reaction_180");
	wait(.10);
	//self set_force_color("y");
	
	node = getnode ("intro_attack_node", "targetname");
    self.goalradius = 32;
    self setgoalnode (node);
    
}	


intro_delta_guard_and_makarov_number_2_init()
{
	intro_hvt_arrive_hvt = getstruct("intro_hvt_arrive_hvt", "targetname");
	intro_hvt_arrive_guard = getstruct("intro_hvt_arrive_guard", "targetname");
	intro_hvt_idle = getstruct("intro_hvt_idle", "targetname");
	
	level.bishop.animname = "guard";
	level.bishop clear_force_color();
	level.makarov_number_2.animname = "hvt";
	
	looping_guys = [];
	looping_guys[0] = level.bishop;
	looping_guys[1] = level.makarov_number_2;
	
	flag_wait("intro_setup_complete");
	
	//level fade in, watch for pop-in when changing....
	wait(2);
	
	//hvt plays arrival anim
	intro_hvt_arrive_hvt thread anim_single_solo(level.makarov_number_2, "intro_hvt_arrive_hvt");
	
	//guard plays arrival anim
	intro_hvt_arrive_guard anim_single_solo(level.bishop, "intro_hvt_arrive_guard");
	
	//both idle off HVT
	level.makarov_number_2 anim_loop (looping_guys, "intro_hvt_idle");
	
}



catch_up_osprey_crash()
{
	return;

}

intro_osprey()
{
	// Setup Osprey	
	thread set_flag_on_targetname_trigger("new_player_drop");
	
	level thread crash_timeout();
	
	osprey = Spawn( "script_model", ( 0, 0, 0 ) );
	osprey SetModel( "vehicle_v22_osprey" );
	osprey.angles = ( 0, 0, 0 );
	osprey.targetname = "intro_osprey";
	//osprey playloopsound( "intro_osprey_idle" );
	osprey_anim_node = GetEnt( "new_intro_crash_start_pos", "targetname" );
	osprey thread player_osprey_dist_check();
	
	//script_brushmodel 
	osprey.clip = getent("osprey_clip", "targetname");
	osprey.clip.angles = osprey.angles;
	osprey.clip.origin = osprey.origin;
	osprey.clip linkto(osprey, "tag_body", (0,-80,15), (0,0,0)  );
	//osprey.clip thread Print3d_on_me("!");
	
	// Setup Osprey passengers
	pilot_spawner = GetEnt( "intro_osprey_pilot", "targetname" );
	Assert( IsDefined( pilot_spawner ) );
	pilot = pilot_spawner SpawnDrone();
	pilot.script_noteworthy = "intro_osprey_pilot";
	pilot.animname = "generic";
	pilot UseAnimTree( level.scr_animtree[ "drone" ] );
	
	copilot_spawner = GetEnt( "intro_osprey_copilot", "targetname" );
	Assert( IsDefined( copilot_spawner ) );
	copilot = copilot_spawner SpawnDrone();
	copilot.script_noteworthy = "intro_osprey_copilot";
	copilot.animname = "generic";
	copilot UseAnimTree( level.scr_animtree[ "drone" ] );

	thread intro_osprey_fx();
	
	wait(.5);
	//osprey_anim_node thread anim_generic( pilot, "ANIM_paris_ac130_osprey_flyin_pilot" );
	pilot thread play_shortened_anim_scene(osprey_anim_node, "ANIM_paris_ac130_osprey_flyin_pilot", .70);
	
	//osprey_anim_node thread anim_generic( copilot, "ANIM_paris_ac130_osprey_flyin_copilot" );
	
	copilot thread play_shortened_anim_scene(osprey_anim_node, "ANIM_paris_ac130_osprey_flyin_copilot", .70);

	osprey.animname = "v22_osprey";
	osprey maps\_anim::setanimtree();
	
	flag_set ("start_flyin");
		
	osprey play_shortened_anim_scene(osprey_anim_node, "ANIM_paris_ac130_osprey_flyin", .70);
	
	objective_add( obj("OBJ_osprey"), "current",  &"PARIS_AC130_OBJ_INTRO_GET_TO_OSPREY" );
    Objective_Position(  obj( "OBJ_osprey" ), osprey.origin );
    objective_onentity( obj("OBJ_osprey"), osprey);
		
	flag_set( "FLAG_intro_osprey_1_crash_ready" );
	
	osprey playloopsound( "osprey_idle_high" );
	
	while ( !flag( "new_player_drop" ) )//FLAG_intro_player_knockout_started
	{
		osprey_anim_node thread anim_generic( pilot, "ANIM_paris_ac130_osprey_idle_pilot" );
		osprey_anim_node thread anim_generic( copilot, "ANIM_paris_ac130_osprey_idle_copilot" );
		osprey_anim_node maps\_anim::anim_single( [ osprey ], "ANIM_paris_ac130_osprey_idle" );
	}
	
	flag_set( "FLAG_intro_osprey_1_crash_start");
	
	osprey_anim_node thread anim_generic( pilot, "ANIM_paris_ac130_osprey_idle_pilot" );
	osprey_anim_node thread anim_generic( copilot, "ANIM_paris_ac130_osprey_idle_copilot" );
	osprey_anim_node thread maps\_anim::anim_single( [ osprey ], "ANIM_paris_ac130_osprey_idle" );
	
	wait(2);
	
	flag_set("start_car_crash");
	delaythread(.2, ::musicplaywrapper, "paris_ac130_osprey_crash_mx");
	//flag_set( "FLAG_intro_osprey_1_crash_start");
	
	osprey stoploopsound("osprey_idle_high");
	osprey_anim_node thread maps\_anim::anim_single( [ osprey ], "ANIM_paris_ac130_osprey_crash_v2" );
	osprey_anim_node thread anim_generic( pilot, "ANIM_paris_ac130_osprey_crash_pilot" );
	osprey_anim_node thread anim_generic( copilot, "ANIM_paris_ac130_osprey_crash_copilot" );

	wait(9);
	level.player thread vision_set_fog_changes( "paris_ac130_start_area_crash", 7);
	
	flag_wait( "FLAG_intro_slamout_start" );
	osprey Delete();
}


crash_timeout()
{
	//starts the intro osprey crash if player does not drop down
	level endon( "new_player_drop" );
	timeout_time = 11;
	wait( timeout_time );
	
	if( !flag( "new_player_drop" ) )
	{
		activate_trigger_with_targetname( "new_player_drop" );
	}	
	
}

player_osprey_dist_check()
{
	//self = osprey
	level endon ("FLAG_intro_slamout_start");
	osprey_clip = GetEnt( "osprey_clip", "targetname" ); 
	while(1)
	{
		if(level.player istouching( osprey_clip ) )
		{
			level.player dodamage(5000, level.player.origin);
			return;
		}
		wait(.05);
	}
}			

play_shortened_anim_scene(node, scene, shorten_amount)
{
	//self = actor	
	flag_wait("start_flyin");
	node thread anim_single( [self], scene );
	wait(.05);
	self anim_self_set_time( scene, shorten_amount);
	node waittill(scene);
	return;
	
}	

start_osprey_crash()
{
	flag_wait( "FLAG_intro_osprey_event" );	
	//thread osprey_crash();
	//thread osprey_crash_player_knockout();
	
	flag_wait( "FLAG_intro_slamout_start" );	
	level notify( "LISTEN_end_intro_enemy_1_spawn" );	
	wait 0.05;
	deletestructarray( "intro_enemy_spot", "targetname" );	
	flag_set( "allow_context_sensative_dialog" );
	
}

osprey_crash()
{
	//set in osprey_crash_player_knockout
	flag_wait("intro_vo_complete");
	
	flag_wait( "FLAG_intro_osprey_1_crash_start" );
	
	//flag_set( "FLAG_intro_osprey_1_minigun_stop" );		
	osprey = GetEnt( "intro_osprey", "targetname" );
	level thread rpg_at_osprey(osprey);
	Assert( IsDefined( osprey ) );
	level thread intro_missile_attack(osprey);
	/*
	osprey_anim_node = GetEnt( "new_intro_crash_start_pos", "targetname" );
	osprey.animname = "v22_osprey";
	osprey maps\_anim::setanimtree();
	osprey thread player_osprey_dist_check();
	//osprey_anim_node thread maps\_anim::anim_single( [ osprey ], "ANIM_paris_ac130_osprey_crash_v2" );
	*/
	

}

rpg_at_osprey(osprey)
{	
	rpg_start_building = (4531.8, 45880.1, 626.8);
	rpg_start_osprey = (4531.8, 45880.1, 318.05);
	osprey_end = osprey gettagorigin("j_blades_ri");
	building_end = (3319.4, 46460.1, 352);
	weapon = "hydra_ac130_rocket";
	magicbullet( weapon, rpg_start_osprey, osprey_end );
	wait(.9);
	magicbullet( weapon, rpg_start_building, building_end );
	wait(.8);
	playfx( getfx("intro_building_explosion"), building_end);
	playfx( getfx("debris_explosion_intro"), building_end);	
	
	wait(7);
	//level.player VisionSetNakedForPlayer( "paris_ac130_start_area_crash", 7);
}	

osprey_crash_player_knockout()
{
	level.player endon( "death" );
	flag_set( "FLAG_intro_player_knockout_started" );
		
	frost_downed_pos = getstruct_delete( "intro_frost_downed_pos", "targetname" );
	Assert( IsDefined( frost_downed_pos ) );

	player_top = Spawn( "script_model", frost_downed_pos.origin );
	player_top.angles = frost_downed_pos.angles;
	player_top SetModel( "viewhands_player_delta" );
	player_top hide();
	player_bottom = Spawn( "script_model", frost_downed_pos.origin );
	player_bottom.angles = frost_downed_pos.angles;
	player_bottom SetModel( "viewlegs_generic" );
	player_bottom hide();
	
	player_link = Spawn( "script_model", player_top.origin );
	player_link.angles = player_top GetTagAngles( "tag_origin" );
	player_link SetModel( "tag_origin" );
	player_link LinkTo( player_top, "tag_camera" );

	osprey_anim_node = getent("new_intro_crash_start_pos", "targetname");

	player_top.animname = "player_dragged";
	player_top maps\_anim::setanimtree();
	player_bottom.animname = "player_dragged";
	player_bottom maps\_anim::setanimtree();
	
	cars = GetEntArray( "intro_car", "targetname" );
	car_tags = [];
	foreach ( i, car in cars )
	{
		car_tags[ i ] = Spawn( "script_model", osprey_anim_node.origin );
		car_tags[ i ].angles = osprey_anim_node maps\_utility_chetan::get_key( "angles" );
		car_tags[ i ] SetModel( "tag_origin" );
		car_tags[ i ].animname = "car";
		car_tags[ i ] maps\_anim::setanimtree();
		osprey_anim_node maps\_anim::anim_first_frame_solo( car_tags[ i ], "paris_ac130_osprey_crash_car_" + car.script_index );
		car.origin = car_tags[ i ].origin;
		car.angles = car_tags[ i ] maps\_utility_chetan::get_key( "angles" );
		car LinkTo( car_tags[ i ], "tag_origin" );		
		car thread car_anim_start(osprey_anim_node, car_tags[ i ], "paris_ac130_osprey_crash_car_" + car.script_index);
	}
	
	pilot = GetEnt( "intro_osprey_pilot", "script_noteworthy" );
	copilot = GetEnt( "intro_osprey_copilot", "script_noteworthy" );
	gunner = GetEnt( "intro_osprey_gunner", "script_noteworthy" );
	
	flag_wait("start_car_crash");
	anim_time = GetAnimLength( player_top getanim( "ANIM_player_dragged_top" ) );
	//osprey_anim_node thread anim_generic( pilot, "ANIM_paris_ac130_osprey_crash_pilot" );
	//osprey_anim_node thread anim_generic( copilot, "ANIM_paris_ac130_osprey_crash_copilot" );
	//osprey_anim_node thread maps\_anim::anim_single( [ player_top ], "ANIM_player_dragged_top" );
	
	//anim_time = 35
	time = anim_time - 20;
	wait ( time );//12

	flag_set( "FLAG_intro_osprey_1_crash_finished" );
	
	//NEW INTRO SLAMOUT
	// Fade to AC130
	player_link = Spawn( "script_model", level.player.origin );
	player_link.angles = level.player getplayerangles();
	player_link SetModel( "tag_origin" );
	
	level.player FreezeControls( true );
	level.player SetStance( "stand" );
	level.player AllowCrouch( false );
	level.player PlayerLinkToAbsolute( player_link, "tag_origin" );
	
	level.player EnableInvulnerability();
	level.player HideViewModel();
	level.player TakeAllWeapons();
	level.player.ignoreme = true;
	
	//new slamout
	//finish_ent = getent ("slamout_spot", "targetname" );
//	final_orign = (-4383.36, 42238.9, 12000);
//	final_angles = (53.4379, 27.3719, 0.620108);

	final_orign = ( level.player.origin[0], level.player.origin[1], 12000 );
	final_angles = ( 90, 27.3719, level.player.angles[2] );

	//player_link unlink();
	player_link moveZ( 12000, 1.8, 1.8 );		// old times - 1.8, 1.4, .4
	player_link thread play_loop_sound_on_entity( "slamout_static" );
	thread slamout_static(.2);
	player_link rotateto(final_angles, 0.3, 0.3);
	level.player VisionSetNakedForPlayer( "paris_ac130_enhanced", 2);
	player_link thread play_sound_on_entity( "player_slamzoom_out" );
	wait( 1.1 );
	thread fade_out_in( "overlay_static", 0.3, 1 );
	wait( 0.7 );
	flag_set( "FLAG_intro_slamout_start" );
	level.player FreezeControls( false );
	player_link thread stop_loop_sound_on_entity( "slamout_static" );
	
	// Clean up
	player_top Delete();
	player_bottom Delete();
	player_link Delete();

	pilot_spawner 	= GetEnt( "intro_osprey_pilot", "targetname" );
	copilot_spawner = GetEnt( "intro_osprey_copilot", "targetname" );
	gunner_spawner 	= GetEnt( "intro_osprey_gunner", "targetname" );
	
	pilot_spawner Delete();
	pilot Delete();
	copilot_spawner Delete();
	copilot Delete();
	gunner_spawner Delete();
			
	foreach ( car in cars )
		car Delete();
	foreach ( _tag in car_tags )
		_tag Delete();
	
}

car_anim_start(node, car_tag, scene)
{
	flag_wait("start_car_crash");
	node thread anim_single([car_tag], scene);
	//self thread Print3d_on_me( "C A R !!!!");
}	

notetrack_osprey_rpg_impact(osprey)
{	
	//PlayFXOnTag(level._effect[ "FX_osprey_jet_engine_fire" ], osprey, "J_Blades_RI" );	
	osprey thread play_sound_on_entity ("scn_ac130_opening_osprey_bombed");
	flag_set ("intro_osprey_hit");
	earthquake(.5, .4, level.player.origin, 200);
}	

notetrack_osprey_ground_impact(osprey)
{
	
	exploder("osprey_crash");
	
	osprey thread play_sound_on_entity ("osprey_crash_hitground");
	
	level.player playrumblelooponentity ("damage_light");
	level.player delaycall (6, ::stoprumble, "damage_light" );
	
	earthquake(.2, 6, level.player.origin, 1000);
	wait 3;
	earthquake(.3, 6, level.player.origin, 1000);
	wait 3;
	
	level.player playrumblelooponentity ("damage_heavy");
	level.player delaycall (3, ::stoprumble, "damage_heavy" );
	
	earthquake(.4, 3, level.player.origin, 200);
	
}

notetrack_osprey_engine_smoke(osprey)
{
	level endon( "FLAG_intro_slamout_start" );	
	while( 1 )
	{
		engineFlame = osprey getTagOrigin( "J_Blades_RI" );
	
		playFX( level._effect[ "FX_osprey_engine_smoke" ], engineFlame );
	
		wait(.075);
	}
}	

notetrack_osprey_engine_fire(osprey)
{
	level endon( "FLAG_intro_slamout_start" );	
	while( 1 )
	{
		engineFlame = osprey getTagOrigin( "J_Blades_RI" );
		playFX(level._effect[ "FX_osprey_engine_fire" ], engineFlame );
	
		wait(.1);
	}
}

intro_enemies()
{	
	intro_back_guys_spawners = getentarray("intro_back_guys", "targetname");  
	array_thread(intro_back_guys_spawners, ::add_spawn_function, ::intro_enemy_logic);
	
	flag_wait ("intro_osprey_hit");
	
	wait(4);
	intro_back_guys = array_spawn(intro_back_guys_spawners, .2);
	//iprintlnbold("Contanct!!!!! 12' 0' clock!!");
	wait(2);
	//iprintlnbold("Icoming! Targets dead ahead!");
	flag_wait("FLAG_intro_slamout_start");
	wait(4);
	intro_back_guys = array_removeundefined(intro_back_guys);
	array_delete(intro_back_guys);
	
}	

intro_enemy_logic(accuracy)
{
	self endon ("death");
	self.goalradius = 32;
	if(randomint(100) > 30)
	{
		self.grenadeammo = 0;
	}	
	
	if(IsDefined(accuracy))
	{
		self.baseaccuracy = accuracy;
	}	
	
}	

setup_slamzoom()
{
	init_slamzoom_flags();
	maps\_carry_ai::initCarry();

	bridge_radio();
	
	level.air_support_weapon = "ac130_40mm_air_support_strobe_iw";
	level.squad = [];
	level.delta = array_remove ( level.delta, level.frost );
	//level thread bridge_spawnfuncs();
	level thread bridge_anims();

	level thread humvee_takedown();
	level thread enemy_management();
	level thread friendly_management();
	level thread setup_javelin_objectives();
	level thread bridge_dialogue();
	level thread track_player();
	level thread epic_jets_timing();
	level thread crash_chopper_assets();
	level thread enemy_retreat_pos_set();
	level thread player_hummer_setup();
	
	if(level.start_point == "start_bridge")
	{		
		level thread thermal_ents();
	}	
	
	level.chase_main_vehicle thread force_humvee_unload();
	level.chase_second_vehicle thread force_humvee_unload();
	
	level thread effiel_anims();
	
	good_guys = getAIarray("allies");
	array_thread (good_guys, ::friendly_accuracy_logic);

	spot = get_world_relative_offset( level.chase_second_vehicle.origin, level.chase_second_vehicle.angles,  ( 8, 36, 66 ) ) ; //-63x
	ent = spawn ( "script_origin", spot );
	ent.angles = level.chase_second_vehicle.angles +(0, 328, 0);
	ent linkto (level.chase_second_vehicle);
	level.pip.clipdistance = 10000;

	sonic_boom_nodes = getvehiclenodearray("sonic_boom_bridge", "script_noteworthy");
	array_thread( sonic_boom_nodes, vehicle_scripts\_f15::plane_sound_node);
	
	ambient_bridge_jets = getentarray("ambient_bridge_jets", "targetname");
	level thread bridge_jets_overhead(ambient_bridge_jets);
	
	ai_tanks = [];
	bridge_tanks = getentarray ("bridge_tanks", "script_noteworthy");
	foreach(bridge_tank in bridge_tanks)
	{
		tank_ai =  bridge_tank spawn_vehicle_and_gopath();
		wait(.10);
		tank_ai thermaldrawenable();
		ai_tanks = add_to_array(ai_tanks, tank_ai);
		//tank_ai thread bridge_tank_shoot_until_slamzoom();
	}	
	
	flag_set ("bridge_tanks_spawned");
	
	closest_tank_to_delta = getClosest( level.sandman.origin, ai_tanks );
	closest_tank_to_delta thread bridge_tank_shoot_until_slamzoom();
	
	//turn off trigs on bridge til player slamzooms
	bridge_trigs = getentarray("bridge_trigs", "script_noteworthy");
	//array_thread (bridge_trigs, ::trig_debug);
	foreach(trig in bridge_trigs)
	{
		trig trigger_off();
	}
	
	//Tank on hilltop dies, tank behind it moves up on the same spot
	level thread tank3_moveup_on_death();
	
	level thread humvee_pip_timing(ent);
	level thread tower_destructible_vehicles_fire();
	flag_wait ("slamzoom_complete");	
	
	level.sandman hide(); //So player doesnt see him warp to he anim running around the hummer
	
	level thread bridge_fx();
		
	foreach(trig in bridge_trigs)
	{
		trig trigger_on();
	}
	
	level thread tank_danger_zone();
	level thread tank_death_quote();	
	level thread bridge_cleanup_ents();
	
	base_trig = getent( "squad_pos5", "targetname");
	color_value = base_trig.script_color_allies;
	
	new_alamo_color_trig = spawn("trigger_radius", (-20654, 10816, -12), 0, 771, 128 );
	new_alamo_color_trig.targetname = "new_alamo_color_trig";
	new_alamo_color_trig.script_color_allies = color_value;
	new_alamo_color_trig thread maps\_colors::trigger_issues_orders( color_value, "allies" );
	
	//base_trig delete();
}
	
thermal_ents()
{
	thermal_ents = [];
	thermal_ents[thermal_ents.size] =  "prop_ac_prs_enm_barge_a_1";
	thermal_ents[thermal_ents.size] =  "prop_ac_prs_enm_barge_a_2";
	thermal_ents[thermal_ents.size] =  "prop_ac_prs_enm_missile_boat_a";
	thermal_ents[thermal_ents.size] =  "prop_ac_prs_enm_maz_a";
	thermal_ents[thermal_ents.size] =  "prop_ac_prs_enm_mi26_halo_a";
	thermal_ents[thermal_ents.size] =  "prop_ac_prs_enm_s300v_a";
	thermal_ents[thermal_ents.size] =  "prop_ac_prs_enm_mstas_a";
	
	level thread thermal_on_ents( thermal_ents );
	
}		
	
thermal_on_ents( d_type_array )
{
	//gets all destructibles, turns thermal on the ones in the array you pass through
	ents = getentarray ("destructible_vehicle", "targetname");
	
	foreach( ent in ents)
	{
		foreach( item in d_type_array)
		{
			if(isdefined(ent.destructible_type) )
			{
				if( ent.destructible_type == item )
				{
					//ent thermaldrawenable();
					ent thread thermal_on_til_destroyed();
					break;
				}
			}
		}	
	}				
}
		
thermal_on_til_destroyed()
{
	
	level endon ("slamzoom_complete");
	self thermaldrawenable();
	self waittill_any ( "destroyed", "exploded" );
	if(isDefined( self ) )
	{	
		self thermaldrawdisable();	
	}	
}	
	
bridge_fx()
{               
	level thread spawn_looping_fx_delete_on_flag( ( -8306.91, 6486.67, 595.178 ), ( 270, 0, 0 ), "FX_ambient_explosion_paris", 12, "player_on_board_littlebird");
	level thread spawn_looping_fx_delete_on_flag( ( -11026.2, -66.8614, 599.15 ), ( 270, 0, 0 ), "FX_ambient_explosion_paris", 10, "player_on_board_littlebird");
	level thread spawn_looping_fx_delete_on_flag( ( -14397.4, -3458.67, 795.26 ), ( 270, 0, 0 ), "FX_ambient_explosion_paris", 8, "player_on_board_littlebird");	
}	
	
	
humvee_pip_timing(pip_ent)
{
	wait(12);
	level maps\paris_ac130_pip::ac130_pip_init( pip_ent, undefined, undefined, 70 );
	wait(1);
	//to add: "scn_ac130_pip_crash"
	spot = get_world_relative_offset( level.chase_second_vehicle.origin, level.chase_second_vehicle.angles,  ( 277, 0, 62 ) ) ; //-63x
	hummer_fx_ent = spawn ( "script_model", spot );
	hummer_fx_ent.angles = level.chase_second_vehicle.angles;
	hummer_fx_ent linkto (level.chase_second_vehicle);
	hummer_fx_ent setmodel( "tag_origin" );
	wait(1.5);
	PlayFXOnTag(level._effect[ "FX_bm21_hurt_explosion" ], hummer_fx_ent, "tag_origin" );
	level.player thread play_sound_on_entity( "exp_ac130_40mm_dist" );
	level.player thread play_sound_on_entity( "scn_ac130_pip_crash" );
	wait(1.5);
	playFXOnTag(level._effect[ "FX_bm21_hurt_explosion" ], hummer_fx_ent, "tag_origin" );
	level.player thread play_sound_on_entity( "exp_ac130_40mm_dist" );
}		
	
friendly_accuracy_logic()
{
	self.baseaccuracy = .3;		
	flag_wait("squad_at_final_pos");
	if(isDefined(self))
	{
		self.baseaccuracy = .7;
	}	

}
	
tank3_moveup_on_death()
{
	bridge_tank2 = get_vehicle("bridge_tank2", "targetname");
	bridge_tank2 waittill ("death");
	flag_set ("bridge_tank2_dead");

}	

trig_debug()
{
	self waittill ("trigger", who);
	//iprintlnbold (self.targetname +" triggered");
}

	
init_slamzoom_flags()
{
	flag_init("bridge_tanks_spawned");
	flag_init ("slamzoom_complete");
	flag_init ("player_shot_tank");
	flag_init ("humvee_at_bridge");
	flag_init ("humvee_crashed");
	flag_init ("squad_at_bridge");
	flag_init ("c130_start_attacking");
	flag_init("jav_obj_started");
	flag_init ("2_tanks_left");
	flag_init ("1_tank_left");
	flag_init ("all_tanks_destroyed");
	flag_init ("player_has_javelin");
	flag_init ("player_past_bus");
	flag_init ("player_over_hump");
	flag_init("player_at_second_bus");
	flag_init("crash_chopper_unloading");
	flag_init("chopper_crashed_on_bridge");
	flag_init("squad_to_bridge_collapse");
	flag_init("bridge_collapse_start");
	flag_init("bridge_group1_clear");
	flag_init("crash_jet_complete");
	flag_init("squad_at_final_pos");
	flag_init("tower_final_start");
	flag_init("bombing_run");
	flag_init("squad_at_skipto_pos");
	flag_init( "pickup_choppers_in" );
	flag_init("alamo_clear");
	flag_init("little_bird_full");
	flag_init("c130_clears_baddies");
	flag_init("bridge_bombed");
	flag_init("both_choppers_down");
	flag_init("final_vehicles_in");
	flag_init("bomb_run_vo_finished");
	flag_init("spawn_pickup_choppers");
	flag_init("attack_choppers_spawned");
	//flag_init("player_on_board_littlebird");

}

init_hvt_flags()
{
	flag_init("pinned_anim_complete");
	flag_init("squad_to_courtyard");
	flag_init("player_at_bedroom");
	//flag_init("player_in_first_hallway");
	flag_init("courtyard_dialogue_complete");
	flag_init("player_went_to_bedroom");
	flag_init("player_went_upstairs");
	flag_init("player_shot_yellow_building");
	flag_init("hvt_slamzoom_complete");
	flag_init("hvt_tank_destroyed");
	flag_init("player_has_sniper_rifle");
	flag_init("end_sniper_kill_monitor");
	flag_init("turret_guy_dead");
	flag_init("end_turret_script_control");
	flag_init("hvt_courtyard_clear");
	flag_init("player_on_turret");
	flag_init("player_has_orders");
	flag_init("c130_shooting_tank");
	flag_init("hvt_air_strobe_start");
	flag_init("player_threw_strobe");
	flag_init( "hvt_squad_to_fountain" );
	flag_init( "hvt_monument_clear" );
	
}	

bridge_radio()
{
	//stop stop stop!
	level.scr_radio[ "ac130_snd_stopstop" ]	= "ac130_snd_stopstopstop";
	
	//convoy ist stalled, armor on the bridge, need you to hit now!
	level.scr_radio[ "ac130_snd_convoystalled" ]	= "ac130_snd_armoronbridge";
	
	//Hit that armor
	level.scr_radio[ "ac130_fco_hitarmor" ]	= "ac130_fco_hitarmor";
	
	//Go ahead and engage those tanks
	level.scr_radio[ "ac130_fco_engagetanks" ]	= "ac130_fco_engagetanks";
	
	//That armor is still hitting us, need you to deal with it Warhammer
	level.scr_radio[ "ac130_fco_hittanksbig" ]	= "ac130_fco_hittanksbig";
	
	//Grab the Javelin and take out those tanks
	level.scr_radio[ "ac130_snd_getjavelin" ]	= "ac130_snd_getjavelin";
	
	
	// "Use the javelin and take out those tanks!"
	level.scr_radio[ "ac130_snd_usejavelin" ] = "ac130_snd_usejavelin";
	
	// "Hit those tanks, NOW!"
	level.scr_radio[ "ac130_snd_hittanksnow" ] = "ac130_snd_hittanksnow";
	
	
	
	//One down, now hit the other one!
	level.scr_radio[ "ac130_snd_getotherone" ]	= "ac130_snd_getotherone";
	
	// "Take out that other tank!"
	level.scr_radio[ "ac130_snd_takeoutother" ] = "ac130_snd_takeoutother";
	
	// "Hit that last tank, Frost!"
	level.scr_radio[ "ac130_snd_hitlasttank" ] = "ac130_snd_hitlasttank";	
	
	// "Finish off those tanks!"
	level.scr_radio[ "ac130_snd_finishtanks" ] = "ac130_snd_finishtanks";
	
	// "Tanks are down!"
	level.scr_radio[ "ac130_trk_tanksaredown" ] = "ac130_trk_tanksaredown";
	
	// "Metal Zero One, mark targets with smoke and we'll give you some breathing room."
	level.scr_radio[ "ac130_plt_giveyouroom" ] = "ac130_plt_giveyouroom";
	
	//Get Volk up and Move!
	//level.scr_radio[ "ac130_snd_getvolkup" ]	= "ac130_snd_getvolkup";
	
	//Dont let him out of your sight!
	//level.scr_radio[ "ac130_snd_outofyoursight" ]	= "ac130_snd_outofyoursight";
	
	//hitman
	//I got him!
	level.scr_radio[ "ac130_hit_igothim" ]	= "ac130_hit_igothim";
	
	//hey! HEY! Get your ass up Volk!
	level.scr_radio[ "ac130_hit_getupvolk" ]	= "ac130_hit_getupvolk";
	
	//c130	
	// "Got a rectangular building with flags on the roof.  Cleared to level that."
	level.scr_radio[ "ac130_fco_engagebuilding" ] = "ac130_fco_engagebuilding";
	
	// "Enemy personnel on the balcony of the building right there, you see that?"
	level.scr_radio[ "ac130_fco_balcony" ] = "ac130_fco_balcony";	
	
	// "Tank!  Find cover!"
	level.scr_radio[ "ac130_snd_findcover" ] = "ac130_snd_findcover";
		
	// "Talk to me, Hitman.  Where are we at?"
	level.scr_radio[ "ac130_snd_talktome" ] = "ac130_snd_talktome";
	
	// "Any time now, Hitman."
	level.scr_radio[ "ac130_snd_anytimenow" ] = "ac130_snd_anytimenow";
	
	// "We're taking heavy fire!  Get that MG down, now!"
	level.scr_radio[ "ac130_snd_getmgdown" ] = "ac130_snd_getmgdown";
	
	// "Get up there and take oyut that MG!
	level.scr_radio[ "ac130_snd_takeoutmg" ] = "ac130_snd_takeoutmg";
	
		// "Take out that MG so we can move up!
	level.scr_radio[ "ac130_snd_wecanmoveup" ] = "ac130_snd_wecanmoveup";
	
	// "Alright, let's go!"
	level.scr_radio[ "ac130_snd_alrightletsgo" ] = "ac130_snd_alrightletsgo";
	
	// "Grinch!  Keep Volk behind cover!"
	level.scr_radio[ "ac130_snd_volkcovered" ] = "ac130_snd_volkcovered";
	
	// "Affirmative!"
	level.scr_radio[ "ac130_rno_affirmative" ] = "ac130_rno_affirmative";
	
	// "Warhammer, we've got contact from the building across the courtyard.  "
	level.scr_radio[ "ac130_snd_acrosscourtyard" ] = "ac130_snd_acrosscourtyard";
	
	//thats a negative kilo 1 targets are too close. Youre going to have to find another way around. 
	//level.scr_radio[ "ac130_plt_anotherway" ] = "ac130_plt_anotherway";	
	
	//negative metal zero one were under enemy fire. Give us five mikes to circle back around
	level.scr_radio["ac130_plt_anotherway"]	= "ac130_plt_rearm";
	
	// "Solid copy. We can cut through this courtyard for now."
	//level.scr_radio[ "ac130_snd_cutthrough" ] = "ac130_snd_cutthrough";		
	
	//frost, hitman, sweep the 2nd floor. Gator on me. 
	//level.scr_radio[ "ac130_snd_sweep2nd" ] ="ac130_snd_sweep2nd";
	
	// "Alright.  We'll draw fire.  Hitman and Frost - flank that MG so we can keep moving."
	level.scr_radio[ "ac130_snd_drawfire" ] = "ac130_snd_drawfire";
	
	// "Get ready…Go! Go! Go!"
	level.scr_radio[ "ac130_snd_readygogo" ] = "ac130_snd_readygogo";
	
	// "I think we got their attention."
	level.scr_radio[ "ac130_rno_attention" ] = "ac130_rno_attention";
	
	// "No shot.  Keep going."
	level.scr_radio[ "ac130_hit_noshot" ] = "ac130_hit_noshot";
	
	// "Alright, tag him."
	level.scr_radio[ "ac130_hit_taghim" ] = "ac130_hit_taghim";	
	
	// "We're gonna strongpoint that monument just ahead!  Grinch - bring Volk up when we're secure!"
	level.scr_radio[ "ac130_snd_strongpointmonument" ] = "ac130_snd_strongpointmonument";
	
	// "I'll be right behind you!"
	level.scr_radio[ "ac130_rno_behindyou" ] = "ac130_rno_behindyou";
	
	// "Grinch, you're up!"
	level.scr_radio[ "ac130_snd_grinchyoureup" ] = "ac130_snd_grinchyoureup";
	
	// "Way ahead of ya, bossman."
	level.scr_radio[ "ac130_rno_bossman" ] = "ac130_rno_bossman";
	
	// "I hope the kill you all!"
	level.scr_radio[ "ac130_vlk_killyouall" ] = "ac130_vlk_killyouall";
	
	// "You're going to get me killed!"
	level.scr_radio[ "ac130_vlk_getmekilled" ] = "ac130_vlk_getmekilled";
	
	// "If we have to haul this asshole through the rest of the city, we're gonna go nowhere - fast!"
	level.scr_radio[ "ac130_rno_nowhere" ] = "ac130_rno_nowhere";

	// "Solid copy, Kilo 1-1.  Engaging."
	level.scr_radio[ "ac130_plt_engaging" ] = "ac130_plt_engaging";
	
	// "The convoy will be here any second!"
	level.scr_radio[ "ac130_trk_convoy" ] = "ac130_trk_convoy";

	// "You're all clear, Kilo 1-1."
	level.scr_radio[ "ac130_plt_allclear" ] = "ac130_plt_allclear";
	
	//tanks 3 0'clock!
	level.scr_radio[ "ac130_snd_tankat3" ] = "ac130_snd_tankat3";
	
	// "Tank!"
	level.scr_radio[ "ac130_trk_tank" ] = "ac130_trk_tank";
	
	// "Talk to me, Warhammer, where are we at?!"
	level.scr_radio[ "ac130_snd_talktomewarhammer" ] = "ac130_snd_talktomewarhammer";
	
	// "Zero One, we're back on station and available for ten mikes."
	level.scr_radio[ "ac130_plt_tenmikes" ] = "ac130_plt_tenmikes";
	
	// "We have enemy armor right in front of us!  We're marking with smoke!"
	level.scr_radio[ "ac130_snd_rightinfront" ] = "ac130_snd_rightinfront";
	
	// "Get smoke on that tank!"
	level.scr_radio[ "ac130_snd_getsmokeontank" ] = "ac130_snd_getsmokeontank";
		
	// "Put smoke on the tank!"
	level.scr_radio[ "ac130_snd_putsmokeontank" ] = "ac130_snd_putsmokeontank";
	
	// "Frost!  Get a mark on that tank!"
	level.scr_radio[ "ac130_snd_markonthattank" ] = "ac130_snd_markonthattank";
	
	// "You're supposed to throw it at the tank, Frost!"
	level.scr_radio[ "ac130_trk_throwitattank" ] = "ac130_trk_throwitattank";
	
	//copy that delta 1-2. Waiting on your mark.
	level.scr_radio[ "ac130_plt_waitingonmark" ] = "ac130_plt_waitingonmark";
	
	// "Ok.  Got your mark.  Danger close."
	level.scr_radio[ "ac130_plt_gotyourmark" ] = "ac130_plt_gotyourmark";
	
	//Metal Zero One Engaging the target. Danger close
	level.scr_radio[ "ac130_plt_engagingtarget"]  = "ac130_plt_engagingtarget";
	
	//roger that, good to have you back warhammer
	level.scr_radio[ "ac130_snd_haveyouback" ] = "ac130_snd_haveyouback";
	
	// "Kilo one this is uniform 6 we are inbound to your location."
	level.scr_radio[ "ac130_hmv_enroute" ] = "ac130_hmv_enroute";	
	
	//solid copy, we're almost at the intersection. Three minutes out. 
	level.scr_radio[ "ac130_snd_intersection"] = "ac130_snd_intersection";
	
	// "Kilo 1-1, shot out.  Danger close."
	level.scr_radio[ "ac130_plt_shotout" ] = "ac130_plt_shotout";
	
	// "Alright, looks like we've got a lot of enemy personnel near the base of the tower."
	level.scr_radio[ "ac130_fco_baseoftower" ] = "ac130_fco_baseoftower";
	
	// "This prick better be worth it."
	level.scr_radio[ "ac130_gtr_worthit" ] = "ac130_gtr_worthit";
	
	// "The tower's taking a beating. "
	level.scr_radio[ "ac130_hit_takingabeating" ] = "ac130_hit_takingabeating";
	
	// "Kilo One, this is Uniform Six.  We're en route to your location."
	level.scr_radio[ "ac130_hmv_enroute" ] = "ac130_hmv_enroute";
	
	// "Get some fire on that turret."
	level.scr_radio[ "ac130_snd_fireonturret" ] = "ac130_snd_fireonturret";
	
	//"warhammer the tanks blocking our ext, get some fire on that thing."
	level.scr_radio[ "ac130_snd_tankblocking" ] = "ac130_snd_tankblocking";
	
	// "Let's go, let's go!"
	level.scr_radio[ "ac130_snd_letsgoletsgo2" ] = "ac130_snd_letsgoletsgo2";
	
	// "Move!  Move!  C'mon!"
	level.scr_radio[ "ac130_snd_movemovecmon" ] = "ac130_snd_movemovecmon";
	
	// "On me!"
	level.scr_radio[ "ac130_snd_onme2" ] = "ac130_snd_onme2";
		
	// "We're getting pinned down by RPG fire!  Give us a hand, Warhammer!"
	level.scr_radio[ "ac130_snd_rpgfire2" ] = "ac130_snd_rpgfire2";
	
	// "We're taking more fire from the embassy!  Give us a hand!"
	level.scr_radio[ "ac130_snd_firefromembassy" ] = "ac130_snd_firefromembassy";
	
	//Metal zero 1, we can give you one pass and one pass only
	level.scr_radio[ "ac130_plt_onepassonly" ] = "ac130_plt_onepassonly";
	
	// "Go ahead and hit the building."
	level.scr_radio[ "ac130_fco_okhitem" ] = "ac130_fco_okhitem";
	
	// "Put a one-oh-five round on that building."
	level.scr_radio[ "ac130_fco_hitbuilding" ] = "ac130_fco_hitbuilding";

	//Frost, get on board!
	level.scr_radio[ "ac130_snd_getonboard" ] = "ac130_snd_getonboard";
	
	//Get ont he bird frost lets go!
	level.scr_radio[ "ac130_snd_onthebird" ] = "ac130_snd_onthebird";
		
	// "One of our vehicles is down."
	level.scr_radio[ "ac130_tvo_vehicledown" ] = "ac130_tvo_vehicledown";
	
	// "Yep, I see em."
	level.scr_radio[ "ac130_fco_yepiseeem" ] = "ac130_fco_yepiseeem";
	
	// "One of the humvees has just been hit."
	level.scr_radio[ "ac130_fco_humveehit" ] = "ac130_fco_humveehit";
	
	// "Zero One, any ordinance on that bridge is going to prevent you from getting to the LZ."
	level.scr_radio[ "ac130_plt_ordinance" ] = "ac130_plt_ordinance";
	
	// "Too late.  This is the LZ now."
	level.scr_radio[ "ac130_snd_thisisthelznow" ] = "ac130_snd_thisisthelznow";
	
	// "Crew, you are cleared to engage the armor on the bridge."
	level.scr_radio[ "ac130_plt_engagearmor" ] = "ac130_plt_engagearmor";
	
	//NEW Bridge defend
	
	// "Comin' through!"
	level.scr_radio[ "ac130_rno_cominthrough" ] = "ac130_rno_cominthrough";
	
	// "Movin' up!  Cover me!"
	level.scr_radio[ "ac130_rno_movinup" ] = "ac130_rno_movinup";
	
	// "This son of a bitch better be worth it!"
	level.scr_radio[ "ac130_rno_worthit" ] = "ac130_rno_worthit";
	
	// "Just keep Volk covered!"
	level.scr_radio[ "ac130_snd_keepvolk" ] = "ac130_snd_keepvolk";

	// "Gotcha covered!"
	level.scr_radio[ "ac130_trk_gotchacovered" ] = "ac130_trk_gotchacovered";
	
	// "Set security!"
	level.scr_radio[ "ac130_snd_setsecurity" ] = "ac130_snd_setsecurity";
	
	// "Overlord, this is Metal Zero One!  Black LZ at grid two, seven, seven, five."
	level.scr_radio[ "ac130_snd_blacklz" ] = "ac130_snd_blacklz";
	
	//warhammer we have enemy air support comin in, need you to take care of em!
	level.scr_radio[ "ac130_snd_takecareofem"  ] = "ac130_snd_takecareofem";
	
	// "Strongpoint this position!  We got three minutes until CAS gets here!"
	level.scr_radio[ "ac130_snd_strongpoint" ] = "ac130_snd_strongpoint";
	
	// "Red smoke on the LZ!  Need you to service targets North of that location!"
	level.scr_radio[ "ac130_snd_strobeson" ] = "ac130_snd_strobeson";
	
	// "Mark the target with smoke Frost!"
	level.scr_radio[ "ac130_snd_markthetarget" ] = "ac130_snd_markthetarget";
	
	// "Zero One, we're bingo on fuel.  CAS support will be here in thirty seconds.  Just hold on."
	level.scr_radio[ "ac130_plt_bingofuel" ] = "ac130_plt_bingofuel";
	
	// "Rog'!  Thirty seconds, gentlemen!"
	level.scr_radio[ "ac130_snd_gentlemen" ] = "ac130_snd_gentlemen";
	
	// "I don't think we'll last that long!" //Grinch
	level.scr_radio[ "ac130_rno_lastthatlong" ] = "ac130_rno_lastthatlong";
	
	// "They got a ton of armor rollin in!  We're gonna get pinned down!"
	level.scr_radio[ "ac130_trk_tonofarmor" ] = "ac130_trk_tonofarmor";
	
	// "Last mag!!"
	level.scr_radio[ "ac130_rno_lastmag" ] = "ac130_rno_lastmag";
	
	// "Zero One, Odin Six.  Can't tell who's who down there.  Need you to mark the targets."
	level.scr_radio[ "ac130_odn_whoswho" ] = "ac130_odn_whoswho";
	
	// "Negative!  Nothing left to use!"
	level.scr_radio[ "ac130_snd_nothingleft" ] = "ac130_snd_nothingleft";
	
	// "We're dead center on the bridge!  Hit anything North of us with everything you got!"
	level.scr_radio[ "ac130_snd_deadcenter" ] = "ac130_snd_deadcenter";
		
	// "Overlord, bombing run is going to level EVERTYTHING in that area, requesting clearnece."
	level.scr_radio[ "ac130_odn_leveleverything" ] = "ac130_odn_leveleverything";
	
	// "Odin do whatever you have to to get those men back home"
	level.scr_radio[ "ac130_hqr_dowhatever" ] = "ac130_hqr_dowhatever";

	
	// "I don't want to die here!"
	level.scr_radio[ "ac130_vlk_dontwanttodie" ] = "ac130_vlk_dontwanttodie";
	
	// "AAHHHHH!!!  "
	level.scr_radio[ "ac130_vlk_scream" ] = "ac130_vlk_scream";
	
	// "I'll tell you everything!  Just don't let me die!"
	level.scr_radio[ "ac130_vlk_tellyoueverything" ] = "ac130_vlk_tellyoueverything";
	
	// "Maybe it is a good day to die."
	level.scr_radio[ "ac130_rno_dietoday" ] = "ac130_rno_dietoday";
	
	// "Metal Zero One, this is Odin Six.  Bombs away."
	level.scr_radio[ "ac130_o61_bombsaway" ] = "ac130_o61_bombsaway";
	
	// "Metal Zero One, this is Odin Six-two.  Bombs away."
	level.scr_radio[ "ac130_o62_bombsaway" ] = "ac130_o62_bombsaway";
		
	// "INCOMING!!!!!" Truck
	level.scr_radio[ "ac130_hit_incoming" ] = "ac130_hit_incoming";
			
	//metal zero one this is vandal 3..we heard you guys needed a lift backto base
	level.scr_radio[ "ac130_vnd_backtobase" ] = "ac130_vnd_backtobase";
	
	// "Sounds good, Vandal.  Anywhere but here."
	level.scr_radio[ "ac130_snd_vandalready" ] = "ac130_snd_vandalready";
	
	// "Get Volk!  We're getting' the hell outta here."
	level.scr_radio[ "ac130_snd_gettingouttahere" ] = "ac130_snd_gettingouttahere";
	
	// "Ten feet…one foot…Vandal Three on the deck."
	level.scr_radio[ "ac130_vnd_ondeck" ] = "ac130_vnd_ondeck";
	
	// "What about Volk? "
	level.scr_radio[ "ac130_trk_whataboutvolk" ] = "ac130_trk_whataboutvolk";
	
	//"I'll take him.  Make sure he gets on the next bird."
	level.scr_radio[ "ac130_rno_nextbird" ] = "ac130_rno_nextbird";
	
	// "Alright, do it!"
	level.scr_radio[ "ac130_snd_alrightdoit" ] = "ac130_snd_alrightdoit";
	
	// "…and Grinch…we need him alive."
	level.scr_radio[ "ac130_snd_needhimalive" ] = "ac130_snd_needhimalive";
	
	//"Have a nice ride, gentlemen."
	level.scr_radio[ "ac130_rno_niceride" ] = "ac130_rno_niceride";
	
	//==choper ride flavor burst==//
	//ground forces at l13 eliminated
	level.scr_radio[ "ac130_apl_l3elim" ] = "ac130_apl_l3elim";
	//Vulture 2-2 whats your status?
	level.scr_radio[ "ac130_hqr_vulturestatus" ] = "ac130_hqr_vulturestatus";
	//Roger - move up to phase line alpha
	level.scr_radio[ "ac130_hqr_phaseline" ] = "ac130_hqr_phaseline";
	//"move to phaseline alpha marker."
	level.scr_radio[ "ac130_hqr_phaseline" ] = "ac130_hqr_phaseline";
	//"Circle around to the north."
	level.scr_radio[ "ac130_apl_circletonorth" ] = "ac130_apl_circletonorth";
	level.scr_radio[ "ac130_bl1_turningwest" ] = "ac130_bl1_turningwest";
	level.scr_radio[ "ac130_gt6_longknife" ] = "ac130_gt6_longknife";
	level.scr_radio[ "ac130_gt6_keepscreening" ] = "ac130_gt6_keepscreening";
	
	//Blackhawk gunners call targets
	level.scr_radio[ "ac130_apa_insight" ] = "ac130_apa_insight";
	level.scr_radio[ "ac130_apl_takeoutguys" ] = "ac130_apl_takeoutguys";
	level.scr_radio[ "ac130_apl_getaway" ] = "ac130_apl_getaway";	
	level.scr_radio[ "ac130_agn_solidbox" ] = "ac130_agn_solidbox";
	
	//Blackhawk gunners after killing target
	level.scr_radio[ "ac130_apa_goodshot" ] = "ac130_apa_goodshot";
	level.scr_radio[ "ac130_apl_suppressed" ] = "ac130_apl_suppressed";
	level.scr_radio[ "ac130_apa_youreclear" ] = "ac130_apa_youreclear";
	
	//The towers not gonna take much more of that
	level.scr_radio[ "ac130_gtr_tower" ] = "ac130_gtr_tower";
	
	//The towers taking a beating
	level.scr_radio[ "ac130_hit_takingabeating" ] = "ac130_hit_takingabeating";
	
	//AIR SUPPORT STROBE 
	
	//Stand by zero one, makin adjustments..
	level.scr_radio[ "ac130_plt_adjustments" ] = "ac130_plt_adjustments";
	
	//adjustments complete. Ready for mark
	level.scr_radio[ "ac130_plt_readyformark" ] = "ac130_plt_readyformark";
	
	//Established overhead. ready for targets
	level.scr_radio[ "ac130_plt_readyfortargets" ] = "ac130_plt_readyfortargets";
	
	// "Roger that.  Taking out targets ahead of you."
	level.scr_radio[ "ac130_plt_targetsahead" ] = "ac130_plt_targetsahead";
	
	// "Metal Zero One, engaging the target.  Danger close."
	level.scr_radio[ "ac130_plt_engagingtarget" ] = "ac130_plt_engagingtarget";

}	

bridge_dialogue()
{

	level thread c130_tank_dialogue();
	 
	 flag_wait("slamzoom_complete");
 
	 flag_set("jav_obj_started");
	 
	 wait(10);
	 //stand by zero-one, makin adjustments,...
	 radio_dialogue( "ac130_plt_adjustments" );
	 			
	 //wait(18);
	 
	 do_nags_til_flag("player_has_javelin", undefined, "ac130_snd_usejavelin", "ac130_snd_getjavelin"); //ac130_snd_getjavelin
	 
	 wait(2);
	 do_nags_til_flag("1_tank_left", undefined, "ac130_snd_usejavelin", "ac130_snd_hittanksnow"); 

	 wait(1);
	 //one down now get the other one
	 radio_dialogue("ac130_snd_getotherone");
	 
	wait(3);

	level do_nags_til_flag("all_tanks_destroyed", undefined, "ac130_snd_takeoutother", "ac130_snd_hitlasttank", "ac130_snd_finishtanks"); 
	
	wait(1);
	radio_dialogue( "ac130_trk_tanksaredown" );
	
	flag_wait( "alamo_clear" );
	
	// "Overlord, this is Metal Zero One!  Black LZ at grid two, seven, seven, five."
	radio_dialogue( "ac130_snd_blacklz" );
	
	flag_wait( "attack_choppers_spawned" );
	wait( 8 );
	//warhammer we have enemy air support comin in, need you to take care of em!
	radio_dialogue( "ac130_snd_takecareofem" );
	
	flag_wait("both_choppers_down");
	
	// "Zero One, we're bingo on fuel.  CAS support will be here in thirty seconds.  Just hold on."
	radio_dialogue( "ac130_plt_bingofuel" );
	
	// "Rog'!  Thirty seconds, gentlemen!"
	radio_dialogue( "ac130_snd_gentlemen" );
	
	// "I don't think we'll last that long!"
	level.bishop play_sound_on_entity( "ac130_rno_lastthatlong" );
	
	// "They got a ton of armor rollin in!  We're gonna get pinned down!"
	radio_dialogue( "ac130_trk_tonofarmor" );
	
	wait(2);
	
	//last mag!
	radio_dialogue ( "ac130_rno_lastmag" );
	
	wait(3);
	// "Zero One, Odin Six.  Can't tell who's who down there.  Need you to mark the targets."
	radio_dialogue( "ac130_odn_whoswho" );
	
	// "Negative!  Nothing left to use!"
	radio_dialogue( "ac130_snd_nothingleft" );
	
	wait(.4);
	
	// "We're dead center on the bridge!  Hit anything North of us with everything you got!"
	radio_dialogue( "ac130_snd_deadcenter" );
	
	// "I don't want to die here!"
	//level.makarov_number_2 play_sound_on_entity( "ac130_vlk_dontwanttodie" );
	
	// "I'll tell you everything!  Just don't let me die!"
	//level.makarov_number_2 play_sound_on_entity( "ac130_vlk_tellyoueverything" );
	
	// "Maybe it is a good day to die."
	//level.bishop play_sound_on_entity( "ac130_rno_dietoday" );
	wait(2);
	
	// "Overlord, bombing run is going to level EVERTYTHING in that area, requesting clearnece."
	radio_dialogue( "ac130_odn_leveleverything" );
	
	wait(.8);
	
	// "Odin do whatever you have to to get those men back home"
	radio_dialogue( "ac130_hqr_dowhatever" );
	
	flag_set("bomb_run_vo_finished");
	
	//EIFFEL COLLAPSE 
	
	wait(4);
	level.bishop thread play_sound_on_entity("ac130_gtr_tower");
	
	flag_wait("pickup_choppers_in");
	
	wait(7);
	radio_dialogue( "ac130_vnd_backtobase" );
	
	// "Sounds good, Vandal.  Anywhere but here."
	level.sandman play_sound_on_entity( "ac130_snd_vandalready");
	
	// "What about Volk? "
	level.hitman play_sound_on_entity( "ac130_trk_whataboutvolk" );
	
	//"I'll take him.  Make sure he gets on the next bird."
	level.bishop play_sound_on_entity( "ac130_rno_nextbird" );
	
	wait(1);
	
	// "Alright, do it!"
	level.sandman play_sound_on_entity( "ac130_snd_alrightdoit");
	
	// "…and Grinch…we need him alive."
	level.sandman play_sound_on_entity( "ac130_snd_needhimalive");
	
	 // Have a nice ride gentlemen
	level.bishop play_sound_on_entity( "ac130_rno_niceride" );
	
}	

c130_tank_dialogue()
{
	//needed a spearate func for this so it would cutoff when player shot tank
	
	level endon ("player_shot_tank");
	
	flag_wait( "humvee_at_bridge" );
	
	//stop stop stop !
	radio_dialogue("ac130_snd_stopstop");
	
	//one fo our vehicles is down
	radio_dialogue("ac130_tvo_vehicledown");
	
	wait(randomfloatrange(.2, .5) );
	
	//yep I see em
	radio_dialogue("ac130_fco_yepiseeem" );
	
	//one of the humvees has just been hit
	radio_dialogue("ac130_fco_humveehit");
	
	//convoy is stalled, armor on the bridge. Need you to hit it NOW.
	radio_dialogue("ac130_snd_convoystalled"); 
	
	// "Zero One, any ordinance on that bridge is going to prevent you from getting to the LZ."
	radio_dialogue("ac130_plt_ordinance");
	
	// "Too late.  This is the LZ now."
	radio_dialogue("ac130_snd_thisisthelznow");
	
	// "Crew, you are cleared to engage the armor on the bridge."
	radio_dialogue("ac130_plt_engagearmor");
	
	//"set security!"
	//radio_dialogue("ac130_snd_setsecurity");
	
	level do_nags_til_flag("player_shot_tank", undefined, "ac130_fco_hitarmor", "ac130_fco_engagetanks", "ac130_fco_hittanksbig"); 
}

sandman_moveup_line()
{
	
	//establish the array of lines to use
	if(!IsDefined(level.moveup_lines))
	{
		level.moveup_lines = [];
		level.moveup_lines[level.moveup_lines.size] ="ac130_snd_letsgoletsgo2";	
		level.moveup_lines[level.moveup_lines.size] ="ac130_snd_onme2";
		level.moveup_lines[level.moveup_lines.size] ="ac130_snd_movemovecmon";
	}
	
	//and the used_lines array as well
	if(!IsDefined(level.used_moveup_lines))
	{
		level.used_moveup_lines = [];
	}	
	
	//mix up the array and pick a random one
	mixed_lines = array_randomize( level.moveup_lines );
	random_line = random (mixed_lines);
	
	//have sandman say random line	
	radio_dialogue ( random_line, 4 );
			
	//add that line to the used array
	level.used_moveup_lines = add_to_array (level.used_moveup_lines, random_line );
	
	//remove the line from the lines array
	level.moveup_lines = array_remove (level.moveup_lines, random_line);
	
	//if we've used all the lines
	if(level.moveup_lines.size == 0)
	{
		//reset the array 
		level.moveup_lines = level.used_moveup_lines;
		
		//empty the used lines array
		level.used_moveup_lines = [];
	}	
}

do_nags_til_flag(flag_ender, pilot_confirm, alias0, alias1, alias2, alias3, alias4)
{
	if(flag( flag_ender ) )
	{
		return;
	}	
	level endon (flag_ender);
	
	lines = [];
	lines[0] = alias0;
	
	if(isdefined(alias1))
	{
		lines[1] = alias1;
	}
	
	if(isdefined(alias2))
	{
		lines[2] = alias2;
	}
	
	if(isdefined(alias3))
	{
		lines[3] = alias3;
	}
	
	if(isdefined(alias4))
	{
		lines[4] = alias4;
	}
	
	while(!flag(flag_ender))
	{
		foreach (radio_line in lines)
		{
			radio_dialogue(radio_line);
			//c130 tells player to take out armor as well  (66% chance)
			if(isdefined(pilot_confirm))
			{
				if(randomint(100) > 33)
				{
					if(cointoss() )
					{
						level.player playsound ("ac130_fco_getontanks");
					}
					else 
					{	
						level.player playsound ("ac130_fco_enemyarmor");
					}	
				}	
			}	
			wait(randomintrange (13, 16) );
		}
	}
}			
			
track_player()
{
	trigger_wait_targetname("squad_pos3");
	flag_set ("player_past_bus");

}

track_player_hvt()
{
	//player at t-section upsatirs
	trigger_wait_targetname("player_stairs");
	flag_set ("player_went_upstairs");
	if(level.start_point == "start_e3")
	{
		level.player notify( "stop_demo" );
	}	
	level thread hvt_turret_nag();	
	trigger_wait_targetname( "player_bedroom" );
	flag_set ("player_at_bedroom");
	level.hitman play_sound_on_entity("ac130_hit_taghim");

}
	
crash_jet()
{

	explosion_node = getvehiclenode ("explode", "script_noteworthy");
	explosion_node2 = getvehiclenode ("explode2", "script_noteworthy");
	//array_thread (explosion_nodes, ::vehicle_node_play_fx, "huge_explosion2");
	explosion_node thread  vehicle_node_play_fx("FX_flak_large");
	explosion_node2 thread  vehicle_node_play_fx_on_jet();

	splash_nodes = getvehiclenodearray ("splash", "script_noteworthy");
	array_thread (splash_nodes, ::vehicle_node_play_fx, "jet_crash_water_impact_ac130", 1, "rocket_explode_water_splash");

	jet_spawner = getvehiclespawner ("crash_jet");
	crash_jet = jet_spawner spawn_vehicle_and_gopath();
	
	wait(.10);
	back_fire = playfxontag(level._effect["FX_jet_smoke_trail"], crash_jet, "tag_engine_left");
	
	crash_jet delaythread(2.2, ::play_sound_on_entity, "scn_ac130_bridge_jet_crash_leadin");
	
	//"INCOMING!!"
	level.hitman delaythread( 3.5, ::play_sound_on_entity,  "ac130_hit_incoming" );
	
	crash_jet waittill ("reached_end_node");
	spot = crash_jet.origin;
	thread play_sound_in_space("scn_ac130_bridge_jet_crash_ground", spot);
	//scn_ac130_bridge_jet_crash
	playfx( level._effect[ "jet_crash"], spot );
	crash_jet delete();
		
	earthquake(1, 1.4, level.player.origin, 100);
	level.player playrumblelooponentity ("damage_heavy");
	level.player delaycall (2, ::stoprumble, "damage_heavy" );
	
	exploder("jet_crash_splash");
	
	flag_set ("crash_jet_complete");

}	

vehicle_node_play_fx(fx_alias, sound, sound_alias)
{
	//self = vehicle_node
	self waittill ("trigger");
	playfx( level._effect[ fx_alias ] , self.origin );
	
	if(isdefined(sound))
	{
		self thread play_sound_in_space (sound_alias, self.origin);
	}
	
}	

vehicle_node_play_fx_on_jet( sound, sound_alias)
{
	//self = vehicle_node
	self waittill ("trigger", who);
	playfx( level._effect[ "FX_flak_large" ] , self.origin );
	
	if(isdefined(sound))
	{
		self thread play_sound_in_space (sound_alias, self.origin);
	}
	
	fwd = anglestoforward( who.angles );
	up = anglestoup( who.angles );
	
	playfx( level._effect[ "metal_eject_far" ], who.origin, fwd, up );
	
}

play_anim_off_me(actor, flag_starter, shorten, shorten_amount)
{
	//self = script_origin;
	if(isDefined(flag_starter))
	{
		flag_wait (flag_starter);
	}	
	scene = self.targetname;
	self thread anim_single_solo_run(actor, scene);
	wait(.05);
	actor show();
	if(IsDefined(shorten))
	{
		actor anim_self_set_time( scene, shorten_amount);
	}	

}


setup_javelin_objectives()
{
	spot = getstruct ("crash_fire", "targetname");
	playfx ( level._effect[ "FX_gaz_on_fire" ], spot.origin);	
	
	//make javelin glow
	flag_wait ("slamzoom_complete");
	javs = getentarray ("bridge_javelin", "targetname");
	array_thread (javs, ::jav_setup);
	
	tanks = get_vehicle_array ("bridge_tanks", "script_noteworthy");
	tanks = array_removedead (tanks);
	array_thread (tanks, ::only_die_by_jav);

	//tanks dont shoot MG's unless theyre a jav obj
	foreach(tank in tanks)
	{
		tank.mgturret[0] setmode("manual");	
	}	
	
	closest_tank = getClosest( level.player.origin, tanks );	
	
	if( tanks.size == 2 )
	{	
		// T W O  T A N K S  L E F T 
		flag_set ("2_tanks_left");
		//Destroy enemy vehicles (2 of 2)
		objective_state( obj( "OBJ_destroy_tanks" ), "done");
		objective_Add( obj( "OBJ_shoot_tanks" ), "current", &"PARIS_AC130_OBJ_BRIDGE_DESTROY_TANK_JAV_2" );
		Objective_Position(  obj( "OBJ_shoot_tanks" ), javs[0].origin );
			
		closest_tank thread make_me_javelin_target();
		closest_tank thread tank_attack();
		closest_tank thread bridge_tank_mg_turret_logic();
		level waittill ("tank_death");	//notify sent from make_me_javelin_target()
	}	
	
	flag_set ("1_tank_left");
	
	// O N E   T A N K  L E F T 
	wait(.5);
	//Destroy enemy vehicles (1 of 2)
	Objective_string (  obj( "OBJ_shoot_tanks" ), &"PARIS_AC130_OBJ_BRIDGE_DESTROY_TANK_JAV_1" );
	
	//remove target tank from array
	tanks = array_remove(tanks, closest_tank );
	//wait(.10);
	//tanks = array_removedead (tanks);
	//get closest tank again
	closest_tank = getClosest( level.player.origin, tanks );	
	//make it the objective/jav target
	closest_tank thread make_me_javelin_target();
	closest_tank thread tank_attack();
	closest_tank thread bridge_tank_mg_turret_logic();
	//objective_onentity( level.current_objective, closest_tank );
	
	level waittill ("tank_death");	
	Objective_string (  obj( "OBJ_shoot_tanks" ), &"PARIS_AC130_OBJ_BRIDGE_DESTROY_TANK_JAV_COMPLETED" );
	Objective_state (  obj( "OBJ_shoot_tanks" ), "done");
	flag_set ("all_tanks_destroyed");
	
	wait(2);
	
	Objective_Add( obj( "OBJ_push_to_lz" ), "current", &"PARIS_AC130_OBJ_BRIDGE_PUSH_LZ" );
	
}	

jav_setup()
{
	self thread add_jav_glow("player_has_javelin");
	self waittill ("trigger");
	flag_set ("player_has_javelin");
	Objective_Position(  obj( "OBJ_shoot_tanks" ), (0,0,0) );
		
}	

bridge_tank_mg_turret_logic()
{
	self endon("death");
	
	if(!isDefined( self.mgturret[0] ))
	{
		return;
	}	
	
	self.mgturret[0] setmode("manual");	
	num = randomintrange(15, 30);
	shot_amount = randomintrange(15, 20);
	
	while(isAlive(self))
	{
		stance = level.player GetStance();
		if(stance == "stand")
		{
			start = get_world_relative_offset(self.mgturret[0] gettagorigin ("tag_flash"), self.mgturret[0] gettagangles ("tag_flash"), (10, 0 , 0));
			end = level.player.origin +(num, num, num);
			if(!isdefined( end ))
			{
				continue;
			}	
			for(i=0; i<shot_amount; i++)
			{
				magicbullet("dshk_turret_sp", start, end);
				wait(.14);
			}							
		}
		else
		{
			guy = random(level.delta);
			start = self.mgturret[0] gettagorigin ("tag_flash");
			end = guy.origin +(num, num, num);
			if( !isDefined(guy.origin) )
			{
				continue;
			}	
			for(i=0; i< shot_amount;i++)
			{
				magicbullet("dshk_turret_sp", start, end);
				wait(.14);
			}	
		}		
	  wait(1);
	}

}	


#using_animtree( "script_model" );
effiel_anims()
{
	level.scr_animtree[ "tower" ] = #animtree;	
	level.scr_anim[ "tower" ][ "des_1" ]	=%paris_ac130_tower_destruction_1;
	level.scr_anim[ "tower" ][ "des_2" ]	=%paris_ac130_tower_destruction_2;
	level.scr_anim[ "tower" ][ "des_3" ]	=%paris_ac130_tower_destruction_3;
	
	level.scr_anim[ "tower" ][ "des_finale" ] =%paris_ac130_tower_destruction_finale;
	/*
	level.scr_anim[ "tower" ][ "des_4" ]	=%paris_ac130_tower_destruction_4;
	level.scr_anim[ "tower" ][ "des_5" ]	=%paris_ac130_tower_destruction_5;
	level.scr_anim[ "tower" ][ "des_6" ]	=%paris_ac130_tower_destruction_6;
	level.scr_anim[ "tower" ][ "des_7" ]	=%paris_ac130_tower_destruction_7;
	level.scr_anim[ "tower" ][ "des_8" ]	=%paris_ac130_tower_destruction_8;
	level.scr_anim[ "tower" ][ "des_9" ]	=%paris_ac130_tower_destruction_9;
	level.scr_anim[ "tower" ][ "des_10" ] =%paris_ac130_tower_destruction_10;
	level.scr_anim[ "tower" ][ "des_11" ] =%paris_ac130_tower_destruction_11;
	*/
	addNotetrack_flag( "tower", "show_dest_4", "hide_3_show_4", "des_finale" );
	addNotetrack_flag( "tower", "show_dest_5", "hide_4_show_5", "des_finale" );
	addNotetrack_flag( "tower", "show_dest_6", "hide_5_show_6", "des_finale" );
	addNotetrack_flag( "tower", "show_dest_7", "hide_6_show_7", "des_finale" );
	addNotetrack_flag( "tower", "show_dest_8", "hide_7_show_8", "des_finale" );
	addNotetrack_flag( "tower", "show_dest_9", "hide_8_show_9", "des_finale" );
	addNotetrack_flag( "tower", "show_dest_10", "hide_9_show_10", "des_finale" );
	addNotetrack_flag( "tower", "show_dest_11", "hide_10_show_11", "des_finale" );
	
	addNotetrack_flag( "tower", "tower_fall_stall", "tower_fall_stall", "des_finale" );
	addNotetrack_flag( "tower", "tower_impact_corner", "tower_collapse_dirt", "des_finale" );
	addNotetrack_flag( "tower", "tower_impact_mid", "tower_collapse_dirt_mid", "des_finale" );
	addNotetrack_flag( "tower", "tower_impact_fence", "tower_collapse_fence", "des_finale" );
	addNotetrack_flag( "tower", "tower_impact_water", "tower_collapse_water", "des_finale" );
	addNotetrack_flag( "tower", "tower_impact_gust", "tower_collapse_gust", "des_finale" );
	
	addNotetrack_startFXonTag( "tower", "tower_fall_stall", "des_finale", "metal_eject", "TAG_TOP_FX2" );

	
	//addNotetrack_customFunction( "tower", "tower_fall_stall", Maps\paris_ac130_slamzoom::play_tower_stall("TAG_TOP_FX2"), "des_finale" );
	
	//play_tower_stall("TAG_TOP_FX2");
	
	
/*
FRAME 1221 "show_dest_4"      ( 0 )
FRAME 1393 "show_dest_5"      ( 5.733333 )
FRAME 1451 "show_dest_6"      ( 7.666667 )
FRAME 1480 "show_dest_7"      ( 8.633333 )
FRAME 1527 "show_dest_8"      ( 10.2 )
FRAME 1544 "show_dest_9"      ( 10.76667 )
FRAME 1563 "show_dest_10"     ( 11.4 )
FRAME 1572 "show_dest_11"     ( 11.7 )
*/	
	
level thread eiffel_collapse();
}

	

#using_animtree("generic_human");
bridge_anims()
{	
	level.scr_anim[ "gator" ][ "humvee_crawl1" ]	=%paris_ac130_crawl_from_humvee_1;
	level.scr_anim[ "hitman" ][ "humvee_crawl2" ]	=%paris_ac130_crawl_from_humvee_2;	
	level.scr_anim[ "snd" ][ "hummer_exit" ]	=%paris_ac130_run_around_humvee;
	level.scr_anim[ "snd" ][ "nade_toss" ]	=%CQB_stand_grenade_throw;
	
	//sandman smoke nade toss at alamo
	addNotetrack_customFunction( "snd", "grenade_throw", ::notetrack_nade_throw, "nade_toss" );
	
}	

friendly_management()
{	
	//humvees first arrive, unload
	flag_wait ("squad_at_bridge");
	activate_trigger_with_targetname ("squad_pos_1");
	battlechatter_on("allies");
	
	level.sandman.animname = "snd";
	level.gator.animname = "gator";
	level.hitman.animname = "hitman";
	
	
	level thread setup_HVT_guard();
	
	humvee_crawl_nodes = getentarray ("humvee_crawl_nodes", "script_noteworthy");
	humvee_crawl_nodes[0] thread  play_anim_off_me(level.hitman, "player_shot_tank", 1, .6);
	humvee_crawl_nodes[1] thread  play_anim_off_me(level.gator, "player_shot_tank");
	
	player_hummer = getent("hummer_exit", "targetname");
	player_hummer thread  play_anim_off_me(level.sandman, "notetrack_flag_sandman_start" );
	
	//occurs when player slamzooms down, exits humvee
	flag_wait( "notetrack_flag_sandman_start" );
	wait(.05);
	//level.sandman show();
	baddies = getaiarray("axis");
	foreach( guy in baddies )
	{
		//to prevent nades thrown at javelin 
		guy.grenadeammo = 0;
	}	
	
	//Dont move up until first baddies group is dead
	flag_wait("bridge_group1_clear");
	//don't moveup if players hasnt even got the jav yet
	flag_wait("player_has_javelin");	
	color_trig = getent ("squad_pos2", "targetname");
	if(isdefined( color_trig)) //not defined if player has hit it already
	{
		//color_trig notify ("trigger");
		activate_trigger_with_targetname("squad_pos2");
		color_trig delete();
		wait(randomfloatrange(1.5, 2.4));
	}	
		
	// Dont moveup til both tanks are dead
	flag_wait("all_tanks_destroyed");	
	level thread sandman_moveup_line();
	
	enemy_retreat_trig  = getent ("axis_pos4_trig", "targetname");
	if(isdefined( enemy_retreat_trig)) //not defined if player has hit it already
	{
		enemy_retreat_trig notify ("trigger");		
	}	
		
	wait(2);//time for baddies to retreat.
	
	activate_trigger_with_targetname("squad_pos3");
	thread safe_autosave();
	
	level.strobe_cooldown_override = 30;
	level thread c130_inform_player_attacking();	
	add_extra_autosave_check( "strobe_check", ::autosave_strobe_check, "can't save with air strobe active" );	
	if(isAlive(level.player))
	{
		level.player thread air_support_strobe_vo();
		wait(2);
		level.player thread show_air_support_hint(5);
		level.player maps\_air_support_strobe::enable_strobes_for_player();
	}
	
	level flag_wait_or_timeout("bridge_squad_to_pos4", 40);
	
	//wait while air strobe is is active
	wait_for_air_strobe();
	
	color_trig = getent ("squad_pos4", "targetname");
	if(isdefined( color_trig)) //not defined if player has hit it already
	{
		//color_trig notify ("trigger");
		activate_trigger_with_targetname("squad_pos4");
		color_trig delete();
		wait(randomfloatrange(1.5, 2.4));
		//level.sandman playsound( "ac130_snd_pushforward" );		
	}	
	level thread sandman_moveup_line();
	level thread crash_jet(); //epic jet crash
		
	enemy_retreat_trig  = getent ("axis_pos5_trig", "targetname");
	if(isdefined( enemy_retreat_trig)) //not defined if player has hit it already
	{
		enemy_retreat_trig notify ("trigger");		
	}	

	wait(5);

	level flag_wait_or_timeout("alamo_clear", 45); //only couple guys left

	//music_stop(2);
	//delaythread( 2.5, ::musicplaywrapper, "paris_ac130_defend_bridge_mx");
	
	//wait while air strobe is is active
	wait_for_air_strobe();
	
	if(!flag("flag_strobes_in_use"))
	{
		level.player thread show_air_support_hint(5);
	}	
	
	color_trig = getent ("new_alamo_color_trig", "targetname");
	if(isdefined( color_trig)) //not defined if player has hit it already
	{
		//color_trig notify ("trigger");
		activate_trigger_with_targetname("new_alamo_color_trig");
		//color_trig delete();
		wait(randomfloatrange(1.5, 2.4));
	}	
	
	level thread sandman_drops_smoke();
	
	wait(2);
	//array_wait(level.delta, "goal");
	spot = getstruct ("player_distance_monitor", "targetname");
	dist = distancesquared(spot.origin, level.player.origin);
	
	//wait for player to get close to Alamo before continuing
	while(dist >= 500*500)
	{
		dist = distancesquared(spot.origin, level.player.origin);
		wait(.5);
	}	
		
	flag_set ("squad_at_final_pos");
	thread Safe_Autosave();
	
	//no nades for bad guys when we get to the alamo.
	//spawn function handles unspawned ai. 
	baddies = getaiarray("axis");
	foreach(b in baddies)
	{
		b.grenadeammo = 0;
	}	
	
	wait(1);
	Objective_state( obj( "OBJ_push_to_lz" ), "done");
	Objective_Add( obj( "OBJ_defend_lz" ), "current", &"PARIS_AC130_OBJ_DEFEND_LZ" );
	
}	

safe_autosave()
{
	level notify("attempting_bridge_autosave");
	level endon ("attempting_bridge_autosave");
	
	while(1)
	{
		current_weapon = level.player getcurrentweapon();
		if( flag("flag_strobes_in_use" ) || current_weapon == "air_support_strobe"  )
		{
			wait(.05);
		}
		else
		{
			autosave_by_name("bridge_checkpoint");	
			//autosave_tactical();
			return;
		}	
	}			
}	

autosave_strobe_check()
{
	return ( !flag("flag_strobes_in_use") ||  ( level.player getCurrentWeapon() != "air_support_strobe" ) );
}

wait_for_air_strobe()
{
	while(1)
	{
		if(flag("flag_strobes_in_use"))
		{
			wait(.5);
		}
		else
		{
			return;
		}		
	}		

}	

sandman_drops_smoke()
{
	nade_toss = getent("nade_toss", "targetname");
	nade_land = getstruct ("nade_land", "targetname");	
	level.sandman.grenadeammo = 0;
	level.sandman.animname = "snd";
	
	level.sandman disable_ai_color();
	
	radio_dialogue( "ac130_snd_strongpoint" );
	
	nade_toss anim_reach_solo(level.sandman, "nade_toss");
	nade_toss anim_single_solo(level.sandman, "nade_toss");
	level.sandman set_force_color("r");
	
	// "Red smoke on the LZ!  Need you to service targets North of that location!"
	radio_dialogue( "ac130_snd_strobeson");
	
	// "Mark the target with smoke Frost!"
	radio_dialogue( "ac130_snd_markthetarget" );

}	

notetrack_nade_throw(guy)
{
	nade_land = getstruct ("nade_land", "targetname");	
	nade_land_ent = spawn ("script_origin", nade_land.origin);
	nade_land_ent.angles = nade_land.angles;
	smoke_fwd = AnglesToForward(nade_land_ent.angles); 
	smoke_up  = AnglesToUp (nade_land_ent.angles);
		
	start_pos = guy gettagorigin("tag_inhand");
	start_angles = guy gettagangles("tag_inhand");
	nade = spawn ("script_model", start_pos);
	nade.angles = start_angles;
	nade setmodel("projectile_us_smoke_grenade");
	
	vector = nade_land.origin - guy.origin;
	angles = VectorToAngles( vector );
	forward = AnglesToForward( angles );
	velocity = forward * 20;
	
	nade physicslaunchserver (nade.origin, velocity);
	wait(1.5);
	fx = getfx( "FX_smoke_signal_osprey" );
	playfx(fx, nade.origin, smoke_fwd, smoke_up*-1);
}	

bridge_frost_setup()
{
	if(isDefined(self))
	{
		self stop_magic_bullet_shield();
		self die();	
	}	

}

	
hostage_logic()
{
	//self = HVT
	self waittill ("jumpedout");
	//self thread Print3d_on_me("HVT");
	self thread clear_run_anim();
	self.animname = "generic";
	wait(.5);
	node = getnode ("hvt_start", "targetname");
	//self thread maps\_carry_ai::setWounded( node );
	
	self animscripts\shared::DropAIWeapon();
	
	// make the president go into his wounded idle
	self maps\paris_ac130_code::clear_child_ai();

	wait(.10);
	self.woundedNode = node;
	self.woundedNode thread anim_generic_loop( self, "wounded_idle", "stop_wounded_idle" );

}	

force_humvee_unload()
{	 
	//self = humvee 1 or 2
	self waittill ("reached_end_node");
	self hide();
	guys = thread vehicle_unload();//returns all allies exiting 2 humvees
	
	foreach(guy in guys)
	{
		//some riders are hidden from crash anim
		guy show();
		
		if(guy == level.makarov_number_2)
		{	
			guy thread hostage_logic();
			continue;
		}
		else if(guy == level.frost)
		{
			guy thread bridge_frost_setup();
			continue;
		}	
		
		guy set_force_color ("r");
		guy.ignoreall = 0;
		guy.ignoreme = 0;
			
		//create array of guys from all friendlies unloading
		level.squad = add_to_array (level.squad, guy);
	}	
	
	flag_set ("squad_at_bridge");
	wait(.4);
	player_hummer = getent("hummer_exit", "targetname");
	player_hummer thermaldrawenable();
	
	flag_wait("player_shot_tank");
	
	while( self.riders.size > 0 )
	{
		wait(.5);
	}	
	
	self delete();
	 
}	


enemy_management()
{
	level thread enemy_retreat_timing();
	
	spawners = getentarray ("bridge_enemies_bus", "targetname");
	array_thread(spawners, ::add_spawn_function, ::bridge_guys_logic);
	
	spawners = getentarray ("alamo_floods", "targetname");
	array_thread(spawners, ::add_spawn_function, ::bridge_guys_logic);
	
	createthreatbiasgroup("defend_enemies");
	spawners = getentarray ("rear_bridge_floods", "targetname");
	array_thread(spawners, ::add_spawn_function, ::rear_bridge_flood_logic);
	
	spawners = getentarray ("chopper_fodder", "targetname");
	array_thread(spawners, ::add_spawn_function, ::chopper_fodder_logic);
	
	spawners = getentarray ("area3_baddies", "targetname");
	array_thread(spawners, ::add_spawn_function, ::area3_guys_logic);
	
	activate_trigger_with_targetname ("bridge_tank1_move");
	
	existing_baddies = getAIarray("axis");
	array_thread(existing_baddies, ::delete_me);
	
	existing_baddies = getAIarray("team3");
	array_thread(existing_baddies, ::delete_me);
	
	wait(.10);
	//guys = get_guys_with_targetname_from_spawner ("bridge_ac130_enemies_bus");
	guys = getentarray ("bridge_ac130_enemies_bus", "targetname");
	guys = array_spawn(guys, 1);
	
	//player shot tank from ac130. Slamzoom begins now
	flag_wait ("player_shot_tank");
	activate_trigger_with_targetname ("tank2_move");
	
	boats = getentarray ("river_boats", "script_noteworthy");
	array_thread (boats, ::make_me_a_defend_javelin_target);
	
	//delete the ac130 specific enemies once the player starts slamzoom
	array_thread (guys, ::delete_me);
	
	//close enemy group spawns behind the bus
	bridge_group1 = getentarray ("bridge_group1", "targetname");
	guys = array_spawn(bridge_group1, 1);
	foreach(guy in guys)
	{
		guy.goalradius = 32;
		//node = getnode (guy.target, "targetnamne");
		//guy setgoalnode (node);
		//guy.fixednode = true;
		guy.baseaccuracy = 1.5;
	}	
	
	//delete spawners
	array_delete(bridge_group1);
	
	level thread set_flag_when_x_remain( guys, "bridge_group1_clear",  3); 
	level thread bus_guy_monitor(guys);
	
	flag_wait("bridge_group1_clear");

	spawners = getentarray ("alamo_floods", "targetname");
	maps\_spawner::flood_spawner_scripted( spawners );
	
	//one shot spawn of 4 guys to ensure intensity at pos 3.
	flag_wait ("bridge_squad_to_pos3");
	wait(6);
	area3_baddies = getentarray ("area3_baddies", "targetname");
	area3_baddies_ai = array_spawn(area3_baddies, 1);
	wait(1);	
	//delete spawners
	array_delete(area3_baddies);
		
	//waiting to spawn main floods until squad is at pos 4
	flag_wait("bridge_squad_to_pos4");	
	array_delete(spawners);
	
	axis = getaiarray("axis");
	/*
	while(axis.size > 3 )
	{
		axis = getaiarray("axis");
		wait(1);
	}	
	*/
	level thread set_flag_when_x_remain( axis, "alamo_clear", 3);
	flag_wait_or_timeout("alamo_clear", 20);

	//give trucks a few secs to get ahead
	//spawm trucks earlier so they dont run over guys
	activate_trigger_with_targetname ("bm21_spawner");
	wait(.5);
	trucks = get_vehicle_array ("bridge_trucks", "script_noteworthy");
	array_thread (trucks, ::make_me_a_defend_javelin_target);
	
	wait(4);
	
	//flood ai from end of bridge..squad is moving to alamo at this point
	spawners = getentarray ("rear_bridge_floods", "targetname");
	maps\_spawner::flood_spawner_scripted( spawners );
	
	//array_thread (trucks, ::only_die_by_jav);
	wait 1;
	//flag_wait("squad_at_final_pos");
	createthreatbiasgroup("defend_player");
	level.player setthreatbiasgroup("defend_player");
	SetThreatBias ("defend_player", "defend_enemies", 200000000);
	smoke_spots = getstructarray("bridge_smoke", "targetname");
	foreach(spot in smoke_spots)
	{
		playfx( level._effect["smoke_grenade"], spot.origin );
		//level delaythread( 30, Maps\_fx::script_playfx, getfx("smoke_grenade"), spot.origin);
	}	
	
	//NEW DEFEND TIMING!!!!
	//wait(40);
	
	//c130 has killed both choppers
	flag_wait("both_choppers_down");
	
	wait_for_air_strobe();
		
	//iprintlnbold("C130: We're taking heavy fire and are unavailable!");
	level.player maps\_air_support_strobe::disable_strobes_for_player();
	remove_extra_autosave_check( "strobe_check" );

	//last parade of btrs and tanks
	wait(3);
	level thread final_bridge_vehicles();
	level thread take_jav_ammo();
	
	//key timing to stay alive against the calvary
	wait(10);
	//iprintlnbold("Sandman: Overlord we need ordinance at our location!!!!");
	wait(6);
	//iprintlnbold("Pilot: metal Zero One find cover DANGER CLOSE");
	//Bridge gets bombed, tower gets bombed
	flag_wait("bomb_run_vo_finished");
	flag_set("bombing_run"); 
	
	//stop the floods
	array_delete(spawners);
	
	wait(21);	
	
	//Little bird
	delaythread(5, ::pickup_choppers);
	
	//Blackhawks
	flag_set ("spawn_pickup_choppers");
	level thread spawn_blackhawks();
	set_ambient( "paris_ac130_groundbridge1_ext" );
	
	flag_wait("pickup_choppers_in");
	wait(10);
	spawners = getentarray ("chopper_fodder", "targetname");
	maps\_spawner::flood_spawner_scripted( spawners );
	
}	

take_jav_ammo()
{
	playerPrimaryWeapons = level.player GetWeaponsListPrimaries();
	if (is_in_array( playerPrimaryWeapons, "javelin") )
	{
		//if player is ads, wait to take ammo
		while( level.player maps\_javelin::PlayerJavelinAds() )
		{
			wait(.5);
		}	
		level.player setweaponammoclip( "javelin", 0 );
		level.player setweaponammostock( "javelin", 0);
	}	
}	

bus_guy_monitor(guys)
{
	//kill bus guy if hes still alive. Allies were not moving up and trying to kill him. 
	flag_wait ("bridge_group1_clear");//1 or 2 left
	guys = array_removedead_or_dying(guys);
	
	if(guys.size != 0)
	{
		trig = getent ("bus_trig", "targetname");//trig inside bus
		foreach(guy in guys)
		{
			if(guy istouching(trig))
			{
				guy die();
			}
		}
	}	
}		

enemy_retreat_pos_set()
{
	flag_wait ("bridge_squad_to_pos3");	
	level.current_retreat_pos = "axis_pos4";
	wait(.5);
	
	axis = getAIarray("axis");
	spots = getstructarray (level.current_retreat_pos, "targetname");	
	array_thread(axis, ::retreat_to_area, spots);

	//pos3_badplace = getent ("pos3_badplace", "targetname");
	//BadPlace_Brush( "pos3", -1, pos3_badplace, "axis" );
	
	flag_wait("bridge_squad_to_pos4");
	level.current_retreat_pos = "axis_pos5";
	axis = getAIarray("axis");
	spots = getstructarray (level.current_retreat_pos, "targetname");	
	array_thread(axis, ::retreat_to_area, spots);
	
	flag_wait ("bridge_squad_to_pos5");
	level.current_retreat_pos = "axis_pos6";
	axis = getAIarray("axis");
	spots = getstructarray (level.current_retreat_pos, "targetname");	
	array_thread(axis, ::retreat_to_area, spots);
}	

bridge_guys_logic()
{
	self endon ("death");	
	self.baseaccuracy = 1.5;
	
	//33% have nades
	if(randomint(100) > 66)
	{
		self.grenadeammo = 0;
	}	
	
	//first pos is the death pit in front of bus
	if(!IsDefined(level.current_retreat_pos))
	{
		level.current_retreat_pos = "axis_pos3";
	}
		
	spots = getstructarray (level.current_retreat_pos, "targetname");
	self thread retreat_to_area(spots);
	/*
	while(isDefined(self))
	{
		self waittill("new_retreat_spot");
		spots = getstructarray (level.current_retreat_pos, "targetname");
		//self.ignoreall = 1;
		self thread retreat_to_area(spots);

	}
	*/
}	


area3_guys_logic()
{
	spots = getstructarray ("axis_pos4", "targetname");
	self thread retreat_to_area(spots);
	self.grenadeammo = 0;	
}	

rear_bridge_flood_logic()
{	
	//25% chance they come at the player
	if(randomint(100) < 25)
	{
		self.goalradius = 32;
		self setgoalentity(level.player);
		self.baseaccuracy = 2;
		return;
	}
		
	spots = getstructarray ("axis_pos6", "targetname");
	self thread retreat_to_area(spots);
	self.baseaccuracy = 1;
	self SetThreatBiasGroup( "defend_enemies" );
	if(randomint(100) < 30 )
	{
		self.grenadeammo = 0;	
	}	

}	

chopper_fodder_logic()
{
	self endon ("death");
	spots = getstructarray ("axis_pos6", "targetname");
	self thread retreat_to_area(spots);
}		


set_flag_when_x_remain(ai_array, theflag, remaining_ai)
{
	while(ai_array.size > remaining_ai)
	{
		ai_array = array_removedead_or_dying(ai_array);
		wait(.10);
	}
	
	flag_set (theflag);	

}	

enemy_retreat_timing()
{
	flag_wait ("bridge_squad_to_pos3");
	spots = getstructarray ("axis_pos3", "targetname");
	axis = getaiarray("axis");
	array_thread (axis, ::retreat_to_area, spots);

}


#using_animtree("player");	
slam_zoom_custom(projectile, tank, position)
{
	level.player enableinvulnerability();	
	//collision for the model that animated with player hummer exit. Need to move it then wait for anim to finish, then move it back so player doesnt get unlinked inside collision
	hummer_exit_clip = getent ("hummer_exit_clip", "targetname");
	clip_home = hummer_exit_clip.origin;
	hummer_exit_clip moveto( clip_home -(0,0,300), .05);
	
	new_player_start = getstruct ("new_player_start", "targetname");
	
	level.player thread play_sound_on_entity ("javelin_fire_plr");
	autosave_by_name ("slamzoom_start");
	
	wait(.15); //save buffer
	
	level.player.ignoreme = 1;
	level.player freezeControls( true );
	level.player playrumblelooponentity ("damage_heavy");
	
	bridge_struct = getstruct ("player_bridge_start", "targetname");
	origin = bridge_struct.origin;

	ent = spawn( "script_model", level.player.origin);
	ent.angles = projectile.angles;
	ent setmodel("tag_origin");
	
	level thread slamzoom_clouds(ent);

	vehicle_scripts\_ac130::end_ac130(); 
	
	//level.player enableinvulnerability();	
	level.player playerlinktoabsolute ( ent, "tag_origin" );
	
	level thread spawn_c130_above_bridge(level.player.origin, tank.origin);	
	level.player thread play_sound_on_entity( "scn_ac130_slamzoom_redflags" );
	
	projectile delete();
	ent moveto (position, 1);
	earthquake(.5, 3, ent.origin, 8000);
	level.player viewkick(10, level.player.origin);
	
	wait_time = 1;
	level thread slamzoom_dof(wait_time, "slamzoom_complete");
	
	wait(wait_time * .5);
	level.player VisionSetNakedForPlayer( "coup_sunblind", 1.8 );
	delaythread(1,  ::vision_set_fog_changes, "paris_ac130_bridge", 2);	
	delaythread(.6, ::fade_in_on_flag, "white", "slamzoom_complete", .4 );
	wait(wait_time * .5);
		
	level.player thread play_sound_on_entity ("exp_ac130_105mm");
	wait(.2);

	if( isDefined(tank) && isAlive(tank) )
	{
		tank die();// passed in from did_player_shoot_me()  sometimes the tank wasnt dying
	}
	playfx( level._effect[ "FX_t72_death_explosion" ] , position);	

	player_hummer = getent("hummer_exit", "targetname");

	//spawn and setup viewhands
	player_top = spawn_anim_model( "player_arms", player_hummer.origin );
	player_top.angles = player_hummer.angles;
	
	//move to hummer script_model
	ent moveto ( player_hummer.origin, .10 );
	ent waittill ("movedone");
	ent.angles = player_hummer.angles;
	ent LinkTo( player_top, "tag_camera" );
			
	level.player stoprumble("damage_heavy");
	musicplay ("paris_ac130_bridge");
	
	node = spawn ("script_origin", player_hummer.origin );
	node.angles = player_hummer.angles;
	
	//restore things before playing anim
	SetSavedDvar("sm_SunSampleSizeNear", "0.25");
	SetSavedDvar("sm_SunShadowScale", "1.0");
	//level.player VisionSetNakedForPlayer("paris_ac130_bridge");
	//level.player thread vision_set_fog_changes ("paris_ac130_bridge", .5);	
	set_ambient("paris_ac130_groundbridge5_ext");
	setsaveddvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "hud_showStance", 1 );
		
	flag_set ("slamzoom_complete");
	
	//player getout anim
	node  anim_single_solo( player_top, "hummer_exit");
	
	//Animation over: give weapons, unlink
	player_top hide();
	restore_player_weapons();
	level.player unlink();	
	level.player freezeControls( false );
	level.player allowcrouch(true);
	level.player allowprone(true);
	level.player allowstand(true);	
	level thread torque_player_speed(2.5);
	
	thread safely_restore_collision(hummer_exit_clip, clip_home, node);
	
	level thread flush_current_targets();
	
	//god mode buffer time
	wait(1.5);
	ent delete();
	player_top delete();
	level.player disableinvulnerability();

	
}

safely_restore_collision(clip, clip_home, node)
{
	dist = distancesquared(node.origin, level.player.origin);
	while( dist < 130*130 )
	{
		dist = distancesquared(node.origin, level.player.origin);
		wait(.5);
	}	
	
	//restoring collision on model hummer now that player is out of it
	clip moveto(clip_home, .05);

}	


#using_animtree("vehicles");	
player_hummer_setup()
{
	player_hummer = getent("hummer_exit", "targetname");
	player_hummer.animname = "hummer";
	player_hummer maps\_anim::setanimtree();
	//player_hummer assign_animtree("hummer");
	flag_wait ("slamzoom_complete");
	player_hummer anim_single([player_hummer], "hummer_exit");
	
}	

restore_player_weapons()
{	
	level.player takeallweapons();
	
	//cant restore courtyard weapons if we're using a skipto so just arm the player
	if(level.start_point == "start_bridge" || level.start_point == "start_chase" )
	{
		level arm_player(1);//give nades too
		level thread set_203_ammo(3);
		return;
	}
	
	foreach(weapon in level.current_player_loadout)
	{	
		if (issubstr( tolower( weapon ), "alt_" ) )
		{			
			//if its the 203, only give ammo, dont actually give the weapon.
			println("Giving altweapon ammo for:"  +weapon);
			level.player setweaponammoclip( weapon, 1 );
			level.player setweaponammostock( weapon, 2);
			continue;
		}
		else if(weapon == "rpg_player")
		{
			//dont want to refill RPG to avoid confusion with tank/javelin on bridge
			println("Giving limited RPG ammo for:"  +weapon);
			level.player giveWeapon(weapon);	
			level.player setweaponammoclip( weapon, 1 );
			level.player setweaponammostock( weapon, 0);
			continue;		
		}	
		else
		{	
			//otherwsise give the weapon and fill the ammo
			println("Giving weapon and max ammo for:"  +weapon);
			level.player giveWeapon(weapon);	
			level.player givemaxammo(weapon);			
		}	 
	}	
		
	primaryweapons = level.player GetWeaponsListPrimaries();	
	level.player switchtoweapon(primaryweapons[0]);
}


slamzoom_dof(wait_time, default_dof_flag)
{
	//TODO: remove when art sets up the default. Got these from _art:
	level.dofDefault= [];
	level.dofDefault[ "nearStart" ] = 0;
	level.dofDefault[ "nearEnd" ] = 1;
	level.dofDefault[ "farStart" ] = 8000;
	level.dofDefault[ "farEnd" ] = 10000;
	level.dofDefault[ "nearBlur" ] = 6;
	level.dofDefault[ "farBlur" ] = 0;
		
	sz_dof = [];
	sz_dof[ "nearStart" ] = 24;
	sz_dof[ "nearEnd" ] = 15;
	sz_dof[ "nearBlur" ] = 4;
	sz_dof[ "farStart" ] = 140;
	sz_dof[ "farEnd" ] = 100;
	sz_dof[ "farBlur" ] = 4;

	start = level.dofDefault;
	
	blend_dof( start, sz_dof, wait_time +.2 );
	flag_wait(default_dof_flag);
	blend_dof( sz_dof, start, .10 );

}	
	

setup_HVT_guard()
{
	
	//SETUP AS HVT GUARD HERE:	
	level.guard = level.bishop; //GRINCH
	//level.guard disable_ai_color();
	wait(5);
	level.guard clear_force_color();

	level.guard.goalradius = 10;
	level.guard.ignoresuppression = 1;
	
	//send to guard node by HVT. Move up as color trigs are hit. 
	node = getnode 	("hvt_guard_start", "targetname");
	level.guard setgoalnode(node );
	level.guard.ignoreall = 1;
	level.guard.ignoreme = 1;
	level.guard set_forcegoal();
	//level.guard waittill ("goal");
	//iprintlnbold( "Guard at goal" );
	
	
	//MOVE HVT TO BUS
	flag_wait ("player_past_bus");
	node = getent ("hvt_bus", "targetname");
	
	//"Movin up cover me!!!!"
	level.guard delaythread(5, ::play_sound_on_entity, "ac130_rno_movinup" );
	if( cointoss() )
	{
		//gotcha covered!
		level.bishop delaythread(6.5, ::play_sound_on_entity, "ac130_trk_gotchacovered" );   
	}	
	
	level.guard maps\_carry_ai::move_president_to_node( level.makarov_number_2, node );
	//go to cover node at bus after putting down HVT
	cover_hvt_node = getnode ("hvt_guard_bus", "script_noteworthy");
	level.guard setgoalnode (cover_hvt_node);
	level.guard.ignoreall = 0;
	
	//MOVE HVT TO CAR
	flag_wait ("bridge_squad_to_pos4");
	node = getent ("hvt_car", "targetname");
	//"Movin up cover me!!!!"
	level.guard delaythread(5, ::play_sound_on_entity, "ac130_rno_movinup" );
	if( cointoss() )
	{
		//gotcha covered!
		level.bishop delaythread(6.5, ::play_sound_on_entity, "ac130_trk_gotchacovered" );   
	}
	level.guard maps\_carry_ai::move_president_to_node( level.makarov_number_2, node );
	//go to cover node
	cover_hvt_node = getnode ("hvt_guard_car", "script_noteworthy");
	level.guard setgoalnode (cover_hvt_node);
	
	//MOVE HVT TO ALAMO
	flag_wait ("squad_at_final_pos");
	node = getent ("hvt_second_bus", "targetname");
	
	//"Movin up cover me!!!!"
	level.guard delaythread(5, ::play_sound_on_entity, "ac130_rno_movinup" );
	if( cointoss() )
	{
		//gotcha covered!
		level.bishop delaythread(6.5, ::play_sound_on_entity, "ac130_trk_gotchacovered" );   
	}
	level.guard maps\_carry_ai::move_president_to_node( level.makarov_number_2, node );
	//go to cover node 
	cover_hvt_node = getnode ("hvt_guard_second_bus", "script_noteworthy");
	level.guard setgoalnode (cover_hvt_node);
	//level.guard  play_sound_on_entity( "ac130_rno_worthit" );
	//level.sandman  thread play_sound_on_entity( "ac130_snd_keepvolk" );

}	
	
spawn_c130_above_bridge(spot, target_origin)
{
	//spawns c130 above bridge after player slamzooms, then shoots the tank the player shot it
	level.player endon("death");
	
	//spawns c130 above the bridge after player slamzooms. Attaches to node closest to where the player slamzooms from
	nodes = getvehiclenodearray ("c130_nodes", "script_noteworthy");
	start_node = getClosest( spot, nodes );
	bridge_c130 = spawnvehicle ("vehicle_ac130_low", "bridge_c130", "c130", start_node.origin, start_node.angles);
	wait(.10);
	
	//bridge_c130 AttachPath (start_node);
	bridge_c130 StartPath (start_node);
	bridge_c130 vehicle_setspeed (35, 34, 1);
	
	//so air-support strobe will fire from this vehicle
	level.air_support_aircraft = bridge_c130;
	
	//level thread magic_bullets_at_hummer();
	
	//C130 fires at tank
	for(i=0; i < 2; i++)
	{		
		//num = randomintrange(50, 150);
		//offset = (num, num, 0);	
		magicbullet ("ac130_40mm_air_support_strobe", level.air_support_aircraft.origin, target_origin);
		//earthquake(.4, .35, level.player.origin, 100);
		wait(.05);
	}	
	
	projectile = magicbullet ("ac130_105mm_alt2", level.air_support_aircraft.origin, target_origin);
	projectile waittill ("death");
	earthquake(.7, .6, level.player.origin, 300);
	level.player playrumblelooponentity ("damage_heavy");
	level.player delaycall (1.5, ::stoprumble, "damage_heavy" );


	flag_wait ("squad_at_final_pos");
	
	wait(15);
	
	//enemy trucks and choppers here
	level thread attack_choppers();
	bridge_c130 thread c130_attacks_choppers();
	 
	music_stop(4);
	delaythread( 4.5, ::musicplaywrapper, "paris_ac130_defend_bridge_mx");
	 
	
}	

magic_bullets_at_hummer()
{
	wait(2);
	start = getstruct("hummer_shoot_start", "targetname");
	end = getstruct("hummer_shoot_end", "targetname");
	
	for(i=0; i < 10; i++)
	{		
		num = randomintrange(5, 10);
		offset = (num, num, num);	
		magicbullet ("ak47_ac130", start.origin, end.origin );
		//thread draw_line_for_time( start.origin, end.origin, 1, 0, 0, 1 );
		wait( randomfloatrange(.05, .25) );
	}

}

	
final_bridge_vehicles()
{
	final_bridge_vehicles = getentarray("final_bridge_vehicles", "targetname");
	array_thread(final_bridge_vehicles, ::add_spawn_function, ::final_bridge_vehicle_logic );
	
	flag_set("final_vehicles_in");
	foreach(vehicle in final_bridge_vehicles)
	{
		enemy_vehicle = vehicle thread spawn_vehicle_and_gopath();
		wait(.15);
	}	
	
}	

final_bridge_vehicle_logic()
{
	//self = tank or btr 
	self.ignore_death_fx = 1;
	if(self.classname == "script_vehicle_t72_tank")
	{
		self thread final_tank_attack_logic();
	}
	else 
	{
		self thread btr_attack_logic();
	}	
	
	flag_wait("bridge_bombed");
	spot = self.origin;
	wait(  randomfloatrange(2, 4) );
	if(isAlive(self))
	{
		self dodamage(self.health + 100000, self.origin);
	}		
	
}	

final_tank_attack_logic()
{
	self endon ("death");
	self mgoff();
	guys = level.delta;
	wait( randomint(5) );//offset to prevent all shooting at once
	while(1)
	{	
		chance = randomint(100);
		offset = randomintrange (250, 300);		
		if (chance < 75) //would rather shoot at delta, the FX blocks players read
		{		
			guys = array_removeundefined(guys); 
			guy = random(guys);		
			self SetTurretTargetVec (guy.origin +(offset, offset, 0) );		
			wait (1.5);	
			self FireWeapon();		
		}	
		else
		{	
			self SetTurretTargetVec (level.player.origin +(offset, offset, 0) );		
			wait (1.5);	
			self FireWeapon();	
		}
		wait( randomintrange(9, 15) );
	}	

}

btr_attack_logic()
{
	self endon ("death");	
	self mgoff();
	wait( randomint(5) );//offset to prevent all shooting at once
	guys = level.delta;
	while(1)
	{		
		num = randomintrange (100, 150);
		self SetTurretTargetVec(level.player.origin + (num, num, num) );
		wait(randomfloatrange(1, 2.5));	
		self fire_at_target();
		
		wait(.4);
		guys = array_removeundefined(guys); 
		guy = random(guys);	
		self SetTurretTargetVec( guy.origin + (num, num, num) );
		wait(randomfloatrange(1, 2.5));	
		self fire_at_target();
		wait(1);		
	}	

}

fire_at_target()
{
	self endon ("death");
	burstsize = RandomIntRange( 2, 15 );
	fireTime = 0.1;
	for ( i = 0; i < burstsize; i++ )
	{
		self FireWeapon();
		wait fireTime;
	}
}
	
air_support_strobe_vo()
{	
	//self = player	
	self endon ("death");
	
	while( isAlive(self) )
	{
		self ent_flag_wait("flag_strobe_ready");
		
		if( cointoss() )
		{
			//"Metal Zero One, mark targets with smoke and we'll give you some breathing room."
			radio_dialogue ( "ac130_plt_giveyouroom" );	
		}
		else
		{	
			//Established overhead. ready for targets
			radio_dialogue("ac130_plt_readyfortargets" );
		}		
		
		level waittill ("air_support_strobe_thrown");
		wait(5); //time for flag to clear		
	}		
}	


c130_attack_logic()
{
	//self = c130 
	while(!flag("squad_at_final_pos") )
	{					
		axis = getaiarray ("axis");
		if(axis.size == 0)
		{
			continue;
		}	
		guy = random(axis);		
		dist = Maps\_utility_chetan::distance_2d_squared(guy.origin, level.sandman.origin);
		{
			if(dist > 975*975)
			{	 
		  	  level notify ("bridge_c130_shot");//cues VO informing player of c130 attacking	  		
		  	  if(!isAlive(guy))	  	  		 	  
		  	  {
		  	  	continue;
		  	  }	
  	 		  self thread c130_attack(guy.origin, randomintrange (2,3) );	  
  	 		  level waittill_chopper_arrives_or_timeout();
  	 		}
  	 	}
  	 wait(.05);			  	 	  
	}  
} 

c130_attacks_choppers()
{	
	level flag_wait_or_timeout("crash_chopper_unloading", 15);
	wait(7); //let guys unload
	chopper1 = get_vehicle ("bridge_crash_chopper", "script_noteworthy");	

	if( isdefined (chopper1) ) 
	{
		chopper1 thread crash_notify();
	}
	
	chopper2 = get_vehicle ("bridge_crash_chopper2", "script_noteworthy");	
	
	wait(3);
	if( isdefined (chopper1) ) 
	{
		if(isAlive (chopper1) )
		{
			spot = chopper1.origin;	 
			self thread c130_attack(spot, randomintrange (5,8) );			
			wait(3);
			if(isAlive(chopper1))
			{
				//chopper1 notify ("death");
				chopper1 dodamage(chopper1.health + 100000, chopper1.origin);
			}
		}	
	}		

	if(isdefined(chopper2) )
	{
		if( isAlive(chopper2) )
		{
			spot = chopper2.origin;	
			self thread c130_attack(spot, randomintrange (5,8) );				
			wait(3);
			if(isDefined(chopper2) &&  isAlive(chopper2))
			{
				//chopper2 notify ("death");	
				//chopper2 thread chopper_crash_cowbell();
				chopper2 dodamage(chopper2.health + 100000, chopper2.origin);
				playfx(level._effect[ "FX_mi17_air_explosion" ], chopper2.origin);
				level thread play_sound_in_space("mi17_helicopter_crash_close", spot);
				level.player playrumblelooponentity ("damage_heavy");
				earthquake(.5, .5, level.player.origin, 1000);
				wait(1);
				level.player stoprumble("damage_heavy");
			}	
		}	
	}	
	
	flag_clear ("squad_at_final_pos");	
	flag_set ("both_choppers_down");
	
	
}

//opening music: dc_emp_bunker
c130_kill_remaining_baddies()
{
	//self = c130
	baddies = getaiarray("axis");
	
	if(isdefined(level.defend_btr))
	{
		baddies = add_to_array(baddies, level.defend_btr);
	}	
	foreach(soon_to_be_dead_man in baddies)
	{
		if(isalive(soon_to_be_dead_man))
		{
			spot = soon_to_be_dead_man.origin;
			self thread c130_end_attack_custom(spot, randomintrange (1, 2) );	
			wait(1.5);
			if(isalive(soon_to_be_dead_man))
			{
				soon_to_be_dead_man die();
				wait(3);			
			}
		}
		else
		{
			continue;
		}			
	}		
}	

crash_notify()
{
	//self = crashing chopper
	self waittill ("crash_done");
	flag_set ("chopper_crashed_on_bridge");
	level.player playrumblelooponentity ("damage_heavy");
	earthquake(.2, .5, level.player.origin, 1000);
	wait(1);
	level.player stoprumble("damage_heavy");
}	

chopper_crash_cowbell()
{
	self waittill ("crash_done");
	level.player playrumblelooponentity ("damage_heavy");
	earthquake(.2, .5, level.player.origin, 1000);
	wait(1);
	level.player stoprumble("damage_heavy");
}	

waittill_chopper_arrives_or_timeout()
{
	//self = level
	//this is just an interuptable timer for the c130 between attacks. The flag "squad_at_final_pos" will interupt it. 
	times_up = randomintrange (25, 30);
	time = 0;
	while(1)
	{
		if(flag("squad_at_final_pos"))
		{
			return;
		}		
	wait(1);
	time++;	
		if(time >= times_up)
		{
			return;
		}
	}				
		
}	

c130_end_attack_custom(target_origin, shot_amount)
{
	//self = c130
	if(!isDefined(target_origin))
	{
		println("target origin not defined: c130 not shooting");
		return;
	}
	self thread c130_fires_25(target_origin, 5);
	
	for (i = 0; i < shot_amount; i++ )
	{
		offset = randomintrange (50,70);
		bullet = magicbullet ("ac130_40mm_air_support_strobe", self.origin, target_origin  + (offset,offset,0));
		wait(.4);
		earthquake(.2, .15, level.player.origin, 100);
		level.player playrumblelooponentity  ("damage_light");
		wait(.5);
		level.player stoprumble  ("damage_light");
		wait (randomfloatrange(.2, 1.5) );
	}
	level notify ("c130_done_shooting");
}	


c130_attack(target_origin, shot_amount)
{
	//self = c130
	level endon ("squad_at_final_pos");
		
	self thread c130_fires_25(target_origin, 15);
	
	for (i = 0; i < shot_amount; i++ )
	{
		offset = randomintrange (50,70);
		bullet = magicbullet ("ac130_40mm_air_support_strobe", self.origin, target_origin  + (offset,offset,0));
		bullet waittill ("death");
		//spot = bullet.origin;
		earthquake(.1, .2, level.player.origin, 450);
		level.player playrumblelooponentity  ("damage_light");
		wait(.5);
		level.player stoprumble  ("damage_light");
		wait (.2) ;
	}
	level notify ("c130_done_shooting");
}		


c130_fires_25(target_origin, shot_amount)
{
	//self = c130 
	for (i = 0; i < shot_amount; i++ )
	{
		offset = randomintrange (50,70);
		magicbullet ("ac130_25mm_alt2", self.origin, target_origin  + (offset,offset,offset));
		wait (.10);
	}
	
}	

arm_player(nades, e3)
{
	main_weapon = undefined;
	level.player takeallweapons();
	level.player setViewmodel( "viewhands_delta" );
	if(isdefined(e3))
	{
		main_weapon = "m4m203_reflex";	
	}
	else
	{	
		main_weapon = "m4m203_reflex";		
	}	
	//level.player giveMaxAmmo( "m4m203_acog" );
	level.player giveWeapon( main_weapon );
	level.player giveWeapon( "usp_no_knife" );
	level.player givemaxammo( "usp_no_knife" );
	
	//give nades with ammo count zero so player can pickup more
	level.player giveWeapon( "fraggrenade" );
	level.player SetWeaponAmmoStock( "fraggrenade", 0 );
	
	if(isdefined(nades))
	{	
		level.player giveMaxAmmo( "fraggrenade" );
		level.player giveWeapon ( "flash_grenade" );	
		level.player setOffhandSecondaryClass( "flash" );	
	}

	level.player switchtoWeapon( main_weapon );	

}	

set_203_ammo(count)
{
	//only works with m4m203_reflex for now		
	alt_weapon = weaponaltweaponname( "m4m203_reflex" );
	if ( alt_weapon != "none" )
	{
		//if 0, we have to set clip and stock to 0
		if(count == 0)
		{
			level.player setweaponammoclip( alt_weapon, 0 );
			level.player setweaponammostock( alt_weapon, 0);
		}	
		else
		{	
			//	1 in the clip (0 stock so we can pickup more)	
			level.player setweaponammoclip( alt_weapon, 1 );
			level.player setweaponammostock( alt_weapon, 0);
			if(count > 1)
			{
				//remaining in the stock
				level.player setweaponammostock( alt_weapon, count -1);
			}	
		}
	}	
}	

humvee_takedown()
{	
	hummer_final_pos = getent ("hummer_final_pos", "targetname");
	hummer_final_pos hide();
	
	flag_wait("bridge_tanks_spawned");
	//tanks = get_vehicle_array ("bridge_tanks", "script_noteworthy");
	all_vehicles = getvehiclearray();
	tanks = [];
	//beefing up tank health so player cannot kill them until its the objective
	foreach(vehicle in all_vehicles)
	{
		if(vehicle.classname == "script_vehicle_t72_tank")
		{
			vehicle.orig_health = vehicle.health; 
			vehicle.health = 99999;
			tanks[tanks.size] = vehicle;
			vehicle thread vehicle_god_until_flag("player_shot_tank");
			//iprintlnbold("adding " +vehicle.targetname+ " to TANKS array");
		}
	}		
	
	node = getvehiclenode ("humvee_bridge_arrive", "script_noteworthy");
	
	level thread hummer_crash(node);
	
	node waittill ("trigger", who);
	
	flag_set ("humvee_at_bridge");
	
	who thread hide_me_and_riders_til_unload();

	spot = getstruct ("player_bridge_start", "targetname");
	tank = get_vehicle ("bridge_tank1", "targetname");
	
	tank SetTurretTargetVec (spot.origin);
	wait (1);
	start = tank gettagorigin("tag_flash");
	bullet = magicbullet("t72_125mm", start, spot.origin );	
	
	//array_thread (tanks, ::did_player_shoot_me);
	flag_wait ("humvee_crashed");
		
	Objective_Add( obj( "OBJ_destroy_tanks" ), "current", &"PARIS_AC130_OBJ_BRIDGE_DESTROY_TANK" );
	
	tanks = array_removeundefined(tanks);
	
	//restoring health
	foreach(tank in tanks)
	{
		if ( !IsDefined( tank ) )
			continue;
		tank.health = tank.orig_health;
		tank.godmode = false;
		vehicle_scripts\_ac130::hud_add_targets( [tank]  );	
	}	
	
	//FAIL after 45 secs
	level thread mission_fail_timer(45, "player_shot_tank" );
	
	array_thread (tanks, ::did_player_shoot_me);

}	

flush_current_targets()
{	
	current_targets = target_getarray();
	{
		foreach( target in current_targets )
		{
			target_remove( target );
		}
	}
}

mission_fail_timer(time, success_flag)
{
	level endon (success_flag);
	
	wait(time);
	
	//not needed but just being safe
	if(!flag(success_flag))
	{
		maps\_utility_chetan::_mission_failed( "@PARIS_AC130_MISSION_FAIL_HVI_KILLED" );
	}	
	
}	

#using_animtree( "vehicles" );
hummer_crash(vehicle_node)
{
	hummer_final_pos = getent ("hummer_final_pos", "targetname");
	
	spot = getstruct ("player_bridge_start", "targetname");
	anim_node = spawn ("script_origin", spot.origin);
	anim_node.angles = spot.angles;
	
	stunt_hummer = spawn ("script_model", vehicle_node.origin);
	stunt_hummer setmodel ("vehicle_hummer");
	stunt_hummer.animname =  "hummer";
	stunt_hummer.team = "allies"; 
	stunt_hummer maps\_anim::setanimtree();
	
	starting_pos  = getstartorigin( anim_node.origin, anim_node.angles, %paris_ac130_bridge_humvee_crash_car_01);
	starting_angles  = getstartangles( anim_node.origin, anim_node.angles, %paris_ac130_bridge_humvee_crash_car_01);
	
	stunt_hummer.origin = starting_pos;
	stunt_hummer.angles = starting_angles;
	stunt_hummer hide();
	
	//PIP cam on dash of model
	spot = get_world_relative_offset( stunt_hummer.origin, stunt_hummer.angles,  ( 8, 36, 66 ) ) ; //-63x
	ent = spawn ( "script_origin", spot );
	ent.angles = stunt_hummer.angles +(0, 328, 0);
	ent.targetname = "stunt_vehicle_pip";
	ent linkto ( stunt_hummer, "" );
	
	flag_wait("humvee_at_bridge");

	//setup c130 diamond target and thermal, then show the new hummer
	stunt_hummer thermaldrawenable();
	vehicle_scripts\_ac130::hud_add_targets( [stunt_hummer]  );
	stunt_hummer show();
	
	level thread stunt_hummer_pip(ent);
		
	//play crash anim
	anim_node maps\_anim::anim_single_solo( stunt_hummer, "hummer_crash" );
	flag_set ("humvee_crashed");
	
	maps\paris_ac130_pip::ac130_pip_close();
	hummer_final_pos show();
	hummer_final_pos thermaldrawenable();
	
	ent delete();	
	stunt_hummer delete();
	anim_node delete();
	

}	

stunt_hummer_pip(ent)
{
	//turn off current pip in the script_vehicle, turn on again on this script_model
	maps\paris_ac130_pip::ac130_pip_close();
	wait(.05);
	maps\paris_ac130_pip::ac130_pip_init( ent, undefined, undefined, 65 );	
}

hide_me_and_riders_til_unload()
{
	//this is the script_vehicle that "crashes". A script_model does the crashing, this vehicle just parks at the crash finish and unloads. 
	self hide();
	self.health = 99999; 
	//remove the c130 targets on self and riders
	vehicle_scripts\_ac130::hud_remove_targets( [self] );
	vehicle_scripts\_ac130::hud_remove_targets( self.riders );
	foreach(guy in self.riders)
	{
		guy hide();
	}	

}

	
vehicle_god_until_flag(the_flag)
{
	level endon (the_flag);
	while(!flag(the_flag))
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags, weapon );
		self.health = self.health + amount;
	}
	
}		
		
			
did_player_shoot_me()
{
	//self = tanks!
	while(!flag("player_shot_tank"))
	{
		level.ac130player waittill ("missile_fire", projectile, weapon_name ); 
			
		projectileAngles = projectile.angles;
		projectileForward = VectorNormalize( AnglesToForward( projectileAngles ) );
		spot_array = BulletTrace( projectile.origin, projectile.origin + ( projectileForward* 15000 ), true, level.player );
		
		position = spot_array["position"]; //vector where player is shooting	
		//self thread draw_line_for_time( level.player.origin, position, 1, 0, 0, 5 );	
		range = 0;
		switch ( weapon_name )
		{
		  case "ac130_40mm_alt2":
		  	range = 450; 
		   	break;
		  case "ac130_105mm_alt2":
		    range = 450; //reducing to prevent 2 tanks in 1 shot
		    break;
		  case "ac130_25mm_alt2":
		    range = 450; //reducing to prevent 2 tanks in 1 shot
		    break;
		}	
		if ( Maps\_utility_chetan::distance_2d_squared( self.origin, position ) < Squared( range ) )			
		{
			if(weapon_name == "ac130_25mm_alt2")
			{
				display_weapon_hint();
				self.health = 50000;
				continue;
			}	
			//iprintlnbold ("player shot tank!");		
			self.health = 10000;
	    	level thread slam_zoom_custom(projectile, self, position);    	
	    	self waittill ("death");

			//iprintln ("deleting tank corpse");
			wait(.5);
			self.deathfx_ent delete();
			self delete(); 
					
			flag_set ("player_shot_tank"); //flag that starts slamzoom  	
		    break;
		}	
	}
}	

display_weapon_hint()
{
	display_hint("HINT_USE_40_OR_105");
}


hint_not_using_25()
{
	return flag( "FLAG_ac130_changed_weapons" );
}		

yellow_building_attacking()
{
	bullets = getstructarray("window_muzzle", "targetname");
	targets = getstructarray("hvt_window_targets", "script_noteworthy");
	level thread random_rpgs(bullets, targets);
	
	while(!flag("hvt_slamzoom_complete"))
	{
		shot_num = randomintrange(2,6);
		for(i= 0; i <shot_num; i++ )
		{
			spot = random(bullets);
			target = random(targets);
			magicbullet("ak47_ac130", spot.origin, target.origin);
			playfx( level._effect[ "FX_apache_hydra_rocket_flash" ], spot.origin);
			wait(.2);
		}
	  wait(randomfloatrange(.3, .6) );
	}

}	

random_rpgs(bullets, targets)
{
	while(!flag("hvt_slamzoom_complete"))
	{
	 spot = random(bullets);
	 target = random(targets);
	 magicbullet("rpg_straight_ac130", spot.origin, target.origin);	
	 wait(randomintrange(4,7 ) );
	}
	
}	


yellow_building_shoot_detection()
{
	trig = getent ("yellow_building_trig", "targetname");
	temp_ent = undefined;
	
	while(!flag("hvt_slamzoom_complete"))
	{	
		if ( IsDefined( temp_ent ) )
			temp_ent Delete();
		
		level.ac130player waittill ("missile_fire", projectile, weapon_name ); 
		projectileAngles = projectile.angles;
		projectileForward = VectorNormalize( AnglesToForward( projectileAngles ) );
		spot_array = BulletTrace( projectile.origin, projectile.origin + ( projectileForward* 15000 ), true, level.player );
		
		position = spot_array["position"]; //vector where player is shooting
		temp_ent = spawn ("script_origin", position);
		
		if( temp_ent istouching(trig) ) 
		{
			if(weapon_name == "ac130_25mm_alt2")
			{
				display_weapon_hint();
				continue;
			}			

			autosave_by_name("courtyard_slamzoom");	
			flag_set ("player_shot_yellow_building"); //flag that starts slamzoom
			level thread hvt_slam_zoom(projectile, position);		
			wait(1);
			//impact fx since the bullet is deleted	
			//level delaythread( 1.5, Maps\_fx::script_playfx, getfx("105_impact"), position );
			
			axis = getaiarray("axis");
			//kill axis within 1024 of blast (guys seem to be surviving)
			if(axis.size > 0)
			{
				foreach (guy in axis)
				{
					if ( Maps\_utility_chetan::distance_2d_squared( guy.origin, temp_ent.origin ) <= Squared( 1024 ) )
					{
						if ( IsDefined( guy.magic_bullet_shield ) && guy.magic_bullet_shield )
						{
							guy stop_magic_bullet_shield();
						}
	
						guy die();
					}
				}
			}	
			//temp_ent delete();			
		    break;
		}
	}
	
	if ( IsDefined( temp_ent ) )
		temp_ent Delete();
}		
	
yellow_building_destruction()
{	
	//initial setup: hide the damaged parts
	center_target = getstruct ("c130_target2", "targetname");
	center_pristine = getentarray ("courtyard_building_des_a_pristine", "targetname");
	center_damaged = getentarray ("courtyard_building_des_a_damage", "targetname");
	array_thread (center_damaged, ::hide_me);
	
	right_target = getstruct ("courtyard_building_des_b", "targetname");
	right_side_damaged = getentarray("courtyard_building_des_b_damage", "targetname");
	right_side_pristine = getentarray("courtyard_building_des_b_pristine", "targetname");
	array_thread (right_side_damaged, ::hide_me);
	
	left_target = getstruct ("c130_target1", "targetname");
	left_side_damaged = getentarray("courtyard_building_des_c_damage", "targetname");
	left_side_pristine = getentarray("courtyard_building_des_c_pristine", "targetname");
	array_thread (left_side_damaged, ::hide_me);
	
	source = getstruct ("c130_shoot", "targetname");
	
	flag_wait("player_shot_yellow_building");
	
	//shoot 3 more 105 shots from ac130 for player to see explode right after slamzoom
	wait(1.7);
	
	level thread do_magic_105_return_on_impact(source, right_target, right_side_pristine, right_side_damaged);
	wait(.3);	
	level thread do_magic_105_return_on_impact(source, center_target, center_pristine, center_damaged);
	wait(.3);
	level thread do_magic_105_return_on_impact(source, left_target, left_side_pristine, left_side_damaged);

}	

do_magic_105_return_on_impact(source_ent, target_ent, pristine_array, damaged_array)
{
	//projectile = magicbullet ("ac130_105mm", source_ent.origin, target_ent.origin);
	//projectile waittill ("death");
	
	//playing 105 impact fx instead of magicbulleting..
	level delaythread( .5, Maps\_fx::script_playfx, getfx("105_impact"), target_ent.origin);
	wait(.5);
	level thread play_sound_in_space("scn_ac130_ground_explo_building", target_ent.origin);
	wait(.2);
	
	array_thread (pristine_array, ::hide_me);
	array_thread (damaged_array, ::show_me);	
	return;
}	

hvt_slam_zoom(projectile, position)
{
	level.player enableinvulnerability();
	wait(.15); //save buffer	
	level.player freezeControls( true );
	
	level.player playrumblelooponentity ("damage_heavy");
	
	bridge_struct = getstruct ("player_hvt_zoom_end", "targetname");
	origin = bridge_struct.origin;

	ent = spawn( "script_model", level.player.origin);
	ent setmodel ("tag_origin");
	ent.angles = projectile.angles;
	
	thread slamzoom_clouds(ent);
	
	vehicle_scripts\_ac130::end_ac130(); 
	
	//level.player enableinvulnerability();
	level.player playerlinktoabsolute( ent, "tag_origin" );
	level.player thread play_sound_on_entity( "scn_ac130_slamzoom_redflags" );
	
	//delete the actual 105 bullet so it doesnt cause huge explosion in the initial read when we're done
	projectile delete();
	
	//move the the ent player is linked to instead of riding bullet
	ent moveto( position, 1);
	
	level.player viewkick(10, level.player.origin);
	earthquake(1, 1, ent.origin, 200);
	
	time = .5;
	level thread slamzoom_dof(time, "hvt_slamzoom_complete");
	wait(time);

	level.player VisionSetNakedForPlayer( "coup_sunblind", 1.3 );

	wait(.4);
	
	level.player thread play_sound_on_entity ("exp_ac130_105mm");
	
	//stop any existing VO
	radio_dialogue_stop();
	
	ent unlink();
	ent moveto ( bridge_struct.origin +(0,0,15), .10 ); //2446.3 41400.8 -12
	wait(.10);
	ent rotateto( bridge_struct.angles, .10); //0 277.739 0
	wait(.10);
	
	level.player unlink();
	level.player setplayerangles(bridge_struct.angles);
	level.player allowcrouch(true);
	level.player allowstand(true);
	level.player allowprone(true);
	level.player setstance( "prone" );
	level.player.ignoreme = 0;
	//level.player playerlinktoDelta( ent, "tag_origin", 0, 30, 30, 10, 5 );
	level.player freezeControls( false );
	level thread torque_player_speed(3);
	
	setsaveddvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "hud_showStance", 1 );
	SetSavedDvar("sm_SunSampleSizeNear", "0.25");
	SetSavedDvar("sm_SunShadowScale", "1.0");
	
	flag_set("hvt_slamzoom_complete");
	set_ambient("paris_ac130_courtyard_bldg");
	wait(.5);
	level.player thread vision_set_fog_changes ("paris_ac130_courtyard", .5);
	
	level thread hvt_slamzoom_fx();	
	wait(.05);//rumble wasnt stopping sometimes. Waiting a frame.
	level.player stoprumble("damage_heavy");
	musicstop();//stop temp music if still playing
	
	wait(1);
	//level.player freezeControls( false );
	if(level.start_point == "start_e3")
	{
		level arm_player( 1, 1 );
	}
	else
	{
		level arm_player();	
		level thread set_203_ammo(0);
	}
	
	level.player thread waterfx("FLAG_hvt_escape_hvt_captured", "step_run_plr_water");
	level thread hvt_courtyard_fx();
	//god mode buffer time
	wait(5);
	ent delete();
	//level.player enabledeathshield(false);
	level.player disableinvulnerability();

}


hvt_courtyard_fx()
{
	level thread spawn_looping_fx_delete_on_flag( ( 43698, 63372.7, 18575.7 ), ( 272.097, 345.44, 60.3363 ), "FX_b52_bomber_squadron_a", 25, "hvt_tank_destroyed");
	level thread spawn_looping_fx_delete_on_flag( ( 3051.71, 35473.2, 1325.11 ), ( 270, 0, 0 ), "FX_ambient_explosion_paris", 8, "hvt_tank_destroyed");
	level thread spawn_looping_fx_delete_on_flag( ( 1561.02, 35106.4, 1211.25 ), ( 270, 0, 0 ), "FX_ambient_explosion_paris", 8, "hvt_tank_destroyed");	
}

torque_player_speed(wait_time)
{	
	level.player setmovespeedscale(.2);
	wait(wait_time);
	level.player setmovespeedscale(.5);
	wait(wait_time);
	level.player setmovespeedscale(.7);
	wait(wait_time);
	level.player setmovespeedscale(1);	
}	

	

slamzoom_clouds(ent)
{
	fwd = AnglesToForward(ent.angles);
	_up = AnglesToUp(ent.angles);			
	front = (fwd) * (3000);
	two_hundred = ent.origin + front;
	
	front = (fwd) * (4500);
	four_hundred = ent.origin + front;

	ent1 = spawn_tag_origin_playFXontag(two_hundred, ent.angles, "FX_cloud_single");	
	ent2 = spawn_tag_origin_playFXontag(four_hundred, ent.angles, "FX_cloud_single");
	
	wait(4);
	
	StopFXOnTag(getfx("FX_cloud_single"), ent, "tag_origin");
	StopFXOnTag(getfx("FX_cloud_single"), ent, "tag_origin");
	ent1 delete();
	ent2 delete();
	
}	

spawn_tag_origin_playFXontag(origin, angles, fx_alias)
{
	temp_fx_ent = spawn("script_model", origin);
	temp_fx_ent.angles = angles;
	temp_fx_ent setmodel ("tag_origin");
	
	PlayFXOnTag( getfx(fx_alias), temp_fx_ent, "tag_origin");
	return temp_fx_ent;
}	

hvt_slamzoom_fx()
{

	level thread hvt_custom_wall_impacts("bullet_exit", "player_went_upstairs");
	level thread hvt_custom_wall_impacts("cover_impacts", "player_went_upstairs");
	//bullet_exit //cover_impacts
	
	debris_fall_small = getstruct ("debris_fall_small", "targetname");
	
	debris_fall_big = getstructarray ("debris_fall_big", "targetname");
	
	wait(.5);
	
	//playfx(level._effect[ "debris_explosion" ] , debris_fall_small.origin);
	playfx(level._effect[ "debris_fall_big" ] , debris_fall_small.origin);
	
	/*
	foreach(spot in debris_fall_big)
	{
		playfx( level._effect["debris_fall_big"], debris_fall_small.origin);
		wait(.10);
	}	
	
	playfx( level._effect["debris_fall_small"], debris_fall_small.origin);
	*/
}	

slamout_static(start_delay)
{
	//a  fullscreen snap of pip mode with staticon 
	if(isDefined(start_delay))
	{
		wait(start_delay);
	}	

	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "overlay_static", 640, 480 );//"black", "white"
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	
	//starts strong
	overlay.alpha = .4;
	//out to 0 
	overlay fadeOverTime( .2 );
	overlay.alpha = 0;
	wait(.2);
	//back in 
	overlay fadeOverTime( .2 );
	overlay.alpha = .9;
	wait(.4);
	
	//back out
	overlay fadeOverTime( .2 );
	overlay.alpha = 0;
	
	
	wait(1);
	//out
	overlay destroy();
	
}	


hvt_custom_wall_impacts(struct_targetname, flag_ender)
{
	//requires struct_array by targetname and ender flag. 
	//plays impact fx on each struct 
	wait(randomfloatrange(.5, 1.3) );
	
	spots = getstructarray(struct_targetname, "targetname");
	
	while(!flag(flag_ender) )
	{
		foreach (spot in spots)
		{
			playfx(level._effect["wood_impact"], spot.origin);
			wait( randomfloatrange(.15,.6) );
		}		
		wait(randomfloatrange(1, 3.5) );
	}	
			
}	


tank_attack()
{		
	self endon ("death");
	if ( !IsAlive( self ) )
	{
		return;
	}	
	flag_wait("slamzoom_complete");
	wait 9; //wait for Sandman to tell player to get the Javelin
	self.mgturret[0].accuarcy = 0.25; //default is 0.38
	while(1)
	{
		//returns if player is in the safe zone, otherwise does special attacks
		check_if_player_is_close();				
		chance = randomint(100);
		offset = randomintrange (70,95);		
		if (chance < 25)
		{		
			//iprintln ("tank firing at AI");
			//start = self gettagorigin("tag_flash");
			guy = random (level.delta);		
			self SetTurretTargetVec (guy.origin +(offset, offset, 0) );
			//wait (1.6);		
			wait (1.5);	
			self FireWeapon();
			//magicbullet("t72_125mm", start, guy.origin +(offset, offset, 0));				
		}	
		else
		{	
			//iprintln ("tank firing at player");
			//start = self gettagorigin("tag_flash");
			self SetTurretTargetVec (level.player.origin +(offset, offset, 0) );		
			wait (1.5);	
			self FireWeapon();	
			//magicbullet("t72_125mm", start, level.player.origin +(offset, offset, 0) );	
		}
		wait(randomintrange(3,5) );
	}
}	

bridge_tank_shoot_until_slamzoom()
{
	//self = bridge tanks before player slamzooms
	flag_wait("humvee_at_bridge");
	level endon ("player_shot_tank");
	self endon("death");
	offset = randomintrange (100,200);	
	//fwd = AnglesToForward(self.angles);
	//wait( randomfloatrange(1.4, 5) ); //offset them from all shooting together
		
	while(1)
	{		
		guy = random (level.delta);		
		self SetTurretTargetVec (guy.origin +(offset, offset, 0) );
		wait( randomfloatrange(2.5, 4.3) );
		//self FireWeapon();
		start = self gettagorigin("tag_flash");
		//playfx( getfx("FX_t72_muzzleflash"), start, fwd);
		bullet = magicbullet("t72_125mm", start, guy.origin +(offset, offset, 0));		
	}	
	
	
	
}	

check_if_player_is_close()
{
	//kills player if too close to tanks
	//self = tank
	self endon ("death");
	level endon ("both_tanks_dead");
	
	if(!level.player_close_to_tanks)
	{
		return;
	}
	else
	{
		//WARNING SHOT
		start = self gettagorigin("tag_flash");
		self SetTurretTargetVec (level.player.origin +(10, 10, 0) );		
		wait (1.5);	
		magicbullet("t72_125mm", start, level.player.origin);			
		self FireWeapon();		
		//warning VO?	
		
		//give player chance to get back
		wait(5);
		if(!level.player_close_to_tanks)
		{
			return;
		}
		//player still close...kill kill kill
		else
		{
			//killing player
			//iprintlnbold("killing player");
			level.ground_ref_ent = spawn( "script_model", (0,0,0) );
			end = level.player geteye();
			start = self gettagorigin("tag_flash");		
			death = magicbullet("t72_125mm", start, end);
			//death waittill ("death"); //lol		
			wait(.15);
			earthquake(1, 1, level.player.origin, 8000);
			if(isAlive(level.player))
			{
				level.player dodamage (level.player.health +200, start, self);
			}	
		}
	}	
}			
			
			
tank_death_quote()
{
	level endon ("both_tanks_dead");	
	level.player waittill ( "death", attacker, type, weaponName );	
	if( isDefined (attacker) ) 
	{
		if( (attacker.classname  == "script_vehicle_t72_tank") || (attacker.classname  == "worldspawn") )
		{
			//iprintlnbold("TANK KILLED PLAYER");			
			level notify( "new_quote_string" );
			setdvar( "ui_deadquote", &"PARIS_AC130_OBIT_CUSTOM_TANK_DEATH" );				
		}
	}
	if(isDefined(weaponName))
	{
		if( (weaponName == "t72_turret") || (weaponName == "f15_missile") )
		{
			//iprintlnbold("TANK KILLED PLAYER");			
			level notify( "new_quote_string" );
			setdvar( "ui_deadquote", &"PARIS_AC130_OBIT_CUSTOM_TANK_DEATH" );				
		}
	}
}		

tank_danger_zone()
{
	//checks if player is touching a large trig starting
	level.player_close_to_tanks = 0;
	level endon ("both_tanks_dead");
	trig = getent ("tank_danger_zone", 	"targetname");
	
	while(1)
	{
		if(level.player istouching(trig))
		{
			level.player_close_to_tanks = 1;
		}
		else		
		{
			level.player_close_to_tanks = 0;	
		}
		wait(.15);
	}	
		
}			
	
delete_me()
{
	if(isdefined (self) )
	{
		self delete();
	}	
}



make_me_javelin_target()
{	
	flag_wait ("player_has_javelin");	
		
	if(isalive(self))
	{
		OFFSET = ( 0, 0, 60 );
		target_set( self, OFFSET );
		target_setAttackMode( self, "top" );
		target_setJavelinOnly( self, true );			
	}		
	
	self thread tank_death_monitor();
}

make_me_a_defend_javelin_target()
{	
	if(isalive(self))
	{
		OFFSET = ( 0, 0, 60 );
		target_set( self, OFFSET );
		target_setAttackMode( self, "top" );
		target_setJavelinOnly( self, true );				
	}	
	self waittill ("death");
	target_remove(self);
	
}



only_die_by_jav()
{
	//tanks are dying from c130 fire
	self.health = 90000;
	
	while(1)
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags, weapon );
		//if shot by jav:
		if( attacker == level.player && weapon == "javelin")
		{
			//tank die!
			self die();
			earthquake(.2, .5, level.player.origin, 1000);
			level.player playrumblelooponentity  ("damage_light");
			wait(.5);
			level.player stoprumble  ("damage_light");					
		}
		
		//if not shot by jav, give health
		else
		{
			self.health = 90000;
		}
	}	
			
}		

tank_death_monitor()
{	
	self waittill ("death");
	level notify ("tank_death");
	Target_Remove( self);	
	
	wait(.7);
	self.deathfx_ent delete();
	self delete(); 		
	
}		


c130_inform_player_attacking()
{
	
	level.num = 0;
	while(1)
	{
		level waittill ("air_support_strobe_thrown");
		wait(3.5);
		
		if(level.num == 0)
		{
			radio_dialogue ("ac130_plt_targetsahead");
			level.num ++;
		}
		else
		{	  
	 		radio_dialogue ("ac130_plt_engagingtarget");
	 		level.num = 0;
	 	} 	

	}
}			
 
		
 	   
javelin_equipped()
{
	weapon = level.player getCurrentWeapon();
	if ( IsSubStr( weapon, "javelin" ) )
		return true;
	else
		return false;
}

fade_out_in(fade_color, time, time_out )
{
	if ( !isdefined( time_out ) )
	{
		time_out = time * 0.5;
		time = time_out;
	}
	
	//fade out/fade in on flag
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( fade_color, 640, 480 );//"black", "white"
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	overlay.sort = -1;
	overlay fadeOverTime( time );
	overlay.alpha = 1;
	
	wait( time );

	
	wait( time_out );
	
	overlay fadeOverTime( time_out );
	overlay.alpha = 0;	
	wait(1);

	overlay destroy();

}	

fade_in_on_flag(fade_color, flag_ender, optional_delay)
{
	//fade out/fade in on flag
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( fade_color, 640, 480 );//"black", "white"
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	overlay.alpha = 1;
	

	
	flag_wait(flag_ender);
	
	if(isDefined(optional_delay))
	{
		wait(optional_delay);
	}	
	
	overlay fadeOverTime( .5);
	overlay.alpha = 0;	
	wait(1);

	overlay destroy();

}	


fade_out(fade_color, time)
{
	//fade out/fade in on flag
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( fade_color, 640, 480 );//"black", "white"
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;

	overlay fadeOverTime(time);
	overlay.alpha = 1;

}


attack_choppers()
{		

	flag_set( "attack_choppers_spawned" );
	bridge_attack_chopper1 = spawn_vehicle_from_targetname_and_drive("bridge_attack_chopper1");
	bridge_attack_chopper2 = spawn_vehicle_from_targetname_and_drive("bridge_attack_chopper2");
	wait(.20);
	bridge_attack_chopper1 thread chopper_jav_target();
	bridge_attack_chopper2 thread chopper_jav_target();
	wait(.10);
	array_thread (bridge_attack_chopper1.riders, ::ignore_til_unloaded);
	array_thread (bridge_attack_chopper2.riders, ::ignore_til_unloaded);
	
	jav_crash1 = getent ("jav_crash1", "script_noteworthy");
	bridge_attack_chopper1.perferred_crash_location = jav_crash1;	
	
	jav_crash2 = getent ("jav_crash2", "script_noteworthy");
	bridge_attack_chopper2.perferred_crash_location = jav_crash2;
		
	crash_node = getent ("crash_chopper_unload", "script_noteworthy");
	crash_node waittill ("trigger");
	
	flag_set ("crash_chopper_unloading");
	
	crash_on_bridge = getent ("crash_on_bridge", "script_noteworthy");
	bridge_attack_chopper1.perferred_crash_location = crash_on_bridge;
	
	crash_into_wall = getent ("crash_into_wall", "script_noteworthy");
	bridge_attack_chopper2.perferred_crash_location = crash_into_wall;	
	
}	

ignore_til_unloaded()
{
	self endon ("death");
	self.ignoreme = 1;
	self waittill ("unload");
	self.ignoreme = 0;
}	

chopper_jav_target()
{
	//self waittill ("reached_end_node");
	offset = (0,0,-50);
	self.preferred_crash_style = 0;
	target_set( self, offset );
	//target_setAttackMode( self, "top" );
	target_setJavelinOnly( self, true );		
}		

	

crash_chopper_assets()
{
	clips = getentarray ("crash_clip", "targetname");
	assets = getentarray ("crash_assets", "script_noteworthy");
	
	foreach (asset in assets)
	{
		asset hide();
	}
	foreach (clip in clips)
	{
		clip notsolid();
	}

	flag_wait ("chopper_crashed_on_bridge");	
	
	foreach (asset in assets)
	{
		asset show();
	}
	foreach (clip in clips)
	{
		clip solid();
	}
	
}	

bridge_collapse_setup()
{	
	//this is strictly to set up the skipto 
	level.using_collapse_skipto = 1;
	level.squad = [];
	init_slamzoom_flags();
	bridge_radio();
	bridge_anims();
	level thread final_bridge_vehicles();
	maps\_carry_ai::initCarry();
	effiel_anims();
	
	level.chase_main_vehicle thread force_skipto_unload();
	level.chase_second_vehicle thread force_skipto_unload();	
	
	level thread move_squad_to_skitpo_pos();

	spot = getstruct ("bridge_collapse_player_start", "targetname");
	vehicle_scripts\_ac130::end_ac130(); 
	
	SetSavedDvar("sm_SunSampleSizeNear", "0.25");
	SetSavedDvar("sm_SunShadowScale", "1.0");
	level.player setorigin( spot.origin );
	
	arm_player(1);
	flag_set ("tower_final_start");
	iprintlnbold("PLEASE DO NOT USE THIS SKIPTO. IT IS STRICTLY FOR TESTING PURPOSES.");
	
	baddies = getaiarray("axis");
	array_thread(baddies, ::delete_me);
	
	tanks = getentarray ("bridge_tanks", "script_noteworthy");
	array_thread(tanks, ::delete_me);
		
	//crashed chopper debris removal:
	clips = getentarray ("crash_clip", "targetname");
	assets = getentarray ("crash_assets", "script_noteworthy");
	
	foreach (asset in assets)
	{
		asset hide();
	}
	foreach (clip in clips)
	{
		clip notsolid();
	}
	sandman_drops_smoke();
	level thread pickup_choppers();
	level thread spawn_blackhawks();
	flag_set ("slamzoom_complete");
	flag_set ("bombing_run");
	musicplaywrapper( "paris_ac130_defend_bridge_mx");
	
	wait(5);
	level thread epic_jets_timing();
	spawners = getentarray ("chopper_fodder", "targetname");
	array_thread(spawners, ::add_spawn_function, ::chopper_fodder_logic);
	wait(.10);
	maps\_spawner::flood_spawner_scripted( spawners );
	
}

force_skipto_unload()	
{	
	//self = 1 of 2 humvees with squad
	self waittill ("reached_end_node");
	guys = thread vehicle_unload();
	foreach(guy in guys)
	{
		guy.ignoreall = 1;
		if(guy == level.frost)
		{
			guy thread bridge_frost_setup();
			continue;
		}	
		else
		{
			level.squad = add_to_array (level.squad, guy);
		}	
	}	
	
	//level thread move_squad_to_skitpo_pos();
}	
	
move_squad_to_skitpo_pos()
{
	wait(5);//unload buffer
	spots = getstructarray ("bridge_collapse_ai_start", "targetname");
	
	//waits til unload is complete
	while(level.squad.size < 7)
	{	
		wait(.05);
	}	
	
	guys = level.squad;
		
	foreach(spot in spots)
	{		
		//spot.angles = (0,0,0);
		guy = random(guys);
		guy forceteleport(spot.origin, spot.angles);
		guys = array_remove(guys, guy);
	
		if(guy == level.makarov_number_2)
		{	
			//do HVT stuff here
			continue;
		}
		
		//guy set_force_color ("r");
		//guy.ignoreall = 0;
		//guy.ignoreme = 0;
	}	

	flag_set ("squad_at_skipto_pos");
	//activate_trigger_with_targetname("squad_pos5");
}

epic_jets_timing()
{
	//level._effect[ "plane_bomb_explosion1" ]			 = loadfx( "explosions/airlift_explosion_large" );
	level._effect[ "plane_bomb_explosion2" ]			 = loadfx( "explosions/fuel_storage" );
	sonic_boom_nodes = getvehiclenodearray("sonic_boom", "script_noteworthy");
	array_thread( sonic_boom_nodes, vehicle_scripts\_f15::plane_sound_node);
	
	flag_wait ("slamzoom_complete");
	
	jet1_spawner1 = getent ("bridge_jet_1", "targetname");
	jet1_spawner2= getent ("bridge_jet_2", "targetname");
	
	level.jet1 = jet1_spawner1 thread spawn_vehicle_and_gopath();
	wait(.2);
	jet2 = jet1_spawner2 thread spawn_vehicle_and_gopath();
	
	flag_wait ("bombing_run");
	
	bridge_bomb_start = getvehiclenode("bridge_bomb_start", "script_noteworthy");
	//bridge_bomb_start thread vehicle_scripts\_f15::plane_bomb_node();
	
	bombing_node = getvehiclenode("bomb_start", "script_noteworthy");
	//bombing_node thread vehicle_scripts\_f15::plane_bomb_node();
	
	//Effiel Bomber:
	eiffel_bombing_jet_spawner = getent("eiffel_bombing_jet", "targetname"); 
	bombing_jet = eiffel_bombing_jet_spawner thread spawn_vehicle_and_gopath();
	
	//A10 bomber spawn and attach!
	wait(.10);
	a10 = spawn("script_model", bombing_jet.origin);
	a10 setmodel ("vehicle_a10_warthog");
	a10.modelscale = 10;
	a10.angles = bombing_jet.angles;
	a10 linkto(bombing_jet);
	bombing_jet hide();
	
	bombing_jet delaythread(4.5, ::drop_bombs);
	bombing_jet delaythread(4.5, ::play_sound_on_entity, "scn_ac130_eiffel_bomber");
	
	// "Metal Zero One, this is Odin Six.  Bombs away."
	radio_dialogue( "ac130_o61_bombsaway" );
	
	bombing_node waittill ("trigger");
	
	// "Metal Zero One, this is Odin Six.  Bombs away."
	//radio_dialogue( "ac130_o61_bombsaway" );
	
	exploder("bombing_run_tower_1");
	earthquake(.3, 8, level.player.origin, 200);
	level.player playrumblelooponentity ("damage_light");
	level.player delaycall (4, ::stoprumble, "damage_light" );
	
	//bridge bomber
	bridge_bombing_jet_spawner = getent("bridge_bombing_jet", "targetname"); 
	bridge_bombing_jet = bridge_bombing_jet_spawner thread spawn_vehicle_and_gopath();
	
	//A10 bomber spawn and attach
	wait(.10);
	a10 = spawn("script_model", bridge_bombing_jet.origin);
	a10 setmodel ("vehicle_a10_warthog");
	a10.modelscale = 10;
	a10.angles = bridge_bombing_jet.angles;
	a10 linkto(bridge_bombing_jet);
	bridge_bombing_jet hide();
	
	bridge_bombing_jet delaythread(5.8, ::drop_bombs);
	bridge_bombing_jet delaythread(5.5, ::play_sound_on_entity, "scn_ac130_eiffel_bomber");
	
	// "Metal Zero One, this is Odin Six-two.  Bombs away."	
	delaythread( 3.5, ::radio_dialogue, "ac130_o62_bombsaway" );
		
	bridge_bomb_start waittill ("trigger");

	flag_set("bridge_bombed");
	exploder("bombing_run_tower_2");
	earthquake(.4, 5, level.player.origin, 200);
	level.player playrumblelooponentity ("damage_heavy");
	level.player delaycall (4, ::stoprumble, "damage_heavy" );
	
	wait(5);
	
	//eiffel tower comes down
	flag_set ("tower_final_start");
	
	remaining_axis = getAiarray("axis");
	
	foreach(guy in remaining_axis)
	{
		guy die();
	}
		

	
}	

drop_bombs()
{
	for(i=0; i<7; i++)
	{
		self thread drop_bomb();
		wait(.4);
	}			
}	


drop_bomb()
{
	/*-----------------------
	SPAWN A BOMB MODEL
	-------------------------*/		
	//iprintlnbold("bomb");		
	bomb = spawn( "script_model", self.origin - ( 0, 0, 100 ) );
	bomb.angles = self.angles;
	bomb setModel( "vehicle_f15_missile" );

	/*-----------------------
	launch from self until close to ground
	-------------------------*/		
	vecForward = ( anglestoforward( self.angles ) * 2 );
	vecUp = ( anglestoup( self.angles ) * -0.2 );	// invert the up angles
	vec = [];
	for ( i = 0; i < 3; i++ )
		vec[ i ] = ( vecForward[ i ] + vecUp[ i ] ) / 2;
	vec = ( vec[ 0 ], vec[ 1 ], vec[ 2 ] );
	vec = ( vec * 3000 );
	bomb moveGravity( vec, 5.0 );
	
	wait(5);
	bomb delete();
	
}	


ground_reference_setup()
{
	level.ground_ref_ent = spawn( "script_model", (0,0,0) );
	level.player playerSetGroundReferenceEnt( level.ground_ref_ent );
	
	wait(.5);
	level.ground_ref_ent  rotateto( ( 30, -15, 35 ), 1);
	wait(.2);
	level.ground_ref_ent  rotateto( (0,0,0 ), .3);
	wait(.5);
	level.ground_ref_ent  rotateto( ( 10, -15, -20 ), 1);
	wait(1);
	level.ground_ref_ent  rotateto( (0,0,0 ), 1);
}


aftershocks()
{
	level endon ("player_on_board_littlebird");
	level.ground_ref_ent = spawn( "script_model", (0,0,0) );
	level.player playerSetGroundReferenceEnt( level.ground_ref_ent );
	
	while(1)
	{
		time = randomintrange (15, 25);		
		degrees = randomfloatrange (.7, 2.3);	
		rotate_time = randomfloatrange (.6, 1.2);
		
		level.player playrumblelooponentity ("damage_heavy");
		earthquake(.2, 2, level.player.origin, 8000);
			
		if(cointoss() )
		{
			degrees = degrees * -1;
		}	
		
		//tilt camera				
		level.ground_ref_ent  rotateto( ( degrees, degrees, degrees ), rotate_time);
		wait(rotate_time);
		
		//rubble sound
		level.player thread play_sound_on_entity ("elm_quake_sub_rumble");
		
		//center camera
		level.ground_ref_ent  rotateto( (0,0,0 ), rotate_time, rotate_time * .5, rotate_time * .5);
		wait(rotate_time);
		
		//stop rumble
		level.player stoprumble("damage_heavy");	
		
		//wait 	
		wait(time);
	}	
}

tower_destructible_vehicles_fire()
{
	tower_rockets = getstructarray("tower_rockets", "targetname");
	tower_rockets_ambient = getstructarray("tower_rockets_ambient", "targetname");
	
	tower_aa = getentarray ("tower_aa", "targetname");
		
	flag_wait("all_tanks_destroyed");
	array_thread  (tower_aa, ::aa_fire, "bridge_bombed" );
	level thread shoot_ambient_rockets_from_struct_array(tower_rockets, 6, "bridge_bombed");
	level thread shoot_ambient_rockets_from_struct_array(tower_rockets_ambient, 4, "bridge_bombed");
	
	ambient_bombing_run_structs = getstructarray("ambient_bombing_run", "targetname");
	level thread ambient_bombing_runs( ambient_bombing_run_structs, "bridge_bombed" );

}

ambient_bombing_runs( structs, ender_flag )
{
	assert( isdefined(structs) );
	level endon ( ender_flag );
	while(1)
	{
		foreach( struct in structs )
		{
			fwd = anglestoforward( struct.angles );
			up =  anglestoup( struct.angles );
			playfx( getfx("ambient_bombing"), struct.origin, fwd, up );
			play_sound_in_space( "scn_ac130_distant_explo_building", struct.origin );
			level.player playrumblelooponentity ("damage_light");
			level.player delaycall (.6, ::stoprumble, "damage_light" );
			Earthquake( .2, .4, level.player.origin, 200 );
			wait( randomintrange (10, 15) );		
		}	
	}	

}	
	
shoot_ambient_rockets_from_struct_array(array, time_between, _endon)
{
	level endon(_endon);	
	array_randomize(array);
	while(1)
	{
		foreach(rocket in array)
		{
			fwd = AnglesToForward(rocket.angles);	
			in_front = (fwd) * ( randomintrange(20000, 30000) );
			front_of_me = rocket.origin + in_front;
			fake_rocket = spawn("script_model", rocket.origin);
			fake_rocket setmodel ("tag_origin");
			fake_rocket.angles = rocket.angles;
			fake_rocket rotatepitch(180, .05); //effect is upside down for some reason
			wait(.20);
			playFXOnTag( getfx("FX_s300v_a_missile_trail"), fake_rocket, "tag_origin");
			fake_rocket moveto(front_of_me, 2, 1.6, .3);
			fake_rocket waittill ("movedone");
			playfx( getfx("FX_aa_fire_flash"), fake_rocket.origin); //cheap explosion
			fake_rocket delete();
			wait( time_between );			
		}	
	}		
}	

		
player_can_see( origin )
{
	if( SightTracePassed( level.player GetEye(), origin, false, level.player ) )
	{
		return true;
	}	
	return false;
}	


pickup_choppers()
{
	flag_set("pickup_choppers_in");
	left_side_riders = [];
	right_side_riders = [];
	
	little_bird1_start = getstruct("little_bird1_start", "targetname");
	pickup_node_before_stage = getstruct( "pickup_node_before_stage", "script_noteworthy" );
	
	little_bird1 = spawn_vehicle_from_targetname_and_drive( "little_bird1" );
	little_bird1.health = 90000;
	wait(.10);
	
	foreach(guy in little_bird1.riders)
	{
		guy.ignoreme = 1;
		if ( IsDefined( guy.script_startingposition ) && guy.script_startingposition == 2 )
		{
			guy Hide();
			guy setcontents( 0 );
			level.phantom_passanger = guy;
			level.phantom_passanger thread magic_bullet_shield();	
			level.phantom_passanger.ignoreall = 1;
			level.phantom_passanger.ignoreme = 1;
		}	
	}	
	little_bird1 thread vehicle_paths( little_bird1_start );
	
	//delaythread(7, ::radio_dialogue, "ac130_vnd_backtobase");
	
	little_bird1 waittill( "touch_down" );
	little_bird1  vehicle_unload();
	little_bird1.new_stage_heli_spawn = 1;
	
	//remove volk from delta array
	level.delta = array_remove (level.delta, level.makarov_number_2);
	
	//remove Grinch, he stays with Volk
	level.delta = array_remove (level.delta, level.bishop);
	level.squad = array_remove (level.squad, level.bishop);

	level.phantom_passanger.script_startingposition = 2;
	left_side_riders = array_add(left_side_riders, level.phantom_passanger);
	
	//3 guys in delta (need 2 more)
	allies = getaiarray("allies");

	foreach( guy in allies )
	{
		if(!is_in_array( level.delta, guy ) && is_in_array( level.squad, guy ) )
		{
			new_delta_guy = guy;
			level.delta = array_add(level.delta, new_delta_guy);
			if(level.delta.size == 5)
			{
				break;
			}	
		}
	}	
			
		
	//5 delta guys get on chopper (6th guy is level.phantom_passenger)	
	level.left_side_riders_onboard = 0;	
	num = 3;
	foreach(guy in level.delta)
	{
		guy.script_startingposition = num;
		if(num < 5)
		{
			left_side_riders = array_add(left_side_riders, guy);
			guy.ridingvehicle = undefined;
			guy clear_force_color();
			guy thread left_side_boarders_notify();
		}
		else
		{	
			right_side_riders = array_add(right_side_riders, guy);
			guy.ridingvehicle = undefined;
			guy clear_force_color();
		}	
		num++;		
	}
	
	battlechatter_off("allies");
	
	//delta stops shooting at targets while boarding
	foreach(d in level.delta)
	{
		d.ignoreall = 1;
		d.ignoreme = 1;
	}	
	
	//left_side_riders = array_add(left_side_riders, level.phantom_passanger);
	little_bird1 thread set_stage( pickup_node_before_stage, left_side_riders, "left" );
	little_bird1 thread set_stage( pickup_node_before_stage, right_side_riders, "right" );
	
	level.phantom_passanger.ridingvehicle = undefined;
	little_bird1  thread load_side( "left", left_side_riders );
	little_bird1  thread load_side( "right", right_side_riders );
	level thread little_bird_full_notify(little_bird1);
	
	//final 2 guys group up on Volk
	activate_trigger_with_targetname("last_guys_guard_volk");
	
	sPlayerRideTag = "tag_guy2";
	delaythread(3, ::radio_dialogue,  "ac130_snd_gettingouttahere" );
	little_bird1 delaythread(5, ::player_gets_on_littlebird, sPlayerRideTag);	
	
	//// "Ten feet…one foot…Vandal Three on the deck."
	radio_dialogue( "ac130_vnd_ondeck" );

	flag_wait( "player_on_board_littlebird" );
	//
	little_bird1 thread little_bird_radio_chatter();
	 
	level flag_wait_or_timeout("little_bird_full", 30);
	
	level thread escape_ride_cowbell();
	little_bird1_escape = getstruct ("little_bird1_escape", "targetname");

	/*-----------------------
	LITTLEBIRD TAKES OFF
	-------------------------*/
	little_bird1 vehicle_ai_event( "idle_alert" );
	
	little_bird1 thread vehicle_paths( little_bird1_escape );
	
	//little_bird1 thread vehicle_liftoff( 76 );
	
	wait( 1 );
	
	little_bird1 vehicle_ai_event( "idle_alert_to_casual" );

}	

left_side_boarders_notify()
{
	//each rider gets this notify when they board. I'm only tracking those on the players side.
	self waittill( "animontagdone" );
	level.left_side_riders_onboard++;
	
}	

little_bird_full_notify(little_bird1)
{
	while ( level.left_side_riders_onboard != 2 ) 
	{
		wait( .1 );
	}	
	
	wait(1);
	flag_set ("little_bird_full");
}		

escape_ride_cowbell()
{
	//ambient vehicles get spawned when player boards heli
	finale_bombing_node = getvehiclenode("finale_bomb_start", "script_noteworthy");
	finale_bombing_node thread vehicle_scripts\_f15::plane_bomb_node();
	
	ambient_little_birds = spawn_vehicles_from_targetname_and_drive( "little_bird2" );
	wait(.10);
	foreach(bird in ambient_little_birds)
	{
		bird.health = 90000;
		bird godon();
		bird thread unload_at_touchdown();
	}
	
	finale_bombing_jet = spawn_vehicle_from_targetname_and_drive ("finale_bombing_jet");
	spawn_vehicles_from_targetname_and_drive( "seaknights" );
	delaythread(1, ::spawn_vehicles_from_targetname_and_drive, "escape_cowbell_jets" );

}
	
unload_at_touchdown()
{	
	self waittill( "touch_down" );
	self  vehicle_unload();
}
		
player_gets_on_littlebird( sPlayerRideTag )
{
	//self ==> the littlebird
	
	/*-----------------------
	WAIT FOR PLAYER TO APPROACH LITTLEBIRD
	-------------------------*/
	trigger_origin = self gettagorigin( sPlayerRideTag );
	trigger_radius = 50;
	trigger_height = 100;
	trigger_spawnflags = 0;// player only
	trigger = spawn( "trigger_radius", trigger_origin, trigger_spawnflags, trigger_radius, trigger_height );
	
	player_seat = spawn_tag_origin();
	player_seat.origin = self gettagorigin( sPlayerRideTag );
	player_seat.angles = self gettagangles( sPlayerRideTag );
	player_seat.angles = player_seat.angles + ( 0, 0, 0 );
	player_seat linkto( self, sPlayerRideTag, ( 0, 0, 0 ), ( 0, 90, 0 ) );

	
	Objective_string (  obj( "OBJ_defend_lz" ), &"PARIS_AC130_OBJ_BOARD_THE_LITTLEBIRD" );
	Objective_Position(  obj( "OBJ_defend_lz" ), player_seat.origin );
	objective_onentity(  obj( "OBJ_defend_lz" ), player_seat );
	//iprintlnbold("Frost get on board, let's go!");
	
	level thread do_nags_til_flag("player_on_board_littlebird", undefined, "ac130_snd_getonboard", "ac130_snd_onthebird");
	
	trigger waittill( "trigger" );
	Objective_state (  obj( "OBJ_defend_lz" ), "done");
	playerWeapons = level.player GetWeaponsListall();
	playerPrimaryWeapons = level.player GetWeaponsListPrimaries();
	level.player takeallweapons();
	level.player.ignoreme = 1;

	/*-----------------------
	PLAYER LERPED ONTO BIRD
	-------------------------*/
	
	level.player freezeControls( true );
	setsaveddvar( "ui_hidemap", 1 );
	SetSavedDvar( "hud_showStance", "0" );
	SetSavedDvar( "compass", "0" );
	SetSavedDvar( "ammoCounterHide", "1" );
   	level.player allowprone( false );
   	level.player allowcrouch( false );
   	level.player allowsprint( false );
   	level.player allowjump( false );
    level.player disableWeapons();
    
   	viewPercentFrac = 1.0;
	arcRight = 40;
	arcLeft = 40;
	arcTop = 10;
	arcBottom = 45;
	
	level.player PlayerLinkToBlend( player_seat, "tag_origin", .8, .3, .3 );
	wait 1;
	level.player PlayerLinkToDelta( player_seat, "tag_origin", viewPercentFrac, arcRight, arcLeft, arcTop, arcBottom );
	level.player freezeControls( false );
	//tag_origin.origin = level.player.origin;
	//tag_origin.angles = level.player.angles;
	//level.player PlayerSetGroundReferenceEnt( tag_origin );
	//tag_origin LinkToBlendToTag( self, "tag_origin", false );
	
	level.player takeallweapons();
	level.player LerpViewAngleClamp( 1, 0.25, 0.25, arcRight, arcLeft, arcTop, arcBottom );
	flag_set( "player_on_board_littlebird" );
	
	level.player thread vision_set_fog_changes( "paris_ac130_bridge_takeoff", 8 );

	//KEY timing on fade here
	wait(15);	
	level thread fade_out("black", 5);
	wait(5);
	nextmission();

}

spawn_blackhawks()
{
	
	level._effect[ "shell" ]   = LoadFX( "shellejects/20mm_cargoship" );
	//level._effect[ "shell" ]   = LoadFX( "shellejects/20mm_resting" );
	choppers = getvehiclespawnerarray("pickup_chopper");
	foreach(chopper in choppers)
	{
		pickup_chopper = chopper spawn_vehicle_and_gopath();
		wait(.10);	
		if(isDefined(pickup_chopper.script_noteworthy ))
		{
			pickup_chopper thread blackhawk_mgturret_logic();
			pickup_chopper thread vehicle_god_until_flag("player_on_board_littlebird");
		}	
	}	
	level thread callout_target();
	level thread callout_kill();	
	
}		

blackhawk_mgturret_logic()
{		
	self.minigun = spawnturret("misc_turret", self gettagorigin("tag_gun_r"), "btr80_ac130_turret");//minigun_littlebird_quickspin
	self.minigun.angles = self gettagangles("tag_gun_r");//("tag_turret") -(0,0,180) ;
	self.minigun setmodel("weapon_minigun");//weapon_minigun //weapon_saw_MG_setup
	self.minigun linkto(self, "tag_gun_r");
	self.minigun setmode("manual");
	self.minigun setturretteam("allies");
	self.minigun setdefaultdroppitch(0);
	self.minigun SetAISpread( 5 );
	
	wait(8);
				
	while(!flag("player_on_board_littlebird"))
	{
		//get axis 
		baddies = getaiarray ("axis");	
		
		//remove those already targeted
		foreach(guy in baddies)
		{
			if(isdefined(guy.istarget))
			{
				baddies = array_remove(baddies, guy);
			}
		}		
		
		//if some exist
		if(baddies.size > 0)
		{
			//pick random guy
			guy = random(baddies);
			guy.istarget = 1;
			spot = guy geteye();		
			if(isalive(guy))
			{
				self.minigun SetTargetEntity(guy);
				//wait(randomfloatrange(.5, 1));
				if(isalive(guy))
				{
					level notify ("new_blackhawk_target");
					self shoot_turret_for_time(randomfloatrange(1.5, 6) );
					if(isalive(guy))
					{
						guy die();
					}	
				}
			}
		}
		wait(randomintrange(5, 9) );
	}				
	
}	

callout_target()
{
	callout_lines = [];	
	callout_lines[callout_lines.size]="ac130_apa_insight";
	callout_lines[callout_lines.size]="ac130_apl_takeoutguys";
	callout_lines[callout_lines.size]="ac130_apl_getaway";	
	callout_lines[callout_lines.size]="ac130_agn_solidbox";
	array_randomize(callout_lines);
	
	while(1)
	{
		foreach(line in callout_lines)
		{
			level waittill ("new_blackhawk_target");
			radio_dialogue(line);
		}
	}				
}	

callout_kill()
{
	kill_lines=[];
	kill_lines[kill_lines.size] ="ac130_apa_goodshot";
	kill_lines[kill_lines.size] ="ac130_apl_suppressed";
	kill_lines[kill_lines.size] ="ac130_apa_youreclear";
	array_randomize(kill_lines);
	
	while(1)
	{
		foreach(line in kill_lines)
		{
			level waittill ("blackhawk_target_down");
			radio_dialogue(line);
		}
	}				
}

shoot_turret_for_time(time)
{
	//minigun_heli_gatling_spinup1
	//minigun_heli_gatling_spinloop
	//minigun_heli_gatling_cooldown
	
	self.minigun play_sound_on_entity("blackhawk_gatling_spinup");
	self thread turret_timer(time);
	self endon ("stop_shooting");
	for(;;)
	{
		self.minigun shootturret();
		playfxontag( level._effect["shell"], self, "tag_gun_r");
		wait(.05);
	}	
	
}	


turret_timer(time)
{
	self.minigun thread play_loop_sound_on_entity("blackhawk_gatling_spinloop");
	self.minigun thread play_loop_sound_on_entity("blackhawk_gatling_fire");
	wait(time);
	self.minigun thread stop_loop_sound_on_entity("blackhawk_gatling_spinloop");
	self.minigun thread stop_loop_sound_on_entity("blackhawk_gatling_fire");
	self notify ("stop_shooting");
	self.minigun thread play_sound_on_entity("blackhawk_gatling_cooldown");
	level notify ("blackhawk_target_down");
}	


little_bird_radio_chatter()
{
	/*
	//==choper ride flavor burst==//
	//ground forces at l13 eliminated
	level.scr_radio[ "ac130_apl_l3elim" ] = "ac130_apl_l3elim";
	//Vulture 2-2 whats your status?
	level.scr_radio[ "ac130_hqr_vulturestatus" ] = "ac130_hqr_vulturestatus";
	//Roger - move up to phase line alpha
	level.scr_radio[ "ac130_hqr_phaseline" ] = "ac130_hqr_phaseline";
	//"Circle around to the north."
	level.scr_radio[ "ac130_apl_circletonorth" ] = "ac130_apl_circletonorth";	
	*/
	//self = little bird
	b=[];
	b[b.size] = "ac130_apl_l3elim";
	b[b.size] = "ac130_hqr_vulturestatus";
	//b[b.size] = "ac130_hqr_phaseline";
	b[b.size] = "ac130_apl_circletonorth";
	b[b.size] = "ac130_bl1_blueone";
	b[b.size] = "ac130_bl1_turningwest";
	b[b.size] = "ac130_gt6_longknife";
	b[b.size] = "ac130_gt6_keepscreening";
	
	array_randomize(b);
	
	while(1)
	{
		foreach(a in b)
		{
			//radio_dialogue(a);		
			self play_sound_on_tag (a, "tag_guy2");
			wait(randomfloatrange(2.5, 3.5));
		}
	}	

}	

#using_animtree( "script_model" );
eiffel_collapse()
{
	
	//towers
	//des_towers = getentarray("des_towers", "script_noteworthy");	
	//fx structs
	desfx_1 = getstruct ("desfx_1", "targetname");
	desfx_2 = getstruct ("desfx_2", "targetname");
	desfx_3 = getstruct ("desfx_3", "targetname");
	desfx_4 = getstruct ("desfx_4", "targetname");
	
	//towers	
	tower_orig = getent ("tower", "targetname");
	des1 = getent ("des_1", "targetname");
	des2 = getent ("des_2", "targetname");
	des3 = getent ("des_3", "targetname");
	des4 = getent ("des_4", "targetname");
	des5 = getent ("des_5", "targetname");
	des6 = getent ("des_6", "targetname");
	des7 = getent ("des_7", "targetname");
	des8 = getent ("des_8", "targetname");
	des9 = getent ("des_9", "targetname");
	des10 = getent ("des_10", "targetname");
	des11 = getent ("des_11", "targetname");
	
	des_towers = []; 
	des_towers[des_towers.size] = des1;
	des_towers[des_towers.size] = des2;
	des_towers[des_towers.size] = des3;
	array_thread (des_towers, ::tower_setup);
		
	finale_towers = [];
	finale_towers[finale_towers.size] = des4;
	finale_towers[finale_towers.size] = des5;
	finale_towers[finale_towers.size] = des6;
	finale_towers[finale_towers.size] = des7;
	finale_towers[finale_towers.size] = des8;
	finale_towers[finale_towers.size] = des9;
	finale_towers[finale_towers.size] = des10;
	finale_towers[finale_towers.size] = des11;
	
	foreach(tower in finale_towers)
	{
		tower hide();
		tower.animname = "tower";
		tower assign_animtree();	
	}	
	
	/*
	TAG_TOP_FX2 
	TAG_MID_FX2 
	TAG_TOP_FX1 
	TAG_LOW_FX1 
	TAG_LOW_FX2 
	TAG_LOW_FX3 
	TAG_LOW_FX4 
	TAG_MID_FX3 
	TAG_MID_FX4 
	TAG_MID_FX2  (again?)
	TAG_MID_FX1
	*/
	
	if(!isDefined(level.using_collapse_skipto))
	{
		flag_wait("slamzoom_complete");
		wait(1);
		magicbullet("f15_missile", level.jet1.origin, desfx_1.origin);
		wait(.3);
		magicbullet("f15_missile", level.jet1.origin, desfx_1.origin);
		wait(.3);
		magicbullet("f15_missile", level.jet1.origin, desfx_1.origin);
		wait(1);
	}
		
		des11 thread play_tower_explosions("TAG_TOP_FX2", 1);
		des11 thread play_tower_explosions("TAG_MID_FX2", 1);
		wait(.10);
		
		//hide orig tower
		des1 show();
		tower_orig hide();
		des1 anim_single_solo (des1, "des_1");
		des11 anim_single_solo (des11, "des_1");
		
		des11 thread play_tower_explosions("TAG_TOP_FX2", 1);
		wait(.10);		
		des2 show();
		
		des1 hide();		
		des11 thread play_tower_explosions("TAG_MID_FX2", 1);
		des2 anim_single_solo (des2, "des_2");
		des11 anim_single_solo (des11, "des_2");
	
		wait(5);
		
		des11 thread play_tower_explosions("TAG_TOP_FX1", 1);

		wait(.10);	
		des3 show();
		des2 hide();	
		des3 anim_single_solo (des3, "des_3");
		des11 anim_single_solo (des11, "des_3");
		
		level thread tower_finale_cowbell();
	
		flag_wait("tower_final_start");
		
		playFXOnTag( getfx( "FX_eiffel_tower_flash_burst_a"), des11, "j_top_03" );  	//MAIN SHAFT FLASH BURST AND DEBRIS
		playFXOnTag( getfx( "FX_eiffel_tower_debris_fall_a_wide"), des11, "j_mid" );  	//First Floor Centre Debris Fall Burst
		
		des11 thread play_tower_explosions("TAG_LOW_FX1", 1);
		
		des4 show();
		des3 hide();	
				
		//play finale anim on all finale_towers models 
		foreach(tower in finale_towers)
		{
			tower thread anim_single_solo (tower, "des_finale");
		}	
		des11 thread play_sound_on_entity( "scn_ac130_eiffel_tower_fall" );
		spot = level.player geteye();
		playFX(level._effect[ "tower_ash" ], spot);
	
	level notify ("final_tower_collapse");
	//playFX(level._effect[ "tower_cloud" ], desfx_4.origin);
	
	//these flags are set off notetracks
	flag_wait("hide_4_show_5");
	//iprintlnbold("hide_4_show_5");
	des5 show();
	des4 hide();
		
	playFXOnTag( getfx( "FX_eiffel_tower_debris_burst_a"), des11, "tag_low_fx1" );  	//FRONT left BASE leg break
	playFXOnTag( getfx( "FX_eiffel_tower_debris_burst_a"), des11, "J_Low_break06" );	//REAR right BASE leg break
	playFXOnTag( getfx( "FX_eiffel_tower_spark_burst_b"), des11, "tag_low_fx1" );		//FRONT left MID column break	
	playFXOnTag( getfx( "FX_eiffel_tower_spark_burst_b"), des11, "tag_low_fx2" );		//FRONT right MID column break
	
	playFXOnTag( getfx( "FX_eiffel_tower_debris_loop_a"), des11, "j_top_03" );
	des4 thread play_tower_stress_fx("TAG_LOW_FX2");

	flag_wait("hide_5_show_6");
	//iprintlnbold("hide_5_show_6"); //LEG BREAKS
	des6 show();
	des5 hide();	
	des6 thread play_tower_stress_fx("TAG_LOW_FX3");

	flag_wait("hide_6_show_7");
	//iprintlnbold("hide_6_show_7");
	des7 thread play_tower_explosions("TAG_LOW_FX4");
	earthquake(.4, .5, level.player.origin, 200);//leg impact
	des7 show();
	des6 hide();	

	flag_wait("hide_7_show_8");
	//iprintlnbold("hide_7_show_8");
	des7 thread play_tower_stress_fx("TAG_MID_FX3");
	des8 show();
	des7 hide();	

	flag_wait("hide_8_show_9");
	//iprintlnbold("hide_8_show_9");
	des9 thread play_tower_stress_fx("TAG_MID_FX4");
	des9 show();
	des8 hide();	

	flag_wait("hide_9_show_10");
	//iprintlnbold("hide_9_show_10");
	des10 thread play_tower_stress_fx("TAG_MID_FX2");
	des10 show();
	des9 hide();	

	flag_wait("hide_10_show_11");
	//iprintlnbold("hide_10_show_11");
	playFXOnTag( getfx( "FX_eiffel_tower_debris_burst_b"), des11, "tag_mid_fx1" );		//front left MID column break	
	playFXOnTag( getfx( "FX_eiffel_tower_debris_burst_b"), des11, "J_mid_break03" );	//front right MID column break
	playFXOnTag( getfx( "FX_eiffel_tower_spark_burst_a"), des11, "J_mid_break02" );		//front left MID column break	
	playFXOnTag( getfx( "FX_eiffel_tower_spark_burst_a"), des11, "J_mid_break05" );		//rear right MID column break
	des11 thread play_tower_stress_fx("TAG_MID_FX1");
	des11 show();
	des10 hide();	
	
	wait(7);
	playFXOnTag( getfx( "FX_eiffel_tower_debris_loop_b"), des11, "j_top_03" );
	wait(1);
	stopFXOnTag( getfx( "FX_eiffel_tower_debris_loop_a"), des11, "j_top_03" );
	
}		

/*
play_tower_stall(_tag, explosion )
{
	playFXOnTag( getfx( "metal_eject" ), self, _tag);
}
*/

play_tower_explosions(_tag, explosion )
{
	//self = script_model effiel tower
	//traditional explosion
	if(isdefined(explosion))
	{
		playFXOnTag( getfx( "huge_explosion" ), self, _tag);
	}	
	//effiel gibs flying out
	playFXOnTag( getfx( "FX_eiffel_tower_debris_a" ), self, _tag);
}	

play_tower_stress_fx(_tag, explosion )
{
	//self = script_model effiel tower
	//traditional explosion
	if(isdefined(explosion))
	{
		playFXOnTag( getfx( "huge_explosion" ), self, _tag);
	}	
	//effiel gibs flying out
	playFXOnTag( getfx( "FX_eiffel_tower_stress" ), self, _tag);
}


tower_finale_cowbell(spot)
{
	//earthquakes and rumble for finale
	time = getanimlength(%paris_ac130_tower_destruction_finale); //24
		
	flag_wait("tower_final_start");
	earthquake(.1, time*.5, level.player.origin, 200);
	level.player playrumblelooponentity ("damage_heavy");
	level.player delaycall (3, ::stoprumble, "damage_heavy" );

	wait(time*.5);

	earthquake(.3, time*.2, level.player.origin, 200);
	level.player playrumblelooponentity ("damage_heavy");
	level.player delaycall (3, ::stoprumble, "damage_heavy" );
	wait(time*.1);
	
	//final impact
	wait(.3);
	earthquake(.5, .4, level.player.origin, 200);
	wait(.4);
	earthquake(.2, 3, level.player.origin, 200);
		
	wait(10);
	level thread aftershocks();
}

tower_setup()
{
	self.animname = "tower";
	self assign_animtree();
	self hide();	
	assert( isdefined(self.targetname) );
	self anim_first_frame_solo (self, self.targetname);	
	//des2 anim_first_frame_solo (des2, "des2");
}

	
/*
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
EMBASSY COURTYARD FIGHT
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 
*/

#using_animtree("generic_human"); 
HVT_escape()
{
	battlechatter_off("allies");
	//set_ambient("paris_ac130_ground_ext1");
	bridge_radio();
	maps\_carry_ai::initCarry();
	level.dshk_viewmodel = "viewhands_player_delta";
	maps\_dshk_player::init_dshk_player();
	level init_hvt_flags();
	level.air_support_weapon = "ac130_40mm_air_support_strobe_iw";
	
	CreateThreatBiasGroup( "axis" );
	CreateThreatBiasGroup( "allies" );
	CreateThreatBiasGroup( "turret_player" );
	CreateThreatBiasGroup( "street_player" );
	
	SetThreatBias ("turret_player", "axis", 0);
	SetThreatBias ("street_player", "axis", 200000000);
		
	//node = getstruct( "hvt_escape_hvt_downed", "targetname" );
	level thread yellow_building_destruction();
	level thread second_floor_cowbell();
	//level thread hvt_turret_barrel();
	level thread track_player_hvt();
	level thread hvt_dialogue();
	level thread hvt_friendly_management();
	level thread hvt_enemy_management();
	level thread hvt_did_player_go_to_bedroom();
	level thread hvt_tank_entrance();
	level thread yellow_building_shoot_detection();
	level thread yellow_building_attacking();
	level thread hvy_street_threat_bias();
	level thread hvt_player_turret_threat_bias();
	level thread hvt_courtyard_curtains();
	

	level.scr_anim[ "snd" ][ "door_kick" ]	=%door_kick_in;
	level.scr_anim[ "hitman" ][ "hvt_orders" ]	=%stand_exposed_wave_target_spotted;
	level.scr_anim[ "hitman" ][ "balcony_jump1" ]	=%traverse_jumpdown_130;
	level.scr_anim[ "hitman" ][ "balcony_jump2" ]	=%traverse_jumpdown_96;
	level.scr_anim[ "snd" ][ "slow_door" ]	=%hunted_open_barndoor_flathand;
	level.scr_anim[ "generic" ][ "table_hop" ]	=%traverse40_2_cover;
	
	//sandman pinned
	level.scr_anim[ "snd" ][ "pinned" ]	=%paris_ac130_pinned_sandman;
	level.scr_anim[ "snd" ][ "pinned_idle" ][0] 	=%paris_ac130_pinned_sandman_idle;
	level.scr_anim[ "snd" ][ "pinned_idle_single"] 	=%paris_ac130_pinned_sandman_idle;
	level.scr_anim[ "snd" ][ "pinned_sandman_wave" ]	=%paris_ac130_pinned_sandman_wave;
	
	//Hitman pinned (Truck)
	level.scr_anim[ "hitman" ][ "pinned" ]	=%paris_ac130_pinned_hitman;
	level.scr_anim[ "hitman" ][ "stairs_sprint" ]	=%traverse_stair_run_02;
	
	//hvt and guard pinned
	level.scr_anim[ "guard" ][ "pinned" ]	=%paris_ac130_pinned_guard;
	level.scr_anim[ "guard" ][ "pinned_idle" ][0] = %paris_ac130_pinned_guard_idle;
	
	level.scr_anim[ "hvt" ][ "pinned" ]	=%paris_ac130_pinned_HVT;
	level.scr_anim[ "hvt" ][ "pinned_idle" ][0] = %paris_ac130_pinned_HVT_idle;
	
	//pinned guard left of sandman
	level.scr_anim[ "soldier" ][ "pinned" ]	=%paris_ac130_pinned_soldier01;
	level.scr_anim[ "soldier" ][ "pinned_idle" ][0] = %paris_ac130_pinned_soldier01_idle;

	
	//tank explode through wall
	addNotetrack_customFunction( "snd", "kick", ::first_floor_doors_open, "door_kick" );

	sonic_boom_nodes = getvehiclenodearray("sonic_boom_custom", "script_noteworthy");
	array_thread( sonic_boom_nodes, vehicle_scripts\_f15::plane_sound_node);
	
	jets = getentarray ("hvt_jets", "script_noteworthy");
	level thread jets_overhead(jets);

	//player could possible hit this trig during slamzoom
	trig = getent ("hvt_squad_to_exit", "targetname");
	trig thread trigger_off_til_flag("hvt_tank_destroyed");
	
	//fountain trig getting hit when player warps to hotel(!)
	trig2 = getent("hvt_squad_to_fountain", "targetname");
	trig2 trigger_off();
	
	
	hvt_street = getent ("hvt_street", "targetname");
	hvt_street trigger_off();
	
	//general event setup...
	flag_wait ("hvt_slamzoom_complete");
	

	wait(.10);
	
	aa_fire_ents = getentarray ("aa_fire", "targetname");
	array_thread  (aa_fire_ents, ::aa_fire, "FLAG_hvt_escape_hvt_captured" );
	
	level.makarov_number_2.ignoreme = 1;
	
	//level thread hvt_e3_fade();
	
	trig2 trigger_on();
	hvt_street trigger_on();
	
	courtyard_turrets = [];
	courtyard_turrets[0] = getent ("player_turret", "script_noteworthy");
	//courtyard_turrets[1] = getent ("window_turret", "script_noteworthy");
	
	array_thread(courtyard_turrets, maps\_dshk_player::dshk_turret_init);
	array_thread(courtyard_turrets,
	maps\_dshk_player::dshk_shells,"shell", "FLAG_courtyard_slamzoom_out_finished");
	/*
	fires = getstructarray ("courtyard_fire", "targetname");
	foreach(fire in fires)
	{
		playFX(level._effect[ "courtyard_fire" ], fire.origin);
		//fire delete();
	}	
	*/	
	//show/hide the trees in the courtyard	
	//sky_trees = getentarray("prs_ac_courtyard_trees_air", "targetname");
	//ground_trees = getentarray("prs_ac_courtyard_trees_ground", "targetname");
	
	//array_thread( sky_trees, ::hide_me);
	//array_thread( ground_trees, ::show_me);
			
	//wait for tank to get destroyed by c130 before turning on color trig in parking lot	
	flag_wait ("hvt_tank_destroyed");
	trig trigger_on();
	
}


trigger_off_til_flag(the_flag)
{
	self trigger_off();
	flag_wait (the_flag);
	self trigger_on();
}

#using_animtree( "script_model" );
hvt_courtyard_curtains()
{
	curtains = getentarray("curtains", "script_noteworthy");
	left_curtains = getentarray("curtains_left", "targetname");
	right_curtains = getentarray("curtains_left", "targetname");
	
	foreach(c in curtains)
	{
		if(c.targetname == "curtains_left")
		{
			c.animname =  "left_curtain";
			c maps\_anim::setanimtree();
			c thread anim_loop_solo(c, "left_curtain_wind");
		}
		else
		{
			c.animname =  "right_curtain";
			c maps\_anim::setanimtree();
			c thread anim_loop_solo(c, "right_curtain_wind");	
		}
	}		

}	


hvt_e3_fade()
{
	
	if(level.start_point == "start_e3")
	{
		level.player enableinvulnerability();
		level.player NotifyOnPlayerCommand( "stop_demo", "+usereload" );
		//level.player NotifyOnPlayerCommand( "stop_demo", "+reload" );  //PC TESTING
		level.player waittill( "stop_demo" );
		
		thread fade_out("black", 3);
		//stoprumble
		wait(3);
		level.player delaythread (.3, ::play_sound_on_entity, "player_slamzoom_out" );
		maps\_audio_mix_manager::MM_start_preset( "scn_ac130_e3demo_amb_mix", 1);//scn_ac130_e3demo_amb_mix scn_ac130_e3demo_all_mix
		level.player.ignoreme = 1;
		level.player freezeControls( true );
		level.player disableWeapons();
		ent = spawn( "script_origin", level.player.origin);
		ent.angles = (0,0,0);

		level.player enableinvulnerability();	
		level.player playerlinktoabsolute ( ent );
		ent moveto ( ( 0,0,300), .3);
		wait(1.6);
		//logo = maps\_hud_util::create_client_overlay_custom_size( "mw3_full_logo_alpha", 1);
		//scale = 0.48;
		SetSavedDvar( "g_friendlynamedist", 0 );
		setsaveddvar( "ui_hidemap", 1 );
		setsaveddvar( "compass", 0 );
		SetSavedDvar( "ammoCounterHide", "1" );
		SetSavedDvar( "hud_showStance", 0 );
		//logo Setshader( "mw3_full_logo_alpha", int( 1200 * scale ), int( 512 * scale ) );
		//logo.sort = 5;
		//musicplaywrapper("paris_ac130_end_demo_music");
		wait 5;
		level thread fade_out("black", 3);
		level.nextmission_exit_time = 1;
		wait 3;
		nextmission();
	}	
		
	
}


hvt_pip_cam_timing()
{
	wait(4);
	level thread maps\paris_ac130_pip::ac130_pip_init(level.sandman);
	
	//level.sandman delaythread (3, ::shoot_rpgs_over_my_shoulder, 2);

	level delaythread (8, maps\paris_ac130_pip::ac130_pip_close);

}	

shoot_rpgs_over_my_shoulder(rpg_num)
{
	for(i = 0; i < rpg_num; i++ )
	{
		fwd = AnglesToForward(self.angles);
		random_num = randomintrange(10,20);
		
		behind =  (fwd) *(-200); 
		randomly_behind_and_above_me = self.origin + behind + (random_num, random_num, 120);	
			
		front = (fwd) * (800);
		in_front_of_me = self.origin + front;
			
		magicbullet("rpg", randomly_behind_and_above_me, in_front_of_me);
		wait(randomfloatrange(1.5, 3) );
	}	
}


aa_fire(ender_flag)
{
	//self = script_origin
	wait(randomintrange(1, 3) );
	
	time = randomintrange(1, 4);
	num = randomintrange(60, 100);
	while( !flag( ender_flag ) )
	{
		self thread fire_on_rotate(ender_flag);
		wait(.10);
		self rotatepitch(num*-1, time);
		wait (time);
		self rotatepitch(num, time);
		wait (time);
		self notify ("stop_firing");
		
		wait(randomintrange(6, 10) );;
	}	
}		



	
		
fire_on_rotate(ender_flag)
{
	//self = script_origin
	self endon ("stop_firing");	
	while( !flag( ender_flag ) )
	{
		fwd = AnglesToForward(self.angles);
		playfx( level._effect[ "FX_flak_tracers" ], self.origin, fwd);
		wait(.5);
	}	
}	
	
	
jets_overhead(jets)
{
	//continuously spawns from 3 jet splines over courtyard
	level endon ("FLAG_hvt_escape_hvt_captured");
	flag_wait("hvt_slamzoom_complete");
	
	while(1)
	{
		foreach (jet in jets)
		{
			jet.count = 1;
			jet_ai = jet thread spawn_vehicle_and_gopath();
			wait(.10);
			if( cointoss() )
			{
				jet_ai thread jet_dog_fight();
			}	
			wait(randomintrange(15, 20));
		}
	}			
}	

bridge_jets_overhead(jets)
{
	//continuously spawns from 3 jet splines over courtyard
	level endon ("bridge_collapse_start");
	flag_wait("slamzoom_complete");
	
	wait(10);
	
	while(1)
	{
		foreach (jet in jets)
		{
			jet.count = 1;
			jet_ai = jet thread spawn_vehicle_and_gopath();
			wait(.10);
			
			if( randomint(100) > 50 )
			{
				jet_ai thread jet_dog_fight();
			}	
			wait(randomintrange(15, 20));
		}
	}			
}	

jet_dog_fight()
{
	//iprintlnbold("jet shooting");
	self endon ("reached_end_node");
	
	fwd = AnglesToForward(self.angles);
	end = fwd * (randomintrange(3500, 4500)*2 ); 
	spot = self.origin + end;
	
	//spawn and link another plane
	fake_enemy = spawn ("script_model", spot);
	fake_enemy.angles = self.angles;
	fake_enemy setmodel ("vehicle_mig29_low");
	fake_enemy linkto(self);
	
	self thread delete_fake_enemy(fake_enemy);
	
	r_offset = ( 76,-74, 20 );
	l_offset = ( 76, 74, 20 );
	
	r_offset_m = ( 76,-74, 25 );//lower for missile
	l_offset_m = ( 76, 74, 25 );
	
	shot_amount = 0;
	
	//shoot from chasing plane
	while(ISDefined(self))
	{
		//MG
		left_ = get_world_relative_offset(self.origin, self.angles, l_offset);
		fwd = AnglesToForward(self.angles);
	  	end =  (fwd) *(1000); 
		//MagicBullet( "ac130_25mm", left_, left_ + end );//f15_missile
		playFX (level._effect[ "FX_jet_20mm_tracer" ], left_, fwd);
		wait(.15);
		right_ = get_world_relative_offset(self.origin, self.angles, r_offset);
		fwd = AnglesToForward(self.angles);
		end =  (fwd) *(1000); 
		//MagicBullet( "ac130_25mm", right_, right_ + end );
		playFX (level._effect[ "FX_jet_20mm_tracer" ], right_, fwd);
		wait(.15);
		shot_amount++;
			
		//shoot 2 missile for every X mg bullets
		if(shot_amount >= 10)
		{
			left_ = get_world_relative_offset(self.origin, self.angles, l_offset_m);
			fwd = AnglesToForward(self.angles);
		  	end =  (fwd) *(1000); 
			MagicBullet( "f15_missile", left_, left_ + end );//f15_missile
			wait(.30);
			right_ = get_world_relative_offset(self.origin, self.angles, r_offset_m);
			fwd = AnglesToForward(self.angles);
			end =  (fwd) *(1000); 
			MagicBullet( "f15_missile", right_, right_ + end );		
			//reset shot count
			shot_amount = 0;
		}			
	}	

}	

delete_fake_enemy(fake_enemy)
{
	self waittill ("reached_end_node");
	fake_enemy delete();
}	

get_world_relative_offset( origin, angles, offset )
{
	cos_yaw = cos( angles[ 1 ] );
	sin_yaw = sin( angles[ 1 ] );

	// Rotate offset by yaw
	x = ( offset[ 0 ] * cos_yaw ) - ( offset[ 1 ] * sin_yaw );
	y = ( offset[ 0 ] * sin_yaw ) + ( offset[ 1 ] * cos_yaw );

	// Translate to world position
	x += origin[ 0 ];
	y += origin[ 1 ];
	return ( x, y, origin[ 2 ] + offset[ 2 ] );
}

#using_animtree( "generic_human" );
hvt_friendly_management()
{	
	
	thread set_flag_on_targetname_trigger("hvt_squad_to_fountain");
	
	foreach(guy in level.delta)
	{
		//guy cqb_walk("on");
		//guy LaserForceOff();
		guy.ignoreme = 0;
		guy.ignoreall = 1;
		guy.default_accuracy =  guy.baseAccuracy;
		guy.baseAccuracy = .33;
		guy setlookatentity();
	}

	//level.gator	set_force_color("r");
	level.gator disable_pain();
	gatornode = getnode("gator_cover", "targetname");
	level.gator.goalradius = 32;
	level.gator setgoalnode( gatornode ); 
	
	level.frost.ignoreall = 1;
	level.frost.ignoreme = 1;

	activate_trigger_with_targetname("squad_HVT_pos1");
	
	flag_wait("player_shot_yellow_building");
	
	//pinned-down scene
	level.hitman.animname = "hitman";
	level.gator.animname = "soldier";
	level.bishop.animname = "guard";
	level.makarov_number_2.animname = "hvt";
	level.sandman.animname = "snd";

	pinned_node = getent ("pinned_node", "targetname");
	level.makarov_number_2.woundedNode = pinned_node;
	
	pinned_actors = [];	
	pinned_actors[pinned_actors.size] = level.gator;
	pinned_actors[pinned_actors.size] = level.bishop;
	pinned_actors[pinned_actors.size] = level.makarov_number_2;

	radio_dialogue_stop();
	//one-off on hitman
	//level.hitman waittill( "killanimscript", other );
	level.hitman thread hvt_hitman_pinned(pinned_node);
	
	//special func for sandman to play scene, nag, then idle
	level.sandman thread hvt_sandman_pinned( pinned_node );
	
	//remaining actors play scene then idle
	array_thread(pinned_actors, ::hvt_pinned_actor_play_scene_then_idle, pinned_node);

	//flag_wait("pinned_anim_complete");
	
	//level.hitman enable_sprint();
	
	flag_wait ("turret_guy_dead");
	level.gator stopanimscripted();
	level.hitman disable_cqbwalk();
	
	//squad moves outside:
	flag_set ("squad_to_courtyard");
	autosave_by_name("squad_outside");	
	musicplaywrapper( "paris_ac130_courtyard_fight" );

	//sandman kicks down door to courtyard
	level.sandman disable_ai_color();
	level.sandman gun_recall();
	level.sandman stopanimscripted();
	door_kick_node = getent ("doorkick", "targetname");
	door_kick_node anim_reach_solo(level.sandman, "door_kick");
	door_kick_node anim_single_solo(level.sandman, "door_kick");
	level.sandman set_force_color("r");
	level.gator	set_force_color("r");
	level.gator.ignoreall = 1;
	level.gator.ignoreme = 1;
	level.gator.ignoreSuppression = 1;
	
	level thread hitman_jumpdown();
	
	//squad to courtyard
	activate_trigger_with_targetname("red_to_courtyard");
	level sandman_moveup_line();
	
	//gator ignores all for a few secs to get his ass moving
	wait 4;
		
	foreach(guy in level.delta)
	{
		guy.baseAccuracy = 3;
		guy.ignoreall = 0;
		guy.ignoreme = 0;	
		guy.ignoreSuppression = 0;
	}	
	
	//array_wait (level.delta, "goal");
	
	//GARDEN POS2
	level flag_wait_or_timeout( "squad_garden_pos2", 35);
	level thread sandman_moveup_line();
	
	//if timeout, then player has not hit trig yet. Hit the trig. 
	trig = getent ("squad_garden_pos2", "targetname");
	if(IsDefined(trig) )
	{
		//IPrintLn("pushing up squad");
		activate_trigger_with_targetname(trig.targetname);
		trig delete();
		flag_set ("squad_garden_pos2");
	}	
	
	foreach(guy in level.delta)
	{
		guy.baseAccuracy = 1;
	}
	
	//dont push squad to fountain if player is still upstairs
	while(level.player_upstairs)
	{
		wait(.5);
	}	
	
	wait(10);
	
	//when 3 enemies or less are on monument
	flag_wait("hvt_monument_clear");
	
	autosave_by_name("squad_to_fountain");	
	
	level thread hvt_courtyard_carry();
	
	//move up squad
	level thread sandman_moveup_line();
	
	//IPrintLn("pushing up squad");
	activate_trigger_with_targetname("hvt_squad_to_fountain");

	flag_set ("hvt_squad_to_fountain");
		
	wait(.20);
		
	//wait for player to get close before squad moves to parking lot
	while( Maps\_utility_chetan::distance_2d_squared( level.sandman.origin, level.player.origin ) > Squared( 700 ) )
	{
		wait(.10);
	}	

	flag_wait("hvt_tank_destroyed");
	wait(2);

	//color trig moves squad to last hallway to wait for player
	activate_trigger_with_targetname("hvt_squad_to_parking_lot");
	
	//wait(1);
	//radio_dialogue("ac130_snd_onme");
	
	//delaythread(4, ::hvt_slamout);
	
	// "Kilo one this is uniform 6 we are inbound to your location."
	//radio_dialogue("ac130_hmv_enroute");	
	
	//solid copy, we're almost at the intersection. Three minutes out. 
	//thread radio_dialogue("ac130_snd_intersection");
	
	//sending sandman to covernode on door that he opens
	level.sandman clear_force_color();
	node = getnode ("sandman_door", "targetname");
	level.sandman.goalradius = 32;
	level.sandman setgoalnode(node);
	//wait(1);
	//level.sandman waittill ("goal");

	//wait for player to enter hallway
	//flag_wait("hvt_player_exit_hallway");
	
	//sandman does price door open anim
	//left_door = getent ("courtyard_exit_left", "targetname");
	//door_node = getstruct ("hunted_open_barndoor_flathand", "targetname");
	//level.player delaythread (1.3, ::play_sound_on_entity, "player_slamzoom_out" );
	//level thread pip_sim_til_flag(.2, "FLAG_courtyard_slamzoom_out_finished");
	//time = getanimlength(%hunted_open_barndoor_flathand);	
	//back in ac130 with this flag
	/*	
	level.sandman disable_ai_color();
	door_node anim_reach_solo(level.sandman, "slow_door");
	left_door thread palm_style_door_open();
	door_node thread anim_single_solo( level.sandman, "slow_door" );
	left_door connectpaths();
	
	level.sandman set_force_color("r");
	
	level thread maps\_carry_ai::end_carry_ai_logic(level.bishop, level.makarov_number_2);
	//wait(.15);
	
	//level.current_player_loadout = level.player GetWeaponsListall();
	//wait (time *.7);
	//SLAMZOOM BACK TO AC130 WITH THIS FLAG:	
	//flag_set("FLAG_hvt_escape_hvt_captured" ); 
	
	//wait(1);
	*/
	courtyard_chopper = get_vehicle ("courtyard_chopper", "targetname");
	courtyard_chopper thread maps\_vehicle::godoff();
	courtyard_chopper delete();
	battlechatter_off("allies");

}	

hvt_slamout()
{
	level.player endon( "death" );
	level.current_player_loadout = level.player GetWeaponsListall();
	player_link = Spawn( "script_model", level.player.origin );
	player_link.angles = level.player getplayerangles();
	player_link SetModel( "tag_origin" );
	
	level.player FreezeControls( true );
	level.player SetStance( "stand" );
	level.player AllowCrouch( false );
	level.player PlayerLinkToAbsolute( player_link, "tag_origin" );
	
	level.player EnableInvulnerability();
	level.player HideViewModel();
	level.player TakeAllWeapons();
	level.player.ignoreme = true;

	final_orign = ( 1750, 41099, 5943 );
	final_angles = ( 90, 267.5, level.player.angles[2] );

	player_link moveZ( 5943, 1.2, 1.2 );
	level thread slamout_static(.4);
	player_link rotateto( final_angles, .2 );
	player_link thread play_sound_on_entity( "player_slamzoom_out" );
	player_link thread play_loop_sound_on_entity( "slamout_static" );
	level.player VisionSetNakedForPlayer( "paris_ac130_enhanced", 2 );
	delaythread( .6, vehicle_scripts\_ac130::hud_add_targets, level.delta );
	wait( 0.8 );
	thread fade_out_in( "overlay_static", 0.3, 1 );
	wait( 0.3 );
	flag_set("FLAG_hvt_escape_hvt_captured" );
	player_link thread stop_loop_sound_on_entity( "slamout_static" );
	level thread maps\_carry_ai::end_carry_ai_logic(level.bishop, level.makarov_number_2);
}	

hvt_hitman_pinned(node)
{
	
	level.hitman set_force_color("b");
	level.hitman.ignoreme = 1;
	level.hitman.ignoreall = 1;
	level.hitman disable_pain();	
	level.hitman disable_careful();
	level.hitman disable_surprise();

	node anim_single_solo (level.hitman, "pinned");

	wait(6);
	level.hitman.ignoreme = 0;
	level.hitman.ignoreall = 0;
	wait(10);
	//level.hitman enable_cqbwalk();

}	

hvt_sandman_pinned(node)
{
	//self = sandman
	level endon ("turret_guy_dead");
	
	//give him a node to go to if the endon kicks him out of the anim..
	backup_cover_node = getnode("sandman_cover", "targetname");
	self disable_ai_color();
	self.goalradius = 32;
	self setgoalnode( backup_cover_node );
	
	node anim_single_solo(self, "pinned");
	flag_set("pinned_anim_complete");
	node anim_single_solo(self, "pinned_idle_single");
	
	//manually attaching gun to left hand for the wave anim per animations request to avoid jitter of default gun
	left_hand_origin = self gettagorigin("tag_weapon_left");
	left_hand_angles = self gettagangles("tag_weapon_left");
	
	stunt_gun = spawn ("script_model", left_hand_origin);
	stunt_gun setmodel ("weapon_m16_sp_iw5");//weapon_m16_sp_iw5 weapon_m16
	stunt_gun.angles = left_hand_angles;
	stunt_gun linkto (self, "TAG_WEAPON_LEFT");

	stunt_gun hidepart( "TAG_ACOG_2" );
	stunt_gun hidepart( "TAG_EOTECH" );
	stunt_gun hidepart( "TAG_HAMR_HYBRID" );
	stunt_gun hidepart( "TAG_HEARTBEAT" );
	stunt_gun hidepart( "TAG_FOREGRIP" );
	stunt_gun hidepart( "TAG_M203" );
	stunt_gun hidepart( "TAG_M320" );
	stunt_gun hidepart( "TAG_MAGNIFIER" );
	stunt_gun hidepart( "TAG_RED_DOT" );
	stunt_gun hidepart( "TAG_SHOTGUN" );
	stunt_gun hidepart( "TAG_SILENCER" );
	stunt_gun hidepart( "TAG_THERMAL_SCOPE" );
	
	while(!flag("player_went_upstairs") )
	{		
		self gun_remove();	
		stunt_gun show();
		
		//get up there and flank that MG!
		thread radio_dialogue( "ac130_snd_takeoutmg" );
		node anim_single_solo(self, "pinned_sandman_wave");	
		
		stunt_gun hide();
		self gun_recall();
		node anim_single_solo(self, "pinned_idle_single");	
		node anim_single_solo(self, "pinned_idle_single");	
	}
	
	node anim_loop_solo	(level.sandman, "pinned_idle");
}	


hvt_pinned_actor_play_scene_then_idle(node)
{	
	if(self == level.gator)
	{
		level endon ("turret_guy_dead");
	}
		
	node anim_single_solo(self, "pinned");
	node anim_loop_solo(self, "pinned_idle");
}


hvt_turret_nag()
{
	
	level endon ("turret_guy_dead");
	while(1)
	{
		wait(randomintrange( 10, 15) );
		// "We're taking heavy fire!  Get that MG down, now!"
		radio_dialogue( "ac130_snd_getmgdown" );
		
		wait(randomintrange( 10, 15) );	
		
		// "Take out that mg so we can move up!
		radio_dialogue( "ac130_snd_wecanmoveup" );
		wait(randomintrange( 10, 15) );
	}	

}	


second_floor_cowbell()
{
	//CQB_stand_wave_on_me
	//CQB_stand_signal_move_out
	//CQB_stand_signal_move_up
	createthreatbiasgroup("upstairs_enemies");
	createthreatbiasgroup("hitman");
	level.hitman setthreatbiasgroup("hitman");
	upstairs_guys = getentarray ("upstairs_guys", "targetname");
	array_thread(upstairs_guys, ::add_spawn_function, ::upstairs_guys_logic);
		
	target = getstruct ("2nd_floor_window", "targetname");
	source = getstruct( "balcony_jump1", "targetname" );
	
	trigger_wait_targetname("player_stairs");
	upstairs_guys_ai = array_spawn( upstairs_guys, 1 );
	wait(.10);
	SetThreatBias ("upstairs_enemies", "hitman", 200000000);	
	level.hitman enable_pain();
	while(upstairs_guys_ai.size > 0)
	{
		upstairs_guys_ai = array_removedead (upstairs_guys_ai);
		wait(.5);
	}	
	level.hitman.ignoreall = 1;
	level.hitman.script_pushable = 0;
	midway_trig = getent ("blue_to_hallway", "targetname");
	if(isDefined(midway_trig))
	{
		midway_trig delete();
	}	
	
	//send friendly to bedroom	
	activate_trigger_with_targetname("blue_to_bedroom");
	wait(6);
	level.hitman.ignoreall = 0;
	
}	

upstairs_guys_logic()
{
	self setthreatbiasgroup("upstairs_enemies");
	self.goalradius = 32;
	self.grenadeammo = 0;
	if(cointoss() )
	{
		self enable_sprint();
	}	
	self disable_long_death();
	self endon("death");
	if(isDefined(self.script_noteworthy))
	{
		node = getstruct(self.script_noteworthy, "targetname");
		self.animname = "generic";
		node anim_reach_solo (self, "table_hop");	
		self thread interrupt_anim_on_alert_or_damage(self);
		node thread anim_single_solo (self, "table_hop");
	}	
		
}

interrupt_anim_on_alert_or_damage( guy )
{
	guy waittill_any( "damage", "death" );
	guy StopAnimScripted();
}

hitman_jumpdown()
{
	//level.hitman disable_ai_color();	
	level.hitman disable_cqbwalk();
	level.hitman set_battlechatter(1);
	balcony_jump1 = getstruct( "balcony_jump1", "targetname" );
	balcony_jump2 = getstruct( "balcony_jump2", "targetname" );
	
	level.hitman.animname = "hitman";
	
	balcony_jump1 anim_reach_solo (level.hitman, "balcony_jump1");
	balcony_jump1 anim_single_solo (level.hitman, "balcony_jump1");
	balcony_jump2 anim_single_solo (level.hitman, "balcony_jump2");
	
	level.hitman set_force_color("b");	
	level.hitman.script_pushable = 1;
}	


hvt_courtyard_carry()
{
	level endon ("FLAG_hvt_escape_hvt_captured");
	currently_looping_node = getent ("pinned_node", "targetname");
	//currently_looping_node notify( "stop_wounded_idle" );
	currently_looping_node notify( "stop_loop" );
	
	//MOVE HVT TO FOUNTAIN
	
	//Grinch you're up!
	//radio_dialogue( "ac130_snd_grinchyoureup" );
	//radio_dialogue( "ac130_rno_bossman" );
		
	level.bishop StopAnimScripted();
	level.makarov_number_2 StopAnimScripted();
	level.makarov_number_2 .loops = 0;
	wait(.10);
	level.bishop.animname = "generic";
	level.makarov_number_2.animname = "generic";
	wait(.10);
	node = getstruct( "hvt_loop", "targetname" );
	level.makarov_number_2.woundedNode = node;
	level.makarov_number_2.woundedNode thread anim_generic_loop( level.makarov_number_2, "wounded_idle", "stop_wounded_idle" );
	wait(.15);
	
	node = getent ("hvt_carry_fountain", "targetname");
	
	//Youre going to get me killed!
	level.makarov_number_2 delaythread(8, ::play_sound_on_entity, "ac130_vlk_getmekilled" );
	
	level.bishop maps\_carry_ai::move_president_to_node( level.makarov_number_2, node );
	//level.bishop maps\_carry_ai::move_president_to_node_nopickup( level.makarov_number_2, node );
	
	Objective_Position(  obj( "OBJ_flank_mg_nest" ), level.makarov_number_2.origin +(0,0,55) );
	//objective_onentity(  obj( "OBJ_flank_mg_nest" ), level.makarov_number_2 );
	Objective_SetPointerTextOverride( obj( "OBJ_flank_mg_nest" ), &"PARIS_AC130_OBJ_PROTECT" );
	
	//Bishop goes to cover node after putting down HVT
	cover_hvt_node = getnode ("bishop_cover_hvt", "targetname");
	level.bishop setgoalnode (cover_hvt_node);
	
	//I think we got their attention!
	//radio_dialogue( "ac130_rno_attention" );
	// "I hope the kill you all!"
	level.makarov_number_2 thread play_sound_on_entity("ac130_vlk_killyouall");
	
	//to parking lot after tank is destroyed
	flag_wait ("hvt_tank_destroyed");
	Objective_Position( obj( "OBJ_flank_mg_nest" ), (0,0,0) );
	
}	

hvt_tank_entrance()
{
	spawners = getentarray ("new_tank_guys", "targetname");
	array_thread(spawners, ::add_spawn_function, ::new_tank_guys_logic);
	
	fence_pristine = getentarray("courtyard_fence_des_a_pristine", "targetname");
	fence_pristine_models = getentarray("courtyard_fence_des_a_pristine_models", "targetname");
	
	fence_damaged = getentarray("courtyard_fence_des_a_damage", "targetname");
	fence_damaged_models = getentarray("courtyard_fence_des_a_damage_models", "targetname");
	
	wallgate_pristine = getentarray("wallgate_pristine", "targetname");
	wallgate_damaged = getentarray("wallgate_damage", "targetname");
	
	courtyard_gate_target = getstruct ("courtyard_gate_target", "targetname");
	
	//send in tank
	courtyard_tank_end = getvehiclenode ("courtyard_tank_end", "script_noteworthy");
	
	array_thread(fence_pristine, ::hide_me, 1);
	array_thread(fence_pristine_models, ::hide_me);
	array_thread(wallgate_damaged, ::hide_me);

	flag_wait("hvt_courtyard_clear");
	struct = getstruct ("tank_entrance_fx", "targetname");
	
	play_sound_in_space( "scn_ac130_tank_courtyard_arrive", struct.origin);
	
	//spawn tank enemies 
	new_tank_guys = array_spawn_targetname("new_tank_guys");
	
	//play tank fire sound....blow up wall 
	fwd = VectorNormalize( AnglesToForward(struct.angles) );
	earthquake(.6, 2, level.player.origin, 100);
	thread play_sound_in_space( "t72_fire", struct.origin);
	playfx( level._effect["FX_osprey_explosion"],struct.origin, fwd );
	array_thread(wallgate_pristine, ::hide_me, 1); 
	array_thread(wallgate_damaged, ::show_me);
	wait(.2);
	level thread play_sound_in_space ("scn_ac130_tank_courtyard_wall", struct.origin);
	level.player playrumblelooponentity ("damage_heavy");
	level.player delaycall (2, ::stoprumble, "damage_heavy" );
	
	wait(1);
	
	//need time for new tank troops to come through the gate. Bad place created by tank delays them. 
	courtyard_tank_spawner = getent ("courtyard_tank", "targetname");
	courtyard_tank = courtyard_tank_spawner thread spawn_vehicle_and_gopath();
	wait(.10);
	courtyard_tank thread godon();
	courtyard_tank.health = 999999;
	courtyard_tank.mgturret[0] setmode("manual");
	courtyard_tank.mgturret[0] thread courtyard_tank_mg_logic();
	courtyard_tank setvehicleteam ("axis");
	courtyard_tank thread check_for_player_touching();
	
	wait(1.5);
	
	level thread hvt_strobe_tank_detection(courtyard_tank);

	courtyard_tank thread play_sound_on_entity("scn_ac130_tank_courtyard_move");
	
	//playfx(level._effect[ "debris_explosion" ] , courtyard_gate_target.origin);

	level.player EnableInvulnerability();
	earthquake(.3, 1, level.player.origin, 1000);
	wait(1.5);	
	tank_target_pillars = getstruct ("tank_target_pillars", "targetname");
	courtyard_tank  SetTurretTargetVec(tank_target_pillars.origin -(0, 0, 30) );
	wait(1.5);
	courtyard_tank FireWeapon();
	wait(.8);
	level thread hvt_knock_player_off_turret();
	wait(.6);
	earthquake(.5, 1, level.player.origin, 100);
	
	//continue to fire at player and delta
	courtyard_tank thread courtyard_tank_main_turret_logic();
	wait(2);
	level.player DisableInvulnerability();

}

check_for_player_touching()
{
	//self is tank
	self endon( "death" );
	level endon( "c130_shooting_tank" );
	
	while(1)
	{
		dist = Maps\_utility_chetan::distance_2d_squared( self.origin, level.player.origin );
		if( dist < 400*400 )
		{
			//Walk right up to the tank = you're dead  =)
			spot = level.player.origin + (0,0,100);
			magicbullet( "ac130_105mm_alt2", spot, level.player.origin );
			wait(5);			
		}	
		wait(.20);
	}	
}	



hvt_knock_player_off_turret()
{
	turret = getent("player_turret", "script_noteworthy");

	if( flag( "player_on_dshk_turret" )&& !flag("player_dismounting_turret") )
	{
		level.player FreezeControls(true);
		if(isdefined(turret.usable_turret_trigger))
		{
			turret.usable_turret_trigger delete();
		}
		level.player notify("turret_dismount");
		level.player ShellShock("default", 2);
		turret Maps\_dshk_player::handle_dismount();	
	}
	
	//wait(.10);
	turret makeunusable();
	turret setdefaultdroppitch(12);
			
	if(isdefined( level.player.disomount_hint ))
	{
		level.player.disomount_hint destroy();
	}
	
	if(isdefined( level.player.mount_hint ))
	{
		level.player.mount_hint destroy();
	}
	
	if(isdefined( self.player_rig ))
	{
		self.player_rig delete();
	}
	
	if(level.player isLinked() )
	{
		level.player unlink();
	}	
	
	level.player FreezeControls( false );
	level.player enableweapons();
	
	while(flag( "player_dismounting_turret" ) )
	{
		wait(.05);
	}
	
	turret notify("death");	
	
	spot = turret gettagorigin("tag_weapon");
	playloopedfx( level._effect[ "turret_smoke" ], 1, spot - (0,0,15) );//tag_dummy tag_weapon
	//playFX( level._effect[ "FX_osprey_engine_smoke" ], spot );
}		


hvt_tank_check_player_distance()
{
	//self = hvt tank
	self endon ("death");
	level endon ("hvt_tank_destroyed");
	trig = getent ("hvt_street", "targetname" );
	
	while( level.player istouching(trig) )
	{	
		self SetTurretTargetVec( level.player geteye()  );
		wait(randomfloatrange(1, 2.5));	
		self FireWeapon();
		wait(2);
	}	
		
	return;			

}

hvt_tank_destruction(courtyard_tank)
{		
	//Metal zero one, engaging the target, danger close
	radio_dialogue( "ac130_plt_gotyourmark" );
	wait(2.6);
	musicstop(4);
	spot = getent ("105_shoot", "targetname");	
	spot.origin = (1750, 41099, 5943); //moving source of bullets to slamout origin
	
	//c130 kills tank:
	courtyard_tank thread godoff();
	courtyard_tank.health = 10000;
	tank_spot = courtyard_tank.origin;
	
	spot thread c130_fires_25(courtyard_tank.origin, 15);
	
	//destroy the destuctible cars in the vicinity
	dest_car_spots = getstructarray ("destructible_vehicle_target", "targetname");
	foreach(b in dest_car_spots)
	{
		magicbullet ("ac130_40mm_air_support_strobe", spot.origin, b.origin);
		wait( randomfloatrange(.4, .8) );
		earthquake(.4, .35, level.player.origin, 100);
		magicbullet ("ac130_40mm_air_support_strobe", spot.origin, b.origin);
		wait( randomfloatrange(.4, .8) );
		earthquake(.4, .35, level.player.origin, 100);
		//magicbullet ("ac130_105mm_alt2", spot.origin, b.origin);
	}	
	
	//C130 fires at tank x8
	for(i=0; i < 8; i++)
	{		
		num = randomintrange(50, 150);
		offset = (num, num, 0);	
		magicbullet ("ac130_40mm_air_support_strobe", spot.origin, tank_spot +offset);
		earthquake(.4, .35, level.player.origin, 100);
		wait(randomfloatrange(.15, .45));
	}	
	
	if(isAlive(courtyard_tank))
	{
		courtyard_tank dodamage (courtyard_tank.health + 200, courtyard_tank.origin);
	}	
	
	num = randomintrange(100, 200);
	offset = (num, num, 0);	
	projectile = magicbullet ("ac130_105mm_alt2", spot.origin, tank_spot);
	projectile waittill ("death");
	earthquake(.7, .6, level.player.origin, 100);
	level.player playrumblelooponentity ("damage_heavy");
	level.player delaycall (1.5, ::stoprumble, "damage_heavy" );
	
	spot c130_kill_remaining_baddies();
	//set_ambient("paris_ac130_courtyard1_ext");
	flag_set("hvt_tank_destroyed");	
	battlechatter_off("axis");
	
	level thread hvt_slamout();
	
}	

hvt_strobe_tank_detection(tank)
{
	level endon ("hvt_tank_destroyed" );
		
	flag_set ("hvt_air_strobe_start");

	level.player maps\_air_support_strobe::enable_strobes_for_player();
	level.player thread show_air_support_hint(120);
		
	while(1)
	{
		level.player waittill("grenade_fire", strobe, weaponName);
		if ( weaponName == "air_support_strobe" )
		{
			flag_set ("player_threw_strobe");
			//iprintlnbold("player threw strobe");
			strobe wait_for_notify_or_timeout ("missile_stuck", 3);
			dist = Maps\_utility_chetan::distance_2d_squared(strobe.origin, tank.origin);
			if(dist < 1000*1000)
			{
				//iprintlnbold("Strob close to tank");
				flag_set ("c130_shooting_tank");
				level thread hvt_tank_destruction(tank);
				wait(.5);
				level.player maps\_air_support_strobe::disable_strobes_for_player();
			}
			else
			{
				//strobe is too far from tank				
				//"Frost youre supposed to throw it AT the tank!"
				level.sandman thread play_sound_on_entity ("ac130_trk_throwitattank");
				
				flag_clear ("player_threw_strobe");
			}	
				
		}
	}		

}	

				
			
courtyard_tank_mg_logic()
{
	//self = mg on courtyard tank
	self.leftarc = 90;
	self.rightarc = 90;
	self.toparc = 20;
	self.bottomarc = 20;
	self settargetentity(level.player);
	self SetAISpread(3);	
	self thread auto_fire_til_flag("c130_shooting_tank");
	
	//while(isAlive(self.ownervehicle))
	//{	
		//iprintln("targeting player");
	//	self settargetentity(level.player);
	//	self SetAISpread(20);			
	//}	
}

courtyard_tank_main_turret_logic()
{
	
	//self = tank
	self endon ("death");
	while(1)
	{	
		hvt_tank_check_player_distance();
		
		num = randomintrange (200, 250);
		self SetTurretTargetVec(level.player.origin + (num, num, 0) );
		wait(randomfloatrange(1, 2.5));	
		self FireWeapon();
		wait(.4);
		guy = random(level.delta);
		self SetTurretTargetVec( guy.origin + (num, num, 0) );
		wait(randomfloatrange(1, 2.5));	
		self FireWeapon();
		wait( randomfloatrange(2.5, 3.2) );
	}	
}	

new_tank_guys_logic()
{
	self endon ("death");
	spots = getstructarray("tank_area", "targetname");
	self thread retreat_to_area(spots);

}	

show_air_support_hint(timeout)
{
	//self = player
	self endon( "death" );
	self endon( "stop_air_support_hint" );

	if(!isdefined(timeout))
	{
		timeout = 40;
	}	

	level.player ent_flag_wait( "flag_strobe_ready" );

	self.stop_air_support_hint = false;
	if(!using_strobe())
	{
		self thread stop_air_support_hint_on_notify( timeout );
		display_hint_timeout( "air_support_hint", timeout );
	}
}

stop_air_support_hint_on_notify( timeout )
{
	self endon( "death" );
	self endon( "stop_air_support_hint_timeout" );
	
	thread stop_air_support_hint_timeout( timeout );
	
	self waittill( "stop_air_support_hint" );
	self.stop_air_support_hint = true;
}

stop_air_support_hint_timeout( timeout )
{
	self endon( "death" );
	self endon( "stop_air_support_hint" );
	wait timeout;
	self notify( "stop_air_support_hint_timeout" );
}

using_strobe()
{
	return ( level.player.stop_air_support_hint || level.player GetCurrentWeapon() == "air_support_strobe" );
}

wait_for_strobe_hit()
{
	
	total_killed = 0;
	while(total_killed < 3)
	{
		level waittill("air_support_strobe_killed", num_killed);
		total_killed += num_killed;
	}	
}

hvt_did_player_go_to_bedroom()
{
	level endon ("hvt_squad_to_fountain");
	level.player_upstairs = 0;
	//TODO endon
	trigger_wait_targetname ("player_bedroom_approach");
	flag_set ("player_went_to_bedroom");
	
	trig = getent("player_upstairs_detector", "targetname");

	while(1)
	{
		if(level.player istouching (trig) )
		{
			level.player_upstairs = 1;
		}
		else
		{	
			level.player_upstairs = 0;
		}
		wait(.05);
	}			
}	

hvt_enemy_management()
{
	wave1_guys_spawners = getentarray ("courtyard_wave1", "targetname");
	array_thread( wave1_guys_spawners, ::add_spawn_function, ::hvt_courtyard_enemy_logic, 32, 1);
	
	main_courtyard_floods = getentarray ("main_courtyard_floods", "targetname");
	array_thread( main_courtyard_floods, ::add_spawn_function, ::hvt_courtyard_enemy_logic, undefined, 1);
	
	tank_guys = getentarray ("tank_squad", "targetname");
	array_thread( tank_guys, ::add_spawn_function, ::tank_guys_logic);
	
	window_guys_spawners = getentarray ("window_guys", "targetname");
	array_thread( window_guys_spawners, ::add_spawn_function, ::window_guys_logic);
		
	outside_only_guys_spawners = getentarray ("outside_only_guys", "targetname");
	array_thread( outside_only_guys_spawners, ::add_spawn_function, ::hvt_courtyard_enemy_logic, 32, 1 );
	
	left_side_enemies_spawners = getentarray ("left_side_enemies", "targetname");
	array_thread( left_side_enemies_spawners, ::add_spawn_function, ::left_side_enemies_logic );
	
	tank_squad_spawners = getentarray("tank_squad", "targetname");
	array_thread( tank_squad_spawners, ::add_spawn_function, ::window_guys_logic);
	
	
	//roof rpg guys c130 targets in second building
	roof_rpg_guys = getentarray("roof_rpg_guy", "targetname");
	rpg_guys = array_spawn(roof_rpg_guys, 1);
	wait(.10);
	foreach(guy in rpg_guys)
	{
		guy.goalradius = 24;
		guy thread rpg_roof_guy_logic();
	}	
	vehicle_scripts\_ac130::hud_add_targets( rpg_guys  );
	
	level thread hvt_mg_turret_setup();

	flag_wait("player_shot_yellow_building");

	wave1_guys = array_spawn_targetname ("courtyard_wave1");
	wait(1);
	//activate_trigger_with_noteworthy ("garden_fight_start");
	
	maps\_spawner::flood_spawner_scripted( main_courtyard_floods );
	
	courtyard_chopper = spawn_vehicle_from_targetname_and_drive	("courtyard_chopper");
	wait .10;
	courtyard_chopper thread maps\_vehicle::godon();
	
	flag_wait("hvt_slamzoom_complete");
	
	//delete guys in building
	rpg_guys = array_removeundefined( rpg_guys );
	array_delete(rpg_guys);
	
	//when squad moves up, enemies move back to fountain
	flag_wait ("squad_to_courtyard");
	spots = getstructarray ("fountain", "targetname");
	
	main_courtyard_floods = array_removeundefined( main_courtyard_floods );
	array_delete( main_courtyard_floods );
	
	axis = getAiarray("axis");
		
	for(i=0; i < 6; i++)
	{
		if(isdefined(axis[i]))
		{
			axis[i] thread retreat_to_area(spots);
		}	
	}
	
	//squad at pos2 in garden..spawn window guys
	flag_wait ("squad_garden_pos2");
	
	//2 enemies come fromt he right and go to fountain
	//left_side_enemies = array_spawn(left_side_enemies_spawners);
	
	//find out how many enemies on monument. Wait til theres only X left. 
	trig = getent ("monument_trig", "targetname");
	
	enemies_on_monument = [];
	while(1)
	{
		enemies_on_monument = trig get_ai_touching_volume("axis");
		
		//if the array size is X or less get out of loop
		if(	enemies_on_monument.size <= 3 )		
		{
			break;
		}
		wait(.5);
	}		
	
	flag_set ("hvt_monument_clear" );
	
	//squad to fountain thingy
	flag_wait ("hvt_squad_to_fountain");
	
	//send baddies outside
	spots = getstructarray("street_area", "targetname");
	guys = getaiarray("axis");
	array_thread ( guys, ::retreat_to_area, spots);	
	
	
	tank_squad = array_spawn( tank_squad_spawners );
	
	//bottom_window_guys_spawners = getentarray("bottom_window_guys", "targetname");
	//bottom_window_guys = array_spawn( bottom_window_guys_spawners );
	
	//guys in the windows of embassy
	windows_guys = array_spawn(window_guys_spawners);
	
	//wait for player to get on Monument. baddies come from left and take cover in front of windows. 
	wait(10);
	
	outside_only_guys_spawners = getentarray("outside_only_guys", "targetname");
	level.outside_only_guys = array_spawn( outside_only_guys_spawners );
	
	//time to fight
	wait(10);
	
	axis = getaiarray("axis");
	while(axis.size > 5)
	{
		axis = getaiarray("axis");
		wait(1);
	}	
	
	flag_set("hvt_courtyard_clear");

}	

left_side_enemies_logic()
{
	self.goalradius = 32;
	spots = getstructarray ("fountain", "targetname");
	self thread retreat_to_area(spots);	
}	

rpg_roof_guy_logic()
{
	self endon ("death");
	flag_wait ("player_shot_yellow_building");
	self.bulletsinclip = 0;
	self.a.rockets = 0;
}	
	

window_guys_logic()
{
	self endon("death");
	self.goalradius = 32;
	self.baseAccuracy = .7;
	flag_wait("hvt_courtyard_clear");
	wait(randomfloatrange(1.5, 2.3) );
	self die();		
}	

tank_guys_logic()
{
	self endon ("death");
	flag_wait("player_on_turret");
	self.baseAccuracy = .2;		
	flag_wait("hvt_courtyard_clear");
	spots = getstructarray("tank_area", "targetname");
	
	//iprintlnbold("tank_guys guys retreating to tank area");
	retreat_to_area(spots);
}

main_courtyard_guys_retreat_logic()
{
	self endon ("death");	
	flag_wait("player_on_turret");
	self.baseAccuracy = .2;	

	//iprintlnbold("main_floods  retreating to street area");
	spots = getstructarray("tank_area", "targetname");
	self retreat_to_area(spots);
		
	flag_wait("hvt_courtyard_clear");
	spots = getstructarray("tank_area", "targetname");
	//iprintlnbold("main_floods guys retreating to tank area");
	retreat_to_area(spots);

}	
	

hvt_mg_turret_setup()
{
	level endon ("turret_guy_dead");
	
	flag_wait("player_shot_yellow_building");//slamzoom begins
	turret_guy = getent ("turret_guy", "targetname");
	turret_guy_ai = turret_guy  spawn_ai();
	turret_guy_ai.ignoreme = true;
	turret_guy_ai.goalradius = 8;
	turret_guy_ai.ignoreSuppression = true;
	turret_guy_ai.ignorerandombulletdamage = true;
	turret_guy_ai thread magic_bullet_shield();
	turret = getent ("window_turret", "script_noteworthy");
	turret setmode("manual");
	turret_guy_ai thread set_flag_on_death("turret_guy_dead", turret);	
	turret thread turret_tracer_increase();
	//wait(10);
	
	//turret starts aiming left of player right away
	starting_spot = getstruct("window_target1", "targetname");
	ent = spawn("script_origin", starting_spot.origin);
	//turret settargetentity (ent);
	
	//wait for player to arrive
	flag_wait("hvt_slamzoom_complete");
	
	wait(5);
	
	//turret shoot across windows left to right
	spots = getstructarray("hvt_window_targets", "script_noteworthy");
	turret thread auto_fire_til_flag("end_turret_script_control", 1);
	ent delete();
	turret_guy_ai delaythread(8, ::stop_magic_bullet_shield);
	turret SetAISpread( 1 );	
	//structs at window bottoms
	foreach( spot in spots )
	{	
		ent = spawn("script_origin", spot.origin);
		turret settargetentity (ent);
		wait (.10);	
		ent delete();		
	}	
	
	delta_targets = level.delta;
	delta_targets = array_remove( delta_targets, level.hitman );
	delta_targets = array_remove( delta_targets, level.frost );
	target_ent = spawn("script_origin", (0,0,0) );
	window_trig = getent( "window_damage_trig", "targetname"); 
	window_trig thread fire_damage_on_player();
	//while anim scene plays, shoot player if standing
	while(!flag("player_went_upstairs")  )
	{
		stance = level.player GetStance();
		if(stance == "stand" || level.player istouching(window_trig))
		{
			turret settargetentity(level.player);		
		}
		else
		{
			guy = random (delta_targets);
			spot = guy geteye() +(0,0, 35) ;
			target_ent moveto(spot, .05);
			target_ent waittill ("movedone");
			target_ent linkto(guy);			
			turret settargetentity( target_ent );
		}		
	  wait(randomfloatrange(1, 2.5) );
	  if( target_ent isLinked() )
	  {
	  	target_ent unlink();
	  }	
	}	

	//release turret to Ai control
	flag_set ("end_turret_script_control");
	turret setmode("auto_ai");
	turret setturretteam("axis");
	turret SetAISpread( 20 );
	
	//turret_guy_ai thread stop_magic_bullet_shield();
	turret_guy_ai useturret (turret);	
	turret_guy_ai disable_danger_react();
	//turret thread close_guys_use_me();
	
	flag_wait("player_went_to_bedroom");
	turret_guy.health = 10;
	turret setmode("manual");
	turret thread auto_fire_til_flag("turret_guy_dead");
	
	while(!flag("turret_guy_dead"))
	{
		owner = turret getturretowner();
		if(IsDefined(owner) )
		{
			turret settargetentity(random ( level.delta ) );
			wait(randomfloatrange(1, 1.5));
		}
		else
		{
			turret_reclaim_owner( turret_guy_ai, turret );	
		}				
	}

}	

fire_damage_on_player()
{
	//self = pain_trig by window
	level.player endon("death" );
	level endon ("turret_guy_dead");
	while(1)
	{
		if(level.player istouching( self ) )
		{
			level.player DoDamage( 33, level.player.origin );
		}
		wait(.5);		
	}	
	
}


	
turret_reclaim_owner(guy, turret)
{
	if(isDefined(guy))
	{
		guy endon ("death");
		guy.ignoreall = true;
		guy setgoalpos(turret.origin);
		guy waittill("goal");
		guy useturret(turret);
		guy.ignoreall = false;
		return;
	}	
	return;			
}	

turret_tracer_increase()
{
	//self = turret
	level endon( "player_went_upstairs" );
	start = self gettagorigin("tag_flash");
	up = anglestoup(self.angles);
	fwd = anglestoforward( self.angles );
	while(1)
	{
		self waittill ("turret_fire");	
		playFX(level._effect["big_muzzle"], start, fwd, up);
		//start = self gettagorigin("tag_flash");
		//fwd = self gettagangles("tag_flash");
		//playFX(level._effect["FX_turret_tracer"], start, fwd);
	}	

}	

set_flag_on_death(the_flag, turret)
{
	self waittill ("death", attacker);
	flag_set(the_flag);		
	wait(.5);
	spot = turret gettagorigin("trigger");
	
	turret makeunusable();
	turret setdefaultdroppitch(12);
	playloopedfx( level._effect[ "turret_smoke" ], 1, spot);
	turret setmode("auto_ai");
	turret notify ("death");
	
}	

auto_fire_til_flag(ender_flag, owner)
{
	//self = turret
	self endon ("death");
	if(IsDefined(owner))
	{
		level endon ("turret_guy_dead");
	}	
	while(!flag(ender_flag) )
	{
		if(isDefined(self))
		{		
			self shootturret();			
			wait( randomfloatrange(.05,.30) );
		}	
		
	}	
	//iprintlnbold ("turret script control ended");	
}	


close_guys_use_me()
{
	//self = mg turret
	flag_wait("squad_to_courtyard");
	level endon ("squad_to_fountain"); 
	hot_spot = spawn("trigger_radius", self.origin -(0,0,47), 9, 70, 70);
	while(1)
	{
		my_owner = self getturretowner();
		if(!IsDefined(my_owner) )
		{
			hot_spot waittill ("trigger", who);
			if(isAlive(who))
			{
				who endon ("death");
				who.ignorall = 1;
				who.goalradius = 8;
				who setgoalpos(self.origin);
				who waittill("goal");
				self setmode("auto_ai");
				who useturret(self);
				who.ignoreall = 0;
				break;
				//who waittill ("death");
			}	
		}
		wait(1);
	}
}			

hvt_courtyard_enemy_logic(my_radius, no_nades)
{
	self thread set_my_threatbias( "axis" );
	
	self.a.disableLongDeath = true;
	
	if(isDefined(my_radius))
	{
		self.goalradius = my_radius;
	}	
	if(isDefined(no_nades))
	{
		self.grenadeammo = 0;
	}
	else 
	{
		if(randomint(100) > 66)
		{
			self.grenadeammo = 0;
		}
	}
	self thread main_courtyard_guys_retreat_logic();
	
		
}	

hvt_turret_barrel()
{
	barrel_shield = getent ("barrel_shield", "targetname");//script_brushmodel targeting exploding barrel 
	barrel_shield setcandamage(true);
	barrel = getent ("turret_barrel", "script_noteworthy");
	spot = barrel.origin +(0,0,50);
	chunks = getentarray ("turret_nest_debris", "script_noteworthy");
	
	while(1)
	{
		barrel_shield waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags, weapon );
		if(isdefined(attacker) && attacker == level.player) 
		{
			barrel destructible_force_explosion();
			playfx(level._effect[ "debris_explosion" ] , spot);
			earthquake(.4, .6, level.player.origin, 200);
			level thread play_sound_in_space("car_explode", spot);
			array_thread(chunks, ::launch_me);
			barrel_shield delete();
			return;
		}
	}	
}		
	
launch_me()
{	
	self physicslaunchclient(self.origin, (AnglesToForward(self.angles) * 20000 ) );
	
	wait(3);
	
	while(1)
	{
		if (!level.player can_see_origin( self.origin ) )
		{
			self delete();
			return;
		}		
		else
		{
			wait(1);
		}
	}	
					
}		
	
hvy_street_threat_bias()
{	
	level endon("FLAG_hvt_escape_hvt_captured");
	trig = getent("hvt_street", "targetname");
	trig waittill( "trigger" );

	while(1)
	{
		if(level.player istouching(trig))
		{
			level.player setthreatbiasgroup("street_player");
		}
		else		
		{
			level.player setthreatbiasgroup("allies");	
		}
		wait(.5);
	}	
	
}	
	
	
hvt_player_turret_threat_bias()
{
	turret = getent ("player_turret", "script_noteworthy");
	turret setleftarc(45);
	turret setrightarc(45);

	flag_wait ("hvt_squad_to_fountain");

	allies = getAIarray("allies");
	array_thread (allies, ::set_my_threatbias, "allies");
	//axis = getAIarray("axis");
	//array_thread (axis, ::set_my_threatbias, "axis");
	
	while(!flag("FLAG_hvt_escape_hvt_captured"))
	{
		turret waittill ("turretownerchange");	
		owner = turret getturretowner();
		if( isdefined(owner) && owner == level.player)
		{
			flag_set( "player_on_turret" );
			if(isdefined( level.player.maxhealth ) )
			{
				level.player.health = level.player.maxhealth;
			}	
			level.player setthreatbiasgroup("turret_player");			
			axis = getAIarray("axis");
			array_thread (axis, ::set_my_threatbias, "axis");
		}
		else
		{
			players_group = level.player getthreatbiasgroup();
			if(players_group == "turret_player")
			{
				level.player setthreatbiasgroup("allies");
				if(isdefined( level.player.maxhealth ) )
				{
					level.player.health = level.player.maxhealth;
				}	
			}
		}
	}
}				
	
set_my_threatbias(group)
{
	self setthreatbiasgroup(group);	
}	

retreat_to_area(spots)
{	
	//spots = array of structs
	if(!isDefined(self))
	  return;
	  
	self endon("death");
	self notify ("new_retreat_pos");
	self endon ("new_retreat_pos");	
	spot = random(spots);	
	self.goalradius = randomintrange(150, 200);
	wait(randomfloatrange(.2, 1) );
	self notify( "stop_going_to_node" );
	self.ignoresuppression = 1;
	self setgoalpos (spot.origin);
	//self thread Print3d_on_me("Going to "+ spot.targetname);
	//self thread draw_line_for_time( self.origin, spot.origin, 1, 0, 0, 3 );	
	self waittill("goal");
	//self thread Print3d_on_me("reached "+ spot.targetname);
	self.ignoresuppression = 0;
	self.goalradius = 400;
}	

retreat_and_die(node)
{
	self endon("death");
	self.ignoreall = 1;
	self.goalradius = 20; 
	self setgoalpos (node.origin);
	self waittill ("goal");
	self die();
}			
	
	
hvt_dialogue()
{ 
	wait 2;
	Objective_Add( obj( "OBJ_shoot_yellow_bldng" ), "current", &"PARIS_AC130_OBJ_SHOOT_COURTYARD_BUILDING" );
	
	// "We're taking more fire from the embassy!  Give us a hand!"
	radio_dialogue("ac130_snd_firefromembassy");
	//Metal zero 1, we can give you one pass and one pass only
	radio_dialogue("ac130_plt_onepassonly");
	
	level thread mission_fail_timer(45, "player_shot_yellow_building" );
	
	do_nags_til_flag("player_shot_yellow_building", undefined,  "ac130_fco_okhitem", "ac130_fco_engagebuilding", "ac130_fco_hitbuilding");
	
	flag_wait ("hvt_slamzoom_complete");	
	objective_state(obj( "OBJ_shoot_yellow_bldng" ),"done");	
	
	//obj on top of stairs 
	spot = (2848.5, 41653.5, 240 ); // 
	Objective_add( obj( "OBJ_flank_mg_nest" ), "current", &"PARIS_AC130_OBJ_FLANK_MG_NEST", spot);
	//stops the obj marker when player goes up stairs
	level thread obj_pos_monitor();
	flag_set ("courtyard_dialogue_complete");
	
	//Turret guy dead now...
	flag_wait("squad_to_courtyard");
	radio_dialogue( "ac130_snd_alrightletsgo" );

	Objective_string(  obj( "OBJ_flank_mg_nest" ), &"PARIS_AC130_OBJ_FIGHT_THROUGH_COURTYARD");
	
	battlechatter_on("allies");
	
	flag_wait("squad_garden_pos2");

	wait(.3);
	// "Grinch!  Keep Volk behind cover!"
	radio_dialogue("ac130_snd_volkcovered");
	// "Affirmative!"
	radio_dialogue("ac130_rno_affirmative");
	
	flag_wait("hvt_squad_to_fountain");
	// "We're gonna strongpoint that monument just ahead!  Grinch - bring Volk up when we're secure!"
	radio_dialogue("ac130_snd_strongpointmonument");
	//I'll be right behind you!
	radio_dialogue("ac130_rno_behindyou" );
	
	//the convoy should be here any minute!
	level.hitman delaythread(10, ::play_sound_on_entity, "ac130_trk_convoy" );
	
	flag_wait("hvt_courtyard_clear");
	
	wait(2);
	//tank!
	radio_dialogue( "ac130_trk_tank" );
	//talk to me warhammer, where are we at??
	level.sandman play_sound_on_entity( "ac130_snd_talktomewarhammer" );
	
	// "Zero One, we're back on station and available for ten mikes."
	radio_dialogue("ac130_plt_tenmikes");
	
	// "We have enemy armor right in front of us!  We're marking with smoke!"
	radio_dialogue( "ac130_snd_rightinfront" );
	
	flag_wait("hvt_air_strobe_start");
	
	wait(2);
	Objective_string(  obj( "OBJ_flank_mg_nest" ), &"PARIS_AC130_OBJ_THROW_STROBE");
	
	level thread do_nags_til_flag( "c130_shooting_tank", undefined, "ac130_snd_getsmokeontank" , "ac130_snd_putsmokeontank", "ac130_snd_markonthattank" );
	
	flag_wait("hvt_tank_destroyed");
	wait(2);
	
	objective_state(  obj( "OBJ_flank_mg_nest" ), "done" );
	
	// "You're all clear, Kilo 1-1."
	//radio_dialogue("ac130_plt_allclear");
	
}	

obj_pos_monitor()
{
	flag_wait_any("player_went_upstairs", "squad_to_courtyard");	
	Objective_Position( obj( "OBJ_flank_mg_nest" ), (0,0,0) );
}	



montior_weapon_switch()
{
	level.player waittill ("weapon_switch_started");
	flag_set ("end_sniper_kill_monitor");
	//iprintlnbold("aborting achievement monitor");
	
}	

first_floor_doors_open(guy)
{	
	level.sandman thread play_sound_on_entity ("wood_door_kick");
	left_door = getent ("1st_floor_left_door", "targetname");
	right_door = getent ("1st_floor_right_door", "targetname");
	
	left_door rotateyaw( 85, .2);
	left_door connectpaths();
	
	right_door rotateyaw( -85, .2);
	right_door connectpaths();
	
}	

hide_me(connect)
{
	self hide();	
	self notsolid();
	if(isdefined(connect))
	{
		self connectpaths();
	}		
}	
	
show_me()
{
	self show();	
}		
		

bridge_cleanup_ents()
{
	//-11910.2 X
	ents = getentarray ("destructible_vehicle", "targetname");
	wait(3);
	//ents = getentarray();
	x = -11910.2;
	//max_x = 83000;
	foreach( ent in ents )
	{       
		if ( ent.origin[ 0 ] > x  )
		{
			ent Delete();
		}
	}
}

spawn_looping_fx_delete_on_flag( origin, angles, fx_alias, delay, flag_ender, one_shot)
{	
	temp_fx_ent = spawn("script_model", origin);
	temp_fx_ent.angles = angles;
	temp_fx_ent setmodel( "tag_origin" );
	
	up = anglestoup( temp_fx_ent.angles );
	fwd = anglestoforward ( temp_fx_ent.angles );
	
	temp_fx_ent thread delete_me_on_flag( flag_ender );
	level endon ( flag_ender );
	if(!isDefined( delay ))
	{
		delay = 8;
	}	
	//so fx dont start in unison
	wait( randomintrange(2, 4) );
	
	if(isDefined(one_shot) )
	{
		PlayFXOnTag( getfx( fx_alias ), temp_fx_ent, "tag_origin" );
		return;
	}		
		
	while(1)
	{
		PlayFXOnTag( getfx( fx_alias ), temp_fx_ent, "tag_origin" );
		//PlayFX( getfx( fx_alias ), temp_fx_ent.origin, fwd, up );
		wait( delay + randomintrange(3, 6) );
	}	
	
}	

	
//MikeD Steez
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
