#using scripts\shared\system_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\util_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace audio;

function autoexec __init__sytem__() {     system::register("audio",&__init__,undefined,undefined);    }

function __init__()
{	
	callback::on_spawned( &sndResetSoundSettings);
	callback::on_spawned(&missileLockWatcher);
	callback::on_spawned(&missileFireWatcher);
	callback::on_player_killed( &on_player_killed);
	callback::on_vehicle_spawned( &vehicleSpawnContext );
	level thread register_clientfields();
}

function register_clientfields()
{
	clientfield::register( "world", "sndPrematch", 1, 1, "int" );
	clientfield::register( "world", "sndFoleyContext", 1, 1, "int" );
	clientfield::register( "scriptmover", "sndRattle", 1, 1, "int" );
	clientfield::register( "toplayer", "sndMelee", 1, 1, "int" );
	clientfield::register( "vehicle", "sndSwitchVehicleContext", 1, 3, "int" );
}

function sndResetSoundSettings()
{
	self clientfield::set_to_player( "sndMelee", 0 );
	self util::clientnotify( "sndDEDe" );
	level thread sndPlaySpecialZombiesMusic();
}
function on_player_killed()
{
	if( !( isdefined( self.killcam ) && self.killcam ) )
	{
		self util::clientnotify( "sndDED" );
	}
}
function vehicleSpawnContext()
{
	self clientfield::set( "sndSwitchVehicleContext", 1 );
}
function sndUpdateVehicleContext(added)
{
	if( !isdefined( self.sndOccupants ) )
	{
		self.sndOccupants = 0;
	}
	
	if( added )
	{
		self.sndOccupants++;
	}
	else
	{
		self.sndOccupants--;
		if( self.sndOccupants < 0 )
		{
			self.sndOccupants = 0;
		}
	}
		
	self clientfield::set( "sndSwitchVehicleContext", (self.sndOccupants+1) );
}

function PlayTargetMissileSound( alias, looping )
{
	self notify( "stop_target_missile_sound");
	self endon( "stop_target_missile_sound" );
	self endon( "disconnect" );
	self endon( "death" );
	
	if (IsDefined(alias))
	{
		time = SoundGetPlaybackTime(alias)*0.001;
		if (time>0)
		{
			do 
			{
				self playLocalSound( alias );
				wait(time);
			}
			while (looping);
		}
	}
}

function missileLockWatcher()
{	
	self endon("death");
	self endon("disconnect");

	if (!self flag::exists("playing_stinger_fired_at_me"))
	{
		self flag::init("playing_stinger_fired_at_me",false);
	}
	else
	{
		self flag::clear("playing_stinger_fired_at_me");
	}
	//plays lock on warning sounds for a player
	while (1)
	{
		self waittill("missile_lock", attacker, weapon);
		if (!flag::get("playing_stinger_fired_at_me"))
		{
			self thread PlayTargetMissileSound( weapon.lockonTargetLockedSound, weapon.lockonTargetLockedSoundLoops );
			self util::waittill_any("stinger_fired_at_me","missile_unlocked","death");
			self notify( "stop_target_missile_sound");
		}
	}
}

function missileFireWatcher()
{
	self endon("death");
	self endon("disconnect");
	
	//plays missile fired sounds for a player
	while (1)
	{
		self waittill("stinger_fired_at_me",missile, weapon ,attacker);
		waittillframeend;
		self flag::set("playing_stinger_fired_at_me");
		self thread PlayTargetMissileSound( weapon.lockonTargetFiredOnSound, weapon.lockonTargetFiredOnSoundLoops );
		missile util::waittill_any("projectile_impact_explode","death");
		self notify( "stop_target_missile_sound");
		self flag::clear("playing_stinger_fired_at_me");
	}
}

function sndPlaySpecialZombiesMusic()
{
	if( GetDvarint("ai_spawn_only_zombies") == 1 )
	{
		if( !isdefined( level.zmbSndEnt ) )
		{
			level.zmbSndEnt = spawn( "script_origin", (0,0,0) );
			level.zmbSndEnt playloopsound( "mus_cp_zmb_thelooper", 2 );
		}
	}
}