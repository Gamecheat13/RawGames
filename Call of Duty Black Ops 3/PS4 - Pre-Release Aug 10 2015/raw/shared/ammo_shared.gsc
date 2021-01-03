#using scripts\shared\array_shared;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons\_weapons;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                             	     	                                                                                                                                                                

#namespace ammo;

 //How many clips of ammo the player gets for their primaries for each scavenge

function DropAIAmmo()
{
	self endon("death");
	
	if ( !IsDefined( self.ammoPouch ) )
	{
		return;
	}
	
	if ( ( isdefined( self.disableAmmoDrop ) && self.disableAmmoDrop ) )
	{
		return;
	}
	
	droppedWeapon = shared::ThrowWeapon( self.ammoPouch, "tag_stowed_back", true );
	
	if ( IsDefined( droppedWeapon ) )
	{
		droppedWeapon thread ammo::ammo_pouch_think();
	}
}

function ammo_pouch_think()
{
	self endon( "death" );
	self waittill( "scavenger", player );

	primary_weapons = player GetWeaponsListPrimaries();
	offhand_weapons_and_alts = array::exclude( player GetWeaponsList( true ), primary_weapons );

	ArrayRemoveValue( offhand_weapons_and_alts, level.weaponBaseMelee );
	offhand_weapons_and_alts = array::reverse( offhand_weapons_and_alts ); // Prioritize tacticals over lethals

	player playsound( "wpn_ammo_pickup" );
	player playlocalsound( "wpn_ammo_pickup" );

	//TODO: remove this override after the demo

	if( ( isdefined( level.b_disable_scavenger_icon ) && level.b_disable_scavenger_icon ) )
	{
		player weapons::flash_scavenger_icon();
	}

	for ( i = 0; i < offhand_weapons_and_alts.size; i++ )
	{
		weapon = offhand_weapons_and_alts[i];

		maxAmmo = 0;
		
		if ( weapon == player.grenadeTypePrimary && isdefined( player.grenadeTypePrimaryCount ) && player.grenadeTypePrimaryCount > 0 )
		{
			maxAmmo = player.grenadeTypePrimaryCount;
		}
		else if ( weapon == player.grenadeTypeSecondary && isdefined( player.grenadeTypeSecondaryCount ) && player.grenadeTypeSecondaryCount > 0 )
		{
			maxAmmo = player.grenadeTypeSecondaryCount;
		}
		else if ( weapon.inventorytype == "hero" && ( isdefined( level.overrideAmmoDropHeroWeapon ) && level.overrideAmmoDropHeroWeapon ) )
		{
			maxAmmo = weapon.maxammo;
		}
		
		if ( isdefined( level.customLoadoutScavenge ) )
		{
			maxAmmo = self [[level.customLoadoutScavenge]]( weapon );
		}
		
		if ( maxAmmo == 0 )
		{
			continue;
		}
		
		if ( weapon.rootWeapon == level.weaponSatchelCharge )
		{
			if ( player weaponobjects::anyObjectsInWorld( weapon.rootWeapon ) )
			{
				continue;
			}
		}		
			
		stock = player GetWeaponAmmoStock( weapon );

		if ( weapon.inventorytype == "hero" && ( isdefined( level.overrideAmmoDropHeroWeapon ) && level.overrideAmmoDropHeroWeapon ) )
		{
			ammo = stock + weapon.clipsize;
			if (ammo > maxAmmo) {     ammo = maxAmmo;    };
			player SetWeaponAmmoStock( weapon, ammo );
			player.scavenged = true;
		}
		else if ( stock < maxAmmo )
		{
			// just give 1 for each scavenger pick up
			ammo = stock + 1;
			if ( ammo > maxAmmo )
			{
				ammo = maxAmmo;
			}
			player SetWeaponAmmoStock( weapon, ammo );
			player.scavenged = true;
			
			//player thread challenges::scavengedGrenade();
		}
//  	else
//		{
//			if ( weapon.rootWeapon == GetWeapon( "trophy_system" ) )
//			{
//				player trophy_system::ammo_scavenger( weapon );
//			}
//		}
		
	}

	for ( i = 0; i < primary_weapons.size; i++ )
	{
		weapon = primary_weapons[i];

		stock = player GetWeaponAmmoStock( weapon );
		start = player GetFractionStartAmmo( weapon );
		clip = weapon.clipSize;
		clip *= GetDvarFloat( "scavenger_clip_multiplier", 1 );
		clip = Int( clip );
		maxAmmo = weapon.maxAmmo;

		//give the player multiple clips when ammo is scavenged
		if( stock < maxAmmo - (clip * 3) )
		{
			ammo = stock + (clip * 3);
			player SetWeaponAmmoStock( weapon, ammo );		
		}
		else
		{
			player SetWeaponAmmoStock( weapon, maxAmmo );
		}
	}
}