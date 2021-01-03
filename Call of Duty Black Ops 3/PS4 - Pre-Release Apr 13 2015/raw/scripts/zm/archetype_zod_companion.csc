#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\system_shared;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                                                                                                                                                                                                                                                  	   	   	                                                                                                                                                                                             	          
                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                            	   	
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "client_fx", "destruct/fx_dest_robot_head_sparks" );
#precache( "client_fx", "destruct/fx_dest_robot_body_sparks" );
#precache( "client_fx","zombie/fx_robot_helper_revive_player_zod_zmb" );

#namespace ZodCompanionClientUtils;

function autoexec __init__sytem__() {     system::register("zm_zod_companion",&__init__,undefined,undefined);    }


function __init__()
{	
	clientfield::register( "allplayers", "being_robot_revived", 1, 1, "int", &ZodCompanionClientUtils::play_revival_fx, !true, !true );
	ai::add_archetype_spawn_function( "zod_companion", &ZodCompanionClientUtils::zodCompanionSpawnSetup );
	
	level._effect[ "fx_dest_robot_head_sparks" ] = "destruct/fx_dest_robot_head_sparks";
	level._effect[ "fx_dest_robot_body_sparks" ] = "destruct/fx_dest_robot_body_sparks";
	level._effect[ "companion_revive_effect" ] = "zombie/fx_robot_helper_revive_player_zod_zmb";
}



function private zodCompanionSpawnSetup( localClientNum )
{
	entity = self;

	GibClientUtils::AddGibCallback( localClientNum, entity, 4, &zodCompanionHeadGibFx );
	
	GibClientUtils::AddGibCallback( localClientNum, entity, 4, &_gibCallback );
	GibClientUtils::AddGibCallback( localClientNum, entity, 8, &_gibCallback );
	GibClientUtils::AddGibCallback( localClientNum, entity, 16, &_gibCallback );
	GibClientUtils::AddGibCallback( localClientNum, entity, 64, &_gibCallback );
	GibClientUtils::AddGibCallback( localClientNum, entity, 128, &_gibCallback );

}


function zodCompanionHeadGibFx( localClientNum, entity, gibFlag )
{
	if ( !IsDefined( entity ) || !entity IsAI() || !IsAlive( entity ) )
	{
		return;
	}
	
	if ( IsDefined( entity.mindControlHeadFx ) )
	{
		StopFx( localClientNum, entity.mindControlHeadFx );
		entity.mindControlHeadFx = undefined;
	}
	
	entity.headGibFx =
		PlayFxOnTag(
			localClientNum,
			level._effect[ "fx_dest_robot_head_sparks" ],
			entity,
			"j_neck" );
	playsound(0, "prj_bullet_impact_robot_headshot", entity.origin);
}

function zodCompanionDamagedFx( localClientNum, entity )
{
	if ( !IsDefined( entity ) || !entity IsAI() || !IsAlive( entity ) )
	{
		return;
	}
	
	entity.DamagedFx =
		PlayFxOnTag(
			localClientNum,
			level._effect[ "fx_dest_robot_body_sparks" ],
			entity,
			"j_spine4" );
}

function zodCompanionClearFx( localClientNum, entity )
{
	if ( !IsDefined( entity ) || !entity IsAI() )
	{
		return;
	}
}

function private _gibCallback( localClientNum, entity, gibFlag )
{
	if ( !IsDefined( entity ) || !entity IsAI() )
	{
		return;
	}

	switch (gibFlag)
	{
	case 4:
		break;
	case 8:
		//playsound( localClientNum, "evt_robot_gib_arm", entity.origin);//gdt gib_def handling this now
		break;
	case 16:
		//playsound( localClientNum, "evt_robot_gib_arm", entity.origin);//gdt gib_def handling this now
		break;
	case 64:
		break;
	case 128:
		break;
	}
}

function play_revival_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( isDefined( self.robot_revival_fx) && oldval == 1 && newval == 0 )
	{
		StopFX( localClientNum, self.robot_revival_fx );
	}
	
	if( newval === 1)
	{
		self.robot_revival_fx =	PlayFXOnTag( localClientNum, level._effect[ "companion_revive_effect" ], self, "j_spineupper" );
	}
	
}
