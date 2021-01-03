#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\dev_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\load_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\weapons\_weapons;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\killstreaks\_killstreaks;

/#

#namespace devgui;





























	
function autoexec __init__sytem__() {     system::register("devgui",&__init__,undefined,undefined);    }

function __init__()
{
	SetDvar( "mp_weap_devgui", "" );
	SetDvar( "debug_center_screen", 0 );
	SetDvar( "mp_lockspawn_command_devgui", 0 );
	SetDvar( "mp_weap_use_give_console_command_devgui", 0 );
	SetDvar( "mp_weap_asset_name_display_devgui", 0 );
	SetDvar( "mp_weap_attachment_cosmetic_variant_index_devgui", 0 );
	SetDvar( "mp_weap_attachment_cosmetic_variant_attachment_1_devgui", "none" );
	SetDvar( "mp_weap_attachment_cosmetic_variant_attachment_2_devgui", "none" );

	SetDvar( "mp_attachment_cycling_state_devgui", "none" );

	SetDvar( "mp_attachment_cycling_1_devgui", "none" );
	SetDvar( "mp_attachment_cycling_2_devgui", "none" );
	SetDvar( "mp_attachment_cycling_3_devgui", "none" );
	SetDvar( "mp_attachment_cycling_4_devgui", "none" );
	SetDvar( "mp_attachment_cycling_5_devgui", "none" );
	SetDvar( "mp_attachment_cycling_6_devgui", "none" );

	level.attachment_cycling_dvars = [];
	level.attachment_cycling_dvars[level.attachment_cycling_dvars.size] = "mp_attachment_cycling_1_devgui";
	level.attachment_cycling_dvars[level.attachment_cycling_dvars.size] = "mp_attachment_cycling_2_devgui";
	level.attachment_cycling_dvars[level.attachment_cycling_dvars.size] = "mp_attachment_cycling_3_devgui";
	level.attachment_cycling_dvars[level.attachment_cycling_dvars.size] = "mp_attachment_cycling_4_devgui";
	level.attachment_cycling_dvars[level.attachment_cycling_dvars.size] = "mp_attachment_cycling_5_devgui";
	level.attachment_cycling_dvars[level.attachment_cycling_dvars.size] = "mp_attachment_cycling_6_devgui";

	SetDvar( "mp_acv_cycling_1_devgui", 0 );
	SetDvar( "mp_acv_cycling_2_devgui", 0 );
	SetDvar( "mp_acv_cycling_3_devgui", 0 );
	SetDvar( "mp_acv_cycling_4_devgui", 0 );
	SetDvar( "mp_acv_cycling_5_devgui", 0 );
	SetDvar( "mp_acv_cycling_6_devgui", 0 );

	level.acv_cycling_dvars = [];
	level.acv_cycling_dvars[level.acv_cycling_dvars.size] = "mp_acv_cycling_1_devgui";
	level.acv_cycling_dvars[level.acv_cycling_dvars.size] = "mp_acv_cycling_2_devgui";
	level.acv_cycling_dvars[level.acv_cycling_dvars.size] = "mp_acv_cycling_3_devgui";
	level.acv_cycling_dvars[level.acv_cycling_dvars.size] = "mp_acv_cycling_4_devgui";
	level.acv_cycling_dvars[level.acv_cycling_dvars.size] = "mp_acv_cycling_5_devgui";
	level.acv_cycling_dvars[level.acv_cycling_dvars.size] = "mp_acv_cycling_6_devgui";

	level thread devgui_weapon_think();
	level thread devgui_weapon_asset_name_display_think();
	level thread devgui_player_weapons();
	level thread devgui_test_chart_think();
	level thread devgui_player_spawn_think();

	// center lines for making sure the gun aims properly
	thread init_debug_center_screen();

	level thread dev::body_customization_devgui( 1 );
		
	callback::on_connect( &hero_art_on_player_connect );
	callback::on_connect( &on_player_connect );
}

function on_player_connect()
{
	/#
		self.devguiLockSpawn = false;
		self thread devgui_player_spawn();
	#/
}

function devgui_player_spawn()
{
	wait(1);
	
	player_devgui_base_mp = "devgui_cmd \"Player/Lock Spawn/";

	{wait(.05);}; // so we don't overflow the Cbuf_InsertText()

	players = GetPlayers();
	foreach( player in players )
	{
		if ( player != self )
			continue;

		temp = player_devgui_base_mp + player.playername + "\" \"set " + "mp_lockspawn_command_devgui" + " " + player.playername + "\"\n";
		
		AddDebugCommand( player_devgui_base_mp + player.playername + "\" \"set " + "mp_lockspawn_command_devgui" + " " + player.playername + "\"\n");
	}
}

function devgui_player_spawn_think()
{
	for ( ;; )
	{
		playername = GetDvarString( "mp_lockspawn_command_devgui" );
		if (playername=="")
		{
			{wait(.05);};
			continue;
		}

		players = GetPlayers();
		foreach( player in players )
		{
			if ( player.playername != playername )
				continue;
	
			player.devguiLockSpawn = !player.devguiLockSpawn;
			if ( player.devguiLockSpawn )
			{
				player.resurrect_origin = player.origin;
				player.resurrect_angles = player.angles;
			}
		}
	
		SetDvar( "mp_lockspawn_command_devgui", "" );
		wait( 0.5 );
	}
}

function devgui_player_weapons()
{
	if ( ( isdefined( game["devgui_weapons_added"] ) && game["devgui_weapons_added"] ) )
	{
		return;
	}

	level flag::wait_till("all_players_spawned" );
	
	a_weapons = EnumerateWeapons( "weapon" );
	
	a_weapons_mp = [];
	a_grenades_mp = [];	
	a_misc_mp = [];
	
		// For misc weapons not in statstable
	
	for ( i = 0; i < a_weapons.size; i++ )
	{
		if ( ( weapons::is_primary_weapon( a_weapons[i] ) || weapons::is_side_arm( a_weapons[i] ) ) && !killstreaks::is_killstreak_weapon( a_weapons[i] ) )
		{
			ArrayInsert( a_weapons_mp, a_weapons[i], 0 );
		}
		else if ( weapons::is_grenade( a_weapons[i] ) )
		{
			ArrayInsert( a_grenades_mp, a_weapons[i], 0 );
		}
		else
		{
			ArrayInsert( a_misc_mp, a_weapons[i], 0 );
		}
	}
		
	player_devgui_base_mp = "devgui_cmd \"Player/Weapons/";

	menu_index = 1;
	devgui_add_player_weapons( player_devgui_base_mp, "All", 0, a_weapons_mp, "Guns", menu_index );
	menu_index++;
	devgui_add_player_weapons( player_devgui_base_mp, "All", 0, a_grenades_mp, "Grenades", menu_index );
	menu_index++;
	devgui_add_player_weapons( player_devgui_base_mp, "All", 0, a_misc_mp, "Misc", menu_index );
	menu_index++;

	game["devgui_weapons_added"] = true;
	{wait(.05);}; // so we don't overflow the Cbuf_InsertText()

	AddDebugCommand( player_devgui_base_mp + "Toggle Use Give Cmd" + "\" \"toggle " + "mp_weap_use_give_console_command_devgui" + " 1 0\" \n");
	menu_index++;

	AddDebugCommand( player_devgui_base_mp + "Toggle Debug Center Screen" + "\" \"toggle " + "debug_center_screen" + " 1 0\" \n");
	menu_index++;

	AddDebugCommand( player_devgui_base_mp + "Toggle Weapon Asset Name Display" + "\" \"toggle " + "mp_weap_asset_name_display_devgui" + " 1 0\" \n");
	menu_index++;

	acv_devgui_base_mp = player_devgui_base_mp + "Cosmetic Variants" + "/";
	menu_index++;

	acv_menu_index = 1;
	acv_sub_menu_index = 1;
	for ( i = 0; i <= 3; i++ )
	{
		AddDebugCommand( acv_devgui_base_mp + "Variant Index" + "/" + i + "\" \"set " + "mp_weap_attachment_cosmetic_variant_index_devgui" + " " + i + "\" \n");
		acv_sub_menu_index++;
	}
	acv_menu_index++;
	
	attachmentNames = GetAttachmentNames();

	acv_sub_menu_index = 1;
	for ( i = 0; i < attachmentNames.size; i++ )
	{
		if ( IsSubStr( attachmentNames[i], "gmod" ) )
		{
			continue;
		}

		AddDebugCommand( acv_devgui_base_mp + "Attachment 1" + "/" + attachmentNames[i] + "\" \"set " + "mp_weap_attachment_cosmetic_variant_attachment_1_devgui" + " " + attachmentNames[i] + "\" \n");
		acv_sub_menu_index++;
	}
	acv_menu_index++;

	acv_sub_menu_index = 1;
	for ( i = 0; i < attachmentNames.size; i++ )
	{
		if ( IsSubStr( attachmentNames[i], "gmod" ) )
		{
			continue;
		}

		AddDebugCommand( acv_devgui_base_mp + "Attachment 2" + "/" + attachmentNames[i] + "\" \"set " + "mp_weap_attachment_cosmetic_variant_attachment_2_devgui" + " " + attachmentNames[i] + "\" \n");
		acv_sub_menu_index++;
	}
	acv_menu_index++;

	{wait(.05);}; // so we don't overflow the Cbuf_InsertText()

	attachment_cycling_devgui_base_mp = player_devgui_base_mp + "Attachment Cycling" + "/";
	AddDebugCommand( attachment_cycling_devgui_base_mp + "Clear All\" \"set " + "mp_attachment_cycling_state_devgui" + " clear all\" \n");
	AddDebugCommand( attachment_cycling_devgui_base_mp + "Reapply\" \"set " + "mp_attachment_cycling_state_devgui" + " update\" \n");
	
	for ( i = 0; i < 6; i++ )
	{
		attachment_cycling_sub_menu_index = 1;

		AddDebugCommand( attachment_cycling_devgui_base_mp + "Attachment " + (i + 1) + "/Clear:1\" \"set " + "mp_attachment_cycling_state_devgui" + " clear " + i + "\" \n");

		for ( attachmentName = 0; attachmentName < attachmentNames.size; attachmentName++ )
		{
			if ( IsSubStr( attachmentNames[attachmentName], "gmod" ) )
			{
				continue;
			}

			AddDebugCommand( attachment_cycling_devgui_base_mp + "Attachment " + (i + 1) + "/" + attachmentNames[attachmentName] + "\" \"set " + "mp_attachment_cycling_state_devgui" + " update; set " + level.attachment_cycling_dvars[i] + " " + attachmentNames[attachmentName] + "; set " + level.acv_cycling_dvars[i] + " " + 0 + "\" \n");
			attachment_cycling_sub_menu_index++;

			AddDebugCommand( attachment_cycling_devgui_base_mp + "Attachment " + (i + 1) + "/" + attachmentNames[attachmentName] + " Variant 1\" \"set " + "mp_attachment_cycling_state_devgui" + " update; set " + level.attachment_cycling_dvars[i] + " " + attachmentNames[attachmentName] + "; set " + level.acv_cycling_dvars[i] + " " + 1 + "\" \n");
			attachment_cycling_sub_menu_index++;
		}

		if ( i % 2 )
		{
			{wait(.05);}; // so we don't overflow the Cbuf_InsertText()
		}
	}
	
	level thread devgui_attachment_cosmetic_variant_think();
	level thread devgui_attachment_cycling_think();
}

function devgui_add_player_weapons( root, pname, index, a_weapons, weapon_type, mindex )
{
	if( isDedicated() )
	{
		return;
	}
	
	devgui_root = root + weapon_type + "/";
		
	if ( IsDefined( a_weapons ) )
	{
		for ( i = 0; i < a_weapons.size; i++ )
		{
			attachments = a_weapons[i].supportedAttachments;
			name = a_weapons[i].name;
			
			if ( attachments.size )
			{
				devgui_add_player_weap_command( devgui_root + name + "/", index, name, i + 1 );
				
				foreach( att in attachments )
				{
					if ( att != "none" )
					{
						devgui_add_player_weap_command( devgui_root + name + "/", index, name + "+" + att, i + 1 );
					}
				}
			}
			else
			{
				devgui_add_player_weap_command( devgui_root, index, name, i + 1 );
			}
		}
	}
}

function devgui_add_player_weap_command( root, pid, weap_name, cmdindex )
{
	AddDebugCommand( root + weap_name+"\" \"set "+"mp_weap_devgui"+" "+weap_name+"\" \n");
}

function devgui_weapon_think()
{
	for ( ;; )
	{
		weapon_name = GetDvarString( "mp_weap_devgui" );

		if ( weapon_name != "" )
		{
			devgui_handle_player_command( &devgui_give_weapon, weapon_name );
		}
	
		SetDvar( "mp_weap_devgui", "" );
		
		wait( 0.5 );
	}
}

function hero_art_on_player_connect()
{
	self._debugHeroModels = SpawnStruct();
}



function devgui_weapon_asset_name_display_think()
{
	update_time = 1;

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

		display = GetDvarInt( "mp_weap_asset_name_display_devgui" );

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

function devgui_attachment_cosmetic_variant_think()
{
	old_index = 0;
	old_attachment_1 = "none";
	old_attachment_2 = "none";
	for ( ;; )
	{
		index = GetDvarInt( "mp_weap_attachment_cosmetic_variant_index_devgui" );
		attachment_1 = GetDvarString( "mp_weap_attachment_cosmetic_variant_attachment_1_devgui" );
		attachment_2 = GetDvarString( "mp_weap_attachment_cosmetic_variant_attachment_2_devgui" );

		if ( old_attachment_1 != attachment_1 || old_attachment_2 != attachment_2 || old_index != index )
		{
			devgui_handle_player_command( &devgui_update_attachment_cosmetic_variant, attachment_1, attachment_2 );
		}
	
		old_index = index;
		old_attachment_1 = attachment_1;
		old_attachment_2 = attachment_2;
		
		wait( 0.5 );
	}
}

function devgui_attachment_cycling_clear( index )
{
	SetDvar( level.attachment_cycling_dvars[index], "none" );
	SetDvar( level.acv_cycling_dvars[index], 0 );
}

function devgui_attachment_cycling_update()
{
	currentWeapon = self GetCurrentWeapon();

	rootweapon = currentWeapon.rootweapon;
	supportedAttachments = currentWeapon.supportedattachments;

	textColors = [];
	attachments = [];
	acvs = [];
	originalAttachments = [];
	originalAcvs = [];
	for ( i = 0; i < 6; i++ )
	{
		originalAttachments[i] = GetDvarString( level.attachment_cycling_dvars[i] );
		originalAcvs[i] = GetDvarInt( level.acv_cycling_dvars[i] );

		textColor[i] = "^7";
		attachments[i] = "none";
		acvs[i] = 0;

		name = originalAttachments[i];
		if ( "none" == name )
		{
			continue;
		}

		textColor[i] = "^1";
		for ( supportedIndex = 0; supportedIndex < supportedAttachments.size; supportedIndex++ )
		{
			if ( name == supportedAttachments[supportedIndex] )
			{
				textColor[i] = "^7";
				attachments[i] = name;
				acvs[i] = originalAcvs[i];
				break;
			}
		}
	}

	for ( i = 0; i < 6; i++ )
	{
		if ( "none" == originalAttachments[i] )
		{
			continue;
		}

		for ( j = i + 1; j < 6; j++ )
		{
			if ( originalAttachments[i] == originalAttachments[j] )
			{
				textColor[j] = "^6";
				attachments[j] = "none";
				acvs[j] = 0;
			}
		}
	}

	msg = "";
	for ( i = 0; i < 6; i++ )
	{
		if ( "none" == originalAttachments[i] )
		{
			continue;
		}

		msg += textColor[i];
		msg += i;
		msg += ": ";
		msg += originalAttachments[i];
		msg += ", ";
		msg += originalAcvs[i];
		msg += ", ";
	}

	IPrintLnBold( msg );

	self TakeWeapon( currentWeapon );

	currentWeapon = GetWeapon( rootweapon.name, attachments[0], attachments[1], attachments[2], attachments[3], attachments[4], attachments[5] );
	acvi = GetAttachmentCosmeticVariantIndexes( currentWeapon, attachments[0], acvs[0], attachments[1], acvs[1], attachments[2], acvs[2], attachments[3], acvs[3], attachments[4], acvs[4], attachments[5], acvs[5] );

	wait( 0.25 ); // wait a little bit so that the weapon viewmodel will rebuild

	self GiveWeapon( currentWeapon, undefined, acvi );
	self SwitchToWeapon( currentWeapon );
}

function devgui_attachment_cycling_think()
{
	for ( ;; )
	{
		state = GetDvarString( "mp_attachment_cycling_state_devgui" );
		SetDvar( "mp_attachment_cycling_state_devgui", "none" );

		if ( IsSubStr( state, "clear " ) )
		{
			if ( "clear all" == state )
			{
				for ( i = 0; i < 6; i++ )
				{
					devgui_attachment_cycling_clear( i );
				}
			}
			else
			{
				index = Int( GetSubStr( state, 6, 7 ) );
				devgui_attachment_cycling_clear( index );
			}

			state = "update";
		}

		if ( "update" == state )
		{
			array::thread_all( GetPlayers(), &devgui_attachment_cycling_update );	
		}

		wait( 0.5 );
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
		// if the player already has 2 grenades, take one away
		if ( weapon.isGrenadeWeapon )
		{
			grenades = 0;
			pweapons = self GetWeaponsList();
			foreach( pweapon in pweapons )
			{
				if ( pweapon!=weapon && pweapon.isGrenadeWeapon )
				{
					grenades++;
				}
			}
			if ( grenades > 1 )
			{
				foreach( pweapon in pweapons )
				{
					if ( pweapon!=weapon && pweapon.isGrenadeWeapon )
					{
						grenades--;
						self TakeWeapon(pweapon); 
						if ( grenades < 2 )
							break;
					}
				}
			}
		}
		
		if ( GetDvarInt( "mp_weap_use_give_console_command_devgui" ) )
		{
			AddDebugCommand( "give " + weapon_name );
			{wait(.05);}; // wait a frame to let the command take
		}
		else
		{
			self GiveWeapon( weapon );
			if ( !weapon.isGrenadeWeapon )
				self SwitchToWeapon( weapon );
		}

		max = weapon.maxAmmo;
	
		if ( max )
		{
			self SetWeaponAmmoStock( weapon, max );
		}
	}
}

function devgui_update_attachment_cosmetic_variant( attachment_1, attachment_2 )
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	currentWeapon = self GetCurrentWeapon();
	variant_index = GetDvarInt( "mp_weap_attachment_cosmetic_variant_index_devgui" );
	acvi = GetAttachmentCosmeticVariantIndexes( currentWeapon, attachment_1, variant_index, attachment_2, variant_index );
	self TakeWeapon( currentWeapon );
	wait( 0.25 ); // wait a little bit so that the weapon viewmodel will rebuild
	self GiveWeapon( currentWeapon, undefined, acvi );
	self SwitchToWeapon( currentWeapon );
}

function devgui_handle_player_command( playercallback, pcb_param_1, pcb_param_2 )
{
	pid = GetDvarInt( "mp_weap_devgui" );
	if (pid>0)
	{
		player = GetPlayers()[pid-1];
		if (IsDefined(player))
		{
			if (IsDefined( pcb_param_2 ))
				player thread [[playercallback]]( pcb_param_1, pcb_param_2 );
			else if (IsDefined( pcb_param_1 ))
				player thread [[playercallback]]( pcb_param_1 );
			else
				player thread [[playercallback]]();
		}
	}
	else
	{
		array::thread_all( GetPlayers(), playercallback, pcb_param_1, pcb_param_2 );	
	}
	SetDvar( "mp_weap_devgui", "-1" );
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
