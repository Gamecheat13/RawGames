
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\load_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

//#using scripts\shared\hud_shared;

#namespace savegame;

function autoexec __init__sytem__() {     system::register("save",&__init__,undefined,undefined);    }

function __init__()
{
	if(!isdefined(world.loadout))world.loadout=[];
	if(!isdefined(world.mapdata))world.mapdata=[];
	if(!isdefined(world.playerdata))world.playerdata=[];
}

//-----------------------------------------------------------------------------

function checkpoint_save()
{
	if(!isdefined(world.loadout))world.loadout=[];
	level show_checkpoint_reached();
}

function checkpoint_load()
{
}

//-----------------------------------------------------------------------------
// temp HUD
//-----------------------------------------------------------------------------








	
function show_checkpoint_reached()
{
	self endon("disconnect");
	self notify( "show_checkpoint_reached" );
	self endon( "show_checkpoint_reached" );

	if (!IsDefined(self.cpHUD))
	{
		self.cpHUD = NewHudElem();
		self.cpHUD.location = 0;
		self.cpHUD.alignX = "left";
		self.cpHUD.alignY = "top";
		self.cpHUD.foreground = 0;
		self.cpHUD.fontScale = 1.5;
		self.cpHUD.sort = 20;
		self.cpHUD.alpha = 0;
		self.cpHUD.x = 125;
		self.cpHUD.y = 20;
		self.cpHUD.og_scale = 2;
		self.cpHUD.color = ( 0.8, 0.8, 0.8 );
		self.cpHUD.font = "small";
	}

	self.cpHUD SetText( &"EXE_CHECKPOINT_REACHED" );			
	
	self.cpHUD FadeOverTime( 0.25 );
	self.cpHUD.alpha = 1;
	
	wait 0.25;
	wait 3.0;

	self.cpHUD FadeOverTime( 0.75 );
	self.cpHUD.alpha = 0;
	wait 0.75;
}

//-----------------------------------------------------------------------------
// MISSION NAME:
//-----------------------------------------------------------------------------

function set_mission_name(name)
{
	if ( IsDefined(level.savename) && level.savename != name )
	{
		/#
			ErrorMsg("Error: Changing level save name from "+level.savename+" to "+name+" expect some data loss" );
		#/
	}
	level.savename = name;
}

function get_mission_name()
{
	if ( !IsDefined(level.savename) )
	{
		set_mission_name(level.script);
	}
	return level.savename;
}


//-----------------------------------------------------------------------------
// MISSION DATA:
// - Used to save persistent data on a "level" basis
//-----------------------------------------------------------------------------

function set_mission_data(name,value)
{
	id = get_mission_name();
	if(!isdefined(world.mapdata))world.mapdata=[];
	if(!isdefined(world.mapdata[id]))world.mapdata[id]=[];
	world.mapdata[id][name]=value;
}

function get_mission_data(name,defval)
{
	id = get_mission_name();
	if ( IsDefined(world.mapdata) && IsDefined(world.mapdata[id]) && IsDefined(world.mapdata[id][name]) )
		return world.mapdata[id][name];
	return defval;		
}

function clear_mission_data()
{
	id = get_mission_name();
	if ( IsDefined(world.mapdata) && IsDefined( world.mapdata[id]) )
		world.mapdata[id] = [];
}

//-----------------------------------------------------------------------------
// PLAYER DATA:
// - Used to save persistent data per player
//-----------------------------------------------------------------------------

function private get_player_unique_id()
{
	//guid = self GetGuid(); 
	//if ( isDefined(guid) )
	//	return guid;
	return self.playername;
}

function set_player_data(name,value)
{
	id = self get_player_unique_id();
	if(!isdefined(world.playerdata))world.playerdata=[];
	if(!isdefined(world.playerdata[id]))world.playerdata[id]=[];
	world.playerdata[id][name]=value;
}

function get_player_data(name,defval)
{
	id = self get_player_unique_id();
	if ( IsDefined(world.playerdata) && IsDefined(world.playerdata[id]) && IsDefined(world.playerdata[id][name]) )
		return world.playerdata[id][name];
	return defval;		
}

function clear_player_data()
{
	id = self get_player_unique_id();
	if ( IsDefined(world.playerdata) && IsDefined( world.playerdata[id]) )
		world.playerdata[id] = [];
}

//-----------------------------------------------------------------------------
//  weapondata
// This should probably be moved into some other file

function get_weapon_by_name( weapon_name )
{
	split = StrTok( weapon_name, "+" );
	switch ( split.size )
	{
		default:
		case 1:
			weapon = GetWeapon( split[0] );
			break;
		case 2:
			weapon = GetWeapon( split[0], split[1] );
			break;
		case 3:
			weapon = GetWeapon( split[0], split[1], split[2] );
			break;
		case 4:
			weapon = GetWeapon( split[0], split[1], split[2], split[3] );
			break;
		case 5:
			weapon = GetWeapon( split[0], split[1], split[2], split[3], split[4] );
			break;
		case 6:
			weapon = GetWeapon( split[0], split[1], split[2], split[3], split[4], split[5] );
			break;
		case 7:
			weapon = GetWeapon( split[0], split[1], split[2], split[3], split[4], split[5], split[6] );
			break;
		case 8:
			weapon = GetWeapon( split[0], split[1], split[2], split[3], split[4], split[5], split[6], split[7] );
			break;
		case 9:
			weapon = GetWeapon( split[0], split[1], split[2], split[3], split[4], split[5], split[6], split[7], split[8] );
			break;
	}
	return weapon;
}
function get_player_weapondata(player, weapon)
{
	weapondata = [];

	if ( !isdefined( weapon ) )
	{
		weapon = player GetCurrentWeapon();
	}

	weapondata["weapon"] = weapon.name;

	if ( weapon != level.weaponNone )
	{
		weapondata["clip"] = player GetWeaponAmmoClip( weapon );
		weapondata["stock"] = player GetWeaponAmmoStock(weapon );
		weapondata["fuel"] = player GetWeaponAmmoFuel( weapon );
		weapondata["heat"] = player IsWeaponOverheating( 1, weapon );
		weapondata["overheat"] = player IsWeaponOverheating( 0, weapon );
		if ( weapon.isRiotShield )
		{
			weapondata["health"] = player.weaponHealth;
		}
	}
	else
	{
		weapondata["clip"] = 0;
		weapondata["stock"] = 0;
		weapondata["fuel"] = 0;
		weapondata["heat"] = 0;
		weapondata["overheat"] = 0;
	}
	if ( weapon.dualWieldWeapon != level.weaponNone )
	{
		weapondata["lh_clip"] = player GetWeaponAmmoClip( weapon.dualWieldWeapon );
	}
	else
	{
		weapondata["lh_clip"] = 0;
	}
	if ( weapon.altWeapon != level.weaponNone )
	{
		weapondata["alt_clip"] = player GetWeaponAmmoClip( weapon.altWeapon );
		weapondata["alt_stock"] = player GetWeaponAmmoStock( weapon.altWeapon );
	}
	else
	{
		weapondata["alt_clip"] = 0;
		weapondata["alt_stock"] = 0;
	}
	return weapondata;
}

function weapondata_give( weapondata )
{
	weapon = get_weapon_by_name( weapondata["weapon"] );

	self GiveWeapon( weapon );
	
	if ( weapon != level.weaponNone )
	{
		self SetWeaponAmmoClip( weapon, weapondata["clip"] );
		self SetWeaponAmmoStock( weapon, weapondata["stock"] );
		if (IsDefined(weapondata["fuel"]))
			self SetWeaponAmmoFuel( weapon, weapondata["fuel"] );
		if (IsDefined(weapondata["heat"]) && IsDefined(weapondata["overheat"]))
			self SetWeaponOverheating( weapondata["overheat"], weapondata["heat"], weapon );
		if ( weapon.isRiotShield && IsDefined(weapondata["health"]) )
		{
			self.weaponHealth = weapondata["health"];
		}
	}
	if ( weapon.dualWieldWeapon != level.weaponNone )
	{
		self SetWeaponAmmoClip( weapon.dualWieldWeapon, weapondata["lh_clip"] );
	}
	if ( weapon.altWeapon != level.weaponNone )
	{
		self SetWeaponAmmoClip( weapon.altWeapon, weapondata["alt_clip"] );
		self SetWeaponAmmoStock( weapon.altWeapon, weapondata["alt_stock"] );
	}
}

