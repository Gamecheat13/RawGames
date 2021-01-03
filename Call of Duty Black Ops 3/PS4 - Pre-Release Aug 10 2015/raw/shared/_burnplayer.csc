#using scripts\codescripts\struct;

#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\callbacks_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace burnplayer;

function autoexec __init__sytem__() {     system::register("burnplayer",&__init__,undefined,undefined);    }

// human burning effects
#precache( "client_fx", "fire/fx_fire_ai_human_arm_left_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_arm_left_os" );
#precache( "client_fx", "fire/fx_fire_ai_human_arm_right_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_arm_right_os" );
#precache( "client_fx", "fire/fx_fire_ai_human_hip_left_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_hip_left_os" );
#precache( "client_fx", "fire/fx_fire_ai_human_hip_right_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_hip_right_os" );
#precache( "client_fx", "fire/fx_fire_ai_human_leg_left_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_leg_left_os" );
#precache( "client_fx", "fire/fx_fire_ai_human_leg_right_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_leg_right_os" );
#precache( "client_fx", "fire/fx_fire_ai_human_torso_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_torso_os" );
#precache( "client_fx", "fire/fx_fire_ai_human_head_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_head_os" );
	
	
function __init__()
{
	clientfield::register( "allplayers", "burn", 1, 1, "int", &burning_callback, !true, !true );
	LoadEffects();
	level.activeFX = [];
	callback::on_spawned( &on_player_spawned );
}

function LoadEffects()
{
	//fire fx
	level._effect["burn_j_elbow_le_loop"]		= "fire/fx_fire_ai_human_arm_left_loop";	// hand and forearm fires
	level._effect["burn_j_elbow_ri_loop"]		= "fire/fx_fire_ai_human_arm_right_loop";
	level._effect["burn_j_shoulder_le_loop"]	= "fire/fx_fire_ai_human_arm_left_loop";	// upper arm fires
	level._effect["burn_j_shoulder_ri_loop"]	= "fire/fx_fire_ai_human_arm_right_loop";
	level._effect["burn_j_spine4_loop"]			= "fire/fx_fire_ai_human_torso_loop";		// upper torso fires
	level._effect["burn_j_hip_le_loop"]			= "fire/fx_fire_ai_human_hip_left_loop";	// thigh fires
	level._effect["burn_j_hip_ri_loop"]			= "fire/fx_fire_ai_human_hip_right_loop";
	level._effect["burn_j_knee_le_loop"]		= "fire/fx_fire_ai_human_leg_left_loop";	// shin fires
	level._effect["burn_j_knee_ri_loop"]		= "fire/fx_fire_ai_human_leg_right_loop";
	level._effect["burn_j_head_loop"] 			= "fire/fx_fire_ai_human_head_loop";		// head fire

	level._effect["burn_j_elbow_le_os"]			= "fire/fx_fire_ai_human_arm_left_os";		// hand and forearm fires
	level._effect["burn_j_elbow_ri_os"]			= "fire/fx_fire_ai_human_arm_right_os";
	level._effect["burn_j_shoulder_le_os"]		= "fire/fx_fire_ai_human_arm_left_os";		// upper arm fires
	level._effect["burn_j_shoulder_ri_os"]		= "fire/fx_fire_ai_human_arm_right_os";
	level._effect["burn_j_spine4_os"]			= "fire/fx_fire_ai_human_torso_os";			// upper torso fires
	level._effect["burn_j_hip_le_os"]			= "fire/fx_fire_ai_human_hip_left_os";		// thigh fire
	level._effect["burn_j_hip_ri_os"]			= "fire/fx_fire_ai_human_hip_right_os";
	level._effect["burn_j_knee_le_os"]			= "fire/fx_fire_ai_human_leg_left_os";		// shin fires
	level._effect["burn_j_knee_ri_os"]			= "fire/fx_fire_ai_human_leg_right_os";
	level._effect["burn_j_head_os"] 			= "fire/fx_fire_ai_human_head_os";			// head fire
}

function burning_callback( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self update_burn( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump );
}

function on_player_spawned( local_client_num )
{
	self endon( "entityshutdown" );
	
	if ( self islocalplayer() )
	{
		self notify( "stop_burn_on_thread" );
		self burn_clear( local_client_num );
	}
}

function burn_clear( local_client_num )
{
	self _burnTagsClear( local_client_num );
}

function burn_off( local_client_num )
{
	self notify( "burn_off" );
	self _burnTagsOff( local_client_num );
	if( GetLocalPlayer( local_client_num ) == self )
	{
		self thread postfx::PlayPostfxBundle( "pstfx_burn_fade_out" );
	}
}

function burn_on_postfx()
{
	self endon( "entityshutdown" );
	self endon( "burn_off" );
	self endon( "death" );
	self notify( "burn_on_postfx" );
	self endon( "burn_on_postfx" );
	
	self thread postfx::PlayPostfxBundle( "pstfx_burn_fade_in" );
	wait( .05 );
	self thread postfx::PlayPostfxBundle( "pstfx_burn_loop" );
}

function burn_on( local_client_num )
{
	if( GetLocalPlayer( local_client_num ) != self )
	{
		self thread _burnBody( local_client_num );
	}
	
	if( GetLocalPlayer( local_client_num ) == self )
	{
		self thread burn_on_postfx();
	}
}

function update_burn( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal != 1 )
	{
		self burn_off( local_client_num );
	}
	else
	{
		self burn_on( local_client_num );
	}
}

function private _burnTag( localClientNum, tag, postfix )
{
	if( isDefined( self ) && self hasdobj( localclientnum ) )
	{
		fxname = "burn_" + tag + postfix;
		if( isDefined( level._effect[fxname] ) )
		{
			return PlayFXOnTag( localClientNum, level._effect[fxname], self, tag );
		}
	}
}

function private _burnTagsOn( localClientNum, tags )
{
	if( !isDefined( self ) )
		return;
		
	self endon( "entityshutdown" );
	self endon( "burn_off" );
	self notify( "burn_tags_on" );
	self endon( "burn_tags_on" );
	
	level.activeFX[localclientnum] = [];
	
	while( 1 )
	{
		for( i = 0; i < tags.size; i++ )
		{
			level.activeFX[localclientnum][level.activeFX[localclientnum].size] = self _burnTag( localClientNum, tags[i], "_loop" );
		}
		wait ( 1 );//RandomFloatRange( 1.0, 2.0 ); //restart the effect with some variance
	}
}

function private _burnTagsOff( localClientNum )
{
	if( isDefined( level.activeFX[localclientnum] ) )
	{
		foreach( fx in level.activeFX[localclientnum] )
		{
			StopFx( localClientNum, fx );
		}
		if( isDefined( level.activeFX ) )
		{
			level.activeFX[localclientnum] = [];
		}
	}	
}

function private _burnTagsClear( localClientNum )
{
	if( isDefined( level.activeFX[localclientnum] ) )
	{
		foreach( fx in level.activeFX[localclientnum] )
		{
			KillFx( localClientNum, fx );
		}
		if( isDefined( level.activeFX ) )
		{
			level.activeFX[localclientnum] = [];
		}
	}	
}

function private _burnBody(localClientNum)
{
	self endon("entityshutdown");
	
	burnTags = array("j_elbow_le", "j_elbow_ri", "j_shoulder_le", "j_shoulder_ri", "j_spine4", "j_spinelower", "j_hip_le", "j_hip_ri", "j_head", "j_knee_le", "j_knee_ri" );
	
	self thread _burnTagsOn( localClientNum, burnTags );
}
