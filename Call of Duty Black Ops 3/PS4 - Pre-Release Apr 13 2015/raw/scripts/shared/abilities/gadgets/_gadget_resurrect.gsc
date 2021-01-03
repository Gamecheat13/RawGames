#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                    	   	  	

#namespace resurrect;

function autoexec __init__sytem__() {     system::register("gadget_resurrect",&__init__,undefined,undefined);    }





	
#precache( "fx", "player/fx_plyr_revive" );
#precache( "fx", "player/fx_plyr_revive_demat" );
#precache( "fx", "player/fx_plyr_revive_mat" );

function __init__()
{
	clientfield::register( "allplayers", "resurrecting" , 1, 1, "int" );
	
	ability_player::register_gadget_activation_callbacks( 40, &gadget_resurrect_on, &gadget_resurrect_off );
	ability_player::register_gadget_possession_callbacks( 40, &gadget_resurrect_on_give, &gadget_resurrect_on_take );
	ability_player::register_gadget_flicker_callbacks( 40, &gadget_resurrect_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 40, &gadget_resurrect_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 40, &gadget_resurrect_is_flickering );
	ability_player::register_gadget_primed_callbacks( 40, &gadget_resurrect_is_primed );
	ability_player::register_gadget_ready_callbacks( 40, &gadget_resurrect_is_ready );
	
	callback::on_connect( &gadget_resurrect_on_connect );
	callback::on_spawned( &gadget_resurrect_on_spawned );
}

function gadget_resurrect_is_inuse( slot )
{
	return self GadgetIsActive( slot );
}

function gadget_resurrect_is_flickering( slot )
{
	return self GadgetFlickering( slot );
}

function gadget_resurrect_on_flicker( slot, weapon )
{
}

function gadget_resurrect_on_give( slot, weapon )
{
	self.usedResurrect = false;
	self.resurrect_weapon = weapon;
	self.overridePlayerDeadStatus = &gadget_resurrect_is_player_predead;
	self.secondaryDeathCamTime = &gadget_resurrect_secondary_deathcam_time;	
}

function gadget_resurrect_on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
	
	self.overridePlayerDeadStatus = undefined;
	self.resurrect_weapon = undefined;	
	self.secondaryDeathCamTime = undefined;
	
	self notify("resurrect_taken");
	self hide_resurrect_text();
}

//self is the player
function gadget_resurrect_on_spawned()
{
	// executed when gadget is added to the players inventory
	self flagsys::clear( "gadget_resurrect_ready" );
	self flagsys::clear( "gadget_resurrect_pending" );
	
	if ( self flagsys::get( "gadget_resurrect_activated" ) )
	{
		self thread do_resurrected_on_spawned_player_fx();
		
		self thread resurrect_drain_power();
		
		self flagsys::clear( "gadget_resurrect_activated" ); 
	}
	
	self hide_resurrect_text();
}

function resurrect_drain_power()
{
	if ( isdefined( self.resurrect_weapon ) )
	{
		slot = self GadgetGetSlot( self.resurrect_weapon );
		if ( slot >= 0 && slot < 3 )
		{
			self ability_power::power_drain_completely( slot );
		}
	}	
}

//self is the player
function gadget_resurrect_on_connect()
{
	// setup up stuff on player connect
}

function gadget_resurrect_on( slot, weapon )
{
	// excecutes when the gadget is turned on
}

function gadget_resurrect_is_primed( slot, weapon )
{
//	self thread gadget_resurrect_start( slot, weapon );
}

function gadget_resurrect_is_ready( slot, weapon )
{
	self flagsys::set( "gadget_resurrect_ready" );
	self thread resurrect_breadcrumbs( slot );
	self thread resurrect_watch_for_death( slot,weapon );
}

function gadget_resurrect_start( slot, weapon )
{
	wait 0.1;
	self GadgetSetActivateTime( slot, GetTime() );
	self thread resurrect_delay( weapon );
}

function gadget_resurrect_off( slot, weapon )
{
	self notify( "gadget_resurrect_off" );
	
	// excecutes when the gadget is turned off
}

function resurrect_delay( weapon )
{
	self endon ( "disconnect" );
	self endon("game_ended");
	self endon ( "death" );
	
	self notify( "resurrect_delay" );
	self endon( "resurrect_delay" );
	
}

function overrideSpawn(isPredictedSpawn)
{	
	if ( !self flagsys::get( "gadget_resurrect_ready" ) )
		return false;
	if ( !self flagsys::get( "gadget_resurrect_activated" ) )
		return false;

	if (!IsDefined(	self.resurrect_origin ))
	{
		self.resurrect_origin = self.origin;
		self.resurrect_angles = self.angles;
	}
	
	return true;
}


function is_jumping()
{
	// checking PMF_JUMPING in code would give more accurate results
	ground_ent = self GetGroundEnt();
	return (!isdefined(ground_ent));
}


function player_position_valid()
{
	//if ( self IsWallRunning() || self is_jumping() )
		//return false;
	if ( self clientfield::get_to_player( "out_of_bounds" ) )
		return false;
	
	return true;
}


function resurrect_breadcrumbs(slot)
{
	self endon("disconnect");
	self endon("game_ended");
	self endon("resurrect_taken");
	self.resurrect_slot = slot;

	while(1)
	{
		if (IsAlive(self) && self player_position_valid() )
		{
			self.resurrect_origin = self.origin;
			self.resurrect_angles = self.angles;
		}
		wait 1;
	}
	
}


function glow_for_time( time )
{
	self endon("disconnect");
	self clientfield::set( "resurrecting", 1 );
	wait time;
	self clientfield::set( "resurrecting", 0 );
}

function wait_for_time( time, msg )
{
	self endon("disconnect");
	self endon("game_ended");
	
	self endon(msg);
	wait time;
	self notify(msg);
}

function wait_for_activate( msg )
{
	self endon("disconnect");
	self endon("game_ended");
	
	self endon(msg);
	while(1)
	{
		if ( self OffhandSpecialButtonPressed() )
		{
			self flagsys::set( "gadget_resurrect_activated" ); 
			self notify(msg);
		}
		{wait(.05);};
	}
}

function bot_wait_for_activate( msg, time )
{
	self endon("disconnect");
	self endon("game_ended");
	
	self endon(msg);
	
	if ( !self util::is_bot() )
	{
		return;
	}	
	
	time = int( time + 1 );
	
	randWait = RandomInt( time );
	
	wait randWait;
	
	self flagsys::set( "gadget_resurrect_activated" ); 
	self notify(msg);	
}

function do_resurrect_hint_fx()
{
	offset = (0,0,40);
	fxOrg = spawn( "script_model", self.resurrect_origin + offset );
	fxOrg SetModel( "tag_origin" );

	fx = PlayFxOnTag( "player/fx_plyr_revive", fxOrg, "tag_origin" );
	
	self waittill("resurrect_time_or_activate");	
	
	fxOrg delete();
}

function do_resurrected_on_dead_body_fx()
{
	if ( isdefined( self.body ) )
	{
		fx = PlayFx( "player/fx_plyr_revive_demat", self.body.origin );
		
		self.body NotSolid();
		self.body Ghost();
	}	
}

function do_resurrected_on_spawned_player_fx()
{
	playsoundatposition( "mpl_resurrect_npc", self.origin );
	
	fx = PlayFx( "player/fx_plyr_revive_mat", self.origin );
}

function resurrect_watch_for_death( slot, weapon )
{
	self endon("disconnect");
	self endon("game_ended");

	self waittill("death"); 
	
	resurrect_time = 3;
	
	if ( IsDefined( weapon.gadget_resurrect_duration) )
	{
		resurrect_time = weapon.gadget_resurrect_duration / 1000.0;
	}
	
	self.usedResurrect = false;
	
	self flagsys::clear( "gadget_resurrect_activated" );
	self flagsys::set( "gadget_resurrect_pending" );
	self.resurrect_available_time = GetTime();
	
	self add_resurrect_text();
	
	self thread wait_for_time(resurrect_time,"resurrect_time_or_activate");
	
	self thread wait_for_activate("resurrect_time_or_activate");
	self thread bot_wait_for_activate("resurrect_time_or_activate", resurrect_time );
	
	self thread do_resurrect_hint_fx();
	
	self waittill("resurrect_time_or_activate");
	
	self flagsys::clear( "gadget_resurrect_pending" );
	
	if ( self flagsys::get( "gadget_resurrect_activated" ) )
	{
		self thread do_resurrected_on_dead_body_fx();
		
		self notify ( "end_death_delay" );
		self notify ( "end_killcam" );
		
		self.cancelKillcam = true;
		self.usedResurrect = true;
		
		self notify ( "end_death_delay" );
		self notify( "force_spawn" );
		
		if ( !( isdefined( weapon.gadget_resurrect_reset_scorestreak ) && weapon.gadget_resurrect_reset_scorestreak ) )
		{
			self.pers["resetMomentumOnSpawn"] = false;
		}
		
		//self thread glow_for_time( 7 );
	}

	self hide_resurrect_text();	
}



function gadget_resurrect_delay_updateTeamStatus()
{
	if ( self flagsys::get( "gadget_resurrect_ready" ) )
	{
		return true;
	}
	
	return false;
}

function gadget_resurrect_is_player_predead()
{
	should_not_be_dead = false;
	if ( self.sessionstate == "playing" && isAlive( self ) )
		should_not_be_dead = true;
		
	if ( self flagsys::get( "gadget_resurrect_pending" ) )
	{
		return true;
	}
	
	return should_not_be_dead;
}

function gadget_resurrect_secondary_deathcam_time()
{
	if ( self flagsys::get( "gadget_resurrect_pending" ) && IsDefined(self.resurrect_available_time) )
	{
		resurrect_time = 3000;
		
		weapon = self.resurrect_weapon;	
		if ( IsDefined(weapon.gadget_resurrect_duration) )
			resurrect_time = weapon.gadget_resurrect_duration;
		
		time_left = resurrect_time - ( GetTime() - self.resurrect_available_time );
		
		if ( time_left > 0 )
		{
			return time_left / 1000.0;
		}
	}
	
	return 0.0;
}
	

function add_resurrect_text()
{
	if ( !isdefined( self.resurrect_hint ) )
	{
		self.resurrect_hint = newClientHudElem(self);
		self.resurrect_hint.archived = false;
		self.resurrect_hint.x = 0;
		self.resurrect_hint.alignX = "center";
		self.resurrect_hint.alignY = "middle";
		self.resurrect_hint.horzAlign = "center";
		self.resurrect_hint.vertAlign = "bottom";
		self.resurrect_hint.sort = 1; // force to draw after the bars
		self.resurrect_hint.font = "objective";		
	}

	if ( self IsSplitscreen() )
	{
		self.resurrect_hint.y = -130;
		self.resurrect_hint.fontscale = 2;
	}
	else
	{
		self.resurrect_hint.y = -150;
		self.resurrect_hint.fontscale = 3;
	}

	self.resurrect_hint setText(&"WEAPON_GADGET_RESURRECT_USE");
		
	self.resurrect_hint.alpha = 1;
}

function hide_resurrect_text()
{
	if ( isdefined( self.resurrect_hint ) )
	{
		self.resurrect_hint.alpha = 0;
	}

}
