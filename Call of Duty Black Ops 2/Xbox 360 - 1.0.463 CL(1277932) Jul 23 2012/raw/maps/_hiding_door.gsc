#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility; 
#using_animtree( "hiding_door" );
door_main()
{
	setup_door_anims();

	main_door_guy();
	thread door_notetracks();

	level.hiding_door_spawner = ::hiding_door_spawner;
}

window_main()
{
	setup_window_anims();

	main_window_guy();
	thread window_notetracks();

	level.hiding_door_spawner = ::hiding_door_spawner;
}

setup_door_anims()
{
	level.scr_animtree[ "hiding_door" ] 						= #animtree;	
	level.scr_model[ "hiding_door" ] 							= "anim_jun_com_door_wood_handleft";

	level.scr_anim[ "hiding_door" ][ "close" ]					= %doorpeek_close_door;
	level.scr_anim[ "hiding_door" ][ "death_1" ]				= %doorpeek_deathA_door;
	level.scr_anim[ "hiding_door" ][ "death_2" ]				= %doorpeek_deathB_door;

//	level.scr_anim[ "hiding_door" ][ "fire_1" ]					= %doorpeek_fireA_door;
//	level.scr_anim[ "hiding_door" ][ "fire_2" ]					= %doorpeek_fireB_door;
	level.scr_anim[ "hiding_door" ][ "fire_3" ]					= %doorpeek_fireC_door;
	
	level.scr_anim[ "hiding_door" ][ "grenade" ]				= %doorpeek_grenade_door;

	level.scr_anim[ "hiding_door" ][ "idle" ][ 0 ]				= %doorpeek_idle_door;
	level.scr_anim[ "hiding_door" ][ "jump" ]					= %doorpeek_jump_door;
	level.scr_anim[ "hiding_door" ][ "kick" ]					= %doorpeek_kick_door;
	level.scr_anim[ "hiding_door" ][ "open" ]					= %doorpeek_open_door;

	level.scr_anim[ "hiding_door" ][ "leave" ]					= %doorpeek_jump_door;

	level.scr_anim[ "hiding_door" ][ "death_1_ends_closed" ]	= %doorpeek_deathA_door_ends_closed;
	level.scr_anim[ "hiding_door" ][ "death_2_ends_closed" ]	= %doorpeek_deathB_door_ends_closed;
	level.scr_anim[ "hiding_door" ][ "jump_ends_closed" ]		= %doorpeek_jump_door_ends_closed;
	level.scr_anim[ "hiding_door" ][ "leave_ends_closed" ]		= %doorpeek_jump_door_ends_closed;

	precachemodel( level.scr_model[ "hiding_door" ] );

	setup_model_overrides();
}

setup_window_anims()
{
	level.scr_animtree[ "hiding_window" ] 						= #animtree;	
	level.scr_model[ "hiding_window" ] 							= "anim_jun_shutters";

	level.scr_anim[ "hiding_window" ][ "close" ]				= %ai_shutterpeek_close_shutter;
	level.scr_anim[ "hiding_window" ][ "death_1" ]				= %ai_shutterpeek_death_A_shutter;
	level.scr_anim[ "hiding_window" ][ "death_2" ]				= %ai_shutterpeek_death_B_shutter;

	level.scr_anim[ "hiding_window" ][ "fire_1" ]				= %ai_shutterpeek_fire_A_shutter;
	level.scr_anim[ "hiding_window" ][ "fire_2" ]				= %ai_shutterpeek_fire_B_shutter;
	level.scr_anim[ "hiding_window" ][ "fire_3" ]				= %ai_shutterpeek_fire_C_shutter;
	
	level.scr_anim[ "hiding_window" ][ "grenade" ]				= %ai_shutterpeek_grenade_shutter;

	level.scr_anim[ "hiding_window" ][ "idle" ][ 0 ]			= %ai_shutterpeek_idle_shutter;
	level.scr_anim[ "hiding_window" ][ "open" ]					= %ai_shutterpeek_open_shutter;
	level.scr_anim[ "hiding_window" ][ "melee" ]				= %ai_shutterpeek_melee_shutter;

	level.scr_anim[ "hiding_window" ][ "hide_2_aim" ]			= %ai_shutterpeek_hide_2_stand_shutter;
	level.scr_anim[ "hiding_window" ][ "aim_2_hide" ]			= %ai_shutterpeek_stand_2_hide_shutter;

	level.scr_anim[ "hiding_window" ][ "fire_1_2ndstory" ]		= %ai_shutterpeek_2ndstory_fire_A_shutter;
	level.scr_anim[ "hiding_window" ][ "fire_2_2ndstory" ]		= %ai_shutterpeek_2ndstory_fire_B_shutter;
	level.scr_anim[ "hiding_window" ][ "fire_3_2ndstory" ]		= %ai_shutterpeek_2ndstory_fire_C_shutter;

	precachemodel( level.scr_model[ "hiding_window" ] );

	setup_model_overrides();
}

setup_model_overrides( model_type )
{
	spawners = GetEntArray( "hiding_door_spawner", "script_noteworthy" );

	for( i=0; i < spawners.size; i++ )
	{
		if( IsDefined(spawners[i].script_hidingdoor_model) )
		{
			precachemodel( spawners[i].script_hidingdoor_model );
		}
	}
}

#using_animtree("generic_human");
main_door_guy()
{
	setup_guy_door_anims();
}

main_window_guy()
{
	setup_guy_window_anims();
}

setup_guy_door_anims()
{

	level.scr_anim[ "hiding_door_guy" ][ "close" ]					= %doorpeek_close;
	level.scr_anim[ "hiding_door_guy" ][ "death_1" ]				= %doorpeek_deathA;
	level.scr_anim[ "hiding_door_guy" ][ "death_2" ]				= %doorpeek_deathB;

//	level.scr_anim[ "hiding_door_guy" ][ "fire_1" ]					= %doorpeek_fireA;
//	level.scr_anim[ "hiding_door_guy" ][ "fire_2" ]					= %doorpeek_fireB;
	level.scr_anim[ "hiding_door_guy" ][ "fire_3" ]					= %doorpeek_fireC;
	
	level.scr_anim[ "hiding_door_guy" ][ "grenade" ]				= %doorpeek_grenade;
	
	level.scr_anim[ "hiding_door_guy" ][ "idle" ][ 0 ]				= %doorpeek_idle;
	level.scr_anim[ "hiding_door_guy" ][ "jump" ]					= %doorpeek_jump;
	level.scr_anim[ "hiding_door_guy" ][ "kick" ]					= %doorpeek_kick;
	level.scr_anim[ "hiding_door_guy" ][ "open" ]					= %doorpeek_open;

	level.scr_anim[ "hiding_door_guy" ][ "leave" ]					= %doorpeek_jump;

	level.scr_anim[ "hiding_door_guy" ][ "death_1_ends_closed" ]	= %doorpeek_deathA;
	level.scr_anim[ "hiding_door_guy" ][ "death_2_ends_closed" ]	= %doorpeek_deathB;
	level.scr_anim[ "hiding_door_guy" ][ "jump_ends_closed" ]		= %doorpeek_jump;
	level.scr_anim[ "hiding_door_guy" ][ "leave_ends_closed" ]		= %doorpeek_jump;

	addNotetrack_sound( "hiding_door_guy", "sound door death",	"any", "scn_doorpeek_door_open_death" );
	addNotetrack_sound( "hiding_door_guy", "sound door open",	"any", "scn_doorpeek_door_open" );
	addNotetrack_sound( "hiding_door_guy", "sound door slam",	"any", "scn_doorpeek_door_slam" );
}

setup_guy_window_anims()
{

	level.scr_anim[ "hiding_window_guy" ][ "close" ]			= %ai_shutterpeek_close;
	level.scr_anim[ "hiding_window_guy" ][ "death_1" ]			= %ai_shutterpeek_death_A;
	level.scr_anim[ "hiding_window_guy" ][ "death_2" ]			= %ai_shutterpeek_death_B;

	level.scr_anim[ "hiding_window_guy" ][ "fire_1" ]			= %ai_shutterpeek_fire_A;
	level.scr_anim[ "hiding_window_guy" ][ "fire_2" ]			= %ai_shutterpeek_fire_B;
	level.scr_anim[ "hiding_window_guy" ][ "fire_3" ]			= %ai_shutterpeek_fire_C;
	
	level.scr_anim[ "hiding_window_guy" ][ "grenade" ]			= %ai_shutterpeek_grenade;
	
	level.scr_anim[ "hiding_window_guy" ][ "idle" ][ 0 ]		= %ai_shutterpeek_idle;
	level.scr_anim[ "hiding_window_guy" ][ "open" ]				= %ai_shutterpeek_open;
	level.scr_anim[ "hiding_window_guy" ][ "melee" ]			= %ai_shutterpeek_melee;

	level.scr_anim[ "hiding_window_guy" ][ "hide_2_aim" ]		= %ai_shutterpeek_hide_2_stand;
	level.scr_anim[ "hiding_window_guy" ][ "aim_2_hide" ]		= %ai_shutterpeek_stand_2_hide;

	level.scr_anim[ "hiding_window_guy" ][ "fire_1_2ndstory" ]	= %ai_shutterpeek_2ndstory_fire_A;
	level.scr_anim[ "hiding_window_guy" ][ "fire_2_2ndstory" ]	= %ai_shutterpeek_2ndstory_fire_B;
	level.scr_anim[ "hiding_window_guy" ][ "fire_3_2ndstory" ]	= %ai_shutterpeek_2ndstory_fire_C;

	addNotetrack_sound( "hiding_window_guy", "sound door death",	"any", "scn_doorpeek_door_open_death" );
	addNotetrack_sound( "hiding_window_guy", "sound door open",		"any", "scn_doorpeek_door_open" );
	addNotetrack_sound( "hiding_window_guy", "sound door slam",		"any", "scn_doorpeek_door_slam" );
}

door_notetracks()
{
	wait 0.05;
	maps\_anim::addNotetrack_customFunction( "hiding_door_guy",		"grenade_throw",	::hiding_door_guy_grenade_throw );
}

window_notetracks()
{
	wait 0.05;
	maps\_anim::addNotetrack_customFunction( "hiding_window_guy",	"grenade_throw",	::hiding_door_guy_grenade_throw );
}

hiding_door_spawner()
{
	// place a hiding_door_guy prefab and then place a spawner next to it with script_noteworthy "hiding_door_spawner". 
	// Spawn the guy however you like (trigger or script)
	// Target the spawner to a trigger, this trigger will make the guy open the door.
	// Alternatively put a script_flag_wait on the spawner. The guy will wait for the flag to be set before opening the door.
	// If you put neither, a trigger_radius will be spawned, using the radius of the spawner if a radius is set
		
	door_orgs = getentarray( "hiding_door_guy_org", "targetname" );
	assert( door_orgs.size, "Hiding door guy with export " + self.export + " couldn't find a hiding_door_org!" );
	
	door_org = getclosest( self.origin, door_orgs );
	assert( distancesquared( door_org.origin, self.origin ) < 256*256, "Hiding door guy with export " + self.export + " was not placed within 256 units of a hiding_door_org" );

	door_org.hiding_place_type = "door";
	if( IsDefined(door_org.script_parameters) )
	{
		door_org.hiding_place_type = door_org.script_parameters;
	}
	
	door_org.targetname = undefined; // so future searches won't grab this one
	door_model = getent( door_org.target, "targetname" );
	
	door_clip = getent( door_model.target, "targetname" );
	assert( IsDefined( door_model.target ) );
	
	pushPlayerClip = undefined;
	if ( IsDefined( door_clip.target ) )
	{
		pushPlayerClip = getent( door_clip.target, "targetname" );
	}
	if ( IsDefined( pushPlayerClip ) )
	{
		door_org thread hiding_door_guy_pushplayer( pushPlayerClip );
	}
	
	door_model delete(); // we spawn our own door, the one in the prefab is just to aid placement
	
	door = spawn_anim_model( "hiding_" + door_org.hiding_place_type );

	if( IsDefined(self.script_hidingdoor_model) )
	{
		door SetModel(self.script_hidingdoor_model);
	}

	recordEnt(door);
	
	door_org thread anim_first_frame( door, "fire_3" );
	
	if( IsDefined( door_clip ) )
	{
		door_clip linkto( door, "door_hinge_jnt" );
		door_clip disconnectPaths();
	}
	
	start_trigger = undefined;
	leave_trigger = undefined;
	if ( IsDefined( self.target ) )
	{
		trigger_array = getentarray( self.target, "targetname" );

		for( i=0; i < trigger_array.size; i++ )
		{
			trigger = trigger_array[i];

			// make sure it's actually a trigger
			if( !issubstr( trigger.classname, "trigger" ) )
			{
				continue;
			}
			// if it's got a leave noteworhty, use it to tell AI to stop hiding
			else if( IsDefined(trigger.script_noteworthy) && trigger.script_noteworthy == "leave" )
			{
				leave_trigger = trigger;
			}
			else
			{
				start_trigger = trigger;
			}
		}
	}
	
	if ( !IsDefined( self.script_flag_wait ) && !IsDefined( start_trigger ) )
	{
		radius = 200;
		if ( IsDefined( self.radius ) )
			radius = self.radius;
			
		// no trigger mechanism specified, so add a radius trigger
		start_trigger = spawn( "trigger_radius", door_org.origin, 0, radius, 48 );
	}

	// to fit under add_spawn_function's argument limit
	triggers = SpawnStruct();
	triggers.start_trigger = start_trigger;
	triggers.leave_trigger = leave_trigger;
	
	self add_spawn_function( ::hiding_door_guy, door_org, triggers, door, door_clip );
	self waittill( "spawned" );
}

hiding_door_guy( door_org, triggers, door, door_clip )
{
	self endon( "death" );
	self endon( "stop_hiding" );

	assert( IsDefined(door_org.hiding_place_type) );

	self.animname = "hiding_" + door_org.hiding_place_type + "_guy";
	self.grenadeammo = 2;
	self.overrideActorDamage = ::hiding_door_actor_damage;

	self disable_react();
	self.a.allow_weapon_switch = false;
	self.a.allow_sideArm = false;
	self.goalradius = 4;

	start_trigger = triggers.start_trigger;
	leave_trigger = triggers.leave_trigger;

	// store for later use
	self.hiding_door = SpawnStruct();
	self.hiding_door.door_org		= door_org;
	self.hiding_door.door			= door;
	self.hiding_door.door_clip		= door_clip;
	self.hiding_door.leave_trigger	= leave_trigger;

	self thread hiding_door_guy_cleanup();
	
	guy_and_door = [];
	guy_and_door[ guy_and_door.size ] = door;
	guy_and_door[ guy_and_door.size ] = self;
	
	starts_open = IsDefined(self.script_hidingdoor_starts_open) && self.script_hidingdoor_starts_open;
	if( starts_open )
	{
		// wait for trigger before closing the door
		door_org thread anim_loop_aligned( guy_and_door, "idle" );
	}
	else
	{
		door_org thread anim_first_frame( guy_and_door, "fire_3" );
	}

	if( IsDefined(leave_trigger) )
	{
		self thread hiding_door_leave_door();
	}
	
	// wait for trigger or the flag to start the behavior
	if ( IsDefined( start_trigger	) )
	{
		start_trigger waittill( "trigger" );
	}
	else
	{
		flag_wait( self.script_flag_wait );
	}

	self SetGoalPos( self.origin );

	// slam the door closed
	if ( starts_open )
	{
		door_org notify( "stop_loop" );
		door_org anim_single_aligned( guy_and_door, "close" );
	}

	// start a behavior
	if( IsDefined(self.script_hidingdoor_action) )
	{
		scene = self.script_hidingdoor_action;
		assert( scene == "kick" || scene == "jump" );

		self thread hiding_door_play_scene(scene);
	}
	else
	{
		self thread hiding_door_blindfire_loop( guy_and_door );
	}
}

hiding_door_blindfire_loop( guy_and_door )
{
	self endon( "death" );
	self endon( "stop_hiding" );

	assert( IsDefined(self.hiding_door) );
	assert( IsDefined(self.hiding_door.door_org) );

	grenadeThrowWaitTime = 5000; // wait 5 seconds
	lastGrenadeThrowTime = grenadeThrowWaitTime * -1;

	for ( ;; )
	{
		scene = get_anim_name("fire");
		
		if ( GetTime() > lastGrenadeThrowTime + grenadeThrowWaitTime && randomint( 100 ) < 25 * self.grenadeammo )
		{
			self.grenadeammo--;
			scene = get_anim_name("grenade"); // once the grenade throw has the notetrack we'll change this

			lastGrenadeThrowTime = GetTime();
		}

		self.hiding_door.door_org thread anim_single_aligned( guy_and_door, scene );

		// delay the settime by a frame or it wont work
		if( self.hiding_door.door_org.hiding_place_type == "door" )
		{
			delay_thread( 0.05, ::anim_set_time, guy_and_door, scene, 0.4 );
		}

		self.hiding_door.door_org waittill( scene );

		// go exposed
		if( scene == "hide_2_aim" )
		{
			// give full clip
			self.bulletsInClip = weaponClipSize( self.weapon );

			wait(3);

			self.hiding_door.door_org thread anim_single_aligned( guy_and_door, "aim_2_hide" );
			self.hiding_door.door_org waittill( "aim_2_hide" );
		}

		// loop the start frame of the fire anim while we wait
		self.hiding_door.door_org thread anim_single_aligned( guy_and_door, "fire_3" );

		wait_time = randomfloatrange( 1.5, 2.5 );
		timer = 0;
		while( timer < wait_time )
		{
			self.hiding_door.door_org anim_set_time( guy_and_door, "fire_3", 0.0 );

			timer += 0.05;
			wait(0.05);
		}

		self.hiding_door.door_org notify( "stop_loop" );
	}
}

hiding_door_play_scene(scene)
{
	assert( IsDefined(self.hiding_door) );
	assert( IsDefined(self.hiding_door.door) );
	assert( IsDefined(self.hiding_door.door_org) );
	assert( IsDefined(self.hiding_door.door_clip) );

	self hiding_door_stop_threads();
	self notify("left_door");

	guy_and_door = [];
	guy_and_door[ guy_and_door.size ] = self.hiding_door.door;
	guy_and_door[ guy_and_door.size ] = self;

	scene = get_anim_name(scene);

	self.hiding_door.door_org thread anim_single_aligned( guy_and_door, scene );

	wait( 0.5 );
	self.hiding_door.door_clip connectpaths();
}

hiding_door_guy_cleanup()
{
	assert( IsDefined(self.hiding_door) );
	assert( IsDefined(self.hiding_door.door_org) );
	assert( IsDefined(self.hiding_door.door_clip) );

	self endon( "stop_hiding" );

	// if the guy gets deleted before the sequence happens this thread will catch that and clean up any problems that could arise
	self waittill( "death" );
	
	// stop the looping animations because the guy is removed now
	self.hiding_door.door_org notify( "stop_loop" );
	
	thread hiding_door_death_door_connections( self.hiding_door.door_clip );
	self.hiding_door.door_org notify( "push_player" );

	ends_closed = IsDefined(self.script_hidingdoor_ends_closed) && self.script_hidingdoor_ends_closed;
	if( !ends_closed )
	{
		self.hiding_door.door_org thread anim_single_aligned( self.hiding_door.door, "death_2" );
	}
}

hiding_door_guy_pushplayer( pushPlayerClip )
{
	self waittill( "push_player" );
	pushPlayerClip moveto( self.origin, 1.5 );
	wait 3.0;
	pushPlayerClip delete();
}

hiding_door_guy_grenade_throw( guy )
{
	// called from a notetrack
	startOrigin = guy getTagOrigin( "J_Wrist_RI" );
	player = get_closest_player( guy.origin );	
	strength = ( distance( player.origin, guy.origin ) * 2.0 );
	if ( strength < 300 )
	{
		strength = 300;
	}
	if ( strength > 1000 )
	{
		strength = 1000;
	}
	vector = vectorNormalize( player.origin - guy.origin );
	velocity = VectorScale( vector, strength );
	guy magicGrenadeManual( startOrigin, velocity, randomfloatrange( 3.0, 5.0 ) );
}

hiding_door_death()
{
	assert( IsDefined(self.hiding_door) );
	assert( IsDefined(self.hiding_door.door_org) );
	assert( IsDefined(self.hiding_door.door) );
	assert( IsDefined(self.hiding_door.door_clip) );

	if ( !IsAlive( self ) )
	{
		return;
	}

	guys = [];
	guys[ guys.size ] = self.hiding_door.door;
	guys[ guys.size ] = self;

	thread hiding_door_death_door_connections( self.hiding_door.door_clip );

	self.hiding_door.door_org notify( "push_player" );
	self hiding_door_stop_threads();

	death_anim = get_anim_name("death");
	self set_deathanim( death_anim );

	// must delay this by a frame. don't know exactly why, but it's something to do with this being called from code.
	self.hiding_door.door_org delay_thread( 0.05, ::anim_single_aligned, guys, death_anim );

	wait( 0.5 );

	if ( IsAlive( self ) )
	{
		self DoDamage( self.health + 150, (0,0,0) );
	}
}

hiding_door_death_door_connections( door_clip )
{
	if( !IsDefined( door_clip ) )
	{
		return;
	}
	
	door_clip connectpaths();
	wait 2;
	door_clip disconnectpaths();
}

hiding_door_stop_threads()
{
	assert( IsDefined(self.hiding_door) );
	assert( IsDefined(self.hiding_door.door_org) );

	self notify( "stop_hiding" );

	self.overrideActorDamage = undefined;

	self clear_deathanim();

	self enable_react();
	self.a.allow_weapon_switch = true;
	self.a.allow_sideArm = true;
	self.goalradius = 2048;
}

hiding_door_actor_damage( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	self thread hiding_door_death();

	return 0;
}

hiding_door_leave_door()
{
	self endon("death");
	self endon("left_door");

	assert( IsDefined(self.hiding_door) );
	assert( IsDefined(self.hiding_door.door) );
	assert( IsDefined(self.hiding_door.leave_trigger) );

	anim_name = get_anim_name("leave");
	if( !animation_exists(self.animname, anim_name) )
	{
		return;
	}

	self.hiding_door.leave_trigger waittill( "trigger" );

	guy_and_door = [];
	guy_and_door[ guy_and_door.size ] = self.hiding_door.door;
	guy_and_door[ guy_and_door.size ] = self;

	thread hiding_door_death_door_connections( self.hiding_door.door_clip );

	self.hiding_door.door_org notify( "push_player" );
	self hiding_door_stop_threads();

	self.hiding_door.door_org thread anim_single_aligned( guy_and_door, anim_name );
}

pick_death_anim()
{
	death_choices = [];

	for( i=1; i < 3; i++ )
	{
		anim_name = "death_" + i;

		if( animation_exists(self.animname, anim_name) )
		{
			death_choices[ death_choices.size ] = anim_name;
		}
	}

	return death_choices[ RandomInt(death_choices.size) ];
}

pick_fire_anim()
{
	fire_choices = [];

	for( i=1; i < 4; i++ )
	{
		anim_name = "fire_" + i;

		if( animation_exists(self.animname, anim_name) )
		{
			fire_choices[ fire_choices.size ] = anim_name;
		}
	}

	if( animation_exists(self.animname, "hide_2_aim") )
	{
		fire_choices[ fire_choices.size ] = "hide_2_aim";
	}

	return fire_choices[ RandomInt(fire_choices.size) ];
}

get_anim_name( action )
{
	anim_name = action;

	switch(action)
	{
		case "fire":
			anim_name = pick_fire_anim();
			break;

		case "death":
			anim_name = pick_death_anim();
			break;
	}

	ends_closed = IsDefined(self.script_hidingdoor_ends_closed) && self.script_hidingdoor_ends_closed;
	enemy_is_below = IsDefined(self.enemy) && (self.origin[2] - self.enemy.origin[2]) > 100;

	if( ends_closed && animation_exists(self.animname, anim_name + "_ends_closed") )
	{
		anim_name += "_ends_closed";
	}

	if( enemy_is_below && animation_exists(self.animname, anim_name + "_2ndstory") )
	{
		anim_name += "_2ndstory";
	}

	return anim_name;
}