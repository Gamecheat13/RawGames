#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_weapons;


#precache( "client_fx", "zombie/fx_tesla_rail_view_zmb" );
#precache( "client_fx", "zombie/fx_tesla_tube_view_zmb" );
#precache( "client_fx", "zombie/fx_tesla_tube_view2_zmb" );
#precache( "client_fx", "zombie/fx_tesla_tube_view3_zmb" );

#precache( "client_fx", "zombie/fx_tesla_rail_view_ug_zmb" );
#precache( "client_fx", "zombie/fx_tesla_tube_view_ug_zmb" );
#precache( "client_fx", "zombie/fx_tesla_tube_view2_ug_zmb" );
#precache( "client_fx", "zombie/fx_tesla_tube_view3_ug_zmb" );

function init()
{
	level.weaponZMTeslaGun = GetWeapon( "tesla_gun" );
	level.weaponZMTeslaGunUpgraded = GetWeapon( "tesla_gun_upgraded" );
	if ( !zm_weapons::is_weapon_included( level.weaponZMTeslaGun ) && !(isdefined( level.uses_tesla_powerup ) && level.uses_tesla_powerup) )
	{
		return;
	}

	level._effect["tesla_viewmodel_rail"]	= "zombie/fx_tesla_rail_view_zmb";
	level._effect["tesla_viewmodel_tube"]	= "zombie/fx_tesla_tube_view_zmb";
	level._effect["tesla_viewmodel_tube2"]	= "zombie/fx_tesla_tube_view2_zmb";
	level._effect["tesla_viewmodel_tube3"]	= "zombie/fx_tesla_tube_view3_zmb";
	
	level._effect["tesla_viewmodel_rail_upgraded"]	= "zombie/fx_tesla_rail_view_ug_zmb";
	level._effect["tesla_viewmodel_tube_upgraded"]	= "zombie/fx_tesla_tube_view_ug_zmb";
	level._effect["tesla_viewmodel_tube2_upgraded"]	= "zombie/fx_tesla_tube_view2_ug_zmb";
	level._effect["tesla_viewmodel_tube3_upgraded"]	= "zombie/fx_tesla_tube_view3_ug_zmb";
	
	level thread player_init();
	level thread tesla_notetrack_think();
}

function player_init()
{
	util::waitforclient( 0 );
	level.tesla_play_fx = [];
	level.tesla_play_rail = true;
	
	players = GetLocalPlayers();
	for( i = 0; i < players.size; i++ )
	{
		level.tesla_play_fx[i] = false;
		players[i] thread tesla_fx_rail( i );
		players[i] thread tesla_fx_tube( i );
		players[i] thread tesla_happy( i );
	}
}

function tesla_fx_rail( localclientnum )
{
	self endon( "disconnect" );
	
	for( ;; )
	{
		waitrealtime( RandomFloatRange( 8, 12 ) );
		
		if ( !level.tesla_play_fx[localclientnum] )
		{
			continue;
		}
		if ( !level.tesla_play_rail )
		{			
			continue;
		}

		currentweapon = GetCurrentWeapon( localclientnum ); 
		if ( currentweapon != level.weaponZMTeslaGun && currentweapon != level.weaponZMTeslaGunUpgraded )
		{
			continue;
		}

		if ( IsADS( localclientnum ) || IsThrowingGrenade( localclientnum ) || IsMeleeing( localclientnum ) || IsOnTurret( localclientnum ) )
		{
			continue;
		}
		
		if ( GetWeaponAmmoClip( localclientnum, currentweapon ) <= 0 )
		{
			continue;
		}
		
		fx = level._effect["tesla_viewmodel_rail"];
		
		if ( currentweapon == level.weaponZMTeslaGunUpgraded )
		{
			fx = level._effect["tesla_viewmodel_rail_upgraded"];
		}
		
		PlayViewmodelFx( localclientnum, fx, "tag_flash" );
		playsound(localclientnum,"wpn_tesla_effects", (0,0,0));
	}
}

function tesla_fx_tube( localclientnum )
{
	self endon( "disconnect" );
		
	for( ;; )
	{
		waitrealtime( 0.1 );
		
		if ( !level.tesla_play_fx[localclientnum] )
		{
			continue;
		}

		currentweapon = GetCurrentWeapon( localclientnum ); 
		if ( currentweapon != level.weaponZMTeslaGun && currentweapon != level.weaponZMTeslaGunUpgraded )
		{
			continue;
		}

		if ( IsThrowingGrenade( localclientnum ) || IsMeleeing( localclientnum )  || IsOnTurret( localclientnum ) )
		{
			continue;
		}
		
		ammo = GetWeaponAmmoClip( localclientnum, currentweapon );
				
		if ( ammo <= 0 )
		{
			continue;
		}
		
		fx = level._effect["tesla_viewmodel_tube"];
		
		if ( currentweapon == level.weaponZMTeslaGunUpgraded )
		{
			if ( ammo == 3 || ammo == 4 )
			{
				fx = level._effect["tesla_viewmodel_tube2_upgraded"];
			}
			else if ( ammo == 1 || ammo == 2 )
			{
				fx = level._effect["tesla_viewmodel_tube3_upgraded"];
			}
			else
			{
				fx = level._effect["tesla_viewmodel_tube_upgraded"];
			}
		}
		else // regular tesla gun
		{
			if ( ammo == 1 )
			{
				fx = level._effect["tesla_viewmodel_tube3"];
			}
			else if ( ammo == 2 )
			{
				fx = level._effect["tesla_viewmodel_tube2"];
			}
			else
			{
				fx = level._effect["tesla_viewmodel_tube"];
			}
		}
		
		PlayViewmodelFx( localclientnum, fx, "tag_brass" );
	}
}
function tesla_notetrack_think()
{
	for ( ;; )
	{
		level waittill( "notetrack", localclientnum, note );
		
		//println( "@@@ Got notetrack: " + note + " for client: " + localclientnum );
		
		switch( note )
		{
		case "tesla_play_fx_off":
			level.tesla_play_fx[localclientnum] = false;			
		break;	
			
		case "tesla_play_fx_on":
			level.tesla_play_fx[localclientnum] = true;			
		break;			
		
		}
	}
}
function tesla_happy( localclientnum )
{
	for(;;)
	{
		level waittill ("TGH");
		currentweapon = GetCurrentWeapon( localclientnum ); 
		if ( currentweapon == level.weaponZMTeslaGun || currentweapon == level.weaponZMTeslaGunUpgraded )
		{
			playsound(localclientnum,"wpn_tesla_happy", (0,0,0));
			level.tesla_play_rail = false;
			waitrealtime(2);
			level.tesla_play_rail = true;
		}
		
	}

}



