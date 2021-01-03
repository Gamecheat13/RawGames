#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\postfx_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       




	
 // 200 * 200

	
#precache( "client_fx", "weapon/fx_prox_grenade_scan_blue" );
#precache( "client_fx", "weapon/fx_prox_grenade_wrn_grn" );
#precache( "client_fx", "weapon/fx_prox_grenade_scan_orng" );
#precache( "client_fx", "weapon/fx_prox_grenade_wrn_red" );
#precache( "client_fx", "weapon/fx_prox_grenade_impact_player_spwner" );
	
#namespace proximity_grenade;

function init_shared()
{	
	clientfield::register( "toplayer", "tazered", 1, 1, "int", undefined, !true, !true );

	level._effect["prox_grenade_friendly_default"] = "weapon/fx_prox_grenade_scan_blue";
	level._effect["prox_grenade_friendly_warning"] = "weapon/fx_prox_grenade_wrn_grn";

	level._effect["prox_grenade_enemy_default"] = "weapon/fx_prox_grenade_scan_orng";
	level._effect["prox_grenade_enemy_warning"] = "weapon/fx_prox_grenade_wrn_red";

	level._effect["prox_grenade_player_shock"] = "weapon/fx_prox_grenade_impact_player_spwner";
	
	callback::add_weapon_type( "proximity_grenade", &proximity_spawned );
	callback::on_spawned( &on_player_spawned );
	
	level thread watchForProximityExplosion();
}

function on_player_spawned( localClientNum )
{

}

function proximity_spawned( localClientNum )
{	
	if ( self isGrenadeDud() ) 
		return; 

	self.equipmentFriendFX = level._effect["prox_grenade_friendly_default"];
	self.equipmentEnemyFX = level._effect["prox_grenade_enemy_default"];
	self.equipmentTagFX = "tag_fx";
	
	self thread weaponobjects::equipmentTeamObject( localClientNum );
}

function watchForProximityExplosion()
{
	if ( GetActiveLocalClients() > 1 )
		return;

	weapon_proximity = GetWeapon( "proximity_grenade" );

	while ( true )
	{
		level waittill( "explode", localClientNum, position, mod, weapon, owner_cent );
		
		if ( weapon.rootWeapon != weapon_proximity )
		{
			continue;
		}
		
		localPlayer = GetLocalPlayer( localClientNum );

		if ( ( !localPlayer util::is_player_view_linked_to_entity( localClientNum ) ) )
		{
			
			explosionRadius = weapon.explosionRadius;
				
			if ( DistanceSquared( localPlayer.origin, position ) < explosionRadius * explosionRadius )
			{
				if ( isdefined( owner_cent ) )
				{
					if ( ( owner_cent == localPlayer ) || !( owner_cent util::friend_not_foe( localClientNum, true ) ) )
					{
						//localPlayer thread taserHUDFX( localClientNum, position );
						localPlayer thread postfx::PlayPostfxBundle( "pstfx_shock_charge" );
					}
				}
			}
			
		}
	}
}
