#include maps\_utility;
#include animscripts\utility;
#include common_scripts\utility;
#include maps\_hud_util;

main()
{
	flag_init( "coop_game" );
	flag_init( "coop_revive" );
	flag_init( "coop_alldowned" );
	flag_init( "coop_show_constant_icon" );
	flag_init( "coop_fail_when_all_dead" );

	setDvarIfUninitialized( "coop_revive", 1 );
	setDvarIfUninitialized( "coop_show_constant_icon", 1 );

	//later on - hopefully this flag will be set through some real time method
	//so that the 2nd player can jump in and out of a game at any moment...right
	//now this check only happens at the load of each level and doesn't get checked again
	if ( is_coop() )
		flag_set( "coop_game" );
	if ( getdvar( "coop_revive" ) == "1" )
		flag_set( "coop_revive" );

	flag_set( "coop_show_constant_icon" );

	// LANG_ENGLISH		Bleeding out"
	precacheString( &"SCRIPT_COOP_BLEEDING_OUT" );
	precacheString( &"SCRIPT_COOP_REVIVING" );
	// LANG_ENGLISH		Hold ^3[{+usereload}]^7 to revive"
	precacheString( &"SCRIPT_COOP_REVIVE" );
	precacheShader( "hint_health" );
	precacheShader( "coop_player_location" );
	precacheShader( "coop_player_location_fire" );

	level.coop_icon_green = ( 0.635, 0.929, 0.604 );
	level.coop_icon_yellow = ( 1, 1, 0.2 );
	level.coop_icon_orange = ( 1, .65, 0.2 );
	level.coop_icon_red = ( 1, 0.2, 0.2 );
	level.coop_icon_white = ( 1, 1, 1 );
	level.coop_icon_downed = level.coop_icon_yellow;
	level.coop_icon_shoot = level.coop_icon_green;
	level.coop_icon_damage = level.coop_icon_orange;
	
	level.coop_icon_blinktime = 7;  // how long the non-downed player's hud icon should blink after the downed player presses the nag button
	level.coop_icon_blinkcrement = 0.375;  // how long each "blink" lasts
	
	level.coop_bleedout_stage2_multiplier = 0.5;
	level.coop_bleedout_stage3_multiplier = 0.25;
	level.coop_revive_nag_hud_refreshtime = 20;

	// Used to keep one player alive for a few seconds when the other player goes down
	level.coop_last_player_downed_time = 0;
	thread downed_player_manager();
}

player_coop_proc()
{
	//this checks to see if we're already running the process
	if ( !flag( "coop_game" ) )
		return;
	level endon( "coop_game" );
	
	if ( self ent_flag( "coop_proc_running" ) )
		return;
	
	if ( !isdefined( self.original_maxhealth ) )
		self.original_maxhealth = self.maxhealth;
	
	if ( !flag( "coop_revive" ) )
		return;
	level endon( "coop_revive" );

	self thread player_coop_proc_ended();

	self ent_flag_set( "coop_proc_running" );
	self EnableDeathShield( true );
	
	assertex( self ent_flag_exist( "coop_downed" ), "Didnt have flag set" );
	self ent_flag_clear( "coop_downed" );
	self ent_flag_clear( "coop_pause_bleedout_timer" );

	self.coop.bleedout_time_default = 120;// 2 minutes

	/*
	switch( self.gameskill )
	{
		case 0:
			self.coop.bleedout_time_default = 40;	
			break;
		case 1:
			self.coop.bleedout_time_default = 30;	
			break;
		default:
			self.coop.bleedout_time_default = 20;	
	}	
	*/

	self thread player_setup_icon();

	self endon( "death" );
	
	my_id = self.unique_id;
	
	while ( 1 )
	{
		self waittill( "deathshield", damage, attacker, dir_vec, point, type, weaponName );
		
		// we're already downed
		if ( self ent_flag( "coop_downed" ) )
			continue;

		death_array = [];
		death_array[ "damage" ] = damage;
		death_array[ "player" ] = self;

		level.coop_death_reason = [];
		level.coop_death_reason[ "attacker" ] = attacker;
		level.coop_death_reason[ "cause" ] = type;
		level.coop_death_reason[ "id" ] = my_id;
		
		level.downed_players[ self.unique_id ] = death_array;

		// the downed_player_manager will down the player
		level notify( "player_downed" );
	}
}

downed_player_manager()
{
	for ( ;; )
	{
		// the array will be refilled when a player is downed
		level.downed_players = [];
		
		level waittill( "player_downed" );

		assertex( isdefined( level.player_downed_death_buffer_time ), "level.player_downed_death_buffer_time didnt get defined!" );
		
		// wait until the end of the frame so the array will have all players that were downed in it
		waittillframeend;

		if ( gettime() < level.coop_last_player_downed_time + level.player_downed_death_buffer_time * 1000 )
		{
			// cant die until this time has passed
			continue;
		}

		level.coop_last_player_downed_time = gettime();

		// figure out which player to down
		highest_damage = 0;
		downed_player = undefined;
		// randomize it so either player can be downed if they tie on damage		
		level.downed_players = array_randomize( level.downed_players );
		foreach ( unique_id, array in level.downed_players )
		{
			//Print3d( array[ "player" ] geteye(), array[ "damage" ], (1,0,0), 1, 1, 500 );
			if ( array[ "damage" ] >= highest_damage )
			{
				downed_player = array[ "player" ];
			}
		}
		assertex( isdefined( downed_player ), "Downed_player was not defined!" );
		
		downed_player thread player_coop_downed();
		
		// the remaining player gets slightly buffed
		thread maps\_gameskill::resetSkill();
	}
}

create_fresh_friendly_icon( material )
{
	if ( isdefined( self.friendlyIcon ) )
		self.friendlyIcon Destroy();
		
	self.friendlyIcon = NewClientHudElem( self );
	self.friendlyIcon SetShader( material, 1, 1 );
	self.friendlyIcon SetWayPoint( true, true, false );
	self.friendlyIcon SetWaypointIconOffscreenOnly();
	self.friendlyIcon SetTargetEnt( get_other_player( self ) );
	self.friendlyIcon.material = material;
	self.friendlyIcon.hidewheninmenu = true;

	if ( flag( "coop_show_constant_icon" ) )
		self.friendlyIcon.alpha = 1.0;
	else
		self.friendlyIcon.alpha = 0.0;
}

rebuild_friendly_icon( color, material, non_rotating )
{
	if ( isdefined( self.noFriendlyHudIcon ) )
		return;

	assertex( isdefined( color ), "rebuild_friendly_icon requires a valid color to be passed in." );
	assertex( isdefined( material ), "rebuild_friendly_icon requires a valid material to be passed in.");
	
	// Rebuild from scratch if it doesn't exist or the material has changed.
	if ( !isdefined( self.friendlyIcon ) || ( self.friendlyIcon.material != material ) )
	{
		create_fresh_friendly_icon( material );
	}

	self.friendlyIcon.color = color;
	if ( !isdefined( non_rotating ) )
		self.friendlyIcon SetWaypointEdgeStyle_RotatingIcon();
}

CreateFriendlyHudIcon_Normal()
{
	self rebuild_friendly_icon( level.coop_icon_green, "coop_player_location" );
}

CreateFriendlyHudIcon_Downed()
{
	self rebuild_friendly_icon( level.coop_icon_downed, "hint_health", true );
}

FriendlyHudIcon_BlinkWhenFire()
{
	self endon( "death" );

	while ( 1 )
	{
		self waittill( "weapon_fired" );
		other_player = get_other_player( self );
		other_player thread FriendlyHudIcon_FlashIcon( level.coop_icon_shoot, "coop_player_location_fire" );
	}
}

FriendlyHudIcon_BlinkWhenDamaged()
{
	self endon( "death" );

	while ( 1 )
	{
		self waittill( "damage" );
		other_player = get_other_player( self );
		other_player thread FriendlyHudIcon_FlashIcon( level.coop_icon_damage, "coop_player_location" );
	}
}

FriendlyHudIcon_FlashIcon( color, material )
{
	if ( isdefined( self.noFriendlyHudIcon ) )
		return;

	self endon( "death" );
	self notify( "flash_color_thread" );
	self endon( "flash_color_thread" );

	other_player = get_other_player( self );
	if ( other_player ent_flag( "coop_downed" ) )
		return;

	self rebuild_friendly_icon( color, material );
	wait .5;

	self rebuild_friendly_icon( level.coop_icon_green, "coop_player_location" );
}

player_setup_icon()
{
	if ( !flag( "coop_game" ) )
		return;
	level endon( "coop_game" );

	self CreateFriendlyHudIcon_Normal();
	self thread FriendlyHudIcon_BlinkWhenFire();
	self thread FriendlyHudIcon_BlinkWhenDamaged();

	if ( isdefined( self.noFriendlyHudIcon ) )
		return;

	while ( 1 )
	{
		flag_wait( "coop_show_constant_icon" );
		self.friendlyIcon.alpha = 1;

		flag_waitopen( "coop_show_constant_icon" );
		self.friendlyIcon.alpha = 0;
	}
}

player_coop_create_use_target()
{
	level.revive_ent = spawn( "script_model", self.origin );
	level.revive_ent setModel( "tag_origin" );
	level.revive_ent linkTo( self, "tag_origin" );
	level.revive_ent makeUsable();
	level.revive_ent setHintString( &"SCRIPT_COOP_REVIVE" );	// LANG_ENGLISH		Hold ^3[{+usereload}]^7 to revive"

	thread player_coop_destroy_use_target_mission_ended();
}

player_coop_destroy_use_target_mission_ended()
{
	level waittill( "special_op_terminated" );
	player_coop_destroy_use_target();
}

player_coop_destroy_use_target()
{
	if ( !isdefined( level.revive_ent ) )
		return;
	level.revive_ent Delete();
}

player_coop_downed()
{
	self endon( "death" );

	self player_coop_set_down_attributes();

	player_coop_check_alldowned();

	if ( flag( "coop_alldowned" ) )
		self player_coop_kill();

	self player_coop_create_use_target();
	
	//put up icon
	self thread player_coop_downed_dialogue();
	self thread player_coop_downed_hud();
	self thread player_coop_downed_icon();
	self thread player_coop_enlist_savior();

	self add_wait( ::flag_wait, "coop_alldowned" );
	self add_wait( ::ent_flag_waitopen, "coop_downed" );
	self add_wait( ::waittill_msg, "coop_bled_out" );
	do_wait_any();

	//take down icon
	waittillframeend;
	self notify( "end_func_player_coop_downed_icon" );

	if ( flag( "coop_alldowned" ) || self ent_flag( "coop_downed" ) )
		self player_coop_kill();

	self player_coop_set_original_attributes();
}

player_coop_downed_dialogue()
{
	self endon( "death" );
	self endon( "revived" );
	level endon( "special_op_terminated" );

	other_player = get_other_player( self );	
	time = other_player.coop.bleedout_time_default;
	//time_fifth = time * 0.2;
	initialWait = 1;
	
	wait initialWait;
	self notify( "so_downed" );
	self delaythread( 0.05, ::player_coop_downed_nag_button );
}

get_coop_downed_hud_color( current_time, total_time, doBlinks )
{
	// only one player should see the blinking
	if( !IsDefined( doBlinks ) )
	{
		doBlinks = true;
	}
	
	// maybe we have to deliver the blink state?
	if( doBlinks && self coop_downed_hud_should_blink() )
	{
		ASSERT( IsDefined( self.blinkState ) );
		
		if( self.blinkState == 1 )
		{
			return level.coop_icon_white;
		}
	}
	
	// if we're not blinking, return the base color
	if ( current_time < ( total_time * level.coop_bleedout_stage3_multiplier ) )
	{
		return level.coop_icon_red;
	}
	
	if ( current_time < ( total_time * level.coop_bleedout_stage2_multiplier ) )
	{
		return level.coop_icon_orange;
	}

	return level.coop_icon_downed;
}

coop_downed_hud_should_blink()
{
	otherplayer = get_other_player( self );
	
	if( otherplayer player_coop_is_reviving() )
	{
		return false;
	}
	
	// have we ever pressed the nag button?
	if( IsDefined( self.lastReviveNagButtonPressTime ) )
	{
		// did we press the button recently?
		if( ( GetTime() - self.lastReviveNagButtonPressTime ) < ( level.coop_icon_blinktime * 1000 ) )
		{
			return true;
		}
	}
	
	return false;
}

// this toggles the blink state so we don't have to track increment time in the get_coop_downed_hud_color() function
player_downed_hud_toggle_blinkstate()
{
	self notify( "player_downed_hud_blinkstate" );
	self endon( "player_downed_hud_blinkstate" );
	self endon( "death" );
	self endon( "revived" );
	
	self.blinkState = 1;
	
	while( 1 )
	{
		wait( level.coop_icon_blinkcrement );
		
		if( self.blinkState == 1 )
		{
			self.blinkState = 0;
		}
		else
		{
			self.blinkState = 1;
		}
	}
}

player_coop_downed_nag_button()
{
	self endon( "death" );
	self endon( "revived" );
	level endon( "special_op_terminated" );
	
	self NotifyOnPlayerCommand( "nag", "weapnext" );
	
	while( 1 )
	{
		if( !self can_show_nag_prompt() )
		{
			wait( 0.05 );
			continue;
		}
		
		if( self nag_should_draw_hud() )
		{
			self thread nag_prompt_show();
			self thread nag_prompt_cancel();
		}
		
		msg = self waittill_any_timeout( level.coop_revive_nag_hud_refreshtime, "nag", "nag_cancel" );
		
		if( msg == "nag" )
		{
			self.lastReviveNagButtonPressTime = GetTime();
			self thread player_downed_hud_toggle_blinkstate();
			self maps\_specialops_battlechatter::play_revive_nag();
		}
		
		wait( 0.05 );
	}
}

nag_should_draw_hud()
{
	waitTime = level.coop_revive_nag_hud_refreshtime * 1000;
	
	if( !IsDefined( self.lastReviveNagButtonPressTime ) )
	{
		return true;
	}
	else if( GetTime() - self.lastReviveNagButtonPressTime < waitTime )
	{
		return false;
	}
	
	return true;
}

nag_prompt_show()
{
	fadeTime = 0.05;
	loc = &"SPECIAL_OPS_REVIVE_NAG_HINT";
	
	hud = self get_nag_hud();
	hud.alpha = 0;
	hud SetText( loc );
	hud FadeOverTime( fadeTime );
	hud.alpha = 1;
	
	self waittill_any( "nag", "nag_cancel", "death" );
	
	hud FadeOverTime( fadeTime );
	hud.alpha = 0;
	hud delaycall( ( fadeTime + 0.05 ), ::Destroy );
}

get_nag_hud()
{
	hudelem = NewClientHudElem( self );
	
	hudelem.x = 0;
	hudelem.y = -50;
	hudelem.alignX = "center";
	hudelem.alignY = "middle";
	hudelem.horzAlign = "center";
	hudelem.vertAlign = "middle";
	hudelem.fontScale = 1;
	hudelem.color = ( 1.0, 1.0, 1.0 );
	hudelem.font = "hudsmall";
	hudelem.glowColor = ( 0.3, 0.6, 0.3 );
	hudelem.glowAlpha = 0;
	hudelem.foreground = 1;
	hudelem.hidewheninmenu = true;
	hudelem.hidewhendead = true;
	return hudelem;
}

nag_prompt_cancel()
{
	self endon( "nag" );
	
	while( self can_show_nag_prompt() )
	{
		wait( 0.05 );
	}
	
	self notify( "nag_cancel" );
}

can_show_nag_prompt()
{
	otherplayer = get_other_player( self );
	
	if( otherplayer player_coop_is_reviving() )
	{
		return false;
	}
	
	if( !self maps\_specialops_battlechatter::can_say_current_nag_event_type() )
	{
		return false;
	}
	
	return true;
}

player_coop_downed_hud()
{
	self endon( "end_func_player_coop_downed_icon" );
	self endon( "death" );
	self endon( "revived" );

	level endon( "special_op_terminated" );

	if ( level.console )
	{
		self.revive_text = createClientFontString( "hudsmall", 1.2 );
		self.revive_text setPoint( "CENTER", undefined, 0, 50 );

		self.revive_timer = createClientTimer( "hudsmall", 1.4 );
		self.revive_timer setPoint( "CENTER", undefined, 0, 70 );
	}
	else
	{
		self.revive_text = createClientFontString( "hudsmall", 1.2 );
		self.revive_text setPoint( "CENTER", undefined, 0, 50 );

		self.revive_timer = createClientTimer( "hudsmall", 1.4 );
		self.revive_timer setPoint( "CENTER", undefined, 0, 70 );
	}

	self thread player_coop_downed_hud_destroy( self.revive_text, self.revive_timer );
	// LANG_ENGLISH		Bleeding out"
	self.revive_text settext( &"SCRIPT_COOP_BLEEDING_OUT" );

	self.revive_timer setTimer( self.coop.bleedout_time_default - 1 );
	self thread player_coop_countdown_timer( self.coop.bleedout_time_default, self.revive_timer );

	time = self.coop.bleedout_time_default;

	self.revive_text.color = level.coop_icon_green;
	self.revive_timer.color = self.revive_text.color;

	// give player a chance to get his timer set
	waittillframeend;

	while ( time )
	{
		self.revive_text.color = get_coop_downed_hud_color( self.coop.bleedout_time, self.coop.bleedout_time_default, false );
		self.revive_timer.color = self.revive_text.color;

		wait 0.1;
		time -= 0.1;
	}
}

player_coop_downed_hud_destroy( text, timer )
{
	self thread player_coop_downed_hud_destroy_mission_end( text, timer );

	self waittill_any( "end_func_player_coop_downed_icon", "death" );
	if ( isdefined( text ) )	
		text destroy();
	if ( isdefined( timer ) )
		timer destroy();
}

player_coop_downed_hud_destroy_mission_end( text, timer )
{
	level waittill( "special_op_terminated" );

	if ( isdefined( text ) )	
		text destroy();
	if ( isdefined( timer ) )
		timer destroy();

	if ( isdefined( self.friendlyIcon ) )
		self.friendlyIcon Destroy();
	other_player = get_other_player( self );
	if ( isdefined( other_player.friendlyIcon ) )
		other_player.friendlyIcon Destroy();
}

player_coop_countdown_timer( time, hud_timer )
{
	self endon( "death" );
	self endon( "revived" );

	level endon( "special_op_terminated" );

	self.coop.bleedout_time = time;

	while ( self.coop.bleedout_time > 0 )
	{
		if ( self ent_flag( "coop_pause_bleedout_timer" ) )
		{
			hud_timer.alpha = 0;
			self ent_flag_waitopen( "coop_pause_bleedout_timer" );

			//need this check because was setting a time that wasn't greater than 0 which would give an error
			if ( self.coop.bleedout_time >= 1 )
				hud_timer settimer( self.coop.bleedout_time - 1 );
		}
		else
			hud_timer.alpha = 1;

		wait .05;
		self.coop.bleedout_time -= .05;
	}

	self.coop.bleedout_time = 0;
	maps\_specialops::so_force_deadquote( "@DEADQUOTE_SO_BLED_OUT" );
	thread maps\_specialops::so_dialog_mission_failed_bleedout();
	self notify( "coop_bled_out" );
}

player_coop_downed_icon()
{
	self endon( "end_func_player_coop_downed_icon" );
	self endon( "death" );
	self endon( "revived" );

	level endon( "special_op_terminated" );

	self thread player_coop_downed_icon_timer();

	//give player a chance to get his timer set
	waittillframeend;

	other_player = get_other_player( self );	
	other_player CreateFriendlyHudIcon_Downed();
	
	while ( self.coop.bleedout_time > 0 )
	{
		self ent_flag_waitopen( "coop_pause_bleedout_timer" );
		
		other_player rebuild_friendly_icon( get_coop_downed_hud_color( self.coop.bleedout_time, self.coop.bleedout_time_default ), "hint_health", true );
		wait 0.05;
	}
}

player_coop_downed_icon_timer()
{
	self endon( "end_func_player_coop_downed_icon" );
	self endon( "death" );
	self endon( "revived" );

	level endon( "special_op_terminated" );
	
	//give player a chance to get his timer set
	waittillframeend;

	other_player = get_other_player( self );	

	while ( self.coop.bleedout_time > 0 )
	{
		self ent_flag_waitopen( "coop_pause_bleedout_timer" );

		origin = self.origin + ( 0, 0, 80 );
		_size = .25 + ( distance( self.origin, other_player.origin ) * .0015 );

		if ( self.model != "" )
		{
			origin = self gettagorigin( "tag_origin" );
			offset = vector_multiply( anglestoright( self gettagangles( "tag_origin" ) ), 5 );
			origin += offset;
		}

		string = convert_to_time_string( self.coop.bleedout_time );
		color = self get_coop_downed_hud_color( self.coop.bleedout_time, self.coop.bleedout_time_default );
		print3d( origin + ( 0, 0, 35 + ( _size * 12 ) ), string, color, .75, _size );
		wait .05;
	}
}

player_coop_enlist_savior()
{
	savior = get_other_player( self );
	savior thread player_coop_revive_buddy();
}

player_coop_revive_buddy()
{
	self endon( "death" );
	self endon( "revived" );

	level endon( "special_op_terminated" );

	downed_buddy = get_other_player( self );
	buttonTime = 0;
	for ( ;; )
	{
		level.revive_ent waittill( "trigger" );
		
		if ( player_coop_is_reviving() )
		{
			// reset the other player's death protection if he initiates revive, so you can't infinitely revive each other
			level.coop_last_player_downed_time = 0;
			
			// Gives ability to reload by tapping support.
			wait 0.1;
			if ( !player_coop_is_reviving() )
				continue;

			bars = [];
			bars[ "p1" ] = createClientProgressBar( level.player );
			bars[ "p2" ] = createClientProgressBar( level.player2 );
		
			thread player_coop_check_mission_ended( bars, downed_buddy );
			
			downed_buddy.revive_text settext( &"SCRIPT_COOP_REVIVING" );

			speak_first = randomfloat( 1 ) > 0.33;
			if ( speak_first )
				self notify( "so_reviving" );
			
			buttonTime = 0;
			totalTime = 1.5;
			while ( player_coop_is_reviving() )
			{
				downed_buddy ent_flag_set( "coop_pause_bleedout_timer" );
				foreach ( bar in bars )
					bar updateBar( buttonTime / totalTime );

				wait( 0.05 );
				buttonTime += 0.05;
				if ( buttonTime > totalTime )
				{
					player_coop_revive_buddy_kill_bar( bars, downed_buddy );

					//if we get to here - we double tapped	
					downed_buddy player_coop_revive_self();
					if ( !speak_first )
						self notify( "so_revived" );
					return;
				}
			}

			player_coop_revive_buddy_kill_bar( bars, downed_buddy );
		}
	}
}

player_coop_is_reviving()
{
	if ( !self UseButtonPressed() )
		return false;
		
	if ( !player_coop_savior_close_enough() )
		return false;

/* Stopping on reload is "realistic" but not fun.
	if ( IsReloading() )
		return false;
*/
	return true;
}

player_coop_check_mission_ended( bars, downed_buddy )
{
	level endon( "revive_bars_killed" );
	downed_buddy endon( "revived" );
	
	level waittill( "special_op_terminated" );
	
	player_coop_revive_buddy_kill_bar( bars, downed_buddy );
}

player_coop_revive_buddy_kill_bar( bars, downed_buddy )
{
	level notify( "revive_bars_killed" );

	if ( isdefined( downed_buddy ) && isalive( downed_buddy ) )
	{
		downed_buddy ent_flag_clear( "coop_pause_bleedout_timer" );
		downed_buddy.revive_text settext( &"SCRIPT_COOP_BLEEDING_OUT" );
	}
	
	foreach ( bar in bars )
	{
		if ( isdefined( bar ) )
		{
			bar notify( "destroying" );
			bar destroyElem();
		}
	}
	
	if ( isdefined( self ) && isalive( self ) )
		self enableweapons();
}

player_coop_revive_self()
{
	self ent_flag_clear( "coop_downed" );
	self notify( "revived" );
	player_coop_destroy_use_target();
	self thread player_dying_effect_remove();
	
	// so other player loses health bonus from being only mobile guy
	thread maps\_gameskill::resetSkill();
}

player_coop_savior_close_enough()
{
	buddy = get_other_player( self );
	use_dist = getdvarint( "player_useradius" );
	dist = use_dist * use_dist;
	
	return distancesquared( self geteye(), level.revive_ent.origin ) <= dist;
}

player_coop_proc_ended()
{
	self endon( "death" );

	flag_waitopen( "coop_revive" );
	self ent_flag_clear( "coop_proc_running" );
	self EnableDeathShield( false );
}

player_coop_set_down_attributes()
{
	self endon( "death" );

	// Use radius increased when someone is down... more like MP distance
	level.default_use_radius = getdvarint( "player_useradius" );
	setsaveddvar( "player_useradius", 128 );

	self.coop_downed = true;
	self.ignoreRandomBulletDamage = true;
	self EnableInvulnerability();
	self ent_flag_set( "coop_downed" );
	self.health = 2;
	self.maxhealth = self.original_maxhealth;
	self.ignoreme = true;

	self DisableUsability();
	self DisableWeaponSwitch();
	self DisableWeapons();

	self thread player_coop_set_down_part1();
}

player_coop_set_original_attributes()
{
	// Use radius decreased to default when someone is revived.
	setsaveddvar( "player_useradius", level.default_use_radius );
	level.default_use_radius = undefined;

	self.ignoreRandomBulletDamage = false;
	self ent_flag_clear( "coop_downed" );
	self.down_part2_proc_ran = undefined;

	// This is done like this because when a guy goes down, he forces the *other*
	// person to turn on the health icon. Since only one guy can be down at a time,
	// we can trust that we only need to reset on the other player.
//	self CreateFriendlyHudIcon_Normal();
	other_player = get_other_player( self );
	other_player delaythread( 0.1, ::CreateFriendlyHudIcon_Normal );

	self player_coop_getup();

	self.health = self.maxhealth;
	self.ignoreme = false;
	self setstance( "stand" );

	self EnableUsability();
	self EnableWeaponSwitch();
	self EnableWeapons();

	wait 1.0;
	self DisableInvulnerability();
	self.coop_downed = undefined;
}

// Could possibly be a useful utility function, but only useful here right now.
check_for_pistol()
{
	AssertEx( IsPlayer( self ), "check_for_pistol() was called on a non-player." );

	weapon_list = self GetWeaponsListPrimaries();
	foreach ( weapon in weapon_list )
	{
		// Need to account for Akimbo weapons?
		if ( WeaponClass( weapon ) == "pistol" )
			return weapon;
	}
		
	return undefined;
}

remove_pistol_if_extra()
{
	AssertEx( IsPlayer( self ), "remove_pistol_if_extra() was called on a non-player." );

	if ( isdefined( self.preincap ) )
	{
		weapon_pistol = self.preincap[ "pistol" ];
		self.preincap[ "left" ]		= self getweaponammoclip( weapon_pistol, "left" );
		self.preincap[ "right" ]	= self getweaponammoclip( weapon_pistol, "right" );
		self.preincap[ "stock" ]	= self getweaponammostock( weapon_pistol );
	}

	self restore_players_weapons( "pre_incap" );

	if ( isdefined( self.preincap ) )
	{
		weapon_pistol = self.preincap[ "pistol" ];
		self SetWeaponAmmoClip( weapon_pistol, self.preincap[ "left" ], "left" );
		self SetWeaponAmmoClip( weapon_pistol, self.preincap[ "right" ], "right" );
		self SetWeaponAmmoStock( weapon_pistol, self.preincap[ "stock" ] );
	}
	
	self.preincap = undefined;
}

player_coop_force_switch_to_pistol()
{
	weapon_pistol = self check_for_pistol();
	if ( isdefined( weapon_pistol ) )
	{
		self.preincap = [];
		self.preincap[ "pistol" ]	= weapon_pistol;
		self.preincap[ "left" ]		= self getweaponammoclip( weapon_pistol, "left" );
		self.preincap[ "right" ]	= self getweaponammoclip( weapon_pistol, "right" );
		self.preincap[ "stock" ]	= self getweaponammostock( weapon_pistol );
	}

	self store_players_weapons( "pre_incap" );
	self takeallweapons();

	if ( !isdefined( self.preincap ) )
	{
		weapon_pistol = "Beretta";
		if ( isdefined( level.coop_incap_weapon ) )
			weapon_pistol = level.coop_incap_weapon;
	}

	self giveWeapon( weapon_pistol );
	if ( isdefined( self.preincap ) )
	{
		self SetWeaponAmmoClip( weapon_pistol, self.preincap[ "left" ], "left" );
		self SetWeaponAmmoClip( weapon_pistol, self.preincap[ "right" ], "right" );
		self SetWeaponAmmoStock( weapon_pistol, self.preincap[ "stock" ] );
	}	

	self SwitchToWeapon( weapon_pistol );
	self EnableWeapons();
}

player_coop_set_down_part1()
{
	self endon( "revived" );

	self.laststand = true;
	wait .3;

	self player_coop_force_switch_to_pistol();

	wait .25;
	self DisableInvulnerability();

	self thread player_coop_down_draw_attention();

	self waittill( "damage" );
	self thread player_coop_set_down_part2();
}

player_coop_set_down_part2()
{
	self.down_part2_proc_ran = true;

	self disableweapons();
	self thread player_dying_effect();

	self.ignoreme = true;
	self.ignoreRandomBulletDamage = true;
	self EnableInvulnerability();
}

player_dying_effect()
{
	self endon( "death" );
	self endon( "revived" );

	//allow this thread to only be run once
	if ( !ent_flag_exist( "coop_dying_effect" ) )
		ent_flag_init( "coop_dying_effect" );
	else if ( ent_flag( "coop_dying_effect" ) )
		return;
	ent_flag_set( "coop_dying_effect" );

	for ( ;; )
	{
		self shellshock( "default", 60 );
		wait ( 60 );
	}
}

player_dying_effect_remove()
{
	if ( ent_flag_exist( "coop_dying_effect" ) )
		ent_flag_clear( "coop_dying_effect" );

	self stopShellShock();
}

player_coop_down_draw_attention()
{
	self endon( "death" );
	self endon( "revived" );
	self endon( "damage" );

	notifyoncommand( "draw_attention", "+attack" );
	self waittill_notify_or_timeout( "draw_attention", 4 );
	self.ignoreme = false;
	self.ignoreRandomBulletDamage = false;
}

player_coop_getup()
{
	self endon( "death" );

	self disableweapons();
	self remove_pistol_if_extra ();
	
	self.laststand = false;
	wait .3;
	//self player_recallweapons();
}

player_coop_kill()
{
	self ent_flag_set( "coop_is_dead" );
	self thread player_dying_effect_remove();

	if ( flag( "coop_fail_when_all_dead" ) )
		flag_wait( "coop_alldowned" );

	self EnableDeathShield( false );
	self DisableInvulnerability();
	self EnableHealthShield( false );
	self.laststand = false;
	waittillframeend;
	level.coop_death = true;
	self kill();
}

player_coop_check_alldowned()
{
	foreach ( player in level.players )
	{
		downed = player ent_flag( "coop_downed" );
		if ( !downed )
			return;
	}

	flag_set( "coop_alldowned" );
}
