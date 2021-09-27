#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_escape_code;
#include maps\_shg_common;
#include animscripts\utility;


// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_dumpster()
{
	move_player_to_start( "start_dumpster" );
	
	if( !isdefined( level.player ) )
	{
		level.player = getentarray( "player", "classname" )[ 0 ];
	}
	
	setup_hero_for_start( "price", "dumpster" );
	setup_hero_for_start( "soap", "dumpster" );
	
	flag_set( "queue_sniper_music" );
	flag_set( "queue_player_carry_music" );
	flag_set( "queue_price_carry_music" );	 
	
	level thread maps\prague_escape::handle_prague_escape_music();
	maps\prague_escape_sniper::prague_escape_skippast_cleanup();
	
	//spawn chopper 
	level.cough_alley_chopper = spawn_vehicle_from_targetname("cough_alley_chopper" );
	wait(.10);
	level.cough_alley_chopper.target_offset = undefined;	
	node = getstruct("statue_wait_node", "script_noteworthy" );
	level.cough_alley_chopper vehicle_teleport( node.origin, node.angles );
	level.cough_alley_chopper.attachedpath = node;	
	level.cough_alley_chopper thread vehicle_paths( node );
	
}


// Main Functions	/////////////////////////////////////////////////////////////////////////////////////
dumpster_main()
{
	autosave_by_name( "dumpster" );
	level thread magic_bullets_at_window();
	player_loadout();
	dead_resistance();
	dumpster_to_doorway();
	clear_room_battle();
}


player_loadout()
{
	level.player EnableWeapons();
	
	level.price forceUseWeapon( "deserteagle", "primary" );
	level.soap forceUseWeapon( "p99", "primary" );
	
	level.price notify( "stop_going_to_node" );
}


dead_resistance()
{
	m_deadguys_01 = GetEntArray( "dead_guy_01", "targetname" );
	
	foreach( m_deadguy01 in m_deadguys_01 )
	{
		m_deadguy01 Attach( "head_prague_civ_hero_male_a", "", true );
		m_deadguy01.headmodel = "head_prague_civ_hero_male_a";
		m_deadguy01 useanimtree( level.scr_animtree[ "dead_guy" ] );
		m_deadguy01.animname = "dead_guy";
		m_deadguy01 anim_last_frame_solo( m_deadguy01, "resist_death01" );
	}
	
	m_deadguys_02 = GetEntArray( "dead_guy_02", "targetname" );
	
	foreach( m_deadguy02 in m_deadguys_02 )
	{
		m_deadguy02 Attach( "head_prague_civ_hero_male_b", "", true );
		m_deadguy02.headmodel = "head_prague_civ_hero_male_b";
		m_deadguy02 useanimtree( level.scr_animtree[ "dead_guy" ] );
		m_deadguy02.animname = "dead_guy";
		m_deadguy02 anim_last_frame_solo( m_deadguy02, "resist_death02" );
	}
	
	m_deadguys_03 = GetEntArray( "dead_guy_03", "targetname" );
	
	foreach( m_deadguy03 in m_deadguys_03 )
	{
		m_deadguy03 Attach( "head_prague_civ_hero_male_c", "", true );
		m_deadguy03.headmodel = "head_prague_civ_hero_male_c";
		m_deadguy03 useanimtree( level.scr_animtree[ "dead_guy" ] );
		m_deadguy03.animname = "dead_guy";
		m_deadguy03 anim_last_frame_solo( m_deadguy03, "resist_death03" );
	}
}


#using_animtree( "generic_human" );
//////////////////////////////////////////////////////////////
// Price helps Soap up and supports him to the doorway
//////////////////////////////////////////////////////////////
dumpster_to_doorway()
{
	level thread objectives_dumpster();
	level thread player_enter_room();
	level thread ignore_squad();
	level thread fake_destruction_chinashop();
		
	a_m_boxes = [];
	a_m_boxes[0] = level.m_link_box1;
	a_m_boxes[1] = level.m_link_box2;
	a_m_boxes[2] = level.m_link_box3;
	a_m_boxes[3] = level.m_link_box4;
	a_m_boxes[4] = level.m_link_box5;
	a_m_boxes[5] = level.m_link_box6;
	
	array = [];
	array[0] = level.price;
	array[1] = level.soap;
	array[2] = level.m_link_box1;
	array[3] = level.m_link_box2;
	array[4] = level.m_link_box3;
	array[5] = level.m_link_box4;
	array[6] = level.m_link_box5;
	array[7] = level.m_link_box6;
	
	a_ai_actors = make_array( level.price, level.soap );
		
	s_align = getstruct( "anim_align_dumpster", "targetname" );
	
	s_align thread anim_loop( a_m_boxes, "idle_room" );
	
	level.price thread vo_dumpster();
	
	flag_set( "queue_price_carry_music" );

	level.price delaythread( .05, ::play_sound_on_entity, "ch_pragueb_4_1_priceliftsoap_price" );
	s_align anim_single( a_ai_actors, "soap_lift_dumpster" );
	
	level.soap castshadows();
	
	level thread door_dumpster();
	
	flag_set( "vo_this_way" );
	
	level.price delaythread(.05, ::play_sound_on_entity, "ch_pragueb_4_2_kickdoor_price" );
	s_align anim_single( a_ai_actors, "kickdoor_dumpster" );
	
	s_align notify( "stop_loop" );
	
	level thread box_fx();
	
	flag_set( "vo_cmon_son" );
	
	level.price delaythread(.05, ::play_sound_on_entity, "ch_pragueb_4_3_reachroom_price" );
	s_align anim_single( array, "reachroom" );
	
	s_align thread anim_loop( a_ai_actors, "idle_roomclear" );
	
	flag_wait( "player_enter_store" );
	
	s_align notify( "stop_loop" );
	
	level.price disable_sprint();
}


box_fx()
{
	wait 1.2;
	
	exploder( 425 );	
}


//////////////////////////////////////////////////////////////////////////////////
// Price and Soap follow player into shop and clear the room of enemies //
//////////////////////////////////////////////////////////////////////////////////
clear_room_battle()
{
	level thread player_spotted_timer();
		
	a_actors = make_array( level.price, level.soap );
	
	s_align = getstruct( "anim_align_dumpster", "targetname" );
	
	flag_wait( "store_go_hot" );
	
	level.price delaythread(.05, ::play_sound_on_entity, "ch_pragueb_4_4_reachdoor_price" );
	s_align anim_single( a_actors, "reachdoor" );
	
	s_align thread anim_loop( a_actors, "clearroom" );
	
	flag_set( "reached_door" );
	
	level thread room_clear();
	
	flag_wait( "room_clear" );
	
	battlechatter_off( "allies" );
	
	s_align notify( "stop_loop" );
	
	s_align thread anim_loop( a_actors, "idle_clearroom" );
	
	level thread door_breach();
}

player_spotted_timer()
{
	wait 2.5;
	
	flag_set( "store_go_hot" );
}


/////////////////////////////////////////////////
// enemy breaches door, Soap shoots him //
/////////////////////////////////////////////////
door_breach()
{
	level.price waittill_player_lookat( 0.8 );
	
	flag_set( "door_breached" );
	
	level thread door_store();
	
	flag_set( "vo_nice_one" );
	
	sp_door_spawner = getent( "door_breach_guy", "targetname" );
	level.ai_door_breacher = sp_door_spawner spawn_ai( true );
	
	s_align = getstruct( "anim_align_dumpster", "targetname" );
	
	s_align notify( "stop_loop" );
	
	a_actors = make_array( level.price, level.soap );
	
	level.price delaythread( .10, ::play_sound_on_entity, "ch_pragueb_4_4_doorbreach_price" );
	s_align thread anim_single_solo( level.ai_door_breacher, "doorbreach" );
	s_align anim_single( a_actors, "doorbreach" );
	
	flag_set( "breach_done" );
	
	wait 0.5;
	
	autosave_by_name( "door_breach" );
}


vo_dumpster()
{
	self dialogue_queue( "presc_pri_cmonsoap" );
	level.soap dialogue_queue( "presc_mct_needto" );
	
	flag_wait( "vo_this_way" );
	
	wait 1;
	
	self dialogue_queue( "presc_pri_chopperscircling" ); //presc_pri_thisway
	
	flag_wait( "vo_cmon_son" );
	
	wait 2;
	
	self dialogue_queue( "presc_pri_cmonson" );
	
	wait 1.8;
	
	if ( !flag( "store_go_hot" ) )
	{
		self dialogue_queue( "presc_pri_takepoint" );
	}
	
	flag_wait( "store_go_hot" );
	
	//self dialogue_queue( "presc_pri_theyrehere" ); Yuri get up there
	
	battlechatter_on( "allies" );
	level.price set_ai_bcvoice( "taskforce" );
	
	wait 2;
	
	self dialogue_queue( "presc_pri_clearthestore" );
	
	flag_wait( "vo_nice_one" );
	
	wait 3;
	
	if ( !flag( "killedby_player" ) )
	{
		self dialogue_queue( "presc_pri_niceone" );
		level.soap dialogue_queue( "presc_mct_teachyou");
	}	
}


// spawn functions ////////////////////////////////////////////////////////////
spawnfunc_store_guard()
{
	self endon( "death" );	
	self thread player_spotted();
	self thread store_guard_monitor();
	self thread store_guard_listener();
	self thread price_kills();
	
	self.a.disableLongDeath = true;
	self.animname = "generic";
	self.allowdeath = true;
	self.goalradius = 32;
	
	self cqb_walk( "on" );
	
	flag_wait( "store_go_hot" );
	
	if(isdefined( self.script_noteworthy ) )
	{
		if( self.script_noteworthy == "guard_right" )
		{
			surprise_anim = "cqb_stop";
			self anim_generic_custom_animmode( self, "gravity", surprise_anim );
		}
	}		
		
	self cqb_walk( "off" );
	
	flag_wait( "china_shop_charge" );
	
	self thread last_guyin_chinashop();
}

magic_bullets_at_window()
{
	flag_wait( "store_go_hot" );
	
	wait(1.5);
	ak_source = getstruct("ak_source", "targetname" );
	spots = getstructarray( "store_window_break", "targetname" );
	bullet_amount = 3;
	foreach(spot in spots)
	{
		for( i = 0; i < bullet_amount; i++ )
		{
			magicbullet( "pecheneg", ak_source.origin, spot.origin );
			wait( RandomFloatRange( .05, .15) );
		}
	}		

}	

spawnfunc_store_runner()
{
	self endon( "death" );
	
	self thread price_kills();
	self.a.disableLongDeath = true;
	self.goalradius = 32;
	self.animname = "generic";
	self.allowdeath = true;
	
	self cqb_walk( "on" );
	
	flag_wait( "store_go_hot" );
	
	self cqb_walk( "off" );
		
	//wait 0.3;
	
	surprise_anim = "exchange_surprise_0";
	self anim_generic_custom_animmode( self, "gravity", surprise_anim );
	
	flag_wait( "china_shop_charge" );
	
	self thread last_guyin_chinashop();
}


spawnfunc_back_guard()
{
	self endon( "death" );
	
	self thread price_kills();
	
	//self set_fixednode_true();
	self.a.disableLongDeath = true;
	self.goalradius = 32;
		
	//wait 1;
	
	//self set_fixednode_false();
		
	if ( flag( "china_right_path" ) )
	{
		nd_rear = GetNode( "cover_rear", "targetname" );
		self SetGoalNode( nd_rear );
	}
	else
	{
		nd_front = GetNode( "cover_front", "targetname" );
		self SetGoalNode( nd_front );
	}
	
	flag_wait( "china_shop_charge" );
	
	self thread last_guyin_chinashop();
}


spawnfunc_cashier()
{
	self endon( "death" );
	
	self thread price_kills();
	
	self.a.disableLongDeath = true;
	self.goalradius = 32;
	
	self waittill( "goal" );
	
	self set_fixednode_true();
	
	wait 3;
	
	self set_fixednode_false();
	
	vol = GetEnt( "vol_china_rear", "targetname" );
	
	self SetGoalVolumeAuto( vol );
	
	flag_wait( "china_shop_charge" );
	
	self thread last_guyin_chinashop();
}


spawnfunc_front_door()
{
	self endon( "death" );
	
	self thread price_victim_distance();
	
	self.a.disableLongDeath = true;
	
	flag_wait( "china_right_path" );  //set by trigger
	
	self thread last_guyin_chinashop();
}


spawnfunc_door_breacher()
{
	self endon( "death" );
	
	self thread check_who_killed();
	
	self.health = 1;
	self.allowdeath = true;
	self.a.disableLongDeath = true;
	self.ignoreall = true;
	self.animname = "door_breacher";
}


check_who_killed()
{
	self waittill( "death", attacker );

	if ( isdefined( attacker ) && ( isplayer( attacker ) ) )
	{
		flag_set( "killedby_player" );
	}
}


// section functions ////////////////////////////////////////////////////////////
enter_china_shop( guy )
{
	if ( GetAICount( "axis" ) )
	{
		guy Shoot();
	}
}


soap_shoots_breacher( guy )
{
	wait 0.05;
		
	if ( IsAlive( level.ai_door_breacher ) )
	{
		v_soap_gun = level.soap GetTagOrigin( "tag_flash" );
		v_enemy_head = level.ai_door_breacher GetTagOrigin( "J_Head" );
		
		MagicBullet( "p99", v_soap_gun, v_enemy_head );
		
		wait 0.1;
		
		level.ai_door_breacher die();
	}
}


last_guyin_chinashop()
{
	self endon( "death" );
	
	vol = GetEnt( "vol_china_shop", "targetname" );
	
	self ClearGoalVolume();
	
	self SetGoalVolumeAuto( vol );
}


fake_destruction_chinashop()
{
	a_t_phys = GetEntArray( "trigger_physics_chinashop", "targetname" );
	
	foreach( t_phys in a_t_phys )
	{
		t_phys thread waittill_shot_chinashop();
	}
}


waittill_shot_chinashop()
{
	level endon( "room_clear" );
	
	self waittill( "trigger" );
		
	RadiusDamage( self.origin, 25, 200, 180 );
}


player_spotted()
{
	self endon( "death" );
	level endon( "store_go_hot" );
	
	while( 1 )
	{
		if( self CanSee( level.player ) )
		{
			wait 0.3;
			
			flag_set( "store_go_hot" );
			
			break;
		}
		
		wait 0.05;
	}
}


ignore_squad()
{
	level.player.ignoreme = true;
	level.price.ignoreme = true;
	level.soap.ignoreme = true;
	
	flag_wait( "store_go_hot" );
	
	level.player.ignoreme = false;
	level.price.ignoreme = false;
	level.soap.ignoreme = false;
}


player_enter_room()
{	
	t_room_entered = getent( "trigger_enter_room", "targetname" );
	t_room_entered waittill( "trigger" );
	
	level thread spawn_store_guards();
	
	flag_set( "player_enter_store" );
}


spawn_store_guards()
{	
	store_guard_ai = get_guys_with_targetname_from_spawner( "store_guards" );
	wait(.10);
	
	level thread monitor_china_shop();
	
	while( store_guard_ai.size > 0 )
	{
		store_guard_ai = array_removedead_or_dying( store_guard_ai );
		wait(.5);
	}
	
	flag_set( "room_clear" );		
}


door_dumpster()
{
	m_dump_door = getent( "door_dumpster", "targetname" );
	m_clip_dump_door = getent( "clip_door_dumpster", "targetname" );
	
	wait 0.7;
	
	exploder( 420 );
		
	m_dump_door rotateyaw( 120, 0.2 );
	
	m_clip_dump_door connectpaths();
	m_clip_dump_door delete();
}


price_victim_distance()
{
	self endon( "death" );
	
	while( Distance2D( self.origin, level.price.origin ) > 200 )
	{
		wait 0.1;
	}
	
	self kill_price_victim();
}


kill_price_victim()
{
	self endon( "death" );
	
	v_price_gun = level.price GetTagOrigin( "tag_flash" );
	v_enemy_head = self GetTagOrigin( "J_Head" );
		
	MagicBullet( "deserteagle", v_price_gun, v_enemy_head );
}


price_kills()
{
	self endon( "death" );
	
	flag_wait( "reached_door" );
	
	while( Distance2D( self.origin, level.price.origin ) > 320 )
	{
		wait 0.1;
	}
	
	self kill_price_victim();
}


store_guard_listener()
{
	self endon( "death" );
	level endon( "store_go_hot" );
	
	self addAIEventListener( "gunshot" );
	
	while( 1 )
	{
		self waittill( "ai_event", msg );
		
		if( msg == "gunshot" )
		{
			flag_set( "store_go_hot" );
			break;
		}
	}
}


store_guard_monitor()
{
	self endon( "death" );
	level endon( "store_go_hot" );
	
	self waittill_any( "bulletwhizby", "bullethit", "damage", "flashbang", "grenade danger", "explode" );
	
	flag_set( "store_go_hot" );
}


room_clear()
{
	waittill_aigroupcleared( "group_store_guard" );
	
	flag_set( "room_clear" );
}


monitor_china_shop()
{
	waittill_aigroupcount( "group_store_guard", 1 );
	
	flag_set( "china_shop_charge" );
}


door_store()
{
	m_door_store = getent( "door_cafe", "targetname" );
	m_clip_door_store = getent( "clip_door_store", "targetname" );
	
	m_door_store rotateyaw( -120, 0.1 );
	
	exploder( 608 );
	
	m_clip_door_store connectpaths();
	m_clip_door_store delete();
	
	m_clip_door = GetEnt( "clip_china_door", "targetname" );
	m_clip_door trigger_on();
}


flags_dumpster()
{
	flag_init( "player_enter_store" );
	flag_init( "store_go_hot" );
	flag_init( "reached_door" );
	flag_init( "china_shop_charge" );
	flag_init( "room_clear" );
	flag_init( "door_breached" );
	flag_init( "killedby_player" );
	flag_init( "breach_done" );
	
	//vo flags
	flag_init( "vo_this_way" );
	flag_init( "vo_cmon_son" );
	flag_init( "vo_nice_one" );
	
	//music
	flag_init( "queue_price_carry_music" );
}


objectives_dumpster()
{
	//prague_objective_add( str_objective_text, is_new, is_current, v_position, str_state )
	//prague_objective_add_on_ai( e_ai, str_objective_text, is_new, is_current, str_state, str_override )
	
	level.n_obj_protect = prague_objective_add_on_ai( level.soap, &"PRAGUE_ESCAPE_PROTECT_SOAP", true, true, "active", &"PRAGUE_ESCAPE_PROTECT" );
	
	//flag_wait( "player_enter_store" );
	
	//n_obj_clearroom = prague_objective_add( &"PRAGUE_ESCAPE_CLEAR_ROOM" );
	
	//flag_wait( "room_clear" );
	
	//prague_objective_complete( n_obj_clearroom );
	
	//objective_delete( n_obj_clearroom );
	
	//objective_current( level.n_obj_protect );
}


dumpster_spawnfuncs()
{
	a_enemy_spawners = getentarray( "store_guards", "targetname" );
	array_thread( a_enemy_spawners, ::add_spawn_function, ::spawnfunc_store_guard );
	/*
	sp_back_guard = getent( "back_guard", "targetname" );
	sp_back_guard add_spawn_function( ::spawnfunc_back_guard );
	
	sp_cashier = getent( "cashier", "targetname" );
	sp_cashier add_spawn_function( ::spawnfunc_cashier );
			
	sp_first_kill = getent( "front_door_guard", "script_noteworthy" );
	sp_first_kill add_spawn_function( ::spawnfunc_front_door );
	
	sp_store_runner = getent( "store_runner", "targetname" );
	sp_store_runner add_spawn_function( ::spawnfunc_store_runner );
	*/
	sp_door_spawner = getent( "door_breach_guy", "targetname" );
	sp_door_spawner add_spawn_function( ::spawnfunc_door_breacher );
}


setup_dumpster()
{
	level.m_box1 = GetEnt( "soap_lean_box_1", "targetname" );
	level.m_box2 = GetEnt( "soap_lean_box_2", "targetname" );
	level.m_box3 = GetEnt( "soap_lean_box_3", "targetname" );
	level.m_box4 = GetEnt( "soap_lean_box_4", "targetname" );
	level.m_box5 = GetEnt( "soap_lean_box_5", "targetname" );
	level.m_box6 = GetEnt( "soap_lean_box_6", "targetname" );
			
	level.m_link_box1 = Spawn( "script_model", level.m_box1.origin );
	level.m_link_box1.angles = level.m_box1.angles;
	level.m_link_box1 SetModel( "tag_origin_animate" );
	level.m_link_box1.animname = "box1";
	level.m_link_box1 useanimtree( level.scr_animtree[ "box1" ] );
				
	level.m_box1.origin = level.m_link_box1 GetTagOrigin( "origin_animate_jnt" );
	level.m_box1.angles = level.m_link_box1 GetTagAngles( "origin_animate_jnt" );
	level.m_box1 linkto( level.m_link_box1, "origin_animate_jnt" );
	
	level.m_link_box2 = Spawn( "script_model", level.m_box2.origin );
	level.m_link_box2.angles = level.m_box2.angles;
	level.m_link_box2 SetModel( "tag_origin_animate" );
	level.m_link_box2.animname = "box2";
	level.m_link_box2 useanimtree( level.scr_animtree[ "box2" ] );
				
	level.m_box2.origin = level.m_link_box2 GetTagOrigin( "origin_animate_jnt" );
	level.m_box2.angles = level.m_link_box2 GetTagAngles( "origin_animate_jnt" );
	level.m_box2 linkto( level.m_link_box2, "origin_animate_jnt" );
	
	level.m_link_box3 = Spawn( "script_model", level.m_box3.origin );
	level.m_link_box3.angles = level.m_box3.angles;
	level.m_link_box3 SetModel( "tag_origin_animate" );
	level.m_link_box3.animname = "box3";
	level.m_link_box3 useanimtree( level.scr_animtree[ "box3" ] );
				
	level.m_box3.origin = level.m_link_box3 GetTagOrigin( "origin_animate_jnt" );
	level.m_box3.angles = level.m_link_box3 GetTagAngles( "origin_animate_jnt" );
	level.m_box3 linkto( level.m_link_box3, "origin_animate_jnt" );
	
	level.m_link_box4 = Spawn( "script_model", level.m_box4.origin );
	level.m_link_box4.angles = level.m_box4.angles;
	level.m_link_box4 SetModel( "tag_origin_animate" );
	level.m_link_box4.animname = "box4";
	level.m_link_box4 useanimtree( level.scr_animtree[ "box4" ] );
				
	level.m_box4.origin = level.m_link_box4 GetTagOrigin( "origin_animate_jnt" );
	level.m_box4.angles = level.m_link_box4 GetTagAngles( "origin_animate_jnt" );
	level.m_box4 linkto( level.m_link_box4, "origin_animate_jnt" );
	
	level.m_link_box5 = Spawn( "script_model", level.m_box5.origin );
	level.m_link_box5.angles = level.m_box5.angles;
	level.m_link_box5 SetModel( "tag_origin_animate" );
	level.m_link_box5.animname = "box5";
	level.m_link_box5 useanimtree( level.scr_animtree[ "box5" ] );
				
	level.m_box5.origin = level.m_link_box5 GetTagOrigin( "origin_animate_jnt" );
	level.m_box5.angles = level.m_link_box5 GetTagAngles( "origin_animate_jnt" );
	level.m_box5 linkto( level.m_link_box5, "origin_animate_jnt" );
	
	level.m_link_box6 = Spawn( "script_model", level.m_box6.origin );
	level.m_link_box6.angles = level.m_box6.angles;
	level.m_link_box6 SetModel( "tag_origin_animate" );
	level.m_link_box6.animname = "box6";
	level.m_link_box6 useanimtree( level.scr_animtree[ "box6" ] );
				
	level.m_box6.origin = level.m_link_box6 GetTagOrigin( "origin_animate_jnt" );
	level.m_box6.angles = level.m_link_box6 GetTagAngles( "origin_animate_jnt" );
	level.m_box6 linkto( level.m_link_box6, "origin_animate_jnt" );
	
	a_m_courtclips = getentarray( "clip_court", "targetname" );
	foreach( m_courtclip in a_m_courtclips )
	{
		m_courtclip ConnectPaths();
		m_courtclip trigger_off();
	}
	
	m_clip_door = GetEnt( "clip_china_door", "targetname" );
	m_clip_door trigger_off();
	
	// "destructible" hedges
	m_hedge01 = GetEnt( "hedge_c_dest01", "targetname" );
	m_hedge_clip01 = GetEnt( "clip_c_dest01", "targetname" );
	
	m_hedge01 Hide();
	m_hedge_clip01 trigger_off();
	
	m_hedge02 = GetEnt( "hedge_c_dest02", "targetname" );
	m_hedge_clip02 = GetEnt( "clip_c_dest02", "targetname" );
	
	m_hedge02 Hide();
	m_hedge_clip02 trigger_off();
	
	level thread hedge_courtyard_destruction();
}


hedge_courtyard_destruction()
{
	t_hedge01 = GetEnt( "trigger_hedge01", "targetname" );
	t_hedge02 = GetEnt( "trigger_hedge02", "targetname" );
	
	t_hedge01 thread waittill_hedge_dmg( 1 );
	t_hedge02 thread waittill_hedge_dmg( 2 );
}


waittill_hedge_dmg( id )
{
	level endon( "bank_done" );
	
	self waittill( "trigger" );
	
	m_hedge_clean = GetEnt( "hedge_c_clean0"+id, "targetname" );
	m_hedge_dest = GetEnt( "hedge_c_dest0"+id, "targetname" );
	m_clip_clean01 = GetEnt( "clip_c_clean0"+id, "targetname" );
	m_clip_dest01 = GetEnt( "clip_c_dest0"+id, "targetname" );
	
	PlayFXOnTag( level._effect[ "hedgea_dest" ], m_hedge_dest get_tag_origin(), "tag_origin" );
		
	wait 0.1;
		
	m_hedge_clean Delete();
	m_hedge_dest Show();
	m_clip_clean01 Delete();
	m_clip_dest01 trigger_on();
}