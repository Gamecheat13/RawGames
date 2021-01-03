#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\dev_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\load_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;

#using scripts\cp\_laststand;
#using scripts\cp\killstreaks\_killstreaks;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

//#using scripts\cp\common_scripts\utility;

/#

#namespace devgui;



	







function autoexec __init__sytem__() {     system::register("devgui",&__init__,undefined,undefined);    }

function __init__()
{
	SetDvar( "coop_devgui", "" );
	SetDvar( "coop_devgui_player", "" );
	SetDvar( "cp_weap_devgui", "" );
	SetDvar( "debug_center_screen", 0 );
	SetDvar( "cp_attachment_devgui", "" );
	SetDvar( "cp_weap_use_give_console_command_devgui", 0 );
	SetDvar( "cp_weap_asset_name_display_devgui", 0 );
	SetDvar( "cp_weap_devgui_player", "" );
	
	thread devgui_think();
	thread devgui_weapon_think();
	thread devgui_weapon_asset_name_display_think();
	thread devgui_test_chart_think();

	// center lines for making sure the gun aims properly
	thread init_debug_center_screen();

	level thread dev::body_customization_devgui( "cp" );

	callback::on_start_gametype( &devgui_player_commands );
	callback::on_connect( &devgui_player_connect );
	callback::on_disconnect( &devgui_player_disconnect );
}


function devgui_player_commands()
{
	level flag::wait_till("all_players_spawned" );

	rootclear = "devgui_remove \"Player/All\" \n";
	AddDebugCommand( rootclear );
	players = GetPlayers();
	foreach ( player in GetPlayers() )
	{
		rootclear = "devgui_remove \"Player/"+ player.playername + "\" \n";
		AddDebugCommand( rootclear );
	}
	
	// make sure this happens after the menus are deleted
	thread devgui_player_weapons();
	
	level.player_devgui_base = "devgui_cmd \"Player/";

	devgui_add_player_commands( level.player_devgui_base, "All", 0);
	
	players = GetPlayers();
	for ( i=0; i<players.size; i++ )
	{
		ip1 = i+1;
		devgui_add_player_commands( level.player_devgui_base, players[i].playername, ip1);
	}
}

function devgui_player_connect()
{
	if ( !isdefined( level.player_devgui_base ) )
		return;
	
	players = GetPlayers();
	for ( i=0; i<players.size; i++ )
	{
		if ( players[i] != self )
			continue;
		
		devgui_add_player_commands( level.player_devgui_base, players[i].playername, i+1);
	}
	
}


function devgui_player_disconnect()
{
	if ( !isdefined( level.player_devgui_base ) )
		return;
	
	rootclear = "devgui_remove \"Player/"+ self.playername + "\" \n";
	AddDebugCommand( rootclear );
}


function devgui_add_player_commands( root, pname, index)
{
	player_devgui_root = root + pname + "/";
	pid = "" + index;		
	
	devgui_add_player_command( player_devgui_root, pid, "Invulnerable", 1, "invul_on" );
	devgui_add_player_command( player_devgui_root, pid, "Vulnerable", 2, "invul_off" );
	devgui_add_player_command( player_devgui_root, pid, "Ignore Toggle", 3, "ignore" );
	devgui_add_player_command( player_devgui_root, pid, "Megahealth Toggle", 4, "health" );
	devgui_add_player_command( player_devgui_root, pid, "Infinite Ammo Toggle", 5, "ammo" );
	devgui_add_player_command( player_devgui_root, pid, "Down", 6, "kill" );
	devgui_add_player_command( player_devgui_root, pid, "Infinite SOLO revives", 7, "infiniteSOLO" );
	devgui_add_player_command( player_devgui_root, pid, "Revive", 8, "revive" );
}

function devgui_add_player_command( root, pid, cmdname, cmdindex, cmddvar)
{
	AddDebugCommand( root + cmdname + "\" \"set " + "coop_devgui_player" + " " + pid + ";set " + "coop_devgui" + " " + cmddvar + "\" \n");
}

function devgui_handle_player_command( cmd, playercallback, pcb_param )
{
	pid = GetDvarInt( "coop_devgui_player" );
	if (pid>0)
	{
		player = GetPlayers()[pid-1];
		if (IsDefined(player))
		{
			if (IsDefined( pcb_param ))
				player thread [[playercallback]]( pcb_param );
			else
				player thread [[playercallback]]();
		}
	}
	else
	{
		array::thread_all( GetPlayers(), playercallback, pcb_param );	
	}
	SetDvar( "coop_devgui_player", "-1" );
}

function devgui_think()
{
	for ( ;; )
	{
		cmd = GetDvarString( "coop_devgui" );
		if (cmd=="")
		{
			{wait(.05);};
			continue;
		}

		switch ( cmd )
		{
		case "health":
			devgui_handle_player_command( cmd, &devgui_give_health );
			break;
		case "ammo":
			devgui_handle_player_command( cmd, &devgui_toggle_ammo );
			break;
		case "ignore":
			devgui_handle_player_command( cmd, &devgui_toggle_ignore );
			break;
		case "invul_on":
			devgui_handle_player_command( cmd, &devgui_invulnerable, true );
			break;
		case "invul_off":
			devgui_handle_player_command( cmd, &devgui_invulnerable, false );
			break;
		case "kill":
			devgui_handle_player_command( cmd, &devgui_kill );
			break;
		case "revive":
			devgui_handle_player_command( cmd, &devgui_revive );
			break;
		case "infiniteSOLO":
			devgui_handle_player_command( cmd, &devgui_toggle_infiniteSOLO );
			break;
			
		case "":
			break;

		default:
			if ( IsDefined( level.custom_devgui ) )
			{
				if ( IsArray( level.custom_devgui ) )
				{
					foreach( devgui in level.custom_devgui )
					{
						if ( ( isdefined( [[ devgui ]]( cmd ) ) && [[ devgui ]]( cmd ) ) )
							break;
					}
				}
				else 
				{
					[[level.custom_devgui]]( cmd );
				}
			}
			else
			{
				//iprintln( "Unknown devgui command: '" + cmd + "'" );
			}
			break;
		}
	
		SetDvar( "coop_devgui", "" );
		wait( 0.5 );
	}
}

function devgui_invulnerable( onoff )
{
	if (onoff)
		self EnableInvulnerability();
	else
		self DisableInvulnerability();
}

function devgui_kill()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	
	if ( IsAlive( self ) )
	{
		self DisableInvulnerability();
		
		death_from = (RandomFloatRange(-20,20),RandomFloatRange(-20,20),RandomFloatRange(-20,20));
		self dodamage(self.health + 666, self.origin + death_from);
	}
}

function devgui_toggle_ammo()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	self notify("devgui_toggle_ammo");
	self endon("devgui_toggle_ammo");
	
	self.ammo4evah = !( isdefined( self.ammo4evah ) && self.ammo4evah );

	while ( isdefined(self) && self.ammo4evah )
	{
		weapon = self GetCurrentWeapon();
		if ( weapon != level.weaponNone )
		{
			self SetWeaponOverheating( 0,0 );
			max = weapon.maxAmmo;
			if ( isdefined( max ) )
				self SetWeaponAmmoStock( weapon, max );
		}
		wait 1;
	}
}

function devgui_toggle_ignore()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	self.ignoreme = !self.ignoreme;
}

function devgui_toggle_infiniteSOLO()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	self.infinite_solo_revives = !self.infinite_solo_revives;
}

function devgui_revive()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	self reviveplayer(); 
	
	if ( IsDefined( self.revivetrigger ) )
	{
		self.revivetrigger delete();
		self.revivetrigger = undefined;
	}
	
	self laststand::cleanup_suicide_hud();
	self laststand::laststand_enable_player_weapons();
	
	self AllowJump( true );
	
	self.ignoreme = false;
	self DisableInvulnerability();
	self.laststand = undefined;
	
	self notify("player_revived",self);
}

function maintain_maxhealth( maxhealth )
{
	self endon("disconnect");
	self endon("devgui_give_health");
	while(1)
	{
		wait 1;
		if ( self.maxhealth != maxhealth )
		{
			self.maxhealth = maxhealth;
			self.health = self.maxhealth;
		}
	}
}



function devgui_give_health()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );

	self notify("devgui_give_health");
	
	if ( self.maxhealth >= 2000 && IsDefined(self.orgmaxhealth))
	{
		self.maxhealth = self.orgmaxhealth;
	}
	else
	{
		self.orgmaxhealth = self.maxhealth;
		self.maxhealth = 2000;
		self thread maintain_maxhealth(self.maxhealth);
	}
	self.health = self.maxhealth;
}

function devgui_player_weapons()
{
	if ( ( isdefined( game["devgui_weapons_added"] ) && game["devgui_weapons_added"] ) )
	{
		return;
	}

	level flag::wait_till("all_players_spawned" );
	wait( 0.1 );
	a_weapons = EnumerateWeapons( "weapon" );
	
	a_weapons_cp = [];
	a_grenades_cp = [];
	a_misc_cp = [];
	
	for ( i = 0; i < a_weapons.size; i++ )
	{
		if ( ( weapons::is_primary_weapon( a_weapons[i] ) || weapons::is_side_arm( a_weapons[i] ) ) && !killstreaks::is_killstreak_weapon( a_weapons[i] ) )
		{
			ArrayInsert( a_weapons_cp, a_weapons[i], 0 );
		}
		else if ( weapons::is_grenade( a_weapons[i] ) )
		{
			ArrayInsert( a_grenades_cp, a_weapons[i], 0 );
		}
		else
		{
			ArrayInsert( a_misc_cp, a_weapons[i], 0 );
		}
	}
	
	player_devgui_base_cp = "devgui_cmd \"Player/";
		
	AddDebugCommand( player_devgui_base_cp + "All" + "/Weapons/Toggle Use Give Cmd\" \"toggle " + "cp_weap_use_give_console_command_devgui" + " 1 0\" \n");
	AddDebugCommand( player_devgui_base_cp + "All" + "/Weapons/Toggle Debug Center Screen\" \"toggle " + "debug_center_screen" + " 1 0\" \n");
	AddDebugCommand( player_devgui_base_cp + "All" + "/Weapons/Toggle Weapon Asset Name Display\" \"toggle " + "cp_weap_asset_name_display_devgui" + " 1 0\" \n");

	devgui_add_player_weapons( player_devgui_base_cp, "All", 0, a_grenades_cp, "Grenades" );
	devgui_add_player_weapons( player_devgui_base_cp, "All", 0, a_weapons_cp, "Guns" );
	devgui_add_player_weapons( player_devgui_base_cp, "All", 0, a_misc_cp, "Misc");
	devgui_add_player_gun_attachments( player_devgui_base_cp, "All", 0, a_weapons_cp, "Attachments" );
	
	players = GetPlayers();

	for ( i = 0; i < players.size; i++ )
	{
		ip1 = i+1;

		AddDebugCommand( player_devgui_base_cp + players[i].playername + "/Weapons/Toggle Use Give Cmd\" \"toggle " + "cp_weap_use_give_console_command_devgui" + " 1 0\" \n");
		AddDebugCommand( player_devgui_base_cp + players[i].playername + "/Weapons/Toggle Debug Center Screen\" \"toggle " + "debug_center_screen" + " 1 0\" \n");
		AddDebugCommand( player_devgui_base_cp + players[i].playername + "/Weapons/Toggle Weapon Asset Name Display\" \"toggle " + "cp_weap_asset_name_display_devgui" + " 1 0\" \n");
		devgui_add_player_weapons( player_devgui_base_cp, players[i].playername, ip1, a_grenades_cp, "Grenades" );
		devgui_add_player_weapons( player_devgui_base_cp, players[i].playername, ip1, a_weapons_cp, "Guns" );
		devgui_add_player_weapons( player_devgui_base_cp, players[i].playername, ip1, a_misc_cp, "Misc" );
		devgui_add_player_gun_attachments( player_devgui_base_cp, players[i].playername, ip1, a_weapons_cp, "Attachments" );
	}
	

	game["devgui_weapons_added"] = true;
}

function devgui_add_player_gun_attachments( root, pname, index, a_weapons, weapon_type )
{
	player_devgui_root = root + pname +  "/" + "Weapons/" + weapon_type + "/";
	attachments = [];

	foreach( weapon in a_weapons )
	{
		foreach( supportedAttachment in weapon.supportedAttachments )
		{
			array::add( attachments, supportedAttachment, false )	;
		}
	}
	
	pid = "" + index;
	
	foreach( att in attachments )
	{
		devgui_add_player_attachment_command( player_devgui_root, pid, att, 1 );
	}
}

function devgui_add_player_weapons( root, pname, index, a_weapons, weapon_type )
{
	player_devgui_root = root + pname +  "/" + "Weapons/" + weapon_type + "/";
	pid = "" + index;		
	
	if ( IsDefined( a_weapons ) )
	{
		for ( i = 0; i < a_weapons.size; i++ )
		{
			if ( weapon_type == "Guns" ) // treating gun attachments seperately
			{
				attachments = [];
			}
			else
			{
				attachments = a_weapons[i].supportedAttachments;
			}
				
			name = a_weapons[i].name;
			
			if ( attachments.size )
			{
				devgui_add_player_weap_command( player_devgui_root + name + "/", pid, name, i + 1 );
				
				foreach( att in attachments )
				{
					if ( att != "none" )
					{
						devgui_add_player_weap_command( player_devgui_root + name + "/", pid, name + "+" + att, i + 1 );
					}
				}
			}
			else
			{
				devgui_add_player_weap_command( player_devgui_root, pid, name, i + 1 );
			}
		}
	}
}

function devgui_add_player_weap_command( root, pid, weap_name, cmdindex )
{
	AddDebugCommand( root + weap_name +  "\" \"set " + "cp_weap_devgui_player" + " " + pid + ";set " + "cp_weap_devgui" + " " + weap_name + "\" \n");
}

function devgui_add_player_attachment_command( root, pid, attachment_name, cmdindex )
{
	AddDebugCommand( root + attachment_name + "\" \"set " + "cp_weap_devgui_player" + " " + pid + ";set " + "cp_attachment_devgui" + " " + attachment_name + "\" \n");
}

function devgui_weapon_think()
{
	for ( ;; )
	{
		weapon_name = GetDvarString( "cp_weap_devgui" );

		if ( weapon_name != "" )
		{
			devgui_handle_player_command( weapon_name, &devgui_give_weapon, weapon_name );
			SetDvar( "cp_weap_devgui", "" );
		}
		
		attachmentname = GetDvarString( "cp_attachment_devgui" );
		
		if ( attachmentname != "" )
		{
			devgui_handle_player_command( attachmentname, &devgui_give_attachment, attachmentname );
			SetDvar( "cp_attachment_devgui", "" );
		}
	
		wait( 0.5 );
	}
}

function devgui_weapon_asset_name_display_think()
{
	update_time = 0.5;

	print_duration = Int( update_time / .05 );

	printlnbold_update = Int( 1 / update_time );
	printlnbold_counter = 0;

	colors = [];
	colors[colors.size] = (1, 1, 1);
	colors[colors.size] = (1, 0, 0);
	colors[colors.size] = (0, 1, 0);
	colors[colors.size] = (1, 1, 0);
	colors[colors.size] = (1, 0, 1);
	colors[colors.size] = (0, 1, 1);

	for ( ;; )
	{
		wait( update_time );

		display = GetDvarInt( "cp_weap_asset_name_display_devgui" );

		if ( !display )
		{
			continue;
		}

		if ( !printlnbold_counter )
		{
			iPrintLnBold( level.players[0] GetCurrentWeapon().name );
		}
		printlnbold_counter++;
		if ( printlnbold_counter >= printlnbold_update )
		{
			printlnbold_counter = 0;
		}

		color_index = 0;
		for ( i = 1; i < level.players.size; i++ )
		{
			player = level.players[i];
			weapon = player GetCurrentWeapon();

			if ( !IsDefined( weapon ) || level.weaponNone == weapon )
			{
				continue;
			}

			Print3D( player GetTagOrigin( "tag_flash" ), weapon.name, colors[color_index], 1, 0.15, print_duration );

			color_index++;
			if ( color_index >= colors.size )
			{
				color_index = 0;
			}
		}

		color_index = 0;
		ai_list = GetAIArray();
		for ( i = 0; i < ai_list.size; i++ )
		{
			ai = ai_list[i];
			if ( IsVehicle( ai ) )
			{
				weapon = ai.turretweapon;
			}
			else
			{
				weapon = ai.weapon;
			}

			if ( !IsDefined( weapon ) || level.weaponNone == weapon )
			{
				continue;
			}

			Print3D( ai GetTagOrigin( "tag_flash" ), weapon.name, colors[color_index], 1, 0.15, print_duration );

			color_index++;
			if ( color_index >= colors.size )
			{
				color_index = 0;
			}
		}
	}
}

function devgui_test_chart_think()
{
	{wait(.05);}; // wait to get 0 initially

	old_val = GetDvarInt( "scr_debug_test_chart" );

	for ( ;; )
	{
		val = GetDvarInt( "scr_debug_test_chart" );

		if ( old_val != val )
		{
			if ( IsDefined( level.test_chart_model ) )
			{
				level.test_chart_model delete();
				level.test_chart_model = undefined;
			}

			if ( val )
			{
				player = GetPlayers()[0];

				direction = player GetPlayerAngles();
				direction_vec = AnglesToForward( (0, direction[1], 0) ); // only want the player's yaw

				scale = 120;
				direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);

				level.test_chart_model = Spawn( "script_model", player GetEye() + direction_vec );
				level.test_chart_model SetModel( "test_chart_model" );
				level.test_chart_model.angles = (0, direction[1], 0) + (0, 90, 0); // only want the yaw
			}
		}

		old_val = val;
		{wait(.05);};
	}
}

function devgui_give_weapon( weapon_name )
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	self notify( "devgui_give_ammo" );
	self endon( "devgui_give_ammo" );
	
	currentWeapon = self GetCurrentWeapon();

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
	}
	
	if ( currentWeapon != weapon )
	{
		if ( GetDvarInt( "cp_weap_use_give_console_command_devgui" ) )
		{
			AddDebugCommand( "give " + weapon_name );
			{wait(.05);}; // wait a frame to let the command take
		}
		else
		{
			self TakeWeapon( currentWeapon );
			
			self GiveWeapon( weapon );
			self SwitchToWeapon( weapon );
		}
		
		max = weapon.maxAmmo;
	
		if ( max )
		{
			self SetWeaponAmmoStock( weapon, max );
		}
	}
}

function devgui_give_attachment( attachment_name )
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	self notify( "devgui_give_attachment" );
	self endon( "devgui_give_attachment" );
	
	currentWeapon = self GetCurrentWeapon();
	
	attachmentSupported = false;
	
	split = StrTok( currentWeapon.name, "+" );
	
	foreach( attachment in currentWeapon.supportedAttachments )
	{
		if ( attachment == attachment_name ) 
		{
			attachmentSupported = true;
		}
	}
	if ( attachmentSupported == false )
	{
		iprintlnbold( "Attachment " + attachment_name + " is not supported for " + split[0] );
		attachmentsString = "Supported: ";
		if ( currentWeapon.supportedAttachments.size == 0 )
		{
			attachmentsString = attachmentsString + " none";
		}
		foreach( attachment in currentWeapon.supportedAttachments )
		{
			attachmentsString += "+" + attachment;
		}
		iprintlnbold( attachmentsString );
		return;
	}
	
	foreach( currentAttachment in split )
	{
		if ( currentAttachment == attachment_name )
		{
			iprintlnbold( "Attachment " + attachment_name + " is already attached to " + currentWeapon.name );
			return;
		}
	}
	
	split[split.size] = attachment_name;
	for ( index = split.size; index < 9; index++ )
	{
		split[index] = "none";
	}

	self TakeWeapon( currentWeapon );	
	newWeapon = GetWeapon( split[0], split[1], split[2], split[3], split[4], split[5], split[6], split[7], split[8] );
	self GiveWeapon( newWeapon );
	self SwitchToWeapon( newWeapon );
	
}

// *** Debug the Center of the Screen ***
// Allows you to draw a large crosshair in the center of the screen by pressing in both sticks at once
function init_debug_center_screen()
{
	zero_idle_movement = "0";

	for (;;)
	{
		if( GetDvarInt( "debug_center_screen" ) )
		{
			if (!isdefined (level.center_screen_debug_hudelem_active) || level.center_screen_debug_hudelem_active == false)
			{							
				thread debug_center_screen();

				zero_idle_movement = GetDvarString( "zero_idle_movement" );
				if(  isdefined( zero_idle_movement ) && zero_idle_movement == "0" )
				{
					SetDvar( "zero_idle_movement", "1" );
					zero_idle_movement = "1";
				}
			}
		}
		else
		{	
			level notify ("stop center screen debug");

			if(  zero_idle_movement == "1" )
			{
				SetDvar( "zero_idle_movement", "0" );
				zero_idle_movement = "0";
			}
		}
		wait (0.05);
	}
}

// draws the center screen debug marker
function debug_center_screen()
{	
	level.center_screen_debug_hudelem_active = true;	
	wait 0.1;
			
	level.center_screen_debug_hudelem1 = newclienthudelem ( level.players[0] );
	level.center_screen_debug_hudelem1.alignX = "center";   
 	level.center_screen_debug_hudelem1.alignY = "middle";   
 	level.center_screen_debug_hudelem1.fontScale = 1;
 	level.center_screen_debug_hudelem1.alpha = 0.5;
 	level.center_screen_debug_hudelem1.x = (640/2) - 1;
 	level.center_screen_debug_hudelem1.y = (480/2);	
	level.center_screen_debug_hudelem1 setshader("white", 1000, 1);
	
	level.center_screen_debug_hudelem2 = newclienthudelem ( level.players[0] );
	level.center_screen_debug_hudelem2.alignX = "center";   
 	level.center_screen_debug_hudelem2.alignY = "middle";   
 	level.center_screen_debug_hudelem2.fontScale = 1;
 	level.center_screen_debug_hudelem2.alpha = 0.5;
 	level.center_screen_debug_hudelem2.x = (640/2) - 1;
 	level.center_screen_debug_hudelem2.y = (480/2);
	level.center_screen_debug_hudelem2 setshader("white", 1, 480);	
	
	level waittill ("stop center screen debug");
	
	level.center_screen_debug_hudelem1 destroy();
	level.center_screen_debug_hudelem2 destroy();
	level.center_screen_debug_hudelem_active = false;
}

#/
