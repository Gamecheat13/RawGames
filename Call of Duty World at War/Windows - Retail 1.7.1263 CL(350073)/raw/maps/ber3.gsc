//
// file: ber3.gsc
// description: main level script for berlin3
// scripter: Joyal
//

#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\ber3_util;

main()
{
	maps\ber3_fx::main();  // set up level fx

	maps\_t34::main("vehicle_rus_tracked_t34", "t34");
	maps\_flak88::main( "artillery_ger_flak88" ); 
	maps\_katyusha::main("vehicle_rus_wheeled_bm13", "katyusha");
	//maps\_tiger::main( "vehicle_ger_tracked_king_tiger", "tiger" );
	maps\_artillery::main("artillery_ger_pak43", "pak43");
	maps\_stuka::main( "vehicle_stuka_flying" );
	maps\_aircraft::main( "vehicle_rus_airplane_il2", "il2" );	

	// Tread stuff
	maps\_vehicle::build_treadfx();

	build_starts();  // set up level starts	
	init_flags();  // set up level flags
	precache_models();
	
	setup_friendlies();
	setup_drones();
	
	maps\_load::main();  // COD magic		

	maps\ber3_anim::main();  // set up level anims
	thread maps\ber3_amb::main();  // kick off the audio scripts
	
	maps\ber3_anim::main();  // set up level anims
	setup_strings();  // set up localized string references for the level

	thread build_threatbias_groups();

	thread collectible_corpse_spawn( "collectible_struct", character\char_ger_honorguard_mp44::main );

	if(NumRemoteClients())
	{
		if(NumRemoteClients() > 1)
		{
			level.max_drones["allies"] = 6;
		}
		
		flag_wait("all_players_connected");
		
		clientNotify("dl");		// tell the client vms to go ahead and decorate the level with script models.
	}
}

precache_models()
{
	precacheshellshock( "ber3_intro" );
	precacheshellshock( "ber3_outro" );
	
	precachevehicle ("stuka");
	precachevehicle ("t34");
	
	PrecacheModel( "viewmodel_rus_guard_player" );
	PrecacheModel( "static_berlin_books_diary" );
	precachemodel( "vehicle_rus_airplane_il2" );
	PrecacheModel( "anim_berlin_rus_flag_rolled" );
	PrecacheModel( "anim_berlin_rus_flag_rolled_sm" );
	precacheModel("weapon_ger_panzershreck_rocket");
	PrecacheModel( "katyusha_rocket" );
	precachemodel( "weapon_usa_explosive_russian" );
	precachemodel( "weapon_rus_molotov_grenade" );
	precachemodel( "weapon_rus_ppsh_smg" );
	precachemodel( "anim_alley_brick_chunks" );
	precachemodel( "anim_berlin_nazi_burnt_flag" );
	precachemodel( "anim_berlin_stag_column" );
	precachemodel( "mounted_ger_fg42_bipod_lmg" );
	precachemodel( "char_ger_traitorsign" );
	precachemodel( "char_rus_guard_grachev_burn" );
	//precachemodel( "char_ger_wrmcht_fullbody1" );
	precachemodel( "static_peleliu_flak88_shell" );
	
	precachestring( &"BER3_HINT_PLANT_CHARGE" );
	//PrecacheItem("mosin_rifle");
	
	//CHRIS_P - add rumbles
	precacherumble( "tank_rumble");
		
}

setup_drones()
{
	character\char_rus_r_ppsh::precache();
	character\char_ger_honorguard_mp44::precache();
	
// Spawn Functions for Drones
	level.drone_spawnFunction["allies"] = character\char_rus_r_ppsh::main; 		
	level.drone_spawnFunction["axis"] = character\char_ger_honorguard_mp44::main;	
	
	// Init drones functionality or something like that	
	maps\_drones::init();		

}

build_starts()
{
	// intro event starts
	add_start( "intro", maps\ber3_event_intro::event_intro_start, &"BER3_WARP_INTRO" );
		
	// plaza event starts
	add_start( "plaza", maps\ber3_event_plaza::event_plaza_start, &"BER3_WARP_PLAZA" );
	
// plaza event starts
	add_start( "reich", maps\ber3_event_steps::event_reich_start, &"BER3_WARP_REICH" );	
	
	// default start
	add_start( "default", level.start_functions[ "intro" ] );
	default_start( level.start_functions[ "intro" ] );
	
	// turn off the introscreen if necessary
	start = tolower( GetDvar( "start" ) );
	//	if( IsDefined( start ) && start != "" && start != "default" && start != "intro" )
	if(isdefined(level.start_point) && level.start_point != "default")
	{
		SetDvar( "introscreen", "0" );  // disable the introscreen
	}
}

build_threatbias_groups()
{
	// Create new threat bias groups. 
	createthreatbiasgroup("panzer_group");
	createthreatbiasgroup("mg42_group");
	createthreatbiasgroup("player_group");
	
	// Make first group ignored by second group
	setignoremegroup( "player_group", "panzer_group" );
	setthreatbias( "player_group", "mg42_group", -1000 );
	
	spawners = getentarray("mg42_ai", "script_noteworthy");
	array_thread( spawners, ::add_spawn_function, ::mg42_set_threatgroup );
}


mg42_set_threatgroup()
{
	self setthreatbiasgroup("mg42_group");
}


init_flags()
{
	flag_init( "friends_setup" );
}

setup_strings()
{

}

set_objective( num )
{

}

// skips past objectives that should have already happened (for skiptos)
objectives_skip( numToSkipPast )
{
	for( i = 1; i <= numToSkipPast; i++ )
	{
		set_objective( i );
	}
}

// keeps the objective star on a moving entity
objective_follow_ent( objectiveNum, ent )
{
	ent endon( "death" );
	level endon( "objective_stop_following_ent" );
	
	while( 1 )
	{
		if( IsDefined( ent ) )
		{
			objective_position( objectiveNum, ent.origin );
		}
		
		wait( 0.05 );
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
		
		// while i'm at it, set the player's threat group
		players[i] setthreatbiasgroup("player_group");
	}
	
	set_breadcrumbs(starts);
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



warp_player(pos)
{
	self endon("death");
	self endon("disconnect");
	
	if(!isDefined(self.warpblack))
	{
		self.warpblack = NewClientHudElem( self ); 
		self.warpblack.x = 0; 
		self.warpblack.y = 0; 
		self.warpblack.horzAlign = "fullscreen"; 
		self.warpblack.vertAlign = "fullscreen"; 
		self.warpblack.foreground = false;
		self.sort = 50;
		self.warpblack.alpha = 0; 
		self.warpblack SetShader( "black", 640, 480 );	
	}
	self.warpblack FadeOverTime( .75 ); 
	self.warpblack.alpha = 1;
		
	wait(.75);
	self setorigin(pos);
	self.warpblack FadeOverTime( .75 ); 
	self.warpblack.alpha = 0;	
}



setup_friendlies()
{
	level.friends = grab_starting_friends();	
	
	// set up the sarge
	level.sarge = getent("sarge", "script_noteworthy");
	level.sarge thread magic_bullet_shield();
	level.sarge.animname = "reznov";
	
	level.chernov = getent("chernov", "script_noteworthy");
	level.chernov thread magic_bullet_shield();
	level.chernov.animname = "reznov";
}

// warp friendlies to a given set of points
warp_friendlies( startValue, startKey )
{
	//setup_friendlies();
	///////////////////////////////////////TEMP///////////////////////////////////////
	//ASSERTEX( flag( "friends_setup" ), "warp_friendlies(): level.friends needs to be set up before this runs." );
	///////////////////////////////////////TEMP///////////////////////////////////////
	
	// get start points
	friendlyStarts = GetStructArray( startValue, startKey );
	ASSERTEX( friendlyStarts.size > 0, "warp_friendlies(): didn't find enough friendly start points!" );

	for( i = 0; i < level.friends.size; i++ )
	{
		level.friends[i] Teleport( groundpos( friendlyStarts[i].origin ), friendlyStarts[i].angles );
	}
	
//	cher_start = getstruct("temp_chernov_start", "targetname");
//	level.chernov Teleport( groundpos( cher_start.origin ), cher_start.angles );
//	
//	sarge_start = getstruct("temp_reznov_start", "targetname");
//	level.sarge Teleport( groundpos( sarge_start.origin ), sarge_start.angles );
}



// Taken from living battlefield
hangguy()
{
	forcex = randomFloatRange( 1000, 3000 );
	forcey = randomFloatRange( -1000, 3000 );
	forcez = randomFloatRange( 1000, 3000 );

	dir = (forcex, forcey, forcez);
	contactPoint = self.origin + ( randomfloatrange(-1,1), randomfloatrange(-1,1), randomfloatrange(-1,1) );
	self physicsLaunch( contactPoint, dir );	
	//self startragdoll();
}

// Taken from living battlefield
hangguy_with_ragdoll( bonename, length )
{
	sign = spawn("script_model", self getTagOrigin("J_SpineUpper") );
	sign.angles = self getTagAngles( "J_SpineUpper" );
	sign setmodel("char_ger_traitorsign");
	sign linkto(self, "J_SpineUpper", (3, 7, 0), (-90, 0, 180) );
	
	start = self.origin + ( 0, 0, length + 22 );		// offset to make up for the length of the head
	end = ( 0, 0, 0 );
	ropeId = createrope( start, end, length, self, bonename, 1 );
	self startragdoll();
}



move_tank_on_trigger(pathname, trigname)
{
	tank_startnode = getvehiclenode(pathname, "targetname");
	
	getent(trigname, "targetname") waittill("trigger");
	
	self attachPath( tank_startnode );
	wait(.2);
	self startPath( tank_startnode );	
}



spawn_tank( tank_type, start_node, kill_tank )
{
	while( !OkToSpawn() )
	{
		wait_network_frame();
	}	
	
	tank = spawnvehicle( tank_type, "tank", "t34", start_node.origin, start_node.angles );
	tank.vehicletype = "t34";	// safety check, just to make sure the vehicletype is set (needed in maps\_vehicle::vehicle_paths())
	maps\_vehicle::vehicle_init(tank);
	
	tank.script_turretmg = 0;
	
	tank attachPath( start_node );
	tank startPath();
	
	
	
	if( isdefined(kill_tank) && kill_tank )
	{
		wait(20);
		tank delete();
	}
	else
	{
		return tank;
	}
}



spawn_plane( plane_type, start_node )
{
	while( !OkToSpawn() )
	{
		wait_network_frame();
	}	
	
	plane = spawnvehicle( plane_type, "plane", "stuka", start_node.origin, start_node.angles );		

	plane attachPath( start_node );
	plane startpath();
	plane playsound("fly_by");
	wait(3.5);
	plane playsound("fly_by_shoot");

	plane waittill( "reached_end_node" );
	plane delete();
}	



// Used to stop vehicles at certain nodes, modified from pel2_util.gsc
veh_stop_at_node( node_name, accel, decel )
{

	if( !isdefined( accel ) )
	{
		accel = 15;	
	}

	if( !isdefined( decel ) )
	{
		decel = 15;	
	}
	
	//iprintln("waiting for node " + node_name + " to be triggered");
	vnode = getvehiclenode( node_name, "script_noteworthy" );
	vnode waittill( "trigger" );	
	//iprintln("node " + node_name + " triggered");
	
	self setspeed( 0, accel, decel );	
}

// Used for satchel charges on flaks.  Taken from pel1b
satchel_setup( charge_trig, target_ent )
{
	self thread remove_satchel_on_death(charge_trig);
	
	self endon("death");
	wait( 2 );

	charge = getent( charge_trig.target, "targetname" );

	// snap it to a tag_bomb later on (TEMP - allow it to sit where it is in radiant)
	//charge.origin = self LocalToWorldCoords( ( -34, -15, 20 ) );
	//charge.angles = self.angles;
	
	ASSERTEX( isdefined ( charge ), "Charge trigger should be pointing to a sachel charge" );
	ASSERTEX( isdefined ( charge.script_noteworthy ), "Charge should have a swap model specified as script_noteworthy" );
	
	// wait till its getting used
	charge_trig waittill ("trigger", user);

	// set the active model - make sure the model is precahced first.
	charge setmodel("weapon_usa_explosive_russian");
	//Kevin adding the plant and ticking sounds
	charge playsound("satchel_plant");
	charge playloopsound("satchel_timer");
	
	// get rid of the prompt to place the charge
	charge_trig delete();
	
	wait(5);

	// damage the target ent
	//Kevin stopping the ticking
	charge stoploopsound();
	charge delete();

	maps\_utility::arcademode_assignpoints( "arcademode_score_generic250", user );

	level notify("flak destroyed");	
	self notify("death");
}

// used to remove the satchel stuff in the event that the target is destroyed by other means
remove_satchel_on_death(charge_trig)
{
	self waittill("death");
	
	if( isdefined(charge_trig) )
	{
		charge = getent( charge_trig.target, "targetname" );
	
		charge_trig delete();
	
		if( isdefined(charge) )
		{
			charge delete();
		}
	}
}



// Borrowed from See1 - used for molotov toss
hold_fire()
{
	self endon( "death" );

	self.ignoreall = true;
	self.pacifist = 1;

	self waittill( "open_fire" );
	self.ignoreall = false;
	self.pacifist = 0;
}

resume_fire()
{	
	self.pacifist = 0;
	self.ignoreall = 0;
}



////////////////////////////////////////////////////////////////////////////////////////////////////////
//	SPAWNER FUNCTIONS
////////////////////////////////////////////////////////////////////////////////////////////////////////

// Function to control spawning due to network issues (to fix "too many ents in snapshot" bug).  Modified from pel2_util.gsc
simple_floodspawn( spawn_func )
{
	self waittill ("trigger");
	
	spawners = getEntArray( self.target, "targetname" );

	//assertex( spawners.size, "spawner with target " + self.target + " found!" );	
	if(spawners.size == 0)
	{
		return undefined;
	}	
	
	
	// add spawn function to each spawner if specified
	if( isdefined( spawn_func ) )
	{
		for( i  = 0; i < spawners.size; i++ )
		{
			spawners[i] add_spawn_function( spawn_func );
		}
	}
	
	for(i=0;i<spawners.size;i++)
	{
		//wait for a snapshot after spawning every 2 guys
		while( !OkToSpawn() )
		{
			wait_network_frame();
		}
		
		// extra security
		//if(i % 2)
		//{
		//	wait_network_frame();
		//}
		
		if(	isdefined( spawners[i]) )
		{
			spawners[i] thread maps\_spawner::flood_spawner_think();
		}
		
		wait_network_frame();		// wait a network frame per spawner
	}	
}



// Function to control spawning due to network issues (to fix "too many ents in snapshot" bug).  Modified from pel2_util.gsc
simple_spawn( spawn_func )
{
	self waittill ("trigger");
	
	spawners = getEntArray( self.target, "targetname" );

	//assertex( spawners.size, "spawner with target " + self.target + " found!" );	
	if(spawners.size == 0)
	{
		return undefined;
	}
	
	// add spawn function to each spawner if specified
	if( isdefined( spawn_func ) )
	{
		for( i  = 0; i < spawners.size; i++ )
		{
			spawners[i] add_spawn_function( spawn_func );
		}
	}
	
	ai_array = [];
	
	for(i=0;i<spawners.size;i++)
	{
		//wait for a snapshot after spawning every 2 guys
		while( !OkToSpawn() )
		{
			wait_network_frame();
		}
			
		// extra security
//		if(i % 2)
//		{
//			wait_network_frame();
//		}	
			
		// check if we want to forcespawn him
		if( IsDefined( spawners[i].script_forcespawn ) )
		{
			ai = spawners[i] StalingradSpawn(); 
		}
		else
		{
			ai = spawners[i] DoSpawn(); 
		}		
		
		spawn_failed( ai );
		
		ai_array = add_to_array( ai_array, ai );
		
		wait_network_frame();				// wait a network frame between spawning
	}	
	
	return ai_array;	
}



// Thread the simple_spawner functions on all the normal triggers in the level
simple_spawners_level_init()
{
	flood_spawner_trigs = getentarray( "ber3_flood_spawner", "targetname" );
	spawner_trigs = getentarray( "ber3_spawner", "targetname" );
	
	
	for(i = 0; i < flood_spawner_trigs.size; i++)
	{
		flood_spawner_trigs[i] thread simple_floodspawn();
	}
	
	for(i = 0; i < spawner_trigs.size; i++)
	{
		spawner_trigs[i] thread simple_spawn();
	}
}







////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Eventually move all this to client scripts
////////////////////////////////////////////////////////////////////////////////////////////////////////
ambient_fakefire( endonString, delayStart, endonTrig )
{	
	if( delayStart )
	{
		wait( RandomFloatRange( 0.25, 3.5 ) );
	}
	
	if( IsDefined( endonString ) )
	{
		level endon( endonString );
	}
	
	if( IsDefined( endonTrig ) )
	{
		endonTrig endon( "trigger" );
	}
	
	team = undefined;
	fireSound = undefined;
	weapType = "rifle";
	
	if( !IsDefined( self.script_noteworthy ) )
	{
		team = "axis_mg";
	}
	else
	{
		team = self.script_noteworthy;
	}
	
	switch( team )
	{
		case "axis_mg":
			fireSound = "weap_type92_fire";
			weapType = "mg";
			break;
			
		default:
			ASSERTMSG( "ambient_fakefire: team name '" + team + "' is not recognized." );
	}
	
	// TODO make the sound chance dependent on player proximity?
	
	muzzleFlash = level._effect["distant_muzzleflash"];
	fake_tracer = level._effect["reich_tracer"];
	soundChance = 45;
	
	burstMin = 10;
	burstMax = 20;
	betweenShotsMin = 0.048;		// mg42 fire time from turretsettings.gdt
	betweenShotsMax = 0.049;
	reloadTimeMin = 0.3;
	reloadTimeMax = 3.0;
	
	burst_area = (1250,8250,1000);
	
	traceDist = 10000;
	orig_target = self.origin + vector_multiply( AnglesToForward( self.angles ),  traceDist );
			
	target_org = spawn ("script_origin", orig_target);
	
	//target_org thread drawlineon_org();
	
	println("org" + target_org.origin);
	println("BA" + burst_area);
		
	while( 1 )
	{		
		// burst fire
		burst = RandomIntRange( burstMin, burstMax );

		targ_point = (	(orig_target[0]) - (burst_area[0]/2) + randomfloat(burst_area[0]),
						(orig_target[1]) - (burst_area[1]/2) + randomfloat(burst_area[1]), 
						(orig_target[2]) - (burst_area[2]/2) + randomfloat(burst_area[2]));
						
		// TODO randomize the target a bit so we're not always firing in the same direction
		// get a point in front of where the struct is pointing
		target_org moveto(targ_point, randomfloatrange(0.5, 6.0));

		
		for (i = 0; i < burst; i++)
		{			
			target = target_org.origin;
			//BulletTracer( self.origin, target, false );
			
			// play fx with tracers
			fx_angles = VectorNormalize(target - self.origin);
			PlayFX( muzzleFlash, self.origin, fx_angles );
			
			if( i % 4 == 0 )
			{
				PlayFX( fake_tracer, self.origin, fx_angles );
			}
			
			//if (self.origin[0] > 1850 && self.origin[0] < 2300)
			//{
			//	thread whiz_by_sound(self.origin, target);
			//}
			// muzzle pop sound from gary
			//playsound (0, "pacific_fake_fire", self.origin);
			
			// snyder steez - reduce popcorn effect
			//if( RandomInt( 100 ) <= soundChance )
			//{
				//playsound( 0, fireSound, self.origin );
			//}
			
			wait( RandomFloatRange( betweenShotsMin, betweenShotsMax ) );
		}
		
		wait( RandomFloatRange( reloadTimeMin, reloadTimeMax ) );
	}
	
}

rumble_all_players(high_rumble_string, low_rumble_string, rumble_org, high_rumble_range, low_rumble_range)
{
	players = get_players();
	
	for (i = 0; i < players.size; i++)
	{
		if (isdefined (high_rumble_range) && isdefined (low_rumble_range) && isdefined(rumble_org))
		{
			if (distance (players[i].origin, rumble_org) < high_rumble_range)
			{
				players[i] playrumbleonentity(high_rumble_string);
			}
			else if (distance (players[i].origin, rumble_org) < low_rumble_range)
			{
				players[i] playrumbleonentity(low_rumble_string);
			}
		}
		else
		{
			players[i] playrumbleonentity(high_rumble_string);
		}
	}
}