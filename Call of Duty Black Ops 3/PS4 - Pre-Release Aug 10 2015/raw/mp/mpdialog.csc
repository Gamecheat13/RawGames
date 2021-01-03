    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace mpdialog;

function autoexec __init__sytem__() {     system::register("mpdialog",&__init__,undefined,undefined);    }

function __init__()
{	
	level.mpBoostResponse = [];
	level.mpBoostResponse[ "assassin" ] = "Spectre";
	level.mpBoostResponse[ "grenadier" ] = "Grenadier";
	level.mpBoostResponse[ "outrider" ] = "Outrider";
	level.mpBoostResponse[ "prophet" ] = "Technomancer";
	level.mpBoostResponse[ "pyro" ] = "Firebreak";
	level.mpBoostResponse[ "reaper" ] = "Reaper";
	level.mpBoostResponse[ "ruin" ] ="Mercenary";
	level.mpBoostResponse[ "seraph" ] = "Enforcer";
	level.mpBoostResponse[ "trapper" ] = "Trapper";

	level.clientVoiceSetup = &client_voice_setup;
	
	clientfield::register( "world", "boost_number", 1, 2, "int", &set_boost_number, true, true );
	clientfield::register( "allplayers", "play_boost", 1, 2, "int", &play_boost_vox, true, false );
}

function client_voice_setup( localClientNum )
{
	self thread sniperVoNotify( localClientNum, "playerbreathinsound", "exertSniperHold" );
	self thread sniperVoNotify( localClientNum, "playerbreathoutsound", "exertSniperExhale" );	
	self thread sniperVoNotify( localClientNum, "playerbreathgaspsound", "exertSniperGasp" );
}

function sniperVoNotify( localClientNum, notifyString, dialogKey )
{
	self endon("entityshutdown");
	for(;;)
	{	
		self waittill ( notifyString );
		
		if ( IsUnderwater( localClientNum ) )
		{
			return;
		}
		
		dialogAlias = self mpdialog::get_player_dialog_alias( dialogKey );

		if ( isdefined( dialogAlias ) )
		{
			self playsound (0, dialogAlias);
		}
	}
}

function set_boost_number( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	level.boostNumber = newVal;
}

function play_boost_vox( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	localPlayerTeam = GetLocalPlayerTeam( localClientNum );
	entityNumber = self GetEntityNumber();
	
	if ( newVal == 0 ||
	     self.team != localPlayerTeam ||
	     level._sndNextSnapshot != "mpl_prematch" ||
		 level.boostStartEntNum === entityNumber ||
		 level.boostResponseEntNum === entityNumber )
	{
		return;
	}
	     
	if ( newVal == 1 )
	{
		level.boostStartEntNum = entityNumber;
		
		self thread play_boost_start_vox( localClientNum );
	}
	else if ( newVal == 2 )
	{
		level.boostResponseEntNum = entityNumber;
			
		self thread play_boost_start_response_vox( localClientNum );
	}
}

function play_boost_start_vox( localClientNum )
{	
	self endon( "entityshutdown" );
	self endon( "death" );
	
	wait( 2 );

	playbackId = self play_dialog( "boostStart" + level.boostNumber, localClientNum );
	
	if ( isdefined( playbackId ) && playbackId >= 0 )
	{
		while ( SoundPlaying( playbackId ) )
		{
			wait ( 0.05 );
		}
	}
	
	wait ( 0.5 );	// Pause before response
	
	level.boostStartResponse = "boostStartResp" + level.mpBoostResponse[ self GetMpDialogName() ] + level.boostNumber;
	
	if ( isdefined( level.boostResponseEntNum ) )
	{
		responder = GetEntByNum( localClientNum, level.boostResponseEntNum );
		responder thread play_boost_start_response_vox( localClientNum );
	}
}

function play_boost_start_response_vox( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "death" );

	if ( !isdefined( level.boostStartResponse ) ||
	   	 self.team != GetLocalPlayerTeam( localClientNum ) )
	{
		return;
	}
	
	self play_dialog( level.boostStartResponse, localClientNum );
}

function get_commander_dialog_alias( commanderName, dialogKey )
{	
	if ( !isdefined( commanderName ) )
	{
		return;
	}
	
	commanderBundle = struct::get_script_bundle( "mpdialog_commander", commanderName );
	
	return get_dialog_bundle_alias( commanderBundle, dialogKey );
}

function get_player_dialog_alias( dialogKey )
{
	bundleName = self GetMpDialogName();
	
	if ( !isdefined( bundleName ) )
	{
		return undefined;
	}
	
	playerBundle = struct::get_script_bundle( "mpdialog_player", bundleName );
	
	return get_dialog_bundle_alias( playerBundle, dialogKey );
}


function get_dialog_bundle_alias( dialogBundle, dialogKey )
{
	if ( !isdefined( dialogBundle ) || !isdefined( dialogKey ) )
	{
		return undefined;
	}
	
	dialogAlias = GetStructField( dialogBundle, dialogKey );
	
	if ( !isdefined( dialogAlias ) )
	{
		return;
	}
	
	voicePrefix = GetStructField( dialogBundle, "voiceprefix" );
		
	if ( isdefined( voicePrefix ) )
	{
		dialogAlias = voicePrefix + dialogAlias;	
	}
	
	return dialogAlias;
}

function play_dialog( dialogKey, localClientNum )
{
	if ( !isdefined( dialogKey ) ||
	     !isdefined( localClientNum ) )
	{
		return -1;
	}
	
	dialogAlias = self get_player_dialog_alias( dialogKey );
	
	if ( !isdefined( dialogAlias ) )
	{
		return -1; // SND_PLAYBACKID_NOTPLAYED
	}
	
	// Standing camera height offset
	soundPos = ( self.origin[0], self.origin[1], self.origin[2] + 60 );

	if ( !IsSpectating( localClientNum ) )
	{
		return self PlaySound( undefined, dialogAlias, soundPos );
	}

	voiceBox = Spawn( localClientNum, self.origin, "script_model" );
	self thread update_voice_origin( voiceBox );
	voiceBox thread delete_after( 10 );
	return voiceBox PlaySound( undefined, dialogAlias, soundPos );
}

function update_voice_origin( voiceBox )
{
	while(1)
	{
		wait( 0.1 );
		
		if ( !isdefined( self ) || !isdefined( voiceBox ) )
		{
			return;
		}
		
		voiceBox.origin = self.origin;
	}
}

function delete_after( waitTime )
{
	wait( waitTime );
	
	self Delete();
}