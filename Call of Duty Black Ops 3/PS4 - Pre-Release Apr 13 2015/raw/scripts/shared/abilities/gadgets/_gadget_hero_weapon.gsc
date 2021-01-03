#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\spawner_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                    	   	  	

#using scripts\shared\system_shared;

#precache( "eventstring", "hero_weapon_received" );

function autoexec __init__sytem__() {     system::register("gadget_hero_weapon",&__init__,undefined,undefined);    }

function __init__()
{
	ability_player::register_gadget_activation_callbacks( 14, &gadget_hero_weapon_on_activate, &gadget_hero_weapon_on_off );
	ability_player::register_gadget_possession_callbacks( 14, &gadget_hero_weapon_on_give, &gadget_hero_weapon_on_take );
	ability_player::register_gadget_flicker_callbacks( 14, &gadget_hero_weapon_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 14, &gadget_hero_weapon_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 14, &gadget_hero_weapon_is_flickering );
	ability_player::register_gadget_ready_callbacks( 14, &gadget_hero_weapon_ready );

	//callback::on_connect( &gadget_hero_weapon_on_connect );
	//callback::on_spawned( &gadget_hero_weapon_on_spawn );
}

function gadget_hero_weapon_is_inuse( slot )
{
	// returns true when the gadget is on
	return self GadgetIsActive( slot );
}

function gadget_hero_weapon_is_flickering( slot )
{
	// returns true when the gadget is flickering
	return self GadgetFlickering( slot );
}

function gadget_hero_weapon_on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
}

function gadget_hero_weapon_on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory
	
	if ( !isdefined( self.pers["held_hero_weapon_ammo_count"] ) )
	{
		self.pers["held_hero_weapon_ammo_count"] = [];
	}

	if( weapon.gadget_power_consume_on_ammo_use || !isdefined( self.pers["held_hero_weapon_ammo_count"][weapon] ) )
	{
		self.pers["held_hero_weapon_ammo_count"][weapon] = 0;
	}	
	
	self SetWeaponAmmoClip( weapon, self.pers["held_hero_weapon_ammo_count"][weapon] );
	
	n_ammo = self GetAmmoCount( weapon );
	
	if ( n_ammo > 0 )
	{
		stock = self.pers["held_hero_weapon_ammo_count"][weapon] - n_ammo;
		
		if ( stock > 0 && !weapon.isClipOnly )
		{
			self SetWeaponAmmoStock( weapon, stock );
		}		
		
		self hero_handle_ammo_save( slot, weapon );
	}
	else
	{	
		self GadgetCharging( slot, true );
	}
}

function gadget_hero_weapon_on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
}

//self is the player
function gadget_hero_weapon_on_connect()
{	
	// setup up stuff on player connect	
}

//self is the player
function gadget_hero_weapon_on_spawn()
{	
	// setup up stuff on player spawn
}

function gadget_hero_weapon_on_activate( slot, weapon )
{
	// excecutes when the gadget is turned on
	self.heroweaponKillCount = 0;
	
	if ( !weapon.gadget_power_consume_on_ammo_use )
	{
		self hero_give_ammo( slot, weapon );
	
		self hero_handle_ammo_save( slot, weapon );
	}
}

function gadget_hero_weapon_on_off( slot, weapon )
{
	if ( weapon.gadget_power_consume_on_ammo_use )
	{
		self SetWeaponAmmoClip( weapon, 0 );
	}
}

function gadget_hero_weapon_ready( slot, weapon )
{
	if ( weapon.gadget_power_consume_on_ammo_use )
	{
		hero_give_ammo( slot, weapon );
	}
}

function hero_give_ammo( slot, weapon )
{	
	if ( isdefined( level.heroWeaponsTable ) )
	{
		weaponStatsTableEntry = level.heroWeaponsTable[weapon.name];
		if ( isdefined( weaponStatsTableEntry ) )
		{
			index = weaponStatsTableEntry["index"];
			if ( isdefined( index ) )
			{
				self LUINotifyEvent( &"hero_weapon_received", 1, index );
				self LUINotifyEventToSpectators( &"hero_weapon_received", 1, index );
			}
		}	
	}	
	
	self GiveMaxAmmo( weapon );
	self SetWeaponAmmoClip( weapon, weapon.clipSize );	
}

function hero_handle_ammo_save( slot, weapon )
{	
	self thread hero_wait_for_out_of_ammo( slot, weapon );
	self thread hero_wait_for_game_end( slot, weapon );
	self thread hero_wait_for_death( slot, weapon );
}

function hero_wait_for_game_end( slot, weapon )
{
	self endon( "disconnect" );	

	self notify( "hero_ongameend" );
	self endon( "hero_ongameend" );		
	
	level waittill("game_ended");

	if ( IsAlive( self ) )
	{
		self hero_save_ammo( slot, weapon );
	}
}

function hero_wait_for_death( slot, weapon )
{
	self endon( "disconnect" );	

	self notify( "hero_ondeath" );
	self endon( "hero_ondeath" );
	
	self waittill( "death" );
	
	self hero_save_ammo( slot, weapon );
}

function hero_save_ammo( slot, weapon )
{
	self.pers["held_hero_weapon_ammo_count"][weapon] = self GetAmmoCount( weapon );
}


function hero_wait_for_out_of_ammo( slot, weapon )
{
	self endon( "disconnect" );
	self endon( "death" );

	self notify( "hero_noammo" );
	self endon( "hero_noammo" );
	
	while( 1 )
	{
		wait ( 0.1 );
		
		n_ammo = self GetAmmoCount( weapon );
		
		if ( n_ammo == 0 )
		{
			break;
		}
	}
	
	self GadgetPowerReset( slot );
	self GadgetCharging( slot, true );
}


function set_gadget_hero_weapon_status( weapon, status, time )
{
	timeStr = "";

	if ( IsDefined( time ) )
	{
		timeStr = "^3" + ", time: " + time;
	}
	
	if ( GetDvarInt( "scr_cpower_debug_prints" ) > 0 )
		self IPrintlnBold( "Hero Weapon " + weapon.name + ": " + status + timeStr );
}