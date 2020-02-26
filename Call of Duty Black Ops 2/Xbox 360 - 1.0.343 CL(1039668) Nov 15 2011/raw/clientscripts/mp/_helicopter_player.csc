// _helicopter_player.csc
// Sets up clientside behavior for the player helicopter

#include clientscripts\mp\_utility;
#include clientscripts\mp\_vehicle;
#include clientscripts\mp\_rewindobjects;

main()
{
	type = "helicopter_player_mp";
//	build_exhaust( model, "vehicle/exhaust/fx_exhaust_panzerIV" );
//	build_treadfx( type );
}

init()
{
	level._client_flag_callbacks["helicopter"][level.const_flag_warn_targeted] = ::warnMissileLocking;
	level._client_flag_callbacks["helicopter"][level.const_flag_warn_locked] = ::warnMissileLocked;
	level._client_flag_callbacks["helicopter"][level.const_flag_warn_fired] = ::warnMissileFired;
	level._client_flag_callbacks["helicopter"][level.const_flag_outofbounds] = ::warnLeavingBattlefield;
	level._client_flag_callbacks["helicopter"][level.const_flag_choppergunner] = ::chopperGunnerSpawned;
	level._client_flag_callbacks["helicopter"][level.const_flag_opendoor] = ::chopperGunnerOpenDoor;
	level._client_flag_callbacks["helicopter"][level.const_flag_crashing] = ::chopperCrashing;
	level._client_flag_callbacks["helicopter"][level.const_flag_player_helicopter] = ::playerHelicopterSwitch;
	
	init_heli_anims();
	
	level.fx_heli_warning = loadfx( "vehicle/light/fx_cobra_interior_blinking_light" );
	level.fx_hind_warning = loadfx( "vehicle/light/fx_heli_hind_interior_red_dlight" );
	level.fx_door_closed = loadfx( "vehicle/light/fx_heli_interior_red_dlight" );
	level.fx_door_open = loadfx( "vehicle/light/fx_heli_interior_green_dlight" );
	level.fx_door_ambient = loadfx( "vehicle/treadfx/fx_heli_clouds_chopper_gunner" );
}

warnMissileLocking( localClientNum, set )
{
	if ( set && !(self IsLocalClientDriver(localClientNum)) )
		return;
		
	clientscripts\mp\_helicopter_sounds::play_targeted_sound( set );
	
	playWarningLight( localClientNum, set );
}

warnMissileLocked( localClientNum, set )
{
	if ( set && !(self IsLocalClientDriver(localClientNum)) )
		return;

	clientscripts\mp\_helicopter_sounds::play_locked_sound( set );
	
	playWarningLight( localClientNum, set );
}

warnMissileFired( localClientNum, set )
{
	if ( set && !(self IsLocalClientDriver(localClientNum)) )
		return;

	clientscripts\mp\_helicopter_sounds::play_fired_sound( set );
	
	playWarningLight( localClientNum, set );
}

warnLeavingBattlefield( localClientNum, set )
{
	if ( !(self IsLocalClientDriver(localClientNum)) )
		return;

	clientscripts\mp\_helicopter_sounds::play_leaving_battlefield_alarm( set );
	
	playWarningLight( localClientNum, set );
}

playWarningLight( localClientNum, set )
{
	if ( set )
	{		
		if ( !isDefined( self.warningLightCount ) )
			self.warningLightCount = 1;
		else
			self.warningLightCount++;
		
		if ( !isDefined( self.warningLight ) )
			self thread spawnWarningLight( localClientNum );
	}
	else
	{
		if ( isDefined( self.warningLightCount ) )
		{
			if ( self.warningLightCount > 0 )
				self.warningLightCount--;
		
			if ( ( self.warningLightCount == 0 ) && isDefined( self.warningLight ) )
			{
				DeleteFX( localClientNum, self.warningLight );
				self.warningLight = undefined;
			}
		}
	}
}

spawnWarningLight( localClientNum )
{
	self endon( "entityshutdown" );
	
	if ( !IsInVehicle( localClientNum, self ) )
		return;
	
//	self.warningLight = PlayFXOnTag( localClientnum, level.fx_heli_warning, self, "tag_mfd_right_0" );
	self.warningLight = PlayFXOnTag( localClientnum, level.fx_hind_warning, self, "tag_origin" );
	
	for ( ;; )
	{
		if ( !isDefined( self.warningLight ) )
			return;
			
		if ( !IsInVehicle( localClientNum, self ) )
		{
			DeleteFX( localClientNum, self.warningLight );
			self.warningLight = undefined;
			return;	
		}
		
		wait 0.01;
	}
}

chopperGunnerSpawned( localClientNum, set )
{
	self endon( "entityshutdown" );
	
	if ( !set )
		return;
			
	self thread checkForPlayerSwitch( localClientNum );
	self thread spawnFakePlayer( localClientNum );
	self thread spawnFakeArms( localClientNum );
	self chopperUseAnimTree();
	self chopperGunnerOpenDoor( localClientNum, false );
	self setHelicopterEnvEffects( localClientNum );
	
	wait(0.1);
	self.cloudFX = PlayFXOnTag( localClientNum, level.fx_door_ambient, self, "tag_origin" );
}

#using_animtree ( "multiplayer" );

checkForPlayerSwitch( localClientNum )
{
	self endon( "entityshutdown" );
	
	level waittill( "demo_player_switch" );
	
	self chopperGunnerOpenDoor( localClientNum, self.chopperGunnerOpenDoorFlag );
	
	if ( isDefined( self.fakePlayer ) )
	{
		self.fakePlayer notify( "removed_early" );
		self.fakePlayer hide();
		self.fakePlayer delete();
		self.fakePlayer = undefined;
	}
	
	if ( isDefined( self.fakeArms ) )
	{
		self.fakeArms unlink();
		self.fakeArms Hide();
		self.fakeArms = undefined;
	}
	
	self thread checkForPlayerSwitch( localClientNum );
	self thread spawnFakePlayer( localClientNum );
}

spawnFakePlayer( localClientNum )
{
	self endon( "entityshutdown" );
	level endon( "demo_player_switch" );
	
	serverWait( localClientNum, 0.1 );
	
	for ( ;; )
	{		
		if ( !isDefined( self.fakePlayer ) && !IsInVehicle( localClientNum, self ) )
		{
			self.fakePlayer = spawn( localClientNum, self.origin, "script_model" );
			self.fakePlayer thread watchShutdownForFakePlayer( self );
			self linkFakePlayer();
		
			team = GetLocalPlayerTeam( localClientNum );
			
			if ( team == "allies" )
			{
				self.fakePlayer SetModel( level.chopper_gunner_player_model[level.allies_team] );
				self.fakePlayer Attach( level.chopper_gunner_player_head[level.allies_team], "" );
			}
			else
			{
				self.fakePlayer SetModel( level.chopper_gunner_player_model[level.axis_team] );
				self.fakePlayer Attach( level.chopper_gunner_player_head[level.allies_team], "" );
			}
				
			wait( 0.2 );	// wait needed before setting animtree on newly spawned model
			
			if ( !isDefined( self.fakePlayer ) )
				continue;
			
			result = self.fakePlayer UseAnimTree( #animtree );

			if( isDefined(result) && !result )
			{
				self.fakePlayer notify( "removed_early" );
				self.fakePlayer delete();
				break;
			}
			
			self thread updateFakePlayer();
		}
		else if ( isDefined( self.fakePlayer ) && IsInVehicle( localClientNum, self ) )
		{
			self.fakePlayer notify( "removed_early" );
			self.fakePlayer delete();
		}
		
		wait 0.01;
	}
}

watchShutdownForFakePlayer( heli )
{
	self endon( "removed_early" );
	level endon( "demo_player_switch" );
		
	heli waittill( "entityshutdown" );
	self hide();
	self delete();
}

linkFakePlayer()
{
	self.fakePlayer.angles = self GetTagAngles( "tag_gunner1" );
	forwardVec = AnglesToForward( self.fakePlayer.angles );
	rightVec = AnglesToRight( self.fakePlayer.angles );
	self.fakePlayer.origin = self GetTagOrigin( "tag_gunner1" );
	
	self.fakeplayer LinkTo( self, "tag_gunner1" );
}

//------------------------------------
// Alternate environmental effects values for helicopter:
//
setHelicopterEnvEffects( localClientNum )
{
	if ( isDefined( level.helicopter_fog ) && level.helicopter_fog || isDefined( level.fx_local_heli_rain ) )
	{
		self thread helicopterEnvEffectsUpdate( localClientNum );
		self thread helicopterEnvEffectsCleanup( localClientNum );
	}
}

helicopterEnvEffectsUpdate( localClientNum )
{
	self endon( "entityshutdown" );
	
	insideHeli = false;
	for ( ;; )
	{		
		if ( IsInHelicopter( localClientNum ) != insideHeli )
		{
			if ( insideHeli )
			{
				if ( isDefined( level.helicopter_fog ) && level.helicopter_fog )
				{
					println("Switch to SERVER fog");
					SwitchToServerVolumetricFog( localClientNum );
				}
				if ( isDefined( self.localRainFX ) )
				{
					println("Stop helicopter rain");
					stopfx( localClientNum, self.localRainFX );
					self.localRainFX = undefined;
				}
				insideHeli = false;
			}
			else
			{
				if ( isDefined( level.helicopter_fog ) && level.helicopter_fog )
				{
					println("Switch to CLIENT fog");
					SwitchToClientVolumetricFog( localClientNum );
				}
				if ( isDefined( level.fx_local_heli_rain ) && !isDefined( self.localRainFX ) )
				{
					println("Start helicopter rain");
					self.localRainFX = PlayFXOnTag( localClientNum, level.fx_local_heli_rain, self, "tag_origin" );
				}
				insideHeli = true;
			}
		}
		wait 0.01;
	}
}

helicopterEnvEffectsCleanup( localClientNum )
{
	self waittill( "entityshutdown" );

	if ( isDefined( level.helicopter_fog ) && level.helicopter_fog )
	{
		println("DONE: Switch to SERVER fog");
		SwitchToServerVolumetricFog( localClientNum );
	}
	if ( isDefined( level.localRainFX ) )
	{
		println("DONE: Stop helicopter rain");
		stopfx( localClientNum, self.localRainFX );
		self.localRainFX = undefined;
	}
}

playerHelicopterSwitch( localClientNum, set )
{
	if ( set )
	{
		setHelicopterEnvEffects( localClientNum );
	}
}

//
//------------------------------------

getBlend( angle )
{
	blend = angle / 60;
	if ( blend > 1 )
		blend = 1;
	if ( blend < -1 )
		blend = -1;
	
	return blend;
}


setFakePlayerVerticalAnims( blend, rightLeftBlend, verticalAnim, name )
{
	self SetAnim( verticalAnim, blend, 0, 1 );

	rightIndex = 0;
	centerIndex = 1;
	leftIndex = 2;

	rightAnim = self AnimGetChildAt( verticalAnim, rightIndex );
	centerAnim = self AnimGetChildAt( verticalAnim, centerIndex );
	leftAnim = self AnimGetChildAt( verticalAnim, leftIndex );

	fullBlend = 0;
	if ( rightLeftBlend < 0 )
	{
		fullBlend = rightLeftBlend * -1;

		self SetAnimLimited( rightAnim, fullBlend, 0, 1 );
		self SetAnimLimited( centerAnim, 1.0 - fullBlend, 0, 1 );
		self ClearAnim( leftAnim, 0 );
	}
	else
	{
		fullBlend = rightLeftBlend;
	
		self SetAnimLimited( centerAnim, 1.0 - fullBlend, 0, 1 );
		self SetAnimLimited( leftAnim, fullBlend, 0, 1 );
		self ClearAnim( rightAnim, 0 );
	}
//	PrintLn( name +" full " + fullBlend +  " blend " + blend + " rlblend " + rightLeftBlend);
}

setFakePlayerAnims( upDownBlend, rightLeftBlend )
{
	baseAnim = %fake_gunner_aim;
	
	//self ClearAnim( baseAnim, 0 );
	self SetAnim( baseAnim, 1, 0, 1 );
	
	upIndex = 0;
	levelIndex = 1;
	downIndex = 2;
	
	upAnim = self AnimGetChildAt( baseAnim, upIndex );
	levelAnim = self AnimGetChildAt( baseAnim, levelIndex );
	downAnim = self AnimGetChildAt( baseAnim, downIndex );

	if ( upDownBlend < 0 )
	{
		blend = upDownBlend * -1;
		
		setFakePlayerVerticalAnims( blend, rightLeftBlend, upAnim, "up" );
		setFakePlayerVerticalAnims( 1.0 - blend, rightLeftBlend, levelAnim, "level" );
		self ClearAnim( downAnim, 0 );
	}
	else
	{
		blend = upDownBlend;
		levelAnim = self AnimGetChildAt( baseAnim, levelIndex );
		
		setFakePlayerVerticalAnims( blend, rightLeftBlend, downAnim, "down" );
		setFakePlayerVerticalAnims( 1.0 - blend, rightLeftBlend, levelAnim, "level" );
		self ClearAnim( upAnim, 0 );
	}
}

updateFakePlayer()
{
	self endon( "entityshutdown" );
	self.fakePlayer endon( "entityshutdown" );
	level endon( "demo_player_switch" );
	
	upDownBlend = 0;
	rightLeftBlend = 0;
	for( ;; )
	{
		// Do animation and blending
		localAngles = self GetLocalGunnerAngles( 0 );
		upDownBlend = getBlend( localAngles[0] );
		rightLeftBlend = getBlend( localAngles[1] );
					
		self.fakePlayer setFakePlayerAnims( upDownBlend, rightLeftBlend );
		wait 0.01;
	}
}

#using_animtree ( "mp_vehicles" );

init_heli_anims()
{
	level.fake_arms_door_open = %int_huey_gunner_on;
	level.chopper_door_open = %v_huey_door_open;
	level.chopper_door_open_state = %v_huey_door_open_state;
	level.chopper_door_closed_state = %v_huey_door_close_state;
}

chopperUseAnimTree()
{
	self.animtree = self UseAnimTree( #animtree );
}

chopperGunnerInteriorLight( localClientNum, fxID, timeout )
{
	self notify("interior_light_play");
	self endon("interior_light_play");
	
	self waittill_dobj(localClientNum);

	if ( IsDefined( self.doorStateFX ) )
		stopfx( localClientNum, self.doorStateFX);
		
	self.doorStateFX = PlayFXOnTag( localClientNum, fxID, self, "tag_origin" );
	
	if ( !IsDefined(timeout) )
		return;
		
	wait( timeout );
	
	if ( IsDefined( self.doorStateFX ) )
		stopfx( localClientNum, self.doorStateFX);
}

chopperGunnerOpenDoor( localClientNum, set )
{
	self endon( "entityshutdown" );

	while( !(self HasAnimTree()) )
	{
		// wait for it to become valid
		self chopperUseAnimTree();
		wait(0.1);
	}
	
	// If we have already called the open door or when we switch between players,
	// we want to stop opening doors further till the next time we spawn a chopper.
	if ( isDefined( self.chopperGunnerOpenDoorFlag ) && self.chopperGunnerOpenDoorFlag == true )
		return;
		
	animTime = 0.2;
	
	if ( set )
	{	
		self.chopperGunnerOpenDoorFlag = true;
		self SetAnim( level.chopper_door_closed_state, 0, animTime, 1 );
		self SetAnim( level.chopper_door_open_state, 1, animTime, 1 );
		self thread chopperDoorOpenSound ();
	

		if ( IsDefined(self.fakeArms) )
		{
			self.fakeArms.origin = self GetTagOrigin( "tag_gunner_barrel2_anim" );
			self.fakeArms.angles = self GetTagAngles( "tag_gunner_barrel2_anim" );
			self.fakeArms LinkTo( self, "tag_gunner_barrel2_anim" );
			self.fakeArms SetAnim(level.fake_arms_door_open, 1, animTime, 1 );
			self.fakeArms show();
			
			self.fakeArms thread hideArmsWhenAnimDone();
		}
		chopperGunnerInteriorLight( localClientNum, level.fx_door_open, 2 );

	}
	else
	{	
		self.chopperGunnerOpenDoorFlag = false;
		// immediate close
		self SetAnim( level.chopper_door_open_state, 0, 0, 1 );
		self SetAnim( level.chopper_door_closed_state, 1, 0, 1 );

		chopperGunnerInteriorLight( localClientNum, level.fx_door_closed );
	}
}
chopperDoorOpenSound()
{
	self endon("entityshutdown");
	level endon( "demo_player_switch" );
	
	wait .7;
	self playsound (0, "veh_heli_door");
}
chopperCrashing( localClientNum, set )
{
	self endon( "entityshutdown" );
	PrintLn("chopperCrashing");
	if (!set)
		return;
		
	localPlayers = level.localPlayers;
	
	for(i = 0; i < localPlayers.size; i ++)
	{
		 self thread chopperCrashingFX(localPlayers[i]);
		 self thread chopperCrashingEarthquake(localClientNum, localPlayers[i]);
	}

	waitrealtime(4);
	
	self notify("stop_player_fx");
}

chopperCrashingFX( player )
{
	self endon( "entityshutdown" );
	self endon( "entityshutdown" );
}

chopperCrashingEarthquake( localClientNum, player )
{
	player endon( "entityshutdown" );
	self endon( "entityshutdown" );
	self endon( "stop_player_fx" );
	
	while ( 1 )
	{
		player Earthquake( randomFloatRange(0.5, 1.5), randomFloatRange(0.5, 2), self.origin, 1024 ); 
		self PlayRumbleOnEntity( localClientNum, "grenade_rumble" );
		wait( randomFloatRange(0.25, 1) );
	}
}

spawnFakeArms(localClientNum)
{
	self endon( "entityshutdown" );
	level endon( "demo_player_switch" );
	
	origin = self GetTagOrigin( "tag_gunner_barrel2_anim" );
	arms = Spawn(localClientNum, origin, "script_model");
	arms.angles = self GetTagAngles( "tag_gunner_barrel2_anim" );
	arms LinkTo( self, "tag_gunner_barrel2_anim" );
	arms Hide();
	
	team = GetLocalPlayerTeam( localClientNum );

	if ( team == "allies" )
	{
		arms SetModel( level.chopper_gunner_viewmodel[level.allies_team] );
	}
	else
	{
		arms SetModel( level.chopper_gunner_viewmodel[level.axis_team] );
	}

//	wait( 0.2 );	// wait needed before setting animtree on newly spawned model
//	
//	if ( !isDefined( self.fakePlayer ) )
//		return;
	
	arms UseAnimTree( #animtree );
	
	self.fakeArms = arms;
}

hideArmsWhenAnimDone()
{
	self endon("entityshutdown");
	level endon( "demo_player_switch" );
	
	waitTime = getanimlength(level.fake_arms_door_open);
	
	waitrealtime( waitTime );
	
	self unlink();
	self Hide();
	//self delete();
}
