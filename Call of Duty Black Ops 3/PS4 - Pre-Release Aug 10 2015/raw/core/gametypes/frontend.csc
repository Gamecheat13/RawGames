
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\custom_class;
#using scripts\shared\exploder_shared;
#using scripts\shared\util_shared;
#using scripts\shared\postfx_shared;

#using scripts\core\_multi_extracam;
#using scripts\codescripts\struct;

// ARCHETYPE SCRIPTS - by putting them here, any autoexec functions will execute automatically.
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\archetype_damage_effects;

#using scripts\shared\_character_customization;
#using scripts\shared\_weapon_customization_icon;
#using scripts\shared\lui_shared;
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       



	











	


	
#precache( "client_fx", "zombie/fx_glow_eye_orange" );

function main()
{
	level.callbackEntitySpawned = &entityspawned;
	level.callbackLocalClientConnect = &localClientConnect;
	level.mpVignettePostfxActive = false;
	
	if(!isdefined(level.str_current_safehouse))level.str_current_safehouse="cairo";
	
	level.orbis = (GetDvarString( "orbisGame") == "true");
	level.durango = (GetDvarString( "durangoGame") == "true");
	
	clientfield::register( "world", "safehouse", 1, GetMinBitCountForNum( 3 ), "int", &set_current_safehouse, !true, true );
	clientfield::register( "world", "first_time_flow", 1, GetMinBitCountForNum( 1 ), "int", &first_time_flow, !true, true );
	clientfield::register( "world", "cp_bunk_anim_type", 1, GetMinBitCountForNum( 1 ), "int", &cp_bunk_anim_type, !true, true );
	
	customclass::init();
		
	level.cameras_active = false;

	clientfield::register( "actor", "zombie_has_eyes", 1, 1, "int", &zombie_eyes_clientfield_cb, !true, true );
	
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";

	level thread blackscreen_watcher();

	setStreamerRequest( 1, "core_frontend" );

	handle_forced_streaming( "" );
}

function set_current_safehouse( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) // self = actor
{
	switch ( newVal )
	{
		case 1:
			
			level.str_current_safehouse = "cairo";
			break;
			
		case 2:
			
			level.str_current_safehouse = "mobile";
			break;
			
		case 3:
			
			level.str_current_safehouse = "singapore";
			break;
	}
}

function first_time_flow( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	// leaving this empty - just using the clientfield value directly for some logic elsewhere
}

function cp_bunk_anim_type( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	// leaving this empty - just using the clientfield value directly for some logic elsewhere
}

function setupClientMenus( localClientNum )
{
	lui::initMenuData( localClientNum );
	
	// lobby menus
	lui::createCustomCameraMenu( "Main", localClientNum, &lobby_main, true );
	lui::createCameraMenu( "Inspection", localClientNum, "spawn_char_lobbyslide", "cac_main_lobby_camera_01", "cam1" );
	lui::linkToCustomCharacter( "Inspection", localClientNum, "inspection_character" );
	
	// character customization menus
	lui::createCustomCameraMenu( "PersonalizeCharacter", localClientNum, &personalize_characters_watch, false, &start_character_rotating, &end_character_rotating );
	lui::addMenuExploders( "PersonalizeCharacter", localClientNum, array( "char_customization", "char_custom_bg" ) );
	lui::linkToCustomCharacter( "PersonalizeCharacter", localClientNum, "character_customization" );

	
	lui::createCameraMenu( "OutfitsMainMenu", localClientNum, "spawn_char_custom", "ui_cam_character_customization", "cam_preview" );
	lui::addMenuExploders( "OutfitsMainMenu", localClientNum, array( "char_customization", "char_custom_bg" ) );
	lui::linkToCustomCharacter( "OutfitsMainMenu", localClientNum, "character_customization" );
	
	lui::createCameraMenu( "ChooseOutfit", localClientNum, "spawn_char_custom", "ui_cam_character_customization", "cam_preview", &start_character_rotating, &end_character_rotating );
	lui::addMenuExploders( "ChooseOutfit", localClientNum, array( "char_customization", "char_custom_bg" ) );
	lui::linkToCustomCharacter( "ChooseOutfit", localClientNum, "character_customization" );
	
	lui::createCameraMenu( "ChooseHead", localClientNum, "spawn_char_custom", "ui_cam_character_customization", "cam_helmet", &open_choose_head_menu, &close_choose_head_menu );
	lui::addMenuExploders( "ChooseHead", localClientNum, array( "char_customization", "char_custom_bg" ) );
	lui::linkToCustomCharacter( "ChooseHead", localClientNum, "character_customization" );
	
	lui::createCameraMenu( "ChoosePersonalizationCharacter", localClientNum, "room2_frontend_camera", "ui_cam_char_selection_background", "cam1", &open_choose_loadout_menu, &close_choose_loadout_menu );
	lui::createCustomExtraCamXCamData( "ChoosePersonalizationCharacter", localClientNum, 1, &choose_loadout_extracam_watch );
	lui::linkToCustomCharacter( "ChoosePersonalizationCharacter", localClientNum, "character_customization" );
	
	lui::createCameraMenu( "ChooseCharacterLoadout", localClientNum, "room2_frontend_camera", "ui_cam_char_selection_background", "cam1", &open_choose_loadout_menu, &close_choose_loadout_menu );
	//lui::createCustomExtraCamXCamData( "ChooseCharacterLoadout", localClientNum, 1, &choose_loadout_extracam_watch );
	lui::linkToCustomCharacter( "ChooseCharacterLoadout", localClientNum, "character_customization" );
	
	lui::createCameraMenu( "ChooseGender", localClientNum, "room2_frontend_camera", "ui_cam_char_selection_background", "cam1" );
	lui::addMenuExploders( "ChooseGender", localClientNum, array( "char_customization", "char_custom_bg" ) );
	lui::linkToCustomCharacter( "ChooseGender", localClientNum, "character_customization" );
	
	// create a class
	lui::createCameraMenu( "chooseClass", localClientNum, "spawn_char_cac_choose", "ui_cam_cac_specialist", "cam_specialist", &open_choose_class, &close_choose_class );
	lui::addMenuExploders( "chooseClass", localClientNum, array( "char_customization", "lights_paintshop", "weapon_kick", "char_custom_bg" ) );
	lui::linkToCustomCharacter( "chooseClass", localClientNum, "character_customization" );
	
	// paintshop
	lui::createCustomCameraMenu( "Paintshop", localClientNum, undefined, false, undefined, undefined );
	lui::addMenuExploders( "Paintshop", localClientNum, array( "char_customization", "char_custom_bg" ) );
	
	// gunsmith
	lui::createCustomCameraMenu( "Gunsmith", localClientNum, undefined, false, undefined, undefined );
	lui::addMenuExploders( "Gunsmith", localClientNum, array( "char_customization", "char_custom_bg" ) );
	
	// Weapon build Kits
	lui::createCustomCameraMenu( "WeaponBuildKits", localClientNum, undefined, false, &open_zm_buildkits, &close_zm_buildkits );
	lui::addMenuExploders( "WeaponBuildKits", localClientNum, array( "zm_weapon_kick", "zm_weapon_room" ) );
	
	// Bubblegum Buffs
	lui::createCameraMenu( "BubblegumBuffs", localClientNum, "zm_gum_position", "ui_cam_default", "default", &open_zm_bgb, &close_zm_bgb );
	lui::addMenuExploders( "BubblegumBuffs", localClientNum, array( "zm_gum_kick", "zm_gum_room" ) );

	// Mega Chew Factory
	lui::createCameraMenu( "MegaChewFactory", localClientNum, "zm_gum_position", "ui_cam_default", "default", &open_zm_bgb, &close_zm_bgb );
	lui::addMenuExploders( "MegaChewFactory", localClientNum, array( "zm_gum_kick", "zm_gum_room" ) );
	
	// Arena
	lui::createCameraMenu( "Pregame_Main", localClientNum, "character_frozen_moment_extracam1", "ui_cam_char_identity", "cam_bust", undefined, undefined );
}

function zombie_eyes_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)  // self = actor
{
	if(!IsDefined(newVal))
	{
		return;
	}
	
	if(newVal)
	{
		self createZombieEyes( localClientNum );
		self mapshaderconstant( localClientNum, 0, "scriptVector2", 0, get_eyeball_on_luminance(), self get_eyeball_color() );
	}
	else
	{
		self deleteZombieEyes(localClientNum);
		self mapshaderconstant( localClientNum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color() );
	}
	
	// optional callback for handling zombie eyes
	if ( IsDefined( level.zombie_eyes_clientfield_cb_additional ) )
	{
		self [[ level.zombie_eyes_clientfield_cb_additional ]]( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump );
	}	
}


function get_eyeball_on_luminance()
{
	if( IsDefined( level.eyeball_on_luminance_override ) )
	{
		return level.eyeball_on_luminance_override;
	}
	
	return 1;
}

function get_eyeball_off_luminance()
{
	if( IsDefined( level.eyeball_off_luminance_override ) )
	{
		return level.eyeball_off_luminance_override;
	}
	
	return 0;
}

function get_eyeball_color()  // self = zombie
{
	val = 0;
	
	if ( IsDefined( level.zombie_eyeball_color_override ) )
	{
		val = level.zombie_eyeball_color_override;
	}
	
	if ( IsDefined( self.zombie_eyeball_color_override ) )
	{
		val = self.zombie_eyeball_color_override;
	}
	
	return val;
}

function createZombieEyes( localClientNum )
{
	self thread createZombieEyesInternal(localClientNum);
}

function deleteZombieEyes(localClientNum)
{
	if ( isdefined( self._eyeArray ) )
	{
		if ( isdefined( self._eyeArray[localClientNum] ) )
		{
			DeleteFx( localClientNum, self._eyeArray[localClientNum], true );
			self._eyeArray[localClientNum] = undefined;
		}
	}
}

function createZombieEyesInternal(localClientNum)
{
	self endon("entityshutdown");
	
	self util::waittill_dobj( localClientNum );

	if ( !isdefined( self._eyeArray ) )
	{
		self._eyeArray = [];
	}

	if ( !isdefined( self._eyeArray[localClientNum] ) )
	{
		linkTag = "j_eyeball_le";

		effect = level._effect["eye_glow"];

		// will handle level wide eye fx change
		if(IsDefined(level._override_eye_fx))
		{
			effect = level._override_eye_fx;
		}
		// will handle individual spawner or type eye fx change
		if(IsDefined(self._eyeglow_fx_override))
		{
			effect = self._eyeglow_fx_override;
		}

		if(IsDefined(self._eyeglow_tag_override))
		{
			linkTag = self._eyeglow_tag_override;
		}

		self._eyeArray[localClientNum] = PlayFxOnTag( localClientNum, effect, self, linkTag );
	}
}

function blackscreen_watcher()
{
	blackscreenUIModel = CreateUIModel( GetGlobalUIModel(), "hideWorldForStreamer" );
	SetUIModelValue( blackscreenUIModel, 1 );

	while( true )
	{
		level waittill( "streamer_change", data_struct );
		SetUIModelValue( blackscreenUIModel, 1 );
		wait 0.1;
		
		while( true )
		{
			charReady = true;
			
			if( IsDefined( data_struct ) )
			{
				charReady = character_customization::is_character_streamed( data_struct );
			}

			sceneReady = GetStreamerRequestProgress( 0 ) >= 100;
			if( charReady && sceneReady )
			{
				break;
			}
			wait 0.1;
		}
			
		SetUIModelValue( blackscreenUIModel, 0 );
	}
}

function streamer_change( hint, data_struct )
{
	if( IsDefined( hint ) )
	{
		setStreamerRequest( 0, hint );
	}
	else
	{
		clearStreamerRequest( 0 );
	}
	level notify( "streamer_change", data_struct );
}

function handle_forced_streaming(mode)
{
	return; // MJD - disable all forcing

	if( IsDefined( level.current_streaming_mode ) && level.current_streaming_mode == mode )
	{
		return;
	}

	setScriptStreamBias( 1.0 );
	stopForcingStreamer();

	if( mode == "cp" )
	{
		character_customization::handle_forced_streaming( "cp" );
	}
	else if( mode == "mp" )
	{
		forceStreamWeapons();
		character_customization::handle_forced_streaming( "mp" );
	}
	else
	{
		forceStreamWeapons();
		character_customization::handle_forced_streaming( "cp" );
		character_customization::handle_forced_streaming( "mp" );
	}

	level.current_streaming_mode = mode;
}

function playMPHeroVignetteCam( localClientNum, data_struct )
{
	fields = GetCharacterFields( data_struct.characterIndex, 1 );

	if( isDefined(fields) && isDefined(fields.frontendVignetteStruct) && isdefined( fields.frontendVignetteXCam ) )
	{
		if( isDefined(fields.frontendVignetteStreamerHint) )
		{
			streamer_change( fields.frontendVignetteStreamerHint, data_struct );
		}
		position = struct::get(fields.frontendVignetteStruct);
		PlayMainCamXCam( localClientNum, fields.frontendVignetteXCam, 0, "", "", position.origin, position.angles );
	}
}

function handle_inspect_player( localClientNum )
{
	level endon( "disconnect" );

	while( true )
	{
		level waittill( "inspect_player", xuid );
		assert( isdefined( xuid ) );
		
		level thread update_inspection_character( localClientNum, xuid );
	}
}

function update_inspection_character( localClientNum, xuid )
{
	level endon( "disconnect" );
	level endon( "inspect_player" );
	
	customization = GetCharacterCustomizationForXUID( localClientNum, xuid );
	while( !isdefined( customization ) )
	{
		//TODO: Handle the case where we have to wait for the character, and handle timeout
		customization = GetCharacterCustomizationForXUID( localClientNum, xuid );
		wait( 1 );
	}
	
	//TODO: If the character is hidden/obscured while loading, show it.
	fields = GetCharacterFields( customization.charactertype, customization.charactermode );
	
	params = SpawnStruct();
	if(!isdefined(fields))fields=SpawnStruct();
	
	params.anim_name = "pb_cac_main_lobby_idle";
	
	s_scene = struct::get_script_bundle( "scene", "sb_frontend_inspection" );
	s_align = struct::get( s_scene.aligntarget, "targetname" );
	
	s_params = SpawnStruct();
	s_params.scene = s_scene.name;

	params.weapon_right = "wpn_t7_arak_paint_shop";

	data_struct = lui::getCharacterDataForMenu( "Inspection", localClientNum );

	character_customization::set_character( data_struct, customization.charactertype );
	character_customization::set_character_mode( data_struct, customization.charactermode );
	character_customization::set_body( data_struct, customization.charactermode, customization.charactertype, customization.body.selectedindex, customization.body.colors );
	character_customization::set_head( data_struct, customization.charactermode, customization.head );
	character_customization::set_helmet( data_struct, customization.charactermode, customization.charactertype, customization.helmet.selectedIndex, customization.helmet.colors );
	
	character_customization::update( localClientNum, data_struct, params );

	if( isDefined( data_struct.characterModel ) )
	{
		data_struct.characterModel SetHighDetail( true, true );
	}
}

function entityspawned(localClientNum)
{
}

function localClientConnect(localClientNum)
{
	/# println( "*** Client script VM : Local client connect " + localClientNum ); #/
		
	setupClientMenus( localClientNum );
	
	if ( isdefined( level.characterCustomizationSetup ) )
	{
		[[ level.characterCustomizationSetup ]]( localclientnum );
	}
	
	if ( isdefined( level.weaponCustomizationIconSetup ) )
	{
		[[ level.weaponCustomizationIconSetup ]]( localclientnum );
	}
	// mp lobby character
	level.mp_lobby_data_struct = character_customization::create_character_data_struct( GetEnt( localClientNum, "customization", "targetname" ) );
	
	// cp lobby character
	lobbyModel = util::spawn_model( localClientNum, "tag_origin", (0,0,0) );
	lobbyModel.targetname = "cp_lobby_player_model";
	level.cp_lobby_data_struct = character_customization::create_character_data_struct( lobbyModel );
	character_customization::update_show_helmets( localClientNum, level.cp_lobby_data_struct, false );	// cp doesn't want helmets
	
	lobbyModel = util::spawn_model( localClientNum, "tag_origin", (0,0,0) );
	lobbyModel.targetname = "zm_lobby_player_model";
	level.zm_lobby_data_struct = character_customization::create_character_data_struct( lobbyModel );
	
	callback::Callback( #"on_localclient_connect", localClientNum );
	
	customclass::localClientConnect( localClientNum );
	level thread handle_inspect_player( localClientnum );
	
	customclass::hide_paintshop_bg( localClientNum );

	globalModel = GetGlobalUIModel();
	roomModel = CreateUIModel( globalModel, "lobbyRoot.room");
	room = GetUIModelValue( roomModel );

	EnableFrontendStreamingOverlay( localClientNum, true );

	level.frontendClientConnected = true;
	
	level notify( "menu_change", "Main", "opened", room );
}	

function onPrecacheGameType()
{
}

function onStartGameType()
{
}

///////////////////////////////////////////
// CAC MENUS CUSTOM INFO
///////////////////////////////////////////

function open_choose_class( localClientNum, menu_data )
{
	level notify( "updateHero", "refresh", character_customization::get_character_mode( localClientNum ) );
	PlayRadiantExploder( localClientNum, "lights_paintshop" );
	PlayRadiantExploder( localClientNum, "weapon_kick" );
}

function close_choose_class( localClientNum, menu_data )
{
	KillRadiantExploder( localClientNum, "lights_paintshop" );
	KillRadiantExploder( localClientNum, "weapon_kick" );
}

///////////////////////////////////////////
// END CAC MENUS CUSTOM INFO
///////////////////////////////////////////

///////////////////////////////////////////
// ZM WEAPON MENUS CUSTOM INFO
///////////////////////////////////////////

function open_zm_buildkits( localClientNum, menu_data )
{
	level.weapon_position = struct::get("zm_weapon_position");
}

function close_zm_buildkits( localClientNum, menu_data )
{
	level.weapon_position = struct::get("paintshop_weapon_position");
}

function open_zm_bgb( localClientNum, menu_data )
{
	level.weapon_position = struct::get("zm_gum_position");
	level thread wait_for_mega_chew_notifies( localClientNum, menu_data );
	PlayRadiantExploder( localClientNum, "zm_gum_room" );
	PlayRadiantExploder( localClientNum, "zm_gum_kick" );
}

function close_zm_bgb( localClientNum, menu_data )
{
	level.weapon_position = struct::get("paintshop_weapon_position");
	KillRadiantExploder( localClientNum, "zm_gum_room" );
	KillRadiantExploder( localClientNum, "zm_gum_kick" );
}

function wait_for_mega_chew_notifies( localClientNum, menu_data )
{
	level endon( "disconnect" );
	level endon( "MegaChewFactory_closed" );
	
	while( true )
	{
		level waittill( "mega_chew_update", event, index, n_bgb_index );
		switch( event )
		{
			case "focus_changed":
				break;
			case "selected": //gets sent when player doesn't have enough tokens to purchase
					/#
						IPrintLnBold( "Selected megachew machine " + index );
						PrintLn( "Selected megachew machine " + index  );
					#/
				break;
			case "purchased":
					str_item_index = tableLookup( "gamedata/stats/zm/zm_statstable.csv", 0, n_bgb_index, 7 );
					
					/#
						IPrintLnBold( "Purchased from megachew machine " + index + " and got bgb " + str_item_index );
						PrintLn( "Purchased from megachew machine " + index + " and got bgb " + str_item_index );
					#/
				break;
		}
	}
}

///////////////////////////////////////////
// END ZM WEAPON MENUS CUSTOM INFO
///////////////////////////////////////////


///////////////////////////////////////////
// CHARACTER CUSTOMIZATION MENUS CUSTOM INFO
///////////////////////////////////////////

function open_character_menu( localClientNum, menu_data )
{
	character_ent = GetEnt( localClientNum, menu_data.target_name, "targetname" );
	if ( isdefined( character_ent ) )
	{
		character_ent Show();
	}
}

function close_character_menu( localClientNum, menu_data )
{
	character_ent = GetEnt( localClientNum, menu_data.target_name, "targetname" );
	if ( isdefined( character_ent ) )
	{
		character_ent Hide();
	}
}

function choose_loadout_extracam_watch( localClientNum, menu_name, extracam_data )
{
	level endon( menu_name + "_closed" );
	
	while ( true )
	{		
		params = SpawnStruct();
		character_customization::get_current_frozen_moment_params( localClientNum, level.liveCCdata, params );
		
		if ( isdefined( params.align_struct ) )
		{
			camera_ent = multi_extracam::extracam_init_item( localClientNum, params.align_struct, extracam_data.extracam_index );
			if ( isdefined( camera_ent ) && isdefined( params.xcam ) )
			{
				if ( isdefined( params.xcamFrame ) )
				{
					camera_ent PlayExtraCamXCam( params.xcam, 0, params.subXCam, params.xcamFrame );
				}
				else
				{
					camera_ent PlayExtraCamXCam( params.xcam, 0, params.subXCam );
				}
			}
		}
		
		level waittill( "frozenMomentChanged" );
	}
}

function open_choose_loadout_menu( localClientNum, menu_data )
{
	menu_data.custom_character.characterMode = 1;
	character_customization::update_use_frozen_moments( localClientNum, menu_data.custom_character, true );
}

function close_choose_loadout_menu( localClientNum, menu_data )
{
	character_customization::update_use_frozen_moments( localClientNum, menu_data.custom_character, false );
}

function start_character_rotating( localClientNum, menu_data )
{
	level notify ( "begin_personalizing_hero" );
}

function end_character_rotating( localClientNum, menu_data )
{
	level notify( "done_personalizing_hero" );
}

function move_mp_character_to_inspect_room( localClientNum, menu_data )
{
	character_customization::set_character_align( localClientNum, menu_data.custom_character, "spawn_char_lobbyslide" );
}

function move_mp_character_from_inspect_room( localClientNum, menu_data )
{
	character_customization::set_character_align( localClientNum, menu_data.custom_character, undefined );
}

function open_choose_head_menu( localClientNum, menu_data )
{
	character_customization::update_show_helmets( localClientNum, menu_data.custom_character, false );
	level notify ( "begin_personalizing_hero" );
}

function close_choose_head_menu( localClientNum, menu_data )
{
	character_customization::update_show_helmets( localClientNum, menu_data.custom_character, true );
	level notify( "done_personalizing_hero" );
}

function personalize_characters_watch( localClientNum, menu_name )
{
	level endon( "disconnect" );
	level endon( menu_name + "_closed" );
	
	s_cam = struct::get( "personalizeHero_camera", "targetname" );
	assert( isdefined( s_cam ) );
	
	animTime = 0;
	while( true )
	{
		level waittill( "camera_change", pose );
		if ( pose === "exploring" )
		{
			PlayMainCamXCam( localClientNum, "ui_cam_character_customization", animTime, "cam_preview", "", s_cam.origin, s_cam.angles );
		}
		else if ( pose === "inspecting_helmet" )
		{
			PlayMainCamXCam( localClientNum, "ui_cam_character_customization", animTime, "cam_helmet", "", s_cam.origin, s_cam.angles );
		}
		else if ( pose === "inspecting_body" )
		{
			PlayMainCamXCam( localClientNum, "ui_cam_character_customization", animTime, "cam_select", "", s_cam.origin, s_cam.angles );
		}
		
		animTime = 300;
	}
}

///////////////////////////////////////////
// END CHARACTER CUSTOMIZATION MENUS CUSTOM INFO
///////////////////////////////////////////

///////////////////////////////////////////
// LOBBY MENUS CUSTOM INFO
///////////////////////////////////////////

function cp_lobby_room( localClientNum )
{
	str_safehouse = level.str_current_safehouse;
	
	/#
		
	str_debug_safehouse = GetDvarString( "scr_frontend_safehouse", "default" );
		
	if ( str_debug_safehouse != "default" )
	{
		str_safehouse = str_debug_safehouse;
	}
	
	#/
	
	level.a_str_bunk_scenes = [];		
	if ( !isdefined( level.a_str_bunk_scenes ) ) level.a_str_bunk_scenes = []; else if ( !IsArray( level.a_str_bunk_scenes ) ) level.a_str_bunk_scenes = array( level.a_str_bunk_scenes ); level.a_str_bunk_scenes[level.a_str_bunk_scenes.size]="cp_cac_cp_lobby_idle_" + str_safehouse;;
	if ( !isdefined( level.a_str_bunk_scenes ) ) level.a_str_bunk_scenes = []; else if ( !IsArray( level.a_str_bunk_scenes ) ) level.a_str_bunk_scenes = array( level.a_str_bunk_scenes ); level.a_str_bunk_scenes[level.a_str_bunk_scenes.size]="cin_fe_cp_bunk_vign_smoke_read_" + str_safehouse;;
	if ( !isdefined( level.a_str_bunk_scenes ) ) level.a_str_bunk_scenes = []; else if ( !IsArray( level.a_str_bunk_scenes ) ) level.a_str_bunk_scenes = array( level.a_str_bunk_scenes ); level.a_str_bunk_scenes[level.a_str_bunk_scenes.size]="cin_fe_cp_desk_vign_work_" + str_safehouse;;
	if ( !isdefined( level.a_str_bunk_scenes ) ) level.a_str_bunk_scenes = []; else if ( !IsArray( level.a_str_bunk_scenes ) ) level.a_str_bunk_scenes = array( level.a_str_bunk_scenes ); level.a_str_bunk_scenes[level.a_str_bunk_scenes.size]="cin_fe_cp_desk_vign_type_" + str_safehouse;;
		
	// We have exploders to go with these.
	// They don't work as note tracks because the note track is ignored when there's no client.
	level.a_str_bunk_scene_exploders = [];	
	if ( !isdefined( level.a_str_bunk_scene_exploders ) ) level.a_str_bunk_scene_exploders = []; else if ( !IsArray( level.a_str_bunk_scene_exploders ) ) level.a_str_bunk_scene_exploders = array( level.a_str_bunk_scene_exploders ); level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size]="cp_frontend_idle";;
	if ( !isdefined( level.a_str_bunk_scene_exploders ) ) level.a_str_bunk_scene_exploders = []; else if ( !IsArray( level.a_str_bunk_scene_exploders ) ) level.a_str_bunk_scene_exploders = array( level.a_str_bunk_scene_exploders ); level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size]="cp_frontend_read";;
	if ( !isdefined( level.a_str_bunk_scene_exploders ) ) level.a_str_bunk_scene_exploders = []; else if ( !IsArray( level.a_str_bunk_scene_exploders ) ) level.a_str_bunk_scene_exploders = array( level.a_str_bunk_scene_exploders ); level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size]="cp_frontend_work";;
	if ( !isdefined( level.a_str_bunk_scene_exploders ) ) level.a_str_bunk_scene_exploders = []; else if ( !IsArray( level.a_str_bunk_scene_exploders ) ) level.a_str_bunk_scene_exploders = array( level.a_str_bunk_scene_exploders ); level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size]="cp_frontend_type";;

	level.a_str_bunk_scene_hints = [];	
	if ( !isdefined( level.a_str_bunk_scene_hints ) ) level.a_str_bunk_scene_hints = []; else if ( !IsArray( level.a_str_bunk_scene_hints ) ) level.a_str_bunk_scene_hints = array( level.a_str_bunk_scene_hints ); level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size]=undefined;;
	if ( !isdefined( level.a_str_bunk_scene_hints ) ) level.a_str_bunk_scene_hints = []; else if ( !IsArray( level.a_str_bunk_scene_hints ) ) level.a_str_bunk_scene_hints = array( level.a_str_bunk_scene_hints ); level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size]="cp_frontend_read";;
	if ( !isdefined( level.a_str_bunk_scene_hints ) ) level.a_str_bunk_scene_hints = []; else if ( !IsArray( level.a_str_bunk_scene_hints ) ) level.a_str_bunk_scene_hints = array( level.a_str_bunk_scene_hints ); level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size]="cp_frontend_work";;
	if ( !isdefined( level.a_str_bunk_scene_hints ) ) level.a_str_bunk_scene_hints = []; else if ( !IsArray( level.a_str_bunk_scene_hints ) ) level.a_str_bunk_scene_hints = array( level.a_str_bunk_scene_hints ); level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size]="cp_frontend_type";;
	
	if ( !isdefined( level.n_cp_index ) )
	{
		if ( level clientfield::get( "first_time_flow" ) )
		{
			// always play "smoke" scene the first time
			level.n_cp_index = 0;
			
			/#
				PrintTopRightln( "first time flow active - client", ( 1, 1, 1 ) );
			#/
		}	
		else if ( level clientfield::get( "cp_bunk_anim_type" ) == 0 )
		{
			level.n_cp_index = RandomIntRange( 0, 2 ); // bed anims
			
			/#
				PrintTopRightln( "bed - client", ( 1, 1, 1 ) );
			#/
		}
		else if ( level clientfield::get( "cp_bunk_anim_type" ) == 1 )
		{
			level.n_cp_index = RandomIntRange( 2, 4 ); // desk anims
			
			/#
				PrintTopRightln( "desk - client", ( 1, 1, 1 ) );
			#/
		}
	}
	
	/#
	
	// moves through the scene array itteratively in dev		
	if ( GetDvarInt( "scr_cycle_frontend_anims", 0 ) )
	{
		if(!isdefined(level.cp_debug_index))level.cp_debug_index=level.n_cp_index;
		
		level.cp_debug_index++;		
		if ( level.cp_debug_index == level.a_str_bunk_scenes.size )
		{
			level.cp_debug_index = 0;
		}
		
		level.n_cp_index = level.cp_debug_index;
	}
	
	#/
	
	streamer_change( level.a_str_bunk_scene_hints[ level.n_cp_index ] );
	
	s_scene = struct::get_script_bundle( "scene", level.a_str_bunk_scenes[ level.n_cp_index ] );
	
	str_gender = GetHeroGender( GetEquippedHeroIndex( localClientNum, 2 ), "cp" );
	if ( str_gender === "female" && isdefined( s_scene.FemaleBundle ) )
	{
		s_scene = struct::get_script_bundle( "scene", s_scene.FemaleBundle );
	}
	
	/# 
		PrintTopRightln( s_scene.name, ( 1, 1, 1 ) );
	#/
		
	s_align = struct::get( s_scene.aligntarget, "targetname" );
	PlayMainCamXCam( localClientNum, s_scene.cameraswitcher, 0, "", "", s_align.origin, s_align.angles );
	
	// Play the right exploder and stop all the others.
	for( i = 0; i < level.a_str_bunk_scenes.size; i++ )
	{
		if( i == level.n_cp_index )
		{
			PlayRadiantExploder( 0, level.a_str_bunk_scene_exploders[i] );
		}
		else
		{
			StopRadiantExploder( 0, level.a_str_bunk_scene_exploders[i] );
		}
	}
		
	s_params = SpawnStruct();
	s_params.scene = s_scene.name;
	s_params.sessionMode = 2;
	
	character_customization::loadEquippedCharacterOnModel( localClientNum, level.cp_lobby_data_struct, undefined, s_params );
	
	/#
		if ( GetDvarInt( "scr_cycle_frontend_anims", 0 ) )
		{
			level.n_cp_index = undefined;
		}
	#/
}

function cpzm_lobby_room( localClientNum )
{
	str_safehouse = level.str_current_safehouse;
	
	/#
		
	str_debug_safehouse = GetDvarString( "scr_frontend_safehouse", "default" );
		
	if ( str_debug_safehouse != "default" )
	{
		str_safehouse = str_debug_safehouse;
	}
	
	#/
	
	level.a_str_bunk_scenes = [];		
	level.active_str_cpzm_scene = "zm_cp_" + str_safehouse + "_lobby_idle";
	
	if ( !isdefined( level.a_str_bunk_scenes ) ) level.a_str_bunk_scenes = []; else if ( !IsArray( level.a_str_bunk_scenes ) ) level.a_str_bunk_scenes = array( level.a_str_bunk_scenes ); level.a_str_bunk_scenes[level.a_str_bunk_scenes.size]=level.active_str_cpzm_scene;;
		
	// We have exploders to go with these.
	// They don't work as note tracks because the note track is ignored when there's no client.
	level.a_str_bunk_scene_exploders = [];	
	if ( !isdefined( level.a_str_bunk_scene_exploders ) ) level.a_str_bunk_scene_exploders = []; else if ( !IsArray( level.a_str_bunk_scene_exploders ) ) level.a_str_bunk_scene_exploders = array( level.a_str_bunk_scene_exploders ); level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size]="cp_frontend_idle";;
	if ( !isdefined( level.a_str_bunk_scene_exploders ) ) level.a_str_bunk_scene_exploders = []; else if ( !IsArray( level.a_str_bunk_scene_exploders ) ) level.a_str_bunk_scene_exploders = array( level.a_str_bunk_scene_exploders ); level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size]="cp_frontend_read";;
	if ( !isdefined( level.a_str_bunk_scene_exploders ) ) level.a_str_bunk_scene_exploders = []; else if ( !IsArray( level.a_str_bunk_scene_exploders ) ) level.a_str_bunk_scene_exploders = array( level.a_str_bunk_scene_exploders ); level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size]="cp_frontend_work";;
	if ( !isdefined( level.a_str_bunk_scene_exploders ) ) level.a_str_bunk_scene_exploders = []; else if ( !IsArray( level.a_str_bunk_scene_exploders ) ) level.a_str_bunk_scene_exploders = array( level.a_str_bunk_scene_exploders ); level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size]="cp_frontend_type";;

	level.a_str_bunk_scene_hints = [];	
	if ( !isdefined( level.a_str_bunk_scene_hints ) ) level.a_str_bunk_scene_hints = []; else if ( !IsArray( level.a_str_bunk_scene_hints ) ) level.a_str_bunk_scene_hints = array( level.a_str_bunk_scene_hints ); level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size]=undefined;;
	if ( !isdefined( level.a_str_bunk_scene_hints ) ) level.a_str_bunk_scene_hints = []; else if ( !IsArray( level.a_str_bunk_scene_hints ) ) level.a_str_bunk_scene_hints = array( level.a_str_bunk_scene_hints ); level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size]="cp_frontend_read";;
	if ( !isdefined( level.a_str_bunk_scene_hints ) ) level.a_str_bunk_scene_hints = []; else if ( !IsArray( level.a_str_bunk_scene_hints ) ) level.a_str_bunk_scene_hints = array( level.a_str_bunk_scene_hints ); level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size]="cp_frontend_work";;
	if ( !isdefined( level.a_str_bunk_scene_hints ) ) level.a_str_bunk_scene_hints = []; else if ( !IsArray( level.a_str_bunk_scene_hints ) ) level.a_str_bunk_scene_hints = array( level.a_str_bunk_scene_hints ); level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size]="cp_frontend_type";;
	
	level.n_cp_index = 0;
	
	streamer_change( level.a_str_bunk_scene_hints[ level.n_cp_index ] );
	
	s_scene = struct::get_script_bundle( "scene", level.a_str_bunk_scenes[ level.n_cp_index ] );
	
	str_gender = GetHeroGender( GetEquippedHeroIndex( localClientNum, 2 ), "cp" );
	if ( str_gender === "female" && isdefined( s_scene.FemaleBundle ) )
	{
		s_scene = struct::get_script_bundle( "scene", s_scene.FemaleBundle );
	}
	
	/# 
		PrintTopRightln( s_scene.name, ( 1, 1, 1 ) );
	#/
		
	s_align = struct::get( s_scene.aligntarget, "targetname" );
	PlayMainCamXCam( localClientNum, s_scene.cameraswitcher, 0, "", "", s_align.origin, s_align.angles );
	
	// Play the right exploder and stop all the others.
	for( i = 0; i < level.a_str_bunk_scenes.size; i++ )
	{
		if( i == level.n_cp_index )
		{
			PlayRadiantExploder( 0, level.a_str_bunk_scene_exploders[i] );
		}
		else
		{
			StopRadiantExploder( 0, level.a_str_bunk_scene_exploders[i] );
		}
	}
		
	s_params = SpawnStruct();
	s_params.scene = s_scene.name;
	s_params.sessionMode = 2;
	
	character_customization::loadEquippedCharacterOnModel( localClientNum, level.cp_lobby_data_struct, undefined, s_params );
	
	/#
		if ( GetDvarInt( "scr_cycle_frontend_anims", 0 ) )
		{
			level.n_cp_index = undefined;
		}
	#/
}

function zm_lobby_room( localClientNum )
{
	/#
		
	n_zm_max_char_index = 8;
	
	if ( GetDvarInt( "scr_cycle_frontend_anims", 0 ) )
	{
		if ( !isdefined( level.zm_debug_index ) || level.zm_debug_index > n_zm_max_char_index )
		{
			level.zm_debug_index = 0;
		}
	}
	
	#/
	
	s_scene = struct::get_script_bundle( "scene", "cin_fe_zm_forest_vign_sitting" );
			
	s_params = SpawnStruct();
	s_params.scene = s_scene.name;
	s_params.sessionMode = 0;
	
	character_customization::loadEquippedCharacterOnModel( localClientNum, level.zm_lobby_data_struct, level.zm_debug_index, s_params );
	
	/#
		if ( GetDvarInt( "scr_cycle_frontend_anims", 0 ) )
		{
			level.zm_debug_index++;
		}
	#/
}

function mp_lobby_room( localClientNum )
{
	character_index = GetEquippedHeroIndex( localClientNum, 1 );
	fields = GetCharacterFields( character_index, 1 );
	
	params = SpawnStruct();
	if(!isdefined(fields))fields=SpawnStruct();
	
	if( isDefined(fields.frontendVignetteStruct) )
	{
		params.align_struct = struct::get( fields.frontendVignetteStruct );
	}

	params.weapon_left = fields.frontendVignetteWeaponLeftModel;
	params.weapon_right = fields.frontendVignetteWeaponModel;

	isAbilityEquipped = ( 1 == GetEquippedLoadoutItemForHero( localClientNum, character_index ) );
	if ( isAbilityEquipped )
	{
		params.anim_name = fields.frontendVignetteAbilityXAnim;
		params.weapon_left_anim = fields.frontendVignetteAbilityWeaponLeftAnim;
		params.weapon_right_anim = fields.frontendVignetteAbilityWeaponRightAnim;
	}
	else
	{
		params.anim_name = fields.frontendVignetteXAnim;
		params.weapon_left_anim = fields.frontendVignetteWeaponLeftAnim;
		params.weapon_right_anim = fields.frontendVignetteWeaponAnim;
	}
	
	params.sessionMode = 1;
	character_customization::loadEquippedCharacterOnModel( localClientNum, level.mp_lobby_data_struct, character_index, params );

	playMPHeroVignetteCam( localClientNum, level.mp_lobby_data_struct );
}

function lobby_main( localClientNum, menu_name, state )
{
	if ( !isdefined( state ) || (state == "room2") )
	{
		streamer_change();
		camera_ent = struct::get( "mainmenu_frontend_camera" );
		if ( isdefined( camera_ent ) )
		{
			PlayMainCamXCam( localclientnum, "startmenu_camera_01", 0, "cam1", "", camera_ent.origin, camera_ent.angles );
		}
	}
	else if ( state == "room1" )
	{
		handle_forced_streaming( "" );
		streamer_change( "core_frontend_sitting_bull" );
		camera_ent = struct::get( "room1_frontend_camera" );
		if ( isdefined( camera_ent ) )
		{
			PlayMainCamXCam( localclientnum, "startmenu_camera_01", 0, "cam1", "", camera_ent.origin, camera_ent.angles );
		}
	}
	else if ( StrStartsWith( state, "cpzm" ) )
	{
		handle_forced_streaming( "cp" );
		cpzm_lobby_room( localClientNum );
	}
	else if ( StrStartsWith( state, "cp" ) )
	{
		handle_forced_streaming( "cp" );
		cp_lobby_room( localClientNum );
	}
	else if ( StrStartsWith( state, "mp" ) )
	{
		handle_forced_streaming( "mp" );
		mp_lobby_room( localClientNum );
	}
	else if ( StrStartsWith( state, "zm" ) )
	{
		streamer_change( "core_frontend_zm_lobby" );
		camera_ent = struct::get( "zm_frontend_camera" );
		if ( isdefined( camera_ent ) )
		{
			PlayMainCamXCam( localclientnum, "zm_lobby_cam", 0, "default", "", camera_ent.origin, camera_ent.angles );
		}
		zm_lobby_room( localClientNum );
	}
	else
	{
		streamer_change();
	}
}

///////////////////////////////////////////
// END LOBBY MENUS CUSTOM INFO
///////////////////////////////////////////
