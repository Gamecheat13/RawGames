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

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	


#namespace flashback;


	
#precache( "fx", "player/fx_plyr_flashback_trail_impact" );

function autoexec __init__sytem__() {     system::register("gadget_flashback",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "scriptmover", "flashback_trail_fx", 1, 1, "int" );
	clientfield::register( "playercorpse", "flashback_clone" , 1, 1, "int" );
	
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

function clone_watch_death()
{
	self endon ( "death" );
	
	wait( 1.0 );
	
	// do not delete the clones
	// player corpses should never get deleted
	self ghost();
}


/#

function debug_star( origin, seconds, color )
{
	if ( !isdefined( seconds ) )
	{
		seconds = 1;
	}
	
	if ( !isdefined( color ) )
	{
		color = ( 1, 0, 0 );
	}

	frames = Int( 20 * seconds );
	DebugStar( origin, frames, color );
}
#/
	


function gadget_flashback_on( slot, weapon )
{
	// excecutes when the gadget is turned on
	self flagsys::set( "gadget_flashback_on" );	
	
	self GadgetSetActivateTime( slot, GetTime() );

	visionset_mgr::activate( "overlay", "flashback_warp", self, 0.8, 0.8 );

	self.flashbackTime = GetTime();

	self notify("flashback");
	
	clone = self CreateFlashbackClone();
	clone clientfield::set( "flashback_clone", 1 );
	clone thread clone_watch_death();
	
	oldpos = self GetTagOrigin( "j_spineupper" );
	offset = oldpos - self.origin;
	newpos = self flashbackstart( weapon ) + offset;
	self NotSolid();
	
	if ( isdefined ( newpos ) && isdefined ( oldpos ) )
	{
		self thread flashbackTrailFx( slot, weapon, oldpos, newpos );
		flashbackTrailImpact( newpos, oldpos, 8 );
		flashbackTrailImpact( oldpos, newpos, 8 );
		
		if ( isdefined( level.playHeroabilitySuccess ) )
	    {
			self [[ level.playHeroabilitySuccess ]]( "flashbackSuccessDelay" );
		}
	}
	
	self thread deactivateFlashbackWarpAfterTime( 0.8 );
}


function flashBackTrailImpact( startPos, endPos, recursionDepth ) 
{
	recursionDepth--;
	if ( recursionDepth <= 0 )
	{
		return;
	}
	trace = BulletTrace( startPos, endPos, false, self );
	if ( trace[ "fraction" ] < 1.0 && trace[ "normal" ] != ( 0,0,0 ) )
	{
		
		PlayFx( "player/fx_plyr_flashback_trail_impact", trace[ "position" ], trace[ "normal" ] );
		newStartPos = trace[ "position" ] - trace[ "normal" ];
/#
//		debug_star( trace[ "position" ], 100 );
#/
		flashBackTrailImpact( newStartPos, endPos, recursionDepth );
	}
}

function deactivateFlashbackWarpAfterTime( time )
{
	self endon( "disconnect" );
	
	self util::waittill_any_timeout( time, "death" );  

	visionset_mgr::deactivate( "overlay", "flashback_warp", self );
}

function flashbackTrailFx( slot, weapon, oldpos, newPos )
{
	dirVec = newPos - oldPos;
	if ( dirVec == (0,0,0) )
	{
		dirVec = (0,0,1);
	}
	dirVec = VectorNormalize( dirVec );
	angles = VectorToAngles( dirVec );
	fxOrg = spawn( "script_model", oldpos, 0, angles );
	fxOrg.angles = angles;
	fxOrg setowner( self );
	fxOrg SetModel( "tag_origin" );
	
	fxOrg clientfield::set( "flashback_trail_fx", 1 );
	util::wait_network_frame();
	tagPos = self GetTagOrigin( "j_spineupper" );
	fxOrg MoveTo( tagPos, 0.1 ); 
	fxOrg waittill( "movedone" );
	wait( 1 );
	fxOrg clientfield::set( "flashback_trail_fx", 0 );
	util::wait_network_frame();
	fxOrg delete();
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
