#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_riotshield;
#using scripts\zm\craftables\_zm_craftables;

#using scripts\shared\ai\zombie_utility;

                                                                                                                                                                              	                           	                                        	                                                     	                                 
                                                                                                                               

#precache( "string", "ZOMBIE_CRAFT_RIOT" );
#precache( "string", "ZOMBIE_GRAB_RIOTSHIELD" );









#namespace zm_craft_shield;

function autoexec __init__sytem__() {     system::register("zm_craft_shield",&__init__,&__main__,undefined);    }

// RIOT SHIELD

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	level.riotshield_supports_deploy = false; 
	level.weaponRiotshield = GetWeapon( "zod_riotshield" );
		
	riotShield_dolly = zm_craftables::generate_zombie_craftable_piece( "craft_shield_zm", "dolly", 32, 64, 0, undefined, &on_pickup_common, &on_drop_common, undefined, undefined, undefined, undefined, "piece_riotshield_dolly", 1, "build_zs" );
	riotShield_door  = zm_craftables::generate_zombie_craftable_piece( "craft_shield_zm", "door", 48, 15, 25, undefined, &on_pickup_common, &on_drop_common, undefined, undefined, undefined, undefined, "piece_riotshield_door", 1, "build_zs" );
	riotShield_clamp  = zm_craftables::generate_zombie_craftable_piece( "craft_shield_zm", "clamp", 48, 15, 25, undefined, &on_pickup_common, &on_drop_common, undefined, undefined, undefined, undefined, "piece_riotshield_clamp", 1, "build_zs" );
	
	RegisterClientField( "world", "piece_riotshield_dolly",	1, 1, "int", undefined, false );
	RegisterClientField( "world", "piece_riotshield_door",	1, 1, "int", undefined, false );
	RegisterClientField( "world", "piece_riotshield_clamp", 1, 1, "int", undefined, false );

	riotShield = SpawnStruct();
	riotShield.name = "craft_shield_zm";
	riotShield.weaponname = "zod_riotshield";
	riotShield zm_craftables::add_craftable_piece( riotShield_dolly );
	riotShield zm_craftables::add_craftable_piece( riotShield_door );
	riotShield zm_craftables::add_craftable_piece( riotShield_clamp );
	riotShield.onBuyWeapon = &on_buy_weapon_riotshield;
	riotShield.triggerThink = &riotshield_craftable;
	
	zm_craftables::include_zombie_craftable( riotShield );
	
	zm_craftables::add_zombie_craftable( "craft_shield_zm",	&"ZOMBIE_CRAFT_RIOT", "ERROR", &"ZOMBIE_BOUGHT_RIOT", undefined, 1 );
	zm_craftables::add_zombie_craftable_vox_category( "craft_shield_zm", "build_zs" );
	zm_craftables::make_zombie_craftable_open( "craft_shield_zm", "wpn_t7_shield_riot_world", (0, -90, 0), (0, 0, 26) );
	
	zm_equipment::register( "zod_riotshield", &"ZOMBIE_EQUIP_RIOTSHIELD_PICKUP_HINT_STRING", &"ZOMBIE_EQUIP_RIOTSHIELD_HOWTO", undefined, "riotshield", &zm_equip_riotshield::riotshield_activation_watcher_thread, undefined, &zm_equip_riotshield::dropShield, &zm_equip_riotshield::pickupShield ); //, &placeShield );
}

function __main__()
{
	zm_equipment::register_for_level( "zod_riotshield" );
	zm_equipment::include( "zod_riotshield" );
	
	zm_equipment::set_ammo_driven( "zod_riotshield", level.weaponRiotshield.startAmmo );
	
	SetDvar( "juke_enabled", 1 );
	
	zombie_utility::set_zombie_var( "riotshield_fling_damage_shield",			0 ); 
	zombie_utility::set_zombie_var( "riotshield_knockdown_damage_shield",		0 );
	zombie_utility::set_zombie_var( "riotshield_fling_range",					120 ); 
	zombie_utility::set_zombie_var( "riotshield_gib_range",						120 ); 
	zombie_utility::set_zombie_var( "riotshield_knockdown_range",				120 ); 

}

function riotshield_craftable()
{
	zm_craftables::craftable_trigger_think( "riotshield_zm_craftable_trigger", "craft_shield_zm", "zod_riotshield", &"ZOMBIE_GRAB_RIOTSHIELD", 1, 1 );
}

// self is a WorldPiece
function on_pickup_common( player )
{
	// CallBack When Player Picks Up Craftable Piece
	//----------------------------------------------
/#	PrintLn( "ZM >> Common part callback onPickup()" );	#/

	player playsound( "zmb_craftable_pickup" );	
		
	self pickup_from_mover();
	self.piece_owner = player;
}

// self is a WorldPiece
function on_drop_common( player )
{
	// CallBack When Player Drops Craftable Piece
	//-------------------------------------------
/#	PrintLn( "ZM >> Common part callback onDrop()" );	#/

	self drop_on_mover( player );
	self.piece_owner = undefined;
}

function pickup_from_mover()
{	
	//Setup for override
	if( isdefined( level.craft_shield_pickup_override ) )
	{
		[[level.craft_shield_pickup_override]]();
	}
}

function drop_on_mover( player )
{
	//Setup for override
	if( isdefined( level.craft_shield_drop_override ) )
	{
		[[level.craft_shield_drop_override]]();
	}	
}

function on_buy_weapon_riotshield( player )
{
	if ( isdefined(player.player_shield_reset_health))
	{
		player [[player.player_shield_reset_health]]();
	}
	if ( isdefined(player.player_shield_reset_location))
	{
		player [[player.player_shield_reset_location]]();
	}
}

