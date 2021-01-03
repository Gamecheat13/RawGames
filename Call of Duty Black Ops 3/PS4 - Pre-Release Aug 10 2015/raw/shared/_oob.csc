#using scripts\shared\system_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\callbacks_shared;

                                             
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace oob;

function autoexec __init__sytem__() {     system::register("out_of_bounds",&__init__,undefined,undefined);    }		

	//Change the value in the _oob.gsc file to match this one
 //Change the value in the _oob.gsc file to match this one
	
function __init__()
{
	if(SessionModeIsMultiplayerGame())
	{
		level.oob_timelimit_ms = GetDvarInt( "oob_timelimit_ms", 3000 );
	}
	else
	{
		level.oob_timelimit_ms = GetDvarInt( "oob_timelimit_ms", 6000 );
	}
	
	clientfield::register( "toplayer", "out_of_bounds", 1, 5, "int", &onOutOfBoundsChange,!true, true );
	
	callback::on_localclient_connect( &on_localplayer_connect );
	callback::on_spawned( &on_player_spawned );
	callback::on_localclient_shutdown( &on_localplayer_shutdown );
}

function on_localplayer_connect( localClientNum )
{
	oobModel = GetOObUIModel( localClientNum );
	SetUIModelValue( oobModel, 0 );
}

function on_player_spawned( localClientNum )
{
	player = getlocalplayer( localClientNum );
	if ( player GetEntityNumber() == self GetEntityNumber() )
	{
		filter::disable_filter_oob( self, 0 );
		self Randomfade( 0 );
	}
}

function on_localplayer_shutdown( localClientNum )
{
	localPlayer = self;
	if ( isdefined( localPlayer ) )
	{
		StopOutOfBoundsEffects( localClientNum, localPlayer );
	}
}

function onOutOfBoundsChange( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	
	localPlayer = GetLocalPlayer( localClientNum );
	
	if(!isdefined(level.oob_sound_ent))
	{
		level.oob_sound_ent = [];
	}
	
	if( !isdefined( level.oob_sound_ent[localClientNum] ) )
	{
		level.oob_sound_ent[localClientNum] = Spawn( localClientNum, (0,0,0), "script_origin" );
	}
	
	if( newVal > 0)
	{
		if( !isdefined( localPlayer.oob_effect_enabled ) )
		{
			filter::init_filter_oob( localPlayer );
			filter::enable_filter_oob( localPlayer, 0 );
			localPlayer.oob_effect_enabled = true;
			
			level.oob_sound_ent[localClientNum] PlayLoopSound( "uin_out_of_bounds_loop", 0.5 );//not sure why this sound was added
		
			oobModel = GetOObUIModel( localClientNum );
			SetUIModelValue( oobModel, getServerTime( 0 ) + level.oob_timelimit_ms );
		}
		
		newValf = newVal / 31.0;
		
		localPlayer Randomfade( newValf );
	}
	else
	{
		StopOutOfBoundsEffects( localClientNum, localPlayer );
	}
}

function StopOutOfBoundsEffects( localClientNum, localPlayer )
{
	filter::disable_filter_oob( localPlayer, 0 );
	localPlayer Randomfade( 0 );
	
	if( isDefined(level.oob_sound_ent) && isdefined( level.oob_sound_ent[localClientNum] ) )
	{
		level.oob_sound_ent[localClientNum] StopAllLoopSounds( 0.5 );
	}

	oobModel = GetOObUIModel( localClientNum );
	SetUIModelValue( oobModel, 0 );
	
	if( isdefined( localPlayer.oob_effect_enabled ) )
	{	
		localPlayer.oob_effect_enabled = false;
		localPlayer.oob_effect_enabled = undefined;
	}
}

function GetOObUIModel( localClientNum )
{
	controllerModel = GetUIModelForController( localClientNum );
	return CreateUIModel( controllerModel, "hudItems.outOfBoundsEndTime" );
}