#include maps\_utility;
#include common_scripts\utility;
#using_animtree("ac130");
init()
{
	setdvar( "scr_dof_enable", "0" );
	flag_clear( "nightvision_enabled" );
	
	if (!isdefined(level.ac130))
	{
		assertMsg("YOU MUST DEFINE LEVEL.AC130 BEFORE CALLING MAPS\_AC130::INIT()");
		return;
	}
	
	level.ac130 hide();
	
	if ( getdvar( "ac130_enabled") == "" )
		setdvar( "ac130_enabled", "1" );
	if ( getdvar( "ac130_debug_weapons") == "" )
		setdvar( "ac130_debug_weapons", "0" );
	if ( getdvar( "ac130_debug_context_sensative_dialog" ) == "" )
		setdvar( "ac130_debug_context_sensative_dialog", "0" );
	
	//0 - player can freely engage targets before being authorized
	//1 - player fails the mission for engage targets before being authorized
	//2 - player gets red X over crosshairs when trying to fire before being authorized
	if ( getdvar( "ac130_pre_engagement_mode" ) == "" )
		setdvar( "ac130_pre_engagement_mode", "2" );
	
	if ( getdvar( "ac130_alternate_controls" ) == "" )
		setdvar( "ac130_alternate_controls", "0" );
	
	precacheShader( "ac130_overlay_25mm" );
	precacheShader( "ac130_overlay_40mm" );
	precacheShader( "ac130_overlay_105mm" );
	precacheShader( "ac130_overlay_grain" );
	precacheShader( "ac130_overlay_nofire" );
	
	precacheString( &"AC130_HUD_TOP_BAR" );
	precacheString( &"AC130_HUD_LEFT_BLOCK" );
	precacheString( &"AC130_HUD_RIGHT_BLOCK" );
	precacheString( &"AC130_HUD_BOTTOM_BLOCK" );
	precacheString( &"AC130_HUD_THERMAL_WHOT" );
	precacheString( &"AC130_HUD_THERMAL_BHOT" );
	precacheString( &"AC130_HUD_WEAPON_105MM" );
	precacheString( &"AC130_HUD_WEAPON_40MM" );
	precacheString( &"AC130_HUD_WEAPON_25MM" );
	precacheString( &"AC130_HUD_AGL" );
	
	if (getdvar("ac130_alternate_controls") == "0")
	{
		precacheItem("ac130_25mm");
		precacheItem("ac130_40mm");
		precacheItem("ac130_105mm");
	}
	else
	{
		precacheItem("ac130_25mm_alt");
		precacheItem("ac130_40mm_alt");
		precacheItem("ac130_105mm_alt");
	}
	
	precacheShellShock("ac130");
	
	level._effect["beacon"] = loadfx ( "misc/ir_beacon" );
	
	level.spawnerCallbackThread = ::context_Sensative_Dialog_Kill;
	level.vehicleSpawnCallbackThread = ::context_Sensative_Dialog_VehicleSpawn;
	
	level.enemiesKilledInTimeWindow = 0;
	
	level.radioForcedTransmissionQueue = [];
	
	level.lastRadioTransmission = getTime();
	
	level.color["white"] = (1,1,1);
	level.color["red"] = (1,0,0);
	level.color["blue"] = (.1,.3,1);
	
	level.cosine = [];
	level.cosine[ "45" ] = cos( 45 );
	
	level.player takeallweapons();
	level.player.ignoreme = true;
	
	level.badplaceRadius["ac130_25mm"] = 800;
	level.badplaceRadius["ac130_40mm"] = 1000;
	level.badplaceRadius["ac130_105mm"] = 1600;
	level.badplaceRadius["ac130_25mm_alt"] = 800;
	level.badplaceRadius["ac130_40mm_alt"] = 1000;
	level.badplaceRadius["ac130_105mm_alt"] = 1600;
	
	level.badplaceDuration["ac130_25mm"] = 1.0;
	level.badplaceDuration["ac130_40mm"] = 5.0;
	level.badplaceDuration["ac130_105mm"] = 7.0;
	level.badplaceDuration["ac130_25mm_alt"] = 1.0;
	level.badplaceDuration["ac130_40mm_alt"] = 5.0;
	level.badplaceDuration["ac130_105mm_alt"] = 7.0;
	
	level.ac130_Speed = [];
	level.ac130_Speed["move"] = 300;
	level.ac130_Speed["rotate"] = 100;
	
	//flag_init( "ir_beakons_on" );
	flag_init( "allow_context_sensative_dialog" );
	flag_init( "clear_to_engage" );
	
	level.player takeallweapons();
	if (getdvar("ac130_alternate_controls") == "0")
	{
		level.player giveweapon("ac130_105mm");
		level.player switchtoweapon("ac130_105mm");
	}
	else
	{
		level.player giveweapon("ac130_105mm_alt");
		level.player switchtoweapon("ac130_105mm_alt");
	}
	level.player SetActionSlot( 2, "" );
	takeAllAmmo();
	
	if (getdvar("ac130_enabled") == "1")
	{
		overlay();
		thread attachPlayer();
		thread changeWeapons();
		thread invertThermal();
		if ( getdvar( "ac130_pre_engagement_mode" ) == "1" )
			thread failMissionForEngaging();
		if ( getdvar( "ac130_pre_engagement_mode" ) == "2" )
			thread nofireCrossHair();
		thread context_Sensative_Dialog();
		thread shotFired();
		thread maps\_ac130_amb::main();
	}
}

overlay()
{
	level.ac130_overlay = newHudElem();
	level.ac130_overlay.x = 0;
	level.ac130_overlay.y = 0;
	level.ac130_overlay.alignX = "center";
	level.ac130_overlay.alignY = "middle";
	level.ac130_overlay.horzAlign = "center";
	level.ac130_overlay.vertAlign = "middle";
	level.ac130_overlay.foreground = true;
	level.ac130_overlay setshader ("ac130_overlay_105mm", 640, 480);
	
	grain = newHudElem();
	grain.x = 0;
	grain.y = 0;
	grain.alignX = "left";
	grain.alignY = "top";
	grain.horzAlign = "fullscreen";
	grain.vertAlign = "fullscreen";
	grain.foreground = true;
	grain setshader ("ac130_overlay_grain", 640, 480);
	grain.alpha = 0.4;
	
	hud_top_bar = newHudElem();
	hud_top_bar.x = 0;
	hud_top_bar.y = 0;
	hud_top_bar.alignX = "left";
	hud_top_bar.alignY = "top";
	hud_top_bar.horzAlign = "left";
	hud_top_bar.vertAlign = "top";
	hud_top_bar.foreground = true;
	hud_top_bar.fontScale = 2.5;
	hud_top_bar settext ( &"AC130_HUD_TOP_BAR" );
	hud_top_bar.alpha = 1.0;
	
	hud_left_block = newHudElem();
	hud_left_block.x = 0;
	hud_left_block.y = 60;
	hud_left_block.alignX = "left";
	hud_left_block.alignY = "top";
	hud_left_block.horzAlign = "left";
	hud_left_block.vertAlign = "top";
	hud_left_block.foreground = true;
	hud_left_block.fontScale = 2.5;
	hud_left_block settext ( &"AC130_HUD_LEFT_BLOCK" );
	hud_left_block.alpha = 1.0;
	
	hud_right_block = newHudElem();
	hud_right_block.x = 0;
	hud_right_block.y = 50;
	hud_right_block.alignX = "right";
	hud_right_block.alignY = "top";
	hud_right_block.horzAlign = "right";
	hud_right_block.vertAlign = "top";
	hud_right_block.foreground = true;
	hud_right_block.fontScale = 2.5;
	hud_right_block settext ( &"AC130_HUD_RIGHT_BLOCK" );
	hud_right_block.alpha = 1.0;
	
	hud_right_block = newHudElem();
	hud_right_block.x = 0;
	hud_right_block.y = 0;
	hud_right_block.alignX = "center";
	hud_right_block.alignY = "bottom";
	hud_right_block.horzAlign = "center";
	hud_right_block.vertAlign = "bottom";
	hud_right_block.foreground = true;
	hud_right_block.fontScale = 2.5;
	hud_right_block settext ( &"AC130_HUD_BOTTOM_BLOCK" );
	hud_right_block.alpha = 1.0;
	
	level.hud_thermal_mode = newHudElem();
	level.hud_thermal_mode.x = -80;
	level.hud_thermal_mode.y = 50;
	level.hud_thermal_mode.alignX = "right";
	level.hud_thermal_mode.alignY = "top";
	level.hud_thermal_mode.horzAlign = "right";
	level.hud_thermal_mode.vertAlign = "top";
	level.hud_thermal_mode.foreground = true;
	level.hud_thermal_mode.fontScale = 2.5;
	level.hud_thermal_mode settext ( &"AC130_HUD_THERMAL_WHOT" );
	level.hud_thermal_mode.alpha = 1.0;
	
	level.hud_weapon_text = newHudElem();
	level.hud_weapon_text.x = 0;
	level.hud_weapon_text.y = -60;
	level.hud_weapon_text.alignX = "left";
	level.hud_weapon_text.alignY = "bottom";
	level.hud_weapon_text.horzAlign = "left";
	level.hud_weapon_text.vertAlign = "bottom";
	level.hud_weapon_text.foreground = true;
	level.hud_weapon_text.fontScale = 2.5;
	level.hud_weapon_text settext ( &"AC130_HUD_WEAPON_105MM" );
	level.hud_weapon_text.alpha = 1.0;
	
	hud_timer = newHudElem();
	hud_timer.x = -100;
	hud_timer.y = 0;
	hud_timer.alignX = "right";
	hud_timer.alignY = "bottom";
	hud_timer.horzAlign = "right";
	hud_timer.vertAlign = "bottom";
	hud_timer.foreground = true;
	hud_timer.fontScale = 2.5;
	hud_timer setTimerUp( 1.0 );
	hud_timer.alpha = 1.0;
	
	thread overlay_coords();
	
	thread ac130ShellShock();
	
	wait 0.05;
	setblur(1, 0);
	setsaveddvar("g_friendlynamedist",0);
	setsaveddvar("compass", 0);
}

overlay_coords()
{
	coord1 = newHudElem();
	coord1.x = -100;
	coord1.y = 0;
	coord1.alignX = "right";
	coord1.alignY = "top";
	coord1.horzAlign = "right";
	coord1.vertAlign = "top";
	coord1.foreground = true;
	coord1.fontScale = 2.5;
	coord1.alpha = 1.0;
	
	coord2 = newHudElem();
	coord2.x = 0;
	coord2.y = 0;
	coord2.alignX = "right";
	coord2.alignY = "top";
	coord2.horzAlign = "right";
	coord2.vertAlign = "top";
	coord2.foreground = true;
	coord2.fontScale = 2.5;
	coord2.alpha = 1.0;
	
	asl = newHudElem();
	asl.x = 0;
	asl.y = 20;
	asl.alignX = "right";
	asl.alignY = "top";
	asl.horzAlign = "right";
	asl.vertAlign = "top";
	asl.foreground = true;
	asl.fontScale = 2.5;
	asl.label = ( &"AC130_HUD_AGL" );
	asl.alpha = 1.0;
	
	wait 0.05;
	for(;;)
	{
		coord1 setValue( abs( int( level.player.origin[0] ) ) );
		coord2 setValue( abs( int( level.player.origin[1] ) ) );
		
		pos = physicstrace( level.player.origin, level.player.origin - ( 0, 0, 100000 ) );
		if( ( isdefined( pos ) ) && ( isdefined( pos[2] ) ) )
		{
			alt = ( ( level.player.origin[2] - pos[2] ) * 1.5 );
			asl setValue( abs( int( alt ) ) );
		}
		
		wait ( 0.75 + randomfloat( 2 ) );
	}
}

ac130ShellShock()
{
	for (;;)
	{
		duration = 60;
		level.player shellshock("ac130", duration);
		wait duration;
	}
}

rotatePlane( toggle )
{
	level notify("stop_rotatePlane_thread");
	level endon("stop_rotatePlane_thread");
	
	if (toggle == "on")
	{
		for (;;)
		{
			level.ac130 rotateyaw( 360, level.ac130_Speed["rotate"] );
			wait level.ac130_Speed["rotate"];
		}
	}
	else if (toggle == "off")
	{
		rotateTime = ( 360 / level.ac130_Speed["rotate"] );
		level.ac130 rotateyaw( level.ac130.angles[2] + 5, rotateTime, 0, rotateTime );
	}
}

attachPlayer()
{
	//playerlinktodelta( <linkto entity>, <tag>, <viewpercentag fraction>, <right arc>, <left arc>, <top arc>, <bottom arc> )
	level.player playerLinkToDelta (level.ac130, "tag_player", 1.0, 65, 65, 35, 40 );
	wait 0.05;
	level.player allowProne( false );
	level.player allowCrouch( false );
	level.player setplayerangles ( level.ac130 getTagAngles( "tag_player" ) );
	SetSavedDvar( "ammoCounterHide", "1" );
}

attachPlaneToEnt( entity )
{
	assert( isdefined ( entity ) );
	
	level notify ("ac130_reposition");
	level endon ("ac130_reposition");
	
	level.ac130 linkto ( entity );
}

getRealAC130Angles()
{
	angle = level.ac130.angles[1];
	while( angle >= 360 )
		angle -= 360;
	while( angle < 0 )
		angle += 360;
	return angle;
}

movePlaneToPoint( coordinate, rotationWait )
{	
	level notify ( "ac130_reposition" );
	level endon ( "ac130_reposition" );
	
	if ( !isdefined( rotationWait ) )
		rotationWait = false;
	
	level.ac130 unlink();
	
	d = distance( level.ac130.origin, coordinate );
	moveTime = ( d / level.ac130_Speed["move"] );
	
	if ( moveTime > 0 )
	{
		accel = 0;
		decel = 0;
		if ( moveTime > 2 )
		{
			accel = 1.0;
			decel = 1.0;
		}
		
		if ( rotationWait )
		{
			//find the angle it should be at to move to the next point
				destAng = vectorToAngles( level.ac130.origin - coordinate );
				destAng = destAng[1] + 90;
				while( destAng >= 360 )
					destAng -= 360;
				while( destAng < 0 )
					destAng += 360;
			/*
			//wait till it gets to the angle it should be at then shut off rotation
				while ( abs( getRealAC130Angles() - destAng )  > 20 )
					wait 0.05;
			
			//shut off rotation when it gets there
			rotatePlane( "off" );
			*/
			
			realDestAng = level.ac130.angles[1];
			if ( destAng < getRealAC130Angles() )
			{
				realDestAng += ( 360 - getRealAC130Angles() ) + destAng;
			}
			else
			{
				realDestAng += ( destAng - getRealAC130Angles() );
			}
			
			while( level.ac130.angles[1] < realDestAng )
				wait 0.05;
			
			//shut off rotation when it gets there
			rotatePlane( "off" );
		}
		
		level.ac130 moveto ( coordinate, moveTime, accel, decel );
		if ( moveTime > 2.0 )
		{
			wait ( moveTime - 2.0 );
			level notify( "ac130_almost_at_destination" );
			wait 2.0;
		}
		else
		{
			wait moveTime;
		}
		
		if ( rotationWait )
			rotatePlane( "on" );
	}	
}

ac130_move_in()
{
	if ( isdefined( level.ac130_moving_in ) )
		return;
	level.ac130_moving_in = true;
	level.ac130_moving_out = undefined;
	
	thread context_Sensative_Dialog_Play_Random_Group_Sound( "plane", "rolling_in", true );
	
	level.ac130 useAnimTree( #animtree );
	level.ac130 setflaggedanim ( "ac130_move_in", %ac130_move_in, 1.0, 0.2, 0.1 );
	level.ac130 waittillmatch( "ac130_move_in", "end" );
	
	level.ac130_moving_in = undefined;
}

ac130_move_out()
{
	if ( isdefined( level.ac130_moving_out ) )
		return;
	level.ac130_moving_out = true;
	level.ac130_moving_in = undefined;
	
	level.ac130 useAnimTree( #animtree );
	level.ac130 setflaggedanim ( "ac130_move_out", %ac130_move_out, 1.0, 0.2, 0.3 );
	level.ac130 waittillmatch( "ac130_move_out", "end" );
	
	level.ac130_moving_out = undefined;
}

changeWeapons()
{
	weapon = [];
	
	weapon[0] = spawnstruct();
	weapon[0].overlay = "ac130_overlay_105mm";
	weapon[0].fov = "55";
	weapon[0].name = "105mm";
	weapon[0].sound = "ac130_105mm_fire";
	weapon[0].string = ( &"AC130_HUD_WEAPON_105MM" );
	
	weapon[1] = spawnstruct();
	weapon[1].overlay = "ac130_overlay_40mm";
	weapon[1].fov = "25";
	weapon[1].name = "40mm";
	weapon[1].sound = "ac130_40mm_fire";
	weapon[1].string = ( &"AC130_HUD_WEAPON_40MM" );
	
	weapon[2] = spawnstruct();
	weapon[2].overlay = "ac130_overlay_25mm";
	weapon[2].fov = "10";
	weapon[2].name = "25mm";
	weapon[2].sound = "ac130_25mm_fire";
	weapon[2].string = ( &"AC130_HUD_WEAPON_25MM" );
	
	if (getdvar("ac130_alternate_controls") == "0")
	{
		weapon[0].weapon = "ac130_105mm";
		weapon[1].weapon = "ac130_40mm";
		weapon[2].weapon = "ac130_25mm";
	}
	else
	{
		weapon[0].weapon = "ac130_105mm_alt";
		weapon[1].weapon = "ac130_40mm_alt";
		weapon[2].weapon = "ac130_25mm_alt";
	}
	
	currentWeapon = 0;
	level.currentWeapon = weapon[currentWeapon].name;
	thread fire_screenShake();
	
	for(;;)
	{
		while( !level.player buttonPressed( "BUTTON_Y" ) )
			wait 0.05;
		
		currentWeapon++;
		if ( currentWeapon >= weapon.size )
			currentWeapon = 0;
		level.currentWeapon = weapon[currentWeapon].name;
		
		level.ac130_overlay setshader ( weapon[currentWeapon].overlay, 640, 480 );
		level.hud_weapon_text settext ( weapon[currentWeapon].string );
		
		if ( getdvar( "ac130_alternate_controls" ) == "0" )
			setsaveddvar( "cg_fov",weapon[currentWeapon].fov );
		
		level.player takeallweapons();
		level.player giveweapon( weapon[currentWeapon].weapon );
		level.player switchtoweapon( weapon[currentWeapon].weapon );
		
		takeAllAmmo();
		
		while( level.player buttonPressed( "BUTTON_Y" ) )
			wait 0.05;
	}
}

invertThermal()
{
	level.player endon( "death" );

	VisionSetNaked( "ac130", 0 );
	inverted = "0";
	for (;;)
	{
		while( !level.player buttonPressed( "BUTTON_X" ) )
			wait 0.05;
		
		if ( inverted == "0" )
		{
			VisionSetNaked( "ac130_inverted", 0 );
			level.hud_thermal_mode settext ( &"AC130_HUD_THERMAL_BHOT" );
			inverted = "1";
		}
		else
		{
			VisionSetNaked( "ac130", 0 );
			level.hud_thermal_mode settext ( &"AC130_HUD_THERMAL_WHOT" );
			inverted = "0";
		}
		
		while( level.player buttonPressed( "BUTTON_X" ) )
			wait 0.05;
	}
}

takeAllAmmo()
{
	if ( getdvar( "ac130_pre_engagement_mode" ) == "2" )
	{
		if ( flag( "clear_to_engage" ) )
			return;

        weaponList = level.player GetWeaponsListPrimaries();
        for( idx = 0; idx < weaponList.size; idx++ )
        {
			level.player SetWeaponAmmoClip( weaponList[idx], 0 );
			level.player SetWeaponAmmoStock( weaponList[idx], 0 );
        }
	}
}

failMissionForEngaging()
{
	level endon ( "clear_to_engage" );
	
	level.player waittill ( "begin_firing" );
	
	wait 2;
	
	if ( !flag( "mission_failed" ) )
	{
		flag_set( "mission_failed" );
		setdvar( "ui_deadquote", "@AC130_DO_NOT_ENGAGE" );
		maps\_utility::missionFailedWrapper();
	}
}

nofireCrossHair()
{
	level endon ( "clear_to_engage" );
	
	if ( flag( "clear_to_engage" ) )
		return;
	
	level.ac130_nofire = newHudElem();
	level.ac130_nofire.x = 0;
	level.ac130_nofire.y = 0;
	level.ac130_nofire.alignX = "center";
	level.ac130_nofire.alignY = "middle";
	level.ac130_nofire.horzAlign = "center";
	level.ac130_nofire.vertAlign = "middle";
	level.ac130_nofire.foreground = true;
	level.ac130_nofire setshader ( "ac130_overlay_nofire", 64, 64 );
	
	thread nofireCrossHair_Remove();
	
	level.ac130_nofire.alpha = 0;
	
	for (;;)
	{
		while( level.player attackButtonPressed() )
		{
			level.ac130_nofire.alpha = 1;
			level.ac130_nofire fadeOverTime( 1.0 );
			level.ac130_nofire.alpha = 0;
			wait 1.0;
		}
		wait 0.05;
	}
}

nofireCrossHair_Remove()
{
	level waittill ( "clear_to_engage" );
	level.ac130_nofire destroy();
	
	if ( GetDvar( "ac130_alternate_controls" ) == "0" )
	{
		level.player GiveStartAmmo( "ac130_25mm" );
		level.player GiveStartAmmo( "ac130_40mm" );
		level.player GiveStartAmmo( "ac130_105mm" );
	}
	else
	{
		level.player GiveStartAmmo( "ac130_25mm_alt" );
		level.player GiveStartAmmo( "ac130_40mm_alt" );
		level.player GiveStartAmmo( "ac130_105mm_alt" );
	}
}

fire_screenShake()
{
	for (;;)
	{
		level.player waittill ( "begin_firing" );
		
		if (level.currentWeapon == "105mm")
		{
			if ( ( getdvar( "ac130_pre_engagement_mode" ) == "2" ) && ( !flag( "clear_to_engage" ) ) )
				continue;
			
			thread gun_fired_and_ready_105mm();
			
			//earthquake(<scale>,<duration>,<source>,<radius>)
			earthquake (0.2, 1, level.player.origin, 1000);
		}
		else
		if (level.currentWeapon == "40mm")
		{
			if ( ( getdvar( "ac130_pre_engagement_mode" ) == "2" ) && ( !flag( "clear_to_engage" ) ) )
				continue;
			
			//earthquake(<scale>,<duration>,<source>,<radius>)
			earthquake (0.1, 0.5, level.player.origin, 1000);
		}
		
		wait 0.05;
	}
}

gun_fired_and_ready_105mm()
{
	wait 0.5;
	
	if ( randomint( 2 ) == 0 )
		thread context_Sensative_Dialog_Play_Random_Group_Sound( "weapons", "105mm_fired" );
	
	wait 5.0;	
	
	thread context_Sensative_Dialog_Play_Random_Group_Sound( "weapons", "105mm_ready", true );
}

getFriendlysCenter()
{
	//returns vector which is the center mass of all friendlies
	averageVec = undefined;
	friendlies = getaiarray("allies");
	if (!isdefined(friendlies))
		return (0,0,0);
	if (friendlies.size <= 0)
		return (0,0,0);
	for( i = 0 ; i < friendlies.size ; i++ )
	{
		if (!isdefined(averageVec))
			averageVec = friendlies[i].origin;
		else
			averageVec += friendlies[i].origin;
	}
	averageVec = ( (averageVec[0] / friendlies.size), (averageVec[1] / friendlies.size), (averageVec[2] / friendlies.size) );
	return averageVec;
}

shotFired()
{
	for (;;)
	{
		level.player waittill( "projectile_impact", weaponName, position, radius );
		thread shotFiredBadPlace ( position, weaponName );
		wait 0.05;
	}
}

shotFiredBadPlace (center, weapon)
{
	assert( isdefined( level.badplaceRadius[weapon] ) );
	badplace_cylinder("", level.badplaceDuration[weapon], center, level.badplaceRadius[weapon], level.badplaceRadius[weapon], "axis");
	
	if ( getdvar( "ac130_debug_weapons" ) == "1" )
		thread debug_circle( center, level.badplaceRadius[weapon], level.badplaceDuration[weapon], level.color["blue"], undefined, true);
}

add_beacon_effect()
{
	flashDelay = 0.75;
	
	//flag_wait( "ir_beakons_on" );
	
	wait randomfloat(3.0);
	for (;;)
	{
		if (!isdefined(self))
			return;
		if (!isalive(self))
			return;
		playfxontag( level._effect["beacon"], self, "j_spine4" );
		wait flashDelay;
	}
}

destroyable_vehicle()
{
	self setCanDamage( true );
	self.health = 1400;
	
	if ( !isdefined( self.target ) )
	{
		assertMsg( "destroyable vehicle at " + self.origin + " does not target a destroyed version of itself." );
		return;
	}
	
	destroyed_model = getent( self.target, "targetname" );
	if ( !isdefined( destroyed_model ) )
	{
		assertMsg( "destroyed target entity not found at " + self.origin );
		return;
	}
	destroyed_model hide();
	
	radiusDamageOrigin = self.origin + (0,0,100);
	
	for (;;)
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type );
		if ( attacker != level.player )
			continue;
		if ( ( type == "MOD_PROJECTILE_SPLASH" ) && ( damage >= 300 ) )
			break;
		if ( self.health <= 0 )
			break;
	}
	
	//blow up the vehicle
	//-------------------

	for(i=0;i<level.vehicle_death_fx["humvee"].size;i++)
	{
		if(isdefined(level.vehicle_death_fx["humvee"][i].effect))
		{
			playfx ( level.vehicle_death_fx["humvee"][i].effect, self.origin + (0,0,50), anglesToUp(self.angles), anglesToForward(self.angles) );
		}
	}
	
	level notify ( "vehicle_explosion", radiusDamageOrigin );
	
	self delete();
	//radiusdamage(<origin>, <range>, <max damage>, <min damage>)
	radiusdamage( radiusDamageOrigin, 150, 10000, 5000 );
	destroyed_model show();
}

breakable()
{
	self setcandamage( true );
	for (;;)
	{
		self waittill ( "damage", damage, attacker );
		if ( ( attacker == level.player ) & ( damage >= 1000 ) )
			break;
	}
	self delete();
}

tree_fall()
{
	self setcandamage( true );
	for (;;)
	{
		self waittill( "damage", damage, attacker, direction_vec, point );
		if ( attacker != level.player )
			continue;
		if ( randomint( 2 ) == 0 )
			continue;
		break;
	}
	
	tree = self;
	
	treeorg = spawn( "script_origin", tree.origin );
	treeorg.origin = tree.origin;
	
	org = point;
	pos1 = (org[0],org[1],0);
	org = tree.origin;
	pos2 = (org[0],org[1],0);
	treeorg.angles = vectortoangles( pos1 - pos2 );
	
 	treeang = tree.angles;
	ang = treeorg.angles;
	org = point;
	pos1 = (org[0],org[1],0);
	org = tree.origin;
	pos2 = (org[0],org[1],0);
	treeorg.angles = vectortoangles( pos1 - pos2 );
	tree linkto( treeorg );
	
	treeorg rotatepitch( -90, 1.1, .05, .2 );
	treeorg waittill( "rotatedone" );
	treeorg rotatepitch( 5, .21, .05, .15 );
	treeorg waittill( "rotatedone" );
	treeorg rotatepitch( -5, .26, .15, .1 );
	treeorg waittill( "rotatedone" );
	tree unlink();
	treeorg delete();
}

context_Sensative_Dialog()
{
	thread context_Sensative_Dialog_Guy_Crawling();
	thread context_Sensative_Dialog_Guy_Pain();
	thread context_Sensative_Dialog_Guy_Pain_Falling();
	thread context_Sensative_Dialog_Secondary_Explosion_Vehicle();
	thread context_Sensative_Dialog_Kill_Thread();
	thread context_Sensative_Dialog_Locations();
	thread context_Sensative_Dialog_Filler();
}

context_Sensative_Dialog_Guy_Crawling()
{
	for (;;)
	{
		level waittill ( "ai_crawling", guy );
		
		if ( ( isdefined( guy ) ) && ( isdefined( guy.origin ) ) )
		{
			if ( getdvar( "ac130_debug_context_sensative_dialog" ) == "1" )
				thread debug_line(level.player.origin, guy.origin, 5.0, ( 0, 1, 0 ) );
		}
		
		thread context_Sensative_Dialog_Play_Random_Group_Sound( "wounded_ai", "crawl" );
	}
}

context_Sensative_Dialog_Guy_Pain_Falling()
{
	for (;;)
	{
		level waittill ( "ai_pain_falling", guy );
		
		if ( ( isdefined( guy ) ) && ( isdefined( guy.origin ) ) )
		{
			if ( getdvar( "ac130_debug_context_sensative_dialog" ) == "1" )
				thread debug_line(level.player.origin, guy.origin, 5.0, ( 1, 0, 0 ) );
		}
		
		thread context_Sensative_Dialog_Play_Random_Group_Sound( "wounded_ai", "pain" );
	}
}

context_Sensative_Dialog_Guy_Pain()
{
	for (;;)
	{
		level waittill ( "ai_pain", guy );
		
		if ( ( isdefined( guy ) ) && ( isdefined( guy.origin ) ) )
		{
			if ( getdvar( "ac130_debug_context_sensative_dialog" ) == "1" )
				thread debug_line(level.player.origin, guy.origin, 5.0, ( 1, 0, 0 ) );
		}
		
		thread context_Sensative_Dialog_Play_Random_Group_Sound( "wounded_ai", "pain" );
	}
}

context_Sensative_Dialog_Secondary_Explosion_Vehicle()
{
	for (;;)
	{
		level waittill ( "vehicle_explosion", vehicle_origin );
		
		wait 1;
		
		if ( isdefined( vehicle_origin ) )
		{
			if ( getdvar( "ac130_debug_context_sensative_dialog" ) == "1" )
				thread debug_line(level.player.origin, vehicle_origin, 5.0, ( 0, 0, 1 ) );
		}
		
		thread context_Sensative_Dialog_Play_Random_Group_Sound( "explosion", "secondary" );
	}
}

context_Sensative_Dialog_Kill( guy )
{
	if ( isdefined( level.LevelSpecificSpawnerCallbackThread ) )
		thread [[ level.LevelSpecificSpawnerCallbackThread ]]( guy );
	
	if ( !isdefined( guy ) )
		return;
	
	if ( ( !isdefined( guy.team ) ) || ( guy.team != "axis" ) )
		return;
	
	guy waittill ( "death", attacker );
	
	if ( !isdefined( attacker ) )
		return;
	
	if ( attacker != level.player )
		return;
	
	level.enemiesKilledInTimeWindow++;
	level notify ( "enemy_killed" );
	
	if ( ( isdefined( guy ) ) && ( isdefined( guy.origin ) ) )
	{
		if ( getdvar( "ac130_debug_context_sensative_dialog" ) == "1" )
			thread debug_line(level.player.origin, guy.origin, 5.0, ( 1, 1, 0 ) );
	}
}

context_Sensative_Dialog_Kill_Thread()
{
	timeWindow = 1;
	for (;;)
	{
		level waittill ( "enemy_killed" );
		wait timeWindow;
		println ( "guys killed in time window: " );
		println ( level.enemiesKilledInTimeWindow );
		
		soundAlias1 = "kill";
		soundAlias2 = undefined;
		
		if ( level.enemiesKilledInTimeWindow >= 3 )
			soundAlias2 = "large_group";
		else if ( level.enemiesKilledInTimeWindow == 2 )
			soundAlias2 = "small_group";
		else
		{
			soundAlias2 = "single";
			if ( randomint( 3 ) != 1 )
			{
				level.enemiesKilledInTimeWindow = 0;
				continue;
			}
		}
		
		level.enemiesKilledInTimeWindow = 0;
		assert( isdefined( soundAlias2 ) );
		
		thread context_Sensative_Dialog_Play_Random_Group_Sound( soundAlias1, soundAlias2, true );
	}
}

context_Sensative_Dialog_Locations()
{
	array_thread( getentarray( "context_dialog_car",		"targetname" ),	::context_Sensative_Dialog_Locations_Add_Notify_Event, "car" );
	array_thread( getentarray( "context_dialog_truck",		"targetname" ),	::context_Sensative_Dialog_Locations_Add_Notify_Event, "truck" );
	array_thread( getentarray( "context_dialog_building",	"targetname" ),	::context_Sensative_Dialog_Locations_Add_Notify_Event, "building" );
	array_thread( getentarray( "context_dialog_wall",		"targetname" ),	::context_Sensative_Dialog_Locations_Add_Notify_Event, "wall" );
	
	thread context_Sensative_Dialog_Locations_Thread();
}

context_Sensative_Dialog_Locations_Thread()
{
	for (;;)
	{
		level waittill ( "context_location", locationType );
		
		if ( !isdefined( locationType ) )
		{
			assertMsg( "LocationType " + locationType + " is not valid" );
			continue;
		}
		
		if ( !flag( "allow_context_sensative_dialog" ) )
			continue;
		
		thread context_Sensative_Dialog_Play_Random_Group_Sound( "location", locationType );
		
		wait ( 5 + randomfloat( 10 ) );
	}
}

context_Sensative_Dialog_Locations_Add_Notify_Event( locationType )
{
	for (;;)
	{
		self waittill ( "trigger", triggerer );
		
		if ( !isdefined( triggerer ) )
			continue;
		
		if ( ( !isdefined( triggerer.team) ) || ( triggerer.team != "axis" ) )
			continue;
		
		level notify ( "context_location", locationType );
		
		wait 5;
	}
}

context_Sensative_Dialog_VehicleSpawn( vehicle )
{
	if ( vehicle.script_team != "axis" )
		return;
	
	vehicle endon( "death" );
	
	//chad
	//target_set( vehicle, ( 0, 0, 100 ) );
	//target_setShader( vehicle, "ac130_hud_target" );
	//target_setOffscreenShader( vehicle, "ac130_hud_target" );
	
	while( !within_fov( level.player getEye(), level.player getPlayerAngles(), vehicle.origin, level.cosine[ "45" ] ) )
		wait 0.5;
	
	context_Sensative_Dialog_Play_Random_Group_Sound( "vehicle", "incoming" );
	wait 0.05;
	thread context_Sensative_Dialog_Play_Random_Group_Sound( "vehicle", "clearengage" );
}

context_Sensative_Dialog_Filler()
{
	for(;;)
	{
		if( ( isdefined( level.radio_in_use ) ) && ( level.radio_in_use == true ) )
			level waittill ( "radio_not_in_use" );
		
		// if 3 seconds has passed and nothing has been transmitted then play a sound
		currentTime = getTime();
		if ( ( currentTime - level.lastRadioTransmission ) >= 3000 )
		{
			level.lastRadioTransmission = currentTime;
			thread context_Sensative_Dialog_Play_Random_Group_Sound( "misc", "action" );
		}
		
		wait 0.25;
	}
}

context_Sensative_Dialog_Play_Random_Group_Sound( name1, name2, force_transmit_on_turn )
{
	assert( isdefined( level.scr_sound[ name1 ] ) );
	assert( isdefined( level.scr_sound[ name1 ][ name2 ] ) );
	
	if ( !isdefined( force_transmit_on_turn ) )
		force_transmit_on_turn = false;
	
	if ( !flag( "allow_context_sensative_dialog" ) )
	{
		if ( force_transmit_on_turn )
			flag_wait( "allow_context_sensative_dialog" );
		else
			return;
	}
	
	validGroupNum = undefined;
	
	randGroup = randomint( level.scr_sound[ name1 ][ name2 ].size );
	
	// if randGroup has already played
	if ( level.scr_sound[ name1 ][ name2 ][ randGroup ].played == true )
	{
		//loop through all groups and use the next one that hasn't played yet
		
		for( i = 0 ; i < level.scr_sound[ name1 ][ name2 ].size ; i++ )
		{
			randGroup++;
			if ( randGroup >= level.scr_sound[ name1 ][ name2 ].size )
				randGroup = 0;
			if ( level.scr_sound[ name1 ][ name2 ][ randGroup ].played == true )
				continue;
			validGroupNum = randGroup;
			break;
		}
		
		// all groups have been played, reset all groups to false and pick a new random one
		if ( !isdefined( validGroupNum ) )
		{
			for( i = 0 ; i < level.scr_sound[ name1 ][ name2 ].size ; i++ )
				level.scr_sound[ name1 ][ name2 ][ i ].played = false;
			validGroupNum = randomint( level.scr_sound[ name1 ][ name2 ].size );
		}
	}
	else
		validGroupNum = randGroup;
	
	assert( isdefined( validGroupNum ) );
	assert( validGroupNum >= 0 );
	
	if ( context_Sensative_Dialog_Timedout( name1, name2, validGroupNum ) )
		return;
	
	level.scr_sound[ name1 ][ name2 ][ validGroupNum ].played = true;
	randSound = randomint( level.scr_sound[ name1 ][ name2 ][ validGroupNum ].size );
	playSoundOverRadio( level.scr_sound[ name1 ][ name2 ][ validGroupNum ].sounds[ randSound ], force_transmit_on_turn );
}

context_Sensative_Dialog_Timedout( name1, name2, groupNum )
{
	// dont play this sound if it has a timeout specified and the timeout has not expired
	
	if( !isdefined( level.context_sensative_dialog_timeouts ) )
		return false;
	
	if( !isdefined( level.context_sensative_dialog_timeouts[ name1 ] ) )
		return false;
	
	if( !isdefined( level.context_sensative_dialog_timeouts[ name1 ][name2 ] ) )
		return false;
	
	if( ( isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups ) ) && ( isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ] ) ) )
	{
		assert( isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v["timeoutDuration"] ) );
		assert( isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v["lastPlayed"] ) );
		
		currentTime = getTime();
		if( ( currentTime - level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v["lastPlayed"] ) < level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v["timeoutDuration"] )
			return true;
		
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v["lastPlayed"] = currentTime;
	}
	else if ( isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v ) )
	{
		assert( isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v["timeoutDuration"] ) );
		assert( isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v["lastPlayed"] ) );
		
		currentTime = getTime();
		if( ( currentTime - level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v["lastPlayed"] ) < level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v["timeoutDuration"] )
			return true;
		
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v["lastPlayed"] = currentTime;
	}
	
	return false;
}

playSoundOverRadio( soundAlias, force_transmit_on_turn )
{
	if ( !isdefined( level.radio_in_use ) )
		level.radio_in_use = false;
	if ( !isdefined( force_transmit_on_turn ) )
		force_transmit_on_turn = false;
	
	soundPlayed = false;
	soundPlayed = playAliasOverRadio( soundAlias );
	if ( soundPlayed )
		return;
	
	// Dont make the sound wait to be played if force transmit wasn't set to true
	if ( !force_transmit_on_turn )
		return;
	
	level.radioForcedTransmissionQueue[ level.radioForcedTransmissionQueue.size ] = soundAlias;
	while( !soundPlayed )
	{
		if ( level.radio_in_use )
			level waittill ( "radio_not_in_use" );
		soundPlayed = playAliasOverRadio( level.radioForcedTransmissionQueue[ 0 ] );
		if ( !level.radio_in_use && !soundPlayed )
			assertMsg( "The radio wasn't in use but the sound still did not play. This should never happen." );
	}
	level.radioForcedTransmissionQueue = array_remove_index( level.radioForcedTransmissionQueue, 0 );
}

playAliasOverRadio( soundAlias )
{
	if ( level.radio_in_use )
		return false;
	
	level.radio_in_use = true;
	level.player playLocalSound( soundAlias, "playSoundOverRadio_done" );
	level.player waittill( "playSoundOverRadio_done" );
	level.radio_in_use = false;
	level.lastRadioTransmission = getTime();
	level notify ( "radio_not_in_use" );
	return true;
}

debug_circle(center, radius, duration, color, startDelay, fillCenter)
{
	circle_sides = 16;
	
	angleFrac = 360/circle_sides;
	circlepoints = [];
	for(i=0;i<circle_sides;i++)
	{
		angle = (angleFrac * i);
		xAdd = cos(angle) * radius;
		yAdd = sin(angle) * radius;
		x = center[0] + xAdd;
		y = center[1] + yAdd;
		z = center[2];
		circlepoints[circlepoints.size] = (x,y,z);
	}
	
	if (isdefined(startDelay))
		wait startDelay;
	
	thread debug_circle_drawlines(circlepoints, duration, color, fillCenter, center);
}

debug_circle_drawlines(circlepoints, duration, color, fillCenter, center)
{
	if (!isdefined(fillCenter))
		fillCenter = false;
	if (!isdefined(center))
		fillCenter = false;
	
	for( i = 0 ; i < circlepoints.size ; i++ )
	{
		start = circlepoints[i];
		if (i + 1 >= circlepoints.size)
			end = circlepoints[0];
		else
			end = circlepoints[i + 1];
		
		thread debug_line( start, end, duration, color);
		
		if (fillCenter)
			thread debug_line( center, start, duration, color);
	}
}

debug_line(start, end, duration, color)
{
	if (!isdefined(color))
		color = (1,1,1);
	
	for ( i = 0; i < (duration * 20) ; i++ )
	{
		line(start, end, color);
		wait 0.05;
	}
}