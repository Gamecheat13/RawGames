#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_audio;
#include maps\_vehicle;



spinup_ny_harbor_hind(spinup_time)
{
	// start the rotor rotating for now
	if (spinup_time > 0)
	{
		blades = self.landed_blades;
		guys = [];
		guys[0] = blades;
		blades thread anim_loop( guys, "rotor_spin" );
		rate=0.1;
		spinup_rate = 20;
		time = 0;
		dt = .05;
		time_to_start_treads = 0;
		treads_started=false;
		animation = level.scr_anim[blades.animname]["rotor_spin"][0];
		while (time < spinup_time)
		{
			if (!treads_started && (time >= time_to_start_treads))
			{
				treads_started = true;
				self notify("stop_kicking_up_dust");
				self thread aircraft_dust_kickup();
			}
			blades setanimknob(animation, 1.0, 0.2, rate);
			wait dt;
			time += dt;
			rate = (time/spinup_time)*spinup_rate;
		}
		// stop the animation
		blades stopanimscripted();
		blades SetAnimKnob( animation, 1, 0, 0 );
	}
	else
	{
		//self notify("stop_kicking_up_dust");
		//self thread aircraft_dust_kickup();
	}
	// we are spinning fast enough to switch to the spinning model
	self.landed_blades hide();
	self ShowPart(self.flying_blades_tag);
}



fix_hind_doors()
{
	wait 0.05;	// let things get started
	guys = [];
	guys[0] = level.player_hind;
	level.player_hind anim_single( guys, "open_door_idle", undefined, undefined, "ny_harbor_hind" ); 
}

retract_landing_gear()
{
	level.player_hind anim_single_solo(level.player_hind, "landing_gear_retract");
	level.player_hind anim_single_solo(level.player_hind, "landing_gear_retract_idle");
}

swap_hind_guns(viewmodel_gun)
{
	if (!isdefined(level.use_hind_mg))
		return;
	//viewmodel_bones=["tag_barrel", "reloadgrip", "trigger", "barelrecoil", "bullet01", "bullet02", "bullet03", "bullet04", "bullet05", "bullet06", "bullet07", "bullet08", "bullet09", "bullet10" ];
	if (viewmodel_gun)
	{
		self.turret_model Hide();
		self.mgturret[0] Show();
		//self HidePart("tag_turret_npc");
		//foreach (bone in viewmodel_bones)
			//self ShowPart(bone);
	}
	else
	{
		self.turret_model Show();
		self.mgturret[0] Hide();
		//self ShowPart("tag_turret_npc");
		//foreach (bone in viewmodel_bones)
			//self HidePart(bone);
	}
}




player_dismount_hind_gun()
{
	//self ==> the vehicle being used by the player
	if (isdefined(level.use_hind_mg))
	{
		player_exit_turret_with_viewmodel(level.hind_tvm);
		level.hind_tvm.player unlink();
		level.hind_tvm.player notify("unlink");
	}
	else
	{
		self useby( self.minigunUser );
		self.minigunUser unlink();
	}
	level notify( "player_off_hind_gun" );
	
	level.player allowcrouch( true );
	level.player allowprone( true );
	level.player allowsprint( true );
	level.player allowjump( true );

	thread hud_hide( false );
}


player_lerped_onto_hind_sideturret( nolerp )
{
	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player allowsprint( false );
	level.player allowjump( false );
	if (isdefined(level.use_hind_mg))
	{
		hind_turret = level.player_hind.mgturret[0];
   		level.hind_tvm = level.player_hind setup_turret_with_viewmodel(hind_turret, level.player, "tag_player_doorgun", undefined, 75, 75, 35, 45, "viewhands_player_delta_shg");
		level.player_hind thread player_use_turret_with_viewmodel( level.hind_tvm );
		level.player_hind swap_hind_guns(true);
	}
	else
	{
		thread player_lerped_onto_minigun( false );
		/*
	   	level.hind_tvm = level.player_hind setup_turret_with_viewmodel(undefined, level.player, "tag_player", "tag_butt", 27, 85, 30, 30);
		level.player_hind thread player_use_vehicle_turret_with_viewmodel( level.hind_tvm );
		level.player_hind swap_hind_guns(true);
		*/
	}
	level.onHeli = true;
}




// this is a level/turret specific setup
// the vehicle is passed in as self
setup_turret_with_viewmodel( turret, player, player_link_tag, viewmodel_tag, right_arc, left_arc, top_arc, bottom_arc, viewhands )
{
	tvm = spawnstruct();
	tvm.right_arc = right_arc;
	tvm.left_arc = left_arc;
	tvm.top_arc = top_arc;
	tvm.bottom_arc = bottom_arc;
	tvm.lerp_on = true;
	tvm.viewmodel_tag = viewmodel_tag;		// tag the viewmodel will link to
	tvm.viewhands = viewhands;
	tvm.player_tag = player_link_tag;
	tvm.vehicle = self;
	if (isdefined(turret))
	{
		turret.animname = "hind_turret";
		turret.health = 99999;
		turret.is_occupied = false;
		if (isdefined(tvm.right_arc))
			AdjustHindPlayersViewArcs(tvm.right_arc, tvm.left_arc, tvm.top_arc, tvm.bottom_arc, 0);
		else
		{
			assert(0);
			player PlayerLinkToDelta( self, player_link_tag, 1 );
		}
	}
	//player EnableWeapons();
	tvm.turret = turret;								// which turret are we using
	tvm.player = player;								// for mp, we set save the player that is using this turret
	tvm.viewmodel = level.scr_model[ "player_rig" ];	// level needs to setup the appropriate rig
	tvm.end_on = "mortar_technical_hit";					// When the level is sent this notify, then the player_use thread will end
	if (isdefined(turret))
		tvm.turret_normal_model = turret.model;
	tvm.turret_viewmodel_model = "weapon_blackhawk_minigun_viewmodel";	// this needs to be viewmodel
	return tvm;
}



hindgun_fire( end_on )
{
	self endon( "death" );
	level endon( end_on );
	//Only need this logic for vehicle mounted miniguns
	if ( !issubstr(self.classname, "script_vehicle" ) )
		return;
	
	tracercount = 0;
	level endon( "player_off_hindgun" );
	while( flag( "player_on_hindgun" ) )
	{
		self waittill( "turret_fire" );
		self fireWeapon();
		// do tracer, since the weapon is a projectile
		tracercount = tracercount - 1;
		if (tracercount <= 0)
		{
			self handleTracer();
			tracercount = 4;
		}
		earthquake( 0.1, .13, self GetTagOrigin( "tag_turret" ), 200 );
		wait( 0.05 );
	}
}

play_fx_minigun()
{
	self endon( "death" );
	for(i=0;i<3;i++)
	{
		forward = anglestoforward(level.player getplayerangles());
		org = self GetTagOrigin( "TAG_FLASH" )+forward * 200;
		angles = level.player getplayerangles();
		//fx_origin linkto(self,"TAG_FLASH");
		playfx(getfx("minigun_projectile"),org,forward,(0,0,1));
		wait(.05);
	}
}

//

handleTracer()
{
	origin = self GetTagOrigin( "TAG_FLASH" );
	eyepos = level.player GetEye();
	forward = anglestoforward(level.player getplayerangles());
	tgtpos = eyepos + 12000*forward;
	startpos = eyepos + 60*forward;
	trace = BulletTrace( startpos, tgtpos, false );
	dest = trace["position"];
	//bullettracer( origin, dest, true );
	self thread play_fx_minigun();
}

hindgun_tracers( end_on )
{
	self endon( "death" );
	level endon( end_on );
	tracercount = 0;
	shotsbtntracers = 1;
	level endon( "player_off_hindgun" );
	while( flag( "player_on_hindgun" ) )
	{
		self waittill("missile_fire");
		tracercount = tracercount - 1;
		if (tracercount <= 0)
		{
			self handleTracer();
			tracercount = shotsbtntracers;
		}
		
	}
}

hindgun_shells( end_on )
{
	self endon( "death" );
	level endon( end_on );
	level endon( "player_off_hindgun" );
	
	fx = getfx( "minigun_shell_eject" );
	tag = "tag_brass";
	timebtnshots = 0.1;

	while ( 1 )
	{
		while ( level.player AttackButtonPressed() )
		{
			PlayFXOnTag( fx, self, tag );
			wait( timebtnshots );	// tune this to match the fire rate of the weapon
		}

		wait( 0.05 );
	}
}



// use this when the turret is part of the vehicle
player_use_vehicle_turret_with_viewmodel( tvm )
{
	level endon(tvm.end_on);

	player = level.player;

	//self ==> the vehicle being used by the player
   	player allowprone( false );
   	player allowcrouch( false );
	player disableWeapons();
	if (tvm.lerp_on)
		self lerp_player_view_to_tag( player, "tag_player", 1, 1, tvm.right_arc, tvm.left_arc, tvm.top_arc, tvm.bottom_arc );	// get there smoothly

	self useby( player );	// useby will always link to tag_player
	flag_set( "player_on_hindgun" );
	
	self thread hindgun_fire( tvm.end_on );
	
	self attach( tvm.viewmodel, tvm.viewmodel_tag );
	
	is_attacking = false;
	was_attacking = false;
	
/*
	idle_hands_anim = self getanim( "turret_hands_idle" );
	idle_gun_anim = self getanim( "turret_gun_idle" );
	self setAnim( idle_hands_anim, 1, 0, 1 );
	self setAnim( idle_gun_anim, 1, 0, 1 );
	self.hands_animation = idle_hands_anim;
	self.gun_animation = idle_gun_anim;

	while ( IsDefined( self ) )
	{
		is_attacking = level.player AttackButtonPressed();

		if ( was_attacking != is_attacking )
		{
			if ( is_attacking )
			{
				self thread animate_turret_with_viewmodel( "turret_hands_idle2fire", "turret_hands_fire", "turret_gun_idle2fire", "turret_gun_fire" );
			}
			else
			{
				self thread animate_turret_with_viewmodel( "turret_hands_fire2idle", "turret_hands_idle", "turret_gun_fire2idle", "turret_gun_idle" );
			}
		}
		
		was_attacking = is_attacking;
		wait 0.05;
	}
*/
}

// call on the vehicle when turret is not built into the vehicle
player_use_turret_with_viewmodel( tvm )
{
	level endon(tvm.end_on);
	tvm.turret assign_animtree();
	
	assert(!tvm.turret.is_occupied);
	tvm.turret.is_occupied = true;
	tvm.turret MakeUsable();
	tvm.turret SetMode( "manual" );
	tvm.turret UseBy(tvm.player );
	tvm.turret SetModel( tvm.turret_viewmodel_model );
	tvm.player DisableTurretDismount();
	tvm.turret MakeUnusable();

//	tvm.turret attach( tvm.viewmodel, "tag_player" );
	
	level.player PlayerLinkedTurretAnglesEnable();
	
	flag_set( "player_on_hindgun" );
	tvm.turret thread hindgun_tracers(tvm.end_on);
//	tvm.turret thread hindgun_shells(tvm.end_on);
	
	is_attacking = false;
	was_attacking = false;

	thread maps\_minigun_viewmodel::player_viewhands_minigun( tvm.turret, tvm.viewhands );

/*
	idle_hands_anim = tvm.turret getanim( "turret_hands_idle" );
	idle_gun_anim = tvm.turret getanim( "turret_gun_idle" );
	tvm.turret setAnim( idle_hands_anim, 1, 0, 1 );
	tvm.turret setAnim( idle_gun_anim, 1, 0, 1 );
	tvm.turret.hands_animation = idle_hands_anim;
	tvm.turret.gun_animation = idle_gun_anim;

	while ( IsDefined( tvm.turret ) )
	{
		is_attacking = level.player AttackButtonPressed();

		if ( was_attacking != is_attacking )
		{
			if ( is_attacking )
			{
				tvm.turret thread animate_turret_with_viewmodel( "turret_hands_idle2fire", "turret_hands_fire", "turret_gun_idle2fire", "turret_gun_fire" );
			}
			else
			{
				tvm.turret thread animate_turret_with_viewmodel( "turret_hands_fire2idle", "turret_hands_idle", "turret_gun_fire2idle", "turret_gun_idle" );
			}
		}
		
		was_attacking = is_attacking;
		wait 0.05;
	}
*/
}




player_exit_turret_with_viewmodel( tvm )
{
	level notify(tvm.end_on);

	assert(tvm.turret.is_occupied);
	tvm.turret.is_occupied = false;
	tvm.turret MakeUsable();
	tvm.turret SetMode( "manual" );
	tvm.player EnableTurretDismount();
	tvm.turret UseBy(tvm.player );
	tvm.turret SetModel( tvm.turret_normal_model );
	tvm.turret MakeUnusable();

	tvm.turret detach( tvm.viewmodel, "tag_player" );
}

// call on the turret
// assumes the viewmodel has been attached to the turret
animate_turret_with_viewmodel( to_hands_anim_name, hands_anim_name, to_gun_anim_name, gun_anim_name )
{
	self notify( "turret_anim_change" );
	self endon( "turret_anim_change" );
	
	to_hands_anim = self getanim( to_hands_anim_name );
	hands_anim = self getanim( hands_anim_name );
	to_gun_anim = self getanim( to_gun_anim_name );
	gun_anim = self getanim( gun_anim_name );
	
	// play transition animation
	self clearAnim( self.hands_animation, 0 );
	self clearAnim( self.gun_animation, 0 );
	self.hands_animation = to_hands_anim;
	self.gun_animation = to_gun_anim;
	self setAnim( to_gun_anim, 1, 0.1, 1 );
	self setFlaggedAnim( to_hands_anim_name, to_hands_anim, 1, 0.1, 1 );
	self waittillmatch( to_hands_anim_name, "end" );
	
	// play next state animation
	self clearAnim( to_hands_anim, 0 );
	self clearAnim( to_gun_anim, 0 );
	self.hands_animation = hands_anim;
	self.gun_animation = gun_anim;
	self setAnim( hands_anim, 1, 0.1, 1 );
	self setAnim( gun_anim, 1, 0.1, 1 );
}






AdjustHindPlayersViewArcs( right, left, top, bottom, time)
{
	player = level.player;
	if (!isdefined(player) || !isalive(player))
		return;
	if (!isdefined(player.right_view_arc) || (time <= 0))
	{	// snap to the requested values
		player.right_view_arc = right;
		player.left_view_arc = left;
		player.top_view_arc = top;
		player.bottom_view_arc = bottom;
		player PlayerLinkToDelta( level.player_hind, "tag_player", 0.65, player.right_view_arc, player.left_view_arc, player.top_view_arc, player.bottom_view_arc );
	}
	else
	{
		player LerpViewAngleClamp(time, 0, 0, right, left, top, bottom);
	}
}

kill_aircraft_dust()
{
	wait 0.05;
	self notify("stop_kicking_up_dust");	// stop dust until the blades start
}

#using_animtree( "script_model" );
setup_ny_harbor_hind(blades_stopped)
{
	/*
	self HidePart( "tag_turret_base" );
	self HidePart( "tag_turret" );
	self HidePart( "turret_animate_jnt" );
	self HidePart( "tag_barrel" );
	self HidePart( "barrel_animate_jnt" );
	self HidePart( "tag_flash" );
	self HidePart( "spin_jnt" );
	self HidePart( "tag_player" );
	self HidePart( "ammo_box_jnt" );
	*/

/*
	self.landed_blades = spawn("script_model", self.origin);
	self.landed_blades UseAnimTree( #animtree );
	self.landed_blades setmodel("vehicle_ny_harbor_hind_landed_blades");
	self.landed_blades.angles = self.angles;
	self.landed_blades linkto( self, "tag_origin");
	self.flying_blades_tag = "main_rotor_jnt";
	if (blades_stopped)
	{
		self.landed_blades show();
		self HidePart(self.flying_blades_tag);
		self thread kill_aircraft_dust();
	}
	else
	{
		self.landed_blades hide();
		self ShowPart(self.flying_blades_tag);
	}
*/
	self.animname = "ny_harbor_hind";
//	self.landed_blades.animname = "ny_harbor_hind_rotors";
	
	if (isdefined(level.use_hind_mg))
	{
		tag_turret_npc = "tag_turret_npc";
		self.turret_model = spawn("script_model", self gettagorigin(tag_turret_npc));
		self.turret_model setmodel("weapon_blackhawk_minigun");
		self.turret_model.angles = self gettagangles(tag_turret_npc);
		self.turret_model.origin = self gettagorigin(tag_turret_npc);
		self.turret_model LinkTo( self, tag_turret_npc, ( 0, 0, 0 ), ( 0, 0, 0 ) );
		while (!isdefined(self.mgturret))
			wait 0.05;
		self.turret_model.animname = "ny_harbor_hind";	// just so we use existing anims and animtrees
		self.turret_model setanimtree();
		/*
		idle_gun_anim = self getanim( "turret_gun_idle" );	// had to wait until other init completes
		self.turret_model setAnim( idle_gun_anim, 1, 0, 1 );	// put the world turret in a good anim state
		*/
		if (!isdefined(level.starting_on_hind) || (level.starting_on_hind == 0))
			self swap_hind_guns(false);
	}
}


move_npc_hind_gun()
{
	if (!isdefined(level.use_hind_mg))
		return;
	self.turret_model unlink();
	self.turret_model.origin = self GetTagOrigin("tag_doorgun");
	self.turret_model linkto(self, "tag_doorgun");
}

hide_hind_guns()
{
	if (!isdefined(level.use_hind_mg))
		return;
	if (isdefined(self.turret_model))
		self.turret_model Hide();
	self.mgturret[0] Hide();
}


hud_hide( state )
{
	wait 0.05;
	if ( state )
	{
		setsaveddvar( "ui_hidemap", 1 );
		SetSavedDvar( "hud_showStance", "0" );
		SetSavedDvar( "compass", "0" );
		SetDvar( "old_compass", "0" );
		SetSavedDvar( "ammoCounterHide", "1" );
	}
	else
	{
		setsaveddvar( "ui_hidemap", 0 );
		setSavedDvar( "hud_drawhud", "1" );
		SetSavedDvar( "hud_showStance", "1" );
		SetSavedDvar( "compass", "1" );
		SetDvar( "old_compass", "1" );
		SetSavedDvar( "ammoCounterHide", "0" );
	}
}


kill_hind_light()
{
	for (i=0; i<40; i++)
	{
		// ensure the light is off, by waiting for a thread that starts it
		level.player_hind vehicle_lights_off( "running" );
		wait 0.05;
	}
}

hide_hind_wing(delay)
{
	if (delay > 0)
		wait delay;
	level.player_hind HidePart("tag_wing_r");
	level thread kill_hind_light();
}

wait_for_turret_swap()
{
	level.player_arms waittillmatch("single anim","gunswap");
	level.player_hind move_npc_hind_gun();
}


player_lerped_onto_minigun( nolerp )
{
	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player allowsprint( false );
	level.player allowjump( false );
	level.player_hind setvehgoalpos(level.player_hind.origin, 1);	// ensure the ai is controlling the hind before the player takes control
	level.player_hind player_mount_blackhawk_gun( nolerp );
	level.onHeli = true;
}

player_mount_blackhawk_gun( nolerp, player, hide_hud )
{
	if( !IsDefined( player ) )
	{
		player = level.player;
	}

	self.minigunUser = player;
	
	//self ==> the vehicle being used by the player
	if ( !isdefined( hide_hud ) )
		hide_hud = true;
	thread hud_hide( hide_hud );
   	player allowprone( false );
   	player allowcrouch( false );
    if ( !isdefined( nolerp ) )
    {
    	player disableWeapons();
    		//lerp_player_view_to_tag( player, tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc )
    	self lerp_player_view_to_tag( player, "tag_player", 1, 1, 30, 30, 30, 30 );

    }

	self useby( player );
	tagAngles = self gettagangles( "tag_player" );
	player setplayerangles( tagAngles + ( 0, 0, 0 ) );	
//	flag_set( "player_on_minigun" );
	self thread maps\_minigun::minigun_think();
	//thread maps\_minigun::minigun_hints_on();
}

