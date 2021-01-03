//
// file: zm_factory_teleporter.csc
// description: clientside post-teleport effects
// scripter: seibert
//

#using scripts\codescripts\struct;

#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       


function autoexec __init__sytem__() {     system::register("zm_factory_teleporter",&__init__,undefined,undefined);    }

function __init__()
{
	visionset_mgr::register_overlay_info_style_transported( "zm_factory", 1, 15, 2 );

	level thread setup_teleport_aftereffects();
	level thread wait_for_black_box();
	level thread wait_for_teleport_aftereffect();
}

function setup_teleport_aftereffects()
{
	util::waitforclient( 0 );
	
	level.teleport_ae_funcs = [];
	if( getlocalplayers().size == 1 )
	{
		level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_factory_teleporter::teleport_aftereffect_fov;
	}
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_factory_teleporter::teleport_aftereffect_shellshock;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_factory_teleporter::teleport_aftereffect_shellshock_electric;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_factory_teleporter::teleport_aftereffect_bw_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_factory_teleporter::teleport_aftereffect_red_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_factory_teleporter::teleport_aftereffect_flashy_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_factory_teleporter::teleport_aftereffect_flare_vision;
}

function wait_for_black_box()
{
	secondClientNum = -1;
	while( true ) 
	{
		level waittill( "black_box_start", localClientNum );
		assert( isDefined( localClientNum ) );
		savedVis = GetVisionSetNaked( localClientNum );
		VisionSetNaked( localClientNum, "default", 0 );
		while( secondClientNum != localClientNum )
		{
			level waittill( "black_box_end", secondClientNum );
		}
		VisionSetNaked( localClientNum, savedVis, 0 );
	}
}

function wait_for_teleport_aftereffect()
{
	while( true )
	{
		level waittill( "tae", localClientNum );
		if( GetDvarString( "factoryAftereffectOverride" ) == "-1" )
		{
			self thread [[ level.teleport_ae_funcs[RandomInt(level.teleport_ae_funcs.size)] ]]( localClientNum );
		}
		else
		{
			self thread [[ level.teleport_ae_funcs[int(GetDvarString( "factoryAftereffectOverride" ))] ]]( localClientNum );
		}
	}
}

function teleport_aftereffect_shellshock( localClientNum )
{
	wait( 0.05 );
}

function teleport_aftereffect_shellshock_electric( localClientNum )
{
	wait( 0.05 );
}

function teleport_aftereffect_fov( localClientNum )
{
	/#println( "***FOV Aftereffect***\n" );#/

	start_fov = 30;
	end_fov = GetDvarfloat( "cg_fov_default" );
	duration = 0.5;
	
	for( i = 0; i < duration; i += 0.017 )
	{
		fov = start_fov + (end_fov - start_fov)*(i/duration);
		//SetClientDvar( "cg_fov", fov );
		waitrealtime( 0.017 );
	}
}

function teleport_aftereffect_bw_vision( localClientNum )
{
	/#println( "***B&W Aftereffect***\n" );#/
	savedVis = GetVisionSetNaked( localClientNum );
	VisionSetNaked( localClientNum, "cheat_bw_invert_contrast", 0.4 );
	wait( 1.25 );
	VisionSetNaked( localClientNum, savedVis, 1 );
}

function teleport_aftereffect_red_vision( localClientNum )
{
	/#println( "***Red Aftereffect***\n" );#/
	savedVis = GetVisionSetNaked( localClientNum );
	VisionSetNaked( localClientNum, "zombie_turned", 0.4 );
	wait( 1.25 );
	VisionSetNaked( localClientNum, savedVis, 1 );
}

function teleport_aftereffect_flashy_vision( localClientNum )
{
	/#println( "***Flashy Aftereffect***\n" );#/
	savedVis = GetVisionSetNaked( localClientNum );
	VisionSetNaked( localClientNum, "cheat_bw_invert_contrast", 0.1 );
	wait( 0.4 );
	VisionSetNaked( localClientNum, "cheat_bw_contrast", 0.1 );
	wait( 0.4 );
//	VisionSetNaked( localClientNum, "cheat_invert_contrast", 0.1 );
	wait( 0.4 );
//	VisionSetNaked( localClientNum, "cheat_contrast", 0.1 );
	wait( 0.4 );
	VisionSetNaked( localClientNum, savedVis, 5 );
}

function teleport_aftereffect_flare_vision( localClientNum )
{
	/#println( "***Flare Aftereffect***\n" );#/
	savedVis = GetVisionSetNaked( localClientNum );
	VisionSetNaked( localClientNum, "flare", 0.4 );
	wait( 1.25 );
	VisionSetNaked( localClientNum, savedVis, 1 );
}