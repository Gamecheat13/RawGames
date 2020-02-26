#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_net; 
#include maps\mp\zombies\_zm_utility; 
#include maps\mp\zombies\_zm_weapons; 

//
//
//
init()
{
	//////////////////////////////////////////////////////////////////////////////////////
	//
	// Zombie Window and Blockers speaks between two main scripts _zombiemode_blockers
	// and _zombiemode_spawner and _zombimode _utility
	//
	//
	//
	//
	//
	//
	//
	//
	//////////////////////////////////////////////////////////////////////////////////////
	
	
	init_blockers(); 

//	level thread rebuild_barrier_think(); 

	//////////////////////////////////////////
	//designed by prod
	//set_zombie_var( "rebuild_barrier_cap_per_round", 500 );
	//////////////////////////////////////////
	
  	if ( isdefined( level.quantum_bomb_register_result_func ) )
  	{
  		[[level.quantum_bomb_register_result_func]]( "open_nearest_door", ::quantum_bomb_open_nearest_door_result, 35, ::quantum_bomb_open_nearest_door_validation );
  	}
}


//
//	BLOCKERS
//
init_blockers()
{
	// EXTERIOR BLOCKERS ----------------------------------------------------------------- //
	level.exterior_goals = getstructarray( "exterior_goal", "targetname" ); 
	array_thread(level.exterior_goals, ::blocker_init);

	// DOORS ----------------------------------------------------------------------------- //
	zombie_doors = GetEntArray( "zombie_door", "targetname" ); 
	if(IsDefined(zombie_doors))
	{
		flag_init("door_can_close");
		array_thread(zombie_doors, ::door_init);
	}
	// DEBRIS ---------------------------------------------------------------------------- //
	zombie_debris = GetEntArray( "zombie_debris", "targetname" ); 
	array_thread(zombie_debris, ::debris_init);

	// Flag Blockers ---------------------------------------------------------------------- //
	flag_blockers = GetEntArray( "flag_blocker", "targetname" );
	array_thread(flag_blockers, ::flag_blocker);
}


//
// DOORS --------------------------------------------------------------------------------- //
//
door_init()
{
	self.type = undefined; 
	self.purchaser = undefined;	
	self._door_open = false;


	// Figure out what kind of door we are
	targets = GetEntArray( self.target, "targetname" ); 
	
	//CHRIS_P - added script_flag support for doors as well
	if( isDefined(self.script_flag) && !IsDefined( level.flag[self.script_flag] ) ) 
	{
		// Initialize any flags called
		if( IsDefined( self.script_flag ) )
		{
			tokens = Strtok( self.script_flag, "," );
			for ( i=0; i<tokens.size; i++ )
			{
				flag_init( self.script_flag );
			}
		}

	}	

	// Door trigger types
	if ( !IsDefined( self.script_noteworthy ) )
	{
		self.script_noteworthy = "default";
	}

	//MM Consolidate type codes for each door into script_string
	self.doors = [];
	for(i=0;i<targets.size;i++)
	{
		targets[i] door_classify( self );
		if(!isDefined(targets[i].og_origin))
		{
			targets[i].og_origin = targets[i].origin;
			targets[i].og_angles = targets[i].angles;
		}
	}

	//assert( IsDefined( self.type ), "You must determine how this door opens. Specify script_angles, script_vector, or a script_noteworthy... Door at: " + self.origin ); 
	cost = 1000;
	if( IsDefined( self.zombie_cost ) )
	{
		cost = self.zombie_cost;
	}

	self SetCursorHint( "HINT_NOICON" );

	// MM (03/09/10) - Allow activation at any time in order to make it easier to open bigger doors.
//	self UseTriggerRequireLookAt();
	self thread door_think(); 

	// MM - Added support for electric doors.  Don't have to add them to level scripts
	if ( IsDefined( self.script_noteworthy ) )
	{
		if ( self.script_noteworthy == "electric_door" || self.script_noteworthy == "electric_buyable_door" )
		{
			self sethintstring(&"ZOMBIE_NEED_POWER");
//			self set_door_unusable();
			if( isDefined( level.door_dialog_function ) )
			{
				self thread [[ level.door_dialog_function ]]();
			}
			return;
		}
		else if ( self.script_noteworthy == "kill_counter_door" )
		{
			self sethintstring(&"ZOMBIE_DOOR_ACTIVATE_COUNTER", cost);
			return;
		}
	}

	self set_hint_string( self, "default_buy_door_" + cost );
}


//
//	Help fix-up doors not using script_string and also to reclassify non-door entities.
//
door_classify( parent_trig )
{
	if ( IsDefined(self.script_noteworthy) && self.script_noteworthy == "clip" )
	{
		parent_trig.clip = self;
		parent_trig.script_string = "clip";
	}
	else if( !IsDefined( self.script_string ) )
	{
		if( IsDefined( self.script_angles ) )
		{
			self.script_string = "rotate";
		}
		else if( IsDefined( self.script_vector ) )
		{
			self.script_string = "move";
		}
	}
	else
	{
		if ( !IsDefined( self.script_string ) )
		{
			self.script_string = "";
		}

		// Handle other script_strings here
		switch( self.script_string )
		{
		case "anim":
			assert( IsDefined( self.script_animname ), "Blocker_init: You must specify a script_animname for "+self.targetname ); 
			assert( IsDefined( level.scr_anim[ self.script_animname ] ), "Blocker_init: You must define a level.scr_anim for script_anim -> "+self.script_animname ); 
			assert( IsDefined( level.blocker_anim_func ), "Blocker_init: You must define a level.blocker_anim_func" ); 
			break;

		case "counter_1s":
			parent_trig.counter_1s = self;
			return;	// this is not a door element

		case "counter_10s":
			parent_trig.counter_10s = self;
			return;	// this is not a door element

		case "counter_100s":
			parent_trig.counter_100s = self;
			return;	// this is not a door element

		case "explosives":
			if ( !IsDefined(parent_trig.explosives) )
			{
				parent_trig.explosives = [];
			}
			parent_trig.explosives[parent_trig.explosives.size] = self;
			return;	// this is not a door element
		}
	}

	if ( self.classname == "script_brushmodel" )
	{
		self DisconnectPaths();
	}
	parent_trig.doors[parent_trig.doors.size] = self;
}


//
//	Someone just tried to buy the door
//		return true if door was bought
//		NOTE: This is currently intended to be used as a non-threaded call 
//	self is a door trigger
door_buy()
{
	self waittill( "trigger", who, force ); 

	if(GetDvarInt( "zombie_unlock_all") > 0 || is_true( force ) )
	{
		return true;		
	}	
	
	if( !who UseButtonPressed() )
	{
		return false;
	}

	if( who in_revive_trigger() )
	{
		return false;
	}

	if( is_player_valid( who ) )
	{
		players = GET_PLAYERS();
		if((IsDefined(self.purchaser) && self.purchaser == who) && self._door_open == true)
		{
			self.purchaser = undefined;
		}	
		else if (  who.score >= self.zombie_cost)
		{
			who maps\mp\zombies\_zm_score::minus_to_player_score( self.zombie_cost ); 
			who maps\mp\zombies\_zm_stats::increment_client_stat( "doors_purchased" );
			self.purchaser = who;
		}
		else // Not enough money
		{
			play_sound_at_pos( "no_purchase", self.doors[0].origin );
			who maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "door_deny", undefined, 0 );
			return false;
		}

	}

	return true;
}


//
//	Open a delay door once the time has expired
//	self is a door
door_delay()
{
	// Show explosives
	if ( IsDefined( self.explosives ) )
	{
		for ( i=0; i<self.explosives.size; i++ )
		{
			self.explosives[i] Show();
		}
	}

	// Now wait
	if (!IsDefined(self.script_int) )
	{
		self.script_int = 5;
	}

	// Turn off the triggers.
	all_trigs = getentarray( self.target, "target" ); 
	for( i = 0; i < all_trigs.size; i++ )
	{
		all_trigs[i] trigger_off(); 
	}

	wait (self.script_int);
	for ( i=0; i<self.script_int; i++ )
	{
		/#
		iprintln( self.script_int - i );
		#/
		wait(1);
	}

	// Time's Up!
	// Show explosives
	if ( IsDefined( self.explosives ) )
	{
		for ( i=0; i<self.explosives.size; i++ )
		{
			PlayFX( level._effect["def_explosion"], self.explosives[i].origin, AnglesToForward(self.explosives[i].angles) );
			self.explosives[i] Hide();
		}
	}
}


//
//	Initialize the countdown
//
kill_countdown()
{
	kills_remaining = self.kill_goal - level.total_zombies_killed;

	// Play initiate sound
	players = GET_PLAYERS();
	for (i=0; i<players.size; i++ )
	{
  		if( is_true( level.player_4_vox_override ) )
  		{
  			players[i] playlocalsound( "zmb_laugh_rich" );
  		}
  		else
  		{
  			players[i] playlocalsound( "zmb_laugh_child" );	
  		}
	}

	// Random number flipping to setup the counter
	level.kill_counter_hud FadeOverTime( 1.0 );
	level.kill_counter_hud.alpha = 1;		

	// Note: First 2 stages will be number flipping
	num_stages = 3;		// Only 1 digit counter
	if ( IsDefined( self.counter_10s ) )
	{
		num_stages = 4;	// 2-digit
	}
	else
	{
		num_stages = 5;	// 3-digit
	}

	time_per_stage = 1.0;	// how long to take for each phase
	steps = time_per_stage * num_stages / 0.1;		// 0.1 is the interval
	steps_per_stage = steps / num_stages;
	stage_num = 1;
	ones = 0;
	tens = 0;
	hundreds = 0;

	for (i=0; i<steps; i++ )
	{
		if ( i > steps_per_stage * stage_num )
		{
			stage_num++;
		}

		// 1s
		if ( num_stages - stage_num == 0 )
		{
			ones = kills_remaining % 10;
		}
		else
		{
			ones = i % 10;
		}
		self.counter_1s set_counter( ones );
	
		// 10s
		if ( IsDefined( self.counter_10s ) )
		{
			if ( num_stages - stage_num <= 1 )
			{
				tens = int( kills_remaining / 10 );
			}
			else
			{
				tens = i % 10;
			}
			self.counter_10s set_counter( tens );
		}

		if ( IsDefined( self.counter_100s ) )
		{
			if ( num_stages - stage_num <= 1 )
			{
				hundreds = int( kills_remaining / 100 );
			}
			else
			{
				hundreds = i % 10;
			}
			self.counter_100s set_counter( hundreds );
		}

		level.kill_counter_hud SetValue( hundreds*100 + tens*10 + ones );
		wait (0.1);
	}


	level.kill_counter_hud FadeOverTime( 1.0 );
	level.kill_counter_hud.color = ( 0.21, 0, 0 );

	// Now keep track of how many kills are needed
	while ( level.total_zombies_killed < self.kill_goal )
	{
		kills_remaining = self.kill_goal - level.total_zombies_killed;
		self.counter_1s set_counter( kills_remaining % 10 );
		if ( IsDefined( self.counter_10s ) )
		{
			self.counter_10s set_counter( int( kills_remaining / 10 ) );
		}
		if ( IsDefined( self.counter_100s ) )
		{
			self.counter_100s set_counter( int( kills_remaining / 100 ) );
		}
		level.kill_counter_hud SetValue( kills_remaining );

		level waittill( "zom_kill" );
	}

	// Zero!  Play end sound
	players = GET_PLAYERS();
	for (i=0; i<players.size; i++ )
	{
		players[i] playlocalsound( "zmb_perks_packa_ready" );
	}

	self.counter_1s set_counter( 0 );
	if ( IsDefined( self.counter_10s ) )
	{
		self.counter_10s set_counter( 0 );
	}
	if ( IsDefined( self.counter_100s ) )
	{
		self.counter_100s set_counter( 0 );
	}
	level.kill_counter_hud SetValue( 0 );
	wait(1.0);

	self notify( "countdown_finished" );
}

//
//	Open a delay door once the time has expired
//	self is a door
door_kill_counter()
{
//	flag_wait( "start_zombie_round_logic" ); 

	// init the counter
	counter = 0;
	if (!IsDefined(self.script_int) )
	{
		counter = 5;
	}
	else
	{
		counter = self.script_int;

		// formula for reducing the kills needed by number of players
		players = GET_PLAYERS();
		if ( players.size < 4 )
		{
			// Reduce it by 20% per person under three players
			fraction = int( counter * 0.2 );
			counter -= fraction * (4 - players.size );
		}
	}
	// Now randomize between that and +20%.
	counter = RandomIntRange( counter, Int(counter * 1.2)+1 );

/#
	if( GetDvarInt( "zombie_cheat" ) >= 1 )
	{
		counter = 0;
	}
#/

	assert( IsDefined( self.counter_1s ), "Door Kill counter needs a 'ones' digit model" );
	assert( (counter < 9 || IsDefined( self.counter_10s )), "Door Kill counter needs a 'tens' digit model" );
	assert( (counter < 99 || IsDefined( self.counter_100s )), "Door Kill counter needs a 'hundreds' digit model" );

	// Setup the Hud display
	level.kill_counter_hud = create_counter_hud();

	num_enemies = get_enemy_count();
	if ( level.zombie_total + num_enemies < counter )
	{
		level.zombie_total += counter - num_enemies;
	}

	// Turn off the triggers.
	all_trigs = getentarray( self.target, "target" ); 
	for( i = 0; i < all_trigs.size; i++ )
	{
		all_trigs[i] trigger_off(); 
	}

	// Now do the countdown
	self.kill_goal = level.total_zombies_killed + counter;
	self thread kill_countdown();

	self waittill( "countdown_finished" );

	level.kill_counter_hud destroy_hud();

	// Goal reached!  BOOM!
	self.counter_1s Delete();
	if ( IsDefined( self.counter_10s ) )
	{
		self.counter_10s Delete();
	}
	if ( IsDefined( self.counter_100s ) )
	{
		self.counter_100s Delete();
	}
	if ( IsDefined( self.explosives ) )
	{
		for ( i=0; i<self.explosives.size; i++ )
		{
			self.explosives[i] Hide();
		}
		PlayFX( level._effect["betty_explode"], self.explosives[0].origin, AnglesToForward(self.explosives[0].angles) );

		self.explosives[0] playsound( "mpl_kls_artillery_impact" );
	}
}


//
//	Make the door do its thing
//	self is a door
//	open: true makes the door open, false makes it close (reverse operation).  Defaults to TRUE
//		NOTE: open is currently ONLY supported for  "move" type doors
//	time is a time override
door_activate( time, open  )
{
	if ( !IsDefined(time) )
	{
		time = 1; 
		if( IsDefined( self.script_transition_time ) )
		{
			time = self.script_transition_time; 
		}
	}

	if ( !IsDefined( open ))
	{
		open = true;
	}

		
	self NotSolid();

	if(self.classname == "script_brushmodel")
	{
		if ( open )
		{
			self ConnectPaths();
		}	
	}

	if ( ( IsDefined( self.script_noteworthy )	&& self.script_noteworthy == "clip" ) ||
		( IsDefined( self.script_string )		&& self.script_string == "clip" ) )
	{
		if(!open)
		{
			self disconnectpaths();
			wait(.1);
			self Solid();
		}
		return;
	}
	
		// Prevent multiple triggers from making doors move more than once
	if ( IsDefined(self.door_moving) )
	{
		return;
	}
	self.door_moving = 1;
	

	if( IsDefined( self.script_sound ) )
	{
		if( open )
			playsoundatposition( self.script_sound, self.origin );
		else
			playsoundatposition( self.script_sound + "_close", self.origin );
	}
	else
	{
		play_sound_at_pos( "door_slide_open", self.origin );
	}

	// scale
	scale = 1;
	if ( !open )
	{
		scale = -1;
	}

	// MM - each door can now have a different opening style instead of
	//	needing to be all the same
	switch( self.script_string )
	{
	case "rotate":
		if(isDefined(self.script_angles))
		{
			rot_angle = self.script_angles;
			if(!open)
			{
				rot_angle = self.og_angles;
			}
			self RotateTo( rot_angle, time, 0, 0 ); 
			self thread door_solid_thread(); 
		}
		wait(randomfloat(.15));						
		break;
	case "move":
	case "slide_apart":
		if(isDefined(self.script_vector))
		{
			vector = VectorScale( self.script_vector, scale );
			if ( time >= 0.5 )
			{
				self MoveTo( self.origin + vector, time, time * 0.25, time * 0.25 ); 
			}
			else
			{
				self MoveTo( self.origin + vector, time ); 
			}
			self thread door_solid_thread();
			if ( !open )
			{
				self thread disconnect_paths_when_done();
			}
		}
		wait(randomfloat(.15));
		break;

	case "anim":
		//						self animscripted( "door_anim", self.origin, self.angles, level.scr_anim[ self.script_animname ] );
		self [[ level.blocker_anim_func ]]( self.script_animname ); 
		self thread door_solid_thread_anim();
		wait(randomfloat(.15));						
		break;

	case "physics":
		self thread physics_launch_door( self );
		wait(0.10);						
		break;
	}
}


//
//	Wait to be opened!
//	self is a door trigger
door_think()
{
	self endon("kill_door_think");

	// maybe the door the should just bust open instead of slowly opening.
	// maybe just destroy the door, could be two players from opposite sides..
	// breaking into chunks seems best.
	// or I cuold just give it no collision

	cost = 1000;
	if( IsDefined( self.zombie_cost ) )
	{
		cost = self.zombie_cost;
	}

	while( 1 )
	{
		switch( self.script_noteworthy )
		{
		case "electric_door":
			self self_and_flag_wait( "power_on" );
			self door_opened();
			return;

		case "electric_buyable_door":
			flag_wait( "power_on" );

			self set_hint_string( self, "default_buy_door_" + cost );
//			self UseTriggerRequireLookAt();

			if ( !self door_buy() )
			{
				continue;
			}
			break;

		case "delay_door":	// set timer and explode
			if ( !self door_buy() )
			{
				continue;
			}

			self door_delay();
			break;

		case "kill_counter_door":
 			if ( !self door_buy() )
 			{
 				continue;
 			}

			self door_kill_counter();
			self door_opened();
			return;
			
		default:
			if(isDefined( level._default_door_custom_logic))
			{
				self [[level._default_door_custom_logic]]();
				break;
			}		
			if ( !self door_buy() )
			{
				continue;
			}
			break;
		}

		self door_opened();
		if(!flag("door_can_close"))
		{
			break;
		}	
	}
}

self_and_flag_wait( msg )
{
	self endon( msg );
	
	if ( is_true( self.power_door_ignore_flag_wait ) )
	{
		level waittill( "forever" );
	}
	else
	{
		flag_wait( msg );
	}
}

door_opened()
{
	if ( !IsDefined( self._door_open ) || (self._door_open == false))
	{
		self._door_open = true;
		self notify("door_opened");				
	}
	else	// close the door instead.
	{
		self._door_open = false;
	}
	

	// Set any flags called
	if( IsDefined( self.script_flag ) && self._door_open == true )
	{
		tokens = Strtok( self.script_flag, "," );
		for ( i=0; i<tokens.size; i++ )
		{
			flag_set( tokens[i] );
		}
	}
	else if(IsDefined( self.script_flag ) && self._door_open == false)
	{
		tokens = Strtok( self.script_flag, "," );
		for ( i=0; i<tokens.size; i++ )
		{
			flag_clear( tokens[i] );
		}
	}	


	// Door has been activated, make it do its thing
	for(i=0;i<self.doors.size;i++)
	{
		// Don't thread this so the doors don't move at once
		self.doors[i] door_activate(self.doors[i].script_transition_time, self._door_open);
	}
	// Just play purchase sound on the first door
	if( self.doors.size )
	{
		play_sound_at_pos( "purchase", self.doors[0].origin );
	}

	// get all trigs for the door, we might want a trigger on both sides
	// of some junk sometimes		
	all_trigs = getentarray( self.target, "target" ); 
	for( i = 0; i < all_trigs.size; i++ )
	{
		all_trigs[i] trigger_off(); 
	}	

	// Check if doors can be closed.
	if(flag("door_can_close"))
	{
		wait(2.0);
		
		for( i = 0; i < all_trigs.size; i++ )
		{
			all_trigs[i] trigger_on(); 
		}	
	}
}


//
//	Launch the door!
//	self = door entity
//	door_trig = door trigger
physics_launch_door( door_trig )
{
	vec = VectorScale( VectorNormalize( self.script_vector ), 5 );
	self MoveTo( self.origin + vec, 0.1 );
	self waittill( "movedone" );

	self PhysicsLaunch( self.origin, self.script_vector *10 );
	wait(0.1);
	PhysicsExplosionSphere( VectorScale( vec, -1 ), 120, 1, 100 );

	wait(60);

	self delete();
}


//
//	Waits until it is finished moving and then returns to solid once no player is touching it
//		(So they don't get stuck).  The door is made notSolid initially, otherwise, a player
//		could block its movement or cause a player to become stuck.
//	self is a door
door_solid_thread()
{
	// MM - added support for movedone.
	self waittill_either( "rotatedone", "movedone" ); 

	self.door_moving = undefined;
	while( 1 )
	{
		players = GET_PLAYERS(); 
		player_touching = false; 
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] IsTouching( self ) )
			{
				player_touching = true; 
				break; 
			}
		}

		if( !player_touching )
		{
			self Solid(); 
			return; 
		}

		wait( 1 ); 
	}
}


//
//	Called on doors using anims.  It needs a different waittill, 
//		and expects the animname message to be the same as the one passed into scripted anim
//	self is a door
door_solid_thread_anim( )
{
	// MM - added support for movedone.
	self waittillmatch( "door_anim", "end" ); 

	self.door_moving = undefined;
	while( 1 )
	{
		players = GET_PLAYERS(); 
		player_touching = false; 
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] IsTouching( self ) )
			{
				player_touching = true; 
				break; 
			}
		}

		if( !player_touching )
		{
			self Solid(); 
			return; 
		}

		wait( 1 ); 
	}
}


//
//
//
disconnect_paths_when_done()
{
	self waittill_either( "rotatedone", "movedone" );

	self DisconnectPaths();
}

//
// DEBRIS - these are "doors" that consist of various pieces of piled objects
//		they lift up and disappear when bought.
//
debris_init()
{
	cost = 1000;
	if( IsDefined( self.zombie_cost ) )
	{
		cost = self.zombie_cost;
	}

	self set_hint_string( self, "default_buy_debris_" + cost );
	self setCursorHint( "HINT_NOICON" );
	
	if( isdefined (self.script_flag)  && !IsDefined( level.flag[self.script_flag] ) )
	{
		flag_init( self.script_flag ); 
	}

//	self UseTriggerRequireLookAt();
	self thread debris_think(); 
}


//
//	self is a debris trigger
//
debris_think()
{
	
	if( isDefined( level.custom_debris_function ) )
	{
		self [[ level.custom_debris_function ]]();
	}	
	
	while( 1 )
	{
		self waittill( "trigger", who, force ); 

		if(GetDvarInt( "zombie_unlock_all") > 0 || is_true( force ) )
		{
			//bypass.
		}
		else
		{	
			if( !who UseButtonPressed() )
			{
				continue;
			}
	
			if( who in_revive_trigger() )
			{
				continue;
			}
		}
		
		if( is_player_valid( who ) )
		{
			// Can we afford this door?
			players = GET_PLAYERS();
			if(GetDvarInt( "zombie_unlock_all") > 0)
			{
				// bypass charge.
			}
			else if ( /*players.size == 1 &&*/ who.score >= self.zombie_cost )
			{
				// solo buy
				who maps\mp\zombies\_zm_score::minus_to_player_score( self.zombie_cost ); 
			}
/*
			else if( level.team_pool[ who.team_num ].score >= self.zombie_cost )
			{
				// team buy
				who maps\mp\zombies\_zm_score::minus_to_team_score( self.zombie_cost ); 
			}
			else if( level.team_pool[ who.team_num ].score + who.score >= self.zombie_cost )
			{
				// team funds + player funds
				team_points = level.team_pool[ who.team_num ].score;
				who maps\mp\zombies\_zm_score::minus_to_player_score( self.zombie_cost - team_points ); 
				who maps\mp\zombies\_zm_score::minus_to_team_score( team_points ); 
			}
*/
			else
			{
				play_sound_at_pos( "no_purchase", self.origin );
				who maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "door_deny", undefined, 1 );
				continue;
			}

			// Okay remove the debris
			bbPrint( "zombie_uses: playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type door", who.name, who.score, level.round_number, self.zombie_cost, self.script_flag, self.origin );

			// delete the stuff
			junk = getentarray( self.target, "targetname" ); 

			// Set any flags called
			if( IsDefined( self.script_flag ) )
			{
				tokens = Strtok( self.script_flag, "," );
				for ( i=0; i<tokens.size; i++ )
				{
					flag_set( tokens[i] );
				}
			}

			play_sound_at_pos( "purchase", self.origin );
			level notify ("junk purchased");

			move_ent = undefined;
			clip = undefined;
			for( i = 0; i < junk.size; i++ )
			{	
				junk[i] connectpaths(); 
//				junk[i] add_new_zombie_spawners(); 

				if( IsDefined( junk[i].script_noteworthy ) )
				{
					if( junk[i].script_noteworthy == "clip" )
					{
						clip = junk[i];
						continue;
					}
				}

				struct = undefined;
				if( IsDefined( junk[i].script_linkTo ) )
				{
					struct = getstruct( junk[i].script_linkTo, "script_linkname" );
					if( IsDefined( struct ) )
					{
						move_ent = junk[i];
						junk[i] thread debris_move( struct );
					}
					else
					{
						junk[i] Delete();
					}
				}
				else
				{
					junk[i] Delete();
				}
			}
			
			// get all trigs, we might want a trigger on both sides
			// of some junk sometimes
			all_trigs = getentarray( self.target, "target" ); 
			for( i = 0; i < all_trigs.size; i++ )
			{
				all_trigs[i] delete(); 
			}

			if( IsDefined( clip ) )
			{
				if( IsDefined( move_ent ) )
				{
					move_ent waittill( "movedone" );
				}

				clip Delete();
			}
			
			break; 								
		}
	}
}


//
//	Moves the debris out of place
//	self is a debris piece
//
debris_move( struct )
{
	self script_delay();
	//chrisp - prevent playerse from getting stuck on the stuff
	self notsolid();
	
	self play_sound_on_ent( "debris_move" );
	playsoundatposition ("zmb_lightning_l", self.origin);
	if( IsDefined( self.script_firefx ) )
	{
		PlayFX( level._effect[self.script_firefx], self.origin );
	}

	// Do a little jiggle, then move.
	if( IsDefined( self.script_noteworthy ) )
	{
		if( self.script_noteworthy == "jiggle" )
		{
			num = RandomIntRange( 3, 5 );
			og_angles = self.angles;
			for( i = 0; i < num; i++ )
			{
				angles = og_angles + ( -5 + RandomFloat( 10 ), -5 + RandomFloat( 10 ), -5 + RandomFloat( 10 ) );
				time = RandomFloatRange( 0.1, 0.4 );
				self Rotateto( angles, time );
				wait( time - 0.05 );
			}
		}
	}

	time = 0.5;
	if( IsDefined( self.script_transition_time ) )
	{
		time = self.script_transition_time; 
	}

	self MoveTo( struct.origin, time, time * 0.5 );
	self RotateTo( struct.angles, time * 0.75 );

	self waittill( "movedone" );

	//Z2 commented out missing sound, wouldn't go past.
	//self play_sound_on_entity("couch_slam");

	if( IsDefined( self.script_fxid ) )
	{
		PlayFX( level._effect[self.script_fxid], self.origin );
		playsoundatposition("zmb_zombie_spawn", self.origin); //just playing the zombie_spawn sound when it deletes the blocker because it matches the particle.
	}

	self Delete();

}

blocker_disconnect_paths(start_node, end_node, two_way)
{
	if(!IsDefined(two_way))
		two_way = false;
		
	if(IsDefined(start_node) && IsDefined(end_node))
	{
		if(NodesAreLinked(start_node, end_node))
		{
			UnlinkNodes(start_node, end_node);
		}

		if(NodesAreLinked(end_node, start_node) && two_way == true)
		{
			UnlinkNodes(end_node, start_node);
		}
	}
}

blocker_connect_paths(start_node, end_node, two_way)
{
	if(IsDefined(start_node) && IsDefined(end_node))
	{
		if(!IsDefined(two_way))
			two_way = false;		
			
		if(!NodesAreLinked(start_node, end_node))
		{
			LinkNodes(start_node, end_node);
		}

		if(!NodesAreLinked(end_node, start_node) && two_way == true)
		{
			LinkNodes(end_node, start_node);
		}
	}
}


//
// BLOCKER (aka window, bar, board)
// Self = exterior_goal, it is the node that targets all of the boards and bars
// This sets up every window in level,
blocker_init()
{
	if( !IsDefined( self.target ) ) // If the exterior_goal entity has no targets defined then return
	{
		return;
	}

	targets = GetEntArray( self.target, "targetname" ); // Grab all the pieces that are targeted by the exterior_goal

	self.barrier_chunks = []; // self has a newly defined array of barrier_chunks

	use_boards = true;

	if( level.mutators["mutator_noBoards"] )
	{
		use_boards = false;
	}

	for( j = 0; j < targets.size; j++ ) // count total targets of exterior_goal
	{
		if(targets[j] IsZBarrier())
		{
			self.zbarrier = targets[j];
			
			self.zbarrier.chunk_health = [];
			
			for( i = 0; i < self.zbarrier GetNumZBarrierPieces(); i ++)
			{
				self.zbarrier.chunk_health[i] = 0;
			}
			
			continue;
		}
		
		if( IsDefined( targets[j].script_noteworthy ) ) // If a script noteworthy is defined
		{
/*			if( targets[j].script_noteworthy == "clip" ) //  Grab the clip and continue
			{
				self.clip = targets[j]; // self.clip is defined from the array
				if(!use_boards)
				{
					self.clip connectpaths();
				}
				continue; // Go forward with the script
			} */
		}

		// jl/ jan/15/10 add new setup for grates	
		// I hide all the pieces you don't need to see right now.
		// This works
		// Now when they get pulled off, I just want them to swap out the model		
		
		if( IsDefined( targets[j].script_string ) && targets[j].script_string == "rock" )
		{
		    targets[j].material = "rock";
		}
		
		if( IsDefined( targets[j].script_parameters ) ) // If a script noteworthy is defined
		{
			if( targets[j].script_parameters == "grate" )
			{
				if( IsDefined( targets[j].script_noteworthy ) ) // If a script noteworthy is defined
				{
					if( targets[j].script_noteworthy == "2" || targets[j].script_noteworthy == "3" || targets[j].script_noteworthy == "4" ||
					 targets[j].script_noteworthy == "5" || targets[j].script_noteworthy == "6")
					{
						// this is an improper setup because each piece is still sitting there
						targets[j] Hide(); // this grabs all the pieces and hides it
						/#
						IPrintLnBold(" Hide ");
						#/
					}
				}
			}
			//DCS: new pentagon system where barricade starts as new and is repaired with boards, etc.
			// start with repair boards hidden.
			else if( targets[j].script_parameters == "repair_board" )
			{
				targets[j].unbroken_section = GetEnt(targets[j].target,"targetname");
				if(IsDefined(targets[j].unbroken_section))
				{
					targets[j].unbroken_section LinkTo(targets[j]);
					targets[j] Hide();
					targets[j] notSolid();
					targets[j].unbroken = true;
					
					// self is the goal (level.exterior_goals)
					if(IsDefined(targets[j].unbroken_section.script_noteworthy) && targets[j].unbroken_section.script_noteworthy == "glass")
					{
						targets[j].material = "glass";
						targets[j] thread destructible_glass_barricade(targets[j].unbroken_section, self);
					}
					else if(IsDefined(targets[j].unbroken_section.script_noteworthy) && targets[j].unbroken_section.script_noteworthy == "metal")
					{
						targets[j].material = "metal";
					}
				}	
			}
			else if( targets[j].script_parameters == "barricade_vents" )
			{
				targets[j].material = "metal_vent";
			}					
		}
			
		if( IsDefined ( targets[j].targetname ) )
		{
			if( targets[j].targetname == "auto2" )
			{
				//	 targets[j]
			}
		}

		if( use_boards )
		{
			targets[j] update_states("repaired"); // Change state to repaired
			targets[j].destroyed = false;
			targets[j] show();
			
		}
		else
		{
			targets[j] update_states("destroyed");
			targets[j].destroyed = true;
			targets[j] Hide();
			targets[j] notSolid();
		}
		targets[j].claimed = false;
		targets[j].anim_grate_index = 0; // check this index to know where each piece is
		// I can create another thing to track here if I need to
		targets[j].og_origin = targets[j].origin; // This one piece's origin is defined by grabbing the starting origin 
		targets[j].og_angles = targets[j].angles; // The one piece's angles is defined by grabbing the starting angles 
		self.barrier_chunks[self.barrier_chunks.size] = targets[j]; // barrier_chunks is the total size of the bars windows or boards used 

	}

	target_nodes = GetNodeArray(self.target, "targetname" );
	
	for( j = 0; j < target_nodes.size; j++ ) // count total targets of exterior_goal
	{
		if(target_nodes[j].type == "Begin")
		{
			self.neg_start = target_nodes[j];
			
			if(isdefined(self.neg_start.target))
			{
				self.neg_end = getnode(self.neg_start.target, "targetname");
			}
			
			blocker_disconnect_paths(self.neg_start, self.neg_end);
		}		
	}
	
	if(isdefined(self.zbarrier))
	{
		if(isdefined(self.barrier_chunks))
		{
			for(i = 0; i < self.barrier_chunks.size; i ++)
			{
				self.barrier_chunks[i] delete();
			}
			
			self.barrier_chunks = [];
		}
	}

	if( isDefined(self.zbarrier) &&  should_delete_zbarriers() )
	{
		self.zbarrier delete();
		self.zbarrier = undefined;
		return;
	}

	self blocker_attack_spots(); // exterior_goal thread 
	
	if( use_boards )
	{
		//assert( IsDefined( self.clip ) );
		self.trigger_location = getstruct( self.target, "targetname" ); // trigger_location is the new name for exterior_goal targets -- which is auto1 in all cases

		self thread blocker_think(); // exterior_goal thread blocker_think
	}
}

should_delete_zbarriers()
{
	gametype = GetDvar( "ui_gametype" );
	if(!is_Classic() && !is_Standard() && gametype != "zgrief"  )
	{
		return true;
	}
	return false;
}

//-------------------------------------------------------------------------------
// DCS 090710:	glass barricade. Player can damage.
//							self is chunk, aka. repair_board
//-------------------------------------------------------------------------------
destructible_glass_barricade(unbroken_section, node)
{
	unbroken_section SetCanDamage( true );
	unbroken_section.health = 99999;
	unbroken_section waittill( "damage", amount, who);
	if( is_player_valid( who ) || who maps\mp\zombies\_zm_laststand::player_is_in_laststand())
	{
		self thread maps\mp\zombies\_zm_spawner::zombie_boardtear_offset_fx_horizontle( self, node );
		level thread remove_chunk( self, node, true );
		self update_states("destroyed");
		self notify("destroyed");
		self.unbroken = false;
		
	}	
}
//-------------------------------------------------------------------------------

// jl jan/05/10 
// Self = exterior_goal, it is the node that targets all of the boards and bars
// Creates three spots that the AI can now choose from to attack the window
blocker_attack_spots()
{

	spots = [];
	

	numSlots = self.zbarrier GetZBarrierNumAttackSlots();
	
	numSlots = int(max(numSlots, 1));
	
	if(numSlots % 2)
	{
		spots[spots.size] = groundpos_ignore_water_new( self.zbarrier.origin + ( 0, 0, 60 ) );
	}
	
	if(numSlots > 1)
	{
		reps = floor(numSlots / 2);
		
		slot = 1;
		
		for(i = 0; i < reps; i ++)
		{
			offset = self.zbarrier GetZBarrierAttackSlotHorzOffset() * (i + 1);
			
			spots[spots.size] = groundpos_ignore_water_new( spots[0] + ( AnglesToRight( self.angles ) * offset ) + ( 0, 0, 60 ) );
			
			slot ++;
			
			if(slot < numSlots)
			{
				spots[spots.size] = groundpos_ignore_water_new( spots[0] + ( AnglesToRight( self.angles ) * -offset ) + ( 0, 0, 60 ) );
				
				slot ++;
			}
		}
	}
	
	taken = []; // new array
	for( i = 0; i < spots.size; i++ ) // cycle through all spots and define as not taken
	{
		taken[i] = false;
	}

	self.attack_spots_taken = taken; // set attack_spots_taken to taken
	self.attack_spots = spots; // set attack_spots to spots

/#
		self thread debug_attack_spots_taken(); // self = exterior_goal
#/
}


blocker_choke()
{
	level._blocker_choke = 0;
	level endon("stop_blocker_think");
	while(1)
	{
		wait(0.05);
		level._blocker_choke = 0;
	}
}


// jl jan/05/10 
// Self = exterior_goal, it is the node that targets all of the boards and bars
blocker_think()
{
	level endon("stop_blocker_think");
	if(!IsDefined(level._blocker_choke))
	{
		level thread blocker_choke();
	}

	use_choke = false;
	
	if(IsDefined(level._use_choke_blockers) && level._use_choke_blockers == 1)
	{
		use_choke = true;
	}
	
	while( 1 ) // exterior_goal is going to constantly loop
	{
		wait( 0.5 ); 

		if(use_choke)
		{
			if(level._blocker_choke > 3)
			{
				wait(0.05);
			}
		}
		
		level._blocker_choke ++;

		if( all_chunks_intact( self, self.barrier_chunks ) ) // speak to _zm_utility and into all_chunks_intact function 
		{
			// if any piece has the state of not repaired then return false
			// if the board has been repaired then return true 
			continue;  
		}

		if( no_valid_repairable_boards( self, self.barrier_chunks ) )// speak to _zm_utility and into no_valid_repairable_boards function
		{
			// if any piece has been destroyed return false
			// if any piece is not destroyed then return true
			continue;
		}

		self blocker_trigger_think(); 
	}
}

player_fails_blocker_repair_trigger_preamble(player, players, trigger)
{
	if( !player IsTouching( trigger ) )
	{
		return true;
	}

	if( !is_player_valid( player ) )
	{
		return true; 
	}

	if( player in_revive_trigger() )
	{
		return true;
	}

	if( players.size == 1 && IsDefined( players[0].intermission ) && players[0].intermission == 1)
	{
		return true;
	}
	
	if( player hacker_active() )
	{
		return true;
	}
	
	if( !player UseButtonPressed() )
	{
		return true; 
	}	
	
	return false;
}

has_blocker_affecting_perk()
{
	has_perk = undefined;
	
	if( self hasperk( "specialty_fastreload" ) )
	{
		has_perk = "specialty_fastreload";
	}

	return has_perk;
}

do_post_chunk_repair_delay(has_perk)
{
	if( !self script_delay() )
	{
		wait( 1 ); 
	}	
}

handle_post_board_repair_rewards(cost)
{
	self maps\mp\zombies\_zm_stats::increment_client_stat( "boards" );	

	// set the score
	self.rebuild_barrier_reward += cost;
	if( self.rebuild_barrier_reward < level.zombie_vars["rebuild_barrier_cap_per_round"] )
	{
		self maps\mp\zombies\_zm_score::player_add_points( "rebuild_board", cost );
		self play_sound_on_ent( "purchase" );
		
	}
	// general contractor achievement for dlc 2. keep track of how many board player repaired.
	if(IsDefined(self.board_repair))
	{
		self.board_repair += 1;
	}
}

// Self = exterior_goal, it is the node that targets all of the boards and bars
// trigger_location 
// this function repairs the boards
blocker_trigger_think()
{
	if(is_true(level.no_board_repair)) // don't create the repair trigger if this is true
	{
		return;
	}
	
/#	println( "ZM >> TRIGGER blocker_trigger_think " );	#/
	level endon("stop_blocker_think");
	
	// They don't cost, they now award the player the cost...
	cost = 10;
	if( IsDefined( self.zombie_cost ) )
	{
		cost = self.zombie_cost; 
	}

	original_cost = cost;

	radius = 96; 
	height = 96; 

	if( IsDefined( self.trigger_location ) ) // this is defined in the blocker_init function
	{
		trigger_location = self.trigger_location; // trigger_location is the new name for exterior_goal targets -- which is auto1 in all cases
	}
	else
	{
		trigger_location = self; // if it is not defined then just use self as the trigger_location
	}

	if( IsDefined( trigger_location.radius ) ) // he is asking if it is defined here, yet he never defines it anywhere
	{
		radius = trigger_location.radius; 
	}

	if( IsDefined( trigger_location.height ) ) // he is asking if it is defined here, yet he never defines it anywhere
	{
		height = trigger_location.height; 
	}

	trigger_pos = groundpos( trigger_location.origin ) + ( 0, 0, 4 ); // this is from trigger_location and is reset to trigger_pos
	trigger = Spawn( "trigger_radius", trigger_pos, 0, radius, height ); // spawn in a trigger at the location of the exterior_goal
	trigger setTeamForTrigger( "allies" );
	trigger thread trigger_delete_on_repair(); // This function waits till the boards/bars are repaired 
	if(IsDefined(level._zombiemode_blocker_trigger_extra_thread))
	{
		trigger thread [[level._zombiemode_blocker_trigger_extra_thread]]();
	}
	/#
		if( GetDvarInt( "zombie_debug" ) > 0 ) // 
		{
			thread debug_blocker( trigger_pos, radius, height ); 
		}
	#/

	// Rebuilding no longer costs us money... It's rewarded
	
	//////////////////////////////////////////
	//designed by prod; NO reward hint (See DT#36173)
	trigger set_hint_string( self, "default_reward_barrier_piece" ); // this is the string to call when the player is the trigger
	//trigger thread blocker_doubler_hint( "default_reward_barrier_piece_", original_cost );
	//////////////////////////////////////////
	
	trigger SetCursorHint( "HINT_NOICON" ); 
	
	while( 1 ) // the trigger constantly loops here till while the player interacts with it.
	{
		trigger waittill( "trigger", player ); 

		
		has_perk = player has_blocker_affecting_perk(); 
		

		
		if( all_chunks_intact( self, self.barrier_chunks ) ) // barrier chunks are all the pieces targeted from the exterior_goal
		{
			// if any piece has the state of not repaired then return false
			// if the board has been repaired then return true 
			trigger notify("all_boards_repaired");
			return;
		}

		if( no_valid_repairable_boards( self, self.barrier_chunks ) ) // barrier chunks are all the pieces targeted from the exterior_goal
		{
			// if any piece has been destroyed return false
			// if any piece is not destroyed then return true
			trigger notify("no valid boards");
			return;
		}
	
		while( 1 )
		{
			players = GET_PLAYERS();

			if(player_fails_blocker_repair_trigger_preamble(player, players, trigger))
			{
				break;
			}
			
			if(isdefined(self.zbarrier))
			{
				chunk = get_random_destroyed_chunk(self, self.barrier_chunks);
				
				self thread replace_chunk( self, chunk, has_perk, is_true( player.pers_upgrades_awarded["board"] ) ); // writing out
			}
			else
			{
				chunk = get_random_destroyed_chunk( self, self.barrier_chunks ); // calls get_random_destroyed_chunk in _zm_utility, continue if the chunk was destroyed
	
				if(IsDefined(chunk.script_parameter) && chunk.script_parameters == "repair_board" || chunk.script_parameters == "barricade_vents")
				{
					if(IsDefined(chunk.unbroken_section))
					{
						chunk Show();
						chunk Solid();
						chunk.unbroken_section self_delete();
					}	
				}
				else
				{	
					chunk Show(); 			
				}
	
				if ( !isDefined( chunk.script_parameters ) || chunk.script_parameters == "board" || chunk.script_parameters == "repair_board" || chunk.script_parameters == "barricade_vents")
				{
					//sounds now played on client
					if(!is_true(level.use_clientside_board_fx))
					{
	
						if( !IsDefined( chunk.material ) || ( IsDefined( chunk.material ) && chunk.material != "rock" ) )
						{
							chunk play_sound_on_ent( "rebuild_barrier_piece" );
						}
						playsoundatposition ("zmb_cha_ching", (0,0,0));
					}
				}
				if ( chunk.script_parameters == "bar" )
				{
					chunk play_sound_on_ent( "rebuild_barrier_piece" );
					playsoundatposition ("zmb_cha_ching", (0,0,0));
				}
	
				// I need to do this in a different place	
				if(isdefined(chunk.script_parameters))
				{
					if( chunk.script_parameters == "bar"  )
					{	
						if(isdefined(chunk.script_noteworthy))
						{
							if(chunk.script_noteworthy == "5") // this is the far left , this bar now bends it does not leave
							{
								chunk hide();
							}
							else if(chunk.script_noteworthy == "3" ) 
							{
								chunk hide();
							}
						}
					}
				}
			
				self thread replace_chunk( self, chunk, has_perk, is_true( player.pers_upgrades_awarded["board"] ) ); // writing out
			}

			//assert( IsDefined( self.clip ) );
			if(IsDefined(self.clip))
			{
				self.clip enable_trigger(); 
				self.clip DisconnectPaths(); // the boards disconnect paths everytime they are used here
			}
			else
			{
				blocker_disconnect_paths(self.neg_start, self.neg_end);
			}
			
			//maps\_zombiemode_challenges::doMissionCallback( "zm_board_repair", player );	
			bbPrint( "zombie_uses: playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type repair", player.name, player.score, level.round_number, original_cost, self.target, self.origin );

			self do_post_chunk_repair_delay(has_perk);

			if( !is_player_valid( player ) )
			{
				break;
			}

			player handle_post_board_repair_rewards(cost);

			if( all_chunks_intact( self, self.barrier_chunks ) ) // This calls into _zm_utility
			{
				// if any piece has the state of not repaired then return false
				// if the board has been repaired then return true 
				trigger notify("all_boards_repaired");
				return;
			}

			if( no_valid_repairable_boards( self, self.barrier_chunks ) ) // This calls into _zm_utility
			{
				// if any piece has been destroyed return false
				// if any piece is not destroyed then return true
				trigger notify("no valid boards");
				return;
			}
			
		}
	}
}

random_destroyed_chunk_show( )
{
	wait( 0.5 );
	self Show(); 
}


// jl this calls a rumble and zombie scream on the players if they are next to a door being opened.
// call a distance check of the the last chunk replaced
door_repaired_rumble_n_sound()
{
	players = GET_PLAYERS();
	//players[0] PlayRumbleOnEntity("damage_heavy");
	// only do this if they are close enough
	// add distnace check

	for(i = 0; i < players.size; i++)
		{
			
			if (distance (players[i].origin, self.origin) < 150)
			{
			
				if(isalive(players[i]))
					//-- not usedif(isalive(players[i]) && (isdefined(players[i].pers["team"])) && (players[i].pers["team"] == team)) 
				{
					
				players[i] thread board_completion();
						
				}
			}
		}
}

board_completion()
{
	self endon ("disconnect");
	
		// need to be place a delay if done within a certain time frame
		//wait(1.2);
		//self play_sound_on_ent( "purchase" );
		//players[i] iprintlnbold("Entrance 1 is fixed!!!");
		//wait(0.3);
		//self play_sound_on_ent( "purchase" );
		//wait(0.3);
		//self play_sound_on_ent( "purchase" );
}


// self is a trigger that is spawned off of the exterior_goal entity.
trigger_delete_on_repair()
{
	while( IsDefined( self ) )
	{
		self waittill_either("all_boards_repaired", "no valid boards");
		self thread door_repaired_rumble_n_sound(); // jl added cool repair sound
		self delete(); // when the boards are totally repaired then delete your self
		break;
	}

}

blocker_doubler_hint( hint, original_cost )
{
	self endon( "death" );

	doubler_status = level.zombie_vars["zombie_powerup_point_doubler_on"];
	while( 1 )
	{
		wait( 0.5 );

		if( doubler_status != level.zombie_vars["zombie_powerup_point_doubler_on"] )
		{
			doubler_status = level.zombie_vars["zombie_powerup_point_doubler_on"];
			cost = original_cost;
			if( level.zombie_vars["zombie_powerup_point_doubler_on"] )
			{
				cost = original_cost * 2;
			}
	
			self set_hint_string( self, hint + cost );
		}
	}
}

rebuild_barrier_reward_reset()
{
	self.rebuild_barrier_reward = 0;
}

remove_chunk( chunk, node, destroy_immediately, zomb )
{
	chunk update_states("mid_tear");
	
	// jl dec 15 09
	// jl added check for differnt types of windows
	if(IsDefined(chunk.script_parameters))
	{
		if( chunk.script_parameters == "board" || chunk.script_parameters == "repair_board" || chunk.script_parameters == "barricade_vents") // jl this is new check to see if it is a board then do board anims, this needs to hold the entire function
		{
			chunk thread zombie_boardtear_audio_offset(chunk);
		}
	}
	
	if(IsDefined(chunk.script_parameters))
	{
		if( chunk.script_parameters == "bar" ) // jl this is new check to see if it is a board then do board anims, this needs to hold the entire function
		{
			chunk thread zombie_bartear_audio_offset(chunk);
		}
	}
	
	
	chunk NotSolid();
	// here I do a check for if it is a bar 
	
	//if ( isdefined( destroy_immediately ) && destroy_immediately)
	//{
	//	chunk.destroyed = true;
	//}
		
	fx = "wood_chunk_destory";
	if( IsDefined( self.script_fxid ) )
	{
		fx = self.script_fxid;
	}
	
	

		if ( IsDefined( chunk.script_moveoverride ) && chunk.script_moveoverride )
		{
			chunk Hide();
		}	
		
	
		// an origin is created and the current chunk is linked to it. Then it flings the chunk and deletes the origin	
		if ( IsDefined( chunk.script_parameters ) && ( chunk.script_parameters == "bar" ) )
		{
			
			// added top bar check so it goes less higher
			if( IsDefined ( chunk.script_noteworthy ) && ( chunk.script_noteworthy == "4" ) )
			{
				ent = Spawn( "script_origin", chunk.origin ); 
				ent.angles = node.angles +( 0, 180, 0 );
				
				//DCS 030711: adding potential for having max distance movement 
				//for boards in closets that aren't very deep.
				dist = 100; // base number.
				if(IsDefined(chunk.script_move_dist))
				{
						dist_max = chunk.script_move_dist - 100;
						dist = 100 + RandomInt(dist_max);
				}
				else
				{	
					dist = 100 + RandomInt( 100 );
				}
			
				dest = ent.origin + ( AnglesToForward( ent.angles ) * dist );
				trace = BulletTrace( dest + ( 0, 0, 16 ), dest + ( 0, 0, -200 ), false, undefined );
		
				if( trace["fraction"] == 1 )
				{
					dest = dest + ( 0, 0, -200 );
				}
				else
				{
					dest = trace["position"];
				}
			
		//		time = 1; 
				chunk LinkTo( ent ); 
		
				//time = ent fake_physicslaunch( dest, 200 + RandomInt( 100 ) );
				time = ent fake_physicslaunch( dest, 300 + RandomInt( 100 ) );

		
				if( RandomInt( 100 ) > 40 )
				{
					ent RotatePitch( 180, time * 0.5 );
				}
				else
				{
					ent RotatePitch( 90, time, time * 0.5 ); 
				}
				wait( time );
		
				chunk Hide();
			
				// try sending the notify now...
				wait( 0.1);
				//wait( 1 ); // the notify is sent out late... so I can't call it right away... 
				// I need to keep track of what the last peice is...
				ent Delete(); 
			}
			
			else
			{
				ent = Spawn( "script_origin", chunk.origin ); 
				ent.angles = node.angles +( 0, 180, 0 );


				//DCS 030711: adding potential for having max distance movement 
				//for boards in closets that aren't very deep.
				dist = 100; // base number.
				if(IsDefined(chunk.script_move_dist))
				{
						dist_max = chunk.script_move_dist - 100;
						dist = 100 + RandomInt(dist_max);
				}
				else
				{	
					dist = 100 + RandomInt( 100 );
				}

				dest = ent.origin + ( AnglesToForward( ent.angles ) * dist );
				trace = BulletTrace( dest + ( 0, 0, 16 ), dest + ( 0, 0, -200 ), false, undefined );
		
				if( trace["fraction"] == 1 )
				{
					dest = dest + ( 0, 0, -200 );
				}
				else
				{
					dest = trace["position"];
				}
			
		//		time = 1; 
				chunk LinkTo( ent ); 
		
				time = ent fake_physicslaunch( dest, 260 + RandomInt( 100 ) );
				
				// here you will do a random damage... however it would be better if you made them fall over
				// call damage function out of here so the wait doesn't interrupt normal flow.
				
				
				//time = ent fake_physicslaunch( dest, 200 + RandomInt( 100 ) );
		
				//forward = AnglesToForward( ent.angles + ( -60, 0, 0 ) ) * power ); 
				//ent MoveGravity( forward, time ); 
		
				if( RandomInt( 100 ) > 40 )
				{
					ent RotatePitch( 180, time * 0.5 );
				}
				else
				{
					ent RotatePitch( 90, time, time * 0.5 ); 
				}
				wait( time );
		
				chunk Hide();
			
				// try sending the notify now...
				wait( 0.1);
				//wait( 1 ); // the notify is sent out late... so I can't call it right away... 
				// I need to keep track of what the last peice is...
				ent Delete();
				
			}
			//if (isdefined( destroy_immediately ) && destroy_immediately)
			//{
			//	return;
			//}
			chunk update_states("destroyed");
			chunk notify( "destroyed" );			
		}

	if ( IsDefined ( chunk.script_parameters ) && chunk.script_parameters == "board" || chunk.script_parameters == "repair_board" || chunk.script_parameters == "barricade_vents" ) 
	{
		
			ent = Spawn( "script_origin", chunk.origin ); 
			ent.angles = node.angles +( 0, 180, 0 );
			
			//DCS 030711: adding potential for having max distance movement 
			//for boards in closets that aren't very deep.
				dist = 100; // base number.
				if(IsDefined(chunk.script_move_dist))
				{
						dist_max = chunk.script_move_dist - 100;
						dist = 100 + RandomInt(dist_max);
				}
				else
				{	
					dist = 100 + RandomInt( 100 );
				}
				
			dest = ent.origin + ( AnglesToForward( ent.angles ) * dist );
			trace = BulletTrace( dest + ( 0, 0, 16 ), dest + ( 0, 0, -200 ), false, undefined );
	
			if( trace["fraction"] == 1 )
			{
				dest = dest + ( 0, 0, -200 );
			}
			else
			{
				dest = trace["position"];
			}
		
	//		time = 1; 
			chunk LinkTo( ent ); 
	
			time = ent fake_physicslaunch( dest, 200 + RandomInt( 100 ) );
			//time = ent fake_physicslaunch( dest, 200 + RandomInt( 100 ) );
	
	//		forward = AnglesToForward( ent.angles + ( -60, 0, 0 ) ) * power ); 
	//		ent MoveGravity( forward, time ); 

			// DCS 090110: delete glass or wall piece before sending flying.
			//DCS 090910: but not metal.
			if(IsDefined(chunk.unbroken_section))
			{
				if(!IsDefined(chunk.material) || chunk.material != "metal")
				{
					chunk.unbroken_section self_delete();
				}	
			}
	
			if( RandomInt( 100 ) > 40 )
			{
				ent RotatePitch( 180, time * 0.5 );
			}
			else
			{
				ent RotatePitch( 90, time, time * 0.5 ); 
			}
			wait( time );

			// DCS 090910: let the metal vents go fly.
			if(IsDefined(chunk.unbroken_section))
			{
				if(IsDefined(chunk.material) && chunk.material == "metal")
				{
					chunk.unbroken_section self_delete();
				}	
			}

			chunk Hide();
						
			// try sending the notify now...
			wait( 0.1);
			//wait( 1 ); // the notify is sent out late... so I can't call it right away... 
			// I need to keep track of what the last peice is...
			ent Delete(); 
		
	
			//if (isdefined( destroy_immediately ) && destroy_immediately)
			//{
			//	return;
			//}
		
			chunk update_states("destroyed");
			chunk notify( "destroyed" );
		}

	
	if ( IsDefined ( chunk.script_parameters ) && ( chunk.script_parameters == "grate" ) )
	{
		// Only make the last piece of the grate get pulled off.
		if( IsDefined ( chunk.script_noteworthy ) && ( chunk.script_noteworthy == "6" ) )
		{
	//		angles = node.angles +( 0, 180, 0 );
	//		force = AnglesToForward( angles + ( -60, 0, 0 ) ) * ( 200 + RandomInt( 100 ) ); 
	//		chunk PhysicsLaunch( chunk.origin, force );
		
			ent = Spawn( "script_origin", chunk.origin ); 
			ent.angles = node.angles +( 0, 180, 0 );
			dist = 100 + RandomInt( 100 );
			dest = ent.origin + ( AnglesToForward( ent.angles ) * dist );
			trace = BulletTrace( dest + ( 0, 0, 16 ), dest + ( 0, 0, -200 ), false, undefined );
	
			if( trace["fraction"] == 1 )
			{
				dest = dest + ( 0, 0, -200 );
			}
			else
			{
				dest = trace["position"];
			}
		
	//		time = 1; 
			chunk LinkTo( ent ); 
	
			time = ent fake_physicslaunch( dest, 200 + RandomInt( 100 ) );
			//time = ent fake_physicslaunch( dest, 200 + RandomInt( 100 ) );
	
	//		forward = AnglesToForward( ent.angles + ( -60, 0, 0 ) ) * power ); 
	//		ent MoveGravity( forward, time ); 
	
			if( RandomInt( 100 ) > 40 )
			{
				ent RotatePitch( 180, time * 0.5 );
			}
			else
			{
				ent RotatePitch( 90, time, time * 0.5 ); 
			}
			wait( time );
			chunk Hide();
			//wait( 1 ); // the notify is sent out late... so I can't call it right away... 
			// I need to keep track of what the last peice is...
			ent Delete(); 
			chunk update_states("destroyed");
			chunk notify( "destroyed" );
		}
		
		else
		{
			chunk Hide();
			//chunk moveto( chunk.origin + ( 0, 0, -1000 ), 0.3, 0.1, 0.1 );
			chunk update_states("destroyed");
			chunk notify( "destroyed" );
		}
			//chunk Hide();
	}

	/*
	// this is kicking off but is to late to send the notify
	if( all_chunks_destroyed( node.barrier_chunks ) )
	{
	
		if( IsDefined( node.clip ) )
		{
			node.clip ConnectPaths(); 
			wait( 0.05 ); 
			node.clip disable_trigger(); 
		}
		else
		{
			for( i = 0; i < node.barrier_chunks.size; i++ )
			{
				node.barrier_chunks[i] ConnectPaths(); 
			}
		}
	}
	else
	{
		EarthQuake( RandomFloatRange( 1, 3 ), 0.9, chunk.origin, 500 ); 
	}
	*/
}


// jl dec 15 09
remove_chunk_rotate_grate( chunk )
{
	// this is going to rotate all of them.. I need to some how do this off of the node pointing to it..
	//chunk_rotate_piece = GetEntArray( "grate", "script_parameters");
	
	//chunk_rotate_piece = GetEnt( "grate", "script_parameters");
	//chunk vibrate(( 0, 270, 0 ), 0.2, 0.4, 0.4);
	
	
	// how do I only effect the one for that window and not affect all of them
	// This is actually checked every time
	
	if( IsDefined (chunk.script_parameters) && chunk.script_parameters == "grate" ) //&& chunk.script_parameters != "grate" )
	{
		chunk vibrate(( 0, 270, 0 ), 0.2, 0.4, 0.4);	
		return;
	}
}

// jl just for now I added an audio offset to give more length and depth to the tearing off feeling
// i should add these to the same area where the fx is called, which is zombie_boardtear_offset_fx_horizontle(chunk) 
// in zombiemode_spawner
zombie_boardtear_audio_offset(chunk)
{
	if( IsDefined(chunk.material) && !IsDefined( chunk.already_broken ) )
	    chunk.already_broken = false;
	
	if( IsDefined(chunk.material) && chunk.material == "glass" && chunk.already_broken == false )
	{
	    chunk PlaySound( "zmb_break_glass_barrier" );
	    wait( randomfloatrange( 0.3, 0.6 ));
	    chunk PlaySound( "zmb_break_glass_barrier" );
	    chunk.already_broken = true;
	}
	else if( IsDefined(chunk.material) && chunk.material == "metal" && chunk.already_broken == false )
	{
	    chunk PlaySound( "grab_metal_bar" );
	    wait( randomfloatrange( 0.3, 0.6 ));
	    chunk PlaySound( "break_metal_bar" );
	    chunk.already_broken = true;
	}	
	else if( IsDefined(chunk.material) && chunk.material == "rock" )
	{
	    if(!is_true(level.use_clientside_rock_tearin_fx))
			{
	    	chunk PlaySound( "zmb_break_rock_barrier" );
	    	wait( randomfloatrange( 0.3, 0.6 ));
	    	chunk PlaySound( "zmb_break_rock_barrier" );
	    }
	    chunk.already_broken = true;
	}
	else if( IsDefined(chunk.material) && chunk.material == "metal_vent")
	{
			if(!is_true(level.use_clientside_board_fx))
			{
	    	//chunk PlaySound( "evt_vent_slat_grab" );
	    	//wait( randomfloatrange( 0.3, 0.6 ));
	    	chunk PlaySound( "evt_vent_slat_remove" );
	  	}
	}		
	else
	{
			if(!is_true(level.use_clientside_board_fx))
			{
	    	chunk play_sound_on_ent( "break_barrier_piece" );
	    	wait( randomfloatrange( 0.3, 0.6 )); // 06 might be too much, a little seperation sounds great...
	    	chunk play_sound_on_ent( "break_barrier_piece" );
	    }
	    chunk.already_broken = true;
	}
}

zombie_bartear_audio_offset(chunk)
{
	chunk play_sound_on_ent( "grab_metal_bar" );
	//iprintlnbold("RRIIIPPPPP!!!");
	wait( randomfloatrange( 0.3, 0.6 ));
	chunk play_sound_on_ent( "break_metal_bar" );
	wait( randomfloatrange( 1.0, 1.3 ));
	chunk play_sound_on_ent( "drop_metal_bar" );
}

ensure_chunk_is_back_to_origin( chunk )
{
	if ( chunk.origin != chunk.og_origin )
	{
		chunk notsolid();
		chunk waittill( "movedone" );
	}
}

replace_chunk( barrier, chunk, perk, upgrade, via_powerup )
{
	if(!isdefined(barrier.zbarrier))
	{
		chunk update_states("mid_repair");
		assert( IsDefined( chunk.og_origin ) );
		assert( IsDefined( chunk.og_angles ) );
		
		sound = "rebuild_barrier_hover";
		if( IsDefined( chunk.script_presound ) )
		{
			sound = chunk.script_presound;
		}		
		
	}
	
	has_perk = false;

	if( isDefined( perk ) )
	{
		has_perk = true;
	}
	

	if( !isdefined( via_powerup  ) && isdefined(sound))
	{
		play_sound_at_pos( sound, chunk.origin );
	}


	if(upgrade)
	{
		barrier.zbarrier ZBarrierPieceUseUpgradedModel(chunk);
		barrier.zbarrier.chunk_health[chunk] = barrier.zbarrier GetUpgradedPieceNumLives(chunk);
	}
	else
	{
		barrier.zbarrier ZBarrierPieceUseDefaultModel(chunk);
		barrier.zbarrier.chunk_health[chunk] = 0;
	}
	
	scalar = 1.0;
	if(has_perk)
	{
		if("speciality_fastreload" == perk)	
		{
			scalar = 0.31;
		}
		else if("speciality_fastreload_upgrade" == perk)
		{
			scalar = 0.2112;
		}
	}
	
	barrier.zbarrier SetZBarrierPieceState(chunk, "closing", scalar);
	waitDuration = barrier.zbarrier GetZBarrierPieceAnimLengthForState(chunk, "closing", scalar);
	wait(waitDuration);

}

open_all_zbarriers()
{
	foreach ( barrier in level.exterior_goals )
	{
		if ( IsDefined( barrier.zbarrier ) )
		{
			for ( x = 0; x < barrier.zbarrier GetNumZBarrierPieces(); x++ )
			{
				barrier.zbarrier SetZBarrierPieceState( x, "opening" );
			}
		}
		
		if ( IsDefined( barrier.clip ) )
		{
			barrier.clip disable_trigger(); 
			barrier.clip ConnectPaths();
		}
		else
		{
			blocker_connect_paths( barrier.neg_start, barrier.neg_end );
		}			

	}
}

// Jl we want different audio for each type of board or bar when they are repaired
// Need tags so the off sets for the effects is less code.
zombie_boardtear_audio_plus_fx_offset_repair_horizontal( chunk )
{
	
	if(isDefined(chunk.material) && chunk.material == "rock" )
	{
		if(is_true(level.use_clientside_rock_tearin_fx))
		{
			chunk clearclientflag(level._ZOMBIE_SCRIPTMOVER_FLAG_ROCK_FX);//PlayFX( level._effect["wall_break"], chunk.origin );
		}
		else 
		{
			EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), chunk.origin, 150 ); // do I want an increment if more are gone...
			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (0, 0, 30));
			wait( randomfloatrange( 0.3, 0.6 )); // 06 might be too much, a little seperation sounds great...
			chunk play_sound_on_ent( "break_barrier_piece" );
			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (0, 0, -30));
		}
	}	
	else 
	{
		if(is_true(level.use_clientside_board_fx))
		{
			chunk clearclientflag(level._ZOMBIE_SCRIPTMOVER_FLAG_BOARD_HORIZONTAL_FX);
		}
		else 
		{
			EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), chunk.origin, 150 ); // do I want an increment if more are gone...
			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (0, 0, 30));
			wait( randomfloatrange( 0.3, 0.6 )); // 06 might be too much, a little seperation sounds great...
			chunk play_sound_on_ent( "break_barrier_piece" );
			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (0, 0, -30));
		}
	}
	

}

zombie_boardtear_audio_plus_fx_offset_repair_verticle( chunk )
{
	if(isDefined(chunk.material) && chunk.material == "rock")
	{
		if (is_true(level.use_clientside_rock_tearin_fx))
		{
			chunk clearclientflag(level._ZOMBIE_SCRIPTMOVER_FLAG_ROCK_FX);//PlayFX( level._effect["wall_break"], chunk.origin );
		}
		else
		{

			EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), chunk.origin, 150 ); // do I want an increment if more are gone...
			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (30, 0, 0));
			wait( randomfloatrange( 0.3, 0.6 )); // 06 might be too much, a little seperation sounds great...
			chunk play_sound_on_ent( "break_barrier_piece" );
			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (-30, 0, 0));
		}
	}
	else
	{
		if(is_true(level.use_clientside_board_fx))
		{
			chunk clearclientflag(level._ZOMBIE_SCRIPTMOVER_FLAG_BOARD_VERTICAL_FX);
		}
		else
		{
			EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), chunk.origin, 150 ); // do I want an increment if more are gone...
			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (30, 0, 0));
			wait( randomfloatrange( 0.3, 0.6 )); // 06 might be too much, a little seperation sounds great...
			chunk play_sound_on_ent( "break_barrier_piece" );
			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (-30, 0, 0));
		}
	}

	
}


zombie_gratetear_audio_plus_fx_offset_repair_horizontal( chunk )
{
	EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), chunk.origin, 150 ); // do I want an increment if more are gone...
	chunk play_sound_on_ent( "bar_rebuild_slam" );
	
		switch( randomInt( 9 ) ) // This sets up random versions of the bars being pulled apart for variety
		{
			case 0:
							PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin + (-30, 0, 0) );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFX( level._effect["fx_zombie_bar_break_lite"], chunk.origin + (-30, 0, 0) );
				break;
				
			case 1:
							PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin + (-30, 0, 0) );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin + (-30, 0, 0) );

				break;
				
			case 2:
							PlayFX( level._effect["fx_zombie_bar_break_lite"], chunk.origin + (-30, 0, 0) );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin + (-30, 0, 0) );
			
				break;
				
			case 3:
							PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin + (-30, 0, 0) );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFX( level._effect["fx_zombie_bar_break_lite"], chunk.origin + (-30, 0, 0) );
			
				break;
				
			case 4:
							PlayFX( level._effect["fx_zombie_bar_break_lite"], chunk.origin + (-30, 0, 0) );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFX( level._effect["fx_zombie_bar_break_lite"], chunk.origin + (-30, 0, 0) );
				break;
				
			case 5:
							PlayFX( level._effect["fx_zombie_bar_break_lite"], chunk.origin + (-30, 0, 0) );
				break;
			case 6:
							PlayFX( level._effect["fx_zombie_bar_break_lite"], chunk.origin + (-30, 0, 0) );
				break;
			case 7:
							PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin + (-30, 0, 0) );
				break;
			case 8:
							PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin + (-30, 0, 0) );
				break;
		} 
	
}


zombie_bartear_audio_plus_fx_offset_repair_horizontal( chunk )
{
	
	EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), chunk.origin, 150 ); // do I want an increment if more are gone...
	chunk play_sound_on_ent( "bar_rebuild_slam" );

	
		switch( randomInt( 9 ) ) // This sets up random versions of the bars being pulled apart for variety
		{			
			case 0:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right" );
				break;
				
			case 1:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right" );
				break;
				
			case 2:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right" );
				break;
				
			case 3:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right" );
				break;
				
			case 4:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right" );
				break;
				
			case 5:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left" );
				break;
			case 6:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right" );
				break;
			case 7:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_left" );
				break;
			case 8:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right" );
				break;
		} 
	
}

zombie_bartear_audio_plus_fx_offset_repair_verticle(chunk)
{
	EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), chunk.origin, 150 ); // do I want an increment if more are gone...
	chunk play_sound_on_ent( "bar_rebuild_slam" );
	
	
		switch( randomInt( 9 ) ) // This sets up random versions of the bars being pulled apart for variety
		{
			case 0:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom" );
				break;
				
			case 1:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom" );
				break;
				
			case 2:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom" );
				break;
				
			case 3:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom" );
				break;
				
			case 4:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom" );
				break;
				
			case 5:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top" );
				break;
			case 6:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom" );
				break;
			case 7:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top" );
				break;
			case 8:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom" );
				break;
		} 
}

add_new_zombie_spawners()
{
	if( isdefined( self.target ) )
	{
		self.possible_spawners = getentarray( self.target, "targetname" ); 
	}	

	if( isdefined( self.script_string ) )
	{
		spawners = getentarray( self.script_string, "targetname" ); 
		self.possible_spawners = ArrayCombine( self.possible_spawners, spawners, true, false );
	}	
	
	if( !isdefined( self.possible_spawners ) )
	{
		return; 
	}
	
	// add new check if they've been added already
	zombies_to_add = self.possible_spawners; 

	for( i = 0; i < self.possible_spawners.size; i++ )
	{
		self.possible_spawners[i].is_enabled = true;
		add_spawner( self.possible_spawners[i] );
	}
}

//
// Flag Blocker ----------------------------------------------------------------------------------- //
//

flag_blocker()
{
	if( !IsDefined( self.script_flag_wait ) )
	{
		AssertMsg( "Flag Blocker at " + self.origin + " does not have a script_flag_wait key value pair" );
		return;
	}

	if( !IsDefined( level.flag[self.script_flag_wait] ) )
	{
		flag_init( self.script_flag_wait ); 
	}

	type = "connectpaths";
	if( IsDefined( self.script_noteworthy ) )
	{
		type = self.script_noteworthy;
	}

	flag_wait( self.script_flag_wait );

	self script_delay();

	if( type == "connectpaths" )
	{
		self ConnectPaths();
		//FOCKER
		//iprintlnbold("BOARDS AREE ALL DOWN!!!");
		self disable_trigger();
		return;
	}

	if( type == "disconnectpaths" )
	{
		self DisconnectPaths();
		//iprintlnbold("BOARDS ARE ALL UP!!!");
		self disable_trigger();
		return;
	}

	AssertMsg( "flag blocker at " + self.origin + ", the type \"" + type + "\" is not recognized" );
}

update_states( states )
{
	assert( isdefined( states ) );
	
	self.state = states;

}


quantum_bomb_open_nearest_door_validation( position )
{
	range_squared = 180 * 180; // 15 feet

	zombie_doors = GetEntArray( "zombie_door", "targetname" ); 
	for( i = 0; i < zombie_doors.size; i++ )
	{
		if ( DistanceSquared( zombie_doors[i].origin, position ) < range_squared )
		{
			return true;
		}
	}

	zombie_airlock_doors = GetEntArray( "zombie_airlock_buy", "targetname" ); 
	for( i = 0; i < zombie_airlock_doors.size; i++ )
	{
		if ( DistanceSquared( zombie_airlock_doors[i].origin, position ) < range_squared )
		{
			return true;
		}
	}

	zombie_debris = GetEntArray( "zombie_debris", "targetname" ); 
	for( i = 0; i < zombie_debris.size; i++ )
	{
		if ( DistanceSquared( zombie_debris[i].origin, position ) < range_squared )
		{
			return true;
		}
	}

	return false;
}


quantum_bomb_open_nearest_door_result( position )
{
	range_squared = 180 * 180; // 15 feet

	zombie_doors = GetEntArray( "zombie_door", "targetname" ); 
	for( i = 0; i < zombie_doors.size; i++ )
	{
		if ( DistanceSquared( zombie_doors[i].origin, position ) < range_squared )
		{
			self thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "kill", "quant_good" );
			zombie_doors[i] notify( "trigger", self, true );
			[[level.quantum_bomb_play_area_effect_func]]( position );
			return;
		}
	}

	zombie_airlock_doors = GetEntArray( "zombie_airlock_buy", "targetname" ); 
	for( i = 0; i < zombie_airlock_doors.size; i++ )
	{
		if ( DistanceSquared( zombie_airlock_doors[i].origin, position ) < range_squared )
		{
			self thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "kill", "quant_good" );
			zombie_airlock_doors[i] notify( "trigger", self, true );
			[[level.quantum_bomb_play_area_effect_func]]( position );
			return;
		}
	}

	zombie_debris = GetEntArray( "zombie_debris", "targetname" ); 
	for( i = 0; i < zombie_debris.size; i++ )
	{
		if ( DistanceSquared( zombie_debris[i].origin, position ) < range_squared )
		{
			self thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "kill", "quant_good" );
			zombie_debris[i] notify( "trigger", self, true );
			[[level.quantum_bomb_play_area_effect_func]]( position );
			return;
		}
	}
}

