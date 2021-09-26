#include maps\_utility;

/*
	maps\_artillery::SetShellDelay( float ); // time it takes for shell to impact after being fired
	maps\_artillery::SetShellDeviance( float ); // radius in which the shell will impact relative to the target point
	maps\_artillery::SetTargetOffset( float ); // obsolete
	maps\_artillery::SetAllowRegions( entArray ); // a list of triggers in which artillery can be targetted
	maps\_artillery::SetDenyRegions( entArray ); // a list of triggers in which artillery cannot be targetted
	maps\_artillery::EnableUse(); // enable the use of artillery
	maps\_artillery::DisableUse(); // disable the use of artillery
*/

main()
{
	Hud_Init();
	Battery_Init();
	Button_Init();
	Anim_Init();

	InitTargetOrigin();
	SetShellDelay( 3.0 );
	SetReloadDelay( 3.0 );
	SetTargetOffset( 0 );
	SetShellDeviance( 384 );
	SetAllowRegions( getEntArray( "artillery_allow", "targetname" ) );
	SetDenyRegions( getEntArray( "artillery_deny", "targetname" ) );
	SetUseRegions( getEntArray( "artillery_use", "targetname" ) );
	SetRadioMan( undefined );
	EnableUse();
	SetInProgress( false );
	SetLastIncomingTime();
	
	level thread Artillery_WaitForUse();
}

Anim_Init()
{
	level.scrsound["braeburn"]["firemission"] = "braeburn_arty_firemission";
	level.scrsound["braeburn"]["coord0"] = "braeburn_arty_0";
	level.scrsound["braeburn"]["coord1"] = "braeburn_arty_1";
	level.scrsound["braeburn"]["coord2"] = "braeburn_arty_2";
	level.scrsound["braeburn"]["coord3"] = "braeburn_arty_3";
	level.scrsound["braeburn"]["coord4"] = "braeburn_arty_4";
	level.scrsound["braeburn"]["coord5"] = "braeburn_arty_5";
	level.scrsound["braeburn"]["coord6"] = "braeburn_arty_6";
	level.scrsound["braeburn"]["coord7"] = "braeburn_arty_7";
	level.scrsound["braeburn"]["coord8"] = "braeburn_arty_8";
	level.scrsound["braeburn"]["coord9"] = "braeburn_arty_9";
	level.scrsound["braeburn"]["pointfuse"] = "braeburn_arty_pointfuse";
	level.scrsound["braeburn"]["gimmetarget"] = "braeburn_arty_gimmetarget";

	level.scrsound["braeburn"]["requestnew"] = "us_arty_requestnew";
	level.scrsound["braeburn"]["notvalid"] = "us_arty_notvalid";
	level.scrsound["braeburn"]["tooclose"] = "us_arty_tooclose";
	level.scrsound["braeburn"]["nomoreavail"] = "us_arty_nomoreavail";
	level.scrsound["braeburn"]["battery"] = "us_arty_battery";
	level.scrsound["braeburn"]["reloading"] = "us_arty_reloading";
	level.scrsound["braeburn"]["shot"] = "us_arty_shot";

	level.scrsound["macgregor"]["firemission"] = "mcg_arty_firemissiontrp";
	level.scrsound["macgregor"]["trp"] = "mcg_arty_trp";
	level.scrsound["macgregor"]["coord0"] = "mcg_arty_0";
	level.scrsound["macgregor"]["coord1"] = "mcg_arty_1";
	level.scrsound["macgregor"]["coord2"] = "mcg_arty_2";
	level.scrsound["macgregor"]["coord3"] = "mcg_arty_3";
	level.scrsound["macgregor"]["coord4"] = "mcg_arty_4";
	level.scrsound["macgregor"]["coord5"] = "mcg_arty_5";
	level.scrsound["macgregor"]["coord6"] = "mcg_arty_6";
	level.scrsound["macgregor"]["coord7"] = "mcg_arty_7";
	level.scrsound["macgregor"]["coord8"] = "mcg_arty_8";
	level.scrsound["macgregor"]["coord9"] = "mcg_arty_9";
	level.scrsound["macgregor"]["pointfuse"] = "mcg_arty_firemissionfuse";
	level.scrsound["macgregor"]["over"] = "mcg_arty_over";
	level.scrsound["macgregor"]["gimmetarget"] = "mcg_arty_realtarget";

	level.scrsound["macgregor"]["requestnew"] = "british_arty_requestnew";
	level.scrsound["macgregor"]["notvalid"] = "british_arty_notvalidtarget";
	level.scrsound["macgregor"]["tooclose"] = "british_arty_tooclose";
	level.scrsound["macgregor"]["nomoreavail"] = "british_arty_nofireavail";
	level.scrsound["macgregor"]["battery"] = "british_arty_batteryunavail";
	level.scrsound["macgregor"]["reloading"] = "british_arty_standbyreload";
	level.scrsound["macgregor"]["shot"] = "british_arty_shotover";

}
Artillery_WaitForUse()
{
	while ( true )
	{
		level.player waittill ( "fire button down" );

		if ( !CanUse() )
			continue;
		
		if ( !IsInUseRegion() )
		{
			level thread Artillery_DenyUse( "unavailable" );
			continue;
		}
		else if ( IsInProgress() )
		{
			level thread Artillery_DenyUse( "in progress" );
			continue;
		}
		else if ( !isdefined( GetRadioMan() ) || !IsRadioManInRange() )
		{
			level thread Artillery_DenyUse( "too far" );
			continue;
		}

		/*
		holdTime = 0;
		barrageSize = 0;
		while ( Button_IsFirePressed() )
		{			
			if ( !(holdTime % 100) && Battery_GetAvailable() > 0 )
				barrageSize += Battery_LockShells( 4 );

			wait (0.05);
			holdTime += 5;
		}
		*/
		
		barrageSize = 0;
		if ( Battery_GetAvailable() > 0 )
			barrageSize = Battery_LockShells( 12 );
		
		targetPos = GetTargetedPos();
		
		if ( !isdefined( targetPos ) )
			Artillery_DenyUse( "no target" );
		else if ( !IsPosInValidRegion( targetPos ) )
			Artillery_DenyUse( "invalid region" );
		else if ( IsPosNearFriendlies( targetPos ) )
			Artillery_DenyUse( "too close" );
		else if ( !barrageSize )
			Artillery_DenyUse( "reloading" );
		else
			level thread Artillery_ApproveUse( targetPos, barrageSize );
	}
}

local_single_solo( soldier, anime, facialHack )
{
	soldier dialog_add( anime );
	/*
	if ( self._animActive || ( isDefined( facialHack ) && facialHack ) )
	{
		if ( !self._animActive )
			self thread maps\_anim::anim_single_solo( soldier, anime );
		
		if ( isDefined( level.scr_face[self.animname][anime] ) )
			wait ( getAnimLength( level.scr_face[self.animname][anime] ) );
		else
			wait ( 1.0 );
	}
	else
	{
		self maps\_anim::anim_single_solo( soldier, anime );
	}
	*/
}

waitfordialog()
{
	while ( self.dialogque.size )
		wait ( 0.05 );
}

Artillery_DenyUse( denialReason )
{
	radioMan = GetRadioMan();
	
	level notify ("artillery_denial",denialReason);
	switch ( denialReason )
	{
	case "invalid region":
		radioMan waitfordialog();
		radioMan local_single_solo( radioMan, "trp" );
		radioMan local_single_solo( radioMan, "coord" + randomInt( 9 ), true );
		radioMan local_single_solo( radioMan, "coord" + randomInt( 9 ), true );
		radioMan local_single_solo( radioMan, "coord" + randomInt( 9 ), true );
		radioMan local_single_solo( radioMan, "over" );
		Battery_UnlockAllShells();
		radioMan local_single_solo( radioMan, "requestnew" );
		radioMan waittill ("que finished");
		break;
	case "no target":
		radioMan waitfordialog();
		radioMan local_single_solo( radioMan, "gimmetarget" );
		Battery_UnlockAllShells();
		radioMan waittill ("que finished");
		break;
	case "in progress":
		break;		
	case "reloading":
		radioMan waitfordialog();
		radioMan local_single_solo( radioMan, "trp" );
		radioMan local_single_solo( radioMan, "coord" + randomInt( 9 ), true );
		radioMan local_single_solo( radioMan, "coord" + randomInt( 9 ), true );
		radioMan local_single_solo( radioMan, "coord" + randomInt( 9 ), true );
		radioMan local_single_solo( radioMan, "over" );	
		radioMan local_single_solo( radioMan, "reloading" );
		radioMan waittill ("que finished");
		break;		
	case "too close":
		radioMan waitfordialog();
		radioMan local_single_solo( radioMan, "trp" );
		radioMan local_single_solo( radioMan, "coord" + randomInt( 9 ), true );
		radioMan local_single_solo( radioMan, "coord" + randomInt( 9 ), true );
		radioMan local_single_solo( radioMan, "coord" + randomInt( 9 ), true );
		radioMan local_single_solo( radioMan, "over" );	
		Battery_UnlockAllShells();
		radioMan local_single_solo( radioMan, "tooclose" );
		radioMan waittill ("que finished");
		break;
	case "unavailable":
//		level.player playSound( "" );
		Battery_UnlockAllShells();
		break;
	case "too far":
		iprintlnbold( &"SCRIPT_ARTILLERY_TOOFAR" );
		break;		
	default:
		break;
	}
}




Artillery_ApproveUse( targetPos, barrageSize )
{
	radioMan = GetRadioMan();

	if(isdefined(level._effect["artillery_indicator"]))
		playfx(level._effect["artillery_indicator"], targetPos);
	SetInProgress( true );
	level notify ("artillery_inprogress"); //  kills some reminder dialog in decoytown

	shellPositions = [];
	for ( index = 0; index < barrageSize; index++ )
		shellPositions[index] = CalcShellPos( targetPos );

	radioMan waitfordialog();
	radioMan local_single_solo( radioMan, "trp" );
	radioMan local_single_solo( radioMan, "coord" + randomInt( 9 ), true );
	radioMan local_single_solo( radioMan, "coord" + randomInt( 9 ), true );
	radioMan local_single_solo( radioMan, "coord" + randomInt( 9 ), true );
	radioMan local_single_solo( radioMan, "over" );
	radioMan local_single_solo( radioMan, "shot" );
	radioMan waittill ("que finished");

	SetInProgress( false );

	level.artilleryGlobalDelay = 0;
	for ( index = 0; index < barrageSize; index++ )
	{
		level thread FireShell( shellPositions[index] );
	}
	
	shellImpacts = 0;
	while ( shellImpacts < barrageSize )
	{
		level waittill ( "artillery shell impact" );
		shellImpacts++;
	}
}



FireShell( shellPos )
{
	shellEnt = spawn( "script_origin", shellPos );

	maxDelay = (GetReloadDelay() / 12) - 0.01;
	minDelay = maxDelay / 2;
	
	level.artilleryGlobalDelay += randomFloatRange( minDelay, maxDelay );
	Battery_ShellFired( level.artilleryGlobalDelay );
	wait ( level.artilleryGlobalDelay );
	
	level.player FiringSound();
	wait ( GetShellDelay() );
	
	shellEnt IncomingSound();
	
	shellEnt Impact();
	shellEnt delete();
	level notify ( "artillery shell impact" );
}


FiringSound()
{
	level.player playsound( "artillery_fire" );
	level.player playsound( "distant_explosion_triggered" );
}


IncomingSound()
{
	level notify("incoming_shell_start");
	
	if ( getTime() < GetLastIncomingTime() + 2.0 )
	{
		wait ( 1.5 );
		return;
	}

	SetLastIncomingTime();
	self playsound( "artillery_incoming", "artillery_incoming " + self.origin, false );
	self waittill ( "artillery_incoming " + self.origin );
}


Impact()
{
	level.player playsound( "artillery_explosion" );
	if ( gettime() - level.artillery["lastfxtime"] > 800 )
	{
		playfx( level._effect["artillery"], self.origin );
		level.artillery["lastfxtime"] = gettime();
	}
	earthquake(0.25, 0.75, self.origin, 4096);
	radiusDamage (self.origin, 256, 1000, 900);
}


IsPosInValidRegion( targetPos )
{
	targetEnt = GetTargetOrigin();
	targetEnt.origin = targetPos;
	regions = GetDenyRegions();

	for ( index = 0; index < regions.size; index++ )
	{ 
		if ( targetEnt isTouching( regions[index] ) )
			return ( false );
	}

	regions = GetAllowRegions();
	
	if ( !regions.size )
		return ( true );
	
	for ( index = 0; index < regions.size; index++ )
	{ 
		if ( targetEnt isTouching( regions[index] ) )
			return ( true );
	}
	return ( false );
}


IsPosNearFriendlies( targetPos )
{
	friendlies = getAiArray( "allies" );
	
	for ( index = 0; index < friendlies.size; index++ )
	{
		if ( distance( targetPos, friendlies[index].origin ) < 700 )
			return ( true );
	}
	
	return ( false );
}


IsInUseRegion()
{
	regions = GetUseRegions();

	if ( !regions.size )
		return ( true );

	for ( index = 0; index < regions.size; index++ )
	{ 
		if ( level.player isTouching( regions[index] ) )
			return ( true );
	}

	return ( false );
}


GetTargetedPos()
{
	startOrigin = level.player getEye();
	forward = anglesToForward( level.player getplayerangles() );
	forward = vector_scale( forward, 100000 );
	endOrigin = startOrigin + forward;
	
	trace = bulletTrace( startOrigin, endOrigin, false, level.player );

	if ( trace["fraction"] == 1.0 || trace["surfacetype"] == "default")
		return ( undefined );
	else
		return ( trace["position"] );
}


CalcShellPos( targetPos )
{
	targetPos += GetTargetOffset();
	shellPos = undefined;
	iterations = 0;
	
	while ( !isdefined (shellPos) && iterations < 5 )
	{
		shellPos = targetPos;
		angle = randomfloat( 360 );
		radius = randomfloat( GetShellDeviance() );
		randomOffset = ( cos( angle ) * radius, sin( angle ) * radius, 0 );
		shellPos += randomOffset;
	
		startOrigin = shellPos + (0, 0, 512);
		endOrigin = shellPos + (0, 0, -2048);
		
		trace = bulletTrace( startOrigin, endOrigin, false, undefined );
		
		if ( trace["fraction"] < 1.0 )
			shellPos = trace["position"];
		else
			shellPos = undefined;
		
		iterations++;
	}
//	assert( isdefined( shellPos ) );
	return ( shellPos );
}


Artillery_Trigger()
{
	while ( true )
	{
		self waittill ( "trigger" );
		
		EnableUse();
	}
}

InitTargetOrigin()
{
	level.artillery["origin"] = spawn ("script_origin", (0, 0, 0));
}


SetRadioMan( soldier )
{
	if ( isdefined( soldier ) )
		assert( issubstr( tolower( soldier.name ), "macgregor" ) || issubstr( tolower( soldier.name ), "braeburn" ) );
	
	level.artillery["radioman"] = soldier;
	
	if ( isdefined( soldier ) )
		thread Hud_Create();
}


GetRadioMan()
{
	if ( !isalive( level.artillery["radioman"] ) )
		return ( undefined );

	if ( !isdefined( level.artillery["radioman"].animname ) )
		level.artillery["radioman"].animname = "braeburn";
	
	return ( level.artillery["radioman"] );
}


IsRadioManInRange()
{
	radioMan = GetRadioMan();
	if ( !isdefined( radioMan ) )
		return ( false );
		
	if ( distance( radioMan.origin, level.player.origin ) > 512 )
		return ( false );
		
	return ( true );
}


GetLastIncomingTime()
{
	return ( level.artillery["lastincoming"] );
}


SetLastIncomingTime()
{
	level.artillery["lastincoming"] = getTime();
}


GetTargetOrigin()
{
	return ( level.artillery["origin"] );
}


SetTargetOffset( maxOffset )
{
	angle = randomfloat( 360 );
	radius = randomfloat( maxOffset );
	level.artillery["offset"] = ( cos( angle ) * radius, sin( angle) * radius, 0 );
}


GetTargetOffset()
{
	return ( level.artillery["offset"] );
}


SetAllowRegions( regions )
{
	level.artillery["allowregions"] = regions;
}


GetAllowRegions()
{
	return ( level.artillery["allowregions"] );
}


SetDenyRegions( regions )
{
	level.artillery["denyregions"] = regions;
}


GetDenyRegions()
{
	return ( level.artillery["denyregions"] );
}


SetUseRegions( regions )
{
	level.artillery["useregions"] = regions;
}


GetUseRegions()
{
	return ( level.artillery["useregions"] );
}


EnableUse()
{
	level.artillery["canuse"] = true;
}


DisableUse()
{
	level.artillery["canuse"] = false;
}


CanUse()
{
	return ( level.artillery["canuse"] ); 
}


SetShellDelay( maxDelay )
{
	level.artillery["shelldelay"] = maxDelay;
}


GetShellDelay()
{
	return ( level.artillery["shelldelay"] );
}


SetReloadDelay( maxDelay )
{
	level.artillery["reloaddelay"] = maxDelay;
}


GetReloadDelay()
{
	return ( level.artillery["reloaddelay"] );
}


SetShellDeviance( maxDeviance )
{
	level.artillery["shelldeviance"] = maxDeviance;
}


GetShellDeviance()
{
	return ( level.artillery["shelldeviance"] );
}


SetInProgress( state )
{
	level.artillery["inprogress"] = state;
}


IsInProgress()
{
	return ( level.artillery["inprogress"] );
}


Button_SetFirePressed( state )
{
	level.artillery["buttonpressed"] = state;
}


Button_IsFirePressed()
{
	return ( level.artillery["buttonpressed"] );
}


Button_SetBinoculars( state )
{
	level.artillery["binoculars"] = state;	

	if ( !isDefined( level.artillery["hudhint"] ) )
		return;
		
	if ( state )
	{
		level.artillery["hudhint"].label = level.artillery["hudhintuse"];
	}
	else
	{
		level.artillery["hudhint"].label = level.artillery["hudhintsight"];
	}
}


Button_IsBinocularsPressed()
{
	return ( level.artillery["binoculars"] );
}


Button_Init()
{
	Button_SetBinoculars( false );
	Button_SetFirePressed( false );
	level thread Button_WaitForUse();
}

Button_WaitForUse()
{
	level.player endon ("death");
	while ( true )
	{
		msg = level.player waittill_any( "binocular_fire", "binocular_release", "binocular_enter", "binocular_exit" );
		
		switch ( msg )
		{
		case "binocular_fire":
			Button_SetFirePressed( true );
			level.player notify ( "fire button down" );
			break;
		case "binocular_release":
			Button_SetFirePressed( false );
			level.player notify ( "fire button up" );
			break;
		case "binocular_enter":
			Button_SetBinoculars( true );
//			level thread Hud_WaitForDisplay();
			break;
		case "binocular_exit":
			Button_SetBinoculars( false );
//			if ( Hud_IsActive() )
//				Hud_Destroy();
			break;
		}
	}
}


Battery_Init()
{
	level.artillery["shellsavailable"] = 0;
	for ( index = 0; index < 12; index++ )
	{
		level.artillery["battery"][index] = spawnstruct();
		Battery_UnlockShell( index );
		level.artillery["battery"][index].lastFireTime = -12000;
		level.artillery["battery"][index].isReloading = false;
	}
	
	level.artillery["lastfxtime"] = 0;
}


Battery_WaitForUse()
{
	while ( true )
	{
		level waittill ( "artillery shell fired" );

		curTime = getTime();
		for ( index = 0; index < 12; index++ )
		{
			if ( !Battery_IsLocked( index ) || Battery_GetReloadTime( index, curTime ) > 0 )
				continue;
				
			level thread Battery_Reload( index, curTime );
			break;
		}
	}
}


Battery_ShellFired( fireDelay )
{
	curTime = getTime();
	for ( index = 0; index < 12; index++ )
	{
		if ( !Battery_IsLocked( index ) || level.artillery["battery"][index].isReloading )
			continue;
			
		level thread Battery_Reload( index, curTime );
		level thread Hud_FireShell( index, fireDelay );
		break;
	}
}


Battery_Reload( shellIndex, curTime )
{
	level.artillery["battery"][shellIndex].isReloading = true;
	level.artillery["battery"][shellIndex].lastFireTime = curTime;
	wait ( GetReloadDelay() );
	Battery_UnlockShell( shellIndex );
	level.artillery["battery"][shellIndex].isReloading = false;
}


Battery_IsReloading( shellIndex )
{
	return ( level.artillery["battery"][shellIndex].isReloading );
}


Battery_LockShells( numShells )
{
	numLocks = 0;
	curTime = getTime();
	for ( index = 0; index < 12; index++ )
	{
		if ( Battery_IsLocked( index ) )
			continue;
			
		Battery_LockShell( index );
		numLocks++;
		
		if ( numLocks == numShells )
			break;
	}
	
	return ( numLocks );
}


Battery_UnlockAllShells()
{
	for ( index = 0; index < 12; index++ )
	{
		if ( Battery_IsLocked( index ) && !Battery_IsReloading( index ) )
			Battery_UnlockShell( index );
	}
}


Battery_GetAvailable()
{
	return ( level.artillery["shellsavailable"] );
}


Battery_LockShell( shellIndex )
{
	level.artillery["battery"][shellIndex].isLocked = true;
	level.artillery["shellsavailable"]--;
	
	if ( !Hud_IsActive() )
		return;

	Hud_SetColor( shellIndex, (1.0, 0.0, 0.0) );
}


Battery_UnlockShell( shellIndex )
{
	level.artillery["battery"][shellIndex].isLocked = false;
	level.artillery["shellsavailable"]++;

	if ( !Hud_IsActive() )
		return;

	Hud_SetShader( shellIndex, "artillery" );
	Hud_SetColor( shellIndex, (1.0, 1.0, 1.0) );
}


Battery_IsLocked( shellIndex )
{
	return ( level.artillery["battery"][shellIndex].isLocked );
}


Battery_GetReloadTime( shellIndex, curTime )
{
	if ( curTime < level.artillery["battery"][shellIndex].lastFireTime + (GetReloadDelay() * 1000) )
		return ( GetReloadDelay() - ((curTime - level.artillery["battery"][shellIndex].lastFireTime) * 0.001) );
	else
		return ( 0 );
}


Hud_Init()
{
	precacheShader( "artillery" );
	precacheShader( "artillery_firing" );

	precacheString(&"SCRIPT_ARTILLERY_TOOFAR");
	precacheString(&"SCRIPT_PLATFORM_HINT_SIGHTARTILLERY");
	precacheString(&"SCRIPT_PLATFORM_HINT_SIGHTARTILLERY_BREATH");
	precacheString(&"SCRIPT_PLATFORM_HINT_USEARTILLERY");

	level.artillery["hudhintuse"] = &"SCRIPT_PLATFORM_HINT_USEARTILLERY";

	Hud_SetActive( false );
	level thread updateBinocularsSight();
	level thread updateHudHint();
}


Hud_WaitForDisplay()
{
	while ( Button_IsBinocularsPressed() )
	{
		if ( !Hud_IsActive() )
		{
			if ( CanUse() && IsInUseRegion() && isdefined( GetRadioMan() ) && IsRadioManInRange() )
				Hud_Create();
		}
		else
		{
			if ( !CanUse() || !IsInUseRegion() || !isdefined( GetRadioMan() ) || !IsRadioManInRange() )
				Hud_Destroy();
		}
		
		wait ( 0.1 );
	}
}


updateHudHint()
{
	while ( true )
	{
		if ( isDefined ( level.artillery["hudhint"] ) )
		{
			if ( Button_IsBinocularsPressed() )
				level.artillery["hudhint"].label = level.artillery["hudhintuse"];
			else
				level.artillery["hudhint"].label = level.artillery["hudhintsight"];
		}
			
		wait ( 0.1 );
	}
}


Hud_Create()
{
	waittillframeend;
	offsetHorz = -18;
	offsetVert = 8;
	tweakHorz = 0;
	tweakVert = 0;
	iconSize = 32;
	curTime = getTime();

	level.artillery["hudhint"] = newHudElem();

	level.artillery["hudhint"].alignX = "right";
	level.artillery["hudhint"].alignY = "top";	
	level.artillery["hudhint"].horzAlign = "right";
	level.artillery["hudhint"].vertAlign = "top";	
	level.artillery["hudhint"].x = offsetHorz;
	level.artillery["hudhint"].y = offsetVert + iconSize;

	if(level.xenon)
		level.artillery["hudhint"].fontScale = 1.3;
	
	for ( index = 0; index < 12; index++ )
	{
		level.artillery["hud"][index] = newHudElem();
		level.artillery["hud"][index].sort = index;
		level.artillery["hud"][index].x = tweakHorz + offsetHorz;
		level.artillery["hud"][index].y = tweakVert + offsetVert;
		level.artillery["hud"][index].alignX = "right";
		level.artillery["hud"][index].alignY = "top";
		level.artillery["hud"][index].horzAlign = "right";
		level.artillery["hud"][index].vertAlign = "top";
		if ( Battery_IsLocked( index ) )
		{
			level.artillery["hud"][index].color = (1.0, 0.0, 0.0);
			level.artillery["hud"][index] setShader( "artillery", iconSize, iconSize );

			if ( Battery_IsReloading( index ) )
			{
				level.artillery["hud"][index] setShader( "artillery_firing", iconSize, iconSize );
			}
		}
		else
		{
			level.artillery["hud"][index].color = (1.0, 1.0, 1.0);
			level.artillery["hud"][index] setShader( "artillery", iconSize, iconSize );
		}

		if ( index % 2 )
			tweakHorz += -36;
	}
	Hud_SetActive( true );
}


bindingGen(binding, key)
{
	bind = spawnstruct();
	bind.name = binding;
	bind.key = key;
	bind.binding = getKeyBinding( binding )[key];
	return bind;
}


updateBinocularsSight()
{
	while ( true )
	{
		if ( isBound( "+binoculars" ) )
			level.artillery["hudhintsight"] = &"SCRIPT_PLATFORM_HINT_SIGHTARTILLERY";
		else if ( isBound( "+breath_binoculars" ) )
			level.artillery["hudhintsight"] = &"SCRIPT_PLATFORM_HINT_SIGHTARTILLERY_BREATH";
		else
			level.artillery["hudhintsight"] = &"SCRIPT_PLATFORM_HINT_SIGHTARTILLERY";

		wait ( 0.25 );
	}
}


Hud_Destroy()
{
	for ( index = 0; index < 12; index++ )
		level.artillery["hud"][index] destroy();
	Hud_SetActive( false );
}


Hud_SetActive( state )
{
	level.artillery["hudexists"] = state;
}


Hud_IsActive()
{
	return ( level.artillery["hudexists"] );
}


Hud_FireShell( shellIndex, fireDelay )
{
	wait ( fireDelay );
	
	if ( !Hud_IsActive() )
		return;
		
	oldAlpha = Hud_GetAlpha( shellIndex );
	Hud_SetShader( shellIndex, "artillery_firing" );
	
	for ( index = 0; index < 3 && Hud_IsActive(); index++ )
	{
		Hud_SetAlpha( shellIndex, 1.0 );
		Hud_SetColor( shellIndex, (1.0, 1.0, 1.0) );
		Hud_FadeOverTime( shellIndex, 0.1 );
		Hud_SetAlpha( shellIndex, oldAlpha );
		Hud_SetColor( shellIndex, (1.0, 0.0, 0.0) );
		wait ( 0.1 );
	}
}


Hud_FadeOverTime( shellIndex, fadeTime )
{
	level.artillery["hud"][shellIndex] fadeOverTime( fadeTime );
}


Hud_SetShader( shellIndex, shader )
{
	level.artillery["hud"][shellIndex] setShader( shader, 32, 32 );
}


Hud_SetColor( shellIndex, color )
{
	level.artillery["hud"][shellIndex].color = color;
}


Hud_GetColor( shellIndex )
{
	return ( level.artillery["hud"][shellIndex].color );
}


Hud_SetAlpha( shellIndex, alpha )
{
	level.artillery["hud"][shellIndex].alpha = alpha;
}


Hud_GetAlpha( shellIndex )
{
	return ( level.artillery["hud"][shellIndex].alpha );
}


Battery_DrawShellStatus()
{
	while ( true )
	{
		string = "";
		curTime = getTime();
		for ( index = 0; index < 12; index++ )
		{
			if ( Battery_IsReloading ( index ) )
				string += "^2";
			else if ( Battery_IsLocked( index ) )
				string += "^3"; 
			else
				string += "^4";
				
			if ( Battery_GetReloadTime( index, curTime ) > 0 )
				string += int( Battery_GetReloadTime( index, curTime ) ) + " "; 
			else
				string += "A ";
				
		}
		
		println(string);
		wait ( 0.05 );
	}
}



vector_scale (vec, scale)
{
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}


Artillery_DrawTargetPos( hitEntities )
{
	while ( true )
	{
		startOrigin = level.player getEye();
		forward = anglesToForward( level.player getplayerangles() );
		forward = vector_scale( forward, 100000 );
		endOrigin = startOrigin + forward;
		
		trace = bulletTrace( startOrigin, endOrigin, hitEntities, undefined );
	
		if ( trace["fraction"] < 1.0 )
		{
			print3d( trace["position"], "X", (1, 0, 0), 1, 2.15 );	// origin, text, RGB, alpha, scale
//			print3d( CalcShellPos( level.artilleryPos.origin ), "Y", (0, 0.5, 1), 1, 2.15 );	// origin, text, RGB, alpha, scale
		}

		print3d( level.artilleryPos.origin, "O", (0, 1, 0), 1, 2.15 );	// origin, text, RGB, alpha, scale
		print3d( level.artilleryPos.origin + GetTargetOffset(), "Y", (0, 0.5, 1), 1, 2.15 );	// origin, text, RGB, alpha, scale
		wait ( 0.05 );
	}
}

drawTargetPos( hitEntities )
{
	while ( true )
	{
		startOrigin = level.player getEye();
		forward = anglesToForward( level.player getplayerangles() );
		forward = vector_scale( forward, 100000 );
		endOrigin = startOrigin + forward;
		
		trace = bulletTrace( startOrigin, endOrigin, hitEntities, undefined );
	
		if ( trace["fraction"] < 1.0 )
			print3d( trace["position"], "X", (1, 0, 0), 1, 2.15 );	// origin, text, RGB, alpha, scale

		wait ( 0.05 );
	}
}

