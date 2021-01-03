
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
//#using scripts\shared\gameobjects_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                               

#using scripts\zm\_util;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;


	
#namespace zm_altbody;

function autoexec __init__sytem__() {     system::register("zm_altbody",&__init__,undefined,undefined);    }
	
function __init__()
{
	// clientuimodels are registered client-side in raw/ui/uieditor/clientfieldmodels.lua
	clientfield::register( "clientuimodel", "player_lives", 1, 2, "int" );
	clientfield::register( "toplayer", "player_in_afterlife", 1, 1, "int" ); 
	clientfield::register( "toplayer", "player_afterlife_mana", 1, 5, "float" );
	clientfield::register( "allplayers", "player_altbody", 1, 1, "int" ); 
}

function init( name, trigger_name, trigger_hint, visionset_name, visionset_priority, loadout, character_index, enter_callback, exit_callback, allow_callback, notrigger_name, notrigger_hint )
{
	if(!isdefined(level.altbody_enter_callbacks))level.altbody_enter_callbacks=[];
	if(!isdefined(level.altbody_exit_callbacks))level.altbody_exit_callbacks=[];
	if(!isdefined(level.altbody_allow_callbacks))level.altbody_allow_callbacks=[];
	if(!isdefined(level.altbody_loadouts))level.altbody_loadouts=[];
	if(!isdefined(level.altbody_visionsets))level.altbody_visionsets=[];
	if(!isdefined(level.altbody_charindexes))level.altbody_charindexes=[];
	
	if ( IsDefined(visionset_name) )
	{
		level.altbody_visionsets[ name ] = visionset_name;
		visionset_mgr::register_info( "visionset", visionset_name, 1, visionset_priority, 1, true ); //, &vsmgr_lerp_power_up_down, false );
	}
	
	if ( IsDefined( trigger_name ) )
	{
		watch_kiosk_triggers( name, trigger_name, trigger_hint, true );
		if ( IsDefined( notrigger_name ) )
			watch_kiosk_triggers( name, notrigger_name, notrigger_hint, false );
	}
	
	level.altbody_enter_callbacks[name]=enter_callback;
	level.altbody_exit_callbacks[name]=exit_callback;
	level.altbody_allow_callbacks[name]=allow_callback;
	level.altbody_loadouts[name]=loadout;
	level.altbody_charindexes[name]=character_index; 
	
}

function private watch_kiosk_triggers( name, trigger_name, trigger_hint, whenvisible )
{
	triggers = GetEntArray( trigger_name, "targetname" );
	if ( !triggers.size )
	{
		triggers = GetEntArray( trigger_name, "script_noteworthy" );
	}
	
	array::thread_all( triggers, &trigger_watch_kiosk, name, trigger_name, trigger_hint, whenvisible );
}

function private trigger_watch_kiosk( name, trigger_name, trigger_hint, whenvisible )
{
	self endon("death");
	self SetHintString( trigger_hint );
	self SetVisibleToAll();
	self thread trigger_monitor_visibility(name, whenvisible);
	if ( whenvisible )
	{
		if ( IsDefined( self.target ) )
		{
			target = GetEnt( self.target, "targetname" );
			self.kiosk = target;
		}
		
		while ( IsDefined( self ) )
		{
			self waittill( "trigger", player );
			
			if( isdefined( player.custom_altbody_callback ) )
			{
				player thread [[ player.custom_altbody_callback ]]( self, name );
			}
			else
			{
				player thread player_try_altbody( self, name );
			}
		}
	}
}

function trigger_monitor_visibility( name, whenvisible )
{
	self endon("death");
	self SetInvisibleToAll();
	//wait 2;
	level flagsys::wait_till( "start_zombie_round_logic" );
	self SetVisibleToAll();
	pid = 0;

	// all kiosks now unlocked by default (keep this value around as we'll probably keep activating/deactivating kiosks)	
	self.is_unlocked = true;
	
	while( IsDefined(self) )
	{
		players = level.players; //GetPlayers();
		if ( pid >= players.size )
			pid = 0;
		player = players[pid];
		pid++;

		if (!IsDefined(player))
			continue;
		visible = true;		
		visible = player player_can_altbody( self, name );
		
		if ( visible == whenvisible && ( !( isdefined( player.altbody ) && player.altbody ) || ( isdefined( player.see_kiosks_in_altbody ) && player.see_kiosks_in_altbody ) ) && ( isdefined( self.is_unlocked ) && self.is_unlocked ) )
			self SetVisibleToPlayer( player );
		else
			self SetInvisibleToPlayer( player );
			
		//WAIT_SERVER_FRAME;	
		wait RandomFloatRange( 0.2, 0.5 );
	}
	
}

/#
function devgui_start_altbody( name )
{
	self player_altbody( name );
}
#/	

function private player_can_altbody( trigger, name )
{
	if ( ( self.is_drinking > 0 ) && !( isdefined( self.trigger_kiosks_in_altbody ) && self.trigger_kiosks_in_altbody ) )
	{
		return false;
	}

	if ( self zm_utility::in_revive_trigger() )
	{
		return false;
	}
		
	if ( self laststand::player_is_in_laststand() )
	{
		return false;
	}
	
	if ( self IsThrowingGrenade() )
	{
		return false;
	}
	
	callback = level.altbody_allow_callbacks[ name ];
	if ( IsDefined( callback ) )
	{
		if ( !self [[ callback ]]( name, trigger.kiosk ) )
		{
			return false;
		}
	}

	return true;	
}

function private player_try_altbody( trigger, name )
{
	if ( self player_can_altbody( trigger, name ) )
	{
		level notify( "kiosk_used", trigger.kiosk );
		self player_altbody( name, trigger );
	}
}

function private player_altbody( name, trigger )
{
	self.altbody = true; 
	self player_enter_altbody( name, trigger ); 
	self thread temp_mana_hud(); 
	self waittill("altbody_end"); 
	self player_exit_altbody( name, trigger ); 
	self.altbody = false; 
}

function get_altbody_weapon_limit( player ) 
{
	return 16;
}


function private player_enter_altbody( name, trigger )
{
	charindex = level.altbody_charindexes[name]; 

	self SetCharacterBodyType( charindex );
	self SetCharacterBodyStyle( 0 );
	self SetCharacterHelmetStyle( 0 );

	self player_apply_loadout(name);
	self thread player_apply_visionset(name);
	
	callback = level.altbody_enter_callbacks[name]; 
	if ( IsDefined(callback) )
	{
		self [[callback]](name, trigger);
	}
	clientfield::set_to_player("player_in_afterlife",1);
	clientfield::set("player_altbody",1);
}

function private player_apply_visionset( name )
{
	if(!isdefined(self.altbody_visionset))self.altbody_visionset=[];
	visionset = level.altbody_visionsets[name]; 
	if ( IsDefined(visionset) )
	{
		if (( isdefined( self.altbody_visionset[name] ) && self.altbody_visionset[name] )) // the turned visionset gets stomped by the laststand visionset if you die as a zombie - deactivate it and reactivate it to force it back on
		{
			visionset_mgr::deactivate( "visionset", visionset, self );		
			util::wait_network_frame();
			util::wait_network_frame();
			if (!isdefined(self))
				return;
		}
		visionset_mgr::activate( "visionset", visionset, self ); //,0
		self.altbody_visionset[name] = 1;
	}
	
}

function private player_apply_loadout( name )
{
	loadout = level.altbody_loadouts[name];
	if ( IsDefined(loadout) )
	{
		self DisableWeaponCycling();
		
		assert(!IsDefined(self.get_player_weapon_limit) ); 
		self.get_player_weapon_limit = &get_altbody_weapon_limit;
		
		self.altbody_loadout[name] = zm_weapons::player_get_loadout(); 
		self zm_weapons::player_give_loadout( loadout, false ); // false to allow player to keep their weapons
		if(!isdefined(self.altbody_loadout_ever_had))self.altbody_loadout_ever_had=[];
		if ( ( isdefined( self.altbody_loadout_ever_had[name] ) && self.altbody_loadout_ever_had[name] ) )
			self SetEverHadWeaponAll( true );
		self.altbody_loadout_ever_had[name] = true; 
	}
	
}



function private player_exit_altbody( name, trigger )
{
	clientfield::set("player_altbody",0);
	clientfield::set_to_player("player_in_afterlife",0);
		
	callback = level.altbody_exit_callbacks[name]; 
	if ( IsDefined(callback) )
	{
		self [[callback]](name, trigger);
	}

	if(!isdefined(self.altbody_visionset))self.altbody_visionset=[];
	visionset = level.altbody_visionsets[name]; 
	if ( IsDefined(visionset) )
	{
		visionset_mgr::deactivate( "visionset", visionset, self );		
		self.altbody_visionset[name] = 0;
	}

	self thread player_restore_loadout(name);
	
	self DetachAll();
	self [[ level.giveCustomCharacters ]]();
	
} 


function private player_restore_loadout( name, trigger )
{
	loadout = level.altbody_loadouts[name];
	if ( IsDefined(loadout) )
	{
		// restore old primary weapon
		if ( IsDefined(self.altbody_loadout[name]) )
		{
			self SwitchToWeaponImmediate(self.altbody_loadout[name].current);
			//self zm_weapons::player_give_loadout( self.altbody_loadout[name] ); 
			self.altbody_loadout[name] = undefined; 
			self util::waittill_any_timeout( 1, "weapon_change_complete" );
		}
	
		self zm_weapons::player_take_loadout( loadout ); 
	
		assert( self.get_player_weapon_limit == &get_altbody_weapon_limit );
		self.get_player_weapon_limit = undefined;
		
		self EnableWeaponCycling();
	}
	
}

function temp_mana_hud()
{
	self endon("disconnect");
	tempY = level.primaryProgressBarY;
	level.primaryProgressBarY = 180;
	self.manabar = hud::createPrimaryProgressBar();
	level.primaryProgressBarY = tempY;
	
	while( IsDefined( self ) && ( isdefined( self.altbody ) && self.altbody ) )
	{
		mana = self clientfield::get_to_player( "player_afterlife_mana" );
		self.manabar hud::updateBar( mana );
		{wait(.05);};
	}

	if ( IsDefined( self ) && IsDefined(self.manabar) )
	{
		self.manabar hud::destroyElem();
	}
}
