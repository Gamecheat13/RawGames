    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                 
                                                                                                                                                                                                                         

#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_load;

#using scripts\zm\_zm_bgb;

#precache( "client_fx", "zombie/fx_bgb_machine_eye_away_zmb" );

#precache( "client_fx", "zombie/fx_bgb_machine_eye_activated_zmb" );
#precache( "client_fx", "zombie/fx_bgb_machine_eye_event_zmb" );
#precache( "client_fx", "zombie/fx_bgb_machine_eye_rounds_zmb" );
#precache( "client_fx", "zombie/fx_bgb_machine_eye_time_zmb" );

#precache( "client_fx", "zombie/fx_bgb_machine_bulb_away_zmb" );
#precache( "client_fx", "zombie/fx_bgb_machine_bulb_available_zmb" );

#precache( "client_fx", "zombie/fx_bgb_machine_bulb_activated_zmb" );
#precache( "client_fx", "zombie/fx_bgb_machine_bulb_event_zmb" );
#precache( "client_fx", "zombie/fx_bgb_machine_bulb_rounds_zmb" );
#precache( "client_fx", "zombie/fx_bgb_machine_bulb_time_zmb" );

#precache( "client_fx", "zombie/fx_bgb_machine_bulb_spark_zmb" );

#precache( "client_fx", "zombie/fx_bgb_machine_flying_elec_zmb" );

#precache( "client_fx", "zombie/fx_bgb_machine_flying_embers_down_zmb" );
#precache( "client_fx", "zombie/fx_bgb_machine_flying_embers_up_zmb" );

#precache( "client_fx", "zombie/fx_bgb_machine_smoke_zmb" );

#precache( "client_fx", "zombie/fx_bgb_machine_gumball_halo_zmb" );

#precache( "client_fx", "zombie/fx_bgb_machine_light_interior_zmb" );
#precache( "client_fx", "zombie/fx_bgb_machine_light_interior_away_zmb" );

#namespace bgb_machine;

function autoexec __init__sytem__() {     system::register("bgb_machine",&__init__,undefined,undefined);    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	clientfield::register( "zbarrier", "zm_bgb_machine", 1, 1, "int", &bgb_machine_init, !true, !true );
	clientfield::register( "zbarrier", "zm_bgb_machine_selection", 1, 8, "int", &bgb_machine_selection, true, !true );
	clientfield::register( "zbarrier", "zm_bgb_machine_fx_state", 1, 3, "int", &bgb_machine_fx_state, !true, !true );
	clientfield::register( "zbarrier", "zm_bgb_machine_ghost_ball", 1, 1, "int", undefined, !true, !true );

	level._effect["zm_bgb_machine_eye_away"] = "zombie/fx_bgb_machine_eye_away_zmb";

	level._effect["zm_bgb_machine_eye_activated"] = "zombie/fx_bgb_machine_eye_activated_zmb";
	level._effect["zm_bgb_machine_eye_event"] = "zombie/fx_bgb_machine_eye_event_zmb";
	level._effect["zm_bgb_machine_eye_rounds"] = "zombie/fx_bgb_machine_eye_rounds_zmb";
	level._effect["zm_bgb_machine_eye_time"] = "zombie/fx_bgb_machine_eye_time_zmb";

	if(!isdefined(level._effect["zm_bgb_machine_bulb_away"]))level._effect["zm_bgb_machine_bulb_away"]="zombie/fx_bgb_machine_bulb_away_zmb";
	if(!isdefined(level._effect["zm_bgb_machine_bulb_available"]))level._effect["zm_bgb_machine_bulb_available"]="zombie/fx_bgb_machine_bulb_available_zmb";

	if(!isdefined(level._effect["zm_bgb_machine_bulb_activated"]))level._effect["zm_bgb_machine_bulb_activated"]="zombie/fx_bgb_machine_bulb_activated_zmb";
	if(!isdefined(level._effect["zm_bgb_machine_bulb_event"]))level._effect["zm_bgb_machine_bulb_event"]="zombie/fx_bgb_machine_bulb_event_zmb";
	if(!isdefined(level._effect["zm_bgb_machine_bulb_rounds"]))level._effect["zm_bgb_machine_bulb_rounds"]="zombie/fx_bgb_machine_bulb_rounds_zmb";
	if(!isdefined(level._effect["zm_bgb_machine_bulb_time"]))level._effect["zm_bgb_machine_bulb_time"]="zombie/fx_bgb_machine_bulb_time_zmb";

	level._effect["zm_bgb_machine_bulb_spark"] = "zombie/fx_bgb_machine_bulb_spark_zmb";

	level._effect["zm_bgb_machine_flying_elec"] = "zombie/fx_bgb_machine_flying_elec_zmb";

	level._effect["zm_bgb_machine_flying_embers_down"] = "zombie/fx_bgb_machine_flying_embers_down_zmb";
	level._effect["zm_bgb_machine_flying_embers_up"] = "zombie/fx_bgb_machine_flying_embers_up_zmb";

	level._effect["zm_bgb_machine_smoke"] = "zombie/fx_bgb_machine_smoke_zmb";

	level._effect["zm_bgb_machine_gumball_halo"] = "zombie/fx_bgb_machine_gumball_halo_zmb";

	if(!isdefined(level._effect["zm_bgb_machine_light_interior"]))level._effect["zm_bgb_machine_light_interior"]="zombie/fx_bgb_machine_light_interior_zmb";
	if(!isdefined(level._effect["zm_bgb_machine_light_interior_away"]))level._effect["zm_bgb_machine_light_interior_away"]="zombie/fx_bgb_machine_light_interior_away_zmb";
}

function private bgb_machine_init( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( IsDefined( self.bgb_machine_fx ) )
	{
		return;
	}

	if ( !IsDefined( level.bgb_machine_streamer_forced ) )
	{
		pieceCount = self GetNumZBarrierPieces();
		for ( i = 0; i < pieceCount; i++ )
		{
			piece = self ZBarrierGetPiece( i );
			ForceStreamXModel( piece.model );
		}


		// temporary until ForceStreamWeaponRenderOptions works
//		ForceStreamMaterial( "mtl_zmb_t7_camo_bgb_burned_out" );
//		ForceStreamMaterial( "mtl_zmb_t7_camo_bgb_burned_out_i" );
//		ForceStreamMaterial( "mtl_zmb_t7_camo_bgb_im_feelin_lucky" );
//		ForceStreamMaterial( "mtl_zmb_t7_camo_bgb_im_feelin_lucky_i" );
//		ForceStreamMaterial( "mtl_zmb_t7_camo_bgb_in_plain_sight" );
//		ForceStreamMaterial( "mtl_zmb_t7_camo_bgb_in_plain_sight_i" );
//		ForceStreamMaterial( "mtl_zmb_t7_camo_bgb_respin_cycle" );
//		ForceStreamMaterial( "mtl_zmb_t7_camo_bgb_respin_cycle_i" );
//		ForceStreamMaterial( "mtl_zmb_t7_camo_bgb_wall_power" );
//		ForceStreamMaterial( "mtl_zmb_t7_camo_bgb_wall_power_i" );



		level.bgb_machine_streamer_forced = true;
	}

	self.bgb_machine_fx = [];

	self.bgb_machine_fx["tag_fx_light_lion_lft_eye_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_lion_rt_eye_jnt"] = [];

	self.bgb_machine_fx["tag_fx_light_top_jnt"] = [];

	self.bgb_machine_fx["tag_fx_light_side_lft_top_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_lft_mid_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_lft_btm_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_rt_top_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_rt_mid_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_rt_btm_jnt"] = [];

	self.bgb_machine_fx["tag_fx_glass_cntr_jnt"] = [];

	self.bgb_machine_fx["tag_gumball_ghost"] = [];

	self.bgb_machine_fx_bulb_tags = [];
	
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_top_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_lft_top_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_lft_mid_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_lft_btm_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_rt_top_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_rt_mid_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_rt_btm_jnt";

	self thread bgb_machine_flying_ember_think( localClientNum, "closing", level._effect["zm_bgb_machine_flying_embers_down"] );
	self thread bgb_machine_flying_ember_think( localClientNum, "opening", level._effect["zm_bgb_machine_flying_embers_up"] );
	self thread bgb_machine_flying_gumballs_think( localClientNum );
	self thread bgb_machine_give_gumball_think( localClientNum );
	self thread bgb_machine_interior_light_shake_piece_think( localClientNum );
}

function private bgb_machine_selection( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !newVal )
	{
		return;
	}

	bgb = level.bgb_item_index_to_name[newVal];
//	ForceStreamWeaponRenderOptions( localClientNum, level.weaponBGBGrab, CalcWeaponOptions( localClientNum, level.bgb[bgb].camo_index ) );
}

function private bgb_machine_play_random_sparks( localClientNum, fx, piece )
{
	piece endon( "opened" );
	piece endon( "closed" );

	self.bgb_machine_fx_bulb_tags = array::randomize( self.bgb_machine_fx_bulb_tags );

	for ( i = 0; i < self.bgb_machine_fx_bulb_tags.size; i++ )
	{
		if ( RandomIntRange( 0, 4 ) )
		{
			PlayFXOnTag( localClientNum, fx, piece, self.bgb_machine_fx_bulb_tags[i] );
		}

		wait_time = RandomFloatRange( 0, 0.2 );
		if ( wait_time )
		{
			wait( wait_time );
		}
	}
}

function private bgb_machine_flying_ember_think( localClientNum, notifyName, fx )
{
	listen_piece = self ZBarrierGetPiece( 3 );
	fx_piece = self ZBarrierGetPiece( 5 );

	for ( ;; )
	{
		listen_piece waittill( notifyName );

//		PlayFXOnTag( localClientNum, fx, fx_piece, ZM_BGB_MACHINE_FLYING_EMBERS_FX_TAG );
		tag_angles = fx_piece GetTagAngles( "tag_fx_glass_cntr_jnt" );
		PlayFX( localClientNum, fx, fx_piece GetTagOrigin( "tag_fx_glass_cntr_jnt" ), AnglesToForward( tag_angles ), AnglesToUp( tag_angles ) );

		PlayFX( localClientNum, level._effect["zm_bgb_machine_smoke"], self.origin );

		self thread bgb_machine_play_random_sparks( localClientNum, level._effect["zm_bgb_machine_bulb_spark"], fx_piece );

		wait( 0.01 );
	}
}

function private bgb_machine_flying_gumballs_think( localClientNum )
{
	gumballs_piece = self ZBarrierGetPiece( 4 );
	fx_piece = self ZBarrierGetPiece( 5 );

	for ( ;; )
	{
		gumballs_piece util::waittill_any( "opening", "closing" );

		self thread bgb_machine_bulb_flash_selecting( localClientNum );

		PlayFXOnTag( localClientNum, level._effect["zm_bgb_machine_flying_elec"], fx_piece, "tag_fx_glass_cntr_jnt" );

		gumballs_piece HidePart( localClientNum, "tag_gumballs", "", true );

		bgb_pack = [];

		bgb_item_index = self clientfield::get( "zm_bgb_machine_selection" );
		bgb = level.bgb_item_index_to_name[bgb_item_index];

		for ( i = 0; i < level.bgb_pack[localClientNum].size; i++ )
		{
			if ( bgb == level.bgb_pack[localClientNum][i] )
			{
				// skip the selected one, it's been shown once already
				continue;
			}

			bgb_pack[bgb_pack.size] = level.bgb_pack[localClientNum][i];
		}

		// add a second copy of all the bgbs in the pack
		for ( i = 0; i < level.bgb_pack[localClientNum].size; i++ )
		{
			bgb_pack[bgb_pack.size] = level.bgb_pack[localClientNum][i];
		}

		// randomize once more, push the selected to the front, and then show as appropriate
		bgb_pack = array::randomize( bgb_pack );
		array::push_front( bgb_pack, bgb );
		for ( i = 0; i < 10; i++ )
		{
			gumballs_piece ShowPart( localClientNum, level.bgb[bgb_pack[i]].flying_gumball_tag + "_" + i );
		}

		wait( 0.01 );
	}
}

function private bgb_machine_give_gumball_think( localClientNum )
{
	piece = self ZBarrierGetPiece( 2 );

	for ( ;; )
	{
		piece waittill( "opening" );

		piece HidePart( localClientNum, "tag_gumballs", "", true );

		bgb_item_index = self clientfield::get( "zm_bgb_machine_selection" );
		bgb = level.bgb_item_index_to_name[bgb_item_index];
		// if ghost ball, unhide that tag
		if( self clientfield::get( "zm_bgb_machine_ghost_ball" ) )
		{
			piece ShowPart( localClientNum, "tag_gumball_ghost" );
		}
		else
		{
			piece ShowPart( localClientNum, level.bgb[bgb].give_gumball_tag );
		}

		wait( 0.01 );
	}
}

function private bgb_machine_interior_light_shake_piece_think( localClientNum )
{
	piece = self ZBarrierGetPiece( 1 );

	for ( ;; )
	{
		piece waittill( "opening" );

		bgb_machine_play_fx( localClientNum, piece, "tag_fx_glass_cntr_jnt", level._effect["zm_bgb_machine_light_interior"] );

		wait( 0.01 );
	}
}

function private bgb_machine_get_eye_fx_for_selected_bgb()
{
	bgb_item_index = self clientfield::get( "zm_bgb_machine_selection" );
	bgb = level.bgb_item_index_to_name[bgb_item_index];

	switch ( level.bgb[bgb].limit_type )
	{
	case "activated":
		return level._effect["zm_bgb_machine_eye_activated"];
	case "event":
		return level._effect["zm_bgb_machine_eye_event"];
	case "rounds":
		return level._effect["zm_bgb_machine_eye_rounds"];
	case "time":
		return level._effect["zm_bgb_machine_eye_time"];
	}

	return undefined;
}

function private bgb_machine_get_bulb_fx_for_selected_bgb()
{
	bgb_item_index = self clientfield::get( "zm_bgb_machine_selection" );
	bgb = level.bgb_item_index_to_name[bgb_item_index];

	switch ( level.bgb[bgb].limit_type )
	{
	case "activated":
		return level._effect["zm_bgb_machine_bulb_activated"];
	case "event":
		return level._effect["zm_bgb_machine_bulb_event"];
	case "rounds":
		return level._effect["zm_bgb_machine_bulb_rounds"];
	case "time":
		return level._effect["zm_bgb_machine_bulb_time"];
	}

	return undefined;
}

function private bgb_machine_play_fx( localClientNum, piece, tag, fx )
{
	if ( IsDefined( self.bgb_machine_fx[tag][localClientNum] ) )
	{
		DeleteFX( localClientNum, self.bgb_machine_fx[tag][localClientNum], true );
	}

	if ( IsDefined( fx ) )
	{
		self.bgb_machine_fx[tag][localClientNum] = PlayFXOnTag( localClientNum, fx, piece, tag );
	}
}

function private bgb_machine_play_top_fx( localClientNum, piece, fx )
{
	bgb_machine_play_fx( localClientNum, piece, "tag_fx_light_top_jnt", fx );
}

function private bgb_machine_play_top_side_fx( localClientNum, piece, fx )
{
	bgb_machine_play_fx( localClientNum, piece, "tag_fx_light_side_lft_top_jnt", fx );
	bgb_machine_play_fx( localClientNum, piece, "tag_fx_light_side_rt_top_jnt", fx );
}

function private bgb_machine_play_mid_side_fx( localClientNum, piece, fx )
{
	bgb_machine_play_fx( localClientNum, piece, "tag_fx_light_side_lft_mid_jnt", fx );
	bgb_machine_play_fx( localClientNum, piece, "tag_fx_light_side_rt_mid_jnt", fx );
}

function private bgb_machine_play_btm_side_fx( localClientNum, piece, fx )
{
	bgb_machine_play_fx( localClientNum, piece, "tag_fx_light_side_lft_btm_jnt", fx );
	bgb_machine_play_fx( localClientNum, piece, "tag_fx_light_side_rt_btm_jnt", fx );
}

function private bgb_machine_play_all_bulb_fx( localClientNum, piece, fx )
{
	bgb_machine_play_top_fx( localClientNum, piece, fx );

	bgb_machine_play_top_side_fx( localClientNum, piece, fx );
	bgb_machine_play_mid_side_fx( localClientNum, piece, fx );
	bgb_machine_play_btm_side_fx( localClientNum, piece, fx );
}

function private bgb_machine_play_sound( localclientnum, entity, alias )
{
	origin = entity gettagorigin( "tag_fx_light_top_jnt" );
	
	playsound(localclientnum,alias,origin);
}

function private bgb_machine_bulb_pattern( localClientNum )
{
	self notify( "bgb_machine_bulb_fx_start" );
	self endon( "bgb_machine_bulb_fx_start" );

	piece = self ZBarrierGetPiece( 5 );

	fx = level._effect["zm_bgb_machine_bulb_available"];
	pattern_time = 0.2;
	flash_time = 0.4;

	// clear everything to start off
	bgb_machine_play_all_bulb_fx( localClientNum, piece, undefined );

	for ( ;; )
	{
		bgb_machine_play_top_fx( localClientNum, piece, fx );

		bgb_machine_play_btm_side_fx( localClientNum, piece, fx );
		bgb_machine_play_sound( localClientNum, piece, "zmb_bgb_machine_light_click" );

		wait( pattern_time );

		bgb_machine_play_btm_side_fx( localClientNum, piece, undefined );
		bgb_machine_play_mid_side_fx( localClientNum, piece, fx );
		bgb_machine_play_sound( localClientNum, piece, "zmb_bgb_machine_light_click" );

		wait( pattern_time );

		bgb_machine_play_mid_side_fx( localClientNum, piece, undefined );
		bgb_machine_play_top_side_fx( localClientNum, piece, fx );
		bgb_machine_play_sound( localClientNum, piece, "zmb_bgb_machine_light_click" );

		wait( pattern_time );

		bgb_machine_play_top_side_fx( localClientNum, piece, undefined );
		bgb_machine_play_mid_side_fx( localClientNum, piece, fx );
		bgb_machine_play_sound( localClientNum, piece, "zmb_bgb_machine_light_click" );

		wait( pattern_time );

		bgb_machine_play_mid_side_fx( localClientNum, piece, undefined );
		bgb_machine_play_btm_side_fx( localClientNum, piece, fx );
		bgb_machine_play_sound( localClientNum, piece, "zmb_bgb_machine_light_click" );

		wait( pattern_time );

		bgb_machine_play_all_bulb_fx( localClientNum, piece, undefined );

		wait( pattern_time );

		bgb_machine_play_all_bulb_fx( localClientNum, piece, fx );
		bgb_machine_play_sound( localClientNum, piece, "zmb_bgb_machine_light_click" );

		wait( flash_time );

		bgb_machine_play_all_bulb_fx( localClientNum, piece, undefined );

		wait( flash_time );

		bgb_machine_play_all_bulb_fx( localClientNum, piece, fx );
		bgb_machine_play_sound( localClientNum, piece, "zmb_bgb_machine_light_click" );

		wait( flash_time );

		bgb_machine_play_all_bulb_fx( localClientNum, piece, undefined );

		wait( flash_time );
	}
}

function private bgb_machine_bulb_flash( localClientNum, piece, fx, flash_time, alias )
{
	self notify( "bgb_machine_bulb_fx_start" );
	self endon( "bgb_machine_bulb_fx_start" );

	for ( ;; )
	{
		bgb_machine_play_all_bulb_fx( localClientNum, piece, fx );
		
		if( isdefined( alias ) )
			bgb_machine_play_sound( localClientNum, piece, alias );

		wait( flash_time );

		bgb_machine_play_all_bulb_fx( localClientNum, piece, undefined );

		wait( flash_time );
	}
}

function private bgb_machine_bulb_flash_selected_bgb( localClientNum )
{
	self thread bgb_machine_bulb_flash( localClientNum, self ZBarrierGetPiece( 5 ), self bgb_machine_get_bulb_fx_for_selected_bgb(), 0.4, "zmb_bgb_machine_light_ready" );
}

function private bgb_machine_bulb_flash_selecting( localClientNum )
{
	self thread bgb_machine_bulb_flash( localClientNum, self ZBarrierGetPiece( 5 ), level._effect["zm_bgb_machine_bulb_available"], 0.2, "zmb_bgb_machine_light_click" );
}

function private bgb_machine_bulb_flash_away( localClientNum )
{
	self thread bgb_machine_bulb_flash( localClientNum, self ZBarrierGetPiece( 1 ), level._effect["zm_bgb_machine_bulb_away"], 0.4, "zmb_bgb_machine_light_leaving" );
}

function private bgb_machine_bulb_solid_away( localClientNum )
{
	self notify( "bgb_machine_bulb_fx_start" );

	bgb_machine_play_all_bulb_fx( localClientNum, self ZBarrierGetPiece( 5 ), level._effect["zm_bgb_machine_bulb_away"] );
}

function private bgb_machine_fx_state( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	// need this because of hot joiners, this might run before the init callback
	bgb_machine_init( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump );

	eye_fx = undefined;
	light_interior_fx = undefined;

	switch ( newVal )
	{
	case 1:
		bgb_machine_play_fx( localClientNum, self ZBarrierGetPiece( 5 ), "tag_fx_glass_cntr_jnt", level._effect["zm_bgb_machine_light_interior_away"] );

		self thread bgb_machine_bulb_solid_away( localClientNum );
		break;
	case 2:
		eye_fx = level._effect["zm_bgb_machine_eye_away"];
		eye_piece = self ZBarrierGetPiece( 1 );

		self thread bgb_machine_bulb_flash_away( localClientNum );
		break;
	case 3:
		light_interior_fx = level._effect["zm_bgb_machine_light_interior"];
		light_interior_piece = self ZBarrierGetPiece( 5 );

		eye_fx = bgb_machine_get_eye_fx_for_selected_bgb();
		eye_piece = self ZBarrierGetPiece( 2 );

		self thread bgb_machine_bulb_flash_selected_bgb( localClientNum );

		bgb_machine_play_fx( localClientNum, eye_piece, "tag_gumball_ghost", level._effect["zm_bgb_machine_gumball_halo"] );
		break;
	case 4:
		bgb_machine_play_fx( localClientNum, self ZBarrierGetPiece( 5 ), "tag_fx_glass_cntr_jnt", level._effect["zm_bgb_machine_light_interior"] );

		self thread bgb_machine_bulb_pattern( localClientNum );

		// this will kill the gumball halo whether it was taken or left, and if it wasn't already running, no big deal
		halo_piece = self ZBarrierGetPiece( 2 );
		bgb_machine_play_fx( localClientNum, halo_piece, "tag_gumball_ghost", undefined );
		break;
	}

	bgb_machine_play_fx( localClientNum, eye_piece, "tag_fx_light_lion_lft_eye_jnt", eye_fx );
	bgb_machine_play_fx( localClientNum, eye_piece, "tag_fx_light_lion_rt_eye_jnt", eye_fx );
}

