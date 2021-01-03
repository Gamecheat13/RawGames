#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\util_shared;
#using scripts\shared\ai\systems\fx_character;
#using scripts\shared\ai\systems\gib;

                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                       	     	                                                                                   
                                                                                                             	     	                                                                                                                                                                

#precache( "client_fx", "electric/fx_ability_elec_surge_short_robot" );
#precache( "client_fx", "explosions/fx_exp_robot_stage3_evb" );

function autoexec precache()
{
	level._effect[ "fx_ability_elec_surge_short_robot" ] = "electric/fx_ability_elec_surge_short_robot";
	level._effect[ "fx_exp_robot_stage3_evb" ] = "explosions/fx_exp_robot_stage3_evb";
}

function autoexec main()
{
	clientfield::register(
		"actor",
		"robot_mind_control",
		1,
		2,
		"int",
		&RobotClientUtils::robotMindControlHandler,
		!true,
		true);
		
	clientfield::register(
		"actor",
		"robot_mind_control_explosion",
		1,
		1,
		"int",
		&RobotClientUtils::robotMindControlExplosionHandler,
		!true,
		!true);
		
	clientfield::register(
		"actor",
		"robot_lights",
		1,
		3,
		"int",
		&RobotClientUtils::robotLightsHandler,
		!true,
		!true);
		
	clientfield::register(
		"actor",
		"robot_EMP",
		1,
		1,
		"int",
		&RobotClientUtils::robotEmpHandler,
		!true,
		!true);
		
	ai::add_archetype_spawn_function( "robot", &RobotClientUtils::robotSoldierSpawnSetup );
}

#namespace RobotClientUtils;

function private robotSoldierSpawnSetup( localClientNum )
{
	entity = self;
}

function private robotLighting( localClientNum, entity, flicker, mindControlState )
{
	switch ( mindControlState )
	{
	case 0:
		entity TmodeClearFlag( 0 );
		
		if ( flicker )
		{
			FxClientUtils::PlayFxBundle( localClientNum, entity, entity.altfxdef3 );
		}
		else
		{
			FxClientUtils::PlayFxBundle( localClientNum, entity, entity.fxdef );
		}
		break;
	case 1:
		entity TmodeClearFlag( 0 );
	
		FxClientUtils::StopAllFXBundles( localClientNum, entity );
		
		if ( flicker )
		{
			FxClientUtils::PlayFxBundle( localClientNum, entity, entity.altfxdef4 );
		}
		else
		{
			FxClientUtils::PlayFxBundle( localClientNum, entity, entity.altfxdef1 );
		}
	
		if ( !GibClientUtils::IsGibbed( localClientNum, entity, 8 ) )
		{
			entity PlaySound(localClientNum, "fly_bot_ctrl_lvl_01_start", entity.origin);
		}
		break;
	case 2:
		entity TmodeSetFlag( 0 );
	
		FxClientUtils::StopAllFXBundles( localClientNum, entity );
		
		if ( flicker )
		{
			FxClientUtils::PlayFxBundle( localClientNum, entity, entity.altfxdef4 );
		}
		else
		{
			FxClientUtils::PlayFxBundle( localClientNum, entity, entity.altfxdef1 );
		}
	
		if ( !GibClientUtils::IsGibbed( localClientNum, entity, 8 ) )
		{
			entity PlaySound(localClientNum, "fly_bot_ctrl_lvl_02_start", entity.origin);
		}
		break;
	case 3:
		entity TmodeSetFlag( 0 );
	
		FxClientUtils::StopAllFXBundles( localClientNum, entity );
		
		if ( flicker )
		{
			FxClientUtils::PlayFxBundle( localClientNum, entity, entity.altfxdef5 );
		}
		else
		{
			FxClientUtils::PlayFxBundle( localClientNum, entity, entity.altfxdef2 );
		}
		
		entity PlaySound(localClientNum, "fly_bot_ctrl_lvl_03_start", entity.origin);
		
		break;
	}
}

function private robotLightsHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	entity = self;
	
	if ( !IsDefined( entity ) ||
		!entity IsAI() ||
		( IsDefined( entity.archetype ) && entity.archetype != "robot" ) )
	{
		return;
	}
	
	FxClientUtils::StopAllFXBundles( localClientNum, entity );
	
	flicker = newValue == 1;
	
	if ( newValue == 0 || newValue == 3 || flicker )
	{
		robotLighting( localClientNum, entity, flicker, clientfield::get( "robot_mind_control" ) );
	}
	else if ( newValue == 4 )
	{
		FxClientUtils::PlayFxBundle( localClientNum, entity, entity.deathfxdef );
	}
}

function private robotEmpHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	entity = self;
	
	if ( !IsDefined( entity ) ||
		!entity IsAI() ||
		( IsDefined( entity.archetype ) && entity.archetype != "robot" ) )
	{
		return;
	}
	
	if ( IsDefined( entity.empFX ) )
	{
		StopFx( localClientNum, entity.empFX );
	}
	
	switch ( newValue )
	{
	case 0:
		break;
	case 1:
		entity.empFX = PlayFxOnTag(
			localClientNum,
			level._effect[ "fx_ability_elec_surge_short_robot" ],
			entity,
			"j_spine4" );
		break;
	}
}

function private robotMindControlHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	entity = self;
	
	if ( !IsDefined( entity ) ||
		!entity IsAI() ||
		( IsDefined( entity.archetype ) && entity.archetype != "robot" ) )
	{
		return;
	}
	
	lights = clientfield::get( "robot_lights" );
	flicker = lights == 1;
	
	if ( lights == 0 || flicker )
	{
		robotLighting( localClientNum, entity, flicker, newValue );
	}
}

function robotMindControlExplosionHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	entity = self;
	
	if ( !IsDefined( entity ) ||
		!entity IsAI() ||
		( IsDefined( entity.archetype ) && entity.archetype != "robot" ) )
	{
		return;
	}
	
	switch ( newValue )
	{
	case 1:
		entity.explosionFx =
			PlayFxOnTag(
				localClientNum,
				level._effect[ "fx_exp_robot_stage3_evb" ],
				entity,
				"j_spineupper" );
		break;
	}
}
