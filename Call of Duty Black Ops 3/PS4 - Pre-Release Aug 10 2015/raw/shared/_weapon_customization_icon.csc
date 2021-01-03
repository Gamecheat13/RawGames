#using scripts\core\_multi_extracam;
#using scripts\shared\util_shared;
#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace weapon_customization_icon;

function autoexec __init__sytem__() {     system::register("weapon_customization_icon",&__init__,undefined,undefined);    }		
	
///////////////////////////////////////////////////////////////////////////
// SETUP
///////////////////////////////////////////////////////////////////////////
function __init__()
{
	level.extra_cam_render_wc_paintjobicon_func_callback = &process_wc_paintjobicon_extracam_request;
	level.extra_cam_render_wc_varianticon_func_callback = &process_wc_varianticon_extracam_request;
	level.weaponCustomizationIconSetup = &wc_icon_setup;
}

function wc_icon_setup( localClientNum )
{
	level.extra_cam_wc_paintjob_icon = SpawnStruct();
	level.extra_cam_wc_variant_icon = SpawnStruct();
	level thread update_wc_icon_extracam( localClientNum );
}

function update_wc_icon_extracam( localClientNum )
{
	level endon( "disconnect" );
	
	while ( true )
	{
		level waittill( "process_wc_icon_extracam", extracam_data_struct );
		setup_wc_weapon_model( localClientNum, extracam_data_struct );
		setup_wc_extracam_settings( localClientNum, extracam_data_struct );
	}
}

function wait_for_extracam_close( camera_ent, extracam_data_struct )
{
	level waittill( "render_complete_" + extracam_data_struct.extraCamIndex );
	multi_extracam::extracam_reset_index( extracam_data_struct.extraCamIndex );
	if( IsDefined( extracam_data_struct.weapon_script_model ) )
	{
		extracam_data_struct.weapon_script_model delete();
	}
}

function GetXcam( weapon_name, camera )
{
	xcam = GetWeaponXCam( weapon_name, camera );

	if( !IsDefined( xcam ) )
	{
		xcam = GetWeaponXCam( GetWeapon( "ar_damage" ), camera );
	}
	
	return xcam;
}

function setup_wc_extracam_settings( localClientNum, extracam_data_struct )
{
	assert( isdefined( extracam_data_struct.jobIndex ) );

	initializedExtracam = false;	
	camera_ent = (isDefined(level.camera_ents) ? level.camera_ents[extracam_data_struct.extraCamIndex] : undefined);
	if( !isdefined( camera_ent ) )
	{
		initializedExtracam = true;
		camera_ent = multi_extracam::extracam_init_index( localClientNum, "weapon_icon_staging_camera", extracam_data_struct.extraCamIndex);
	}

	assert( isdefined( camera_ent ) );
		
	extracam_data_struct.xcam = GetXcam( extracam_data_struct.current_weapon, "cam_gunsmith_weapon" );
	extracam_data_struct.subXCam = "cam_icon";

	position = extracam_data_struct.weapon_position;
	camera_ent PlayExtraCamXCam( extracam_data_struct.xcam, 0, extracam_data_struct.subXCam, extracam_data_struct.notetrack, position.origin, position.angles, extracam_data_struct.weapon_script_model, position.origin, position.angles );
	
	level util::waittill_notify_or_timeout( "paintshop_ready_" + extracam_data_struct.jobIndex, 5 );
		
	setExtraCamRenderReady( extracam_data_struct.jobIndex );
	
	extracam_data_struct.jobIndex = undefined;
	
	if( initializedExtracam )
	{
		level thread wait_for_extracam_close( camera_ent, extracam_data_struct );
	}
}

function set_wc_icon_weapon_options( weapon_options_param, extracam_data_struct )
{
	weapon_options = strtok( weapon_options_param, "," );

	if( IsDefined( weapon_options ) && IsDefined( extracam_data_struct.weapon_script_model ) )
	{

		extracam_data_struct.weapon_script_model SetWeaponRenderOptions( int( weapon_options[0] ), int( weapon_options[1] ), false, false, int( weapon_options[2] ), extracam_data_struct.paintjobSlot, extracam_data_struct.paintjobIndex, true );
	}
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

function set_wc_icon_cosmetic_variants( acv_param, weapon_full_name, extracam_data_struct )
{
	acv_indexes = strtok( acv_param, "," );
	
	for( i = 0; i + 1 < acv_indexes.size; i += 2 )
	{
		extracam_data_struct.weapon_script_model SetAttachmentCosmeticVariantIndex( weapon_full_name, acv_indexes[i], int( acv_indexes[i+1] ) );
	}
}


function setup_wc_weapon_model( localClientNum, extracam_data_struct )
{
	base_weapon_slot = extracam_data_struct.loadoutSlot;
	weapon_full_name = extracam_data_struct.weaponPlusAttachments;
	weapon_options_param = extracam_data_struct.weaponOptions;
	acv_param = extracam_data_struct.attachmentVariantString;

	if( IsDefined( weapon_full_name ) )
	{
		position = struct::get( "weapon_icon_staging" );

		if( !IsDefined( extracam_data_struct.weapon_script_model ) )
		{
			extracam_data_struct.weapon_script_model = spawn_weapon_model( localClientNum, position.origin, position.angles );
		}
		
		extracam_data_struct.current_weapon = GetWeaponWithAttachments( weapon_full_name );
		extracam_data_struct.weapon_script_model UseWeaponModel( extracam_data_struct.current_weapon );
		extracam_data_struct.weapon_position = position;

		if( IsDefined( acv_param ) && acv_param != "none" )
		{
			set_wc_icon_cosmetic_variants( acv_param, weapon_full_name, extracam_data_struct );
		}

		if( IsDefined( weapon_options_param ) && weapon_options_param != "none" )
		{
			set_wc_icon_weapon_options( weapon_options_param, extracam_data_struct );
		}
	}
}

function process_wc_paintjobicon_extracam_request( localClientNum, extraCamIndex, jobIndex, attachmentVariantString, weaponOptions, weaponPlusAttachments, loadoutSlot, paintjobIndex, paintjobSlot )
{
	level.extra_cam_wc_paintjob_icon.jobIndex = jobIndex;
	level.extra_cam_wc_paintjob_icon.extraCamIndex = extraCamIndex;
	level.extra_cam_wc_paintjob_icon.attachmentVariantString = attachmentVariantString;
	level.extra_cam_wc_paintjob_icon.weaponOptions = weaponOptions;
	level.extra_cam_wc_paintjob_icon.weaponPlusAttachments = weaponPlusAttachments;
	level.extra_cam_wc_paintjob_icon.loadoutSlot = loadoutSlot;
	level.extra_cam_wc_paintjob_icon.paintjobIndex = paintjobIndex;
	level.extra_cam_wc_paintjob_icon.paintjobSlot = paintjobSlot;
	level.extra_cam_wc_paintjob_icon.notetrack = "paintjobpreview";

	level notify( "process_wc_icon_extracam", level.extra_cam_wc_paintjob_icon );
}

function process_wc_varianticon_extracam_request( localClientNum, extraCamIndex, jobIndex, attachmentVariantString, weaponOptions, weaponPlusAttachments, loadoutSlot, paintjobIndex, paintjobSlot )
{
	level.extra_cam_wc_variant_icon.jobIndex = jobIndex;
	level.extra_cam_wc_variant_icon.extraCamIndex = extraCamIndex;
	level.extra_cam_wc_variant_icon.attachmentVariantString = attachmentVariantString;
	level.extra_cam_wc_variant_icon.weaponOptions = weaponOptions;
	level.extra_cam_wc_variant_icon.weaponPlusAttachments = weaponPlusAttachments;
	level.extra_cam_wc_variant_icon.loadoutSlot = loadoutSlot;
	level.extra_cam_wc_variant_icon.paintjobIndex = paintjobIndex;
	level.extra_cam_wc_variant_icon.paintjobSlot = paintjobSlot;
	level.extra_cam_wc_variant_icon.notetrack = "variantpreview"; 

	level notify( "process_wc_icon_extracam", level.extra_cam_wc_variant_icon );
}
