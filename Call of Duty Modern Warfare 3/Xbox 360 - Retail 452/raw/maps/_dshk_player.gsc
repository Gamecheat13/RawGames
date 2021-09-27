#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;

/*-=-=-=-DSHK PLAYER TURRET-=-=-=

	WHAT YOU GET 
	A misc_turret the player can use whenever they want that has custom geton/getoff fire/idle anims
	
	WHAT YOU NEED:
	-A working misc_turret using the WEAPON_DSHK model
	-Precached viewarms assigned to the level.dshk_viewmodel variable
	-Run init_dshk_player() on level (runs global setup requirements)
	-Run dshk_turret_init() on each turret
	-include dshk_turret in your CSV (stuff for the gun AI using it)
	-include,dshk_turret_player in your CSV (player specific items)
	-if you want shell eject FX, precahce the level._effect and run dshk_shells() on the turret
	
=-=-=-=-=-=-=-=-=-=-=-=-=*/

//call this on level
init_dshk_player()
{
	assertEx( ( isdefined( level.dshk_viewmodel ) ), "Assign desired viewarms to level.dshk_viewmodel" );
	flag_init( "player_dismounting_turret" );
	flag_init ( "player_on_dshk_turret" );
	dshk_player_anims();

}		

#using_animtree( "vehicles" );
dshk_player_anims()
{
	level.scr_animtree[ "dshk_turret" ]							= #animtree;
	level.scr_animtree[ "turret_player_rig" ]							= #animtree;
	level.scr_model[ "turret_player_rig" ] 							= level.dshk_viewmodel; 
	level.scr_anim[ "turret_player_rig" ][ "turret_hands_geton" ]		= %dshk_player_dshk_geton;
	level.scr_anim[ "dshk_turret" ][ "turret_hands_getoff" ]	= %dshk_player_dshk_getoff;
	level.scr_anim[ "dshk_turret" ][ "turret_hands_idle" ]		= %dshk_player_dshk_idle;
	level.scr_anim[ "dshk_turret" ][ "turret_hands_fire" ]		= %dshk_player_dshk_fire;
	level.scr_anim[ "dshk_turret" ][ "turret_hands_idle2fire" ]	= %dshk_player_dshk_idle_to_fire;
	level.scr_anim[ "dshk_turret" ][ "turret_hands_fire2idle" ]	= %dshk_player_dshk_fire_to_idle;
	
	level.scr_anim[ "dshk_turret" ][ "turret_gun_geton" ]		= %dshk_geton;
	level.scr_anim[ "dshk_turret" ][ "turret_gun_getoff" ]		= %dshk_getoff;
	level.scr_anim[ "dshk_turret" ][ "turret_gun_idle" ]		= %dshk_idle;
	level.scr_anim[ "dshk_turret" ][ "turret_gun_fire" ]		= %dshk_fire;
	level.scr_anim[ "dshk_turret" ][ "turret_gun_idle2fire" ]	= %dshk_idle_to_fire;
	level.scr_anim[ "dshk_turret" ][ "turret_gun_fire2idle" ]	= %dshk_fire_to_idle;
	
}
//call this on your dshk turret
dshk_turret_init()
{
	//self = turret
    turret = self;
   	turret endon ( "death" );
    turret makeunusable();
    turret setdefaultdroppitch(0);

	while(1)
	{
		wait(1.5);
		
		trig_spot = get_world_relative_offset( turret.origin, turret.angles, (-32,0, -48) );
		self.usable_turret_trigger = Spawn( "trigger_radius", trig_spot, 0, 30, 128 );
		
		level.player custom_mount_hint_return_when_mounted(self.usable_turret_trigger);
		
		self thread player_use_dshk_with_viewmodel( self, level.player );
		self.usable_turret_trigger delete();

		//wait(2);
		level.player custom_dismount_hint_return_when_dismounted();
		handle_dismount();
	}	
	
    //hud_icon_minigun
}
		

custom_mount_hint_return_when_mounted(trig)
{
	//self = level.player
	trig endon ("death"); //gets death notify when deleted
	self.mount_hint = maps\_hud_util::createFontString( "default", 1.5 );
	self.mount_hint.alpha = 0.9;
	self.mount_hint.x = 0;
	self.mount_hint.y = 50;
	self.mount_hint.alignx = "center";
	self.mount_hint.aligny = "middle";
	self.mount_hint.horzAlign = "center";
	self.mount_hint.vertAlign = "middle";
	self.mount_hint.foreground = false;
	self.mount_hint.hidewhendead = true;
	self.mount_hint.hidewheninmenu = true;
	
	while(1)
	{
		if(self istouching(trig) )
		{
			self.mount_hint SetText( &"PLATFORM_HOLD_TO_USE" );
			if( self usebuttonpressed() ) 
			{
				self.mount_hint Destroy();
				return;
			}
		}	
		else
		{
			self.mount_hint SetText ("");	
		}	
		wait(.05);	
	}	

}	

custom_dismount_hint_return_when_dismounted()
{
	//self = level.player
	self.disomount_hint = maps\_hud_util::createFontString( "default", 1.5 );
	self.disomount_hint.alpha = 0.9;
	self.disomount_hint.x = 0;
	self.disomount_hint.y = 50;
	self.disomount_hint.alignx = "center";
	self.disomount_hint.aligny = "middle";
	self.disomount_hint.horzAlign = "center";
	self.disomount_hint.vertAlign = "middle";
	self.disomount_hint.foreground = false;
	self.disomount_hint.hidewhendead = true;
	self.disomount_hint.hidewheninmenu = true;

	self.disomount_hint SetText( &"PLATFORM_HOLD_TO_DROP" );

	notifyoncommand( "turret_dismount", "+usereload" );
	notifyoncommand( "turret_dismount", "+activate" );//no workie on 360 O_o
	self waittill( "turret_dismount");	

	self.disomount_hint Destroy();
}			
	
handle_dismount()
{	
	//need to prevent overlapping calls to this
	if(!flag ( "player_dismounting_turret" ) )
	{	
		flag_set ("player_dismounting_turret" );
		level.player FreezeControls(true);
		self.animname = "dshk_turret";
		self notify("player_dismount");
		self setanimtree();
	
		dismount_angle = self GetTagAngles("tag_ground");
	
		//getoff anim
		time = getanimlength(%dshk_player_dshk_getoff);
		hands_getoff = getanim("turret_hands_getoff");
		turret_getoff = getanim("turret_gun_getoff");
		self clearAnim ( %root, 0 );
		self setAnim(hands_getoff, 1, 0, 1);
		self setAnim(turret_getoff, 1, 0, 1);	
	
		wait(time);
	
		//detach viewarms
		self detachall();
	
		//ditch player
		self MakeUsable();
		self SetTurretDismountOrg(self gettagorigin("tag_ground"));
		level.player enableturretdismount();
		self UseBy(level.player);
		self makeunusable();
	
		//transition player view out smoothly.
		lerp_time = 0.15;
		level.player LerpFOV(65, lerp_time);
		linker = Spawn("script_origin", (0,0,0));
		linker.origin = self GetTagOrigin("tag_ground");
		linker.angles = dismount_angle;
		level.player PlayerLinkTo(linker, "", 1, 0, 0, 0, 0, false);
		linker MoveTo(self.mount_pos, lerp_time, lerp_time * 0.25);
		wait(lerp_time+0.1);	// give it extra time to finish, otherwise we can unlink within the ground.
		linker Delete();
		
		if(isdefined( level.player.disomount_hint ))
		{
			level.player.disomount_hint destroy();
		}
		
		if(isdefined( level.player.mount_hint ))
		{
			level.player.mount_hint destroy();
		}
		
		if(isdefined( self.player_rig ))
		{
			self.player_rig delete();
		}
	
		level.player enableweapons();
		level.player FreezeControls(false);
		flag_clear( "player_on_dshk_turret" );
		flag_clear( "player_dismounting_turret" );
		
	}	
}	


#using_animtree( "vehicles" );
player_use_dshk_with_viewmodel(turret,  player )
{
	flag_set( "player_on_dshk_turret" );
	turret endon ("player_dismount");
	turret.animname = "dshk_turret";
	turret setanimtree();

	player freezecontrols( true );
	player disableweapons();
	
	level.player setstance( "stand" );

	self.mount_pos = player.origin;

	// spawn hands
	turret.player_rig = spawn_anim_model( "turret_player_rig" );
	turret.player_rig.animname = "turret_player_rig";
	turret.player_rig LinkTo( turret, "tag_ground", (0, 0, 0), (0, 0, 0) );

	// hide the hands momentarily so we don't accidentally clip through them.
	turret.player_rig Hide();
	turret.player_rig delayCall( 0.25, ::Show );

	// start up animations
	turret anim_first_frame_solo( turret.player_rig, "turret_hands_geton", "tag_player" );
	anim_first_frame_solo( turret, "turret_gun_geton" );

	// blend player/view to hands
	player PlayerLinkToBlend( turret.player_rig, "tag_origin", 0.3, 0.1, 0.1 );

	// wait a little bit to let the player/view start moving to hands
	wait (0.2);

	//GETON anim
	time = getanimlength(%dshk_player_dshk_geton);
	hands_geton = turret.player_rig getanim("turret_hands_geton");
	turret_geton = getanim("turret_gun_geton");
	turret clearAnim( %root, 0 );	// Provided the model stays simple, we know we don't want any animations other than the geton playing now.
	turret setAnim(turret_geton, 1, 0, 1);	
	self thread NotifyAfterTime( "geton_anim_finished", "time is up", time );

	wait (0.1);	// Finish lerping the player's view into position before we add the hands
	turret.player_rig setAnim(hands_geton, 1, 0, 1);
	getonProgressTime = turret GetAnimTime(turret_geton);
	turret.player_rig SetAnimTime(hands_geton, getonProgressTime);

	player LerpFOV(55, 0.2);
	self waittill( "geton_anim_finished" );

	// get-on anims complete.
	// stick the player to the turret, kill the floating hands 
	// and attach hands to the turret instead.
	player PlayerLinkToDelta( self, "tag_player", 0.35, 90, 90, 45, 30, true );
	//ROADKILL: level.player PlayerLinkToDelta( self, "tag_player", 0.35, 360, 360, 45, 30, true );
	turret.player_rig Delete();
	turret.viewhands = level.scr_model[ "turret_player_rig" ];
	turret attach( turret.viewhands, "tag_ground" );

	self thread cleanup_on_death();

	// activate turret
	turret.is_occupIed = true;
	turret MakeUsable();
	turret SetMode( "manual" );
	player unlink();
	turret UseBy( player );
	turret makeunusable();
	player disableturretdismount();

	//IDLE anim
	idle_hands_anim = self getanim( "turret_hands_idle" );
	turret clearAnim ( hands_geton, 0.1 );
	turret setAnim( idle_hands_anim, 1, 0.1, 1 );
	turret.hands_animation = idle_hands_anim;

	idle_gun_anim = turret getanim( "turret_gun_idle" );
	turret clearAnim ( turret_geton, 0.1 );
	turret setAnim( idle_gun_anim, 1, 0.1, 1 );
	turret.gun_animation = idle_gun_anim;

	//flag_set( "player_on_dshk_turret" ); Moving this up to top of this function for better detection of player getting on turret

	is_attacking = false;
	was_attacking = false;

	//while ( IsDefined( turret ) )
	while(flag("player_on_dshk_turret"))
	{
		is_attacking = level.player AttackButtonPressed();

		if ( was_attacking != is_attacking )
		{
			if ( is_attacking )
			{
				turret thread animate_turret_with_viewmodel( "turret_hands_idle2fire", "turret_hands_fire", "turret_gun_idle2fire", "turret_gun_fire" );
			}
			else
			{
				turret thread animate_turret_with_viewmodel( "turret_hands_fire2idle", "turret_hands_idle", "turret_gun_fire2idle", "turret_gun_idle" );
			}
			was_attacking = is_attacking;
		}		
		wait 0.05;
	}
}

// assumes the viewmodel has been attached to the turret
animate_turret_with_viewmodel( to_hands_anim_name, hands_anim_name, to_gun_anim_name, gun_anim_name )
{
	self notify( "turret_anim_change" );
	self endon( "turret_anim_change" );
	self endon ("player_dismount");

	to_hands_anim = self getanim( to_hands_anim_name );
	hands_anim = self getanim( hands_anim_name );
	to_gun_anim = self getanim( to_gun_anim_name );
	gun_anim = self getanim( gun_anim_name );
	
	// play transition animation
	self clearAnim( self.hands_animation, 0 );
	self.hands_animation = to_hands_anim;
	self clearAnim( self.gun_animation, 0 );
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

cleanup_on_death()
{
	level.player endon( "death" );
	level.player waittill("death");

	level.player unlink();
	level.player LerpFOV(65, 0.1);
}

//optional function..run on turret with predefined effect
dshk_shells( fx_alias, end_on )
{
	self endon( "death" );
	
	if(isDefined(end_on))
	{
		level endon( end_on );
	}	
	
	fx = getfx( fx_alias );
	tag = "tag_brass";
	timebtnshots = 0.1;
	
	flag_wait("player_on_dshk_turret");
	
	while(flag("player_on_dshk_turret"))
	{
		while ( level.player AttackButtonPressed() )
		{
			PlayFXOnTag( fx, self, tag );
			wait( timebtnshots );	// tune this to match the fire rate of the weapon
		}
		wait( 0.05 );
	}
	
}

NotifyAfterTime( notifyString, killmestring, time )
{
	self endon( "death" );
	self endon( killmestring );
	wait time;
	self notify( notifyString );
}

get_world_relative_offset( origin, angles, offset )
{
	cos_yaw = cos( angles[ 1 ] );
	sin_yaw = sin( angles[ 1 ] );

	// Rotate offset by yaw
	x = ( offset[ 0 ] * cos_yaw ) - ( offset[ 1 ] * sin_yaw );
	y = ( offset[ 0 ] * sin_yaw ) + ( offset[ 1 ] * cos_yaw );

	// Translate to world position
	x += origin[ 0 ];
	y += origin[ 1 ];
	return ( x, y, origin[ 2 ] + offset[ 2 ] );
}