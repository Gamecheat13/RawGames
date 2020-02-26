#include common_scripts\utility;
#include maps\_utility;

init()
{
	precachemodel ( "com_junktire" );
	level.vision_cheat_enabled = false;
	level.tire_explosion = false;
	level.cheatStates= [];
	level.cheatFuncs = [];
	level.cheatDvars = [];

	level.player thread specialFeaturesMenu();

	level.visionSets["bw"] = false;
	level.visionSets["invert"] = false;
	level.visionSets["contrast"] = false;
	
	
	//if you want to change the global slowmo speed - change it here.
	flag_init( "global_slowmo_button_released" );
	flag_set( "global_slowmo_button_released" );
	
	slowmo_system_init();
	thread death_monitor();
}

death_monitor()
{
	while ( 1 )
	{
		if ( issaverecentlyloaded() )
			setDvars_based_on_varibles();
		wait .1;
	}
}

setDvars_based_on_varibles()
{		
	for ( index = 0; index < level.cheatDvars.size; index++ )
		setDvar( level.cheatDvars[ index ], level.cheatStates[ level.cheatDvars[ index ] ] );
}


addCheat( toggleDvar, cheatFunc )
{
	setDvar( toggleDvar, 0 );
	level.cheatStates[toggleDvar] = getDvarInt( toggleDvar );
	level.cheatFuncs[toggleDvar] = cheatFunc;

	if ( level.cheatStates[toggleDvar] )
		[[cheatFunc]]( level.cheatStates[toggleDvar] );
}


checkCheatChanged( toggleDvar )
{
	cheatValue = getDvarInt( toggleDvar );
	if ( level.cheatStates[toggleDvar] == cheatValue )
		return;
		
	level.cheatStates[toggleDvar] = cheatValue;
	
	[[level.cheatFuncs[toggleDvar]]]( cheatValue );
}


specialFeaturesMenu()
{
	addCheat( "sf_use_contrast", ::contrastMode );
	addCheat( "sf_use_bw", ::bwMode );
	addCheat( "sf_use_invert", ::invertMode );
	addCheat( "sf_use_fisheye", ::fisheyeMode );
	addCheat( "sf_use_pistolammo", ::pistol_ammoMode );
	addCheat( "sf_use_shotgunammo", ::shotgun_ammoMode );
	addCheat( "sf_use_grenadeammo", ::grenade_ammoMode );
	addCheat( "sf_use_slowmo", ::slowmoMode );
	addCheat( "sf_use_showpaths", ::showpathsMode );
	addCheat( "sf_use_showtris", ::showtrisMode );
	addCheat( "sf_use_sniperammo", ::sniper_ammoMode );
	addCheat( "sf_use_smgammo", ::smg_ammoMode );
	addCheat( "sf_use_glammo", ::gl_ammoMode );
	addCheat( "sf_use_assaultammo", ::assault_ammoMode );
	addCheat( "sf_use_ignoreammo", ::ignore_ammoMode );
	addCheat( "sf_use_clustergrenade", ::clustergrenadeMode );
	addCheat( "sf_use_tire_explosion", ::tire_explosionMode );
	
	level.cheatDvars = getArrayKeys( level.cheatStates );
			
	for ( ;; )
	{
		level.player waittill( "menuresponse", menu, value );

		if ( !isSubStr( value, "sf_" ) )
			continue;
			
		//cheatDvars = getArrayKeys( level.cheatStates );
		
		for ( index = 0; index < level.cheatDvars.size; index++ )
			checkCheatChanged( level.cheatDvars[index] );
	}
}

tire_explosionMode( cheatValue )
{
	if ( cheatValue )
		level.tire_explosion = true;
	else
		level.tire_explosion = false;
}



clustergrenadeMode( cheatValue )
{
	if ( cheatValue )
		level.player thread wait_for_grenades();
	else
	{
		level notify ( "end_cluster_grenades" );
	}
}

wait_for_grenades()
{
	level endon ( "end_cluster_grenades" );
	while(1)
	{
		self waittill("grenade_fire", grenade, weapname);
		
		if ( weapname != "fraggrenade" )
			continue;
		
		grenade thread create_clusterGrenade();
	}
}

create_clusterGrenade()
{
	prevorigin = self.origin;
	while(1)
	{
		if ( !isdefined( self ) )
			break;
		prevorigin = self.origin;
		wait .1;
	}
	
	numSecondaries = 5;
	
	// need an actor to throw a magic grenade.
	aiarray = getaiarray();
	if ( aiarray.size == 0 )
		return; // too bad
	
	// prefer a friendly AI
	ai = undefined;
	for ( i = 0; i < aiarray.size; i++ )
	{
		if ( aiarray[i].team == "allies" )
		{
			ai = aiarray[i];
			break;
		}
	}
	if ( !isdefined( ai ) )
		ai = aiarray[0];
	
	oldweapon = ai.grenadeweapon;
	ai.grenadeweapon = "fraggrenade";
	
	for ( i = 0; i < numSecondaries; i++ )
	{
		velocity = getClusterGrenadeVelocity();
		timer = 2 + randomfloat(2);
		ai magicGrenadeManual( prevorigin, velocity, timer );
	}
	ai.grenadeweapon = oldweapon;
}

getClusterGrenadeVelocity()
{
	yaw = randomFloat( 360 );
	pitch = randomFloatRange( 20, 85 );
	
	amntz = sin( pitch );
	cospitch = cos( pitch );
	
	amntx = cos( yaw ) * cospitch;
	amnty = sin( yaw ) * cospitch;
	
	speed = randomFloatRange( 1000, 3000 ); // play with these values
	
	velocity = (amntx, amnty, amntz) * speed;
	return velocity;
}




assault_ammoMode( cheatValue )
{
	if ( cheatValue )
		level thread infinite_assault_ammo();
	else
	{
		level notify ( "end_infinite_assault_ammo" );
	}
}


ignore_ammoMode( cheatValue )
{
	if ( cheatValue )
		setdvar ( "player_sustainAmmo",  1 );
	else
		setdvar ( "player_sustainAmmo", 0 );
}

infinite_assault_ammo()
{
	level endon ( "end_infinite_assault_ammo" );
	
	gun_types = [];
	gun_types[gun_types.size] = "ak47";
	gun_types[gun_types.size] = "ak47_grenadier";
	gun_types[gun_types.size] = "ak74u";
	gun_types[gun_types.size] = "g3";
	gun_types[gun_types.size] = "g3_grenadier";
	gun_types[gun_types.size] = "g36c";
	gun_types[gun_types.size] = "g36c_grenadier";
	gun_types[gun_types.size] = "m16_basic";
	gun_types[gun_types.size] = "m16_grenadier";
	gun_types[gun_types.size] = "m4_grenadier";
	gun_types[gun_types.size] = "m4_grunt";
	gun_types[gun_types.size] = "m4_silencer";
	gun_types[gun_types.size] = "mp44";
	gun_types[gun_types.size] = "m60e4";
	gun_types[gun_types.size] = "saw";
	gun_types[gun_types.size] = "rpd";
	
	while ( 1 )
	{
		weap = level.player GetCurrentWeapon();
		for ( index = 0; index < gun_types.size; index++ )
			if ( weap == gun_types[index] )
				level.player GiveMaxAmmo( weap );
				
		wait 1;
	}
}

gl_ammoMode( cheatValue )
{
	if ( cheatValue )
		level thread infinite_gl_ammo();
	else
	{
		level notify ( "end_infinite_gl_ammo" );
	}
}

infinite_gl_ammo()
{
	level endon ( "end_infinite_gl_ammo" );
	
	gun_types = [];
	gun_types[gun_types.size] = "m203";
	gun_types[gun_types.size] = "m203_m4";
	gun_types[gun_types.size] = "m203_m4_silencer";
	gun_types[gun_types.size] = "gp25";
	
	while ( 1 )
	{
		weap = level.player GetCurrentWeapon();
		for ( index = 0; index < gun_types.size; index++ )
			if ( weap == gun_types[index] )
				level.player GiveMaxAmmo( weap );
				
		wait 1;
	}
}

smg_ammoMode( cheatValue )
{
	if ( cheatValue )
		level thread infinite_smg_ammo();
	else
	{
		level notify ( "end_infinite_smg_ammo" );
	}
}

infinite_smg_ammo()
{
	level endon ( "end_infinite_smg_ammo" );
	
	gun_types = [];
	gun_types[gun_types.size] = "uzi";
	gun_types[gun_types.size] = "uzi_sd";
	gun_types[gun_types.size] = "skorpion";
	gun_types[gun_types.size] = "p90";
	gun_types[gun_types.size] = "p90_silencer";
	gun_types[gun_types.size] = "mp5_silencer_cgoshp";
	gun_types[gun_types.size] = "mp5_silencer";
	gun_types[gun_types.size] = "mp5";
	
	while ( 1 )
	{
		weap = level.player GetCurrentWeapon();
		for ( index = 0; index < gun_types.size; index++ )
			if ( weap == gun_types[index] )
				level.player GiveMaxAmmo( weap );
				
		wait 1;
	}
}

sniper_ammoMode( cheatValue )
{
	if ( cheatValue )
		level thread infinite_sniper_ammo();
	else
	{
		level notify ( "end_infinite_sniper_ammo" );
	}
}

infinite_sniper_ammo()
{
	level endon ( "end_infinite_sniper_ammo" );
	
	gun_types = [];
	gun_types[gun_types.size] = "aw50";
	gun_types[gun_types.size] = "barrett";
	gun_types[gun_types.size] = "dragunov";
	gun_types[gun_types.size] = "m14_scoped";
	gun_types[gun_types.size] = "m14_scoped_silencer";
	gun_types[gun_types.size] = "m14_scoped_silencer_woodland";
	gun_types[gun_types.size] = "m40a3";
	gun_types[gun_types.size] = "remington700";
	
	while ( 1 )
	{
		weap = level.player GetCurrentWeapon();
		for ( index = 0; index < gun_types.size; index++ )
			if ( weap == gun_types[index] )
				level.player GiveMaxAmmo( weap );
				
		wait 1;
	}
}

showtrisMode( cheatValue )
{
	if ( cheatValue )
		setdvar ( "ai_showtris", 1 );
	else
	{
		setdvar ( "ai_showtris", 0 );
	}	
}

showpathsMode( cheatValue )
{
	if ( cheatValue )
		setdvar ( "ai_showpaths", 1 );
	else
	{
		setdvar ( "ai_showpaths", 0 );
	}	
}


slowmoMode( cheatValue )
{
	if ( cheatValue )
		level.slowmo thread gamespeed_proc();
	else
	{
		level notify ( "disable_slowmo" );
		self thread gamespeed_reset();
	}
}

gamespeed_proc()
{
	level endon ( "disable_slowmo" );
	while(1)
	{
		flag_wait( "global_slowmo_button_released" );
		
		while ( !level.player buttonPressed( "BUTTON_RSTICK" ) )
			wait ( 0.05 );
		
		flag_clear( "global_slowmo_button_released" );
		self thread gamespeed_release_button();
					
		if( self.speed_current < level.slowmo.speed_norm )
			self thread gamespeed_reset();
		
		else
			self thread gamespeed_slowmo();
		
		waittillframeend;
		
		//now wait for the right amount of time before even checking again for a button press
	//	while( self.lerping > ( level.slowmo.lerp_time_curr - self.buffer_time_between_button_press ) )
	//		wait self.lerp_interval;
	}
}

pistol_ammoMode( cheatValue )
{
	if ( cheatValue )
		level thread infinite_pistol_ammo();
	else
	{
		level notify ( "end_infinite_pistol_ammo" );
	}
}

infinite_pistol_ammo()
{
	level endon ( "end_infinite_pistol_ammo" );
	
	gun_types = [];
	gun_types[gun_types.size] = "usp";
	gun_types[gun_types.size] = "usp_silencer";
	gun_types[gun_types.size] = "colt45";
	gun_types[gun_types.size] = "deserteagle";
	gun_types[gun_types.size] = "berretta";
	
	while ( 1 )
	{
		weap = level.player GetCurrentWeapon();
		for ( index = 0; index < gun_types.size; index++ )
			if ( weap == gun_types[index] )
				level.player GiveMaxAmmo( weap );
				
		wait 1;
	}
}

shotgun_ammoMode( cheatValue )
{
	if ( cheatValue )
		level thread infinite_shotgun_ammo();
	else
	{
		level notify ( "end_infinite_shotgun_ammo" );
	}
}

infinite_shotgun_ammo()
{
	level endon ( "end_infinite_shotgun_ammo" );
	
	gun_types = [];
	gun_types[gun_types.size] = "m1014";
	gun_types[gun_types.size] = "winchester1200";
	
	while ( 1 )
	{
		weap = level.player GetCurrentWeapon();
		for ( index = 0; index < gun_types.size; index++ )
			if ( weap == gun_types[index] )
				level.player GiveMaxAmmo( weap );
				
		wait 1;
	}
}

grenade_ammoMode( cheatValue )
{
	if ( cheatValue )
		level thread infinite_grenade_ammo();
	else
	{
		level notify ( "end_infinite_grenade_ammo" );
	}
}

infinite_grenade_ammo()
{
	level endon ( "end_infinite_grenade_ammo" );
	gun_types = [];
	gun_types[gun_types.size] = "fraggrenade";
	gun_types[gun_types.size] = "flash_grenade";
	gun_types[gun_types.size] = "smoke_grenade_american";
	gun_types[gun_types.size] = "c4";
	gun_types[gun_types.size] = "claymore";
	
	while ( 1 )
	{
		weapons = level.player GetWeaponsList();
		for ( j = 0; j < weapons.size; j++ )
		{
			for ( index = 0; index < gun_types.size; index++ )
			{
				if( weapons[ j ] == gun_types[ index ] )
				{
					level.player GiveMaxAmmo( weapons[ j ] );
					break;
				}
			}
		}
		wait .5;
	}
}

fisheyeMode( cheatValue )
{
	//special case for COUP and AC-130?
	if ( cheatValue )
		setsaveddvar ( "cg_fov", 110 );
	else
	{
		if ( level.Console )
			setsaveddvar ( "cg_fov", 65 );
		else
			setsaveddvar ( "cg_fov", 80 );
	}
}

contrastMode( cheatValue )
{
	if ( cheatValue )
		level.visionSets["contrast"] = true;
	else
		level.visionSets["contrast"] = false;
	
	applyVisionSets();
}

bwMode( cheatValue )
{
	if ( cheatValue )
		level.visionSets["bw"] = true;
	else
		level.visionSets["bw"] = false;
	
	applyVisionSets();
}


invertMode( cheatValue )
{
	if ( cheatValue )
		level.visionSets["invert"] = true;
	else
		level.visionSets["invert"] = false;
	
	applyVisionSets();
}


applyVisionSets()
{
	visionSet = "";
	if ( level.visionSets["bw"] )
		visionSet = visionSet + "_bw";
	if ( level.visionSets["invert"] )
		visionSet = visionSet + "_invert";
	if ( level.visionSets["contrast"] )
		visionSet = visionSet + "_contrast";
		
	if ( visionSet != "" )
	{
		level.vision_cheat_enabled = true;
		visionSetNaked( "cheat" + visionSet, 0 );
	}
	else
	{
		level.vision_cheat_enabled = false;
		visionSetNaked( level.lvl_visionset, 3.0 );
	}
}





slowmo_system_init()
{
	level.slowmo = spawnstruct();
	
	level.slowmo.lerp_time_in = 0.0;
	level.slowmo.lerp_time_out = .75;
	level.slowmo.speed_slow = 0.4;
	
	// this can never be lower the level.slowmo.lerp_time_out or level.slowmo.lerp_time_in
	// this is the time between button presses that we take action
	level.slowmo.buffer_time_between_button_press = .1; 
	
	level.slowmo.speed_norm = 1.0;
	level.slowmo.speed_current = level.slowmo.speed_norm;	
	level.slowmo.lerp_time_curr = level.slowmo.lerp_time_in;
	level.slowmo.lerp_interval = .05;//server frame
	level.slowmo.lerping = 0;
}


gamespeed_release_button()
{
	while ( level.player buttonPressed( "BUTTON_RSTICK" ) )
		wait ( 0.05 );
	
	flag_set( "global_slowmo_button_released" );
}

gamespeed_set( speed, refspeed, lerp_time )
{
	self notify("gamespeed_set");
	self endon("gamespeed_set");
	
	//we're going to calculate the time to lerp to the new speed
	//if we dont define a time then we want to know how long it should
	//take from our current speed to lerp to the default normal or slowmo
	//this way if the player wants to come out of slowmo before he's finishing
	//going in, it only takes a fraction of time to come out instead taking
	//the same ammount as if he was all the way into slow mo.
	
	default_range 	= ( speed - refspeed );
	actual_range 	= ( speed - self.speed_current );
	actual_rangebytime = actual_range * lerp_time;
	
	time 			= ( actual_rangebytime / default_range ); 
	
	interval 		= self.lerp_interval; // serverframe
	cycles 			= int( time / interval );
	if(!cycles)
		cycles = 1;
	increment 		= ( actual_range / cycles );
	self.lerping 	= time;
	
	while(cycles)
	{
		self.speed_current += increment;
		settimescale( self.speed_current );
		cycles--;	
		self.lerping -= interval;

		wait interval;
	}		
	
	self.speed_current = speed;
	settimescale( self.speed_current );
	
	self.lerping = 0;
	
}

gamespeed_slowmo()
{
	self.lerp_time_curr = self.lerp_time_in;
	gamespeed_set( self.speed_slow, self.speed_norm, self.lerp_time_in );
}

gamespeed_reset()
{	
	self.lerp_time_curr = self.lerp_time_out;
	gamespeed_set( self.speed_norm, self.speed_slow, self.lerp_time_out );
}