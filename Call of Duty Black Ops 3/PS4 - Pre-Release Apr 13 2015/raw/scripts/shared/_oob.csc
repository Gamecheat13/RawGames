#using scripts\shared\system_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\callbacks_shared;

                                            
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace oob;

function autoexec __init__sytem__() {     system::register("out_of_bounds",&__init__,undefined,undefined);    }		


	
function __init__()
{
	level.oob_timelimit_ms = GetDvarInt( "oob_timelimit_ms", 5000 );
	clientfield::register( "toplayer", "out_of_bounds", 1, 5, "int", &onOutOfBoundsChange,!true, true );
	
	callback::on_localclient_connect( &onPlayerConnect );
}

function onPlayerConnect()
{
	localPlayer = self;
	localClientNum = localPlayer.localclientnum;
	
	controllerModel = GetUIModelForController( localClientNum );
	oobModel = CreateUIModel( controllerModel, "hudItems.outOfBoundsEndTime" );
	SetUIModelValue( oobModel, 0 );
	
	filter::disable_filter_oob( localPlayer, 0 );
	localPlayer Randomfade( 0 );
}

function onOutOfBoundsChange( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	controllerModel = GetUIModelForController( localClientNum );
	oobModel = CreateUIModel( controllerModel, "hudItems.outOfBoundsEndTime" );
	
	localPlayer = GetLocalPlayer( localClientNum );
	
	if( !isdefined( localPlayer.oob_sound_ent ) )
	{
		localPlayer.oob_sound_ent = SpawnFakeEnt( localClientNum );
	}
	
	if( newVal > 0)
	{
		if( !isdefined( localPlayer.oob_effect_enabled ) )
		{
			filter::init_filter_oob( localPlayer );
			filter::enable_filter_oob( localPlayer, 0 );
			localPlayer.oob_effect_enabled = true;
			
			PlayLoopSound( localClientNum, localPlayer.oob_sound_ent, "uin_out_of_bounds_loop", 0.5 );//not sure why this sound was added
			SetUIModelValue( oobModel, getServerTime( 0 ) + level.oob_timelimit_ms );
		}
		
		newValf = newVal / 31.0;
		
		localPlayer Randomfade( newValf );
	}
	else
	{
		filter::disable_filter_oob( localPlayer, 0 );
		localPlayer Randomfade( 0 );
		
		StopLoopSound( localClientNum, localPlayer.oob_sound_ent, 0.5 );
		SetUIModelValue( oobModel, 0 );
		
		if( isdefined( localPlayer.oob_effect_enabled ) )
		{	
			localPlayer.oob_effect_enabled = false;
			localPlayer.oob_effect_enabled = undefined;
		}
	}
}

