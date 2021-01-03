#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                    	   	  	

#namespace speedburst;

function autoexec __init__sytem__() {     system::register("gadget_flashback",&__init__,undefined,undefined);    }
	
//#define FLASHBACK_PREAPPEAR_FX		"player/fx_plyr_flashback_flash_blue"
//#define FLASHBACK_DIRECTIONAL_FX	"player/fx_plyr_flashback_direc_indicator_blue"


	
//#precache( "fx", FLASHBACK_PREAPPEAR_FX );
//#precache( "fx", FLASHBACK_DIRECTIONAL_FX );
#precache( "fx", "player/fx_plyr_flashback_trail" );
#precache( "fx", "player/fx_plyr_flashback_trail_impact" );



function __init__()
{
	ability_player::register_gadget_activation_callbacks( 16, &gadget_flashback_on, &gadget_flashback_off );
	ability_player::register_gadget_possession_callbacks( 16, &gadget_flashback_on_give, &gadget_flashback_on_take );
	ability_player::register_gadget_flicker_callbacks( 16, &gadget_flashback_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 16, &gadget_flashback_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 16, &gadget_flashback_is_flickering );
	ability_player::register_gadget_primed_callbacks( 16, &gadget_flashback_is_primed );
	
	callback::on_connect( &gadget_flashback_on_connect );
	if ( !IsDefined( level.vsmgr_prio_overlay_flashback_warp ) )
	{
		level.vsmgr_prio_overlay_flashback_warp = 27;
	}		
	
	visionset_mgr::register_info( "overlay", "flashback_warp", 1, level.vsmgr_prio_overlay_flashback_warp, 7, true, &visionset_mgr::duration_lerp_thread_per_player, false );
}

function gadget_flashback_is_inuse( slot )
{
	// returns true when local script gadget state is on
	return self flagsys::get( "gadget_flashback_on" );
}

function gadget_flashback_is_flickering( slot )
{
	// returns true when local script gadget state is flickering
	return self GadgetFlickering( slot );
}

function gadget_flashback_on_flicker( slot, weapon )
{

}

function gadget_flashback_on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory
}

function gadget_flashback_on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
}

//self is the player
function gadget_flashback_on_connect()
{
	// setup up stuff on player connect
}

function gadget_flashback_on( slot, weapon )
{
	// excecutes when the gadget is turned on
	self flagsys::set( "gadget_flashback_on" );	
	
	self GadgetSetActivateTime( slot, GetTime() );

	visionset_mgr::activate( "overlay", "flashback_warp", self, 0.8, 0.8 );

	self.flashbackTime = GetTime();

	oldpos = self.origin;
	
	newpos = self flashbackstart( weapon );
	
	self NotSolid();
	
	if ( isdefined ( newpos ) && isdefined ( oldpos ) )
	{
		dirVec = newpos - oldpos;
		
		if ( dirVec == (0,0,0) )
		{
			dirVec = (0,0,1);
		}
		
		//fx = PlayFx( FLASHBACK_DIRECTIONAL_FX, oldpos, dirVec );
		//fx = PlayFx( FLASHBACK_DIRECTIONAL_FX, newpos, -dirVec );

		oldpos += (0,0,45);	
		newpos += (0,0,45);
	
		self thread flashback_trail_fx( slot, weapon, oldpos, newpos );
		
		trace = BulletTrace( oldpos, newpos, true, self );	
		if ( trace[ "fraction" ] < 1.0 )
		{
			PlayFx( "player/fx_plyr_flashback_trail_impact", trace[ "position" ], trace[ "normal" ] );
			trace = BulletTrace( newpos, oldpos, true, self );	
			if ( trace[ "fraction" ] < 1.0 )
			{
				PlayFx( "player/fx_plyr_flashback_trail_impact", trace[ "position" ], trace[ "normal" ] );
			}
		}
		
		if ( isdefined( level.playHeroabilitySuccess ) )
	    {
			self [[ level.playHeroabilitySuccess ]]( 3 );
		}
	}
	
	self thread deactivateFlashbackWarpAfterTime( 0.8 );

}

function deactivateFlashbackWarpAfterTime( time )
{
	self endon( "disconnect" );
	
	self util::waittill_any_timeout( time, "death" );  

	visionset_mgr::deactivate( "overlay", "flashback_warp", self );
}

function flashback_trail_fx( slot, weapon, oldpos, newpos )
{
	fxOrg = spawn( "script_model", oldpos );
	fxOrg SetModel( "tag_origin" );

	fxOrg SetInvisibleToPlayer( self );
	util::wait_network_frame();
	
	fx = PlayFxOnTag( "player/fx_plyr_flashback_trail", fxOrg, "tag_origin" );
	fxOrg MoveTo( newpos, 0.1 ); 
	fxOrg waittill( "movedone" );
	wait( 1 );
	fxOrg delete();

	//fx = PlayFx( FLASHBACK_PREAPPEAR_FX, newpos );
}

function gadget_flashback_is_primed( slot, weapon )
{
}

function gadget_flashback_off( slot, weapon )
{
	// excecutes when the gadget is turned off
	self flagsys::clear( "gadget_flashback_on" );
	
	self Solid();
	self flashbackfinish();
	
	if( level.gameEnded )
	{
		self FreezeControls( true );
	}

}
