#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;


    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                                                      
                                                                                                             	     	                                                                                                                                                                

#precache( "client_fx", "zombie/fx_margwa_teleport_zod_zmb" );
#precache( "client_fx", "zombie/fx_margwa_teleport_travel_zod_zmb" );
#precache( "client_fx", "zombie/fx_margwa_teleport_tell_zod_zmb" );
#precache( "client_fx", "zombie/fx_margwa_teleport_intro_zod_zmb" );
#precache( "client_fx", "zombie/fx_margwa_head_shot_zod_zmb" );
#precache( "client_fx", "zombie/fx_margwa_roar_zod_zmb" );

#using_animtree( "generic" );

function autoexec main()
{
	clientfield::register( "actor", "margwa_head_left", 1, 2, "int", &MargwaClientUtils::margwaHeadLeftCallback, !true, !true );
	clientfield::register( "actor", "margwa_head_mid", 1, 2, "int", &MargwaClientUtils::margwaHeadMidCallback, !true, !true );
	clientfield::register( "actor", "margwa_head_right", 1, 2, "int", &MargwaClientUtils::margwaHeadRightCallback, !true, !true );
	clientfield::register( "actor", "margwa_fx_in", 1, 1, "counter", &MargwaClientUtils::margwaFxInCallback, !true, !true );
	clientfield::register( "actor", "margwa_fx_out", 1, 1, "counter", &MargwaClientUtils::margwaFxOutCallback, !true, !true );
	clientfield::register( "actor", "margwa_fx_spawn", 1, 1, "counter", &MargwaClientUtils::margwaFxSpawnCallback, !true, !true );
	clientfield::register( "actor", "margwa_smash", 1, 1, "counter", &MargwaClientUtils::margwaSmashCallback, !true, !true );
	clientfield::register( "actor", "margwa_head_left_hit", 1, 1, "counter", &MargwaClientUtils::margwaLeftHitCallback, !true, !true );
	clientfield::register( "actor", "margwa_head_mid_hit", 1, 1, "counter", &MargwaClientUtils::margwaMidHitCallback, !true, !true );
	clientfield::register( "actor", "margwa_head_right_hit", 1, 1, "counter", &MargwaClientUtils::margwaRightHitCallback, !true, !true );

	clientfield::register( "actor", "margwa_head_killed", 1, 2, "int", &MargwaClientUtils::margwaHeadKilledCallback, !true, !true );
	clientfield::register( "actor", "margwa_jaw", 1, 6, "int", &MargwaClientUtils::margwaJawCallback, !true, !true );

	clientfield::register( "toplayer", "margwa_head_explosion", 1, 1, "counter", &MargwaClientUtils::margwaHeadExplosion, !true, !true );
	clientfield::register( "scriptmover", "margwa_fx_travel", 1, 1, "int", &MargwaClientUtils::margwaFxTravelCallback, !true, !true );
	clientfield::register( "scriptmover", "margwa_fx_travel_tell", 1, 1, "int", &MargwaClientUtils::margwaFxTravelTellCallback, !true, !true );

	ai::add_archetype_spawn_function( "margwa", &MargwaClientUtils::margwaSpawn );

	level._jaw = [];
	level._jaw[ 1 ] = "idle_1";
	level._jaw[ 3 ] = "idle_pain_head_l_explode";
	level._jaw[ 4 ] = "idle_pain_head_m_explode";
	level._jaw[ 5 ] = "idle_pain_head_r_explode";
	level._jaw[ 6 ] = "react_stun";
	level._jaw[ 8 ] = "react_idgun";
	level._jaw[ 9 ] = "react_idgun_pack";
	level._jaw[ 7 ] = "run_charge_f";
	level._jaw[ 13 ] = "run_f";
	level._jaw[ 14 ] = "smash_attack_1";
	level._jaw[ 15 ] = "swipe";
	level._jaw[ 16 ] = "swipe_player";
	level._jaw[ 17 ] = "teleport_in";
	level._jaw[ 18 ] = "teleport_out";
	level._jaw[ 19 ] = "trv_jump_across_256";
	level._jaw[ 20 ] = "trv_jump_down_128";
	level._jaw[ 21 ] = "trv_jump_down_36";
	level._jaw[ 22 ] = "trv_jump_down_96";
	level._jaw[ 23 ] = "trv_jump_up_128";
	level._jaw[ 24 ] = "trv_jump_up_36";
	level._jaw[ 25 ] = "trv_jump_up_96";
}

function autoexec precache()
{
	level._effect[ "fx_margwa_teleport_zod_zmb" ] = "zombie/fx_margwa_teleport_zod_zmb";
	level._effect[ "fx_margwa_teleport_travel_zod_zmb" ] = "zombie/fx_margwa_teleport_travel_zod_zmb";
	level._effect[ "fx_margwa_teleport_tell_zod_zmb" ] = "zombie/fx_margwa_teleport_tell_zod_zmb";
	level._effect[ "fx_margwa_teleport_intro_zod_zmb" ] = "zombie/fx_margwa_teleport_intro_zod_zmb";
	level._effect[ "fx_margwa_head_shot_zod_zmb" ] = "zombie/fx_margwa_head_shot_zod_zmb";
	level._effect[ "fx_margwa_roar_zod_zmb" ] = "zombie/fx_margwa_roar_zod_zmb";
}

#namespace MargwaClientUtils;

function private margwaSpawn( localClientNum )
{
	self SetAnim( "ai_margwa_head_l_closed_add", 1.0, 0.2, 1.0 );
	self SetAnim( "ai_margwa_head_m_closed_add", 1.0, 0.2, 1.0 );
	self SetAnim( "ai_margwa_head_r_closed_add", 1.0, 0.2, 1.0 );

	for ( i = 1; i <= 7; i++ )
	{
		leftTentacle = "ai_margwa_tentacle_l_0" + i;
		rightTentacle = "ai_margwa_tentacle_r_0" + i;

		self SetAnim( leftTentacle, 1.0, 0.2, 1.0 );
		self SetAnim( rightTentacle, 1.0, 0.2, 1.0 );
	}

	level._footstepCBFuncs[self.archetype] = &margwaProcessFootstep;

	self.head = [];
	self.head[ 1 ] = SpawnStruct();
	self.head[ 1 ].index = 1;
	self.head[ 1 ].prevHeadAnim = "ai_margwa_head_l_closed_add";
	self.head[ 1 ].jawBase = "ai_margwa_jaw_l_";

	self.head[ 2 ] = SpawnStruct();
	self.head[ 2 ].index = 2;
	self.head[ 2 ].prevHeadAnim = "ai_margwa_head_m_closed_add";
	self.head[ 2 ].jawBase = "ai_margwa_jaw_m_";

	self.head[ 3 ] = SpawnStruct();
	self.head[ 3 ].index = 3;
	self.head[ 3 ].prevHeadAnim = "ai_margwa_head_r_closed_add";
	self.head[ 3 ].jawBase = "ai_margwa_jaw_r_";
}

function private margwaHeadLeftCallback( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	if ( IsDefined( self.leftGlowFx ) )
	{
		StopFx( localClientNum, self.leftGlowFx );
	}

	switch ( newValue )
	{
	case 1:
		self.head[ 1 ].prevHeadAnim = "ai_margwa_head_l_open_add";
		self SetAnim( "ai_margwa_head_l_open_add", 1.0, 0.1, 1.0 );
		self ClearAnim( "ai_margwa_head_l_closed_add", 0.1 );
		self.leftGlowFx = PlayFxOnTag( localClientNum, level._effect[ "fx_margwa_roar_zod_zmb" ], self, "tag_head_left" );
		break;

	case 2:
		self.head[ 1 ].prevHeadAnim = "ai_margwa_head_l_closed_add";
		self SetAnim( "ai_margwa_head_l_closed_add", 1.0, 0.1, 1.0 );
		self ClearAnim( "ai_margwa_head_l_open_add", 0.1 );
		self ClearAnim( "ai_margwa_head_l_smash_attack_1", 0.1 );
		break;

	case 3:
		self.head[ 1 ].prevHeadAnim = "ai_margwa_head_l_smash_attack_1";
		self ClearAnim( "ai_margwa_head_l_open_add", 0.1 );
		self ClearAnim( "ai_margwa_head_l_closed_add", 0.1 );
		self SetAnimRestart( "ai_margwa_head_l_smash_attack_1", 1, 0.1, 1);
		self.leftGlowFx = PlayFxOnTag( localClientNum, level._effect[ "fx_margwa_roar_zod_zmb" ], self, "tag_head_left" );
		self thread margwaStopSmashFx( localClientNum );
		break;
	}
}

function private margwaHeadMidCallback( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	if ( IsDefined( self.midGlowFx ) )
	{
		StopFx( localClientNum, self.midGlowFx );
	}

	switch ( newValue )
	{
	case 1:
		self SetAnim( "ai_margwa_head_m_open_add", 1.0, 0.1, 1.0 );
		self ClearAnim( "ai_margwa_head_m_closed_add", 0.1 );
		self.midGlowFx = PlayFxOnTag( localClientNum, level._effect[ "fx_margwa_roar_zod_zmb" ], self, "tag_head_mid" );
		break;

	case 2:
		self SetAnim( "ai_margwa_head_m_closed_add", 1.0, 0.1, 1.0 );
		self ClearAnim( "ai_margwa_head_m_open_add", 0.1 );
		self ClearAnim( "ai_margwa_head_m_smash_attack_1", 0.1 );
		break;

	case 3:
		self ClearAnim( "ai_margwa_head_m_open_add", 0.1 );
		self ClearAnim( "ai_margwa_head_m_closed_add", 0.1 );
		self SetAnimRestart( "ai_margwa_head_m_smash_attack_1", 1, 0.1, 1);
		self.midGlowFx = PlayFxOnTag( localClientNum, level._effect[ "fx_margwa_roar_zod_zmb" ], self, "tag_head_mid" );
		self thread margwaStopSmashFx( localClientNum );
		break;
	}
}

function private margwaHeadRightCallback( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	if ( IsDefined( self.rightGlowFx ) )
	{
		StopFx( localClientNum, self.rightGlowFx );
	}

	switch ( newValue )
	{
	case 1:
		self SetAnim( "ai_margwa_head_r_open_add", 1.0, 0.1, 1.0 );
		self ClearAnim( "ai_margwa_head_r_closed_add", 0.1 );
		self.rightGlowFx = PlayFxOnTag( localClientNum, level._effect[ "fx_margwa_roar_zod_zmb" ], self, "tag_head_right" );
		break;

	case 2:
		self SetAnim( "ai_margwa_head_r_closed_add", 1.0, 0.1, 1.0 );
		self ClearAnim( "ai_margwa_head_r_open_add", 0.1 );
		self ClearAnim( "ai_margwa_head_r_smash_attack_1", 0.1 );
		break;

	case 3:
		self ClearAnim( "ai_margwa_head_r_open_add", 0.1 );
		self ClearAnim( "ai_margwa_head_r_closed_add", 0.1 );
		self SetAnimRestart( "ai_margwa_head_r_smash_attack_1", 1, 0.1, 1);
		self.rightGlowFx = PlayFxOnTag( localClientNum, level._effect[ "fx_margwa_roar_zod_zmb" ], self, "tag_head_right" );
		self thread margwaStopSmashFx( localClientNum );
		break;
	}
}

function private margwaStopSmashFx( localClientNum )
{
	self endon( "entityshutdown" );

	wait( 0.6 );

	if ( IsDefined( self.leftGlowFx ) )
	{
		StopFx( localClientNum, self.leftGlowFx );
	}

	if ( IsDefined( self.midGlowFx ) )
	{
		StopFx( localClientNum, self.midGlowFx );
	}

	if ( IsDefined( self.rightGlowFx ) )
	{
		StopFx( localClientNum, self.rightGlowFx );
	}
}

function private margwaFxInCallback( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	if ( newValue )
	{
		self.teleportFxIn = PlayFx( localClientNum, level._effect[ "fx_margwa_teleport_zod_zmb" ], self GetTagOrigin( "j_spine_1" ) );
	}
}

function private margwaFxOutCallback( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	if ( newValue )
	{
		tagPos = self GetTagOrigin( "j_spine_1" );
		self.teleportFxOut = PlayFx( localClientNum, level._effect[ "fx_margwa_teleport_zod_zmb" ], tagPos );
	}
}

function private margwaFxTravelCallback( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	switch ( newValue )
	{
	case 0:
		DeleteFx( localClientNum, self.travelerFx );
		break;

	case 1:
		self.travelerFx = PlayFxOnTag( localClientNum, level._effect[ "fx_margwa_teleport_travel_zod_zmb" ], self, "tag_origin" );
		break;
	}
}

function private margwaFxTravelTellCallback( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	switch ( newValue )
	{
	case 0:
		DeleteFx( localClientNum, self.travelerTellFx );
		self notify( "stop_margwaTravelTell" );
		break;

	case 1:
		self.travelerTellFx = PlayFxOnTag( localClientNum, level._effect[ "fx_margwa_teleport_tell_zod_zmb" ], self, "tag_origin" );
		self thread margwaTravelTellUpdate( localClientNum );
		break;
	}
}

function private margwaTravelTellUpdate( localClientNum )
{
	self notify( "stop_margwaTravelTell" );
	self endon( "stop_margwaTravelTell" );
	self endon( "entityshutdown" );

	player = GetLocalPlayer( localClientNum );

	while ( 1 )
	{
		dist_sq = DistanceSquared( player.origin, self.origin );
		if ( dist_sq < 1000 * 1000 )
		{
			player PlayRumbleOnEntity( localClientNum, "tank_rumble" );
		}

		wait( 0.05 );
	}
}


function private margwaFxSpawnCallback( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	if ( newValue )
	{
		self.spawnFx = PlayFx( localClientNum, level._effect[ "fx_margwa_teleport_intro_zod_zmb" ], self GetTagOrigin( "j_spine_1" ) );
		playsound(0, "zmb_margwa_spawn", self GetTagOrigin( "j_spine_1" ) );
	}
}

function private margwaHeadExplosion( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	if ( newValue )
	{
		self postfx::PlayPostfxBundle( "pstfx_parasite_dmg" );
	}
}

function margwaProcessFootstep( localClientNum, pos, surface, notetrack, bone )
{
	e_player = GetLocalPlayer( localClientNum );
	n_dist = DistanceSquared( pos, e_player.origin );
	n_margwa_dist = ( GetDvarInt( "scr_margwa_footstep_eq_radius", 1000) * GetDvarInt( "scr_margwa_footstep_eq_radius", 1000) );
	if(n_margwa_dist>0)
		n_scale = ( n_margwa_dist - n_dist ) / n_margwa_dist;
	else
		return;
	
	if( n_scale > 1 || n_scale < 0 ) return;
		
	n_scale = n_scale * 0.25;
	if( n_scale <= 0.01 ) return;
	e_player Earthquake( n_scale, 0.1, pos, n_dist );
	
	if( n_scale <= 0.25 && n_scale > 0.2 )
	{
		e_player PlayRumbleOnEntity( localClientNum, "shotgun_fire" );
	}
	
	else if( n_scale <= 0.2 && n_scale > 0.1 )
	{
		e_player PlayRumbleOnEntity( localClientNum, "damage_heavy" );
	}
	else
	{
		e_player PlayRumbleOnEntity( localClientNum, "reload_small" );
	}
}

function private margwaSmashCallback( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	if ( newValue )
	{
		e_player = GetLocalPlayer( localClientNum );

		smashPos = self.origin + VectorScale( AnglesToForward( self.angles ), 60 );
		distSq = DistanceSquared( smashPos, e_player.origin );
		if ( distSq < 144 * 144 )
		{
			e_player Earthquake( 0.7, 0.25, e_player.origin, 3000 );
			e_player PlayRumbleOnEntity( localClientNum, "shotgun_fire" );
		}
		else if ( distSq < 192 * 192 )
		{
			e_player Earthquake( 0.7, 0.25, e_player.origin, 1500 );
			e_player PlayRumbleOnEntity( localClientNum, "damage_heavy" );
		}
	}
}

function private margwaLeftHitCallback( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	if ( newValue )
	{
		self.leftHitFx = PlayFxOnTag( localClientNum, level._effect[ "fx_margwa_head_shot_zod_zmb" ], self, "tag_head_left" );
	}
}

function private margwaMidHitCallback( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	if ( newValue )
	{
		self.midHitFx = PlayFxOnTag( localClientNum, level._effect[ "fx_margwa_head_shot_zod_zmb" ], self, "tag_head_mid" );
	}
}

function private margwaRightHitCallback( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	if ( newValue )
	{
		self.rightHitFx = PlayFxOnTag( localClientNum, level._effect[ "fx_margwa_head_shot_zod_zmb" ], self, "tag_head_right" );
	}
}

function private margwaHeadKilledCallback( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	if ( newValue )
	{
		self.head[ newValue ].killed = true;
	}
}

function private margwaJawCallback( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	if ( newValue )
	{
		foreach( head in self.head )
		{
			if ( ( isdefined( head.killed ) && head.killed ) )
			{
				if ( IsDefined( head.prevJawAnim ) )
				{
					self ClearAnim( head.prevJawAnim, 0.2 );
				}

				if ( IsDefined( head.prevHeadAnim ) )
				{
					self ClearAnim( head.prevHeadAnim, 0.1 );
				}
				
				jawAnim = head.jawBase + level._jaw[ newValue ];
				head.prevJawAnim = jawAnim;

				self SetAnim( jawAnim, 1.0, 0.2, 1.0 );
			}
		}
	}
}


