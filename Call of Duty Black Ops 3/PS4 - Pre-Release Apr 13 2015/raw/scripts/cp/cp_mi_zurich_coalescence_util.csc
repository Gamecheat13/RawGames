#using scripts\codescripts\struct;

#using scripts\cp\_load;

#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       




#precache( "client_fx", "explosions/fx_exp_torso_blood_infection" );
#precache( "client_fx", "zombie/fx_dog_lightning_buildup_zmb" );

#namespace zurich_util;
//--------------------------------------------------------------------------------------------------
//	ZURICH UTIL
//--------------------------------------------------------------------------------------------------
function autoexec __init__sytem__() {     system::register("zurich_util",&__init__,undefined,undefined);    }

function __init__()
{
	init_clientfields();
	
	init_effects();
}

function init_clientfields()
{
	// clientfield setup
	clientfield::register( "actor", 		"exploding_ai_deaths", 			1, 1, 				"int", &callback_exploding_death_fx, 		!true, !true );
	clientfield::register( "actor", 		"ai_spawn_fx",   			1, 1, 				"int", &callback_spawn_fx, 			!true, !true );
}

function init_effects()
{
	level._effect["exploding_death"]	= "explosions/fx_exp_torso_blood_infection";
	level._effect[ "ai_spawn_fx" ]	= "zombie/fx_dog_lightning_buildup_zmb";
}


//--------------------------------------------------------------------------------------------------
//	SURREAL DEATH FX
//--------------------------------------------------------------------------------------------------
function callback_exploding_death_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = actor
{
	if ( newVal == 1 )
	{
		pos = self gettagorigin( "j_spine4" );
		angles = self gettagangles("j_spine4");
		
		fxObj = util::spawn_model(localClientNum, "tag_origin", pos, angles);
			
		fxObj.sfx_id = PlayFXOnTag(localClientNum, level._effect[ "exploding_death" ], fxObj, "tag_origin" );
		fxObj playsound( 0, "evt_ai_explode" );
		
		waitrealtime( 6 );
		fxobj delete();		
	}
}

//--------------------------------------------------------------------------------------------------
//	SURREAL SPAWN FX
//--------------------------------------------------------------------------------------------------
function callback_spawn_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = actor
{
	if ( newVal == 1 )
	{	
		self.sfx_id = PlayFXOnTag(localClientNum, level._effect[ "ai_spawn_fx" ], self, "tag_origin" );
	
		waitrealtime( 6 );
			
		if( isdefined( self ) )
		{	
			DeleteFx( localClientNum, self.sfx_id, false );
			self.sfx_id = undefined;
		}
	}	
}