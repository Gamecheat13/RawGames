
#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_skipto;
#include maps\_scene;
#include maps\_anim;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


//*****************************************************************************
//*****************************************************************************
// BEARTRAP
//*****************************************************************************
//*****************************************************************************

//******************************************************************************************
// The Beartrap is a grenade - The only way to make it available it to give it to the player
// Then take it away
// Then plac it in the level so you can find it and pick it up
//******************************************************************************************

give_player_beartrap()
{
	level.player GiveWeapon( "beartrap_sp" );
	level.player setactionslot( 1, "weapon", "beartrap_sp" );
	level.player thread maps\angola_2_beartrap::beartrap_watch();

	level thread beartrap_helper_message( 2 );
}


//******************************************************************************************
//******************************************************************************************

beartrap_helper_message( delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	screen_message_create( &"ANGOLA_2_BEARTRAP_HELPER" );
	wait( 4 );
	screen_message_delete();
}


//******************************************************************************************
//******************************************************************************************

// self = player
beartrap_watch()
{
	self endon( "death" );

	level.num_beartrap_catches = 0;
	level.num_beartrap_challenge_kills = 3;		// Needed to complete the challenge
	
	while( 1 )
	{
		self waittill( "grenade_fire", e_grenade, str_weapon_name );
		//self waittill( "weapon_fire", e_grenade, str_weapon_name );
		
		if( str_weapon_name == "beartrap_sp" )
		{
			e_grenade thread beartrap_triggered_think();
		}
	}
}


//*****************************************************************************
//*****************************************************************************

// self = beartrap
beartrap_triggered_think()
{
	//*****************************************************
	// Play the Scene of Planting and Priming the Bear trap
	//*****************************************************

	// Not sure why we need this, but we do
	wait( 0.1 );

	// We can't animate grenades (the beartrap is a grenade), so :-
	// - Create a misc model with the beartrap model
	// - Move it to the beartraps position
	// - Hide the beartrap
	// - Animate the fake beartrap

	//e_trap_model = spawn( "script_model", self.origin );
	//e_trap_model.angles = self.angles;
	//e_trap_model SetModel( "t6_wpn_bear_trap_prop" );
	//e_trap_model.targetname = "beartrap_fake";

	// Hide the beartrap
	//self hide();
	//self thread animate_the_bear_trap();

	// Get a set of unqiue animation names for this beartrap instance
	self maps\angola_2_anim::set_beartrap_anim_names();
	// Animation Scene is aligned to the beartrap
	self.targetname = get_beartrap_targetname_from_scene_name( self.str_anim_name_ai_caught );

	wait( 0.1 );

	// When placed the beartrap is not explosive
	self thread beartrap_explosive_think();


	//*******************************
	// NOTE: Possible Trap Modes
	//		"TRAP_LOOKING_FOR_TARGET"
	//		"TRAP_PULLING_IN_TARGET"
	//		"TRAP_CATCHES TARGET"
	//*******************************

	self.trap_mode = "TRAP_LOOKING_FOR_TARGET";

	while( 1 )
	{
		switch( self.trap_mode )
		{
			case "TRAP_LOOKING_FOR_TARGET":
				self beartrap_looking_for_target();
			break;

			case "TRAP_PULLING_IN_TARGET":
				self beartrap_pulling_in_target();
				if( self.trap_mode != "TRAP_CATCHES_TARGET" )
				{
					self.trap_mode = "TRAP_LOOKING_FOR_TARGET";
				}
			break;

			case "TRAP_CATCHES_TARGET":
				self beartrap_catches_targes();
				return;
			break;
		}

		wait( 0.01 );
	}
}


//*****************************************************************************
// Attract an enemy AI to the Bear Trap
//*****************************************************************************

// self = beartrap
beartrap_looking_for_target()
{
	//IPrintLnBold( "Trap Ready to Look for a Victim" );

//does_player_have_mortar()

	self.trap_target = undefined;

	can_see_trap_dist = 1000;		// 700
	can_see_trap_dot = 0.75;

	closest_dist = 999999;
	closest_ai = undefined;
	while( !IsDefined(closest_ai) )
	{
		a_enemies = GetAiArray( "axis" );
		foreach( ai_enemy in a_enemies )
		{
			dist = self beartrap_search_for_ai_victim( ai_enemy, can_see_trap_dist, can_see_trap_dot );
			if( (dist > 0) && (dist < closest_dist) )
			{
				closest_ai = ai_enemy;
				closest_dist = dist;
			}
		}

		if( !IsDefined(closest_ai) )
		{
			delay = randomfloatrange( 0.1, 0.2 );
			wait( delay );
		}
	}

	self.trap_target = closest_ai;
	self.trap_target.investigating_bear_trap = true;
		
	self.trap_target notify( "kill_patrol" );

	self.trap_mode = "TRAP_PULLING_IN_TARGET";
}


//*****************************************************************************
// Get the Ai to run towards the trap 
//	self.trap_target = ai attracted to the trap
//*****************************************************************************

// self = beartrap
beartrap_pulling_in_target()
{
	self.trap_target endon( "death" );

	//IPrintLnBold( "Trap Attracting Someone" );

	wait( 0.1 );
	self.trap_target setgoalpos( self.origin );
	self.trap_target.goalradius = 42;
	self.trap_target waittill( "goal" );

	// Trigger the Trap
	self.trap_target thread ai_caught_in_beartrap( self );
	self.trap_target.using_beartrap = true;
	
	level notify( "beartrap_triggered" );

	self.trap_mode = "TRAP_CATCHES_TARGET";

	return;
}


//*****************************************************************************
// Call over a few enemy Ai suckers
//*****************************************************************************

// self = beartrap
beartrap_catches_targes()
{
	if( maps\angola_stealth::is_player_in_stealth_mode() )
	{
		//IPrintLnBold( "Calling other AI guards Over" );

		wait( 0.01 );

		level thread maps\angola_stealth::patrol_alerted_find_player_quickly( 20, 20 );

		// Pull in troups to investigate the wounded guy
		ai_goto_trap_radius = 2400;
		a_enemies = GetAiArray( "axis" );
		foreach( ai_enemy in a_enemies )
		{
			if( IsDefined( ai_enemy ) && IsAlive( ai_enemy ) )
			{
				if( !maps\angola_2_util::ent_is_launcher(ai_enemy) && !IsDefined(ai_enemy.using_beartrap) 
																   && !IsDefined(ai_enemy.investigating_bear_trap) )
				{
					if( Distance2D( self.origin, ai_enemy.origin ) < ai_goto_trap_radius )
					{
						ai_enemy thread second_wave_investigate_beartrap( self );
					}
				}
			}
		}
	}
}


//*****************************************************************************
//*****************************************************************************

// self = ai
ai_caught_in_beartrap( e_beartrap )
{
	self endon( "death" );

	//IPrintLnBold( "Sucker at Trap" );
	//self.a.nodeath = true;	
	add_generic_ai_to_scene( self, e_beartrap.str_anim_name_ai_caught );
	run_scene( e_beartrap.str_anim_name_ai_caught );

	//****************************************************************
	// The beartrap keeps the victim locked in an a looping ancle lock
	//****************************************************************

	add_generic_ai_to_scene( self, e_beartrap.str_anim_name_ai_caught_loop );
	level thread run_scene( e_beartrap.str_anim_name_ai_caught_loop );

	wait( 4 );

	// If its an explosive beartrap then BOOM!
	if( e_beartrap.beartrap_exlposive == true )
	{
		playfx( level._effect["def_explosion"], e_beartrap.origin );
		//SOUND - Shawn J
		PlaySoundAtPosition ("exp_beartrap_dirt", e_beartrap.origin );
		
		self thread ai_beartrap_explosive_death( e_beartrap );
		level thread ai_beartrap_explosive_radius( e_beartrap, 400 );	// 300
		
		level thread beartrap_alert_ai_to_player_soon( 1 );
	}
	else
	{
		level.num_beartrap_catches = level.num_beartrap_catches + 1;
		self dodamage( self.health+100, self.origin );
		level thread beartrap_alert_ai_to_player_soon( 6 );
	}
}


//*****************************************************************************
//*****************************************************************************

beartrap_alert_ai_to_player_soon( delay )
{
	level endon( "player_position_located" );
	wait( delay );
	level notify( "player_position_located" );
}


//*****************************************************************************
// If the AI can see the trap it returns dist, so we can use the closest if
//    multiple ai can see it
//*****************************************************************************

// self = beartrap
beartrap_search_for_ai_victim( ai_enemy, in_range_distance, vis_dot )
{
	// If the AI is already investigating a bear trap, inore him
	if( IsDefined(ai_enemy.investigating_bear_trap) )
	{
		return( 0 );
	}
	
	// Is the Ai in range of the trap?
	dist_to_trap = distance( ai_enemy.origin, self.origin );
	if( dist_to_trap < in_range_distance )
	{
		// Is the AI looking at the trap?
		v_ai_forward = anglestoforward( ai_enemy.angles );
		v_dir_to_trap = VectorNormalize( self.origin - ai_enemy.origin );
		dot = vectordot( v_ai_forward, v_dir_to_trap );
		if( dot > vis_dot )
		{
/*
			// Do a ray cast to see if we can see the trap
			up = anglestoup( (0, 90, 0) );
			v_start = self.origin + (up * 30);
			v_end = ai_enemy GetEye();
			trace = BulletTrace( v_start, v_end, false, self );
			if( trace["fraction"] == 1 )
*/
			{
				return( dist_to_trap );
			}
		}
	}

	return( 0 );
}


//*****************************************************************************
// self = enemy ai
//*****************************************************************************

second_wave_investigate_beartrap( e_trap )
{
	self endon( "death" );
	e_trap endon( "death" );

	ai_reached_trap_radius = 42*2;

	// Turn off Patrol
	level notify( "patrol_dont_check_player_fire" );
	wait( 0.2 );

	// Use a mix of casual and urgent run
	rval= randomfloatrange( 0, 100 );
	if( rval < 100 )	// always use the urgent run
	{
		self clear_run_anim();
	}

	// Run to the traps location
	self setgoalpos( e_trap.origin );
	self.goalradius = ai_reached_trap_radius;

	self waittill( "goal" );

	//IPrintLnBold( "Reached TRAP" );

	// Keeps them close to the trap
	self.goalradius = 512;

	// Use a look around animation
	self.animname = "stand_and_look_around";
	self set_run_anim( "stand" );

	// Bored at trap, discover player time
	at_trap_find_player_wait = 5;
	wait( at_trap_find_player_wait );
	level notify( "player_position_located" );
}


//*****************************************************************************
//*****************************************************************************

// self = bear trap (grende)

animate_the_bear_trap()
{

/*

// sb42

	wait( 3 );
	IPrintLnBold( "Swapping bear trap model" );
	
	self hide();

	wait( 1 );

	e_fake_beartrap = Spawn( "script_model", self.origin );
	e_fake_beartrap.angles = self.angles;
	e_fake_beartrap setModel( "t6_wpn_bear_trap_world" );
	e_fake_beartrap.targetname = "fake_beartrap";

	wait( 3 );


	IPrintLnBold( "About to play IDLE OPEN" );
	wait( 1 );
	run_scene( "beartrap_idle_open" );
*/

}


//*****************************************************************************
//*****************************************************************************
// Prime the Beartrap with a Mortor
//*****************************************************************************
//*****************************************************************************

beartrap_explosive_think()
{
	self endon( "death" );

	self.beartrap_exlposive = false;

	message = 0;


	//*******************************************************************
	// Wait for the player to prime the beartrap with an explosive mortar
	//*******************************************************************

	while( 1 )
	{
		in_message_range = 0;

		// Is the player close to the beartrap
		dist = distance( self.origin, level.player.origin );
		if( dist < 80 )
		{
			// Is the player looking at the beartrap
			forward = anglestoforward( level.player.angles );
			dir = vectornormalize( self.origin - level.player.origin );
			dot = vectordot( forward, dir );
			if( dot >= 0.0 )
			{
				in_message_range = 1;
				if( !message )
				{
					screen_message_create( &"ANGOLA_2_PRIME_BEARTRAP_WITH_MORTAR" );
					message = 1;
				}
			}
		}

		// If not if message range, make sure its been deleted
		if( (!in_message_range) && (message) )
		{
			screen_message_delete();
			message = 0;
		}

		// Has the user pressed the prime trap button?
		if( (message) && ( level.player useButtonPressed() ) )
		{
			message = 0;
			screen_message_delete();
			run_scene( self.str_anim_name_add_mortar );
			self.beartrap_exlposive = true;
			break;
		}

		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************

// self = level
ai_beartrap_explosive_radius( e_beartrap, radius )
{
	a_ai = GetAIArray( "axis" );
	if( IsDefined(a_ai) )
	{
		for( i=0; i<a_ai.size; i++ )
		{
			e_ent = a_ai[ i ];
			dist = distance( e_beartrap.origin, e_ent.origin );
			if( dist < radius )
			{
				e_ent thread ai_beartrap_explosive_death( e_beartrap );
			}
		}
	}
}

// self = ai
ai_beartrap_explosive_death( e_beartrap )
{
	self endon( "death" );

	if ( !IsDefined(self.alreadyLaunched) )
	{
		self.a.nodeath = true;
		self.alreadyLaunched = true;
		self StartRagdoll( true );

		x = randomintrange( -30, 30 );
		y = randomintrange( -30, 30 );
		v_launch = ( x, y, 100 );
		vectornormalize( v_launch );
		
		v_launch = v_launch * 1.5;

		self LaunchRagdoll( v_launch, "J_SpineUpper" );

		level.num_beartrap_catches = level.num_beartrap_catches + 1;

		wait( 2 );

		self dodamage( self.health+100, self.origin );
	}
}


//*****************************************************************************
//*****************************************************************************

// self = player
does_player_have_mortar()
{

/*
	// Does the player have a mortar

	a_weapon_list = self GetWeaponsList();
		
	for( i=0; i<a_weapon_list.size; i++ )
	{
		str_class = WeaponClass( a_weapon_list[ i ] );
	
		IPrintLnBold( str_class );
				
//		if ( str_class == "pistol" )
//		{
//			self SwitchToWeapon( a_weapon_list[ i ] );
//		}
	}
*/

}



