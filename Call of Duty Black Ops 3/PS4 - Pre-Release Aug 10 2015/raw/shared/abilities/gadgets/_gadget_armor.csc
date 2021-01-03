#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	






	
function autoexec __init__sytem__() {     system::register("gadget_armor",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_spawned( &on_player_spawned );
	clientfield::register( "allplayers", "armor_status", 1, 5, "int", &player_armor_changed, !true, true );
	
	duplicate_render::set_dr_filter_framebuffer_duplicate( "armor_pl", 40, "armor_on", undefined, 1, "mc/mtl_power_armor", 0 );
/#
	level thread armor_overlay_think();
#/
}

function on_player_spawned( localClientNum )
{	
	if ( self armor_is_local_player( localClientNum ) )
	{
		self on_local_player_spawned( localClientNum );
	}
}

function on_local_player_spawned( localClientNum )
{	
	newVal = self clientfield::get( "armor_status" );
	
	self player_armor_changed_event( localClientNum, newVal );
}

function player_armor_changed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{		
	self player_armor_changed_event( localClientNum, newVal);
}

function player_armor_changed_event( localClientNum, newVal )
{		
	self armor_update_overlay_event( localClientNum, newVal);
	
	self armor_update_shader_event( localClientNum, newVal );	
}

function armor_update_shader_event( localClientNum, armorStatusNew )
{
	if ( armorStatusNew )
	{
		self duplicate_render::update_dr_flag( "armor_on", true );
		
		shieldExpansionNcolor = "scriptVector0";
		shieldExpansionValueX = .3;
		
		colorVector = armor_get_shader_color( armorStatusNew ); //( 0.2, 0.8, 1 );
			
		if ( GetDvarInt( "scr_armor_dev" ) )
		{
			shieldExpansionValueX = GetDvarFloat( "scr_armor_expand", shieldExpansionValueX );
			colorVector = ( GetDvarFloat( "scr_armor_colorR", colorVector[0] ), GetDvarFloat( "scr_armor_colorG", colorVector[1] ), GetDvarFloat( "scr_armor_colorB", colorVector[2] ) );
		}		
		
		colorTintValueY = colorVector[0];
		colorTintValueZ = colorVector[1];
		colorTintValueW = colorVector[2];
		
		damageState = "scriptVector1";
		damageStateValue = armorStatusNew / 5;
		
		self MapShaderConstant( localClientNum, 0, shieldExpansionNcolor, shieldExpansionValueX, colorTintValueY, colorTintValueZ, colorTintValueW );
		self MapShaderConstant( localClientNum, 0, damageState, damageStateValue );
	}
	else
	{
		self duplicate_render::update_dr_flag( "armor_on", false );
	}
}

function armor_get_shader_color( armorStatusNew )
{
//	if ( armorStatusNew == ARMOR_STATUS_FULL )
//	{
//		color = ( 0.03, 0.11, 0.97 );
//	}
//	else if ( armorStatusNew == ARMOR_STATUS_GOOD )
//	{
//		color = ( 0.02, 0.65, 0.98 );
//	}
//	else if ( armorStatusNew == ARMOR_STATUS_OK )
//	{
//		color = ( 0.03, 0.82, 0.97 );
//	}
//	else if ( armorStatusNew == ARMOR_STATUS_DANGER )
//	{
//		color = ( 0.47, 0.97, 0.96 );
//	}
//	else if ( armorStatusNew == ARMOR_STATUS_CRITICAL )
//	{
//		color = ( 0.97, 0.04, 0.10 );
//	}
//	else
//	{
//		color = (0.03, 0.11, 0.97 );
//	}
	
	color = ( .3, .3, .2 );
	
	return color;
}

function armor_update_overlay_event( localClientNum, armorStatusNew )
{	
	if ( !self armor_is_local_player( localClientNum ) )
	{
		return;
	}

	//self thread armor_overlay_transition_fx( localClientNum, armorStatusNew );
	
	if ( armorStatusNew > 0 )
	{
		self SetDamageDirectionIndicator(1);
		setsoundcontext( "plr_impact", "pwr_armor" );
	}
	else
	{
		self SetDamageDirectionIndicator(0);
		setsoundcontext( "plr_impact", "" );
	}
	
//	controllerModel = GetUIModelForController( localClientNum );
//	imageModel = CreateUIModel( controllerModel, "hudItems.armorOverlay" );			
//	
//	if ( armorStatusNew == ARMOR_STATUS_FULL )
//	{
//		SetUIModelValue( imageModel, "fullscreen_armor_overlay_full" );
//	}
//	else if ( armorStatusNew == ARMOR_STATUS_GOOD )
//	{
//		SetUIModelValue( imageModel, "fullscreen_armor_overlay_good" );
//	}
//	else if ( armorStatusNew == ARMOR_STATUS_OK )
//	{
//		SetUIModelValue( imageModel, "fullscreen_armor_overlay_ok" );
//	}
//	else if ( armorStatusNew == ARMOR_STATUS_DANGER )
//	{
//		SetUIModelValue( imageModel, "fullscreen_armor_overlay_danger" );
//	}
//	else if ( armorStatusNew == ARMOR_STATUS_CRITICAL )
//	{
//		SetUIModelValue( imageModel, "fullscreen_armor_overlay_critical" );
//	}
//	else if ( armorStatusNew == ARMOR_STATUS_OFF )
//	{
//		SetUIModelValue( imageModel, "blacktransparent" );
//	}			
}

function armor_overlay_transition_fx( localClientNum, armorStatusNew )
{
	self endon( "disconnect" );
	
	if ( !isdefined( self._gadget_armor_state ) )
	{
		self._gadget_armor_state = 0;
	}
	
	if ( armorStatusNew == self._gadget_armor_state )
	{
		return;
	}
	
	self._gadget_armor_state = armorStatusNew;
	
	if ( armorStatusNew == 5 )
	{
		return;
	}	
	
	if ( ( isdefined( self._armor_doing_transition ) && self._armor_doing_transition ) )
	{
		return;
	}
	
	self._armor_doing_transition = true;
	
	transition = 0;
	flicker_start_time = GetRealTime();
	saved_vision = GetVisionSetNaked( localClientNum );

	visionsetnaked( localClientNum, "taser_mine_shock", transition );
	
	self playsound (0, "wpn_taser_mine_tacmask");

	wait( 0.3 );

	visionSetNaked( localClientNum, saved_vision, transition );
	
	self._armor_doing_transition = false;
}

function armor_is_local_player( localClientNum )
{	
	player_view = getlocalplayer( localClientNum );	

	sameEntity = ( self == player_view );

	return sameEntity;
}

/#
function armor_overlay_think()
{	
	armorStatus = 0;
	
	SetDvar( "scr_armor_status", 0 );	
	
	while( 1 )
	{
		wait( 0.1 );
		
		armorStatusNew = GetDvarInt( "scr_armor_status" );
		
		if ( armorStatusNew != armorStatus )
		{
			players = getlocalplayers();
			
			foreach ( i, localPlayer in players )
			{
				if ( !isdefined( localPlayer ) )
				{
					continue;
				}

				localPlayer player_armor_changed_event( i, armorStatusNew );
			}
			
			armorStatus = armorStatusNew;			
		}
	}	
}
#/
	
