// _zm_ai_faller.gsc
// Common location for faller logic

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

#define DEFAULT_DIST_SQ_VISIBLE		( 1000 * 1000 )
#define FALLER_DIST_SQ_VISIBLE		( 1500 * 1500 )

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

zombie_faller_delete()
{
	level.zombie_total++;
	self maps\mp\zombies\_zm_spawner::reset_attack_spot();
	if ( IsDefined( self.zombie_faller_location ) )
	{
		self.zombie_faller_location.is_enabled = true;
		self.zombie_faller_location = undefined;
	}
	self Delete();
}

faller_script_parameters()
{
	if ( IsDefined( self.script_parameters ) )
	{
		parms = strtok( self.script_parameters, ";" );
		if ( IsDefined( parms ) && parms.size > 0 )
		{
			for ( i = 0; i < parms.size; i++ )
			{
				if ( parms[i] == "drop_now" )
				{
					self.drop_now = true;
				}
				//Drop if zone is not occupied
				if ( parms[i] == "drop_not_occupied" )
				{
					self.drop_not_occupied = true;
				}
			}
		}
	}
}

setup_deathfunc()
{
	self endon( "death" );

	while ( !is_true( self.zombie_init_done ) )
	{
		wait_network_frame();
	}

	// rsh040711 - fixed faller deaths
	self.deathFunction = ::zombie_fall_death_func;
}

do_zombie_fall(spot) 
{
	self endon("death");

	self thread setup_deathfunc();

	self.no_powerups = true;
	self.in_the_ceiling = true;

	self.anchor = spawn("script_origin", self.origin);
	self.anchor.angles = self.angles;
	self linkto(self.anchor);

	self.zombie_faller_location = spot;
	//NOTE: multiple zombie fallers could be waiting in the same spot now, need to have spawners detect this 
	//		and not use the spot again until the previous zombie has died or dropped down
	self.zombie_faller_location.is_enabled = false;
	self.zombie_faller_location faller_script_parameters();

	if( !isDefined( spot.angles ) )
	{
		spot.angles = (0, 0, 0);
	}

	anim_org = spot.origin;
	anim_ang = spot.angles;

	self Ghost();
	self.anchor moveto(anim_org, .05);
	self.anchor waittill("movedone");

	// face goal
	target_org = get_desired_origin();
	if (IsDefined(target_org))
	{
		anim_ang = VectorToAngles(target_org - self.origin);
		self.anchor RotateTo((0, anim_ang[1], 0), .05);
		self.anchor waittill("rotatedone");
	}

	self unlink();
	if(isDefined(self.anchor))
	{
		self.anchor delete();
	}
	self thread maps\mp\zombies\_zm_spawner::hide_pop();	
	
	self thread zombie_fall_death(spot);
	self thread zombie_fall_fx(spot);

	self thread zombie_faller_death_wait();

	self thread zombie_faller_do_fall();

	self.no_powerups = false;
	self.in_the_ceiling = false;
	self notify("risen", spot.script_string );		
}	

zombie_faller_do_fall()
{
	self endon("death");
	
	// first play the emerge, then the fall anim
	self AnimScripted( self.origin, self.zombie_faller_location.angles, "zm_faller_emerge" );
	self maps\mp\animscripts\zm_shared::DoNoteTracks( "emerge_anim", ::handle_fall_notetracks, self.zombie_faller_location );

	//NOTE: now we don't fall until we've attacked at least once from the ceiling
	self.zombie_faller_wait_start = GetTime();
	self.zombie_faller_should_drop = false;
	self thread zombie_fall_wait();
	self thread zombie_faller_watch_all_players();
	while ( !self.zombie_faller_should_drop ) 
	{
		if ( self zombie_fall_should_attack(self.zombie_faller_location) )
		{
			self AnimScripted( self.origin, self.zombie_faller_location.angles, "zm_faller_attack" );
			self maps\mp\animscripts\zm_shared::DoNoteTracks( "attack_anim", ::handle_fall_notetracks, self.zombie_faller_location );
			//50/50 chance that we'll stay up here and attack again or drop down
			if ( !(self zombie_faller_always_drop()) && randomfloat(1) > 0.5 )
			{
				//NOTE: if we *can* attack, should we actually stay up here until we can't anymore?
				self.zombie_faller_should_drop = true;
			}
		}
		else
		{
			if ( (self zombie_faller_always_drop()) )
			{
				//drop as soon as we have nobody to attack!
				self.zombie_faller_should_drop = true;
				break;
			}
			//otherwise, wait to attack
			else if ( GetTime() >= self.zombie_faller_wait_start + 20000 )
			{
				//we've been hanging here for 20 seconds, go ahead and drop
				//IPrintLnBold("zombie faller waited too long, dropping");
				self.zombie_faller_should_drop = true;
				break;
			}
			else if ( self zombie_faller_drop_not_occupied() )
			{
				self.zombie_faller_should_drop = true;
				break;
			}
			else
			{
				//NOTE: instead of playing a looping idle, they just flail and attack over and over
				self AnimScripted( self.origin, self.zombie_faller_location.angles, "zm_faller_attack" );
				self maps\mp\animscripts\zm_shared::DoNoteTracks( "attack_anim", ::handle_fall_notetracks, self.zombie_faller_location );
			}
		}
	}
	
	self notify("falling");
	//now the fall location (spot) can be used by another zombie faller again
	spot = self.zombie_faller_location;
	self zombie_faller_enable_location();
	
	self AnimScripted( self.origin, spot.angles, "zm_faller_fall" );
	self maps\mp\animscripts\zm_shared::DoNoteTracks( "fall_anim", ::handle_fall_notetracks, spot );

	// rsh040711 - set the death func back to normal
	self.deathFunction = maps\mp\zombies\_zm_spawner::zombie_death_animscript;

	self notify("fall_anim_finished");
	spot notify("stop_zombie_fall_fx");

	//play fall loop
	self StopAnimScripted();

	// Get Z distance 
	landAnimDelta = 15; //GetMoveDelta( landAnim, 0, 1 )[2];//delta in the anim doesn't seem to reflect actual distance to ground correctly
	ground_pos = groundpos_ignore_water_new( self.origin );
	//draw_arrow_time( self.origin, ground_pos, (1, 1, 0), 10 );
	physDist = self.origin[2] - ground_pos[2] + landAnimDelta;
	
	if ( physDist > 0 )
	{
		//high enough above the ground to play some of the falling loop before we can play the land
		self animcustom( ::zombie_fall_loop );
		self waittill("faller_on_ground");

		//play land
		self animcustom( ::zombie_land );
		self waittill( "zombie_land_done" );
	}
	
	self.in_the_ceiling = false;
	self traverseMode( "gravity" );
	
	self.no_powerups = false;
}

zombie_fall_loop()
{
	self endon("death");
	
	self SetAnimStateFromASD( "zm_faller_fall_loop" );
	
	while(1)
	{
		ground_pos = groundpos_ignore_water_new( self.origin );
		if( self.origin[2] - ground_pos[2] < 20)
		{
			self notify("faller_on_ground");
			break;
		}
		wait .05;
	}
}

zombie_land()
{
	self SetAnimStateFromASD( "zm_faller_land" );
	maps\mp\animscripts\zm_shared::DoNoteTracks( "land_anim" );

	self notify( "zombie_land_done" );
}


zombie_faller_always_drop()
{
	if ( is_true( self.zombie_faller_location.drop_now ) )
	{
		return true;
	}
	return false;
}

zombie_faller_drop_not_occupied()
{
	if ( is_true(self.zombie_faller_location.drop_not_occupied) )
	{
		if( isDefined(self.zone_name) && isDefined(level.zones[ self.zone_name ]) )
		{
			return !level.zones[ self.zone_name ].is_occupied;
		}
	}
	return false;
}

//Watchs for players standing in the general area
zombie_faller_watch_all_players()
{
	players = get_players();
	for(i=0; i<players.size; i++)
	{
		self thread zombie_faller_watch_player(players[i]);
	}
}

zombie_faller_watch_player(player)
{
	self endon("falling");
	self endon("death");
	player endon("disconnect");
	
	
	range = 200;
	rangeSqr = range*range;
	
	timer = 5000; //5 seconds
	
	inRange = false;
	inRangeTime = 0;
	
	//Used to detect player passing under zombie
	closeRange = 60;
	closeRangeSqr = closeRange*closeRange;
	dirToPlayerEnter = (0,0,0);
	inCloseRange = false;
	
	while(1)
	{
		//Watch for standing in general area
		distSqr = distance2dsquared(self.origin, player.origin);
		if(distSqr < rangeSqr)
		{
			if(inRange)
			{
				if(inRangeTime+timer < GetTime())
				{
					self.zombie_faller_should_drop = true;
					break;
				}
			}
			else
			{
				inRange = true;
				inRangeTime = GetTime();
			}
		}
		else
		{
			inRange = false;
		}
		
		//Watch for pass under
		if(distSqr<closeRangeSqr)
		{
			//Just entered range
			if(!inCloseRange)
			{
				dirToPlayerEnter = player.origin - self.origin;
				dirToPlayerEnter = (dirToPlayerEnter[0], dirToPlayerEnter[1], 0.0);
				dirToPlayerEnter = vectornormalize(dirToPlayerEnter);
			}
			
			inCloseRange = true;
		}
		else
		{
			//Just exited range
			if(inCloseRange)
			{
				dirToPlayerExit = player.origin - self.origin;
				dirToPlayerExit = (dirToPlayerExit[0], dirToPlayerExit[1], 0.0);
				dirToPlayerExit = vectornormalize(dirToPlayerExit);
				
				if(vectordot(dirToPlayerEnter, dirToPlayerExit) < 0)
				{
					self.zombie_faller_should_drop = true;
					break;
				}
			}
			
			inCloseRange = false;
		}
		
		wait .1;
	}
}

zombie_fall_wait()
{
	self endon("falling");
	self endon("death");
	
	if ( IsDefined( self.zone_name ) )
	{
		if ( IsDefined(level.zones) && IsDefined(level.zones[ self.zone_name ] ) )
		{
			zone = level.zones[ self.zone_name ];
			while ( 1 )
			{
				//no players in an adjacent zone?  Delete me if nobody can see me
				//NOTE: what if he's not in a zone at all?
				if ( (!zone.is_enabled ||!zone.is_active) )
				{
					if ( !(self potentially_visible( FALLER_DIST_SQ_VISIBLE )) )
					{
						if ( self.health != level.zombie_health )
						{
							//took some damage - fall instead of delete
							//IPrintLnBold("damaged zombie faller in inactive zone dropping down");
							self.zombie_faller_should_drop = true;
							break;
						}
						else
						{
							//IPrintLnBold("deleting zombie faller in inactive zone");
							self zombie_faller_delete();
							return;
						}
					}
				}
				wait( 0.5 );
			}
		}
	}
}

zombie_fall_should_attack(spot)
{
	victims = zombie_fall_get_vicitims(spot);
	return victims.size > 0;
}

zombie_fall_get_vicitims(spot)
{
	ret = [];
	players = GetPlayers();

	checkDist2 = 40.0;
	checkDist2 *= checkDist2;
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
		{
			continue;
		}

		// if the player is in crouch or prone, fallers can't attack them
		stance = player GetStance();
		if ( stance == "crouch" || stance == "prone" )
		{
			continue;
		}
				
		// make sure the player is below us first
		zCheck = self.origin[2] - player.origin[2];
		if ( zCheck < 0.0 || zCheck > 120.0 )
		{
			continue;
		}

		dist2 = Distance2DSquared(player.origin, self.origin);
		if ( dist2 < checkDist2 )
		{
			ret[ret.size] = player;
		}
	}

	return ret;
}

get_fall_anim(spot)
{
	return level._zombie_fall_anims[self.animname]["fall"];
}

zombie_faller_enable_location()
{
	if ( IsDefined( self.zombie_faller_location ) )
	{
		self.zombie_faller_location.is_enabled = true;
		self.zombie_faller_location = undefined;
	}
}

//Wait until we die, then clear our spawn spot so it can be used again
zombie_faller_death_wait()
{
	self endon( "falling" );
	self waittill( "death" );
	//in case we're killed while still hanging out in our location
	self zombie_faller_enable_location();
}

zombie_fall_death_func()
{
	// rsh040711 - set noclip so death anim can translate through the ceiling
	self animmode( "noclip" );
	self.deathanim = "zm_faller_emerge_death";

	return self maps\mp\zombies\_zm_spawner::zombie_death_animscript();
}

/*
zombie_fall_death:
Track when the zombie should die, set the death anim, and stop the animscripted so he can die
*/
zombie_fall_death(spot)
{
	//self.zombie_fall_death_out = false;

	self endon("fall_anim_finished");

	while (self.health > 1)	// health will only go down to 1 when playing animation with AnimScripted()
	{
		self waittill("damage", amount, attacker, dir, p, type);
	}

	self StopAnimScripted();	//Need to stop anim so we don't get into delayedDeath (native var).
	spot notify("stop_zombie_fall_fx");
}

_damage_mod_to_damage_type(type)
{
	toks = strtok(type, "_");
	if(toks.size<2)
	{
		return type;
	}
	
	//Throw out "MOD_"
	returnStr = toks[1];

	for(i=2;i<toks.size;i++)
	{
		returnStr += toks[i];
	}
	
	returnStr = tolower(returnStr);
	return returnStr;
}

//-------------------------------------------------------------------
// Play the fx as the zombie crawls out of the ceiling and thread another function to handle the dust falling
// off when the zombie is out of the ceiling.
//-------------------------------------------------------------------
zombie_fall_fx(spot)
{
	spot thread zombie_fall_dust_fx(self);
	spot thread zombie_fall_burst_fx();
	playsoundatposition ("zmb_zombie_spawn", spot.origin);
	self endon("death");
	spot endon("stop_zombie_fall_fx");
	wait 1;
	if (self.zombie_move_speed != "sprint")
	{
		// wait longer before starting billowing fx if it's not a really fast animation
		wait 1;
	}
}

zombie_fall_burst_fx()
{
	self endon("stop_zombie_fall_fx");
	self endon("fall_anim_finished");
	
	playfx(level._effect["rise_burst"],self.origin + ( 0,0,randomintrange(5,10) ) );
	wait(.25);
	playfx(level._effect["rise_billow"],self.origin + ( randomintrange(-10,10),randomintrange(-10,10),randomintrange(5,10) ) );
}

zombie_fall_dust_fx(zombie)
{
	dust_tag = "J_SpineUpper";
	
	self endon("stop_zombie_fall_dust_fx");
	self thread stop_zombie_fall_dust_fx(zombie);

	dust_time = 7.5; // play dust fx for a max time
	dust_interval = .1; //randomfloatrange(.1,.25); // wait this time in between playing the effect
	
	for (t = 0; t < dust_time; t += dust_interval)
	{
		PlayfxOnTag(level._effect["rise_dust"], zombie, dust_tag);
		wait dust_interval;
	}
}

stop_zombie_fall_dust_fx(zombie)
{
	zombie waittill("death");
	self notify("stop_zombie_fall_dust_fx");
}

handle_fall_notetracks(note, spot)
{
	// the anim notetracks control which death anim to play
	// default to "deathin" (still in the ground)

	if (note == "deathout" )
	{
		self.deathFunction = ::faller_death_ragdoll;
		//self.zombie_fall_death_out = true;
		//self notify("zombie_fall_death_out");
	}
	else if ( note == "fire" )
	{
		// attack all players beneath us
		victims = zombie_fall_get_vicitims(spot);
		for ( i = 0; i < victims.size; i++ )
		{
			victims[i] DoDamage( self.meleeDamage, self.origin, self, self, "none", "MOD_MELEE" );
			//damaged someone!
			self.zombie_faller_should_drop = true;
		}
	}
}

faller_death_ragdoll()
{
	self StartRagdoll();
	self launchragdoll((0, 0, -1));

	return self maps\mp\zombies\_zm_spawner::zombie_death_animscript();
}

//Test if self is in player's FOV
in_player_fov( player )
{
	playerAngles = player getplayerangles();
	playerForwardVec = AnglesToForward( playerAngles );
	playerUnitForwardVec = VectorNormalize( playerForwardVec );

	banzaiPos = self.origin;
	playerPos = player GetOrigin();
	playerToBanzaiVec = banzaiPos - playerPos;
	playerToBanzaiUnitVec = VectorNormalize( playerToBanzaiVec );

	forwardDotBanzai = VectorDot( playerUnitForwardVec, playerToBanzaiUnitVec );
	angleFromCenter = ACos( forwardDotBanzai ); 

	playerFOV = GetDvarFloat( "cg_fov" );
	banzaiVsPlayerFOVBuffer = GetDvarFloat( "g_banzai_player_fov_buffer" );	
	if ( banzaiVsPlayerFOVBuffer <= 0 )
	{
		banzaiVsPlayerFOVBuffer = 0.2;
	}

	inPlayerFov = ( angleFromCenter <= ( playerFOV * 0.5 * ( 1 - banzaiVsPlayerFOVBuffer ) ) );

	return inPlayerFov;
}

//-------------------------------------------------------------------------------
//	MCG 030711: 
//	can faller zombie potentially be seen by any players?
//	self = zombie to check.
//-------------------------------------------------------------------------------
potentially_visible( how_close )
{
	if ( !IsDefined( how_close ) )
	{
		how_close = DEFAULT_DIST_SQ_VISIBLE;
	}
	potentiallyVisible = false;
	
	players = getplayers();
	for ( i = 0; i < players.size; i++ )
	{
		dist = DistanceSquared(self.origin, players[i].origin);
		if(dist < how_close)
		{
			inPlayerFov = self in_player_fov(players[i]);
			if(inPlayerFov)
			{
				potentiallyVisible = true;
				//no need to check rest of players
				break;
			}					
		}		
	}	

	return potentiallyVisible;
}
