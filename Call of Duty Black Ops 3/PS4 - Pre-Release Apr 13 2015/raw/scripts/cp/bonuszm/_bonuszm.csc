#using scripts\codescripts\struct;

#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\load_shared;
#using scripts\shared\music_shared;
#using scripts\shared\_oob;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\shared\weapons\_proximity_grenade;
#using scripts\shared\weapons\_riotshield;
#using scripts\shared\weapons\_satchel_charge;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_trophy_system;
#using scripts\shared\weapons\antipersonnelguidance;
#using scripts\shared\weapons\multilockapguidance;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\util_shared;


#precache( "client_fx", "zombie/fx_glow_eye_orange" );
#precache( "client_fx", "zombie/fx_glow_eye_blue" );
#precache( "client_fx", "zombie/fx_glow_eye_green" );
#precache( "client_fx", "zombie/fx_glow_eye_red" );
#precache( "client_fx", "zombie/fx_spawn_dirt_hand_burst_zmb" );
#precache( "client_fx", "zombie/fx_spawn_dirt_body_billowing_zmb" );
#precache( "client_fx", "zombie/fx_spawn_dirt_body_dustfalling_zmb" );
#precache( "client_fx", "zombie/fx_powerup_on_green_zmb");

#namespace bonuszm;


function autoexec __init__sytem__() {     system::register("bonuszm",&__init__,undefined,undefined);    }

function __init__()
{
	SetupStaticModelsForTheMode();
	
	if( !GetDvarint("ai_spawn_only_zombies") == 1 )
		return;

	bonuszm::register_clientfields();
	bonuszm::init_fx();
}

function SetupStaticModelsForTheMode()
{
	a_misc_models = FindStaticModelIndexArray( "zombie_misc_model" );
	
	if( GetDvarint("ai_spawn_only_zombies") == 1 )
	{	
		// No need to do anything.
	}
	else
	{
		foreach( a_misc_model in a_misc_models )
		{
			HideStaticModel( a_misc_model );
		}
	}
}

function register_clientfields()
{
	clientfield::register("actor", "zombie_riser_fx", 1, 1, "int", &handle_zombie_risers, true, true);
	clientfield::register("actor", "zombie_has_eyes", 1, 1, "int", &zombie_eyes_clientfield_cb, !true, true);
	clientfield::register("actor", "bonus_zombie_has_eyes", 1, 3, "int", &zombie_eyes_clientfield_cb2, !true, true);
	clientfield::register("actor", "zombie_gut_explosion", 1, 1, "int", &zombie_gut_explosion_cb, !true, true);
	clientfield::register("scriptmover", "powerup_on_fx", 1, 1, "int", &callback_powerup_on_fx, true, !true);
}

function init_fx()
{
	level._effect["eye_glow_o"]					= "zombie/fx_glow_eye_orange";	
	level._effect["eye_glow_b"]					= "zombie/fx_glow_eye_blue";	
	level._effect["eye_glow_g"]					= "zombie/fx_glow_eye_green";	
	level._effect["eye_glow_r"]					= "zombie/fx_glow_eye_red";	
	level._effect["rise_burst"]					= "zombie/fx_spawn_dirt_hand_burst_zmb";
	level._effect["rise_billow"]				= "zombie/fx_spawn_dirt_body_billowing_zmb";
	level._effect["rise_dust"]					= "zombie/fx_spawn_dirt_body_dustfalling_zmb";
	level._effect["powerup_on"] 				= "zombie/fx_powerup_on_green_zmb";
		
}


//--------------------------------------------------------------------------------------------------
//		ZOMBIE RISE FX
//--------------------------------------------------------------------------------------------------
function handle_zombie_risers(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level endon("demo_jump");
	self endon("entityshutdown");
	
	if ( !oldVal && newVal )
	{
		localPlayers = level.localPlayers;
		
		sound = "zmb_zombie_spawn";
		burst_fx = level._effect["rise_burst"];
		billow_fx = level._effect["rise_billow"];
		type = "dirt";
		
		if(isdefined(level.riser_type) && level.riser_type == "snow" )
		{
			sound = "zmb_zombie_spawn_snow";
			burst_fx = level._effect["rise_burst_snow"];
			billow_fx = level._effect["rise_billow_snow"];
			type = "snow";
		}		

  		playsound (0,sound, self.origin);
		
		for(i = 0; i < localPlayers.size; i ++)
		{
			self thread rise_dust_fx(i,type,billow_fx,burst_fx);
		}
	}

}

function rise_dust_fx( clientnum, type, billow_fx, burst_fx )
{
	dust_tag = "J_SpineUpper";
	
	self endon("entityshutdown");
	level endon("demo_jump");
	
	if ( IsDefined( burst_fx ) )
	{
		playfx(clientnum,burst_fx,self.origin + ( 0,0,randomintrange(5,10) ) );
	}
	
	wait(.25);
	
	if ( IsDefined( billow_fx ) )
	{
		playfx(clientnum,billow_fx,self.origin + ( randomintrange(-10,10),randomintrange(-10,10),randomintrange(5,10) ) );
	}
	
	wait(2);	//wait a bit to start playing the falling dust 
	dust_time = 5.5; // play dust fx for a max time
	dust_interval = .3; //randomfloatrange(.1,.25); // wait this time in between playing the effect
	
	player = level.localPlayers[clientnum];
	
	effect = level._effect["rise_dust"];
	
	if ( type == "snow")
	{
		effect = level._effect["rise_dust_snow"];
	}
	else if ( type == "none" )
	{
		return;
	}
		
	for (t = 0; t < dust_time; t += dust_interval)
	{
		PlayfxOnTag(clientnum,effect, self, dust_tag);
		wait dust_interval;
	}

}

function zombie_eyes_clientfield_cb2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)  // self = actor
{
	if(!IsDefined(newVal))
	{
		return;
	}
	
	//health value
	self.eyecol = newVal;
}

//--------------------------------------------------------------------------------------------------
//		ZOMBIE EYE GLOWS
//--------------------------------------------------------------------------------------------------
function zombie_eyes_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)  // self = actor
{
	if(!IsDefined(newVal))
	{
		return;
	}
	
	if(newVal)
	{
		self createZombieEyesInternal( localClientNum );
		self mapshaderconstant( localClientNum, 0, "scriptVector2", 0, get_eyeball_on_luminance(), self get_eyeball_color() );
	}
	else
	{
		self deleteZombieEyes(localClientNum);
		self mapshaderconstant( localClientNum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color() );
	}
	
	// optional callback for handling zombie eyes
	if ( IsDefined( level.zombie_eyes_clientfield_cb_additional ) )
	{
		self [[ level.zombie_eyes_clientfield_cb_additional ]]( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump );
	}	
}

function createZombieEyesInternal(localClientNum )
{
	self endon("entityshutdown");
	
	self util::waittill_dobj( localClientNum );	

	if ( !isdefined( self._eyeArray ) )
	{
		self._eyeArray = [];
	}

	if ( !isdefined( self._eyeArray[localClientNum] ) )
	{
		linkTag = "j_eyeball_le";
		
		if( !isdefined(self.eyecol) )
		{
			return;
		}

		if( self.eyecol==0 )
		{
			effect = level._effect["eye_glow_o"];
		}
		else if( self.eyecol==1 )
		{
			effect = level._effect["eye_glow_b"];
		}
		else if( self.eyecol==2 )
		{
			effect = level._effect["eye_glow_g"];
		}
		else if( self.eyecol==3 )
		{
			effect = level._effect["eye_glow_r"];
		}
		else
		{
			return;
		}

		// will handle level wide eye fx change
		if(IsDefined(level._override_eye_fx))
		{
			effect = level._override_eye_fx;
		}
		// will handle individual spawner or type eye fx change
		if(IsDefined(self._eyeglow_fx_override))
		{
			effect = self._eyeglow_fx_override;
		}

		if(IsDefined(self._eyeglow_tag_override))
		{
			linkTag = self._eyeglow_tag_override;
		}

		self._eyeArray[localClientNum] = PlayFxOnTag( localClientNum, effect, self, linkTag );
	}
}

function get_eyeball_on_luminance()
{
	if( IsDefined( level.eyeball_on_luminance_override ) )
	{
		return level.eyeball_on_luminance_override;
	}
	
	return 1;
}

function get_eyeball_off_luminance()
{
	if( IsDefined( level.eyeball_off_luminance_override ) )
	{
		return level.eyeball_off_luminance_override;
	}
	
	return 0;
}

function get_eyeball_color()  // self = zombie
{
	val = 0;
	
	if ( IsDefined( level.zombie_eyeball_color_override ) )
	{
		val = level.zombie_eyeball_color_override;
	}
	
	if ( IsDefined( self.zombie_eyeball_color_override ) )
	{
		val = self.zombie_eyeball_color_override;
	}
	
	return val;
}

function deleteZombieEyes(localClientNum)
{
	if ( isdefined( self._eyeArray ) )
	{
		if ( isdefined( self._eyeArray[localClientNum] ) )
		{
			DeleteFx( localClientNum, self._eyeArray[localClientNum], true );
			self._eyeArray[localClientNum] = undefined;
		}
	}
}

//--------------------------------------------------------------------------------------------------
//		POWER UP FX
//--------------------------------------------------------------------------------------------------
function callback_powerup_on_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!IsDefined(newVal))
	{
		return;
	}
	
	if(newVal)
	{
		self.pwr_fx = PlayFxOnTag( localClientNum, level._effect["powerup_on"], self, "tag_origin" );
	}
	else
	{
		if( isdefined( self.pwr_fx ) )
		{	
			DeleteFx( localClientNum, self.pwr_fx, false );
			self.pwr_fx = undefined;
		}
	}
}		
//--------------------------------------------------------------------------------------------------
//		ZOMBIE EXPLODES
//--------------------------------------------------------------------------------------------------
function zombie_gut_explosion_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		if(isdefined(level._effect["zombie_guts_explosion"]))
		{
			org = self GetTagOrigin("J_SpineLower");
			
			if(isdefined(org))
			{
				playfx( localClientNum, level._effect["zombie_guts_explosion"], org ); 	 
			}
		}
	}
}