#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;

init()
{
	precachestring( &"SCRIPT_PLATFORM_CHEAT_USETOSLOWMO" );
	precacheShellshock( "chaplincheat" );
// MikeD (12/17/2007): We're not going to do the "gibbing tires" I think we're going to try to do real gibs.
//	precachemodel ( "com_junktire" );
	level.vision_cheat_enabled = false;
	level.tire_explosion = false;
	level.cheatStates= [];
	level.cheatFuncs = [];
	level.cheatDvars = [];
	level.cheatBobAmpOriginal = GetDvar( "bg_bobAmplitudeStanding" );
	level.cheatShowSlowMoHint = 0;

	if ( !isdefined( level._effect ) )
		level._effect = [];
	level._effect["grain_test"] = loadfx ("misc/fx_grain_test");


	flag_init("has_cheated");
// MikeD (12/17/2007): Moved to player_init()
//	level.player thread specialFeaturesMenu();

	level.visionSets["bw"] = false;
	level.visionSets["invert"] = false;
	level.visionSets["contrast"] = false;
	level.visionSets["chaplin"] = false;

	level thread death_monitor();
	
	flag_init( "disable_slowmo_cheat" );
}

// MikeD (12/17/2007): player_init, called when the player spawns in.
player_init()
{
	self thread specialFeaturesMenu();

	// MikeD (12/17/2007): Only the host can change the slowmo...
	players = get_players();
	if( self == players[0] )
	{
		self slowmo_system_init();
	}
}

death_monitor()
{
	setDvars_based_on_varibles(); // do one on the first frame of the map too.
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
		
	// nate - setting this here. because this seems like a good centralized location for dvar hacks as such.
	// credits dvar needs to be one for the menu to work.
	// preston - split credits dvar into load and active
	// currently the pause menu and the credits scripts set the dvars to 0 when ending any credits level.
	// setting them here didn't seem to help anymore
	// nate- re-adding. credits active is 1 on levels where it shouldn't be.  needed for my hackout of subtitles on credits levels.
	if( !isdefined( level.credits_active ) || !level.credits_active )
	{
		SetDvar( "credits_active", "0" ); // determines menu options during credits
		SetDvar( "credits_load", "0" ); // determines which version of ac130 loads
	}
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

	if( cheatValue )
		flag_set("has_cheated");
			
	level.cheatStates[toggleDvar] = cheatValue;
	
	[[level.cheatFuncs[toggleDvar]]]( cheatValue );
}


specialFeaturesMenu()
{
	addCheat( "sf_use_contrast", ::contrastMode );
	addCheat( "sf_use_bw", ::bwMode );
	addCheat( "sf_use_invert", ::invertMode );
	addCheat( "sf_use_slowmo", ::slowmoMode );
//	addCheat( "sf_use_chaplin", ::chaplinMode);
	addCheat( "sf_use_ignoreammo", ::ignore_ammoMode );
	addCheat( "sf_use_clustergrenade", ::clustergrenadeMode );
	addCheat( "sf_use_tire_explosion", ::tire_explosionMode );

	level.cheatDvars = getArrayKeys( level.cheatStates );
			
	for ( ;; )
	{
		for ( index = 0; index < level.cheatDvars.size; index++ )
			checkCheatChanged( level.cheatDvars[index] );

		wait 0.5;
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
		self thread wait_for_grenades();
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
		
		if ( weapname != "frag_grenade" )
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
	
	prevorigin += (0,0,5);
	const numSecondaries = 8;
	
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
	ai.grenadeweapon = "frag_grenade";
	
	for ( i = 0; i < numSecondaries; i++ )
	{
		velocity = getClusterGrenadeVelocity();
		timer = 1.5 + i / 6 + randomfloat(0.1);
		ai magicGrenadeManual( prevorigin, velocity, timer );
	}
	ai.grenadeweapon = oldweapon;
}

getClusterGrenadeVelocity()
{
	yaw = randomFloat( 360 );
	pitch = randomFloatRange( 65, 85 );
	
	amntz = sin( pitch );
	cospitch = cos( pitch );
	
	amntx = cos( yaw ) * cospitch;
	amnty = sin( yaw ) * cospitch;
	
	speed = randomFloatRange( 400, 600); // play with these values
	
	velocity = (amntx, amnty, amntz) * speed;
	return velocity;
}

ignore_ammoMode( cheatValue )
{
	if ( level.script == "ac130" )
		return;
		
	if ( cheatValue )
		setsaveddvar ( "player_sustainAmmo",  1 );
	else
		setsaveddvar ( "player_sustainAmmo", 0 );
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
	// no vision type cheats in ac130
	if ( level.script == "ac130" )
		return;

	visionSet = "";
	if ( level.visionSets["bw"] )
		visionSet = visionSet + "_bw";
	if ( level.visionSets["invert"] )
		visionSet = visionSet + "_invert";
	if ( level.visionSets["contrast"] )
		visionSet = visionSet + "_contrast";

	if ( level.visionSets["chaplin"] )
	{
		level.vision_cheat_enabled = true;
		visionSetNaked( "sepia", 0.5 );
	}
	else if ( visionSet != "" )
	{
		level.vision_cheat_enabled = true;
		visionSetNaked( "cheat" + visionSet, 1.0 );
	}
	else
	{
		level.vision_cheat_enabled = false;
		visionSetNaked( level.lvl_visionset, 3.0 );
	}
}

slowmo_system_init()
{
	if( !IsDefined( level.slowmo ) )
	{
		level.slowmo = spawnstruct();
		
		slowmo_system_defaults();
		
		level.slowmo.speed_current = level.slowmo.speed_norm;	
		level.slowmo.lerp_interval = .05;//server frame
		level.slowmo.lerping = 0;
	}
}

slowmo_system_defaults()
{
	level.slowmo.lerp_time_in = 0.0;
	level.slowmo.lerp_time_out = .25;
	level.slowmo.speed_slow = 0.4;
	level.slowmo.speed_norm = 1.0;	
}

slowmo_check_system()
{
	/#
	if( !isdefined( level.slowmo ) )
	{
		assertMsg( "level.slowmo has not been initiliazed...you shoud not call a slowmo function within the first frame" );
		return false;
	}
	#/ 	
	return true;
}


slowmo_hintprint()
{
	if ( level.cheatShowSlowMoHint != 0 )
	{
		level.cheatShowSlowMoHint = 0;
		return;
	}

	if ( !level.console )
		return;

	level.cheatShowSlowMoHint = 1;
	const myTextSize = 1.6;

	// background
	myHintBack = createIcon( "black", 650, 30 );
	myHintBack.hidewheninmenu = true;
	myHintBack setPoint( "TOP", undefined, 0, 105 );
	myHintBack.alpha = .2;
	myHintBack.sort = 0;
	
	// string
	myHintString = createFontString( "objective", myTextSize );
	myHintString.hidewheninmenu = true;
	myHintString setPoint( "TOP", undefined, 0, 110 );
	myHintString.sort = 0.5;
	myHintString setText( &"SCRIPT_PLATFORM_CHEAT_USETOSLOWMO" );

	for ( cycles = 0; cycles < 100; cycles++ )
	{
		if ( level.cheatShowSlowMoHint != 1 )
			break;
		if ( isDefined( level.hintElem ) )
			break;
		wait 0.1;
	}

	level.cheatShowSlowMoHint = 0;
	myHintBack Destroy();
	myHintString Destroy();
}


slowmoMode( cheatValue )
{
	if ( cheatValue )
	{
		level.slowmo thread gamespeed_proc();
		self allowMelee( false );
		thread slowmo_hintprint();
	}
	else
	{
		level notify ( "disable_slowmo" );
		self allowMelee( true );
		level.slowmo thread gamespeed_reset();
		level.cheatShowSlowMoHint = 0;
	}
}


gamespeed_proc()
{
	level endon ( "disable_slowmo" );

	self thread gamespeed_reset_on_death();
	
	while(1)
	{	
		// _cheat_player_press_slowmo
		self waittill( "action_notify_melee" );
		level.cheatShowSlowMoHint = 0;
		
		if( !flag( "disable_slowmo_cheat" ) )
		{
			if( self.speed_current < level.slowmo.speed_norm )
				self thread gamespeed_reset();
			else
				self thread gamespeed_slowmo();
		}
		
		waittillframeend;
	}
}

gamespeed_reset_on_death()
{
	level notify( "gamespeed_reset_on_death" );
	level endon( "gamespeed_reset_on_death" );
	
	self waittill( "death" );
	self thread gamespeed_reset();
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
	
	if( !default_range )
		return;
			
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
		//println( self.speed_current );
		cycles--;	
		self.lerping -= interval;

		wait interval;
	}		
	
	self.speed_current = speed;
	settimescale( self.speed_current );
	//println( self.speed_current );
	
	self.lerping = 0;
	
}


gamespeed_slowmo()
{
	gamespeed_set( self.speed_slow, self.speed_norm, self.lerp_time_in );
}


gamespeed_reset()
{	
	gamespeed_set( self.speed_norm, self.speed_slow, self.lerp_time_out );
}

is_cheating()
{
	for ( i = 0; i < level.cheatDvars.size; i++ )
		if(level.cheatStates[ level.cheatDvars[i] ] )
			return true;
	return false;
}