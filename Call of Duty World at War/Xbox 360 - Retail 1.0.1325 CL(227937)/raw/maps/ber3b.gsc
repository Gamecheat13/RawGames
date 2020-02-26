//
// file: ber3b.gsc
// description: main level script for berlin3b
// scripter: slayback
//

#include common_scripts\utility;
#include maps\_utility;
#include maps\ber3_util;
#include maps\_music;

#using_animtree( "generic_human" );

main()
{
	init_flags();
	build_starts();
	thread introscreen_override();
	build_threatbias_groups();
	precache_assets();
	
	thread onPlayerConnect();
	
	maps\ber3b_fx::main();

	maps\_stuka::main( "vehicle_stuka_flying" );
	maps\_aircraft::main( "vehicle_rus_airplane_il2", "il2" );
	
	setup_friendlies();
	
	maps\ber3b_event_foyer::setup_frontdoors();
	
	maps\_load::main();  // COD magic

	setup_drones();
		
	thread maps\ber3b_amb::main();

	maps\ber3b_anim::ber3b_anim_init();
	maps\_mganim::main();  // anims for portable MG guys
		
	setup_strings();
	
	setup_spawn_functions();
	
	russian_flag_init();
	
	thread random_arty_strikes();
	thread chandeliers_shake();
	
	thread eagle_setup();
	
	thread maps\ber3b_anim::roof_flag_init();
	
	thread collectible_corpse();
	
	//thread debug_ents();
		
	// TEMP for development
	doDebug = GetDvarInt( "debug_ai" );
	if( IsDefined( doDebug ) && doDebug > 0 )
	{
		thread debug_ai();
	}
	
	thread difficulty_scale();
	thread honorguard_combat_dialogue();
}

/*
debug_ents()
{
	while( 1 )
	{
		smodels = GetEntArray( "script_model", "classname" );
		sbmodels = GetEntArray( "script_brushmodel", "classname" );
		test = "test";
		wait( 1 );
	}
}
*/

precache_assets()
{
	PrecacheModel( "tag_origin" );
	PrecacheModel( "tag_origin_animate" );
	PrecacheModel( "weapon_ger_panzershreck_rocket" );
	PrecacheModel( "katyusha_rocket" );
	PrecacheModel( "clutter_berlin_megaphone" );
	PrecacheModel( "anim_berlin_russian_flag" );
	//PrecacheModel( "anim_berlin_russian_flag_obj" );
	PrecacheModel( "anim_berlin_rus_flag_rolled" );
	PrecacheModel( "anim_berlin_rus_flag_rolled_obj" );
	PrecacheModel( "ber3b_3rd_person_flag" );
	PrecacheModel( "anim_nazi_flag_burnt_rope" );
	PrecacheModel( "viewmodel_usa_player" );
	PrecacheModel( "viewmodel_russian_flag" );
	PrecacheModel( "static_berlin_eagle_statue_wall_swastika" );
	PrecacheModel( "projectile_rus_molotov_grenade" );
	PrecacheModel( "weapon_rus_reznov_knife" );
	
	PrecacheItem( "russian_flag" );
	PrecacheItem( "napalmblob" );  // for the molotovs
	precacheItem( "napalmbloblight" );                          

	PrecacheRumble( "explosion_generic" );
	PrecacheRumble( "explosion_generic_no_broadcast" );
}

build_starts()
{		
	// foyer event starts
	add_start( "intro", maps\ber3b_event_foyer::event_intro_start, &"STARTS_BER3B_INTRO" );
	add_start( "foyer", maps\ber3b_event_foyer::event_foyer_start, &"STARTS_BER3B_FOYER" );
		
	// pacing area 1 start
	add_start( "foyer_pacing", maps\ber3b_event_foyer::event_foyer_pacing_start, &"STARTS_BER3B_FOYER_PACING" );
	
	// parliament event starts
	add_start( "parliament", maps\ber3b_event_parliament::event_parliament_start, &"STARTS_BER3B_PARLIAMENT" );
	add_start( "parliament_doors", maps\ber3b_event_parliament::event_parliament_doors_start, &"STARTS_BER3B_PARLIAMENT_DOORS" );
	
	// roof event starts
	add_start( "roof", maps\ber3b_event_roof::event_roof_start, &"STARTS_BER3B_ROOF" );
	add_start( "roof_midpoint", maps\ber3b_event_roof::event_roof_midpoint_start, &"STARTS_BER3B_ROOF_MIDPOINT" );
	add_start( "roof_flagplant", maps\ber3b_event_roof::event_roof_flagplant_start, &"STARTS_BER3B_ROOF_FLAGPLANT" );
	
	// default start
	add_start( "default", level.start_functions[ "intro" ] );
	//add_start( "default", level.start_functions[ "roof_flagplant" ] );
	default_start( level.start_functions[ "intro" ] );
}

introscreen_override()
{
	if ( GetDvar( "createfx" ) != "" )
	{
		return;
	}
	
	start = undefined;
	while( !IsDefined( start ) )
	{
		waittillframeend;
		start = level.start_point;
	}
	
	// start-specific introscreen disable
	if( IsDefined( start ) && start != "" && start != "default" && start != "intro" && !IsSubStr( start, "**" ) )
	{
		SetDvar( "introscreen", "0" );  // disable the introscreen
	}
		
	// always want our intro start to include the introscreen
	if( IsDefined( start ) && start == "intro" )
	{
		SetDvar( "introscreen", "1" );
	}
}

build_threatbias_groups()
{
	CreateThreatBiasGroup( "players" );
	CreateThreatBiasGroup( "friends" );
	CreateThreatBiasGroup( "parliament_floor_enemies" );
	CreateThreatBiasGroup( "parliament_redshirts" );
}

init_flags()
{
	// makes introscreen wait for our flag before showing text
	level.introscreen_waitontext_flag = "ber3b_introscreen_finish";
	flag_init( level.introscreen_waitontext_flag );
	
	flag_init( "friends_setup" );
	flag_init( "warp_players_done" );
	
	flag_init( "hallway_running_dialogue_done" );
	flag_init( "commissar_dialogue_done" );
	
	flag_init( "russian_flag_setup" );
	flag_init( "russian_flag_dropped" );
	flag_set( "russian_flag_dropped" );
	flag_init( "flagbearer_mantled" );
	
	flag_init( "bazookateam_keep_firing" );
	flag_init( "first_balcony_russians_moveup" );
	flag_init( "first_balcony_doors_startopen" );
	flag_init( "eagle_fall" );
	
	flag_init( "parliament_backdoor_used" );
	flag_init( "player_downstairs" );

	flag_init( "roof_rockets_done" );
	
	flag_init( "statue_fall_done" );
	
	flag_init( "fall" );
}

setup_strings()
{
	level.obj1_string = &"BER3B_OBJ_1";  // storm the reichstag
	level.obj2_string = &"BER3B_OBJ_2A"; // get up to balcony and cover Russian troops
	level.obj2b_string = &"BER3B_OBJ_2B"; // shoot Germans on opposite balcony
	level.obj3_string = &"BER3B_OBJ_2";  // get out of parliament room
	level.obj4_string = &"BER3B_OBJ_3";  // keep clearing
	level.obj5_string = &"BER3B_OBJ_4";  // pick up flag
	level.obj6_string = &"BER3B_OBJ_5";  // raise flag
	
	level.diary_skip = &"BER3B_DIARY_SKIP";  // "(Press USE to skip.)"
	
	level.obj_flag_carry_string = &"BER3B_OBJ_FLAG_CARRY";  // "Carry the Russian flag to the roof."
	level.obj_flag_retrieve_string = &"BER3B_OBJ_FLAG_RETRIEVE";  // "Retrieve the Russian flag."
	level.hint_flag_pickup_string = &"BER3B_HINT_FLAG_PICKUP";  // "Hold [use] to pick up the flag."
	level.hint_flag_drop_string = &"BER3B_HINT_FLAG_DROP";  // "Hold [use] to drop the flag."
	level.flag_fail_warning = &"BER3B_FLAG_FAIL_WARNING";  // "Comrade, do not leave our flag behind!"
	level.flag_fail_deadquote = &"BER3B_FLAG_FAIL_DEADQUOTE";  // "You left the flag behind!"
	
	level.flag_plant_trigger_string = &"BER3B_FLAG_PLANT_TRIGGER_HINT";  // "Press [use] to plant the flag."
}

set_objective( num )
{
	// storm the reichstag
	if( num == 1 )
	{
		marker = GetStruct( "struct_objective8_marker", "targetname" );
		
		objective_add( 1, "active", level.obj1_string, marker.origin );
		objective_current( 1 );
		
		level.nonFlagObjective = 1;
	}
	// get up to balcony and provide fire support for Russian troops
	else if( num == 2 )
	{
		objective_state( 1, "done" );
		objective_add( 2, "active", level.obj2_string, ( 2222, 19037, 1170 ) );
		objective_add( 10, "invisible", level.obj2b_string );  // shoot Germans on opposite balcony
		objective_current( 2 );
		
		level.nonFlagObjective = 2;
	}
	// get out of parliament room
	else if( num == 3 )
	{
		marker = GetStruct( "struct_objective9_marker", "targetname" );
		
		objective_state( 2, "done" );
		objective_state( 10, "invisible" );
		
		objective_add( 3, "active", level.obj3_string, marker.origin );
		objective_current( 3 );
		
		level.nonFlagObjective = 3;
	}
	// keep clearing
	else if( num == 4 )
	{
		marker = getent_safe( "trig_roof_mantlearea", "targetname" );
		
		objective_state( 3, "done" );
		objective_add( 4, "active", level.obj4_string, marker.origin );
		objective_current( 4 );
		
		level.nonFlagObjective = 4;
	}
	// pick up flag
	else if( num == 5 )
	{
		marker = GetStruct( "struct_objective11_marker", "targetname" );
		
		objective_state( 4, "done" );
		objective_add( 5, "active", level.obj5_string, marker.origin );
		objective_current( 5 );
	}
	// raise flag
	else if( num == 6 )
	{
		marker = GetStruct( "struct_objective12_marker", "targetname" );
		
		objective_state( 5, "done" );
		objective_add( 6, "active", level.obj6_string, marker.origin );
		objective_current( 6 );
		
		level.nonFlagObjective = 6;
	}
}

// skips past objectives that should have already happened (for skiptos)
objectives_skip( numToSkipPast )
{
	for( i = 1; i <= numToSkipPast; i++ )
	{
		set_objective( i );
	}
}

warp_players_underworld()
{
	// get the spot under the world for temp placement
	underworld = GetStruct( "struct_player_teleport_underworld", "targetname" );
	if( !IsDefined( underworld ) )
	{
		ASSERTMSG( "warp_players_underworld(): can't find the underworld warp spot! aborting." );
		return;
	}
	
	players = get_players();

	for( i = 0; i < players.size; i++ )
	{
		players[i] SetOrigin( underworld.origin );
	}
}

// warp players to a given set of points
warp_players( startValue, startKey )
{
	// get start points
	starts = GetStructArray( startValue, startKey );
	ASSERT( starts.size == 4 );
	
	players = get_players();

	for( i = 0; i < players.size; i++ )
	{
		// Set the players' origin to each start point
		players[i] setOrigin( starts[i].origin );
	
		// Set the players' angles to face the right way.
		players[i] setPlayerAngles( starts[i].angles );
	}
	
	set_breadcrumbs(starts);
	
	flag_set( "warp_players_done" );
}

setup_friendlies()
{
	// used by _colors system
	level.friendly_startup_thread = ::ber3b_friendly_startup_thread;
	
	friends = grab_starting_friends();
	ASSERTEX( IsDefined( friends ) && friends.size > 0, "setup_friendlies(): can't find any friendlies!" );
	
	for( i = 0; i < friends.size; i++ )
	{
		guy = friends[i];
		
		guy.followmin = -1;
		guy friend_add();
		
		if( IsDefined( guy.script_noteworthy ) )
		{
			// Sgt. Zeitzev
			if( guy.script_noteworthy == "sarge" )
			{
				level.sarge = guy;
				level.sarge.animname = "sarge";  // set up a default
			}
			
			// guys with script_noteworthy set are heroes and need a bullet shield
			guy thread magic_bullet_shield();
		}
	}
	
	ASSERTEX( is_active_ai( level.sarge ), "setup_friendlies(): couldn't assign level.sarge." );
	
	flag_set( "friends_setup" );
}

// used to get _colors reinforcements set up properly
ber3b_friendly_startup_thread()
{
	// if you're in the player squad..
	if( IsDefined( self.script_forcecolor ) && self.script_forcecolor == "b" )
	{
		// add to level.friends
		self friend_add();
	}
}

// warp friendlies to a given set of points
warp_friendlies( startValue, startKey )
{
	ASSERTEX( flag( "friends_setup" ), "warp_friendlies(): level.friends needs to be set up before this runs." );
	
	// get start points
	friendlyStarts = GetStructArray( startValue, startKey );
	ASSERTEX( friendlyStarts.size > 0, "warp_friendlies(): didn't find enough friendly start points!" );

	for( i = 0; i < level.friends.size; i++ )
	{
		level.friends[i] Teleport( groundpos( friendlyStarts[i].origin ), friendlyStarts[i].angles );
	}
}

setup_drones()
{
	// TODO these character model names may change as art makes new variants
	character\char_ger_honorguard_mp44::precache();
	character\char_rus_r_rifle::precache();
		
	level.drone_spawnFunction["axis"] = character\char_ger_honorguard_mp44::main;
	level.drone_spawnFunction["allies"] = character\char_rus_r_rifle::main; 
		
	level.drone_weaponlist_axis[0] = "gewehr43";
	level.drone_weaponlist_axis[0] = "stg44";
		
	// Call this before maps\_load::main(); to allow drone usage.
	maps\_drones::init();	
}

random_arty_strikes()
{
	ender = "stop_random_arty_strikes";
	
	level endon( ender );
	
	level.pauseArtyStrikes = false;
	
	minWait = 15;
	maxWait = 35;
	
	thread random_arty_strikes_sound( ender );
	
	while( 1 )
	{
		wait( RandomIntRange( minWait, maxWait ) );
		
		if( !level.pauseArtyStrikes )
		{
			thread arty_strike_on_players( RandomFloatRange( .2, .3 ), 3, 500 );
			//Kevins notify for sound
			//level notify( "int_strike" );
		}
	}
}

arty_strike_on_players( intensity, duration, radius, switchLevelVar )
{
	if( !IsDefined( switchLevelVar ) )
	{
		switchLevelVar = true;
	}
	
	if( switchLevelVar )
	{
		level.pauseArtyStrikes = true;
	}
	
	players = get_players();
			
	level notify( "arty_strike" );
			
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread arty_strike_rumble( duration * 0.5 );
		Earthquake( intensity, duration, players[i].origin, radius );
	}
	
	wait( duration );
	
	if( switchLevelVar )
	{
		level.pauseArtyStrikes = false;
	}
}

arty_strike_rumble( duration )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self PlayRumbleOnEntity( "explosion_generic" );
	wait( 0.2 );

	stopTime = GetTime() + ( duration * 1000 );
	
	while( GetTime() <= stopTime )
	{
		self PlayRumbleOnEntity( "damage_light" );
		wait( 0.05 );
	}
}

random_arty_strikes_sound( ender )
{
	level endon( ender );
	
	level.arty_soundSpot = Spawn( "script_origin", ( 872, 14728, 3064 ) );
	level.arty_soundSpot thread random_arty_strikes_cleanup_soundspot( ender );
	// TODO: Kevin can move the soundSpot around as players move through the level, if he wants
	
	while( 1 )
	{
		level waittill( "arty_strike" );
		level.arty_soundSpot PlaySound( "art_int" );
	}
}

random_arty_strikes_cleanup_soundspot( ender )
{
	level waittill( ender );
	
	wait( 1 );
	
	if( IsDefined( self ) )
	{
		self Delete();
	}
}

chandeliers_shake()
{
	level endon( "stop_chandeliers_shake" );
	
	animDistance = 1500;
	shake_maxWait = 0.25;
	
	chandeliers = GetEntArray( "smodel_chandelier", "targetname" );
	
	if( !IsDefined( chandeliers ) || chandeliers.size <= 0 )
	{
		return;
	}
	
	/* DEPRECATED - since removing the spotlights and optimizing chandelier count we don't need this
	// SRS 5/30/2008: HACK for entity count reduction
	for( i = 0; i < chandeliers.size; i++ )
	{
		chandeliers[i] Delete();
	}
	if( 1 )
	{	
		return;
	}
	// end HACK
	*/
	
	array_thread( chandeliers, ::chandelier_rotate_random );
	
	while( 1 )
	{
		level waittill( "arty_strike" );
		
		for( i = 0; i < chandeliers.size; i++ )
		{
			chandelier = chandeliers[i];
			
			isCloseEnough = false;
			
			players = get_players();
			for( j = 0; j < players.size; j++ )
			{
				if( Distance( chandelier.origin, players[j].origin ) <= animDistance )
				{
					isCloseEnough = true;
					break;
				}
			}
			
			if( !isCloseEnough )
			{
				continue;
			}
			else
			{
				chandelier thread maps\ber3b_anim::chandelier_anim( "reichstag_chandelier", "shake", "chandelier_anim", shake_maxWait );
			}
		}
	}
}

// self = a chandelier
chandelier_rotate_random()
{
	rotateMin = 0;
	rotateMax = 180;
	
	self RotateYaw( RandomIntRange( rotateMin, rotateMax ), 0.05 );
}

// attaches a swastika to the eagle which can be swapped for another asset in other SKUs
eagle_setup()
{
	eagle = getent_safe( "smodel_parliament_eagle", "targetname" );
	eagle Attach( "static_berlin_eagle_statue_wall_swastika", "eagle_base_jnt" );
}

collectible_corpse()
{
	orig = getstruct_safe( "struct_collectible_loop", "targetname" );
	orig.origin = groundpos( orig.origin );

	corpse = Spawn( "script_model", orig.origin );
	corpse.angles = orig.angles;
	corpse maps\ber3b_anim::setup_axis_char_model();
	corpse Detach( corpse.gearModel );
	corpse UseAnimTree( #animtree );
	corpse.animname = "collectible";
	corpse.targetname = "collectible_corpse";

	corpse thread maps\_anim::anim_loop_solo( corpse, "collectible_loop", undefined, "stop_collectible_loop", orig );
	
	level waittill( "stop_collectible_loop" );
	corpse notify( "stop_collectible_loop" );
	wait( 0.1 );
	corpse Delete();
}

// --- FLAG CARRYING ---

russian_flag_init()
{
	flag_wait( "all_players_connected" );
	
	level.useButtonHoldTime = 0.4;
	level.requiredFlagProximity = 1300;
	// model is set up like a weapon so we have to re-orient it in script
	level.russianFlagOriginOffset = ( 0, 0, 27 );
	level.russianFlagAnglesOffset = ( 270, 0, 0 );
	
	russian_flag_hud_init();
	
	russianFlag = Spawn( "script_model", ( 1136, 13288, 392 ) );
	russianFlag.origin += level.russianFlagOriginOffset;
	russianFlag.angles += level.russianFlagAnglesOffset;
	russianFlag SetModel( "anim_berlin_rus_flag_rolled" );
	russianFlag Hide();
	
	level.russianFlag = russianFlag;
	
	flag_set( "russian_flag_setup" );
}

russian_flag_startthink()
{
	if( IsDefined( level.russian_flag_startthink ) )
	{
		return;
	}
	
	level.russian_flag_startthink = true;
	
	level.russianFlag Show();
	
	level thread russian_flag_objectives( level.russianFlag );
	
	/*  DEPRECATED proxcheck is annoying when the flag is only at the end of the level
	flag_disable_proxcheck = GetDvarInt( "flag_disable_proxcheck" );
	if( IsDefined( flag_disable_proxcheck ) && flag_disable_proxcheck <= 0 )
	{
		level thread russian_flag_proxcheck( level.russianFlag );
	}
	*/
	
	flag_set( "russian_flag_dropped" );
	
	level.russianFlag thread russian_flag_think();
	level.russianFlag thread spawn_highlight();
}

russian_flag_hud_init()
{
	level.russianFlagHudFadeTime = 0.1;
	
	players = get_players();
	
	for( i = 0; i < players.size; i++ )
	{
		players[i].russian_flag_hud = NewClientHudElem( players[i] );
		players[i].russian_flag_hud.alignX = "left";
		players[i].russian_flag_hud.fontScale = 1.5;
		players[i].russian_flag_hud.x = 210;
		players[i].russian_flag_hud.y = 200;
		players[i].russian_flag_hud.alpha = 0;
	}
	
	level.russian_flag_timer_hud = NewHudElem();
	level.russian_flag_timer_hud.alignX = "left";
	level.russian_flag_timer_hud.fontScale = 1.5;
	level.russian_flag_timer_hud.x = 180;
	level.russian_flag_timer_hud.y = 215;
	level.russian_flag_timer_hud.alpha = 0;
}

russian_flag_hud_fadeout()
{
	if( !IsDefined( self.russian_flag_hud ) )
	{
		return;
	}
	
	if( self.russian_flag_hud.alpha != 0 )
	{
		self.russian_flag_hud FadeOverTime( level.russianFlagHudFadeTime );
		self.russian_flag_hud.alpha = 0;
	}
}

russian_flag_objectives( russianFlag )
{
	objective_state( 1, "done" );
	objective_state( 2, "done" );
	objective_state( 3, "done" );
	objective_state( 4, "done" );
	objective_state( 5, "done" );

	objective_add( 6, "active", level.obj_flag_retrieve_string, russianFlag get_offset_origin() );
	
	while( 1 )
	{
		// wait for the flag to change
		level waittill( "russian_flag_dropped" );
		
		if( !flag( "russian_flag_dropped" ) )
		{
			objective_string_nomessage( 6, level.obj_flag_carry_string );
			objective_state( 6, "active" );
			objective_position( 6, (1136, 11768, 1604) );
			//objective_current( level.nonFlagObjective );
			objective_current( 6 );
		}
		else
		{
			objective_string( 6, level.obj_flag_retrieve_string );
			objective_position( 6, russianFlag get_offset_origin() );
			objective_current( 6 );
		}
	}
}

russian_flag_proxcheck( russianFlag )
{	
	timer = undefined;
	
	while( 1 )
	{
		while( !flag( "russian_flag_dropped" ) )
		{
			wait( 0.5 );
		}
		
		players = get_players();
		
		playerInRange = false;
		
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			// if in the radius...
			if( Distance( player.origin, russianFlag get_offset_origin() ) <= level.requiredFlagProximity )
			{
				playerInRange = true;
				timer = undefined;
				level.russian_flag_timer_hud.alpha = 0;
				break;
			}
		}
		
		// if nobody was in range...
		if( !playerInRange )
		{
			if( !IsDefined( timer ) )
			{
				timer = GetTime();
				
				// warn player
				sarge_giveorder( "protect_the_flag" );
				
				level.russian_flag_timer_hud SetText( level.flag_fail_warning );
				level.russian_flag_timer_hud.alpha = 1;
			}
			else
			{
				if( GetTime() - timer >= 5000 )
				{
					// turn off the text
					level.russian_flag_timer_hud.alpha = 0;
					
					// mission fail
					level thread russian_flag_mission_fail();
					
					// don't have to watch anymore since the mission failed
					break;
				}
			}
		}
		
		wait( 0.5 );
	}
}

russian_flag_mission_fail()
{
	SetDvar( "ui_deadquote", level.flag_fail_deadquote );
	maps\_utility::missionFailedWrapper();
}

// mostly handles catching input
// self = the flag
russian_flag_think()
{
	level endon( "kill_flagcarry" );

	level thread kill_enemies_in_dome_after_flag_pickup();
	
	while( 1 )
	{
		// wait for flag to drop
		while( !flag( "russian_flag_dropped" ) )
		{
			wait( 0.1 );
		}
		
		// spawn the trigger
		flagtrig = Spawn( "trigger_radius", self get_offset_origin(), 0, 64, 200 );
		flagtrig EnableLinkTo();
		flagtrig LinkTo( self );  // so we can teleport it if we want
		
		// while it's on the ground...
		while( flag( "russian_flag_dropped" ) )
		{
			players = get_players();
			
			for( i = 0; i < players.size; i++ )
			{
				player = players[i];
				
				// if they previously picked up the flag, make sure we're not waiting on button release
				if( IsDefined( player.allowFlagPickup ) && !player.allowFlagPickup )
				{
					continue;
				}
				
				// when in trigger...
				if( player IsTouching( flagtrig ) )
				{
					if( player isthrowinggrenade() )
					{
						if( player.russian_flag_hud.alpha != 0 )
						{
							player.russian_flag_hud FadeOverTime( level.russianFlagHudFadeTime );
							player.russian_flag_hud.alpha = 0;
						}
					}
					else
					{
						if( player.russian_flag_hud.alpha != 1 )
						{
							// HUD tip
							player.russian_flag_hud SetText( level.hint_flag_pickup_string );
							player.russian_flag_hud FadeOverTime( level.russianFlagHudFadeTime );
							player.russian_flag_hud.alpha = 1;
						}
					}

					// if pressing use...
					if( player UseButtonPressed() && player isthrowinggrenade() == false )
					{
						if( !IsDefined( player.useButtonHoldTimer ) || player.useButtonHoldTimer == 0 )
						{
							player.useButtonHoldTimer = GetTime();
						}
						
						// make sure we've been holding the button long enough
						if( ( GetTime() - player.useButtonHoldTimer ) >= ( level.useButtonHoldTime * 1000 ) )
						{
							// turn off the highlight, if necessary
							if( IsDefined( self.highlight ) )
							{
								self.highlight Delete();
							}
							
							// kick off flag carrying
							self thread russian_flag_player_carry( player );
							
							flag_clear( "russian_flag_dropped" );
							
							flagtrig Unlink();
							flagtrig Delete();
							
							// wait for player to release button before waiting for more input
							while( player UseButtonPressed() )
							{
								wait( 0.05 );
							}
							
							// turn off HUD
							array_thread( get_players(), ::russian_flag_hud_fadeout );
							
							break;
						}
					}
					// if not pressing use...
					else
					{
						// reset the HUD and timer
						player.useButtonHoldTimer = 0;
					}
				}
				// if not in the trigger...
				else
				{
					player thread russian_flag_hud_fadeout();
				}
			}
			
			wait( 0.05 );
		}
			
	}
}

kill_enemies_in_dome_after_flag_pickup()
{
	level waittill( "russian_flag_dropped" );

	while( flag( "russian_flag_dropped" ) )
	{
		wait( 0.1 );
	}
	
	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_spineupper";
	tags[5] = "j_spinelower";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";

	axis_ai = GetAiArray( "axis" );
	while( axis_ai.size > 0 )
	{
		// randomly kill 1 enemy every second, as long as there are still enemies left
		i = randomint( axis_ai.size );
		tag = get_random( tags );
		if( is_mature() )
		{
			bloodFX = undefined;  // if we pass undefined it'll do the default flesh_hit
			if( RandomInt( 100 ) < 65 )
			{
				bloodFX = level._effect["flesh_hit_large"];
			}
				
			axis_ai[i] thread bloody_death_fx( tag, bloodFX );
		}
		axis_ai[i] dodamage( axis_ai[i].health + 100, ( 0, 0, 0 ) );

		wait( 2 );
		axis_ai = GetAiArray( "axis" );
	}
}

// self = the flag
russian_flag_player_carry( player )
{
	level endon( "kill_flagcarry" );
	
	useButtonHoldTimer = 0;
	
	// hide the worldmodel
	self Hide();
	
	level.lastFlagBearer = player;
	player.allowFlagPickup = false;	
	
	// take weapons and give flag
	//player take_player_weapons();
	player TakeWeapon( "molotov" );
	//player.lastActiveWeapon = player GetCurrentWeapon();
	player GiveWeapon( "russian_flag" );
	player SwitchToWeapon( "russian_flag" );
	player DisableWeaponCycling();
	player DisableOffhandWeapons();
	
	if( is_coop() )
	{
		player Attach( "ber3b_3rd_person_flag", "tag_weapon_right" );
		// make him not look so bad from 3rd person
		//player Attach( GetWeaponModel( player.lastActiveWeapon ), "tag_weapon_right" );

		level thread fail_mission_on_flag_carrier_death( player );
	}
	
	arcademode_assignpoints( "arcademode_score_generic500", player );
	
	// if holding button, wait for it to be released
	while( player UseButtonPressed() )
	{
		wait( 0.05 );
	}
	
	/*  DEPRECATED - player can't drop flag once he picks it up
	while( IsAlive( player ) && IsDefined( player ) )
	{
		if( player UseButtonPressed() )
		{
			if( useButtonHoldTimer == 0 )
			{
				useButtonHoldTimer = GetTime();
			}
			
			// make sure we've been holding the button long enough
			if( ( GetTime() - useButtonHoldTimer ) >= ( level.useButtonHoldTime * 1000 ) )
			{
				break;
			}
		}
		else
		{
			useButtonHoldTimer = 0;
		}
		
		wait( 0.05 );
	}
	
	// move flag to player position, stick in the ground, and unhide the worldmodel
	self.origin = player.origin + ( 0, 0, 50 );	
	self.origin = ( groundpos( self get_offset_origin() ) + level.russianFlagOriginOffset ) + ( 0, 0, -6 );
	self.angles = level.russianFlagAnglesOffset + ( 13, 349, -20 );
	self Show();
	
	self thread spawn_highlight();
	
	// notify that we dropped the flag
	flag_set( "russian_flag_dropped" );
	
	if( IsAlive( player ) && IsDefined( player ) )
	{
		// take flag and give player weapons back
		player TakeWeapon( "russian_flag" );
		player EnableWeaponCycling();
		player EnableOffhandWeapons();
		//player giveback_player_weapons();
		// if we can't figure out what the last active weapon was, try to switch a primary weapon
		if( player.lastActiveWeapon != "none" )
		{
			player SwitchToWeapon( player.lastActiveWeapon );
		}
		else
		{
			primaryWeapons = player GetWeaponsListPrimaries();
			if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
			{
				player SwitchToWeapon( primaryWeapons[0] );
			}
		}
		
		// wait for player to release button
		while( player UseButtonPressed() )
		{
			wait( 0.05 );
		}
		
		// let player pick up the flag again
		player.allowFlagPickup = true;
	}
	*/
}

fail_mission_on_flag_carrier_death( player )
{
	if( level.onlineGame || level.systemLink )
	{
		player waittill( "disconnect" );
		if( isDefined(level.hands) )
		{
			level.hands Hide();
		}
		missionfailed();
	}
}

// self = the flag
spawn_highlight()
{
	highlight = Spawn( "script_model", self.origin );
	highlight.angles = self.angles;
	//highlight SetModel( "anim_berlin_russian_flag_obj" );
	highlight SetModel( "anim_berlin_rus_flag_rolled_obj" );
	self.highlight = highlight;
}

// self = the flag
get_offset_origin()
{
	return self.origin + level.russianFlagOriginOffset;
}

// self = the flag
get_offset_angles()
{
	return self.angles + level.russianFlagAnglesOffset;
}

// used for moving the flag to start spots
russian_flag_teleport( moveSpot )
{
	if( !flag( "russian_flag_setup" ) )
	{
		flag_wait( "russian_flag_setup" );
	}
	
	level.russianFlag.origin = moveSpot + ( level.russianFlagOriginOffset );
	
	if( !IsDefined( level.russian_flag_startthink ) )
	{
		maps\ber3b::russian_flag_startthink();
	}
}

// --- END FLAG CARRYING ---


// --- CUSTOM SPAWN FUNCTION SETUP ---
//does add_spawn_function on all the spawners that need custom behavior.
setup_spawn_functions()
{
	// foyer: redshirts in a line, already fighting at the first cover area
	group_add_spawn_function( "spawner_foyer_redshirts_1", ::ai_safe_until_trigger, "trig_foyer_entrance", "targetname", 5 );
	
	// foyer: redshirts who die at the entrance to the foyer
	group_add_spawn_function( "spawner_foyer_flagbearer_buddy", maps\ber3b_event_foyer::foyer_flagbearer_buddies_spawnfunc );
	
	// foyer pacing area: redshirts who run down the hall in front of the player
	group_add_spawn_function( "spawner_foyer_pacing_friendly_hallrunners", maps\ber3b_event_foyer::foyer_pacing_friendly_hallrunners_spawnfunc );
		
	// parliament: guys spawning during balcony objective
	array_thread( GetEntArray( "spawner_parliament_enemy", "script_noteworthy"), ::add_spawn_function, maps\ber3b_event_parliament::parliament_enemy_spawnfunc );
		
	// parliament: flamethrower dudes
	group_add_spawn_function( "spawner_parliament_flamer", maps\ber3b_event_parliament::flamer_setup );
	array_thread( GetEntArray( "spawner_parliament_flamer", "script_noteworthy"), ::add_spawn_function, maps\ber3b_event_parliament::flamer_setup );
}

group_add_spawn_function( groupTN, spawnFunc, param1, param2, param3 )
{
	group = GetEntArray( groupTN, "targetname" );
	ASSERTEX( IsDefined( group ) && group.size > 0, "Couldn't find group with targetname of '" + groupTN + "'." );
	
	for( i = 0; i < group.size; i++ )
	{
		group[i] add_spawn_function( spawnFunc, param1, param2, param3 );
	}
}
// --- END CUSTOM SPAWN FUNCTION SETUP ---


// --- DIFFICULTY SCALING ---
difficulty_scale()
{
	removeWeapons = false;
	
	switch( GetDifficulty() )
	{
		case "easy":
		level.ber3b_superenemy_frac = 0.15;
		level.ber3b_friendly_accuracy = 0.2;
		level.ber3b_player_threatbias = 7000;
		level.ber3b_friendly_suppression_wait = 2000;
		break;
		
		case "medium":
		level.ber3b_superenemy_frac = 0.4;
		level.ber3b_friendly_accuracy = 0.1;
		level.ber3b_player_threatbias = 20000;
		level.ber3b_friendly_suppression_wait = 3000;
		break;
		
		case "hard":
		removeWeapons = true;
		level.ber3b_superenemy_frac = 0.55;
		level.ber3b_friendly_accuracy = 0.08;
		level.ber3b_player_threatbias = 40000;
		level.ber3b_friendly_suppression_wait = 4000;
		break;
		
		case "fu":
		removeWeapons = true;
		level.ber3b_superenemy_frac = 0.65;
		level.ber3b_friendly_accuracy = 0.05;
		level.ber3b_player_threatbias = 45000;
		level.ber3b_friendly_suppression_wait = 5500;
		break;
	}
	
	if( removeWeapons )
	{
		pickups = GetEntArray( "weapon_diff_remove", "targetname" );
		array_thread( pickups, ::scr_delete );
	}
	
	array_thread( get_players(), ::player_set_threatbias );
	
	level thread super_enemies();
	level thread gimp_friendlies();
}

player_set_threatbias()
{
	while( !IsDefined( level.ber3b_player_threatbias ) )
	{
		wait( 0.05 );
	}
	
	self.threatbias = level.ber3b_player_threatbias;
}

super_enemies()
{
	level endon( "stop_super_enemies" );
	
	level.superenemies = [];
	
	while( 1 )
	{
		ais = GetAIArray( "axis" );
		
		if( array_validate( ais ) )
		{
			while( level.superenemies.size < ( ais.size * level.ber3b_superenemy_frac ) )
			{
				level thread superenemy_create( ais );
			}
		}
		
		wait( 2.5 );
	}
}

superenemy_create( ais )
{
	guy = undefined;
	
	for( i = 0; i < ais.size; i++ )
	{
		if( !IsDefined( ais[i] ) || IsDefined( ais[i].isSuperEnemy ) )
		{
			continue;
		}
		else
		{
			guy = ais[i];
		}
	}
	
	guy.isSuperEnemy = true;
	guy.accuracy = RandomFloatRange( 0.65, 0.85 );
	guy.suppressionwait = RandomIntRange( 0, 1000 );
	
	level.superenemies[level.superenemies.size] = guy;
	guy thread superenemy_remove_on_death();
}

superenemy_remove_on_death()
{
	self waittill( "death" );
	
	level.superenemies = array_remove( level.superenemies, self );
}

gimp_friendlies()
{
	level endon( "stop_gimping_friendlies" );
	
	while( 1 )
	{
		ais = GetAIArray( "allies" );
		
		if( array_validate( ais ) )
		{
			for( i = 0; i < ais.size; i++ )
			{
				if( ais[i].suppressionwait != level.ber3b_friendly_suppression_wait )
				{
					ais[i].suppressionwait = level.ber3b_friendly_suppression_wait;
				}
				
				if( ais[i].accuracy != level.ber3b_friendly_accuracy )
				{
					ais[i].accuracy = level.ber3b_friendly_accuracy;
				}
			}
		}
		
		wait( 1.5 );
	}
}
// --- END DIFFICULTY SCALING ---


// --- HONORGUARD SPECIAL COMBAT DIALOGUE ---
honorguard_combat_dialogue()
{
	trigger_wait( "trig_roof_entrance", "targetname" );
	
	lines[0] = "fur_deutschland";
	lines[1] = "give_lives_for_germany";
	lines[2] = "fur_das_fuhrer";
	lines[3] = "deutschland_uber_alles";
	lines[4] = "fur_den_ruhm";
	lines[5] = "give_lives_for_fuhrer";
	lines[6] = "berlin_never_yours";
	lines[7] = "take_them_with_you";
	
	lines_ogsize = lines.size;
	
	while( 1 )
	{
		temp_lines = lines;
		
		while( array_validate( temp_lines ) )
		{
			theLine = temp_lines[RandomInt( temp_lines.size )];
			
			enemy = waittill_enemy_in_range_of_player( 375 );
			enemy say_dialogue( "honorguard_misc", theLine, true, false );
			
			temp_lines = array_remove( temp_lines, theLine );
			
			wait( RandomFloatRange( 5, 10 ) );
		}
	}
}
// --- HONORGUARD SPECIAL COMBAT DIALOGUE ---


// --- COOP FUNCTIONS ---
onPlayerConnect()
{
	while( 1 )
	{
		// initial server connection
		level waittill( "connecting", player );
		
		player thread onPlayerSpawned();
	}
}

// self = a player connected to the server
onPlayerSpawned()
{
	// need to loop because potentially this can happen more than once per player, since
	//  last stand just respawns the downed player when they're rezzed.
	while( 1 )
	{
		// waittill the player spawns
		self waittill("spawned_player");
		
		self thread player_set_threatbias();
	}
}
// --- END COOP FUNCTIONS ---
