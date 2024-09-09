#include maps\_vehicle;
#include maps\_vehicle_shg;
#include maps\_anim;
#include maps\_utility;
#include maps\_shg_utility;
#include common_scripts\utility;
#include maps\_shg_anim;
#include soundscripts\_snd;
#include maps\_hud_util;

#using_animtree( "vehicles" );
main( model, type, classname )
{
	PreCacheModel( "vehicle_vm_x4walkerSplit_wheels" );
	PreCacheModel( "vehicle_vm_x4walkerSplit_turret" );
	PreCacheModel( "projectile_rpg7" );
	PreCacheShader( "bls_ui_turret_targetlock" );
	PreCacheShader( "bls_ui_turret_targetlock_white" );	
	PreCacheShader( "bls_ui_turret_targetacquired" );
	PreCacheItem( "mobile_turret_missile" );
	PreCacheRumble( "heavy_1s" );
	PreCacheShader( "bls_ui_turret_overlay_sm" );
	PreCacheShader( "bls_ui_turret_missle" );
	PreCacheShader( "bls_ui_turret_chevron" );
	PreCacheShader( "bls_ui_turret_chevron_right" );

	PreCacheShader( "bls_ui_turret_reticle_tl" );
	PreCacheShader( "bls_ui_turret_reticle_tr" );
	PreCacheShader( "bls_ui_turret_reticle_bl" );
	PreCacheShader( "bls_ui_turret_reticle_br" );
	
	PreCacheShader( "bls_ui_turret_reticule_hpip" );
	PreCacheShader( "bls_ui_turret_reticule_vpip" );
	
	PreCacheShader( "bls_ui_turret_warning" );
	
	PreCacheString( &"_X4WALKER_WHEELS_ENTER" );
	
	set_console_status();
	
	build_template( "x4walker_wheels_turret", model, type, classname );
	build_localinit( ::local_init );
	build_life( 999, 500, 1500 );
	build_team( "allies" );
	build_shoot_shock( "mobile_turret_shoot" );
	build_aianims( ::set_ai_anims );
	//build_idle( %x4walker_wheels_idle );
	//build_drive( %x4walker_wheels_idle );
	build_walker_death( classname );
	
	build_turret( "x4walker_turret", "tag_turret", "vehicle_npc_x4walkerSplit_turret", undefined, "manual", 0.2, 0 );
	
	register_vehicle_anims( classname );
	register_player_anims();
	register_fx();
}

build_walker_death( classname )
{
	//walker death fx/////
	level._effect[ "walkerexplode" ]				= LoadFX( "vfx/explosion/vehicle_x4walker_explosion" );

	build_deathmodel( "vehicle_x4walker_wheels", "vehicle_x4walker_wheels_destroyed" );
	
	//	build_deathfx( effect, 									tag, 					sound, 				bEffectLooping, 	delay, 			bSoundlooping, waitDelay, stayontag, notifyString )
	build_deathfx( "vfx/explosion/vehicle_x4walker_explosion", "TAG_DEATHFX" );
	
	build_deathquake( 1, 1.6, 500 );

	//"Name: build_radiusdamage( <offset> , <range> , <maxdamage> , <mindamage> , <bKillplayer>, <delay> )"
	build_radiusdamage( ( 0, 0, 32 ), 300, 200, 0, false );
	
}

register_vehicle_anims( classname )
{
	add_vehicle_anim( classname, "idle", %x4walker_wheels_turret_idle );
	add_vehicle_anim( classname, "cockpit_idle", %x4walker_wheels_turret_cockpit_idle );
}

register_fx()
{
	level._effect[ "exo_rocket_trail" ] = LoadFX( "fx/test/test_smoke_geotrail_exo_rocket" );
	level._effect[ "exo_rocket_explosion" ] = LoadFX( "fx/explosions/rpg_wall_impact" );
	level._effect[ "x4walker_wheels_rpg_fv" ] = LoadFX( "vfx/muzzleflash/x4walker_wheels_rpg_fv" );
	
}

local_init()
{
	self UseAnimTree( #animtree );
	
	self thread manage_player_using_mobile_turret();
	
	self thread monitor_vehicle_mount();
	self thread animation_think();
	self thread monitor_wheel_movements();
	
	self thread clean_up_vehicle();
	
	self ent_flag_init( "player_in_transition" );
	
	waittillframeend;
	
	// make turret collidable
	self.mgturret[0] MakeTurretSolid();
	self.mgturret[0] UseAnimTree( #animtree );
	
	// turn off shellshock by default
	self notify( "stop_vehicle_shoot_shock" );
	
	self vehicle_scripts\_x4walker_wheels_turret_aud::snd_init_x4_walker_wheels_turret();
}

#using_animtree( "generic_human" );
set_ai_anims()
{
	positions = [];
	
	positions[0] = SpawnStruct();
	positions[0].sittag = "tag_guy";
	//positions[0].idle = %x4walker_wheels_idle_npc;
	//positions[0].vehicle_getoutanim_clear = false;
	//positions[0].getin_idle_func = ::guy_set_animscripts;
	
	return positions;
}

#using_animtree( "player" );
register_player_anims()
{
	level.scr_anim[ "_vehicle_player_rig" ][ "enter_left_turret" ] = %x4walker_turret_cockpit_in_l_vm;
	level.scr_anim[ "_vehicle_player_rig" ][ "enter_right_turret" ] = %x4walker_turret_cockpit_in_r_vm;
	level.scr_anim[ "_vehicle_player_rig" ][ "enter_back_turret" ] = %x4walker_turret_cockpit_in_b_vm;
	level.scr_anim[ "_vehicle_player_rig" ][ "exit_left_turret" ] = %x4walker_turret_cockpit_out_l_vm;
	level.scr_anim[ "_vehicle_player_rig" ][ "exit_right_turret" ] = %x4walker_turret_cockpit_out_r_vm;
	level.scr_anim[ "_vehicle_player_rig" ][ "exit_back_turret" ] = %x4walker_turret_cockpit_out_b_vm;
	
	addNotetrack_customFunction( "_vehicle_player_rig", "cockpit_swap", ::swap_cockpit_model, "enter_left_turret" );
	addNotetrack_customFunction( "_vehicle_player_rig", "cockpit_swap", ::swap_cockpit_model, "enter_right_turret" );
	addNotetrack_customFunction( "_vehicle_player_rig", "cockpit_swap", ::swap_cockpit_model, "enter_back_turret" );
	addNotetrack_customFunction( "_vehicle_player_rig", "cockpit_swap", ::swap_world_model, "exit_left_turret" );
	addNotetrack_customFunction( "_vehicle_player_rig", "cockpit_swap", ::swap_world_model, "exit_right_turret" );
	addNotetrack_customFunction( "_vehicle_player_rig", "cockpit_swap", ::swap_world_model, "exit_back_turret" );
}

manage_player_using_mobile_turret()
{
	self endon( "death" );
	
	// enable dof in vehicle while in vehicle
	self thread handle_vehicle_dof();
	
	// spawn usable model and place around vehicle
	// left, right, back
	self.enter_use_tags = [];
	for ( i = 0; i < 3; i++ )
	{
		use_tag = Spawn( "script_model", (0,0,0) );
		use_tag SetModel( "tag_origin" );
		use_tag Hide();
		self.enter_use_tags[i] = use_tag;
	}
	
	tag_body_pos = self GetTagOrigin( "tag_body" );
	tag_wheel_front_left_pos = self GetTagOrigin( "tag_wheel_front_left" );
	tag_wheel_front_right_pos = self GetTagOrigin( "tag_wheel_front_right" );
	tag_wheel_back_left_pos = self GetTagOrigin( "tag_wheel_back_left" );
	tag_wheel_back_right_pos = self GetTagOrigin( "tag_wheel_back_right" );
	
	// left
	self.enter_use_tags[0].origin = ( ( tag_wheel_front_left_pos[0] + tag_wheel_back_left_pos[0] ) * 0.5, ( tag_wheel_front_left_pos[1] + tag_wheel_back_left_pos[1] ) * 0.5, tag_body_pos[2] );
	// right
	self.enter_use_tags[1].origin = ( ( tag_wheel_front_right_pos[0] + tag_wheel_back_right_pos[0] ) * 0.5, ( tag_wheel_front_right_pos[1] + tag_wheel_back_right_pos[1] ) * 0.5, tag_body_pos[2] );
	// back
	self.enter_use_tags[2].origin = ( ( tag_wheel_back_left_pos[0] + tag_wheel_back_right_pos[0] ) * 0.5, ( tag_wheel_back_left_pos[1] + tag_wheel_back_right_pos[1] ) * 0.5, tag_body_pos[2] );
	
	foreach ( use_tag in self.enter_use_tags )
	{
		use_tag LinkTo( self );
		use_tag SetHintString( &"_X4WALKER_WHEELS_ENTER" );
		use_tag MakeUsable();
	}
	
	waittillframeend;
	self.tag_player_view = spawn_tag_origin();
	self.tag_player_view LinkTo( self.mgturret[0], "tag_barrel", (-38.9526, 6.01624, -46.3999), (0,0,0) );
	
	while ( true )
	{
		self MakeUnusable();
		wait_for_any_trigger_hit( self.enter_use_tags );
		
		self ent_flag_set( "player_in_transition" );
		snd_message("player_enter_walker_anim");
		enter_anim = self player_enter_turret();
		self ent_flag_clear( "player_in_transition" );
		
		self thread monitor_turret_rotation_rate();
		
		exit_anim_info = undefined;
		while ( !IsDefined( exit_anim_info ) )
		{
			self wait_for_exit_message();
			
			if ( !IsAlive( level.player ) || !IsDefined( level.player.drivingVehicleAndTurret ) )
			{
				// player was forced out of vehicle through script, don't try to find an exit anim
				break;
			}
			
			exit_anim_info = self find_best_exit_anim( enter_anim );
			
			if ( !IsDefined( exit_anim_info ) )
			{
				IPrintLnBold( "Could not find an exit!" );
			}
		}
		
		self ent_flag_set( "player_in_transition" );
		level.player DisableSlowAim();
		self.mgturret[0] MakeTurretSolid();
		thread lerp_fov_overtime( 2, 65 );
		
		// can be forced out by another script
		if ( IsDefined( level.player.drivingVehicleAndTurret ) && IsAlive( level.player ) )
		{
			// dismount vehicle
			snd_message("player_exit_walker_anim");
			self player_exit_turret( exit_anim_info );
		}
		
		self ent_flag_clear( "player_in_transition" );
	}
}

getCompassText( angle )
{
	northYaw = GetNorthYaw();
	angle -= northYaw;

	if ( angle < 0 )
		angle += 360;
	else if ( angle > 360 )
		angle -= 360;

	if ( angle < 45 || angle > 315 )
		direction = "N";
	else if ( angle < 135 )
		direction = "E";
	else if ( angle < 225 )
		direction = "S";
	else if ( angle < 315 )
		direction = "W";
	else
		direction = "";

	return( direction );
}

warning_update_text()
{
	self endon( "death" );
	self waittill( "play_damage_warning" );
	
	self notify( "destroy_compass_text" );
	
	self.compass_text SetText( "WARNING" );
	self.hud_warning.alpha = 1;
	self.compass_text thread  pulse_compass_text();	
}

update_hud_text()
{
	self endon( "death" );
	self endon( "player_exited_mobile_turret" );
	self endon( "destroy_hud_text" );
	
	while(1)
	{
		self.hud_text[0] SetText( round_float( self Vehicle_GetSteering(), 1, false ) );
		self.hud_text[1] SetText( round_float( self Vehicle_GetSpeed(), 1, false ) );
		waitframe();
	}
}

pulse_compass_text()
{
	self endon( "death" );
	self endon( "player_exited_mobile_turret" );
	self endon( "destroy_hud_text" );

	da = -0.1;
	
	while(1)
	{
		self.alpha += da;
		if( self.alpha <= 0 || self.alpha >= 1 )
		{
			da = da * -1;
		}
		waitframe();
	}
}

compass_update_text( )
{
	self endon( "destroy_hud_text" );
	self endon( "destroy_compass_text" );
	
	while(1)
	{
		angles = level.player GetPlayerAngles();	
		direction = getCompassText( angles[1] );
		self.compass_text SetText( direction );
		
		waitframe();
	}
}

turret_hud_elem_init_nofade( turret )
{
	self.alignX = "center";
	self.alignY = "middle";
	self.hidewhendead = true;
	self.hidewheninmenu = true;
	self.positioninworld = true;
	self SetTargetEnt( turret, "tag_aim_pivot" );		
}

turret_hud_elem_init( turret )
{
	self FadeOverTime( 0.5 );
	self.alpha = 1;
	
	self turret_hud_elem_init_nofade( turret );
}

turret_hud_elem_fadeout()
{
	self FadeOverTime( 0.1 );
	self.alpha = 0;
}

player_show_turret_hud()
{
	parallax_dist =  100000;
	player_height = 60;
	missile_start = -30000;
	missile_start2 = 25000;
	missile_offset = 5000;
	missile_height = - 23000;
	chevron_left_offset = 40000;
	chevron_right_offset = -40000;
	text_start = -14500;
	text_offset = 28000;
	compass_height = 21500;
	text_height = -22500;
	
	level.player endon( "death" );

	self.missiles = [];
	
	for( i=0; i<4; i++ )
	{
		if( i > 1 )
			missile_start = missile_start2;	
		
		self.missiles[i] = NewHudElem();
		self.missiles[i] SetShader( "bls_ui_turret_missle", 48, 48 );
		self.missiles[i] turret_hud_elem_init( self.mgturret[0] );
		self.missiles[i].x = parallax_dist;
		self.missiles[i].y = missile_start + ( i % 2 ) * missile_offset;
		self.missiles[i].z =  player_height + missile_height;
	}
		
	overlay = NewHudElem();
	overlay SetShader( "bls_ui_turret_overlay_sm", 720, 360 );
	overlay turret_hud_elem_init( self.mgturret[0] );
	overlay.sort = 2;
	overlay.x = parallax_dist;
	overlay.z = player_height;
	
	self.chevron = NewHudElem();
	self.chevron SetShader( "bls_ui_turret_chevron", 32, 32 );
	self.chevron turret_hud_elem_init( self.mgturret[0] );
	self.chevron.x = parallax_dist;
	self.chevron.y = chevron_left_offset;
	self.chevron.z = player_height;
	

	self.chevron_right = NewHudElem();
	self.chevron_right SetShader( "bls_ui_turret_chevron_right", 32, 32 );
	self.chevron_right turret_hud_elem_init( self.mgturret[0] );
	self.chevron_right.x = parallax_dist;
	self.chevron_right.y = chevron_right_offset;
	self.chevron_right.z = player_height;	
	
	
	self.compass_text = createFontString( "small", 1.0 );
	self.compass_text turret_hud_elem_init( self.mgturret[0] );
	self.compass_text.x = parallax_dist;
	self.compass_text.y = 0;
	self.compass_text.z = player_height + compass_height;
	
	self.hud_warning = NewHudElem();
	self.hud_warning SetShader( "bls_ui_turret_warning", 90, 24 );	
	self.hud_warning turret_hud_elem_init_nofade( self.mgturret[0] );
	self.hud_warning.alpha = 0;
	self.hud_warning.x = parallax_dist;
	self.hud_warning.y = 0;	
	self.hud_warning.z = player_height + compass_height;
	
	self.hud_text = [];
	
	for( i=0; i<2; i++ )
	{
		self.hud_text[i] = createFontString( "hudsmall", 0.75 );
		self.hud_text[i] turret_hud_elem_init( self.mgturret[0] );
		self.hud_text[i].x = parallax_dist;	
		self.hud_text[i].y = text_start + i * text_offset ;	
		self.hud_text[i].z = player_height + text_height;		
	}
	
	self thread update_hud_text();
		
	self thread compass_update_text();
	self thread warning_update_text();
	
	self thread player_show_missile_reticle();
		
	self waittill_any( "dismount_vehicle_and_turret", "death" );
	
	overlay turret_hud_elem_fadeout();	
	self.chevron turret_hud_elem_fadeout();	
	self.chevron_right turret_hud_elem_fadeout();	
	self.hud_warning turret_hud_elem_fadeout();	
	self.compass_text turret_hud_elem_fadeout();

	foreach( elem in self.missiles )
		elem turret_hud_elem_fadeout();

	foreach ( elem in self.hud_text )
		elem turret_hud_elem_fadeout();
	
	self waittill_any( "player_exited_mobile_turret", "death" );
	
	overlay Destroy();
	
	self.chevron Destroy();
	self.chevron_right Destroy();
	self.hud_warning Destroy();
	self notify( "destroy_hud_text" );	
	self.compass_text Destroy();
	
	foreach( elem in self.missiles )
		elem Destroy();
	
	foreach ( elem in self.hud_text )
		elem Destroy();
}

reticle_show()
{
	expanded_width = 32;
	expanded_height = 32;
		
	foreach( elem in self )
	{
		elem MoveOverTime( 0.1 );
		elem.alpha = 1;
	}
	
	self["tl"].x =0-expanded_width;
	self["tl"].y = 0-expanded_height;

	self["tr"].x = expanded_width;
	self["tr"].y = 0-expanded_height;
	
	self["br"].x = expanded_width;
	self["br"].y = expanded_height;

	self["bl"].x = 0-expanded_width;
	self["bl"].y = expanded_height;
	
	self["cross_l"].x = 0-expanded_width;
	self["cross_l"].y = 0;

	self["cross_r"].x = expanded_width;
	self["cross_r"].y = 0;

	self["cross_b"].x = 0;
	self["cross_b"].y = 0-expanded_height;

	self["cross_t"].x = 0;
	self["cross_t"].y = expanded_height;
}

reticle_hide()
{
	base_width = 16;
	base_height = 16;
		
	foreach( elem in self )
	{
		elem.alpha = 0;
	}
	
	self["tl"].x =0-base_width;
	self["tl"].y = 0-base_height;

	self["tr"].x = base_width;
	self["tr"].y = 0-base_height;
	
	self["br"].x = base_width;
	self["br"].y = base_height;

	self["bl"].x = 0-base_width;
	self["bl"].y = base_height;
	
	self["cross_l"].x = 0-base_width;
	self["cross_l"].y = 0;

	self["cross_r"].x = base_width;
	self["cross_r"].y = 0;

	self["cross_b"].x = 0;
	self["cross_b"].y = 0-base_height;

	self["cross_t"].x = 0;
	self["cross_t"].y = base_height;
}

player_show_missile_reticle()
{
	self.player_driver endon( "death" );
	
	base_width = 16;
	base_height = 16;

	self.reticle = [];

	self.reticle["tl"] = NewHudElem( );
	self.reticle["tr"] = NewHudElem( );
	self.reticle["br"] = NewHudElem( );
	self.reticle["bl"] = NewHudElem( );
	self.reticle["cross_l"] = NewHudElem();
	self.reticle["cross_r"] = NewHudElem( );
	self.reticle["cross_b"] = NewHudElem();
	self.reticle["cross_t"] = NewHudElem( );
		
	foreach( elem in self.reticle )
	{
		elem.elemType = "icon";
		elem.width = 32;
		elem.height = 32;
		elem.foreground = true;
		elem.children = [];
		elem setParent( level.uiParent );
		elem.alignx = "center";
		elem.aligny = "middle";
		elem.horzAlign = "center";
		elem.vertAlign = "middle";
		elem.alpha = 0;
		elem.hidewhendead = true;
	}

	self.reticle["tl"].x =0-base_width;
	self.reticle["tl"].y = 0-base_height;
	self.reticle["tl"] SetShader( "bls_ui_turret_reticle_tl", 32, 32 );

	self.reticle["tr"].x = base_width;
	self.reticle["tr"].y = 0-base_height;
	self.reticle["tr"] SetShader( "bls_ui_turret_reticle_tr", 32, 32 );	

	self.reticle["br"].x = base_width;
	self.reticle["br"].y = base_height;
	self.reticle["br"] SetShader( "bls_ui_turret_reticle_br", 32, 32 );	

	self.reticle["bl"].x = 0-base_width;
	self.reticle["bl"].y = base_height;
	self.reticle["bl"] SetShader( "bls_ui_turret_reticle_bl", 32, 32 );	
	
	self.reticle["cross_l"].x = 0-base_width;
	self.reticle["cross_l"].y = 0;
	self.reticle["cross_l"] SetShader( "bls_ui_turret_reticule_hpip", 16, 16 );	

	self.reticle["cross_r"].x = base_width;
	self.reticle["cross_r"].y = 0;
	self.reticle["cross_r"] SetShader( "bls_ui_turret_reticule_hpip", 16, 16 );	

	self.reticle["cross_b"].x = 0;
	self.reticle["cross_b"].y = 0-base_height;
	self.reticle["cross_b"] SetShader( "bls_ui_turret_reticule_vpip", 16, 16 );	

	self.reticle["cross_t"].x = 0;
	self.reticle["cross_t"].y = base_height;
	self.reticle["cross_t"] SetShader( "bls_ui_turret_reticule_vpip", 16, 16 );	
	
	self waittill( "dismount_vehicle_and_turret" );

	foreach( elem in self.reticle )
		elem turret_hud_elem_fadeout();

	self waittill( "player_exited_mobile_turret" );
	
	foreach( elem in self.reticle )
		elem Destroy();
}


player_enter_turret()
{
	level.player endon( "death" );
	
	if ( !IsAlive( level.player ) )
	{
		return;
	}
	
	level.player EnableDeathShield( true );
	
	foreach ( use_tag in self.enter_use_tags )
	{
		use_tag MakeUnusable();
	}
		
	level.player setup_player_for_scene();
	player_rig = spawn_player_rig();
	player_rig Hide();
	
	left_distance = DistanceSquared( level.player.origin, self.enter_use_tags[0].origin );
	right_distance = DistanceSquared( level.player.origin, self.enter_use_tags[1].origin );
	back_distance = DistanceSquared( level.player.origin, self.enter_use_tags[2].origin );
	
	closest_distance = left_distance;
	enter_anim = "enter_left_turret";
	if ( right_distance < closest_distance )
	{
		closest_distance = right_distance;
		enter_anim = "enter_right_turret";
	}

	if ( back_distance < closest_distance )
	{
		closest_distance = back_distance;
		enter_anim = "enter_back_turret";
	}
	
	level.player notify( "player_starts_entering_mobile_turret" );
	
	self anim_first_frame_solo( player_rig, enter_anim, "tag_body" );
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.2, 0.1, 0.1 );
	wait 0.2;
	
	thread lerp_fov_overtime( 2, 55 );
	
	player_rig Show();
	player_rig DontCastShadows();
	player_rig.vehicle_to_swap = self;
	self anim_single_solo( player_rig, enter_anim, "tag_body" );
	
	// tag to place player view relative to barrel - must happen after model switch
	//tag_pivot_origin = self.mgturret[0] GetTagOrigin( "tag_pivot" );
	//tag_barrel_origin = self.mgturret[0] GetTagOrigin( "tag_barrel" );
	//to_pivot = tag_pivot_origin - tag_barrel_origin - (0,0,60);
	//self.tag_player_view LinkTo( self.mgturret[0], "tag_barrel", to_pivot, (0,0,0) );
	
	level.player Unlink();
	player_rig Delete();
	level.player setup_player_for_gameplay();

	level.player DriveVehicleAndControlTurret( self );
	self.mgturret[0] SetContents( 0 );
	self.mgturret[0] UseBy( level.player );
	self.mgturret[0] MakeUnusable();
	level.player DisableTurretDismount();
	level.player PlayerLinkTo( self.mgturret[0], "tag_guy", 0, 180, 180, 11, 13, false );
	level.player.drivingVehicleAndTurret = self;
	level.player PlayerLinkedTurretAnglesEnable();
	level.player EnableSlowAim( 0.5, 0.35 );
	self.player_driver = level.player;
	self thread camera_shake();
	self thread randomize_turret_spread();
	self notify( "driving_vehicle_and_turret" );
	self.player_driver notify( "player_enters_mobile_turret" );
	self thread vehicle_scripts\_x4walker_wheels_turret_aud::snd_start_x4_walker_wheels_turret("plr");
	
	self thread player_show_turret_hud();
	
	level.player EnableDeathShield( false );
	level.player EnableInvulnerability(); //make the player invulnerable while he's driving the MT
	
	return enter_anim;
}

camera_shake()
{
	self endon( "death" );
	self endon( "dismount_vehicle_and_turret" );
	level.player endon( "death" );
	
	shake_duration = 7;
	shake_radius = 512;
	random_time = 0.5;
	wait_time = 1;
	
	while( true )
	{
		if( self Vehicle_GetSpeed() == 0 )
		{
			shake_scale = 0.08;
		}
		else
		{
			shake_scale = 0.12;
		}
		
		Earthquake( shake_scale, shake_duration, level.player.origin, shake_radius );
		wait( wait_time + RandomFloat( random_time ) );
	}
}

randomize_turret_spread()
{
	self endon( "death" );
	self endon( "dismount_vehicle_and_turret" );
	level.player endon( "death" );
	
	while( true )
	{
		spread = RandomFloatRange( 0.2, 1 );
		self.mgturret[0] SetPlayerSpread( spread );
		wait( 0.05 );
	}
}

find_best_exit_anim( enter_anim )
{
	exit_anims = [ "exit_left_turret", "exit_right_turret", "exit_back_turret" ];
	exit_anim_order = [ 0, 1, 2 ];
	
	if ( IsDefined( enter_anim ) )
	{
		if ( enter_anim == "enter_right_turret" )
		{
			exit_anim_order = [ 1, 0, 2 ];
		}
	}
	
	dummy_rig = spawn_player_rig();
	dummy_rig Hide();
	
	// figure out best exit
	for ( i = 0; i < exit_anims.size; i++ )
	{
		exit_anim_index = exit_anim_order[ i ];
		exit_anim_name = exit_anims[ exit_anim_index ];
		
		exit_anim = dummy_rig getanim( exit_anim_name );
		
		self anim_first_frame_solo( dummy_rig, exit_anim_name, "tag_body" );
		local_move_delta = GetMoveDelta( exit_anim, 0, 1 );
		anim_end_pos = dummy_rig localToWorldCoords( local_move_delta );
		
		trace_start = anim_end_pos + ( 0, 0, 15 );
		trace_hit = PlayerPhysicsTrace( trace_start, anim_end_pos );
		
		// ending up a little bit in the ground is ok, the engine will pop you off
		ground_tolerance = trace_hit[2] - anim_end_pos[2];
		
		if ( ground_tolerance < 1 )
		{
			dummy_rig Delete();
			return exit_anim_name;
		}
	}
	
	dummy_rig Delete();
	return undefined;
}

player_exit_turret( exit_anim )
{
	level.player endon( "death" );
	
	if ( !IsAlive( level.player ) )
	{
		return;
	}
	
	level.player DisableInvulnerability();
	level.player EnableDeathShield( true );
	
	self.mgturret[0] SetTurretDismountOrg( self.tag_player_view.origin );
	self.mgturret[0] UseBy( level.player );
	level.player PlayerLinkToDelta( self.tag_player_view, "tag_origin", 1 );
	level.player setup_player_for_scene();
	self wait_for_turret_reset();
	level.player Unlink();
	
	player_rig = spawn_player_rig();
	player_rig Hide();
	self anim_first_frame_solo( player_rig, exit_anim, "tag_body" );
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.2, 0.1, 0.1 );
	wait 0.2;
	player_rig Show();
	player_rig DontCastShadows();
	player_rig.vehicle_to_swap = self;
	
	level.player.drivingVehicleAndTurret = undefined;
	self.player_driver = undefined;
	if( !isDefined( self.burning ) )
	{
		level.player DriveVehicleAndControlTurretOff( self );
	}
	else
	{
		if( isDefined( self.damage_fx ) )
		{
			foreach( fx in self.damage_fx )
			{
				StopFXOnTag( getfx( fx.name ), self.mgturret[0], fx.tag );
			}
		}
	}
	self notify( "dismount_vehicle_and_turret" );
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 0, 0, 0, 0, true );
	self thread vehicle_scripts\_x4walker_wheels_turret_aud::snd_start_x4_walker_wheels_turret("npc");
	
	self anim_single_solo( player_rig, exit_anim, "tag_body" );
	level.player Unlink();
	player_rig Delete();
	level.player setup_player_for_gameplay();
	
	foreach ( use_tag in self.enter_use_tags )
	{
		use_tag MakeUsable();
	}
	
	level.player EnableDeathShield( false );
	self notify( "player_exited_mobile_turret" );
	level.player notify( "player_exited_mobile_turret" );
}

wait_for_turret_reset()
{
	turret_reset = false;
	
	while ( !turret_reset )
	{
		wait 0.05;
		
		tag_barrel_angles = self.mgturret[0] GetTagAngles( "tag_barrel" );
		
		vehicle_forward = AnglesToForward( self.angles );
		barrel_forward = AnglesToForward( tag_barrel_angles );
		
		forward_dot = VectorDot( vehicle_forward, barrel_forward );
		turret_reset = ( forward_dot > 0.95 );
	}
}

handle_vehicle_dof()
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "enter_vehicle_dof" );
		
		start = level.dofDefault;
		dof_enter_vehicle = [];
		dof_enter_vehicle[ "nearStart" ] = 10.0;
		dof_enter_vehicle[ "nearEnd" ]	= 70;
		dof_enter_vehicle[ "nearBlur" ] = 4;
		dof_enter_vehicle[ "farStart" ] = 9500;
		dof_enter_vehicle[ "farEnd" ] = 10000;
		dof_enter_vehicle[ "farBlur" ] = 0;
		dof_enter_vehicle[ "bias" ] = 0.5;
		
		blend_dof( start, dof_enter_vehicle, .25 );
		
		self waittill( "exit_vehicle_dof" );
		
		blend_dof( dof_enter_vehicle, start, .25 );
	}
}

wait_for_exit_message()
{
	self endon( "dismount_vehicle_and_turret" );
	
	exit_message = "exit_message";
	NotifyOnCommand( exit_message, "+activate" );
	NotifyOnCommand( exit_message, "+usereload" );
	
	level.player waittill( exit_message );
}

wait_for_any_trigger_hit( trigger_array )
{
	if ( trigger_array.size > 1 )
	{
		for ( i = 1; i < trigger_array.size; i++ )
		{
			trigger_array[i] endon( "trigger" );
		}
	}
	
	if ( trigger_array.size > 0 )
	{
		trigger_array[0] waittill( "trigger" );
	}
}

make_mobile_turret_usable()
{
	self MakeUnusable();
	foreach ( use_tag in self.enter_use_tags )
	{
		use_tag MakeUsable();
	}
}

make_mobile_turret_unusable()
{
	self MakeUnusable();
	foreach ( use_tag in self.enter_use_tags )
	{
		use_tag MakeUnusable();
	}
}

monitor_vehicle_mount()
{
	self endon( "death" );
	
	self SetAnim( get_vehicle_anim( "idle" ) );
	
	while ( true )
	{
		self waittill( "driving_vehicle_and_turret" );
		
		if ( !IsDefined( self.player_driver ) )
		{
			self thread handle_vehicle_ai();
			self make_mobile_turret_unusable();
		}
		else
		{
			self thread monitor_turret_shoot();
			self thread camera_shake_on_turret_fire();
			self thread rocket_think();
		}
		
		self wait_for_exit_message();
	}
}

animation_think()
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "play_anim", anim_mode );
		self clear_anims();
		self SetAnim( get_vehicle_anim( anim_mode ), 1.0, 0.2, 1.0 );
	}
}

#using_animtree( "vehicles" );
clear_anims()
{
	self ClearAnim( %walker_wheels_turret, 0.2 );
}

monitor_turret_shoot()
{
	self endon( "death" );
	self endon( "dismount_vehicle_and_turret" );
	
	//self thread clear_on_end_fire();
	
	while ( true )
	{
		self.mgturret[0] waittill( "turret_fire" );
		self.mgturret[0] SetAnimRestart( %x4walker_wheels_turret_cockpit_fire, 1, 0, 1 );
	}
}

camera_shake_on_turret_fire()
{
	self endon( "death" );
	self endon( "dismount_vehicle_and_turret" );
	
	while( true )
	{
		self.mgturret[0] waittill( "turret_fire" );
		Earthquake( 0.2, 0.1, self.player_driver.origin, 128 );
	}
}

/*
clear_on_end_fire()
{
	self endon( "death" );
	self endon( "dismount_vehicle_and_turret" );
	
	while ( true )
	{
		self.mgturret[0] waittill( "cockpit_fire", note );
		if ( note == "end" )
		{
			self.mgturret[0] ClearAnim( %root, 0 );
		}
	}
}
*/

rocket_think()
{
	self endon( "death" );
	self endon( "dismount_vehicle_and_turret" );
	
	Assert( IsDefined( self.player_driver ) );
	
	self thread monitor_missile_input();
	
	while ( true )
	{
		self waittill( "target_missile_system" );
		
		self thread rocket_target_think();
		
		self waittill( "fire_missile_system" );
		
		self thread fire_rockets();
		
		// delay until you can fire again
		
		wait 2;
		self.mgturret[0] SetAnimKnob( %x4walkersplit_cockpit_rockets_down, 1, 0.2, 1 );
		wait( 0.5 );
		self.mgturret[0] SetAnimKnob( %x4walkersplit_cockpit_rockets_up, 1, 0.2, 1 );
	}
}

rocket_target_think()
{
	self endon( "death" );
	self endon( "dismount_vehicle_and_turret" );
	self endon( "fire_missile_system" );
	
	Assert( IsDefined( self.player_driver ) );
	
	if ( !IsDefined( self.rocket_targets ) )
	{
		self.rocket_targets = [];
	}
	
	max_targets = 4;
	
	while ( true )
	{
		if ( self.rocket_targets.size < max_targets )
		{
			//self add_target_on_LOS();
			self add_target_on_dot();
		}
		
		wait 0.05;
	}
}

acquired_animation()
{
	self endon( "death" );
	wait 0.3;
	Target_SetShader( self, "bls_ui_turret_targetlock_white" );
}

add_target_on_LOS()
{
	look_forward = AnglesToForward( self.player_driver GetPlayerAngles() );
	look_forward = VectorNormalize( look_forward );
	eye_pos = self.player_driver GetEye();
			
	trace = BulletTrace( eye_pos, eye_pos + ( look_forward * 2048 ), true, self );
	hit_entity = trace[ "entity" ];
	if ( IsDefined( hit_entity ) && IsAI( hit_entity ) && IsAlive( hit_entity ) && !maps\_vehicle_code::attacker_isonmyteam( hit_entity ) && !maps\_vehicle_code::attacker_troop_isonmyteam( hit_entity ) )
	{
		if ( !IsDefined( hit_entity.target_marked ) || !hit_entity.target_marked )
		{
			hit_entity.target_marked = true;
			Target_Set( hit_entity, ( 0, 0, 20 ) );
			Target_SetShader( hit_entity, "bls_ui_turret_targetacquired" );
			hit_entity thread acquired_animation();
			snd_message( "x4_walker_hud_target_aquired", hit_entity );
					
			self thread remove_target( hit_entity );
					
			self.rocket_targets[ self.rocket_targets.size ] = hit_entity;
		}
	}
}

update_missile_hud()
{	
	if( IsDefined(self.missiles) && IsDefined( self.rocket_targets ) )
	{
		for( i = 0; i<self.rocket_targets.size; i++ )
		{
			self.missiles[i] FadeOverTime( 0.1 );
			self.missiles[i].alpha = 0.1;
		}
	
		for( ; i<self.missiles.size; i++)
		{
			self.missiles[i] FadeOverTime( 0.1 );			
			self.missiles[i].alpha = 1;
		}
	}
}


add_target_on_dot()
{
	look_forward = AnglesToForward( self.player_driver GetPlayerAngles() );
	look_forward = VectorNormalize( look_forward );
	eye_pos = self.player_driver GetEye();

	targets = get_all_valid_rocket_targets();
	foreach ( bad_guy in targets )
	{
		if ( IsDefined( bad_guy.target_marked ) && bad_guy.target_marked )
			continue;
		
		// just target vehicles, not bad guys in vehicles
		if ( IsDefined( bad_guy.ridingVehicle ) )
			continue;
		
		bad_guy_pos = bad_guy.origin;
		if ( IsAI( bad_guy ) )
		{
			bad_guy_pos = bad_guy GetEye();
		}
		
		to_bad_guy = bad_guy_pos - eye_pos;
		bad_guy_distance = Length( to_bad_guy );
		if ( bad_guy_distance > 2648 )
			continue;
		
		to_bad_guy = VectorNormalize( to_bad_guy );
		bad_guy_dot = VectorDot( look_forward, to_bad_guy );
		bad_guy_angle = abs( acos( bad_guy_dot ) );
		if ( bad_guy_angle > 4 )
			continue;
		
		bad_guy.target_marked = true;
		Target_Set( bad_guy, ( 0, 0, 20 ) );
		Target_SetShader( bad_guy, "bls_ui_turret_targetacquired" );
		bad_guy thread acquired_animation();
		snd_message( "x4_walker_hud_target_aquired", bad_guy );
					
		self thread remove_target( bad_guy );
					
		self.rocket_targets[ self.rocket_targets.size ] = bad_guy;
		
		return;
	}
	
	vehicles = getentarray( "script_vehicle", "code_classname" );
}

get_all_valid_rocket_targets()
{
	enemies = GetAIArray( "axis" );
	vehicles = getentarray( "script_vehicle", "code_classname" );
	
	all_targets = [];
	foreach ( guy in enemies )
	{
		if ( !IsAlive( guy ) )
			continue;
		
		all_targets[ all_targets.size ] = guy;
	}
	
	foreach ( vehicle in vehicles )
	{
		if ( IsSpawner( vehicle ) )
			continue;
		
		if ( !IsAlive( vehicle ) )
			continue;
		
		if ( IsDefined( vehicle.script_team ) && vehicle.script_team != "axis" )
			continue;
		
		if ( isDefined( vehicle.mobile_turret_rocket_target ) && !vehicle.mobile_turret_rocket_target )
			continue;
		
		all_targets[ all_targets.size ] = vehicle;
	}
	
	return all_targets;
}

remove_target( target_entity )
{
	self wait_to_remove_target( target_entity );
	
	if ( IsDefined( target_entity ) )
	{
		target_entity.target_marked = undefined;
		Target_Remove( target_entity );
	}
	
	// rebuild target array and remove any undefined entities and the target to remove
	if ( IsDefined( self ) && IsDefined( self.rocket_targets ) )
	{
		temp_targets = [];
		foreach ( rocket_target in self.rocket_targets )
		{
			if ( IsDefined( rocket_target ) )
			{
				if ( IsDefined( target_entity ) && rocket_target == target_entity )
					continue;
				
				temp_targets[ temp_targets.size ] = rocket_target;
			}
		}
		
		self.rocket_targets = temp_targets;
	}
}

wait_to_remove_target( target_entity )
{
	self endon( "death" );
	self endon( "dismount_vehicle_and_turret" );
	target_entity endon( "death" );
	
	target_entity waittill( "remove_target" );
}

monitor_missile_input()
{
	self endon( "death" );
	self endon( "dismount_vehicle_and_turret" );
	
	Assert( IsDefined( self.player_driver ) );
	
	missiles_active = false;
	while ( true )
	{
		frag_pressed = self.player_driver FragButtonPressed();
		if ( frag_pressed && !missiles_active )
		{
			missiles_active = true;
			SetSavedDvar( "cg_drawCrosshair", 0 );
			self.reticle reticle_show();
			
			self notify( "target_missile_system" );
		}
		else if ( !frag_pressed && missiles_active )
		{
			missiles_active = false;
			SetSavedDvar( "cg_drawCrosshair", 1 );
			self.reticle reticle_hide();
			
			self notify( "fire_missile_system" );
		}
		
		self update_missile_hud();
		
		wait 0.05;
	}
	
	SetSavedDvar( "cg_drawCrosshair", 1 );
}

fire_rockets()
{
	self endon( "death" );
	self endon( "dismount_vehicle_and_turret" );
	
	// create copy of rocket target array as array can change during firing
	rocket_target_copy = [];
	foreach ( rocket_target in self.rocket_targets )
	{
		rocket_target_copy[ rocket_target_copy.size ] = rocket_target;
	}
	
	missile_index = 0;
	foreach ( rocket_target in rocket_target_copy )
	{
		if ( !IsDefined( rocket_target ) || !IsAlive( rocket_target ) )
			continue;
		
		// target was removed since firing started
		if ( !IsDefined( rocket_target.target_marked ) )
			continue;
		
		self.player_driver PlayRumbleOnEntity( "heavy_1s" );
		Earthquake( 0.3, 1, self.player_driver.origin, 256 );
		Target_SetShader( rocket_target, "bls_ui_turret_targetlock" );
		snd_message( "x4_walker_hud_missile_launched", rocket_target );
		self thread fire_rocket_at( rocket_target, missile_index );
		missile_index++;
		wait 0.35;
	}
}

fire_rocket_at( rocket_target, missile_index )
{	
	if ( !IsDefined( self.launcher_index ) )
	{
		self.launcher_index = 0;
	}
	else
	{
		self.launcher_index++;
		self.launcher_index = self.launcher_index % 4;
	}
	
	end = rocket_target.origin;
	missile_index = self.launcher_index + 1;
	launcher_tag = "TAG_LAUNCHER" + missile_index;
	
	anime = undefined;
	switch( missile_index )
	{
		//the anims are numbered left to right, but the tags are numbered right to left
		case 1:
			anime = %x4walkersplit_cockpit_rockets_fire4;
			break;
		case 2:
			anime = %x4walkersplit_cockpit_rockets_fire3;
			break;
		case 3:
			anime = %x4walkersplit_cockpit_rockets_fire2;
			break;
		case 4:
			anime = %x4walkersplit_cockpit_rockets_fire1;
			break;
	}
	
	self.mgturret[0] SetAnimKnob( anime, 1, 0, 1 );
	
	start_pos = self.mgturret[0] GetTagOrigin( launcher_tag );
	launcher_angles = self.mgturret[0] GetTagAngles( launcher_tag );
	straight_pos = start_pos + ( AnglesToForward( launcher_angles ) * 512 );
	
	//play muzzleflash fx
	playfxontag(getfx("x4walker_wheels_rpg_fv"), self.mgturret[0], launcher_tag);
	
	missile = MagicBullet( "mobile_turret_missile", start_pos, straight_pos );
	missile snd_message( "x4_walker_fire_missile", rocket_target );
	//missile Missile_SetTargetPos( end );
	missile Missile_SetTargetEnt( rocket_target );
	missile Missile_SetFlightModeDirect();
	missile waittill( "death" );
	
	if ( IsDefined( rocket_target ) )
	{
		rocket_target notify( "remove_target" );
	}
}

handle_vehicle_ai()
{
	if ( IsDefined( self.ai_func_override ) )
	{
		self thread [[ self.ai_func_override ]]();
	}
	else
	{
		// AI driver
		self thread vehicle_scripts\_vehicle_turret_ai::vehicle_turret_default_ai();
	}
}

swap_cockpit_model( ent )
{
	if ( IsDefined( ent ) && IsDefined( ent.vehicle_to_swap ) )
	{
		ent.vehicle_to_swap notify( "enter_vehicle_dof" );
		ent.vehicle_to_swap SetModel( "vehicle_vm_x4walkerSplit_wheels" );
		ent.vehicle_to_swap.mgturret[0] SetModel( "vehicle_vm_x4walkerSplit_turret" );
		// hack fix to force engine to update entity's bone ids for IK to work.
		//   vehicle teleport will cause entity to reset and bone ids to be set again from new model
		ent.vehicle_to_swap Vehicle_Teleport( ent.vehicle_to_swap.origin, ent.vehicle_to_swap.angles );
		ent.vehicle_to_swap notify( "play_anim", "cockpit_idle" );
	}
}

swap_world_model( ent )
{
	if ( IsDefined( ent ) && IsDefined( ent.vehicle_to_swap ) )
	{
		ent.vehicle_to_swap notify( "exit_vehicle_dof" );
		ent.vehicle_to_swap SetModel( "vehicle_npc_x4walkerSplit_wheels" );
		ent.vehicle_to_swap.mgturret[0] SetModel( "vehicle_npc_x4walkerSplit_turret" );
		ent.vehicle_to_swap Vehicle_Teleport( ent.vehicle_to_swap.origin, ent.vehicle_to_swap.angles );
		ent.vehicle_to_swap notify( "play_anim", "idle" );
	}
}

clean_up_vehicle()
{
	self waittill( "death" );
	
	if ( IsDefined( self ) )
	{
		if ( IsDefined( self.enter_use_tags ) )
		{
			foreach ( use_tag in self.enter_use_tags )
			{
				use_tag Delete();
			}
		}
		
		if ( IsDefined( self.tag_player_view ) )
		{
			self.tag_player_view Delete();
		}
	}
}

// monitor velocities of legs for use in audio
monitor_wheel_movements()
{
	self endon( "death" );
	
	wheel_tags = [ "tag_wheel_back_left", "tag_wheel_back_right", "tag_wheel_front_left", "tag_wheel_front_right" ];
	self.last_wheel_pos = [];
	self.current_wheel_pos = [];
	update_rate = 0.05;
	if (level.currentgen)
		update_rate = 0.5;
	
	while ( true )
	{
		foreach ( wheel_tag in wheel_tags )
		{
			self.current_wheel_pos[ wheel_tag ] = self GetTagOrigin( wheel_tag );
		}
		
		wait update_rate;
		foreach ( wheel_tag in wheel_tags )
		{
			self.last_wheel_pos[ wheel_tag ] = self.current_wheel_pos[ wheel_tag ];
		}
	}
}

monitor_turret_rotation_rate()
{
	self endon( "death" );
	self endon( "dismount_vehicle_and_turret" );
	
	self.gun_struct = SpawnStruct();
	self.gun_struct.data_index = 0;
	self.gun_struct.max_points = 3;
	
	self.gun_struct.data = [];
	for ( i = 0; i < self.gun_struct.max_points; i++ )
	{
		self.gun_struct.data[i] = SpawnStruct();
		player_angles = self.player_driver GetPlayerAngles();
			
		self.gun_struct.data[ self.gun_struct.data_index ].yaw = player_angles[1];
		self.gun_struct.data[ self.gun_struct.data_index ].pitch = player_angles[0];
		self.gun_struct.data[ self.gun_struct.data_index ].time = GetTime();
		self.gun_struct.data_index = ( self.gun_struct.data_index + 1 ) % self.gun_struct.max_points;
	}
	
	while ( true )
	{
		if ( IsDefined( self.player_driver ) && IsDefined( self.mgturret[0] ) )
		{
			player_angles = self.player_driver GetPlayerAngles();
			
			self.gun_struct.data[ self.gun_struct.data_index ].yaw = player_angles[1];
			self.gun_struct.data[ self.gun_struct.data_index ].pitch = player_angles[0];
			self.gun_struct.data[ self.gun_struct.data_index ].time = GetTime();
			self.gun_struct.data_index = ( self.gun_struct.data_index + 1 ) % self.gun_struct.max_points;
			
			offsetAngle = AngleClamp180( player_angles[0] );
			offset = linear_map_clamp( offsetAngle, -11, 13, -6400, 25000 );
			self.chevron.z = offset;
			
			offsetAngle = AngleClamp( player_angles[1] );
			offset = linear_map_clamp( offsetAngle, 0, 360, -6400, 25000 );
			self.chevron_right.z = offset;
		}
		
		wait 0.05;
	}
}

get_wheel_velocity( wheel_tag )
{
	AssertEx( IsDefined( wheel_tag ), "wheel_tag parameter must be defined" );
	
	if ( IsDefined( self.current_wheel_pos[ wheel_tag ] ) && IsDefined( self.last_wheel_pos[ wheel_tag ] ) )
	{
		wheel_diff = self.current_wheel_pos[ wheel_tag ] - self.last_wheel_pos[ wheel_tag ];
		return wheel_diff * 20;
	}
	
	return (0,0,0);
}

get_gun_pitch_rate()
{
	if ( !IsDefined( self.gun_struct ) )
		return 0;
	
	start_index = self.gun_struct.data_index;
	mid_index = ( self.gun_struct.data_index + 1 ) % self.gun_struct.max_points;
	end_index = ( self.gun_struct.data_index + ( self.gun_struct.max_points - 1 ) ) % self.gun_struct.max_points;
	
	start_pitch = ( self.gun_struct.data[ start_index ].pitch + self.gun_struct.data[ mid_index ].pitch ) / 2;
	end_pitch = ( self.gun_struct.data[ mid_index ].pitch + self.gun_struct.data[ end_index ].pitch ) / 2;	
	
	pitch_speed = AngleClamp180( end_pitch - start_pitch );
	game_time = self.gun_struct.data[ end_index ].time - self.gun_struct.data[ start_index ].time;
	
	return ( pitch_speed * (1000 / game_time) );
}

get_gun_yaw_rate()
{
	if ( !IsDefined( self.gun_struct ) )
		return 0;
	
	start_index = self.gun_struct.data_index;
	mid_index = ( self.gun_struct.data_index + 1 ) % self.gun_struct.max_points;
	end_index = ( self.gun_struct.data_index + ( self.gun_struct.max_points - 1 ) ) % self.gun_struct.max_points;
	
	start_yaw = ( self.gun_struct.data[ start_index ].yaw + self.gun_struct.data[ mid_index ].yaw ) / 2;
	end_yaw = ( self.gun_struct.data[ mid_index ].yaw + self.gun_struct.data[ end_index ].yaw ) / 2;	
	
	yaw_speed = AngleClamp180( self.gun_struct.data[ end_index ].yaw - self.gun_struct.data[ start_index ].yaw );
	game_time = self.gun_struct.data[ end_index ].time - self.gun_struct.data[ start_index ].time;
	
	return ( yaw_speed * (1000 / game_time) );
}


/*QUAKED script_vehicle_x4walker_wheels_turret (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_x4walker_wheels_turret::main( "vehicle_npc_x4walkerSplit_wheels", undefined, "script_vehicle_x4walker_wheels_turret" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_x4walker_wheels_turret


defaultmdl="vehicle_npc_x4walkerSplit_wheels"
default:"vehicletype" "x4walker_wheels_turret"
default:"script_team" "allies"
*/

/*QUAKED misc_turret_x4walker_turret (1 0 0) (-16 -16 0) (16 16 56) pre-placed
Spawn Flags:
	pre-placed - Means it already exists in map.  Used by script only.

Key Pairs:
	leftarc - horizonal left fire arc.
	rightarc - horizonal left fire arc.
	toparc - vertical top fire arc.
	bottomarc - vertical bottom fire arc.
	yawconvergencetime - time (in seconds) to converge horizontally to target.
	pitchconvergencetime - time (in seconds) to converge vertically to target.
	suppressionTime - time (in seconds) that the turret will suppress a target hidden behind cover
	maxrange - maximum firing/sight range.
	aiSpread - spread of the bullets out of the muzzle in degrees when used by the AI
	playerSpread - spread of the bullets out of the muzzle in degrees when used by the player
	defaultmdl="vehicle_npc_x4walkerSplit_turret"
	default:"weaponinfo" "x4walker_turret"
	default:"targetname" "delete_on_load"
*/
