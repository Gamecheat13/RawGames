#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai\systems\fx_character;
#using scripts\shared\ai\systems\gib;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                             	   	

#precache( "client_fx", "explosions/fx_exp_robot_stage3_evb" );

function autoexec precache()
{
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
		1,
		"int",
		&RobotClientUtils::robotLightsHandler,
		!true,
		!true);
		
	ai::add_archetype_spawn_function( "robot", &RobotClientUtils::robotSoldierSpawnSetup );
}

#namespace RobotClientUtils;

function private robotSoldierSpawnSetup( localClientNum )
{
	entity = self;
}

function private robotLighting( localClientNum, entity, mindControlState )
{
	switch ( mindControlState )
	{
	case 0:
		// Currently disabled for campaign until after the 4/13/15 milestone.
		shouldEnableFXBundle = !SessionModeIsCampaignGame();
		
		if ( GetDvarInt( "ai_robotFxBundle" ) )
		{
			shouldEnableFXBundle = true;
		}
		
		if ( shouldEnableFXBundle )
		{
			FxClientUtils::PlayFxBundle( localClientNum, entity, entity.fxdef );
		}
		break;
	case 1:
		FxClientUtils::StopAllFXBundles( localClientNum, entity );
			
		FxClientUtils::PlayFxBundle( localClientNum, entity, entity.altfxdef1 );
	
		if ( !GibClientUtils::IsGibbed( localClientNum, entity, 4 ) )
		{
			entity PlaySound(localClientNum, "fly_bot_ctrl_lvl_01_start", entity.origin);
		}
		break;
	case 2:
		FxClientUtils::StopAllFXBundles( localClientNum, entity );
			
		FxClientUtils::PlayFxBundle( localClientNum, entity, entity.altfxdef2 );
	
		if ( !GibClientUtils::IsGibbed( localClientNum, entity, 4 ) )
		{
			entity PlaySound(localClientNum, "fly_bot_ctrl_lvl_02_start", entity.origin);
		}
		break;
	case 3:
		FxClientUtils::StopAllFXBundles( localClientNum, entity );
			
		FxClientUtils::PlayFxBundle( localClientNum, entity, entity.altfxdef3 );
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
	
	if ( newValue == 0 )
	{
		robotLighting( localClientNum, entity, clientfield::get( "robot_mind_control" ) );
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
	
	if ( clientfield::get( "robot_lights" ) == 0 )
	{
		robotLighting( localClientNum, entity, newValue );
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
