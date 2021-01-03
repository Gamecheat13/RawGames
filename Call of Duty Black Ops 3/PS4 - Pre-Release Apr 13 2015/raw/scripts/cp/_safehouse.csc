#using scripts\shared\system_shared;

            	     	     
                                                                                     	                                    
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\shared\_character_customization;
#using scripts\core\_multi_extracam;
#using scripts\shared\scene_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\callbacks_shared;

#namespace safehouse;

function autoexec __init__sytem__() {     system::register("safehouse",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "world", "nextMap", 1, 6, "int", &next_map_changed, !true, true );
	clientfield::register( "world", "selectMenu", 1, GetMinBitCountForNum(15), "int", &menuSelected, !true, !true );
	clientfield::register( "world", "gun_rack_fxanim", 1, 1, "int", &gun_rack_fxanim, !true, !true );
	clientfield::register( "world", "toggle_bunk_1", 1, 1, "int", &toggle_bunk_1, !true, !true );
	clientfield::register( "world", "toggle_bunk_2", 1, 1, "int", &toggle_bunk_2, !true, !true );
	clientfield::register( "world", "toggle_bunk_3", 1, 1, "int", &toggle_bunk_3, !true, !true );
	clientfield::register( "world", "toggle_bunk_4", 1, 1, "int", &toggle_bunk_4, !true, !true );
	clientfield::register( "world", "toggle_console_1", 1, 1, "int", &toggle_console_1, !true, !true );
	clientfield::register( "world", "toggle_console_2", 1, 1, "int", &toggle_console_2, !true, !true );
	clientfield::register( "world", "toggle_console_3", 1, 1, "int", &toggle_console_3, !true, !true );
	clientfield::register( "world", "toggle_console_4", 1, 1, "int", &toggle_console_4, !true, !true );
	
	callback::on_localclient_connect( &on_player_connect );
	
	level thread character_customization::handle_forced_streaming( "cp" );
}

function next_map_changed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	nextMapModel = CreateUIModel( GetGlobalUIModel(), "nextMap" );
	SetUIModelValue( nextMapModel, GetMapAtIndex(newVal) );
}

//spawns in all the weapon models for the gun rack
function gun_rack_init( localClientNum )
{
	//if this is not here the guns don't match up, the joys of clientscripting
	wait 0.05;
	
	//this is the gunrack fx model
	m_gun_rack = GetEnt( localClientNum, "gunrack", "targetname" );
	
	//link all rifles to the rifle rack joint, intermediate script_origin needed to preserve offsets
	a_m_weapons = GetEntArray( localClientNum, "gun_rack_rifle", "targetname" );
	e_rack = Spawn( localClientNum, ( 0, 0, 0 ), "script_origin" );
	e_rack LinkTo( m_gun_rack, "gunrack_rifles_jnt" );
	foreach( m_weapon in a_m_weapons )
	{
		m_weapon LinkTo( e_rack );
	}
	
	//link all pistols and grenades to the drawer joint
	a_m_weapons = GetEntArray( localClientNum, "gun_rack_pistol", "targetname" );
	e_rack = Spawn( localClientNum, ( 0, 0, 0 ), "script_origin" );
	e_rack LinkTo( m_gun_rack, "gunrack_pistols_jnt" );
	foreach( m_weapon in a_m_weapons )
	{
		m_weapon LinkTo( e_rack );
	}
}

function gun_rack_fxanim( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
 {
	m_gun_rack = GetEnt( localClientNum, "gunrack", "targetname" );
	
	if( newVal == 1 )
	{
		m_gun_rack thread scene::play( "p7_fxanim_cp_safehouse_cairo_gunrack_open_bundle" );
	}
	else
	{
		m_gun_rack thread scene::play( "p7_fxanim_cp_safehouse_cairo_gunrack_close_bundle" );
	}
 }
 
function toggle_bunk_1( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	m_bunk_door = GetEnt( localClientNum, "bunk_1_door", "targetname" );

	if( newVal == 1 )
	{
		m_bunk_door thread scene::play( "p7_fxanim_cp_safehouse_door_bunk_1_open_bundle" );
	}
	else
	{
		m_bunk_door thread scene::play( "p7_fxanim_cp_safehouse_door_bunk_1_close_bundle" );
	}
}

function toggle_bunk_2( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	m_bunk_door = GetEnt( localClientNum, "bunk_2_door", "targetname" );

	if( newVal == 1 )
	{
		m_bunk_door thread scene::play( "p7_fxanim_cp_safehouse_door_bunk_2_open_bundle" );
	}
	else
	{
		m_bunk_door thread scene::play( "p7_fxanim_cp_safehouse_door_bunk_2_close_bundle" );
	}
}

function toggle_bunk_3( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	m_bunk_door = GetEnt( localClientNum, "bunk_3_door", "targetname" );

	if( newVal == 1 )
	{
		m_bunk_door thread scene::play( "p7_fxanim_cp_safehouse_door_bunk_3_open_bundle" );
	}
	else
	{
		m_bunk_door thread scene::play( "p7_fxanim_cp_safehouse_door_bunk_3_close_bundle" );
	}
}

function toggle_bunk_4( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	m_bunk_door = GetEnt( localClientNum, "bunk_4_door", "targetname" );

	if( newVal == 1 )
	{
		m_bunk_door thread scene::play( "p7_fxanim_cp_safehouse_door_bunk_4_open_bundle" );
	}
	else
	{
		m_bunk_door thread scene::play( "p7_fxanim_cp_safehouse_door_bunk_4_close_bundle" );
	}
}

function toggle_console_1( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	m_console_arm = GetEnt( localClientNum, "arm_1", "targetname" );

	if( newVal == 1 )
	{
		m_console_arm thread scene::play( "p7_fxanim_cp_safehouse_arm_console_1_down_bundle" );
	}
	else
	{
		m_console_arm thread scene::play( "p7_fxanim_cp_safehouse_arm_console_1_up_bundle" );
	}
}

function toggle_console_2( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	m_console_arm = GetEnt( localClientNum, "arm_2", "targetname" );

	if( newVal == 1 )
	{
		m_console_arm thread scene::play( "p7_fxanim_cp_safehouse_arm_console_2_down_bundle" );
	}
	else
	{
		m_console_arm thread scene::play( "p7_fxanim_cp_safehouse_arm_console_2_up_bundle" );
	}
}

function toggle_console_3( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	m_console_arm = GetEnt( localClientNum, "arm_3", "targetname" );

	if( newVal == 1 )
	{
		m_console_arm thread scene::play( "p7_fxanim_cp_safehouse_arm_console_3_down_bundle" );
	}
	else
	{
		m_console_arm thread scene::play( "p7_fxanim_cp_safehouse_arm_console_3_up_bundle" );
	}
}

function toggle_console_4( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	m_console_arm = GetEnt( localClientNum, "arm_4", "targetname" );

	if( newVal == 1 )
	{
		m_console_arm thread scene::play( "p7_fxanim_cp_safehouse_arm_console_4_down_bundle" );
	}
	else
	{
		m_console_arm thread scene::play( "p7_fxanim_cp_safehouse_arm_console_4_up_bundle" );
	}
}


function on_player_connect( localClientNum )
{
	/# println( "*** Client script VM : Local client connect " + localClientNum ); #/
	player = GetLocalPlayer( localClientNum );
	assert( isdefined( player ) );
	
	level thread gun_rack_init( localClientNum );
}

function menuSelected(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{	
	if ( isdefined( oldVal ) && isdefined( newVal ) && ( ( oldVal == 9 || oldVal == 10 ) && newVal != oldVal ) )
	{
		level notify( "done_personalizing_hero" );
	}
	
	if ( newVal == 13 )
	{
		if ( !isdefined( level.lastCameraSetup ) || level.lastCameraSetup != "hero" )
		{
			level.lastCameraSetup = "hero";
			multi_extracam::extracam_init_index( localClientNum, "character_staging_extracam2", 1);
			
			camera_ent = level.camera_ents[1];
			assert( isdefined( camera_ent ) );
			camera_ent PlayExtraCamXCam( "ui_cam_character_customization", 0, "cam_preview" );
		}
	}
	else if ( newVal == 9 || newVal == 10 )
	{
		if ( !isdefined( level.lastCameraSetup ) || level.lastCameraSetup != "hero" )
		{
			level.lastCameraSetup = "hero";
			multi_extracam::extracam_init_index( localClientNum, "character_staging_extracam2", 1);
			
			camera_ent = level.camera_ents[1];
			assert( isdefined( camera_ent ) );
			camera_ent PlayExtraCamXCam( "ui_cam_character_customization", 0, "cam_menu" );
		}
		
		if ( oldVal != 9 || oldVal != 10  )
		{
			level notify ( "begin_personalizing_hero" );
		}
	}
	else if ( newVal == 12 )
	{
		if ( !isdefined( level.lastCameraSetup ) || level.lastCameraSetup != "hero" )
		{
			level.lastCameraSetup = "hero";
			multi_extracam::extracam_init_index( localClientNum, "character_staging_extracam2", 1);
			
			camera_ent = level.camera_ents[1];
			assert( isdefined( camera_ent ) );
			camera_ent PlayExtraCamXCam( "ui_cam_character_customization", 0, "cam_preview" );
		}
	}
	else if ( newVal == 1 )
	{
		level.lastCameraSetup = "none";
		multi_extracam::extracam_reset_index( 1 );
	}
}

function transition_extracam_immediate( xcam, lerpDuration, subxcam )
{
	self notify("xcamMoved");
	self PlayExtraCamXCam( xcam, lerpDuration, subxcam );
}

function transition_extracam( xcam, initialDelay, lerpDuration, subxcam )
{
	self endon("entityshutdown");
	self notify("xcamMoved");
	self endon("xcamMoved");
	wait initialDelay;
	self PlayExtraCamXCam( xcam, lerpDuration, subxcam );
}

function handle_weapon_changes(type)
{
	level endon("disconnect");
	while( true )
	{
		level waittill( "CustomClass_"+type, slotName, weaponOrAttachment );
		
		camera_ent = level.camera_ents[0];
		if( type == "secondary" )
		{
			camera_ent = level.camera_ents[1];
		}
		
		if( slotName == "custom" || slotName == "custom_removeattach" )
		{
			lerpDuration = 1;
			weaponAndAttachments = strtok(weaponOrAttachment, "+");
			weaponName = GetSubStr(weaponAndAttachments[0],0,weaponAndAttachments[0].size-3);
			subcamera = "cam_custom";

			if( weaponName == "ar_standard" )
			{
				suppressed = 0;
				extbarrel = 0;
				for( i=1; i<weaponAndAttachments.size; i++ )
				{
					if( weaponAndAttachments[i] == "suppressed")
					{
						suppressed = 1;
					}
					else if( weaponAndAttachments[i] == "extbarrel" )
					{
						extbarrel = 1;
					}
				}
				if( suppressed + extbarrel > 0 )
				{
					subcamera = "cam_zoom" + (suppressed + extbarrel);
				}
			}

			if( slotName == "custom_removeattach" )
			{
				lerpDuration = 300;
			}
			if( type == "primary" )
			{
				level.primaryWeapon = weaponName;
			}
			xcamName = "ui_cam_cac_select_" + weaponName;
			camera_ent transition_extracam_immediate( xcamName, lerpDuration, subcamera );
		}
		else if( slotName == "select" )
		{
			xcamName = "ui_cam_cac_select_" + weaponOrAttachment;
			camera_ent transition_extracam_immediate( xcamName, 500, "cam_select" );
		}
		else if ( slotName == "attachment" )
		{
			if( type == "primary" && isDefined( level.primaryWeapon) && level.primaryWeapon == "ar_standard" )
			{
				for( i=2; i<level.camera_ents.size; i++ )
				{
					if( isDefined(level.camera_ents[i]) )
					{
						level.camera_ents[i] delete();
					}
				}
				if( weaponOrAttachment == "reflex" ) // or other optic
				{
					weaponOrAttachment = "optics";
				}

				camera_ent thread transition_extracam( "ui_cam_cac_attachments_ar_arak", .30, 400, "cam_" + weaponOrAttachment );
			}
		}
	}
}