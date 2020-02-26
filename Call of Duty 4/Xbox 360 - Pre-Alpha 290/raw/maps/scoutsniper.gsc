#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\scoutsniper_code;

#using_animtree( "generic_human" );
main()
{	
	//flags
	flag_init( "initial_setup_done" );
	
	flag_init( "intro" );
	flag_init( "intro_patrol_guy_down" );
	flag_init( "intro_patrol_guys_dead" );
	flag_init( "intro_last_patrol_dead" );
	flag_init( "intro_leave_area" );
	flag_init( "intro_safezone" );
	flag_init( "intro_left_area" );
	
	flag_init( "church_patroller_dead" );
	flag_init( "church_patroller_faraway" );
	flag_init( "church_lookout_dead" );
	flag_init( "church_area_clear" );
	flag_init( "church_guess_he_cant_see" );
	flag_init( "church_run_for_it" );
	flag_init( "church_door_open" );
	flag_init( "church_and_intro_killed" );
	

	flag_init( "field");		
	flag_init( "drive_bmps" );

	//starts
	default_start( ::start_intro );
	add_start( "church", ::start_church );
	add_start( "church_x", ::start_church_x );
	add_start( "field", ::start_field );
	
	//globals
	maps\createart\scoutsniper_art::main();
	maps\_hind::main( "vehicle_mi24p_hind_woodland" );
	maps\_bmp::main( "vehicle_bmp" );
	maps\scoutsniper_fx::main();	
	maps\_load::main();
	maps\scoutsniper_anim::main();
	maps\_stealth::main();
	maps\_load::set_player_viewhand_model( "viewhands_player_marines" );//viewhands_marine_sniper
	animscripts\dog_init::initDogAnimations();
	maps\_compass::setupMiniMap( "compass_map_scoutsniper" );
	
	thread maps\scoutsniper_amb::main();

	//start everything after the first frame so that level.start_point can be
	//initialized - this is a bad way of doing things...if people are initilizing
	//things before they want their start to start, then they should wait on a flag
	waittillframeend;

	//these are the actual functions that progress the level
	thread objective_main();	
	switch( level.start_point )
	{
		case "default":	intro_main();
		case "church":	
		case "church_x":church_main();
	//	case "field":	field_main();
	}
}

/************************************************************************************************************/
/*													INTRO													*/
/************************************************************************************************************/

intro_main()
{
	flag_wait( "initial_setup_done" );
	level.player disableweapons();
	delaythread(12.5, ::giveweapons);
	delaythread(1, ::music_play, "scoutsniper_pripyat_music" );
	
	flag_set( "intro" );
	
	reference = getent( "price_start_node", "targetname" );
	reference thread anim_first_frame_solo( level.price, "scoutsniper_opening_price" );
	
	array_thread( getentarray( "patrollers", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai);
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai);
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::idle_anim_think);
	array_thread( getentarray( "tableguard_last_patrol", "targetname" ), ::add_spawn_function, ::intro_lastguy_think);
	
	delaythread(1, ::set_blur, 4, .25 );
	delaythread(4, ::set_blur, 0, 3 );
	
	thread intro_handle_leave_area_flag();
	thread intro_handle_safezone_flag();
	thread intro_handle_last_patrol_clip();
	thread intro_handle_leave_area_clip();
		
	delaythread( randomfloatrange( 3, 7 ), ::scripted_array_spawn, "patrollers", "script_noteworthy", true );
	delaythread( 1, ::scripted_array_spawn, "tableguards", "script_noteworthy", true );
	delaythread( 1, ::scripted_array_spawn, "intro_dogs", "script_noteworthy", true );
	
	wait 9;
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_radiation" );
	level delaythread( 5, ::function_stack, ::radio_dialogue, "scoutsniper_mcm_followme" );

	wait 1;
	
	level.price intro_runup( reference );
	level.price notify( "stop_dynamic_run_speed" );
	level.price intro_holdup();
	
	if( !flag( "_stealth_spotted" ) )
		autosave_by_name( "intro_shack" );
		
	level.price intro_cqb_into_shack();
	level.price ent_flag_set( "_stealth_stance_handler" );
	level.price intro_sneakup_patrollers();
	level.price ent_flag_clear( "_stealth_stance_handler" );
	
	if( !flag( "_stealth_spotted" ) )
		autosave_by_name( "intro_patrollers_killed" );
	
	level.price intro_sneakup_tableguys();
	level.price intro_avoid_tableguys();
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price intro_leave_area();
	if( !flag( "_stealth_spotted" ) )
		autosave_by_name( "intro_last_patroller_killed" );
	level.price thread intro_cleanup();
}
intro_handle_leave_area_clip()
{
	clip = getent("intro_leave_area_clip", "targetname");
	
	clip thread intro_handle_leave_area_clip_spotted();
	
	clip endon("death");
	level endon( "_stealth_spotted" );
	level endon( "church_intro" );
	
	while(1)
	{
		flag_waitopen( "intro_safezone" );
		clip geo_off();
		
		flag_wait( "intro_safezone" );
		clip geo_on();
	}
	
}

intro_handle_leave_area_clip_spotted()
{
	flag_wait_either( "_stealth_spotted", "church_intro" );
	
	self delete();
}

intro_handle_last_patrol_clip()
{		
	clip = getent("intro_last_patrol_clip", "targetname");		
	clip connectpaths();
	clip geo_off();
	
	level endon( "_stealth_spotted" );
	
	flag_wait( "intro_last_patrol" );
	clip thread intro_handle_last_patrol_clip_spotted();
	
	clip geo_on();
	clip disconnectpaths();
}

intro_handle_last_patrol_clip_spotted()
{
	flag_wait( "_stealth_spotted" );
	
	self connectpaths();
	self delete();
}

intro_handle_leave_area_flag()
{
	level endon( "_stealth_spotted" );
	level endon( "intro_last_patrol_dead" );
	level endon( "intro_left_area" );
	
	trig = getent( "intro_leave_area", "script_noteworthy" );
	trig trigger_off();
	
	flag_wait( "intro_last_patrol" );
	
	level.intro_last_patrol waittill("goal");

	trig trigger_on();
	
	while(1)
	{
		trig waittill("trigger", other);
		
		if( other == level.intro_last_patrol )
			break;
	}
	
	flag_set( "intro_leave_area" );
}

intro_handle_safezone_flag()
{
	level endon( "_stealth_spotted" );
	level endon( "church_intro" );
	
	safezone = getent("intro_leave_area_safe_zone", "targetname");
	
	while(1)
	{
		safe = true;
		ai = getaiarray("axis");
		for(i=0; i<ai.size; i++)
		{
			if( !( ai[i] istouching( safezone ) ) )
				continue;	
			
			safe = false;
			break;
		}
		
		if(safe)
		{
			if ( !flag( "intro_safezone" ) )
				flag_set( "intro_safezone" );
		}	
		else if( flag( "intro_safezone" ) )
			flag_clear( "intro_safezone" );
			
		wait .1;	
	}
}

intro_runup( ref )
{	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
		
	self allowedstances( "stand" );
	ref thread anim_custom_animmode_solo( self, "gravity", "scoutsniper_opening_price" );	
		
	//price moves to a stopping point
	node = getnode( "price_intro_path", "targetname" );
		
	length = getanimlength( self getanim("scoutsniper_opening_price") );
	wait length - .2;
	self stopanimscripted();
	
	level delaythread( 2, ::function_stack, ::radio_dialogue, "scoutsniper_mcm_dosimeter" );
	
	self delaythread( .1, ::dynamic_run_speed );
	self follow_path( node );
}

intro_holdup()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	node = getnode("price_intro_holdup","targetname");
	
	node anim_generic_reach_and_arrive( self, "stop2_exposed" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_standby" );
	
	node thread anim_generic( self, "stop2_exposed" );
	node waittill("stop2_exposed");
}

intro_cqb_into_shack()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	self enable_cqbwalk();
	node = getnode("price_intro_holdup2","targetname");
	
	node anim_generic_reach_and_arrive( self, "enemy_exposed" );
	
	thread dialogprint( "Price - Contact.", 1 );
	delaythread(1, ::dialogprint, "Price - Enemy patrol, dead ahead.", 2 );
		
	node thread anim_generic( self, "enemy_exposed" );
	node waittill("enemy_exposed");
	
	thread dialogprint( "Price - stay low", 2 );
	delaythread(3, ::dialogprint, "Price - Likely more inside, so keep it quiet.", 2 );
	
	node thread anim_generic( self, "down_exposed" );
	node waittill("down_exposed");
}

intro_sneakup_patrollers()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
		
	self thread intro_sneakup_patrollers_kill();
	self thread intro_sneakup_patrollers_death();
	self disable_cqbwalk();
	self.disablearrivals = true;
	self.disableexits = true;
	
	level endon( "intro_patrol_guys_dead" );
	
	node = getnode("price_intro_sneakup", "targetname");
	self follow_path( node );
	
	if( !flag( "intro_patrol_guy_down" ) )
		thread dialogprint( "Price - take him out when the other's not looking", 3 );
	
	flag_wait( "intro_patrol_guys_dead" );
}
intro_sneakup_patrollers_death()
{	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	flag_wait( "intro_patrol_guy_down" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_hesdown" );
		
	ai = get_living_ai_array("patrollers", "script_noteworthy");
	waittill_dead( ai );
	
	flag_set( "intro_patrol_guys_dead" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_goodnight" );
}

intro_sneakup_patrollers_kill()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	ai = get_living_ai_array( "patrollers", "script_noteworthy" );
	
	if( ai.size > 1 )
		waittill_dead(ai, 1);
	flag_set( "intro_patrol_guy_down" );
	
	level endon( "intro_patrol_guys_dead" );
	
	wait .5;
	
	while( self ent_flag( "_stealth_stay_still" ) )
		self waittill( "_stealth_stay_still" );
	
	enemy = get_living_ai("patrollers", "script_noteworthy");
	self.favoriteenemy  = enemy;
	self.ignoreall = false;
	
	enemy endon("death");
	
	self thread intro_sneakup_patrollers_moveto_kill( enemy );
	
	while( isalive( enemy ) )
	{
		enemy waittill( "damage", ammount, other );
		if( other == self && isalive( enemy ) )
			enemy dodamage( enemy.health + 100, self.origin );
	}
}

intro_sneakup_patrollers_moveto_kill( enemy )
{
	enemy endon("death");
	self notify( "stop_path" );
	
	while(1)
	{
		vec2 = vectornormalize( enemy.origin - self.origin);
		angles = vectortoangles( vec2 );
		diff = angles[1] - self.angles[1];
		
		yaw = 2;
		if( diff < 0 )
			yaw *= -1;		
		
		self orientMode( "face angle", self.angles[1] + diff );
		wait .05;
	}
}

intro_sneakup_tableguys()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("intro_last_patrol") )
		return;
	level endon("intro_last_patrol");
			
	self.favoriteenemy  = undefined;
	self.ignoreall = true;
	self.disablearrivals = false;
	self.disableexits = false;
	self allowedstances( "stand" );	

	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_move" );
	
	node = getnode("price_intro_tableguys_node1", "targetname");
	
	vec = vectornormalize(node.origin - self.origin);
	self maps\_stealth::friendly_spotted_getup_from_prone( vectortoangles( vec ) );
	
	self delaythread( .5, ::dynamic_run_speed );
	node anim_generic_reach_and_arrive( self, "stop_cornerR" );
	
	self notify( "stop_dynamic_run_speed" );
	
	thread dialogprint( "Price - Holdup, there's more cover if we go around.", 3 );
	
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	self.ref_node thread anim_generic( self, "stop_cornerR" );
	self.ref_node waittill("stop_cornerR");
	self.ref_node thread anim_generic( self, "onme_cornerR" );
	self.ref_node waittill("onme_cornerR");
	
	node = getnode("price_intro_tableguys_node2", "targetname");
	self set_goal_node(node);
	self.goalradius = node.radius;
	self waittill("goal");
	
	self allowedstances( "crouch" );
	
	node = getnode("price_intro_tableguys_node3", "targetname");
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	node anim_generic_reach_and_arrive( self, "enemy_cornerR" );
	
	thread dialogprint( "Price - We got 4 guys inside, stay low.", 2 );
	self.ref_node thread anim_generic( self, "enemy_cornerR" );
	self.ref_node waittill( "enemy_cornerR" );
}

intro_avoid_tableguys()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("intro_last_patrol_dead") )
		return;
	level endon("intro_last_patrol_dead");
	
	self allowedstances( "stand" );
	self.disablearrivals = false;
	self.disableexits = false;
			
	node = getnode("price_intro_tableguys_node4", "targetname");
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	self.ref_node anim_generic_reach_and_arrive( self, "stop_cornerR" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_waithere" ); 
	self.ref_node thread anim_generic( self, "stop_cornerR" );
	self.ref_node waittill( "stop_cornerR" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_contact" ); 
	self.ref_node thread anim_generic( self, "enemy_cornerR" );
	self.ref_node waittill( "enemy_cornerR" );
	
	self.goalradius = 4;
}

intro_leave_area()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	flag_wait_either( "intro_leave_area", "intro_last_patrol_dead" );
	
	node = getnode("price_intro_tableguys_node4", "targetname");
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	self.ref_node anim_generic_reach_and_arrive( self, "stop_cornerR" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_okgo" );
	wait .75;
	self.ref_node thread anim_generic( self, "moveout_cornerR" );
	
	self thread intro_leave_area_dialogue();
	node = getnode("price_intro_leave_node", "targetname");
	self thread follow_path( node );
}

intro_leave_area_dialogue()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	//first node
	self waittill("goal");
	//by barn
	self waittill("goal");
	//by car
	self waittill("goal");
	wait 1;
	level function_stack(::radio_dialogue, "scoutsniper_mcm_move" );
}

intro_lastguy_think()
{	
	level.intro_last_patrol = self;
		
	self thread intro_lastguy_death();
	self endon("death");
	
	flag_wait_either( "intro_last_patrol", "_stealth_spotted" );
	
	if( !flag( "_stealth_spotted") )
	{
		
		self.ref_node notify( "stop_loop" );
		self notify( "stop_loop" );
		self stopanimscripted();
				
		self.target = "intro_last_patrol_smoke";
		self thread maps\_patrol::patrol();
	}
}

intro_lastguy_death()
{
	self waittill("death");
	flag_set("intro_last_patrol_dead");
}

intro_cleanup()
{
	self thread intro_cleanup2();
	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	self waittill( "path_end_reached" );
	flag_set( "intro_left_area" );
}

intro_cleanup2()
{
	level endon( "intro_left_area" );
	
	flag_wait("_stealth_spotted");
	self notify("stop_path");
	waittill_dead_or_dying( getaispeciesarray( "axis", "all" ) );
	
	flag_waitopen( "_stealth_spotted" );
	
	flag_set( "intro_left_area" );
}

/************************************************************************************************************/
/*													CHURCH													*/
/************************************************************************************************************/
church_main()
{
	_flag = getent( "church_intro", "script_noteworthy" ); 
	_flag trigger_off();
	
	flag_wait( "intro_left_area" );
	
	_flag trigger_on();
	
	thread church_patroller();
	thread church_lookout();
		
	level.price church_runup();
	flag_wait( "church_intro" );
	level.price church_runup2();
	
	if( !flag( "_stealth_spotted" ) )
		autosave_by_name( "at_church" );
	level.price notify( "stop_dynamic_run_speed" );
	
	level.price church_holdup();
	level.price ent_flag_set( "_stealth_stance_handler" );
	level.price church_sneakup();
	level.price ent_flag_clear( "_stealth_stance_handler" );
	level.price church_moveup_car();
	level.price church_run_for_it();
	
	thread church_handle_area_killed();
	if( flag("_stealth_spotted") )
		waittill_dead_or_dying( getaiarray( "axis" ) );
	
	while( !flag( "church_door_open" ) )
		level.price church_open_door();
	
	level.price church_walkthrough();
	
	iprintlnbold("END OF LEVEL");
}

church_handle_area_killed()
{
	getaiarray( "axis" );
	waittill_dead_or_dying( getaiarray( "axis" ) );
	flag_set( "church_and_intro_killed" );	
}

church_runup()
{	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
		
	self allowedstances( "stand", "crouch", "prone" );
			
	//price moves to a stopping point
	node = getnode( "church_price_node1", "targetname" );	
	
	if( distance( node.origin, self.origin ) > 512 )
	{
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo" );
		self delaythread( .1, ::dynamic_run_speed );
	}	
	
	self follow_path( node );
}

church_runup2()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	self allowedstances( "stand", "crouch", "prone" );
	
	node = getnode( "church_price_node1", "targetname" );
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	self.ref_node thread anim_generic( self, "moveout_cornerR" );
	thread dialogprint( "Price - move up.", 1 );
		
	//price moves to a stopping point
	node = getnode( "church_price_node2", "targetname" );	
	
	self follow_path( node );
}

church_holdup()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("church_area_clear") )
		return;
	level endon("church_area_clear");
	
	node = getnode( "church_price_node2", "targetname" );	
	node anim_generic_reach_and_arrive( self, "stop_exposed" );
	
	thread church_holdup_dialogue( node );
	
	node thread anim_generic( self, "stop_exposed" );
	node waittill("stop_exposed");
	
	node thread anim_generic( self, "enemy_exposed" );
	node waittill("enemy_exposed");
	
	node thread anim_generic( self, "onme2_exposed" );
	node waittill("onme2_exposed");
}

church_holdup_dialogue( node )
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("church_area_clear") )
		return;
	level endon("church_area_clear");
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_standby" );
	node waittill("stop_exposed");
	if( !flag( "church_lookout_dead" ) )
	{
		dialogprint( "Price - We got a lookout in the church tower", 2 );
		if( !flag( "church_patroller_dead" ) )
			thread dialogprint( "Price - and a Patrol coming from the north", 2 );
	}
	else if( !flag( "church_patroller_dead" ) )
		thread dialogprint( "Price - We got a Patrol coming from the north", 2 );
		
	node waittill("enemy_exposed");
	level function_stack(::radio_dialogue, "scoutsniper_mcm_followme" );
}

church_sneakup()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	level endon( "church_area_clear" );
	level endon( "church_run_for_it" );
		
	node = getnode( "church_price_sneakup", "targetname" );
	self follow_path( node );
	
	flag_wait( "church_patroller_faraway" );
	flag_set( "church_run_for_it" );
}

church_moveup_car()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag( "church_run_for_it" ) )
		return;
	
	flag_waitopen( "_stealth_found_corpse" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_move" );
	
	node = getnode( "church_price_node_car", "targetname" );
	
	vec = vectornormalize(node.origin - self.origin);
	self maps\_stealth::friendly_spotted_getup_from_prone( vectortoangles( vec ) );
	
	self follow_path( node );
}

church_run_for_it()
{
	if( !flag( "church_run_for_it" ) )
		return;
	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag( "church_lookout_dead" ) )
		return;
	level endon("church_lookout_dead");
	
	self set_generic_run_anim( "sprint" );
	
	if( flag("church_guess_he_cant_see") )
		dialogprint( "Price - Guess he can't see the body from there.", 2.5 );
	
	else if( flag( "church_patroller_faraway" ) && !flag( "church_patroller_dead" ) )
		dialogprint( "Price - The patrol won't be back for a while, here's our chance.", 2.5 );
	
	angles = (0,45,0);
	vec1 = anglestoforward( angles );
	guy = get_living_ai("church_lookout", "script_noteworthy");
	
	vec2 = anglestoforward( guy.angles );
	if( vectordot( vec1, vec2 ) <= .9 )
		dialogprint( "Price - Get ready to move, wait for the spotter to turn around", 3 );
		
	while( isalive( guy ) )
	{
		vec2 = anglestoforward( guy.angles );
		if( vectordot( vec1, vec2 ) > .9 )
			break;
		wait .05;
	}
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_okgo" );
	node = getnode( "church_price_runforit", "targetname" );
		
	vec = vectornormalize(node.origin - self.origin);
	self maps\_stealth::friendly_spotted_getup_from_prone( vectortoangles( vec ) );
	
	self thread follow_path( node );
	
	self waittill("goal");
	self clear_run_anim();
	
	self waittill( "path_end_reached" );
}

church_lookout()
{
	spawner = getent( "church_lookout", "script_noteworthy" );
	spawner thread add_spawn_function( ::stealth_ai );
	spawner thread add_spawn_function( ::church_lookout_death );
	spawner thread add_spawn_function( ::church_lookout_think );
	spawner thread add_spawn_function( ::church_lookout_corpse );
	
	
	flag_wait( "church_intro" );

	thread scripted_array_spawn( "church_lookout", "script_noteworthy", true );
}

church_lookout_think()
{
	self endon( "death" );
		
	while( 1 )
	{
		self church_lookout_wait();
		
		if( !self ent_flag( "_stealth_running_to_corpse" ) )
			flag_set( "_stealth_spotted" );
				
		waittillframeend;
		self delaythread( 1, ::set_goal_pos, self.origin );
	}	
}

church_lookout_wait()
{
	self endon( "_stealth_running_to_corpse" );
	self endon( "_stealth_found_corpse" );
	level endon( "_stealth_found_corpse" );
	level endon("_stealth_spotted");
	
	self waittill( "enemy_alert_level_change" );
}

church_lookout_corpse()
{
	self endon( "death" );
	
	flag_wait( "_stealth_found_corpse" );
	wait .6;
	self setgoalpos( ( -34278, -1523, 584 ) );
	self.goalradius = 4;
}

church_lookout_death()
{
	self waittill( "death" );
	
	if( !flag("_stealth_spotted") )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_gothim" );
	
	flag_set( "church_lookout_dead" );
	if( flag( "church_patroller_dead" ) )
		flag_set( "church_area_clear" );	
}

church_patroller()
{
	spawner = getent( "church_smoker", "script_noteworthy" );
	spawner thread add_spawn_function( ::stealth_ai );
	spawner thread add_spawn_function( ::church_patroller_death );
	spawner thread add_spawn_function( ::church_patroller_faraway_trig );
	
	flag_wait( "church_intro" );

	thread scripted_array_spawn( "church_smoker", "script_noteworthy", true );
}

church_patroller_faraway_trig()
{
	self endon( "death" );
	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	trig = getent("church_patrol_faraway_trig", "targetname" );	
	
	while( 1 )
	{
		trig waittill( "trigger", other );
		if( other == self )
			break;
	}
	
	flag_set( "church_patroller_faraway" );
}

church_patroller_death()
{
	self waittill( "death" );
	origin = self.origin;
	
	if( !flag("_stealth_spotted") )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_tangodown" );
	
	flag_set( "church_patroller_dead" );
	if( flag( "church_lookout_dead" ) )
		flag_set( "church_area_clear" );
	else
	{
		lookout = get_living_ai( "church_lookout" , "script_noteworthy" );
		if( distance( origin, lookout.origin ) > ( level._stealth.corpse_sight_dist + 150 ) && !flag("_stealth_spotted") )
	 		flag_set( "church_run_for_it" );
	 	else
	 	{
	 		dialogprint( "Price - Shit, that lookout's gonna see the body.", 3 );
	 		wait 8;
	 		if( !flag( "_stealth_spotted" ) && !flag( "_stealth_found_corpse" ) )
	 		{
		 		flag_set( "church_run_for_it" );
		 		flag_set( "church_guess_he_cant_see" );
		 	}
	 	}
	}
}

church_open_door()
{
	if( flag( "_stealth_spotted" ) )
		flag_waitopen( "_stealth_spotted" );
	
	waittillframeend;
	
	level endon("_stealth_spotted");
		
	name = undefined;
	anime = undefined;
	function = undefined;
	
	if( flag( "church_and_intro_killed" ) )
	{
		name = "church_price_door_kick_node";
		anime = "open_door_kick";
		function = ::door_open_kick;
	}
	else
	{
		name = "church_price_door_slow_node";
		anime = "open_door_slow";
		function = ::door_open_slow;
	}
	
	if( flag( "church_and_intro_killed" ) )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_move" );
	
	node = getent( name, "targetname");
	node anim_generic_reach_and_arrive( self, anime );
	
	self.animname = "generic";
	if(	anime == "open_door_slow" )
		node anim_first_frame_solo( self, anime );
	
	while( distance( level.player.origin, self.origin ) > 200 )
		wait .1;
	
	self thread church_open_door_commit( node, anime, function );
	node waittill( anime );
}

church_open_door_commit( node, anime, function )
{	
	if( flag("_stealth_spotted") )
		return;
	
	flag_set( "church_door_open" );
	
	node thread anim_single_solo( self, anime );	
	
	self enable_cqbwalk();
	door = getent("church_door_front", "targetname");
	door [[ function ]]();
	self delaythread( 2, ::disable_cqbwalk );
}

church_walkthrough()
{
	ent = getent("church_price_look_around_node", "targetname");
	self set_goal_pos( ent.origin );
	self.goalradius = 90;
	
	self waittill("goal");
	self enable_cqbwalk();
	self anim_generic( self, "cqb_look_around" );
	
	ent = getent( ent.target, "targetname" ); 
	self set_goal_pos( ent.origin );
	self waittill("goal");
	
	self disable_cqbwalk();
	
	node = getnode("church_price_backdoor_node", "targetname");
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	self.ref_node anim_generic_reach_and_arrive( self, "moveout_cornerR" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_move" ); 
	self.ref_node anim_generic( self, "moveout_cornerR" );
}

/************************************************************************************************************/
/*													FIELD													*/
/************************************************************************************************************/

field_main()
{
	flag_wait( "initial_setup_done" );
	array_thread( getentarray( "field_guard", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai);
	array_thread( getentarray( "field_guard_delete", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai);
	array_thread( getentarray( "field_guard_delete", "script_noteworthy" ), ::add_spawn_function, ::deleteOnPathEnd);
	
	trigger = getent( "field_hind_flyover", "targetname" );
	trigger waittill( "trigger" );
		
	thread spawnFieldHind();
	
	flag_wait("field_price_standby");
	thread radio_dialogue_queue("macmillan_standby");
	
	wait 20;

	//thread dialogprint( "Price - Alright, let's move.", 3 );
	thread radio_dialogue_queue("macmillan_moveup");

	activate_trigger_with_targetname( "field_price_move" );

	thread spawnFieldBmps();

	trigger = getent( "field_price_getdown", "targetname" );
	trigger waittill( "trigger" );

	// get a notetrack in the animation for when to yell get down and thread this temporarily
	thread radio_dialogue_queue("macmillan_getdown");

	pronehide_node = getent( "pronehide_node", "targetname" );
	pronehide_node anim_reach_solo( level.price, "pronehide_dive" );
	pronehide_node anim_single_solo( level.price, "pronehide_dive" );
	//pronehide_node thread anim_loop_solo( level.price, "pronehide_idle", undefined, "stop_all_idle" );
	pronehide_node thread anim_first_frame_solo( level.price, "pronehide_idle" );
	
	// temp until stance notetrack is added to the animation
	level.price.a.stance = "prone";
	
	delaythread(1, ::music_play, "scoutsniper_surrounded_music" );

	flag_set( "drive_bmps" );
	thread spawnFieldGuards();
}

spawnFieldHind()
{
	field_hind = spawn_vehicle_from_targetname_and_drive( "field_hind" );
}

spawnFieldBmps()
{
	//field_bmp1 = spawn_vehicle_from_targetname_and_drive( "bmp1" );
	field_bmp1 = spawn_vehicle_from_targetname( "bmp1" );
	field_bmp2 = spawn_vehicle_from_targetname( "bmp2" );
	field_bmp3 = spawn_vehicle_from_targetname( "bmp3" );
	field_bmp4 = spawn_vehicle_from_targetname( "bmp4" );

	field_bmp1 thread execVehicleStealthDetection();
	field_bmp2 thread execVehicleStealthDetection();
	field_bmp3 thread execVehicleStealthDetection();
	field_bmp4 thread execVehicleStealthDetection();

	flag_wait("drive_bmps");
	thread gopath( field_bmp1 );

	wait 1;
	thread gopath( field_bmp2 );

	wait 2;
	thread gopath( field_bmp3 );

	wait 0.5;
	thread gopath( field_bmp4 );
}

spawnFieldGuards()
{
	thread scripted_array_spawn( "field_guard_delete", "script_noteworthy", true );
	thread scripted_array_spawn( "field_guard", "script_noteworthy", true );
	wait 10;
	thread scripted_array_spawn( "field_guard2", "script_noteworthy", true );
}

deleteOnPathEnd()
{
	self waittill( "reached_path_end" );
	self delete();
}

/************************************************************************************************************/
/*												OBJECTIVES													*/
/************************************************************************************************************/

objective_main()
{
	//hotel_entrance = getent( "hotel_entrance", "targetname" );
	objective_add( 1, "active", "Follow Cpt. MacMillan" );
	objective_current( 1 );
	thread objective_price();
}

objective_price()
{
	while(1)
	{
		objective_position( 1, level.price.origin );
		wait .05;
	}
}

/************************************************************************************************************/
/*											START POINT INITS												*/
/************************************************************************************************************/

turn_off_triggers()
{
	/*switch(level.start_point)
	{
		"field":{
		}
				
	}*/
}

start_intro()
{
	start_common();
	
	flag_set( "initial_setup_done" );
}

start_church()
{
	start_church_x();
	
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai);
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::idle_anim_think);
	array_thread( getentarray( "tableguard_last_patrol", "targetname" ), ::add_spawn_function, ::intro_lastguy_think);
	
	delaythread( .1, ::scripted_array_spawn, "tableguards", "script_noteworthy", true );
	delaythread( .1, ::scripted_array_spawn, "intro_dogs", "script_noteworthy", true );
}

start_church_x()
{
	start_common();
	
	level.price teleport_actor( getnode( "church_price_node1", "targetname" ) );
	teleport_player( "church" );
	
	flag_set_delayed( "intro_last_patrol", 2 );
	flag_set( "intro_left_area" );
}

start_field()
{
	start_common();
	level.price teleport_actor( getnode( "price_field_start", "targetname" ) );
	teleport_player();
}

start_common()
{
	initLevel();
	initPlayer();
	initPrice();
	initDogs();
	turn_off_triggers();
	miscprecache();
}

miscprecache()
{
	precacheitem("flash_grenade");
	precacheModel("tag_origin");
}

initLevel()
{
	level.cosine["180"] = cos(180);
	level.minBMPexplosionDmg = 50;
	level.maxBMPexplosionDmg = 100;
	level.bmpCannonRange = 2048;
	level.bmpMGrange = 850;
	level.bmpMGrangeSquared = level.bmpMGrange * level.bmpMGrange;
	
	thread initRadiation();
	thread initProneDOF();
	thread updateFog();//should move this into a fcuntion closer to where it happens
	
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	array_thread( getentarray( "clip_nosight", "targetname" ), ::clip_nosight_logic );
	
	createthreatbiasgroup( "price" );
	createthreatbiasgroup( "dog" );
	setignoremegroup( "price", "dog" );
}

initPlayer()
{
	level.player setthreatbiasgroup( "allies" );
	level.player delaythread(.3, ::stealth_ai );
	delaythread(1, ::player_prone_DOF );
	thread player_health_shield();
}

giveweapons()
{
	level.player enableweapons();
	
}

player_health_shield()
{
	level.player enableHealthShield( false );
	
	while(1)
	{
		level.player waittill("death");
		level.player enableHealthShield(true);
	}	
}

initPrice()
{
	spawner = getent( "price", "script_noteworthy" );
	level.price = spawner dospawn();
	level.price.ref_node = spawn("script_origin", level.price.origin);
	spawn_failed( level.price );
	assert( isDefined( level.price ) );
	
	level.price.fixednode = false;	
	level.price.ignoreall = true;
	level.price.ignoreme = true;
	level.price disable_ai_color();
	
	level.price setthreatbiasgroup( "allies" );
	level.price delaythread(.3, ::stealth_ai );
	level.price delaythread(.4, maps\_stealth::friendly_spotted_handler );
	level.price delaythread(.4, maps\_stealth::friendly_stance_handler );
	
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	level.price make_hero();
	level.price setthreatbiasgroup( "price" );
}

