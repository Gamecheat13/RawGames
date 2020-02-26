#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;

main()
{
	maps\cobrafly_precache::main();
	maps\_load::main();
	precacheItem( "zippy_rockets" );
	cobra_think();
}

cobra_think()
{
	triggers = getentarray( "trigger_multiple", "code_classname" );
	foreach ( trigger in triggers )
	{
		trigger.origin += (0,0,-5000);
	}
	
	level.last_attack = [];
	wait( 1 );
	level.player takeallweapons();
	blue_house_bottom_door = getent( "blue_house_bottom_door", "targetname" );
	if ( isdefined( blue_house_bottom_door ) )
		blue_house_bottom_door delete();

	blue_house_top_door = getent( "blue_house_top_door", "targetname" );
	if ( isdefined( blue_house_top_door ) )
		blue_house_top_door delete();
	

	
	cobra_spawner = getent( "cobra", "targetname" );
	cobra_spawner.origin = level.player.origin + (0,0,500);
	cobra_spawner.angles = level.player.angles;
	
	cobra = cobra_spawner spawn_vehicle();
	level.player thread obtain_enemy_target_range( 3000 );
	
	org = spawn( "script_origin", cobra.origin );
	cobra thread org_guides_cobra( org );
	cobra thread cobra_chases_org( org );
	cobra SetAirResistance( 20 );
	
	ent = spawn_tag_origin();
	cobra thread player_ent_trails_heli( ent );
	
	cobra hide();
	//cobra notSolid();
	cobra maps\_vehicle::godon();

	all_spawners = getspawnerteamarray( "axis" );
	hanger_spawners = getentarray( "hanger_reinforce_spawner", "targetname" );
	
	for ( ;; )
	{
		spawners = get_array_of_closest( cobra.origin, all_spawners, undefined, 10, 20000, 1500 );
		foreach ( index, spawner in spawners )
		{
			hanger_spawner = hanger_spawners[ index ];
			hanger_spawner.origin = spawner.origin;
			hanger_spawner.count = 1;
			guy = hanger_spawner dospawn();
			if ( isalive( guy ) )
			{
				guy setentitytarget( cobra );
			}
		}
		wait( 5 );
	}
}

obtain_enemy_target_range( dist )
{
	if ( !isdefined( dist ) )
		dist = 750;
	
	for ( ;; )
	{
		ai = getaiarray( "axis" );
		highest_fov = 0.94;
		enemy = undefined;
		my_org = set_z( self.origin, 0 );
		foreach ( guy in ai )
		{
			his_org = set_z( guy.origin, 0 );
			if ( distance( his_org, my_org ) > dist )
				continue;

			fov = get_dot( my_org, self.angles, his_org );
			if ( fov > highest_fov )
			{
				highest_fov = fov;
				enemy = guy;
			}
		}
		self.snowmobile_enemy = enemy;
		wait( 0.2 );
	}
}


player_ent_trails_heli( player_ent )
{
	level.player.side = -1;
	org = spawn( "script_origin", self.origin );
	level.player PlayerLinkToDelta( player_ent, "tag_origin", 1, 0, 0, -10, 15 );
	right = 120;
	old_side = 1;

	model = spawn( "script_model", (0,0,0) );
	model setmodel( self.model );
//	player_ent linkto( model, "tag_origin", (-100,100,-130), (10,0,0) );


	old_angles = self.angles;
		
	for ( ;; )
	{
		org.origin = self.origin;
		//org.angles = set_y( (0,0,0), self.angles[ 1 ] );
		org.angles = self.angles;
		
		speed = self vehicle_getSpeed();
		ent = spawnstruct();
		ent.entity = org;
		ent.forward = -30 + speed * -1;;
		ent.up = -145;

		// 140
		strafe_dist = 100 + speed * 0.5;
		if ( level.player.side == 1 )
			ent.right = strafe_dist;
		else
			ent.right = strafe_dist * -1;
		
		timer = 0.1;
		if ( level.player.side != old_side )
		{
			ent.forward = 20;
			timer = 0.5;
		}
		
		old_side = level.player.side;
		ent.yaw = 0;
		ent.pitch = 5;
		ent translate_local();
		//Line( self.origin, org.origin );
		player_ent moveto( org.origin, timer );
		angles = old_angles;
		angles = set_x( angles, angles[ 0 ] * 0.5 );
		player_ent rotateto( angles, timer );

		model moveto( self.origin, timer );
		angles = self.angles;
		angles = old_angles;
		angles = set_x( angles, angles[ 0 ] * 0.5 );
		angles = set_z( angles, angles[ 2 ] * 0.5 );
		model rotateto( angles, timer );
		old_angles = self.angles;
		wait( timer );
	}
}

cobra_chases_org( org )
{
	self.pressed = false;
	for ( ;; )
	{
		if ( self.pressed )
			self setvehgoalpos( org.origin, false );
		wait( 0.05 );
	}
}

org_guides_cobra( org )
{
	self SetYawSpeed( 100, 100, 150, 0 );
	//org thread maps\_debug::draworgforever();
	//min_z = level.player.origin[2];
	forward = 1000;
	self settargetyaw( self.angles[ 1 ] );
	self setNearGoalNotifyDist( 2000 );
	
	max_speed = 180;
	accel = 30;
	decel = 150;
	
	for ( ;; )
	{
		org.origin = self.origin;
		org.angles = set_y( (0,0,0), self.angles[ 1 ] );
		
		ent = spawnstruct();
		ent.entity = org;
		ent.up = 0;
		ent.right = 0;
		range = 1000;
		
		self Vehicle_SetSpeed( 1, accel, 50 );
 		if ( level.player buttonPressed( "APAD_LEFT" ) )
 		{
			self Vehicle_SetSpeed( max_speed, accel, 150 );
 			ent.right = range * -1;
 			//level.player.side = -1;
 			
 		}
 		if ( level.player buttonPressed( "APAD_RIGHT" ) )
 		{
			self Vehicle_SetSpeed( max_speed, accel, 150 );
 			ent.right = range;
 			//level.player.side = 1;
 		}

		forward = 0;
		if ( level.player buttonPressed( "APAD_UP" ) )
		{
			forward = 1000;
			self Vehicle_SetSpeed( max_speed, accel, 150 );
		}
		else
		if ( level.player buttonPressed( "APAD_DOWN" ) )
		{
			forward = -1000;
			self Vehicle_SetSpeed( max_speed, accel, 150 );
		}
		
		self settargetyaw( self.angles[ 1 ] );

		if ( level.player buttonPressed( "BUTTON_RSHLDR" ) )
			self settargetyaw( self.angles[ 1 ] - 90 );
		if ( level.player buttonPressed( "BUTTON_LSHLDR" ) )
			self settargetyaw( self.angles[ 1 ] + 90 );
			
			
		ent.forward = forward;

		self.pressed = !( ent.right == 0 && ent.forward == 0 );

		ent translate_local();
		trace = BulletTrace( org.origin + (0,0,5000), org.origin + (0,0,-15000), true, self );
		org.origin = trace[ "position" ] + (0,0,350);

		//line( self.origin, org.origin );
		/*
		if ( org.origin[2] < min_z )
		{
			org.origin = set_z( org.origin, min_z );
		}
		*/

		if ( level.player attackbuttonpressed() )
		{
			heli_attacks( "cobra_zippy", 175 );
		}		
		if ( level.player adsbuttonpressed() )
		{
			heli_attacks( "cobra_turret", 50 );
		}		
		
		
		//Line( self.origin, org.origin );
		wait( 0.05 );
	}
}

heli_attacks( attack, timer )
{
	if ( !isdefined( level.last_attack[ attack ] ) )
	{
		level.last_attack[ attack ] = 0;
	}
	if ( gettime() <= level.last_attack[ attack ] + timer )
		return;

		
	rocket = spawn( "script_origin", self.origin );
	rocket.angles = set_y( (0,0,0), self.angles[ 1 ] );
	
	ent = spawnstruct();
	ent.entity = rocket;
	ent.forward = 4000;
	ent.up = -1000;
	ent translate_local();

	/*
	ent.right = 0;
	
	trace = BulletTrace( rocket.origin + (0,0,1000), rocket.origin + (0,0,-5000), false, undefined );
	rocket.origin = trace[ "position" ];
	*/
	enemies = getaiarray( "axis" );

	
	enemy = rocket;
	if ( ( attack == "cobra_zippy" ) && isalive( level.player.snowmobile_enemy ) )
		enemy = level.player.snowmobile_enemy;
		
	maps\_helicopter_globals::fire_missile( attack, 1, enemy );
	
	
	level.last_attack[ attack ] = gettime();
	//Line( level.player.origin, ent.origin, (1,0,0), 1, 1, 200 );
	rocket delete();
}