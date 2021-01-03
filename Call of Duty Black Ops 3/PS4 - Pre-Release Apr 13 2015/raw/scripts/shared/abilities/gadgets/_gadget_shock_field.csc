#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

                                                                           
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\system_shared;

function autoexec __init__sytem__() {     system::register("gadget_shock_field",&__init__,undefined,undefined);    }



	
#precache( "client_fx", "player/fx_plyr_shock_field_1p" );
#precache( "client_fx", "player/fx_plyr_shock_field" );
	
function __init__()
{
	clientfield::register( "allplayers", "shock_field", 1, 1, "int", &player_shock_changed, !true, true );
	callback::on_spawned( &on_player_spawned );
	level.shock_field_fx = [];
}

function on_player_spawned( local_client_num )
{

}

function is_local_player( localClientNum )
{	
	player_view = getlocalplayer( localClientNum );	

	if (!IsDefined(player_view))
		return false;
	
	sameEntity = ( self == player_view );

	return sameEntity;
}

/*
function is_killcam( localClientNum )
{	
	player_view = getlocalplayer( localClientNum );
	player_client = getnonpredictedlocalplayer( localClientNum ); 
	killcam = ( !IS_EQUAL(player_view,player_client) );
	return killcam;
}

function player_info_string( player, desc )
{
	str = "Player '"+desc+"' is ";
	if (!IsDefined(player))
	{
		str = str + "<undefined>";
	}
	else if ( player isplayer() )
	{
		name = "<unnamed>";
		if (isDefined(player.name))
			name = player.name;
		str = str + name +"["+player GetEntityNumber()+"]";
	}
	else
	{
		str = "Entity '"+desc+"' is ";
		str = str + "entity["+player GetEntityNumber()+"]";
	}
	return str;
}
*/


function player_shock_changed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{		
	entid = getlocalplayer( localClientNum )  GetEntityNumber(); 	
	
	if ( newVal )
	{
		if ( !IsDefined( level.shock_field_fx[entid] ) )
		{
			fx = "player/fx_plyr_shock_field";
			if ( is_local_player( localClientNum ) )
			{
				fx = "player/fx_plyr_shock_field_1p";
			}
			tag = "j_spinelower";
			
			level.shock_field_fx[entid] = PlayFXOnTag( localClientNum, fx, self, tag );
		}
	}
	else
	{
		if ( IsDefined(level.shock_field_fx[entid]) )
		{
			stopfx(localClientNum, level.shock_field_fx[entid]);
			level.shock_field_fx[entid] = undefined;
		}
	}
}
