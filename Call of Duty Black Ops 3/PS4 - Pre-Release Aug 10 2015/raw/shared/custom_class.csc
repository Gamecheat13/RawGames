
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
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
#using scripts\shared\lui_shared;
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       




	
#namespace customclass;

function init()
{
	level.weaponNone = GetWeapon( "none" );
	level.weapon_position = struct::get("paintshop_weapon_position");
}

function custom_class_update( localClientNum )
{
	level endon( "disconnect" );
	level endon( "CustomClass_focus" );
	level endon( "CustomClass_remove" );
	level endon( "CustomClass_closed" );
	
	level waittill( "CustomClass_update", param1, param2, param3, param4, param5, param6 );
	
	base_weapon_slot = param1;
	weapon_full_name = param2;
	camera = param3; //"select01", "select02", or "select03"
	weapon_options_param = param4;
	acv_param = param5;

	if( IsDefined( weapon_full_name ) )
	{
		if( IsDefined( acv_param ) && acv_param != "none" )
		{
			set_attachment_cosmetic_variants( acv_param );
		}

		if( IsDefined( weapon_options_param ) && weapon_options_param != "none" )
		{
			set_weapon_options( weapon_options_param );
		}
		
		if( level.last_weapon_name != weapon_full_name )
		{
			position = level.weapon_position;
			
			if( !IsDefined( level.weapon_script_model ) )
			{
				level.weapon_script_model = spawn_weapon_model( localClientNum, position.origin, position.angles );
				level.preload_weapon_model = spawn_weapon_model( localClientNum, position.origin, position.angles );
				level.preload_weapon_model Hide();
			}
			
			update_weapon_script_model( localClientNum, weapon_full_name );
		}
		
		level notify( "xcamMoved" );

		lerpDuration = get_lerp_duration( camera );
		setup_paintshop_bg( localClientNum, camera );
		level transition_camera_immediate( localClientNum, base_weapon_slot, "cam_cac_weapon", "cam_cac", lerpDuration, camera );
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
	attachment = param3;
	weapon_options_param = param4;
	acv_param = param5;

	update_weapon_options = false;
	weaponAttachmentIntersection = get_attachments_intersection( level.last_weapon_name, weapon_full_name );
	
	if( IsDefined( acv_param ) && acv_param != "none" )
	{
		set_attachment_cosmetic_variants( acv_param );
	}
	
	if( IsDefined( weapon_options_param ) && weapon_options_param != "none" )
	{
		set_weapon_options( weapon_options_param );
	}
	
	if( attachment == "acog" || attachment == "reflex" || attachment == "ir" )
	{
		weaponAttachmentIntersection = weapon_full_name;
	}

	preload_weapon_model( localClientNum, weaponAttachmentIntersection, update_weapon_options );
	wait_preload_weapon();
	
	update_weapon_script_model( localClientNum, weaponAttachmentIntersection, update_weapon_options );

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
	position = level.weapon_position;
	camera = "select01";
	xcamName = "ui_cam_cac_ar_standard";
	PlayMainCamXCam( localClientNum, xcamName, 0, "cam_cac", camera, position.origin, position.angles );
	setup_paintshop_bg( localClientNum, camera );
	
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

	weapon_model SetHighDetail( true, true );

	return weapon_model;
}


function set_attachment_cosmetic_variants( acv_param )
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

function hide_paintshop_bg( localClientNum )
{
	paintshop_bg = GetEnt( localClientNum, "paintshop_black", "targetname" );
	if( IsDefined( paintshop_bg ) )
	{
		if( !IsDefined( level.paintshopHiddenPosition ) )
		{
			level.paintshopHiddenPosition = paintshop_bg.origin;
		}
		paintshop_bg hide();
		paintshop_bg moveto(level.paintshopHiddenPosition,0.01);
	}
}

function show_paintshop_bg( localClientNum )
{
	paintshop_bg = GetEnt( localClientNum, "paintshop_black", "targetname" );
	if( IsDefined( paintshop_bg ) )
	{
		paintshop_bg show();
		paintshop_bg moveto(level.paintshopHiddenPosition + (0,0,227),0.01);
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

function set_weapon_options( weapon_options_param )
{
	weapon_options = strtok( weapon_options_param, "," );

	level.camo_index = int( weapon_options[0] );
	level.show_player_tag = false;
	level.show_emblem = false;
	level.reticle_index = int( weapon_options[1] );
	level.show_paintshop = int( weapon_options[2] );
	
	if( IsDefined( weapon_options ) && IsDefined( level.weapon_script_model ) )
	{
		level.weapon_script_model SetWeaponRenderOptions( get_camo_index(), get_reticle_index(), get_show_payer_tag(), get_show_emblem(), get_show_paintshop() );
	}
}

function get_lerp_duration( camera )
{
	lerpDuration = 0;
	if( IsDefined( camera ) )
	{
		paintshopCameraCloseUp = ( camera == "left" || camera == "right" || camera == "top");
		if( paintshopCameraCloseUp )
		{
			lerpDuration = 500;
		}
	}

	return lerpDuration;
}

function setup_paintshop_bg( localClientNum, camera )
{
	if( IsDefined( camera ) )
	{
		paintshopCameraCloseUp = ( camera == "left" || camera == "right" || camera == "top");
		PlayRadiantExploder( localClientNum, "weapon_kick" );
		if( paintshopCameraCloseUp )
		{
			show_paintshop_bg( localCLientNum );
			KillRadiantExploder( localClientNum, "lights_paintshop" );
			KillRadiantExploder( localClientNum, "weapon_kick" );
			PlayRadiantExploder( localClientNum, "lights_paintshop_zoom" );
		}
		else
		{
			hide_paintshop_bg( localClientNum );
			KillRadiantExploder( localClientNum, "lights_paintshop_zoom" );
			PlayRadiantExploder( localClientNum, "lights_paintshop" );
			PlayRadiantExploder( localClientNum, "weapon_kick" );
		}
	}
}

function transition_camera_immediate( localClientNum, weaponType, camera, subxcam, lerpDuration, notetrack )
{
	xcam = GetWeaponXCam( level.current_weapon, camera );

	if( !IsDefined( xcam ) )
	{
		if( StrStartsWith( weaponType, "specialty" ) )
		{
			xcam = "ui_cam_cac_perk";
		}
		else if( StrStartsWith( weaponType, "bonuscard" ) )
		{
			xcam = "ui_cam_cac_wildcard";
		}
		else if( StrStartsWith( weaponType, "cybercore" ) || StrStartsWith( weaponType, "cybercom" ) )
		{
			xcam = "ui_cam_cac_perk";
		}
		else if ( StrStartsWith( weaponType, "bubblegum" ) )
		{
			xcam = "ui_cam_cac_perk";
		}
		else
		{
			xcam = GetWeaponXCam( GetWeapon( "ar_standard" ), camera );
		}
	}
	
	self.lastXcam[weaponType] = xcam;
	self.lastSubxcam[weaponType] = subxcam;
	self.lastNotetrack[weaponType] = notetrack;

	position = level.weapon_position;
	model = level.weapon_script_model;

	PlayMainCamXCam( localClientNum, xcam, lerpDuration, subxcam, notetrack, position.origin, position.angles, model, position.origin, position.angles );
	if( notetrack == "top" || notetrack == "right" || notetrack == "left" )
	{
		SetAllowXCamRightStickRotation( localClientNum, false );
	}
}

function wait_preload_weapon()
{
	if( level.preload_weapon_complete )
	{
		return;
	}

	level waittill( "preload_weapon_complete" );
}

function preload_weapon_watcher( localClientNum )
{
	level endon( "preload_weapon_changing" );
	level endon( "preload_weapon_complete" );

	while( true )
	{
		if( level.preload_weapon_model isStreamed() )
		{
			level.preload_weapon_complete = true;
			level notify( "preload_weapon_complete" );
			return;
		}

		wait 0.1;
	}
}

function preload_weapon_model( localClientNum, newWeaponString, should_update_weapon_options = true )
{
	level notify( "preload_weapon_changing" );

	level.preload_weapon_complete = false;
	current_weapon = GetWeaponWithAttachments( newWeaponString );
	if ( current_weapon == level.weaponNone )
	{
		level.preload_weapon_complete = true;
		level notify( "preload_weapon_complete" );
		return;
	}
	
	if( isDefined(current_weapon.frontendmodel) )
	{
		level.preload_weapon_model UseWeaponModel( current_weapon, current_weapon.frontendmodel );
	}
	else
	{
		level.preload_weapon_model UseWeaponModel( current_weapon );
	}
	
	if( IsDefined( level.preload_weapon_model ) )
	{
		if( IsDefined( level.attachment_names ) && IsDefined( level.attachment_indices ) )
		{
			for( i = 0; i < level.attachment_names.size; i++ )
			{
				level.preload_weapon_model SetAttachmentCosmeticVariantIndex( newWeaponString, level.attachment_names[i], level.attachment_indices[i] );
			}
		}
		
		if( should_update_weapon_options )
		{
			level.preload_weapon_model SetWeaponRenderOptions( get_camo_index(), get_reticle_index(), get_show_payer_tag(), get_show_emblem(), get_show_paintshop() );
		}
	}

	level thread preload_weapon_watcher( localClientNum );
}


function update_weapon_script_model( localClientNum, newWeaponString, should_update_weapon_options = true )
{
	level.last_weapon_name = newWeaponString;
	level.current_weapon = GetWeaponWithAttachments( level.last_weapon_name );
	if ( level.current_weapon == level.weaponNone  )
	{
		// for perks and wildcards
		level.weapon_script_model delete();
		position = level.weapon_position;
		level.weapon_script_model = spawn_weapon_model( localClientNum, position.origin, position.angles );
		level.weapon_script_model SetModel( level.last_weapon_name );
		level.weapon_script_model SetHighDetail( true, true );
		level.weapon_script_model SetDedicatedShadow( true );
		return;
	}
	
	if( isDefined(level.current_weapon.frontendmodel) )
	{
		level.weapon_script_model UseWeaponModel( level.current_weapon, level.current_weapon.frontendmodel );
	}
	else
	{
		level.weapon_script_model UseWeaponModel( level.current_weapon );
	}
	
	if( IsDefined( level.weapon_script_model ) )
	{
		if( IsDefined( level.attachment_names ) && IsDefined( level.attachment_indices ) )
		{
			for( i = 0; i < level.attachment_names.size; i++ )
			{
				level.weapon_script_model SetAttachmentCosmeticVariantIndex( newWeaponString, level.attachment_names[i], level.attachment_indices[i] );
			}
		}
		
		if( should_update_weapon_options )
		{
			level.weapon_script_model SetWeaponRenderOptions( get_camo_index(), get_reticle_index(), get_show_payer_tag(), get_show_emblem(), get_show_paintshop() );
		}
	}
	
	level.weapon_script_model SetDedicatedShadow( true );
}

function transition_camera( localClientNum, weaponType, camera, subxcam, initialDelay, lerpDuration, notetrack, newWeaponString, should_update_weapon_options = false )
{
	self endon( "entityshutdown" );
	self notify( "xcamMoved" );
	self endon( "xcamMoved" );
	level endon( "cam_customization_closed" );

	if( IsDefined( newWeaponString ) )
	{
		preload_weapon_model( localClientNum, newWeaponString, should_update_weapon_options );
	}

	wait initialDelay;

	transition_camera_immediate( localClientNum, weaponType, camera, subxcam, lerpDuration, notetrack );

	if( IsDefined( newWeaponString ) )
	{
		wait lerpDuration / 1000;

		wait_preload_weapon();

		update_weapon_script_model( localClientNum, newWeaponString, should_update_weapon_options );
	}
}

function restore_camera( localClientNum, type )
{
	if( isDefined(self.lastXcam) && isDefined(self.lastSubxcam ) )
	{
		if( type == "primary" )
		{
			position = level.weapon_position;
			model = level.weapon_script_model;
			PlayMainCamXCam( localClientNum, self.lastXcam[type], 0, self.lastSubxcam[type], self.lastNotetrack[type], position.origin, position.angles );
		}
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

function handle_cac_customization_focus( localClientNum )
{
	level endon( "disconnect" );
	level endon( "cam_customization_closed" );

	while( true )
	{
		level waittill( "cam_customization_focus", param1, param2 );

		base_weapon_slot = param1;
		notetrack = param2;
		if( IsDefined( level.weapon_script_model ) )
		{
			should_update_weapon_options = true;
			level thread customclass::transition_camera( localClientNum, base_weapon_slot, "cam_cac_weapon", "cam_cac", .30, 400, notetrack, level.last_weapon_name, should_update_weapon_options );
		}
	}
}

function handle_cac_customization_weaponoption( localClientNum )
{
	level endon("disconnect");
	level endon( "cam_customization_closed" );
	
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

			level.weapon_script_model SetWeaponRenderOptions( customclass::get_camo_index(), customclass::get_reticle_index(), customclass::get_show_payer_tag(), customclass::get_show_emblem(), customclass::get_show_paintshop() );
		}
	}
}

function handle_cac_customization_attachmentvariant( localClientNum )
{
	level endon( "disconnect" );
	level endon( "cam_customization_closed" );
	
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
			level.weapon_script_model SetAttachmentCosmeticVariantIndex( level.last_weapon_name, weapon_attachment_name, int( acv_index ) );
		}
	}
}

function handle_cac_customization_closed( localClientNum )
{
	level endon("disconnect");
	
	level waittill( "cam_customization_closed", param1, param2, param3, param4 );

	level customclass::restore_camera( localClientNum, "primary" );

	camera = "select01";
	base_weapon_slot = "primary";
	level customclass::transition_camera_immediate( localClientNum, base_weapon_slot, "cam_cac_weapon", "cam_cac", 250, camera );

	if( IsDefined( level.weapon_clientscript_cac_model ) && IsDefined( level.weapon_clientscript_cac_model[level.loadout_slot_name] ) )
	{
		level.weapon_clientscript_cac_model[level.loadout_slot_name] SetWeaponRenderOptions( customclass::get_camo_index(), customclass::get_reticle_index(), customclass::get_show_payer_tag(), customclass::get_show_emblem(), customclass::get_show_paintshop() );
		for( i = 0; i < level.attachment_names.size; i++ )
		{
			level.weapon_clientscript_cac_model[level.loadout_slot_name] SetAttachmentCosmeticVariantIndex( level.last_weapon_name, level.attachment_names[i], level.attachment_indices[i] );
		}
	}
}

function handle_cac_customization( localClientNum )
{
	level endon( "disconnect" );

	self.lastXcam = [];
	self.lastSubxcam = [];
	self.lastNotetrack = [];

	while( 1 )
	{
		level thread handle_cac_customization_focus( localClientNum );
		level thread handle_cac_customization_weaponoption( localClientNum );
		level thread handle_cac_customization_attachmentvariant( localClientNum );
		level thread handle_cac_customization_closed( localClientNum );

		level waittill( "cam_customization_closed" );
	}
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

	level thread custom_class_start_threads( localClientNum );
	level thread handle_cac_customization( localClientNum );
}

function localClientConnect(localClientNum)
{
	level thread custom_class_init( localClientNum );
}

