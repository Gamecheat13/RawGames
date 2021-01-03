
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\postfx_shared;

#using scripts\core\_multi_extracam;
#using scripts\codescripts\struct;

// ARCHETYPE SCRIPTS - by putting them here, any autoexec functions will execute automatically.
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\archetype_damage_effects;

#using scripts\shared\_character_customization;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                     	                                    

// TODO: Remove these when the "sitting bull" has been ported to a custom character



	

	


	
#precache( "client_fx", "zombie/fx_glow_eye_orange" );

function main()
{
	level.callbackEntitySpawned = &entityspawned;
	level.callbackLocalClientConnect = &localClientConnect;
	level.mpVignettePostfxActive = false;
	
	level.orbis = (GetDvarString( "orbisGame") == "true");
	level.durango = (GetDvarString( "durangoGame") == "true");
	
	level.cameras_active = false;

	clientfield::register( "world", "selectMenu", 1, GetMinBitCountForNum(15), "int", &menuSelected, !true, !true );
	clientfield::register( "actor", "zombie_has_eyes", 1, 1, "int", &zombie_eyes_clientfield_cb, !true, true);
	
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";

	level thread handle_forced_streaming();
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

function handle_forced_streaming()
{
	loaded = false;
	while( !loaded )
	{
		// TODO: Remove the HERO_MESH_LODS_ defines from this file when this is removed (currently being used for the "sitting bull" but will be swapped to customized character)
		loaded = ForceStreamXModel( "c_54i_cqb_mpc_fb_fe", 0, 1, true );
		if( loaded )
		{
			break;
		}
		wait 0.25;
	}

	setScriptStreamBias( 1.0 );
	forceStreamWeapons();

	character_customization::handle_forced_streaming( "cp" );
	character_customization::handle_forced_streaming( "mp" );
}

function transition_camera_immediate( localClientNum, weaponType, camera, subxcam, lerpDuration, notetrack )
{
	xcam = GetWeaponXCam( level.current_weapon, camera );

	if( !IsDefined( xcam ) )
	{
		xcam = GetWeaponXCam( GetWeapon( "ar_standard" ), camera );
	}
	
	self.lastXcam[weaponType] = xcam;
	self.lastSubxcam[weaponType] = subxcam;
	self.lastNotetrack[weaponType] = notetrack;

	position = struct::get( "paintshop_weapon_position" );
	model = level.weapon_script_model;
	
	model.origin = position.origin;
	model.angles = position.angles;

	PlayMainCamXCam( localClientNum, xcam, lerpDuration, subxcam, notetrack, position.origin, position.angles, model );
}

function update_weapon_script_model( newWeaponString )
{
	level.last_weapon_name = newWeaponString;
	level.current_weapon = GetWeaponWithAttachments( level.last_weapon_name );
	level.weapon_script_model UseWeaponModel( level.current_weapon );
	
	if( IsDefined( level.weapon_script_model ) && IsDefined(level.attachment_names) && IsDefined( level.attachment_indices) )
	{
		for( i = 0; i < level.attachment_names.size; i++ )
		{
			level.weapon_script_model SetAttachmentCosmeticVariantIndex( newWeaponString, level.attachment_names[i], level.attachment_indices[i] );
		}
	}
	self notify( "weaponMovedSuccessfully" );
}

function update_weapon_on_xcam_moved( newWeaponString )
{
	self endon("weaponMovedSuccessfully");
	self waittill("xcamMoved");

	update_weapon_script_model( newWeaponString );
}

function transition_camera( localClientNum, weaponType, camera, subxcam, initialDelay, lerpDuration, notetrack, newWeaponString )
{
	self endon("entityshutdown");
	self notify("xcamMoved");
	self endon("xcamMoved");

	if( isDefined(newWeaponString) )
	{
		self notify("weaponMovedSuccessfully");
		self thread update_weapon_on_xcam_moved( newWeaponString );
	}

	wait initialDelay;

	transition_camera_immediate( localClientNum, weaponType, camera, subxcam, lerpDuration, notetrack );

	if( isDefined(newWeaponString) )
	{
		wait lerpDuration / 1000;

		self notify("weaponMovedSuccessfully");
		update_weapon_script_model( newWeaponString );
	}
}

function restore_camera( localClientNum, type )
{
	if( isDefined(self.lastXcam) && isDefined(self.lastSubxcam ) )
	{
		if( type == "primary" )
		{
			position = struct::get( "paintshop_weapon_position" );
			model = level.weapon_script_model;
			PlayMainCamXCam( localClientNum, self.lastXcam[type], 0, self.lastSubxcam[type], self.lastNotetrack[type], position.origin, position.angles );
		}
	}
}

function get_weapon_with_attachments( weaponName, weaponAndAttachments )
{
	wpnparam = strtok(weaponAndAttachments, "+");
	switch( wpnparam.size )
	{
		case 2:
			return GetWeapon( weaponName, wpnparam[1] );
		case 3:
			return GetWeapon( weaponName, wpnparam[1], wpnparam[2] );
		case 4:
			return GetWeapon( weaponName, wpnparam[1], wpnparam[2], wpnparam[3] );
		case 5:
			return GetWeapon( weaponName, wpnparam[1], wpnparam[2], wpnparam[3], wpnparam[4] );
		case 6:
			return GetWeapon( weaponName, wpnparam[1], wpnparam[2], wpnparam[3], wpnparam[4], wpnparam[5] );
		case 7:
			return GetWeapon( weaponName, wpnparam[1], wpnparam[2], wpnparam[3], wpnparam[4], wpnparam[5], wpnparam[6] );
		case 8:
			return GetWeapon( weaponName, wpnparam[1], wpnparam[2], wpnparam[3], wpnparam[4], wpnparam[5], wpnparam[6], wpnparam[7] );
		default:
			return GetWeapon( weaponName );
	}
}

function get_attachments_intersection( oldWeapon, newWeapon )
{
	if( !isDefined(oldWeapon) )
	{
		return newWeapon;
	}

	oldWeaponParams = strtok(oldWeapon, "+");
	newWeaponParams = strtok(newWeapon, "+");
	
	if( oldWeaponParams[0] != newWeaponParams[0] )
	{
		return newWeapon;
	}
	
	newWeaponString = newWeaponParams[0];
	
	for ( i = 1; i < newWeaponParams.size; i++ )
	{
		if( isinarray( oldWeaponParams, newWeaponParams[i] ) )
		{
			newWeaponString += "+" + newWeaponParams[i];
		}
	}
	
	return newWeaponString;
}

function update_cac_personalization( localClientNum, type, wpnNameWithSuffix, weaponFullName )
{
	weaponAndAttachmentList = strtok(weaponFullName, "+");
	
	if( ( isDefined(level.loadout_slot_name) && level.loadout_slot_name == type ) && isDefined(level.weapon_base_name) && ( level.weapon_base_name + "_" + level.game_mode_suffix == wpnNameWithSuffix ) )
	{
		level.weapon_clientscript_cac_model[type] SetWeaponRenderOptions( level.camo_index, level.reticle_index, level.show_player_tag, level.show_emblem, level.show_paintshop );

		for( i = 0; i < level.attachment_names.size; i++ )
		{
			if( IsInArray( weaponAndAttachmentList, level.attachment_names[i] ) )
			{
				level.weapon_clientscript_cac_model[type] SetAttachmentCosmeticVariantIndex( weaponFullName, level.attachment_names[i], level.attachment_indices[i] );
			}
			else
			{
				level.weapon_clientscript_cac_model[type] SetAttachmentCosmeticVariantIndex( weaponFullName, level.attachment_names[i], 0 );
			}
		}
	}
}

function handle_paintshop( localClientNum )
{
	level endon( "disconnect" );
	level endon( "cam_paintshop_end" );
	
	weapon_position = struct::get("paintshop_weapon_position");
	lastCameraCloseUp = false;

	while( true )
	{
		level waittill( "cam_paintshop", camera, weaponName );
		stopMPHeroVignettePostfx( localClientNum );

		// Set the weapon model
		if( isdefined(level.paintshop_weapon_script_model) )
		{
			level.paintshop_weapon_script_model forcedelete();
		}
		
		if( isdefined(camera) && isdefined(weaponName) )
		{
			weapon = GetWeapon(weaponName);
			if( isDefined(weapon) )
			{
				paintshop_bg = GetEnt( localClientNum, "paintshop_black", "targetname" );
				if( IsDefined( paintshop_bg ) && ( camera == "left" || camera == "right" || camera == "top") )
				{
					paintshop_bg show();
					KillRadiantExploder( localClientNum, "lights_paintshop" );
					PlayRadiantExploder( localClientNum, "lights_paintshop_zoom" );
				}
				else if( IsDefined( paintshop_bg ) )
				{
					paintshop_bg hide();
					KillRadiantExploder( localClientNum, "lights_paintshop_zoom" );
					PlayRadiantExploder( localClientNum, "lights_paintshop" );
				}
				
				level.paintshop_weapon_script_model = spawn_weapon_model( localClientNum, weapon_position.origin, weapon_position.angles );
				level.paintshop_weapon_script_model UseWeaponModel( weapon );
				showPaintshop = ( camera == "select" ? false : true );
				level.paintshop_weapon_script_model SetWeaponRenderOptions( 0, 0, false, false, showPaintshop );
				xcamName = GetWeaponXCam(weapon, "cam_paintshop");
				cameraCloseUp = ( camera == "left" || camera == "right" || camera == "top");
				
				if( cameraCloseUp == lastCameraCloseUp )
				{
					duration = 500;
				}
				else
				{
					duration = 500;
				}
				
				if( isDefined(xcamName) )
				{
					PlayMainCamXCam( localClientNum, xcamName, duration, "cam_paintshop", camera, weapon_position.origin, weapon_position.angles, level.paintshop_weapon_script_model );
				}
				
				lastCameraCloseUp = cameraCloseUp;
			}
		}
	}
}

function handle_paintshop_exit( localClientNum )
{
	level endon( "disconnect" );

	while( true )
	{
		level waittill( "cam_paintshop_end" );
		
		StopMainCamXCam( localClientNum );

		if( isdefined(level.paintshop_weapon_script_model) )
		{
			level.paintshop_weapon_script_model forcedelete();
		}
		
		if( SessionModeIsMultiplayerGame() )
		{
			playMPHeroVignetteCam( localClientNum, level.mp_lobby_data_struct );
		}
		
		level thread handle_paintshop( localClientNum );
	}
}

function get_camo_index()
{
	if( !IsDefined( level.camo_index ) )
	{
		level.camo_index = 0;
	}

	return level.camo_index;
}

function get_reticle_index()
{
	if( !IsDefined( level.reticle_index ) )
	{
		level.reticle_index = 0;
	}

	return level.reticle_index;
}

function get_show_payer_tag()
{
	if( !IsDefined( level.show_player_tag ) )
	{
		level.show_player_tag = false;
	}

	return level.show_player_tag;
}

function get_show_emblem()
{
	if( !IsDefined( level.show_emblem ) )
	{
		level.show_emblem = false;
	}

	return level.show_emblem;
}

function get_show_paintshop()
{
	if( !IsDefined( level.show_paintshop ) )
	{
		level.show_paintshop = false;
	}

	return level.show_paintshop;
}


function handle_cac_customization_opened( localClientNum )
{
	level endon( "disconnect" );
	weapon_position = struct::get( "paintshop_weapon_position" );

	while( true )
	{
		level waittill( "cam_customization_opened", param1, param2, param3, param4 );
		
		KillRadiantExploder( localClientNum, "lights_paintshop_zoom" );
		PlayRadiantExploder( localClientNum, "lights_paintshop" );
		
		weaponName = param1 + "_" + param2;
		level.game_mode_suffix = param2;
		weapon = get_weapon_with_attachments( param1, param3 );
		level.personalization_xcamName = GetWeaponXCam( weapon, "cam_cac_attachments" );
		selection_type = "select01";
		weapon_position = struct::get( "paintshop_weapon_position" );
		
		response_messages = strtok( param4, ",");
		level.loadout_slot_name = response_messages[0];
		level.weapon_base_name = response_messages[1];
		level.weapon_name = response_messages[2];
		level.camo_index = int( response_messages[3] );
		level.reticle_index = int( response_messages[4] );
		level.show_player_tag = false;
		level.show_emblem = false;
		level.show_paintshop = int( response_messages[5] );

		//Attachment Cosmetic Variant
		attachments_start_index = 6;
		attachments_size = response_messages.size - attachments_start_index;
		
		level.attachment_names = [];
		level.attachment_indices = [];
		
		for( i = attachments_start_index; i + 1 < response_messages.size; i += 2 )
		{
			level.attachment_names[level.attachment_names.size] = response_messages[i];
			level.attachment_indices[level.attachment_indices.size] = int(response_messages[i+1]);
		}
		
		if( IsDefined( level.weapon_script_model) )
		{
			for( i = 0; i < level.attachment_names.size; i++ )
			{
				level.weapon_script_model SetAttachmentCosmeticVariantIndex( level.weapon_name, level.attachment_names[i], level.attachment_indices[i] );
			}
		}

		camera_name = selection_type;
		if( selection_type == "paintjob" || selection_type == "camo" || selection_type == "reticle" )
		{
			camera_name = "select01";
		}
		
		if( isDefined( level.personalization_xcamName ) && IsDefined( level.weapon_script_model ) )
		{
			base_weapon_slot = "primary";
			level.weapon_script_model.origin = weapon_position.origin;
			level.weapon_script_model.angles = weapon_position.angles;
			level transition_camera_immediate( localClientNum, base_weapon_slot, "cam_cac_weapon", "cam_cac", 250, camera_name );
		}
	}
}

function handle_cac_customization_closed( localClientNum )
{
	level endon("disconnect");
	weapon_position = struct::get("paintshop_weapon_position");

	while( true )
	{
		level waittill( "cam_customization_closed", param1, param2, param3, param4 );

		level restore_camera( localClientNum, "primary" );

		camera = "select01";
		base_weapon_slot = "primary";
		level transition_camera_immediate( localClientNum, base_weapon_slot, "cam_cac_weapon", "cam_cac", 250, camera );

		if( IsDefined( level.weapon_clientscript_cac_model ) && IsDefined( level.weapon_clientscript_cac_model[level.loadout_slot_name] ) )
		{
			level.weapon_clientscript_cac_model[level.loadout_slot_name] SetWeaponRenderOptions( level.camo_index, level.reticle_index, level.show_player_tag, level.show_emblem, level.show_paintshop );
			for( i = 0; i < level.attachment_names.size; i++ )
			{
				level.weapon_clientscript_cac_model[level.loadout_slot_name] SetAttachmentCosmeticVariantIndex( level.weapon_name, level.attachment_names[i], level.attachment_indices[i] );
			}
		}
		continue;
	}
}

function handle_cac_customization_weaponoption( localClientNum )
{
	level endon("disconnect");
	weapon_position = struct::get("paintshop_weapon_position");

	while( true )
	{
		level waittill( "cam_customization_wo", weapon_option, weapon_option_new_index );

		if( IsDefined( level.weapon_script_model ) )
		{
			switch( weapon_option )
			{
				case "camo":
					level.camo_index = int( weapon_option_new_index );
					break;
				case "reticle":
					level.reticle_index = int( weapon_option_new_index );
					break;
				case "paintjob":
					level.show_paintshop = int( weapon_option_new_index );
					break;
				default:
					
					break;
			}

			level.weapon_script_model SetWeaponRenderOptions( get_camo_index(), get_reticle_index(), get_show_payer_tag(), get_show_emblem(), get_show_paintshop() );
		}
	}
}

function handle_cac_customization_attachmentvariant( localClientNum )
{
	level endon("disconnect");
	weapon_position = struct::get("paintshop_weapon_position");

	while( true )
	{
		level waittill( "cam_customization_acv", weapon_attachment_name, acv_index );
		
		for ( i = 0; i < level.attachment_names.size; i++ )
		{
			if( level.attachment_names[i] == weapon_attachment_name )
			{
				level.attachment_indices[i] = int( acv_index );
				break;
			}
		}

		if( IsDefined( level.weapon_script_model ) )
		{
			level.weapon_script_model SetAttachmentCosmeticVariantIndex( level.weapon_name, weapon_attachment_name, int( acv_index ) );
		}
	}
}

function handle_cac_customization_focus( localClientNum )
{
	level endon("disconnect");
	weapon_position = struct::get("paintshop_weapon_position");

	while( true )
	{
		level waittill( "cam_customization_focus", selection_type, param2, param3, param4 );

		camera_name = selection_type;
		if( selection_type == "paintjob" || selection_type == "camo" || selection_type == "reticle" )
		{
			camera_name = "select01";
		}
		
		if( isDefined(level.personalization_xcamName) && isDefined(level.weapon_script_model) )
		{
			level.weapon_script_model.origin = weapon_position.origin;
			level.weapon_script_model.angles = weapon_position.angles;
			PlayMainCamXCam( localClientNum, level.personalization_xcamName, 250, "cam_cac", camera_name, weapon_position.origin, weapon_position.angles, level.weapon_script_model );
		}
	}
}

function handle_cac_customization( localClientNum )
{
	self.lastXcam = [];
	self.lastSubxcam = [];
	self.lastNotetrack = [];

	self thread handle_cac_customization_opened( localClientNum );
	self thread handle_cac_customization_closed( localClientNum );
	self thread handle_cac_customization_weaponoption( localClientNum );
	self thread handle_cac_customization_attachmentvariant( localClientNum );
	self thread handle_cac_customization_focus( localClientNum );
}

function custom_class_start_threads( localClientNum )
{
	level endon( "disconnect" );
	
	while( 1 )
	{
		level thread custom_class_update( localClientNum );
		level thread custom_class_attachment_select_focus( localClientNum );
		level thread custom_class_remove( localClientNum );
		level thread custom_class_closed( localClientNum );	
		
		level util::waittill_any( "CustomClass_update", "CustomClass_focus", "CustomClass_remove", "CustomClass_closed" );
	}
}

function custom_class_init( localClientNum )
{
	level.last_weapon_name = "";
	level.current_weapon = undefined;

	custom_class_start_threads( localClientNum );
}

function custom_class_update( localClientNum )
{
	level endon( "disconnect" );
	level endon( "CustomClass_focus" );
	level endon( "CustomClass_remove" );
	level endon( "CustomClass_closed" );
	
	level waittill( "CustomClass_update", param1, param2, param3, param4, param5, param6 );
	
	KillRadiantExploder( localClientNum, "lights_paintshop_zoom" );
	PlayRadiantExploder( localClientNum, "lights_paintshop" );
	
	base_weapon_slot = param1;
	weapon_full_name = param2;
	camera = param3; //"select01", "select02", or "select03"
	weapon_options_param = param4;
	acv_param = param5;
	use_gunsmith_camera = param6;

	if( IsDefined( weapon_full_name ) )
	{
		if( IsDefined( acv_param ) )
		{
			acv_indexes = strtok( acv_param, "," );
			
			level.attachment_names = [];
			level.attachment_indices = [];

			for( i = 0; i + 1 < acv_indexes.size; i += 2 )
			{
				level.attachment_names[level.attachment_names.size] = acv_indexes[i];
				level.attachment_indices[level.attachment_indices.size] = int( acv_indexes[i+1] );
			}
		}

		if( level.last_weapon_name != weapon_full_name )
		{
			position = struct::get( "paintshop_weapon_position" );
			
			if( !IsDefined( level.weapon_script_model ) )
			{
				level.weapon_script_model = spawn_weapon_model( localClientNum, position.origin, position.angles );
			}
			
			update_weapon_script_model( weapon_full_name );
		}
		else
		{
			level notify( "weaponMovedSuccessfully" );
		}
		
		if( IsDefined( weapon_options_param ) )
		{
			weapon_options = strtok( weapon_options_param, "," );
			camo_index = int( weapon_options[0] );
			show_player_tag = false;
			show_emblem = false;
			reticle_index = int( weapon_options[1] );
			paintjob_index = int( weapon_options[2] );
			
			if( IsDefined( weapon_options ) && IsDefined( level.weapon_script_model ) )
			{
				level.weapon_script_model SetWeaponRenderOptions( camo_index, reticle_index, show_player_tag, show_emblem, paintjob_index );
			}
		}
		
		level notify( "xcamMoved" );

		if( IsDefined( use_gunsmith_camera ) && use_gunsmith_camera == true )
		{
			level transition_camera_immediate( localClientNum, base_weapon_slot, "cam_gunsmith_weapon", "cam_gunsmith", 0, camera );
		}
		else
		{
			level transition_camera_immediate( localClientNum, base_weapon_slot, "cam_cac_weapon", "cam_cac", 0, camera );
		}
	}
}

function custom_class_attachment_select_focus( localClientNum )
{
	level endon( "disconnect" );
	level endon( "CustomClass_update" );
	level endon( "CustomClass_remove" );
	level endon( "CustomClass_closed" );
	
	level waittill( "CustomClass_focus", param1, param2, param3, param4, param5, param6 );
	
	base_weapon_slot = param1;
	weapon_full_name = param2;
	camera = param3;//"select01" or "select02" or "select03";
	attachment = param4;
	acv_param = param5;

	weaponAttachmentIntersection = get_attachments_intersection( level.last_weapon_name, weapon_full_name );
	if( IsDefined( acv_param ) )
	{
		acv_indexes = strtok( acv_param, "," );
		
		level.attachment_names = [];
		level.attachment_indices = [];

		for( i = 0; i + 1 < acv_indexes.size; i += 2 )
		{
			level.attachment_names[level.attachment_names.size] = acv_indexes[i];
			level.attachment_indices[level.attachment_indices.size] = int( acv_indexes[i+1] );
		}
	}
	
	if( attachment == "acog" || attachment == "reflex" )
	{
		weaponAttachmentIntersection = weapon_full_name;
	}
	
	update_weapon_script_model( weaponAttachmentIntersection );

	//update camera transitions
	if( weapon_full_name == weaponAttachmentIntersection )
	{
		weapon_full_name = undefined;
	}
	
	level thread transition_camera( localClientNum, base_weapon_slot, "cam_cac_attachments", "cam_cac", .30, 400, attachment, weapon_full_name );
}

function custom_class_remove( localClientNum )
{
	level endon( "disconnect" );
	level endon( "CustomClass_update" );
	level endon( "CustomClass_focus" );
	level endon( "CustomClass_closed" );
	
	level waittill( "CustomClass_remove", param1, param2, param3, param4, param5, param6 );
	
	//creating a default position for the camera in case we land on a loadout slot that doesn't have a model (perks and wildcards)
	position = struct::get( "paintshop_weapon_position" );
	camera = "select01";
	xcamName = "ui_cam_cac_ar_standard";
	PlayMainCamXCam( localClientNum, xcamName, 250, "cam_cac_weapon", camera, position.origin, position.angles );
	
	if( IsDefined( level.weapon_script_model ) )
	{
		level.weapon_script_model forcedelete();
	}
	level.last_weapon_name = "";
}

function custom_class_closed( localClientNum )
{
	level endon( "disconnect" );
	level endon( "CustomClass_update" );
	level endon( "CustomClass_focus" );
	level endon( "CustomClass_remove" );
	
	level waittill( "CustomClass_closed", param1, param2, param3, param4, param5, param6 );
	
	StopMainCamXCam( localClientNum );
		
	if( IsDefined( level.weapon_script_model ) )
	{
		level.weapon_script_model forcedelete();
	}
	level.last_weapon_name = "";
}

function spawn_weapon_model( localClientNum, origin, angles )
{
	weapon_model = Spawn( localClientNum, origin, "script_model" );
	
	if( IsDefined( angles ) )
	{
		weapon_model.angles = angles;
	}

	weapon_model SetHighDetail();

	return weapon_model;
}

function choose_class_hero_preview( localClientNum )
{
	level endon( "disconnect" );
	level endon( "choose_class_preview_closed" );
	
	characterModel = GetEnt( localClientNum, "character_customization", "targetname" );
	
	while( 1 )
	{
		level waittill( "choose_class_preview", eventType, param1, param2, param3, param4 );
		
		if( eventType == "opened" )
		{
			level notify( "updateHero", "refresh" );

			//setup camera
			xcamName = "ui_cam_cac_specialist";
			position = struct::get( "personalizeHero_camera" );
			cameraName = "cam_specialist";
			notetrack = "";

			stopMPHeroVignettePostfx( localClientNum );
			PlayMainCamXCam( localClientNum, xcamName, 250, cameraName, notetrack, position.origin, position.angles );
		}
		else if( eventType == "closed" )
		{
			playMPHeroVignetteCam( localClientNum, level.mp_lobby_data_struct );
		}
	}
}

function choose_class_hero_preview_closed( localClientNum )
{
	level endon( "disconnect" );
	
	while( 1 )
	{
		level waittill( "choose_class_preview_closed", eventType, param1, param2, param3, param4 );
		if( isDefined(eventType) && eventType == "1" )
		{
			playMPHeroVignetteCam( localClientNum, level.mp_lobby_data_struct );
		}
		level thread choose_class_hero_preview( localClientNum );
	}
}

function stopPostFx()
{
}

function startPostFx()
{
}

function stopMPHeroVignettePostfx( localClientNum )
{
	if( !level.mpVignettePostfxActive )
	{
		return;
	}

	level.mpVignettePostfxActive = false;
	player = GetLocalPlayer( localClientNum );
	player thread stopPostFx();
}

function startMPHeroVignettePostfx( localClientNum )
{
	if( level.mpVignettePostfxActive )
	{
		return;
	}

	player = GetLocalPlayer( localClientNum );
	player thread startPostFx();
	level.mpVignettePostfxActive = true;
}

function playMPHeroVignetteCam( localClientNum, data_struct )
{
	fields = GetHeroFields( data_struct.currentHeroIndex );
	
	if( isDefined(fields) && isDefined(fields.frontendVignetteStruct) )
	{
		position = struct::get(fields.frontendVignetteStruct);
		PlayMainCamXCam( localClientNum, fields.frontendVignetteXCam, 0, "", "", position.origin, position.angles );

		startMPHeroVignettePostfx( localClientNum );
	}
}

function menuSelected(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{	
	if ( newVal !== oldVal && isdefined( oldVal ) )
	{
		if ( oldVal === 9 )
		{
			level notify( "done_personalizing_hero" );
		}
		else if ( oldVal === 10 )
		{
			level.liveCCData.hide_helmet = false;
			level notify( "done_personalizing_hero" );
		}
		else if ( oldVal === 10 )
		{
			level.liveCCData.hide_helmet = false;
			level notify( "done_personalizing_hero" );
		}
		else if ( oldVal === 14 )
		{
			character_customization::update_use_frozen_moments( localClientNum, level.liveCCData, false );
			startMPHeroVignettePostfx( localClientNum );
		}
	}

	if( newVal !== 0 )
	{
		stopMPHeroVignettePostfx( localClientNum );
	}
			
	needHeroExtracam = false;
			
	if( newVal == 7 || newVal == 5 )
	{
		if ( !isdefined( level.lastCameraSetup ) || level.lastCameraSetup != "weapon" )
		{
			paintshop_bg = GetEnt( localClientNum, "paintshop_black", "targetname" );
			paintshop_bg hide();
			level.lastCameraSetup = "weapon";
		}
	}
	else if ( newVal == 8 )
	{
		StopMainCamXCam( localClientNum );
		needHeroExtracam = true;
		if ( !isdefined( level.lastCameraSetup ) || level.lastCameraSetup != "hero" )
		{
			level.lastCameraSetup = "hero";
			multi_extracam::extracam_init_index( localClientNum, "character_staging_extracam2", 1);
			
			camera_ent = level.camera_ents[1];
			assert( isdefined( camera_ent ) );
			camera_ent PlayExtraCamXCam( "ui_cam_character_customization", 0, "cam_menu" );
		}
	}
	else if ( newVal == 14 )
	{
		stopMPHeroVignettePostfx( localClientNum );
		StopMainCamXCam( localClientNum );
		character_customization::update_use_frozen_moments( localClientNum, level.liveCCData, true );
		needHeroExtracam = true;
		if ( !isdefined( level.lastCameraSetup ) || level.lastCameraSetup != "hero" )
		{
			level.lastCameraSetup = "hero";
			multi_extracam::extracam_init_index( localClientNum, "character_staging_extracam2", 1);
			
			camera_ent = level.camera_ents[1];
			assert( isdefined( camera_ent ) );
			camera_ent PlayExtraCamXCam( "ui_cam_character_customization", 0, "cam_menu" );
		}
	}
	else if ( newVal == 10 )
	{
		StopMainCamXCam( localClientNum );
		needHeroExtracam = true;
		if ( !isdefined( level.lastCameraSetup ) || level.lastCameraSetup != "hero" )
		{
			level.lastCameraSetup = "hero";
			multi_extracam::extracam_init_index( localClientNum, "character_staging_extracam2", 1);
			
			camera_ent = level.camera_ents[1];
			assert( isdefined( camera_ent ) );
			camera_ent PlayExtraCamXCam( "ui_cam_character_customization", 0, "cam_menu" );
		}
		
		if ( oldVal != 10  )
		{
			level notify ( "begin_personalizing_hero" );
		}
	}
	else if ( newVal == 9 )
	{
		StopMainCamXCam( localClientNum );
		needHeroExtracam = false;
		
		if ( oldVal != 9 )
		{
			level notify ( "begin_personalizing_hero" );
		}
	}
	else if ( newVal == 0 )
	{
		if ( SessionModeIsMultiplayerGame() )
		{
			character_index = GetEquippedHeroIndex( localClientNum );
			fields = GetHeroFields( character_index );
	
			params = spawnstruct();
			if(!isdefined(fields))fields=spawnstruct();
			
			if( isDefined(fields.frontendVignetteStruct) )
			{
				params.align_struct = struct::get( fields.frontendVignetteStruct );
			}
			params.anim_name = fields.frontendVignetteXAnim;
			params.weapon_left = fields.frontendVignetteWeaponLeftModel;
			params.weapon_left_anim = fields.frontendVignetteWeaponLeftAnim;
			params.weapon_right = fields.frontendVignetteWeaponModel;
			params.weapon_right_anim = fields.frontendVignetteWeaponAnim;
			
			character_customization::loadEquippedCharacterOnModel( localClientNum, level.mp_lobby_data_struct, character_index, params );
	
			playMPHeroVignetteCam( localClientNum, level.mp_lobby_data_struct );
		}
	}
	else if ( newVal == 1 )
	{
		if ( SessionModeIsCampaignGame() )
		{
			a_str_bunk_scenes[0] = "cp_cac_cp_lobby_idle";
			//a_str_bunk_scenes[1] = "cin_fe_cp_bunk_vign_smoke_read"; TODO uncomment once this is ready for primetime
			//a_str_bunk_scenes[2] = "cin_fe_cp_bunk_vign_smoke"; TODO uncomment once this is ready for primetime
			
			params = spawnstruct();
			params.scene = a_str_bunk_scenes[ RandomInt( a_str_bunk_scenes.size ) ];
			
			character_customization::loadEquippedCharacterOnModel( localClientNum, level.cp_lobby_data_struct, undefined, params );
		}
	}
	else if ( newVal == 13 )
	{
		needHeroExtracam = true;
		if ( !isdefined( level.lastCameraSetup ) || level.lastCameraSetup != "hero" )
		{
			level.lastCameraSetup = "hero";
			multi_extracam::extracam_init_index( localClientNum, "character_staging_extracam2", 1);
			
			camera_ent = level.camera_ents[1];
			assert( isdefined( camera_ent ) );
			camera_ent PlayExtraCamXCam( "ui_cam_character_customization", 0, "cam_preview" );
		}
	}
	else if ( newVal == 12 )
	{
		needHeroExtracam = true;
		if ( !isdefined( level.lastCameraSetup ) || level.lastCameraSetup != "hero" )
		{
			level.lastCameraSetup = "hero";
			multi_extracam::extracam_init_index( localClientNum, "character_staging_extracam2", 1);
			
			camera_ent = level.camera_ents[1];
			assert( isdefined( camera_ent ) );
			camera_ent PlayExtraCamXCam( "ui_cam_character_customization", 0, "cam_preview" );
		}
	}
	else
	{
		StopMainCamXCam( localClientNum );
	}
	
	if( !needHeroExtraCam )
	{
		multi_extracam::extracam_reset_index( 1 );
		level.lastCameraSetup = undefined;
	}
}

function entityspawned(localClientNum)
{
}

function localClientConnect(localClientNum)
{
	/# println( "*** Client script VM : Local client connect " + localClientNum ); #/
	
	player = GetLocalPlayer( localClientNum );
	assert( isdefined( player ) );

	if ( isdefined( level.onPlayerConnect ) )
	{
		level thread [[ level.onPlayerConnect ]]( localclientnum );
	}
	
	if ( isdefined( level._customPlayerConnectFuncs ) )
	{
		[[ level._customPlayerConnectFuncs ]]( player, localClientNum );
	}	
	
	if ( isdefined( level.characterCustomizationSetup ) )
	{
		[[ level.characterCustomizationSetup ]]( localclientnum );
	}
	
	// mp lobby character
	level.mp_lobby_data_struct = character_customization::create_character_data_struct( GetEnt( localClientNum, "customization", "targetname" ) );
	
	// cp lobby character
	lobbyModel = util::spawn_model( localClientNum, "tag_origin", (0,0,0) );
	lobbyModel.targetname = "cp_lobby_player_model";
	level.cp_lobby_data_struct = character_customization::create_character_data_struct( lobbyModel, level.characterModelTypes["CCBODY_MODEL_ANIMATION"] );
	
	player callback::Callback( #"on_localclient_connect", localClientNum );
	
	level thread choose_class_hero_preview( localClientNum );
	level thread choose_class_hero_preview_closed( localClientNum );
	level thread custom_class_init( localClientNum );
	level thread handle_paintshop( localClientNum );
	level thread handle_paintshop_exit( localClientNum );
	level thread handle_cac_customization( localClientNum );

	menuSelected( localClientNum, undefined, level clientfield::get( "selectMenu" ), undefined, undefined, undefined );
}	

function onPrecacheGameType()
{
}

function onStartGameType()
{
}
