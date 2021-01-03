#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#using scripts\shared\abilities\_ability_gadgets;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

#using scripts\shared\_burnplayer;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                    	   	  	






#namespace heat_wave;

function autoexec __init__sytem__() {     system::register("gadget_heat_wave",&__init__,undefined,undefined);    }

function __init__()
{
	ability_player::register_gadget_activation_callbacks( 41, &gadget_heat_wave_on_activate, &gadget_heat_wave_on_deactivate );
	ability_player::register_gadget_possession_callbacks( 41, &gadget_heat_wave_on_give, &gadget_heat_wave_on_take );
	ability_player::register_gadget_flicker_callbacks( 41, &gadget_heat_wave_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 41, &gadget_heat_wave_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 41, &gadget_heat_wave_is_flickering );
	
	callback::on_connect( &gadget_heat_wave_on_connect );
	callback::on_spawned( &gadget_heat_wave_on_player_spawn );
	
	level.heatwaveBurnDamage = GetDvarFloat( "scr_heat_wave_burn_damage", 1 );
	level.heatwaveBurnInterval = GetDvarFloat( "scr_heat_wave_burn_interval", .25 );
	level.heatwaveBurnDuration = GetDvarFloat( "scr_heat_wave_burn_duration", 1 );	// Must be greater than HEATWAVE_UPDATE_INTERVAL or effects will turn off
		
	/#
	level thread updateDvars();
	#/
}

function updateDvars()
{
	while(1)
	{
		level.heatwaveBurnDamage = GetDvarFloat( "scr_heat_wave_burn_damage", level.heatwaveBurnDamage );
		level.heatwaveBurnInterval = GetDvarFloat( "scr_heat_wave_burn_interval", level.heatwaveBurnInterval );
		level.heatwaveBurnDuration = GetDvarFloat( "scr_heat_wave_burn_duration", level.heatwaveBurnDuration );	// Must be greater than HEATWAVE_UPDATE_INTERVAL or effects will turn off

		wait(1.0);
	}
}

function gadget_heat_wave_is_inuse( slot )
{
	// returns true when local script gadget state is on
	return self GadgetIsActive( slot );
}

function gadget_heat_wave_is_flickering( slot )
{
	// returns true when local script gadget state is flickering
	return self GadgetFlickering( slot );
}

function gadget_heat_wave_on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
	self thread gadget_heat_wave_flicker( slot, weapon );
}

function gadget_heat_wave_on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory
}

function gadget_heat_wave_on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
}

//self is the player
function gadget_heat_wave_on_connect()
{
	// setup up stuff on player connec
}

function gadget_heat_wave_on_player_spawn()
{
	// setup up stuff on player spawned
	self._heat_wave_stuned_end = 0;
}

function gadget_heat_wave_on_activate( slot, weapon )
{
	self thread heat_wave_think( slot, weapon );
}

function gadget_heat_wave_on_deactivate( slot, weapon )
{
}

function gadget_heat_wave_flicker( slot, weapon )
{
	self endon( "disconnect" );	

	if ( !self gadget_heat_wave_is_inuse( slot ) )
	{
		return;
	}

	eventTime = self._gadgets_player[slot].gadget_flickertime;

	self set_gadget_status( "Flickering", eventTime );

	while( 1 )
	{		
		if ( !self GadgetFlickering( slot ) )
		{
			self set_gadget_status( "Normal" );
			return;
		}

		wait( 0.5 );
	}
}

function set_gadget_status( status, time )
{
	timeStr = "";

	if ( IsDefined( time ) )
	{
		timeStr = "^3" + ", time: " + time;
	}
	
	if ( GetDvarInt( "scr_cpower_debug_prints" ) > 0 )
		self IPrintlnBold( "Gadget Heat Wave: " + status + timeStr );
}

function heat_wave_think( slot, weapon )
{
	self endon( "disconnect" );
	
	self notify ( "heat_wave_think" );
	self endon( "heat_wave_think" );
	
	while( 1 )
	{
		wait ( 0.25 );
		
		if ( !self gadget_heat_wave_is_inuse( slot ) )
		{
			return;
		}
		
		entities = GetDamageableEntArray( self.origin, weapon.gadget_shockfield_radius, true );
		burned = false;
		
		foreach( entity in entities )
		{
			if( IsPlayer( entity ) )
			{
				if( self GetEntityNumber() == entity GetEntityNumber() )
				{
					continue;
				}
				
				if( self.team == entity.team )
				{
					continue;
				}
				
				if ( !IsAlive( entity ) )
				{
					continue;
				}
				
				currentTime = GetTime();
				
				if ( (entity._heat_wave_stuned_end + (0*1000)) >  currentTime )
				{
					continue;
				}
				
				if ( entity util::mayApplyScreenEffect() )				
				{				
					if ( BulletTracePassed( self.origin + ( 0, 0, 30 ), entity.origin + ( 0, 0, 30 ), true, self, undefined, false, true ) )
					{
						entity DoDamage( weapon.gadget_shockfield_damage, self.origin + ( 0, 0, 30 ), self, self, 0, "MOD_GRENADE_SPLASH" );
						entity setdoublejumpenergy( 0 );
						entity resetdoublejumprechargetime();
							
						shellshock_duration = 0.5;
						
						entity._heat_wave_stuned_end = currentTime + (shellshock_duration*1000);
						entity shellshock( "heat_wave", shellshock_duration, true );
						entity SetBurn( shellshock_duration );
						entity thread heat_wave_update_rumble();
						entity thread heat_wave_burn_sound();		
						entity burnplayer::SetPlayerBurning( level.heatwaveBurnDuration, level.heatwaveBurnInterval, level.heatwaveBurnDamage, self );
						burned = true;						
					}					
				}
			}
		}
		
		if ( burned )
		{
			// use flickering to change the fx
			self ability_gadgets::SetFlickering( slot, 500 );
		}
	}
}

function heat_wave_update_rumble()
{
	self endon("disconnect");
	self endon( "death" );
	
	while( 1 )
	{
		if ( !isdefined( self ) || !isdefined( self._heat_wave_stuned_end ) )
		{
			return;
		}
		
		currentTime = GetTime();
				
		if ( self._heat_wave_stuned_end < currentTime )
		{
			return;
		}
		
		self PlayRumbleOnEntity( "heat_wave_damage" );	
		
		wait 1;
	}
}

function heat_wave_burn_sound()
{
	self playsound ("mpl_player_burn");
	
	fire_sound_ent = spawn( "script_origin", self.origin );
	fire_sound_ent linkto( self, "tag_origin", (0,0,0), (0,0,0) );
	fire_sound_ent playloopsound ("mpl_player_burn_loop");
	
	wait 1;
	
	if ( isdefined( fire_sound_ent ) )
	{
		fire_sound_ent StopLoopSound( 0.5 );
	}
	
	wait .5;
	
	if ( isdefined( fire_sound_ent ) )
	{
		fire_sound_ent delete();	
	}
}
