#using scripts\codescripts\struct;

#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\footsteps_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_treadfx;
#using scripts\shared\vehicles\_driving_fx;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_filter;
#using scripts\zm\_sticky_grenade;
#using scripts\shared\util_shared;

#namespace callback;

function autoexec __init__sytem__() {     system::register("callback",&__init__,undefined,undefined);    }

// Callback set up, clientside.
	
function __init__()
{
	level thread set_default_callbacks();
}

function set_default_callbacks()
{
	level.callbackPlayerSpawned = &playerspawned;
	level.callbackLocalClientConnect = &localclientconnect;
	level.callbackEntitySpawned = &entityspawned;
	level.callbackHostMigration = &host_migration;
	level.callbackPlayAIFootstep = &footsteps::playaifootstep;
	level.callbackPlayLightLoopExploder = &exploder::playlightloopexploder;		

	level._custom_weapon_CB_Func = &callback::spawned_weapon_type;
}

function localclientconnect( localClientNum )
{
	/# println("*** Client script VM : Local client connect " + localClientNum); #/
	
	player = GetLocalPlayer( localClientNum );
	assert( isdefined( player ) );

	filter::init_filter_hud_outline( player ); // needed for theatermode
	filter::init_filter_zm_turned( player );
	
	player callback::callback( #"on_localclient_connect", localClientNum );

	if ( isdefined( level.onPlayerConnect ) )
	{
		level thread [[ level.onPlayerConnect ]]( localclientnum );
	}
	
	if ( isdefined( level._customPlayerConnectFuncs ) )
	{
		[[ level._customPlayerConnectFuncs ]]( player, localClientNum );
	}
	
	if ( isdefined( level.characterCustomizationSetup ) )
	{
		[[ level.characterCustomizationSetup ]]( localclientnum );
	}
}

function playerspawned(localClientNum)
{
	self endon( "entityshutdown" );
	
	if ( isdefined( level._playerspawned_override ) )
	{
		self thread [[level._playerspawned_override]]( localClientNum );
		return;
	}

/#	PrintLn( "Player spawned" );	#/
	callback::callback( #"on_player_spawned", localClientNum );
	
	// localClientChanged need to get updated players
	level.localPlayers = getLocalPlayers();

	if(isdefined(level._faceAnimCBFunc))
		self thread [[level._faceAnimCBFunc]](localClientNum);
}

function entityspawned(localClientNum)
{
	self endon( "entityshutdown" );

	if ( isdefined( level._entityspawned_override ) )
	{
		self thread [[level._entityspawned_override]]( localClientNum );
		return;
	}
	
	if ( !isdefined( self.type ) )
	{
	/#	println( "Entity type undefined!" );	#/
		return;
	}

	//PrintLn( "entity spawned: type = " + self.type + "\n" );
	if ( self.type == "missile"  )
	{		
		if( isdefined( level._custom_weapon_CB_Func ) )
		{
			self thread [[level._custom_weapon_CB_Func]]( localClientNum );
		}

		//PrintLn( "entity spawned: weapon = " + self.weapon.name + "\n" );
		switch( self.weapon.name )
		{
	/*	case "explosive_bolt":
			local_players_entity_thread( self, _explosive_bolt::spawned, true, true );
			break;
		case "explosive_bolt_upgraded":
			local_players_entity_thread( self, _explosive_bolt::spawned, true, false );
			break;
		case "crossbow_explosive":
			local_players_entity_thread( self, _explosive_bolt::spawned, false, true );
			break;
		case "crossbow_explosive_upgraded":
			local_players_entity_thread( self, _explosive_bolt::spawned, false, false );
			break;*/
		case "sticky_grenade":
			self thread _sticky_grenade::spawned( localClientNum );
			break;
		case "parasite_ooze_turret":
			self thread audio::rpgParasiteRocketWhizbyWatcher();
			break;
		}
	}	
	else if( self.type == "vehicle" || self.type == "helicopter" || self.type == "plane" )
	{	
		_treadfx::loadtreadfx(self); 
		
		if( isdefined(level._customVehicleCBFunc) )
		{
			self thread [[level._customVehicleCBFunc]](localClientNum);
		}
	
		self thread vehicle::field_toggle_exhaustfx_handler( localClientNum, undefined, false, true );
		self thread vehicle::field_toggle_lights_handler( localClientNum, undefined, false, true );
		
		if ( self.type == "plane" || self.type == "helicopter" )
		{
			self thread vehicle::aircraft_dustkick();
		}
		else //if ( level.usetreadfx == 1 )
		{
			self thread driving_fx::play_driving_fx(localClientNum);
			//self thread vehicle::vehicle_rumble(localClientNum);
		}
		
		if( self.type == "helicopter" )
		{
			//self thread helicopter::startfx_loop( localClientNum );
		}
	}
}

function host_migration( localClientNum )
{
	level thread prevent_round_switch_animation();
}

function prevent_round_switch_animation()
{
	AllowRoundAnimation(0);
	
	wait(3);
	
	AllowRoundAnimation(1);
}
