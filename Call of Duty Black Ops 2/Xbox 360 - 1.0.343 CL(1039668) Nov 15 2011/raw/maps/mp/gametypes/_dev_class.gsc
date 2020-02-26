// dev module for create-a-class 2.0
#include maps\mp\_utility;

/#

dev_cac_init()
{
	dev_cac_overlay = false;
	dev_cac_camera_on = false;

	level thread dev_cac_gdt_update_think();

	for ( ;; )
	{
		wait( 0.5 );

		reset = true;

		if ( GetDvar( "scr_disable_cac_2" ) != "" )
		{
			continue;
		}
		
		host = GetHostPlayer();

		if ( !IsDefined( level.dev_cac_player ) )
		{
			level.dev_cac_player = host;
		}
				
		switch( GetDvar( "devgui_dev_cac" ) )
		{
			case "":
				reset = false;
				break;
		
			case "dpad_body":
				host thread dev_cac_dpad_think( "body", ::dev_cac_cycle_body, "" );
				break;

			case "dpad_head":
				host thread dev_cac_dpad_think( "head", ::dev_cac_cycle_head, "" );
				break;

			case "dpad_character":
				host thread dev_cac_dpad_think( "character", ::dev_cac_cycle_character, "" );
				break;

			case "next_player":
				dev_cac_cycle_player(true);
				break;

			case "prev_player":
				dev_cac_cycle_player(false);
				break;

			case "cac_overlay":
				level notify( "dev_cac_overlay_think" );

				if ( !dev_cac_overlay )
					level thread dev_cac_overlay_think();

				dev_cac_overlay = !dev_cac_overlay;
				break;

			case "best_bullet_armor":
				dev_cac_set_model_range( ::sort_greatest, "armor_bullet" );
				break;
			case "worst_bullet_armor":
				dev_cac_set_model_range( ::sort_least, "armor_bullet" );
				break;
			case "best_explosive_armor":
				dev_cac_set_model_range( ::sort_greatest, "armor_explosive" );
				break;
			case "worst_explosive_armor":
				dev_cac_set_model_range( ::sort_least, "armor_explosive" );
				break;
			case "best_mobility":
				dev_cac_set_model_range( ::sort_greatest, "mobility" );
				break;
			case "worst_mobility":
				dev_cac_set_model_range( ::sort_least, "mobility" );
				break;

			case "camera":
				dev_cac_camera_on = !dev_cac_camera_on;
				dev_cac_camera( dev_cac_camera_on );
				break;
				
			// Weapon Options:
			case "dpad_camo":
				host thread dev_cac_dpad_think( "camo", ::dev_cac_cycle_render_options, "camo" );
				break;
			
			case "dpad_lens":
				host thread dev_cac_dpad_think( "lens", ::dev_cac_cycle_render_options, "lens" );
				break;

			case "dpad_reticle":
				host thread dev_cac_dpad_think( "reticle", ::dev_cac_cycle_render_options, "reticle" );
				break;

			case "dpad_reticle_color":
				host thread dev_cac_dpad_think( "reticle color", ::dev_cac_cycle_render_options, "reticle_color" );
				break;

			case "dpad_emblem":
				host thread dev_cac_dpad_think( "emblem", ::dev_cac_cycle_render_options, "emblem" );
				break;

			case "dpad_tag":
				host thread dev_cac_dpad_think( "tag", ::dev_cac_cycle_render_options, "tag" );
				break;

			// Facepaint options:
			case "dpad_facepaint_pattern":
				host thread dev_cac_dpad_think( "facepaint pattern", ::dev_cac_cycle_render_options, "facepaint_pattern" );
				break;
				
			case "dpad_facepaint_color":
				host thread dev_cac_dpad_think( "facepaint color", ::dev_cac_cycle_render_options, "facepaint_color" );
				break;
				
			case "dpad_reset":
				host notify( "dev_cac_dpad_think" );
				break;
		}

		if( reset )
		{
			SetDvar( "devgui_dev_cac", "" );
		}
	}
}

dev_cac_camera( on )
{
	if ( on )
	{
		SetDvar( "cg_thirdPerson", "1" );
		SetDvar( "cg_thirdPersonAngle", "185" );
		SetDvar( "cg_thirdPersonRange", "138" );
		SetDvar( "cg_fov", "20" );
	}
	else
	{
		SetDvar( "cg_thirdPerson", "0" );
		SetDvar( "cg_fov", GetDvar( "cg_fov_default" ) );
	}
}

dev_cac_dpad_think( part_name, cycle_function, tag )
{
	self notify( "dev_cac_dpad_think" );
	self endon( "dev_cac_dpad_think" );
	self endon( "disconnect" );

	iprintln( "Previous " + part_name + " bound to D-Pad Left" );
	iprintln( "Next " + part_name + " bound to D-Pad Right" );

	dpad_left = false;
	dpad_right = false;

	// Highlight the player in focus
	level.dev_cac_player thread highlight_player();

	for ( ;; )
	{
		self SetActionSlot( 3, "" );
		self SetActionSlot( 4, "" );

		if ( !dpad_left && self ButtonPressed( "DPAD_LEFT" ) )
		{
			[[cycle_function]]( false, tag );
			dpad_left = true;
		}
		else if ( !self ButtonPressed( "DPAD_LEFT" ) )
		{
			dpad_left = false;
		}

		if ( !dpad_right && self ButtonPressed( "DPAD_RIGHT" )  )
		{
			[[cycle_function]]( true, tag );
			dpad_right = true;
		}
		else if ( !self ButtonPressed( "DPAD_RIGHT" ) )
		{
			dpad_right = false;
		}

		wait( 0.05 );
	}
}

next_in_list( value, list )
{
	if ( !IsDefined( value ) )
		return list[0];
	
	for ( i = 0; i < list.size; i++ )
	{
		if ( value == list[i] )
		{
			if ( IsDefined( list[ i + 1 ] ) )
				value = list[ i + 1 ];
			else
				value = list[0];

			break;
		}
	}

	return value;
}

prev_in_list( value, list )
{
	if ( !IsDefined( value ) )
		return list[0];

	for ( i = 0; i < list.size; i++ )
	{
		if ( value == list[i] )
		{
			if ( IsDefined( list[ i - 1 ] ) )
				value = list[ i - 1 ];
			else
				value = list[ list.size - 1 ];

			break;
		}
	}

	return value;
}

dev_cac_set_player_model()
{
//	self ClearPerks();
	self.tag_stowed_back = undefined;
	self.tag_stowed_hip = undefined;
	
/*
	if ( !self is_bot() )
	{
		specialties = self.custom_class[ self.class_num ][ "specialties" ];

		for ( i = 0; i < specialties.size; i++ )
		{
			if ( specialties[i].name == "specialty_null" )
			{
				continue;
			}

			self SetPerk( specialties[i].name );
		}
	}
*/

	//self set_player_model();
}

dev_cac_cycle_body( forward, tag )
{
	if ( !dev_cac_player_valid() )
	{
		return;
	}

	player = level.dev_cac_player;
	keys = GetArrayKeys( level.cac_functions[ "set_body_model" ] );

	if ( forward )
		player.cac_body_type = next_in_list( player.cac_body_type, keys );
	else
		player.cac_body_type = prev_in_list( player.cac_body_type, keys );

	player dev_cac_set_player_model();
}

dev_cac_cycle_head( forward, tag )
{
	if ( !dev_cac_player_valid() )
	{
		return;
	}

	player = level.dev_cac_player;
	keys = GetArrayKeys( level.cac_functions[ "set_head_model" ] );

	if ( forward )
		player.cac_head_type = next_in_list( player.cac_head_type, keys );
	else 
		player.cac_head_type = prev_in_list( player.cac_head_type, keys );

	player.cac_hat_type = "none";
	player dev_cac_set_player_model();
}

dev_cac_cycle_character( forward, tag )
{
	if ( !dev_cac_player_valid() )
	{
		return;
	}

	player = level.dev_cac_player;
	keys = GetArrayKeys( level.cac_functions[ "set_body_model" ] );

	if ( forward )
		player.cac_body_type = next_in_list( player.cac_body_type, keys );
	else
		player.cac_body_type = prev_in_list( player.cac_body_type, keys );

	//player.cac_head_type = player maps\mp\gametypes\_armor::get_default_head();

	player.cac_hat_type = "none";
	player dev_cac_set_player_model();
}

dev_cac_cycle_render_options( forward, tag )
{
	if ( !dev_cac_player_valid() )
		return;

	level.dev_cac_player NextPlayerRenderOption( tag, forward );
}

dev_cac_player_valid()
{
	return ( IsDefined( level.dev_cac_player ) && level.dev_cac_player.sessionstate == "playing" );
}

dev_cac_cycle_player( forward )
{
	players = GET_PLAYERS();
	
	for( i = 0; i < players.size; i++ ) 
	{
		if ( forward )
			level.dev_cac_player = next_in_list( level.dev_cac_player, players );
		else
			level.dev_cac_player = prev_in_list( level.dev_cac_player, players );

		if ( dev_cac_player_valid() )
		{
			level.dev_cac_player thread highlight_player();
			return;
		}
	}

	level.dev_cac_player = undefined;
}

highlight_player()
{
	self SetHighlighted( true );
	wait( 1.0 );
	self SetHighlighted( false );
}

dev_cac_overlay_think()
{
	hud = dev_cac_overlay_create();
	level thread dev_cac_overlay_update( hud );

	level waittill( "dev_cac_overlay_think" );
	dev_cac_overlay_destroy( hud );
}

dev_cac_overlay_update( hud )
{
/*
	level endon( "dev_cac_overlay_think" );

	for ( ;; )
	{
		wait( 0.05 );

		if ( !dev_cac_player_valid() )
		{
			SetDvar( "player_debugSprint", "0" );
			continue;
		}

		player = level.dev_cac_player;

		if ( player == GetHostPlayer() )
		{
			SetDvar( "player_debugSprint", "1" );
		}
		else
		{
			SetDvar( "player_debugSprint", "0" );
		}

		// name
		hud.menu[0] SetText( player.name );

		// models
		hud.menu[25] SetText( player.cac_body_type );
		hud.menu[26] SetText( player.cac_head_type );
		hud.menu[27] SetText( player.cac_hat_type );

		// mobility
		hud.menu[28].color	= color( player get_mobility_body() );
		hud.menu[29].color	= color( player get_mobility_head() );
		hud.menu[28]		SetValue( player get_mobility_body() );
		hud.menu[29]		SetValue( player get_mobility_head() );
		hud.menu[30]		SetValue( player GetMoveSpeedScale() );
		hud.menu[31]		SetValue( player get_sprint_duration() );
		hud.menu[32]		SetValue( player get_sprint_cooldown() );

		// armor - bullet
		hud.menu[33].color	= color( player get_armor_bullet_body() );
		hud.menu[34].color	= color( player get_armor_bullet_head() );
		hud.menu[33]		SetValue( player get_armor_bullet_body() );
		hud.menu[34]		SetValue( player get_armor_bullet_head() );

		// armor - explosive
		hud.menu[35].color	= color( player get_armor_explosive_body() );
		hud.menu[36].color	= color( player get_armor_explosive_head() );
		hud.menu[35]		SetValue( player get_armor_explosive_body() );
		hud.menu[36]		SetValue( player get_armor_explosive_head() );

		// damage
		if ( IsDefined( player.cac_debug_damage_type ) )
		{
			diff = player.cac_debug_final_damage - player.cac_debug_original_damage;
							
			hud.menu[37]	SetText( player.cac_debug_damage_type );
			hud.menu[38]	SetValue( player.cac_debug_original_damage );
			hud.menu[39]	SetValue( player.cac_debug_final_damage );
			hud.menu[40]	SetValue( diff );
			hud.menu[41]	SetText( player.cac_debug_location );
			hud.menu[42]	SetText( player.cac_debug_weapon );
			hud.menu[43]	SetText( player.cac_debug_range );
		}
		else
		{
			hud.menu[37]	SetText( "" );
			hud.menu[38]	SetText( "" );
			hud.menu[39]	SetText( "" );
			hud.menu[40]	SetText( "" );
			hud.menu[41]	SetText( "" );
			hud.menu[42]	SetText( "" );
			hud.menu[43]	SetText( "" );
		}
	}
*/
}

dev_cac_overlay_destroy( hud )
{
	for ( i = 0; i < hud.menu.size; i++ )
	{
		hud.menu[i] Destroy();
	}

	hud Destroy();

	SetDvar( "player_debugSprint", "0" );
}

dev_cac_overlay_create()
{
	x = -80;
	y = 140;
	menu_name = "dev_cac_debug";

	hud = maps\mp\gametypes\_dev::new_hud( menu_name, undefined, x, y, 1 );
	hud SetShader( "white", 185, 285 );
	hud.alignX = "left";
	hud.alignY = "top";
	hud.sort = 10;
	hud.alpha = 0.6;	
	hud.color = ( 0.0, 0.0, 0.5 );

	x_offset = 100;

	hud.menu[0] = maps\mp\gametypes\_dev::new_hud( menu_name, "NAME", x + 5, y + 10, 1.3 );

	hud.menu[1] = maps\mp\gametypes\_dev::new_hud( menu_name, "MODELS",			x + 5, y + 25, 1 );
	hud.menu[2] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Body:",		x + 5, y + 35, 1 );
	hud.menu[3] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Head:",		x + 5, y + 45, 1 );
	hud.menu[4] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Head Gear:",	x + 5, y + 55, 1 );

	hud.menu[5] = maps\mp\gametypes\_dev::new_hud( menu_name, "MOBILITY",		x + 5, y + 70, 1 );
	hud.menu[6] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Body:",		x + 5, y + 80, 1 );
	hud.menu[7] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Head Gear:",	x + 5, y + 90, 1 );
	hud.menu[8] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Speed Scale:",	x + 5, y + 100, 1 );
	hud.menu[9] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Sprint Duration:",		x + 5, y + 110, 1 );
	hud.menu[10] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Sprint Cooldown:",	x + 5, y + 120, 1 );

	hud.menu[11] = maps\mp\gametypes\_dev::new_hud( menu_name, "ARMOR - BULLET",	x + 5, y + 135, 1 );
	hud.menu[12] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Body:",			x + 5, y + 145, 1 );
	hud.menu[13] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Head Gear:",		x + 5, y + 155, 1 );

	hud.menu[14] = maps\mp\gametypes\_dev::new_hud( menu_name, "ARMOR - EXPLOSIVE",	x + 5, y + 170, 1 );
	hud.menu[15] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Body:",			x + 5, y + 180, 1 );
	hud.menu[16] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Head Gear:",		x + 5, y + 190, 1 );

	hud.menu[17] = maps\mp\gametypes\_dev::new_hud( menu_name, "DAMAGE",			x + 5, y + 205, 1 );
	hud.menu[18] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Type:",			x + 5, y + 215, 1 );
	hud.menu[19] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Original:",		x + 5, y + 225, 1 );
	hud.menu[20] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Final:",			x + 5, y + 235, 1 );
	hud.menu[21] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Gain/Loss:",		x + 5, y + 245, 1 );
	hud.menu[22] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Location:",		x + 5, y + 255, 1 );
	hud.menu[23] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Weapon:",			x + 5, y + 265, 1 );
	hud.menu[24] = maps\mp\gametypes\_dev::new_hud( menu_name, "  Range:",			x + 5, y + 275, 1 );
			
	x_offset = 65;

	hud.menu[25]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 35, 1 );
	hud.menu[26]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 45, 1 );
	hud.menu[27]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 55, 1 );

	x_offset = 100;

	hud.menu[28]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 80, 1 );
	hud.menu[29]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 90, 1 );
	hud.menu[30]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 100, 1 );
	hud.menu[31]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 110, 1 );
	hud.menu[32]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 120, 1 );

	hud.menu[33]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 145, 1 );
	hud.menu[34]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 155, 1 );

	hud.menu[35]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 180, 1 );
	hud.menu[36]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 190, 1 );

	x_offset = 65;

	hud.menu[37]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 215, 1 );
	hud.menu[38]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 225, 1 );
	hud.menu[39]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 235, 1 );
	hud.menu[40]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 245, 1 );
	hud.menu[41]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 255, 1 );
	hud.menu[42]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 265, 1 );
	hud.menu[43]	= maps\mp\gametypes\_dev::new_hud( menu_name, "", x + x_offset, y + 275, 1 );

	return hud;
}

color( value )
{
	r = 1;
	g = 1;
	b = 0;
	
	color = ( 0.0, 0.0, 0.0 );

	if ( value > 0 )
		r = r - value;
	else
		g = g + value;

	c = ( r, g, b);
	return c;
}

dev_cac_gdt_update_think()
{
	for ( ;; )
	{
		level waittill( "gdt_update", asset, keyValue );
		
		keyValue = StrTok( keyValue, "\\" );
		key = keyValue[0];
		
		switch( key )
		{
			case "armorBullet":
				key = "armor_bullet";
				break;

			case "armorExplosive":
				key = "armor_explosive";
				break;

			case "moveSpeed":
				key = "mobility";
				break;

			case "sprintTimeTotal":
				key = "sprint_time_total";
				break;

			case "sprintTimeCooldown":
				key = "sprint_time_cooldown";
				break;

			default:
				key = undefined;
				break;
		}

		if ( !IsDefined( key ) )
		{
			continue;
		}

		value = Float( keyValue[1] );
		level.cac_attributes[ key ][ asset ] = value;

		players = GET_PLAYERS();

		for ( i = 0; i < players.size; i++ )
		{
			//players[i] set_movement_scale();
		}
	}
}

sort_greatest( function, attribute, greatest )
{
	keys = GetArrayKeys( level.cac_functions[ function ] );
	greatest = keys[0];

	for ( i = 0; i < keys.size; i++ )
	{
		if ( level.cac_attributes[ attribute ][ keys[i] ] > level.cac_attributes[ attribute ][ greatest ] )
		{
			greatest = keys[i];
		}
	}

	return greatest;
}

sort_least( function, attribute, least )
{
	keys = GetArrayKeys( level.cac_functions[ function ] );
	least = keys[0];

	for ( i = 0; i < keys.size; i++ )
	{
		if ( level.cac_attributes[ attribute ][ keys[i] ] < level.cac_attributes[ attribute ][ least ] )
		{
			least = keys[i];
		}
	}

	return least;
}

dev_cac_set_model_range( sort_function, attribute )
{
	if ( !dev_cac_player_valid() )
	{
		return;
	}

	player = level.dev_cac_player;

	player.cac_body_type = [[sort_function]]( "set_body_model", attribute );
	player.cac_head_type = [[sort_function]]( "set_head_model", attribute );
	player.cac_hat_type = [[sort_function]]( "set_hat_model", attribute );

	player dev_cac_set_player_model();
}

#/