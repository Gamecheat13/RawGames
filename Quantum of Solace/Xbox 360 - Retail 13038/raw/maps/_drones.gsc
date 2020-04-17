///////////////////////////////////////////////////////////////////
// _Drones
//
// revision date: 11/15/07
// 
//	Notes:
//	- Must use script_struct to define the node / path of the drones.
//	- Must set up spawn functions that point to characters used for the drone.
//		- Spawn fucntions are set up in your level script in the level.drone_spawnFunction[scipt_aibrain] variable
//		which can also be an array of potential character functions.
//	- Telling the drones to "shoot" doens't look right at the moment.
//
//	Trigger K/V pairs:
//	--------------------
//	script_allowdeath: 	If set to "1", drones will take damage and die.
//	script_trace:		If set to "1", drones will not spawn in unless the player is looking away from the spawn points.
//	script_noteworthy:	If set to "looping" on the trigger, the drones will spawn in on a 
//						loop. MUST HAVE script_delay OR script_delay_min and script_delay_max set.
//	script_delay:		Sets the delay in between looping drone spawns.
//	script_delay_min:	Sets the minimum delay in between looping drone spawns.
//	script_delay_max:	Sets the maximum delay in between looping drone spawns.
//	script_requires_player:	Requires the player to hit the trigger to start the next drone spawn loop.
//	script_drones_min:	Sets the minimum number of drones to spawn.
//	script_drones_max:	Sets the maximum number of drones to spawn.
//	script_repeat:      when looping, how many loops to run. default is 999999.
//	script_perfectsense: Sets civilians to cower if Bond has a weapon unholstered
//							defaults to "1" (true), set to "0" to disable
//	script_ignoreme:	Set to "1" to allow friendly fire on civ drones, defaults to "0"
//	script_fallback:	If set to "1", civ drones will react when player runs into them, defaults to "1"
//	script_sightrange:	enable/disable drone head tracking. default is "1" (on)
//	
//
//	Script_struct K/V pairs:
//	--------------------
//	script_death:		Drone will die in this many seconds. Set to 0 on second to last script_struct in chain to ensure death.
//	script_death_min:	Drone will die between min-max seconds.
//	script_death_max:	Drone will die between min-max seconds.
//	script_delete:		Delete drone on this script_struct.
//	radius:				Drone will run to any point within the radius value before going to the next node.
//	script_noteworthy:	Pass in a string for the event you want to play on this node. Refer to the ShooterRun() function
//						in _drones for all the possible events. Basic locomotion ones are:
//						"walk", "run", "sprint"
//	scipt_aibrain:		Overrides the drone model used with the model set by level.drone_spawnFunction[scipt_aibrain].  defaults to "civilian".
//	script_int:			If set to "1", will use female skeleton animations, also defaults the ai_brain for this drone to "civilian_female".
//
//
///////////////////////////////////////////////////////////////////


#include maps\_utility;

// TREYARCH: Added to make the math stuff work again since ABS and whatnot was changed / removed.
#include animscripts\Utility;
//#include animscripts\SetPoseMovement;
//#include animscripts\Combat_utility;
#include animscripts\shared;
#include common_scripts\Utility;

init()
{
	// SCRIPTER_MOD
	// JesseS (3/16/2007 ): took out weaponlist call since it disappeared...
	//animscripts\weaponList::initWeaponList();

	//set up aiming and shooting animations and fx
	setAnimArray();
	level.drone_impact		= loadfx ("impacts/flesh_hit");
	level.drone_muzzleflash = loadfx ("weapon/p99_discharge_a");
	
	// init global settings
	if (!isdefined(level.traceHeight))
		level.traceHeight = 400;
	
	if (!isdefined(level.droneStepHeight))
		level.droneStepHeight = 100;
	
	// set max drones
	if(!isdefined(level.max_drones))
		level.max_drones = [];
	//if(!isdefined(level.max_drones["axis"]))
	//	level.max_drones["axis"] = 99999;
	//if(!isdefined(level.max_drones["allies"]))
	//	level.max_drones["allies"] = 99999;
	// BOND MOD
	// MQL 11/15/07: commented out axis &allies calls, added civilians
	if(!isdefined(level.max_drones["civilian"]))
		level.max_drones["civilian"] = 99999;

	// set structs to track drones
	if(!isdefined(level.drones))
		level.drones = [];
	//if(!isdefined(level.drones["axis"]))
	//	level.drones["axis"] = struct_arrayspawn();
	//if(!isdefined(level.drones["allies"]))
	//	level.drones["allies"] = struct_arrayspawn();
	// BOND MOD
	// MQL 11/15/07: commented out axis &allies calls, added civilians
	if(!isdefined(level.drones["civilian"]))
		level.drones["civilian"] = struct_arrayspawn();

	// initialize all script_struct entities
	init_struct_targeted_origins();

	// get and thread drone start triggers
	// BOND MOD
	// MQL 11/15/07: commented out axis &allies calls, added civilians
	//array_thread (getentarray("drone_axis","targetname"), ::drone_triggers_wait_axis );
	//array_thread (getentarray("drone_allies","targetname"), ::drone_triggers_wait_allies );
	array_thread (getentarray("drone_civs","targetname"), ::drone_triggers_wait_civs );
	//finish_struct_targeted_origins();
}

build_struct_targeted_origins()
{
	if (!isdefined(self.target))
		return;
	self.targeted = level.struct_targetname[self.target];
	if (!isdefined(self.targeted))
		self.targeted = [];
}

init_struct_targeted_origins()
{
	level.struct_targetname = [];

	count = level.struct.size;

	for ( i = 0; i < count; i++ )
	{
		struct = level.struct[i];
		if (!isdefined(struct.targetname))
			continue;
		struct_targetname = level.struct_targetname[struct.targetname];
		if (!isdefined(struct_targetname))
			targetname_count = 0;
		else
			targetname_count = struct_targetname.size;
		level.struct_targetname[struct.targetname][targetname_count] = struct;
	}

	for ( i = 0; i < count; i++ )
	{
		struct = level.struct[i];
		if (!isdefined(struct.target))
			continue;
		struct.targeted = level.struct_targetname[struct.target];
	}
}


// BOND MOD
// MQL 11/15/07: commented out axis &allies calls, added civilians
// spawn drones off of trigger
drone_triggers_wait_civs()
{
	// set the trigger "targeted" field to targeted script_struct
	self build_struct_targeted_origins();
	
	// BOND MOD
	// MQL 4/23/08: add head tracking
	// set head tracking default to true
	qHeadTrack = true;
	if ( (isdefined(self.script_sightrange)) && (self.script_sightrange == 0) )
	{
		qHeadTrack = false;
	}

	// set fake death default to true
	qFakeDeath = true;
	if ( (isdefined(self.script_allowdeath)) && (self.script_allowdeath == 0) )
	{
		qFakeDeath = false;
	}

	// set sight trace default to false
	qSightTrace = false;
	if ( (isdefined(self.script_trace)) && (self.script_trace > 0) )
	{
		qSightTrace = true;
	}
	
	// BOND MOD
	// MQL 11/21/07: add cowering
	// set cower default to true
	qCower = true;
	if ( (isdefined(self.script_perfectsense)) && (self.script_perfectsense == 0) )
	{
		qCower = false;
	}

	// BOND MOD
	// MQL 11/26/07: check for friendly fire
	// set friendly fire default to true
	qFriendlyFire = false;
	if ( (isdefined(self.script_ignoreme)) && (self.script_ignoreme > 0) )
	{
		qFriendlyFire = true;
	}

	// BOND MOD
	// MQL 12/14/07: check for player bumping against the drone
	qBump = true;
	if( (IsDefined(self.script_fallback)) && (self.script_fallback == 0) )
	{
		qBump = false;
	}

	// check to see if there's a valid script struct the trigger is targeting
	assert(isdefined(self.targeted));
	assert(isdefined(self.targeted[0]));
	
	// set the spawn point to the targeted struct and check for validity
	spawnPoint = self.targeted;
	assert(isdefined(spawnPoint[0]));
	
	// MikeD (06/26/06): Added the ability to kill this thread, if script_ender is defined.
	if( IsDefined( self.script_ender ) )
	{
		level endon( self.script_ender );
	}
	
	// wait for trigger
	self waittill ("trigger");
	
	// define default repeat times if none set
	if (!isdefined (self.script_repeat))
	{
		repeat_times = 999999;
	}
	else
	{
		repeat_times = self.script_repeat;
	}
	
	// check to see if spawner is looping
	if ( ( (isdefined(self.script_noteworthy)) && (self.script_noteworthy == "looping") ) || ( (isdefined(self.script_looping)) && (self.script_looping > 0) ) )
	{
		// assert if mandatory keys are not present for looping
		assert( isdefined(self.script_delay) || ( isdefined(self.script_delay_min) && isdefined(self.script_delay_max) ) );
		
		// set looping endon condition
		self endon ("stop_drone_loop");
		
		// loop drone spawning
		for (i = 0; i < repeat_times; i++)
		{
			// SCRIPTER_MOD
			// JesseS (3/16/2007): kill old drone spawn waits, rather then building them up
			level notify ("new drone spawn wave");
				
			// set number of min/max number of active drones from spawner
			spawnSize = undefined;
			if (isdefined (self.script_drones_min))
			{
				max = spawnpoint.size;
				if (isdefined (self.script_drones_max))
				{
					max = self.script_drones_max;
				}
				if (self.script_drones_min == max)
				{
					spawnSize = max;
				}
				else
				{
					spawnSize = (self.script_drones_min + randomint(max - self.script_drones_min));
				}
			}
			
			// spawn drones with passed in parameter
			thread drone_civ_spawngroup(spawnpoint, qHeadTrack, qFakeDeath, spawnSize, qSightTrace, qCower, qFriendlyFire, qBump);
			if (isdefined(self.script_delay))
			{
				if (self.script_delay < 0)
					return;
				wait (self.script_delay);
			}
			else
			{
				wait ( self.script_delay_min + randomfloat(self.script_delay_max - self.script_delay_min) );
			}
			if ( (isdefined(self.script_requires_player)) && (self.script_requires_player > 0) )
			{
				self waittill ("trigger");
			}

			if (!isdefined (self.script_repeat))
			{
				repeat_times = 999999;
			}
		}
	}
	else	//one time only
	{
		//how many drones should spawn?
		spawnSize = undefined;
		if (isdefined (self.script_drones_min))
		{
			max = spawnpoint.size;
			if (isdefined (self.script_drones_max))
				max = self.script_drones_max;
			if (self.script_drones_min == max)
				spawnSize = max;
			else
				spawnSize = (self.script_drones_min + randomint(max - self.script_drones_min));
		}

		// slayback 10/21/07: added initial delay option for one-time drone spawners
		self drone_triggers_delay_first_spawn();

		// TREYARCH: Changed passing in spawnSize instead of undefined for one time spawns.
		thread drone_civ_spawngroup(spawnpoint, qHeadTrack, qFakeDeath, spawnSize, qSightTrace, qCower, qFriendlyFire, qBump);
	}
}

// slayback 10/21/07: if delay is specified on non-looping triggers, wait before spawning drones
// self = the drone spawn trigger
drone_triggers_delay_first_spawn()
{
	if( IsDefined( self.script_delay ) )
	{
		if( self.script_delay > 0 )
		{
			wait( self.script_delay );
		}
	}
	else if( IsDefined( self.script_delay_min ) && IsDefined( self.script_delay_max ) )
	{
		if( self.script_delay_max > self.script_delay_min )
		{
			wait( RandomFloatRange( self.script_delay_min, self.script_delay_max ) );
		}
	}
}


// BOND MOD
// MQL 11/15/07: commented out axis &allies calls, added civilians
drone_civ_spawngroup(spawnpoint, qHeadTrack, qFakeDeath, spawnSize, qSightTrace, qCower, qFriendlyFire, qBump)
{
	spawncount = spawnpoint.size;
	if (isdefined(spawnSize))
	{
		spawncount = spawnSize;
		spawnpoint = array_randomize(spawnpoint);
	}

	if( spawncount > spawnpoint.size )
	{
		spawncount = spawnpoint.size;
	}

	for (i=0;i<spawncount;i++)
	{
		spawnpoint[i] thread drone_civ_spawn(qHeadTrack, qFakeDeath, qSightTrace, qCower, qFriendlyFire, qBump);
	}
}


// BOND MOD
// MQL 11/15/07: commented out axis &allies calls, added civilians
drone_civ_spawn(qHeadTrack, qFakeDeath, qSightTrace, qCower, qFriendlyFire, qBump)
{	
	// SCRIPTER_MOD
	// JesseS (3/16/2007): Added check to make sure we dont get a bunch of these queued up
	// by co-op guys
	level endon ("new drone spawn wave");

	// set if drone can die
	if (!isdefined (qFakeDeath))
		qFakeDeath = false;

	//if qSightTrace, wait until player can't see the drone spawn point
	if (!isdefined(qSightTrace))
		qSightTrace = false;
	while ( (qSightTrace) && (self spawnpoint_playersView()) )
		wait 0.2;

	// BOND MOD
	// MQL 4/23/08: add head tracking
	if( !IsDefined(qHeadTrack) )
	{
		qHeadTrack = false;
	}

	// BOND MOD
	// MQL 11/21/07: add cowering
	// set if drones can cower
	if (!IsDefined(qCower))
	{
		qCower = true;
	}

	// BOND MOD
	// MQL 11/26/07: add friendly fire
	if (!IsDefined(qFriendlyFire))
	{
		qFriendlyFire = false;
	}

	// BOND MOD
	// MQL 12/14/07: add bumping against drones
	if( !IsDefined( qBump ) )
	{
		qBump = false;
	}

	// keep drone from spawning if at max
	if (level.drones["civilian"].lastindex > level.max_drones["civilian"])
		return;

	// spawn a drone
	guy = spawn("script_model", self.origin);
	if( IsDefined( self.angles ) )
	{
		guy.angles = self.angles;
	}
	
	// BOND MOD
	// MQL 12/06/07: allow spawning of multiple model type based on trigger setting
	// the spawn func needs to be defined on a per level basis
	if( !IsDefined( self.script_aibrain ) )
	{
		if( IsDefined( self.script_int ) && ( self.script_int > 0 ) )
		{
			self.script_aibrain = "civilian_female";
		}
		else
		{
			self.script_aibrain = "civilian";
		}
	}

	assert(isdefined(level.drone_spawnFunction[self.script_aibrain]));
	if(IsArray(level.drone_spawnFunction[self.script_aibrain]))
	{
		spawn_func = random(level.drone_spawnFunction[self.script_aibrain]);
	}
	else
	{
		spawn_func = level.drone_spawnFunction[self.script_aibrain];
	}

	guy [[ spawn_func ]]();

	
	// BOND MOD
	// MQL 12/06/07: set which skeleton the drone is using (determines which anims to play)
	if( IsDefined( self.script_int ) && ( self.script_int > 0 ) )
	{
		guy.female_skeleton = true;
	}
	else
	{
		guy.female_skeleton = false;
	}

	// BOND MOD
	// MQL 11/15/07: commented out weapon assigning for civilians
	//guy drone_civ_assignweapon();
	
	// set drone targetname to drone
	guy.targetname = "drone";
	
	// Added by Alex Liu 10/16/07 to allow script to identify specific drones
	// Drones now have the same script_noteworthy as their spawn points (the structs, not the trigger)
	guy.script_noteworthy = self.script_noteworthy;
	
	// assign the groupname to the drone so we have another way to grab them
	guy.groupname = self.groupname;
	
	// api function to creat a drone
	guy MakeFakeAI();
	
	// set team to civilian
	guy.team = "civilian";

	// override trigger headtrack setting with node setting (_brian_b_ 2008.07.25)
	if (isdefined(self.script_sightrange))
	{
		if (self.script_sightrange == 0)
		{
			qHeadTrack = false;
		}
		else
		{
			qHeadTrack = true;
		}
	}

	guy.headTrack = qHeadTrack;
	guy.fakeDeath = qFakeDeath;
	guy.cower = qCower;
	guy.FriendlyFire = qFriendlyFire;
	guy.bump = qBump;

	// BOND MOD
	// MQL 4/2/08: add wait thread to delete drone
	guy thread drone_wait_for_delete();

	guy thread drone_think( self );
}

// check to see if player can see spawn point
spawnpoint_playersView()
{
	//define FOV
	if (!isdefined(level.cos80))
		level.cos80 = cos(80);
	
	// SCRIPTER_MOD
	// JesseS (3/16/2007): Added check for all players POV
	//players = get_players();

	// BOND MOD
	// set players to level.player since we don't have co-op
	// MQL 11/5
	players = level.player;
	player_view_count = 0;
	success = false;
	
	// check if spawnpoint within player fov
	for (i=0; i < players.size; i++)
	{
		prof_begin("drone_math");
			forwardvec = anglestoforward(players[i].angles);
			normalvec = vectorNormalize(self.origin - (players[i] getOrigin()) );
			vecdot = vectordot(forwardvec,normalvec);
		prof_end("drone_math");
		if (vecdot > level.cos80)	//it's within the players FOV so try a trace now
		{
			prof_begin("drone_math");
				success = ( bullettracepassed(players[i] getEye(), self.origin + (0,0,48), false, self) );
			prof_end("drone_math");
			
			if (success)
			{
				player_view_count++;
			}
		}
	}
	
	if (player_view_count != 0)
	{
		return true;
	}
	
	//isn't in the field of view so it must be out of sight
	return false;
}


// BOND MOD
// MQL 11/15/07: commented out axis &allies calls, added civilians
// assign drones a weapon
drone_civ_assignweapon()
{
	// BOND MOD
	// MQL 11/15/97: comment out campaign check since we don't care
	// check for campaign to assign a weapon
	//switch(level.campaign)
	//{
	//	case "american":
	//		self.weapon = drone_allies_assignWeapon_american();
	//		break;
	//	case "british":
	//		self.weapon = drone_allies_assignWeapon_british();
	//		break;
	//	case "russian":
	//		self.weapon = drone_allies_assignWeapon_russian();
	//		break;
	//}
	self.weapon = drone_civ_weapon();
	
	// get weapon model of drone weapon
	weaponModel = getWeaponModel(self.weapon);

	// BOND MOD
	// Do a check to see if they have a wpn before attaching
	// MQL 11/5
	if( weaponModel != "" )
	{
		self attach(weaponModel, "tag_weapon_right");
		self.bulletsInClip = weaponClipSize( self.weapon );
	}
}

drone_civ_weapon()
{
	randWeapon = randomint(2);
	switch(randWeapon)
	{
		case 0: return "p99";
		case 1: return "p99_s";
	}
}


// set the name of the drone
drone_setName()
{
	wait 0.25;
	if (!isdefined(self))
		return;
	
	//set friendlyname on allies
	if (self.team != "allies")
		return;
		
	if( !IsDefined( level.names ) )
	{
		maps\_names::setup_names();
	}
	
	if (isdefined(self.script_friendname))
		self.name = self.script_friendname;
	else
	{
		switch(level.campaign)
		{
			case "american":
				self maps\_names::get_name_for_nationality( "american" );
				break;
			case "russian":
				self maps\_names::get_name_for_nationality( "russian" );
				break;
			case "british":
				self maps\_names::get_name_for_nationality( "british" );
				break;
		}
	}
	assert(isdefined(self.name));
	/*
	subText = undefined;
	if(!isdefined(self.weapon))
		subText = (&"WEAPON_RIFLEMAN");
	else
	{
		switch(self.weapon)
		{
			case "m1garand":
			case "enfield":
			case "m1carbine":
			case "SVT40":
			case "mosin_rifle":
				subText = (&"WEAPON_RIFLEMAN");
				break;
			case "thompson":
				subText = (&"WEAPON_SUBMACHINEGUNNER");
				break;
			case "BAR":
			case "ppsh":
				subText = (&"WEAPON_SUPPORTGUNNER");
				break;
		}
	}
	if ( (isdefined(self.model)) && (issubstr(self.model, "medic")) )
		subText = (&"WEAPON_MEDICPLACEHOLDER");
	assert(isdefined(subText));
	
	self setlookattext(self.name, subText);
	*/
}

#using_animtree("fakeshooters");
// control what drones do while on path
drone_think(firstNode)
{
	self endon("death");
	// set health for drone
	self.health = 1000000;

	// BOND MOD
	// MQL 11/15/07: comment out name setting since Bond doesn't use this
	// set name for drones
	//self thread drone_setName();
	
	// activate friendly fire check on drone
	//level thread maps\_friendlyfire::friendly_fire_think(self);

	// clear the ".voice" flag 
	self thread drones_clear_variables();

	// add drone to team structure
	structarray_add(level.drones[self.team],self);

	// notify level of new drone
	level notify ("new_drone");

	// spawn script_origin and link to drone
	if (level.script != "duhoc_assault")
	{
		self.turrettarget = spawn ("script_origin",self.origin+(0,0,50));
		self.turrettarget linkto (self);
	}

	// end thread on drone's death
	self endon ("drone_death");

	// assert if no node passed in
	assert(isdefined(firstNode));

	//start drone updateLookAt
	self thread Drone_UpdateLookAt();

	// BOND MOD
	// MQL 4/23/08: add head tracking
	if ( (isdefined(self.headTrack)) && (self.headTrack == true) )
		self thread drone_headtrack();
	//Test code for Drone LookAt
	//self thread startLookAt();

	//start fake death on drone
	if ( (isdefined(self.fakeDeath)) && (self.fakeDeath == true) )
		self thread drone_fakeDeath();
	
	// BOND MOD
	// MQL 11/21/07: add cowering
	//start cowering thread on drone
	if ( (isdefined(self.cower)) && (self.cower == true) )
		self thread drone_cower();

	// BOND MOD
	// MQL 11/26/07: add civilian friendly fire
	if ( (isdefined(self.FriendlyFire)) && (self.FriendlyFire == false) )
		self thread drone_friendlyfire();

	// BOND MOD
	// MQL 12/14/07: add civilian bumping
	//if( (IsDefined(self.bump)) && (self.bump == true ) )
	//	self thread drone_bump();

	// end thinking when shooting
	self endon ("drone_shooting");

	// BOND MOD
	// MQL 11/15/07: change to bond idle anims
	self useAnimTree(#animtree);

	if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
	{
		idleAnim[0] = %Gen_Civs_CasualStand_Female;
		idleAnim[1] = %Gen_Civs_CasualStand_Female;
		idleAnim[2] = %Gen_Civs_CasualStand_Female;
	}
	else
	{
		idleAnim[0] = %Civ_Gen_ArmsHips2Crossed;
		idleAnim[1] = %Civ_Gen_ArmsHips2Crossed;
		idleAnim[2] = %Civ_Gen_ArmsHips2Crossed;
	}

	//idleAnim[0] = %Thu_Relax_Stand_Idl_Pistol;
	//idleAnim[1] = %Thu_Susp_Stand_Idl_Pistol;
	//idleAnim[2] = %Thu_Alrt_Stand_Idl_Pistol;
	//idleAnim[0] = %stand_alert_1;
	//idleAnim[1] = %stand_alert_2;
	//idleAnim[2] = %stand_alert_3;
	
	self.drone_idleAnim = idleAnim;

	// move drone on path
	self drone_runChain(firstNode);
	wait 0.05;
	self.running = undefined;
	self._event = "end_chain";
	if (!isdefined(self))
		return;
	idle_org = self.origin;
	idle_ang = self.angles;

	while(isdefined(self))
	{
		self animscripted("drone_idle_anim", idle_org, idle_ang, idleAnim[randomint(idleAnim.size)]);
		self waittillmatch("drone_idle_anim","end");
	}
}

// BOND MOD
// MQL 11/15/07: conver to random physics launch
#using_animtree("duhoc_drones");
drone_mortarDeath( vDirection, vOrigin, fMagnitude )
{
	// unlink drone
	self unlink();

	// set default origin, damage, and direction
	if( !IsDefined( vDirection ) )
	{
		vDirection = vector_random( 10, 10, 10 );
	}
	if( !IsDefined( vOrigin ) )
	{
		vOrigin = self.origin;
	}
	if( !IsDefined( fMagnitude ) )
	{
		fMagnitude = 200;
	}

	// set drone in ragdoll & start physics
	self StartRagDoll();
	wait(0.1);
	PhysicsJolt( vOrigin, 512, 256, vector_multiply( vDirection, fMagnitude ) );

	// remove drone 
	self drone_doDeath();
	wait( 3 );
	if( IsDefined( self ) )
	{
		self moveto(self.origin - (0,0,100), 7);
	}
	wait( 7 );
	self drone_delete();

	// BOND MOD
	// MQL 11/15/07: commented out all anim call and using ragdoll
	//self useAnimTree(#animtree);
	//switch(direction)
	//{
	//	case "up":
	//		self thread drone_doDeath(%death_explosion_up10);
	//		break;
	//	case "forward":
	//		self thread drone_doDeath(%death_explosion_forward13);
	//		break;
	//	case "back":
	//		self thread drone_doDeath(%death_explosion_back13);
	//		break;
	//	case "left":
	//		self thread drone_doDeath(%death_explosion_left11);
	//		break;
	//	case "right":
	//		self thread drone_doDeath(%death_explosion_right13);
	//		break;
	//}
}

#using_animtree("duhoc_drones");
drone_fakeDeath(instant)
{
	if (!isdefined(instant))
		instant = false;
	
	self endon ("delete");
	self endon ("drone_death");
	
	// SRS testing special explosive death anims
	explosivedeath = false;
	
	// BOND MOD
	// MQL 11/15/07: init damage variables
	amount = undefined;
	attacker = undefined;
	parm1 = undefined;
	parm2 = undefined;
	parm3 = undefined;

	while(isdefined(self))
	{
		if (!instant)
		{
			self setCanDamage(true);
			
			// parm1 (vDirection), parm2 (vPoint), parm3 (iType)
			self waittill ("damage", amount, attacker, parm1, parm2, parm3);
			// JT integrated this with artillery / explosives death check
			// if (parm3 == "MOD_GRENADE_SPLASH")
			// {
			//	 self.damageweapon = "none";
			// }
			
			// SRS testing special explosive death anims
			if( parm3 == "MOD_GRENADE_SPLASH" || parm3 == "MOD_EXPLOSIVE" || parm3 == "MOD_EXPLOSIVE_SPLASH" )
			{
				self.damageweapon = "none";
				explosivedeath = true;
			}

			self notify ("death", attacker, parm3);
			

			// BOND MOD
			// MQL 11/15/07: unlink drone from anything so that it can ragdoll
			self unlink();

			// BOND MOD
			// MQL 11/15/07: call death fx on impact pt
			self thread drone_doDeath_impacts( parm2, attacker );

			// SCRIPTER_MOD
			// JesseS (3/16/2007 ): changed attacker == level.player to isplayer(attacker)
			if ( isplayer(attacker) || attacker == level.playervehicle)
			{
				level notify ( "player killed drone" );
			}
		}
		
		if ( (isdefined(self.customFirstAnim)) && (self.customFirstAnim == true) )
			self waittill ("customFirstAnim done");
		
		if (!isdefined(self))
			return;
		
		self notify ("Stop shooting");
		self.dontDelete = true;
		
		deathAnim = undefined;
		self useAnimTree(#animtree);
		
		// BOND MOD ATTENTION
		// MQL 11/15/08: putting guys into ragdoll since we don't have all these anims
		// SRS Did the guy take damage from an explosive?
		if( explosivedeath )
		{
			if( IsDefined( amount ) && IsDefined( parm1 ) && IsDefined( parm2 ) )
			{
				self thread drone_mortarDeath( vector_multiply(parm1, -1), parm2, amount );
			}

			// JT use a random mortar death anim
			//x = randomInt(5);

			// TODO: - try to pick anims that weren't used recently
			//       - make this directional instead of random (anim is based on guy's location relative to blast)
			//       - use ragdoll system in the future?
			//switch(x)
			//{
			//	case 1:
			//	direction = "up";
			//	break;

			//	case 2:
			//	direction = "forward";
			//	break;

			//	case 3:
			//	direction = "back";
			//	break;

			//	case 4:
			//	direction = "left";
			//	break;

			//	case 5:
			//	direction = "right";
			//	break;

			//	default:
			//	direction = "up";
			//	break;
			//}
			//
			//self thread drone_mortarDeath(direction);
			return;
		}
		//JT if not explosive death, then check if drone is running
		else
		// BOND MOD
		// MQL 11/15/07: get rid of this and put drone into ragdoll
		//if (isdefined(self.running))
		{
			if( IsDefined( amount ) && IsDefined( parm1 ) && IsDefined( parm2 ) )
			{
				self drone_bulletDeath( parm1, parm2, amount );
			}

			//deaths[0] = %death_run_stumble;
			//deaths[1] = %death_run_onfront;
			//deaths[2] = %death_run_onleft;
			//deaths[3] = %death_run_forward_crumple;
		}
		// BOND MOD
		// MQL 11/15/07: get rid of this and put drone into ragdoll
		//else
		//{
		//	deaths[0] = %death_stand_dropinplace;
		//}
		
		// BOND MOD
		// MQL 11/15/07: remove anim param because we're using ragdoll
		self thread drone_doDeath();
		//self thread drone_doDeath( deaths[randomint(deaths.size)] );
		return;
	}
}

// delay killing drone for x amount of time
#using_animtree("duhoc_drones");
drone_delayed_bulletdeath(waitTime, deathRemoveNotify)
{
	self endon ("delete");
	self endon ("drone_death");
	
	self.dontDelete = true;
	
	if (!isdefined(waitTime))
		waitTime = 0;
	if (waitTime > 0)
		wait (waitTime);
	
	self thread drone_fakeDeath(true);
}

// BOND MOD
// MQL 11/15/07: comment out anything pertaining to death anim, using ragdoll
// play death anim
#using_animtree("duhoc_drones");
drone_doDeath(deathAnim, deathRemoveNotify)
{
	// BOND MOD
	// MQL 11/15/07: comment out to let physics do it's work
	// lock drone into place
	//self moveTo (self.origin, 0.05, 0, 0);
	
	traceDeath = false;
	if ( (isdefined(self.running)) && (self.running == true) )
		traceDeath = true;
	self.running = undefined;
	self notify ("drone_death");
	self notify ("Stop shooting");
	self unlink();
	//self useAnimTree(#animtree);

	// BOND MOD
	// MQL 11/15/07: comment out and move to drone_fakeDeath due to ragdoll
	//self thread drone_doDeath_impacts();
	
	// BOND MOD
	// MQL 11/15/07: should move into drone_doDeath_Impacts
	//				 commenting out for now
	// play random death sound
	//if (randomint(3) == 0)
	//{
	//	alias = "generic_death_american_" + (1 + randomint(6));
	//	self thread play_sound_in_space(alias);
	//}
	
	// BOND MOD
	// MQL 11/15/07: comment out for ragdoll stuff
	//prof_begin("drone_math");
	//cancelRunningDeath = false;
	//if (traceDeath)
	//{
	//	//trace last frame of animation to prevent the body from clipping on something coming up in its path
	//	//backup animation if trace fails: %death_stand_dropinplace
	//	
	//	offset = getcycleoriginoffset( self.angles, deathAnim );
	//	endAnimationLocation = (self.origin + offset);
	//	endAnimationLocation = physicstrace( (endAnimationLocation + (0,0,128)), (endAnimationLocation - (0,0,128)) );
	//	//thread debug_line( endAnimationLocation + (0,0,256), endAnimationLocation - (0,0,256) );
	//	d1 = abs(endAnimationLocation[2] - self.origin[2]);
	//	
	//	if (d1 > 20)
	//		cancelRunningDeath = true;
	//	else
	//	{
	//		//trace even more forward than the animation (bounding box reasons)
	//		forwardVec = anglestoforward(self.angles);
	//		rightVec = anglestoright(self.angles);
	//		upVec = anglestoup(self.angles);
	//		relativeOffset = (50,0,0);
	//		secondPos = endAnimationLocation;
	//		secondPos += vector_multiply(forwardVec, relativeOffset[0]);
	//		secondPos += vector_multiply(rightVec, relativeOffset[1]);
	//		secondPos += vector_multiply(upVec, relativeOffset[2]);
	//		secondPos = physicstrace( (secondPos + (0,0,128)), (secondPos - (0,0,128)) );
	//		d2 = abs(secondPos[2] - self.origin[2]);
	//		if (d2 > 20)
	//			cancelRunningDeath = true;
	//	}
	//}
	//prof_end("drone_math");
	//
	//if (cancelRunningDeath)
	//	deathAnim = %death_stand_dropinplace;
	//
	//self animscripted("drone_death_anim", self.origin, self.angles, deathAnim, "deathplant");
	//self waittillmatch("drone_death_anim","end");
	
	// check for valid drone
	if (!isdefined(self))
		return;

	// set contents of drone
	self setcontents(0);

	// wait for notify if defined, else wait 3 sec
	if (isdefined(deathRemoveNotify))
		level waittill (deathRemoveNotify);
	else
		wait 3;

	// check for valid drone
	if (!isdefined(self))
		return;

	// move drone below ground 100 units over 7 sec then delete
	self moveto(self.origin - (0,0,100), 7);
	wait 3;
	if (!isdefined(self))
		return;
	self.dontDelete = undefined;
	self thread drone_delete();
}
/*
debug_line(start, end)
{
	seconds = 5;
	cycles = (seconds * 20);
	for( i = 0 ; i < cycles ; i++ )
	{
		line (start, end, (1,1,1) );
		wait 0.05;
	}
}
*/

// BOND MOD
// MQL 11/15/07: modify to play fx at impact pt instead of bone
drone_doDeath_impacts( vImpactPoint, entAttacker )
{
	// set up script origin
	entOrigin = Spawn( "script_model", self.origin );
	entOrigin SetModel( "tag_origin" );
	if(!IsDefined( entAttacker ))
	{
		entAttacker = level.player;
	}
	entOrigin.angles = VectorToAngles( vImpactPoint - entAttacker.origin );
	entOrigin LinkTo( self );

	// play f/x
	playfxontag( level.drone_impact, entOrigin, "tag_origin" );
	self playsound ("bullet_small_flesh");
	wait 0.05;
	entOrigin Delete();


	//bone[0] = "J_Knee_LE";
	//bone[1] = "J_Ankle_LE";
	//bone[2] = "J_Clavicle_LE";
	//bone[3] = "J_Shoulder_LE";
	//bone[4] = "J_Elbow_LE";
	//
	//impacts = (1 + randomint(2));
	//for (i=0;i<impacts;i++)
	//{
	//	playfxontag( level.drone_impact, self, bone[randomint(bone.size)] );
	//	self playsound ("bullet_small_flesh");
	//	wait 0.05;
	//}
}

// set drone to move on path
drone_runChain(point_start)
{
	// set endon conditions
	self endon ("drone_death");
	self endon ("drone_shooting");
	//self endon ("drone_cover");
	
	runPos = undefined;
	runPoint = undefined;

	self drone_delay(point_start);

	// move while drone is valid
	while(isdefined(self))
	{
		//check for script_death, script_death_min, script_death_max, and script_delete
		// delay death if set
		//-----------------------------------------------------------------------------
		if (isdefined(point_start.script_death))
		{
			//drone will die in this many seconds
			self.dontDelete = true;
			self thread drone_delayed_bulletdeath(0);
		}
		else
		if ( (isdefined(point_start.script_death_min)) && (isdefined(point_start.script_death_max)) )
		{
			//drone will die between min-max seconds
			self.dontDelete = true;
			self thread drone_delayed_bulletdeath(point_start.script_death_min + randomfloat( point_start.script_death_max - point_start.script_death_min));
		}
		
		if ( (isdefined(point_start.script_delete)) && (point_start.script_delete >= 0) )
			self thread drone_delete(point_start.script_delete);
		
		//-----------------------------------------------------------------------------
		
		// set destination
		if (!isdefined(point_start.targeted))
		{
			// BOND MOD
			// MQL 4/15: rotate drone to the angles of the last point
			if( IsDefined( point_start.angles ) )
			{
				self RotateTo(point_start.angles, 0.5);
				self waittill( "rotatedone" );
			}
			break;
		}
		point_end = point_start.targeted;
		if ( (!isdefined(point_end)) || (!isdefined(point_end[0])) )
			break;
		index = randomint(point_end.size);
		
		runPos = point_end[index].origin;
		runPoint = point_end[index];
		
		//check for radius on node, since you can now make them run to a radius rather than an exact point
		if (isdefined(point_end[index].radius))
		{
			assert(point_end[index].radius > 0);
			
			//offset for this drone (-1 to 1)
			if (!isdefined(self.droneRunOffset))
				self.droneRunOffset = (0 - 1 + (randomfloat(2)) );
			
			if (!isdefined(point_end[index].angles))
				point_end[index].angles = (0,0,0);
				
			prof_begin("drone_math");
				forwardVec = anglestoforward(point_end[index].angles);
				rightVec = anglestoright(point_end[index].angles);
				upVec = anglestoup(point_end[index].angles);
				relativeOffset = (0, (self.droneRunOffset * point_end[index].radius) ,0);
				runPos += vector_multiply(forwardVec, relativeOffset[0]);
				runPos += vector_multiply(rightVec, relativeOffset[1]);
				runPos += vector_multiply(upVec, relativeOffset[2]);
			prof_end("drone_math");
		}
		
		// move drone to next position
		self.drone_hasPath = true;
		if (isdefined(point_start.script_noteworthy))
			self ShooterRun(runPoint, point_start.script_noteworthy);
		else
			self ShooterRun(runPoint);
		
		point_start = point_end[index];
	}
	
	// move drone to valid position
	if (!isdefined(runPoint))
	{
		self.drone_hasPath = false;
		runPoint = point_start;
		//self drone_delay(runPoint);
	}
	
	if (isdefined(point_start.script_noteworthy))
		self ShooterRun(runPoint, point_start.script_noteworthy);
	else
		self ShooterRun(runPoint);

	// BOND MOD
	// MQL 2/08: rotate drone to the angles of the last point
	if( IsDefined( runPoint.angles ) )
	{
		self RotateTo(runPoint.angles, 0.5);
		self waittill( "rotatedone" );
	}

	// check for delete flag on struct node and delete if set
	if ( (isdefined(point_start.script_delete)) && (point_start.script_delete >= 0) )
		self thread drone_delete(point_start.script_delete);
}

drone_delay(point)
{
	// delay with idle anim
	if ((IsDefined(point.script_delay)) || (IsDefined(point.script_delay_min) && IsDefined(point.script_delay_max)))
	{
		self thread drone_playIdleAnimation(random(self.drone_idleAnim), false, true);
		delay_time = point script_delay();
	}
}

drones_clear_variables()
{
	if(isdefined(self.voice))
		self.voice = undefined;
}

// delete drone
drone_delete(delayTime)
{
	if ((isdefined(delayTime)) && (delayTime > 0))
		wait delayTime;
	if (!isdefined(self))
		return;
	self notify ("drone_death");
	self notify ("drone_idle_anim");
	structarray_remove(level.drones[self.team],self);
	if (!isdefined(self.dontDelete))
	{
		if(isdefined(self.turrettarget))
			self.turrettarget delete();
		if(isdefined(self.shootTarget))
			self.shootTarget delete();
		self detachall();
		self delete();
	}
}

// BOND MOD
// ATTENTION
// MQL - This handles all actions specified on struct nodes/points
#using_animtree("fakeShooters");
ShooterRun(destinationPoint, event)
{
	// check for valid drone and stop shooting 
	if(!isdefined(self))
		return;
	self notify ("Stop shooting");
	self UseAnimTree(#animtree);
	
	// BOND MOD
	// MQL 11/16/07: add a way to stop if finished cowering
	// set endon to reset loop
	self endon( "cower_stop" );

	// BOND MOD
	// MQL 11/16/07: save destination & event for cowering use
	self._destinationPoint = destinationPoint;
	self._event = event;

	// BOND MOD
	// MQL 11/20/07: wait 1 frame to prevent drones from T posing
	wait( 0.05 );

	prof_begin("drone_math");
	

	// BOND MOD
	// ATTENTION
	// MQL: setting default animation rate
	// 11/16/07: putting animrate on [drone].animRate
	//		sprint = 200
	//		run = 150
	//		walk = 75
	//
	// Setting Default Animation Rate
	//---------------------------------------------------------
	minRate = 0.5;
	maxRate = 1.5;
	randomAnimRate = minRate + randomfloat( maxRate - minRate);

	// BOND MOD
	// ATTENTION
	// MQL: setting default movement rates
	//		sprint = 200
	//		run = 150
	//		walk = 75
	//
	// Setting Default Movement Rate to Walk
	//---------------------------------------------------------
	//calculate the distance to the next run point and figure out how long it should take
	//to get there based on distance and run speed
	d = distance(self.origin, destinationPoint.origin);
	if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
	{
		if( !IsDefined( self.animRate ) )
		{
			self.animRate = 45;
		}

		if (!isdefined(self.droneRunRate))
		{
			self.droneRunRate = 52;
		}
	}
	else
	{
		if( !IsDefined( self.animRate ) )
		{
			self.animRate = 40;
		}

		if (!isdefined(self.droneRunRate))
		{
			self.droneRunRate = 40;
		}
	}

	speed = (d/self.droneRunRate);
	//set his trace height back to normal
	self.lowheight = false;
	//orient the drone to his run point
	self turnToFacePoint( destinationPoint.origin, speed );
	// set default locomotion animation
	//self.drone_run_cycle = %Thu_Relax_Stand_Walk_Pistol;

	if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
	{
		self.drone_run_cycle = %Gen_Civs_CasualWalk_Female;
		//self.drone_run_cycle = %Civ_CasualWalkV1;
	}
	else
	{
		self.drone_run_cycle = %Civ_CasualWalkV1;
	}
	

	// ATTENTION
	// BOND MOD
	// MQL 11/15/07: need new traversal anims for drones,
	//				 can't use ai anims because they're
	//
	// Initial Anim/Traversal Event
	//---------------------------------------------------------	
	//if I want the guy to do a jump first do that here before continuing the run
	customFirstAnim = undefined;
	//if ( (isdefined(event)) && (event == "jump") )
	//{
	//	customFirstAnim = %jump_across_100;
	//}
	//if ( (isdefined(event)) && (event == "jumpdown") )
	//{
	//	customFirstAnim = %jump_down_56;
	//}
	//if ( (isdefined(event)) && (event == "wall_hop") ) // added by Alex Liu 10/16/07
	//{
	//	customFirstAnim = %traverse_wallhop;
	//}
	//if ( (isdefined(event)) && (event == "step_up") ) // added by Alex Liu 10/16/07
	//{
	//	customFirstAnim = %step_up_low_wall;
	//}

	// BOND MOND
	// MQL 11/15/07: revise calls to new mortar death func
	//
	// Movement Events
	//---------------------------------------------------------
	if (IsDefined(event))
	{
		if (event == "walk")
		{
			// set movement rate and anim
			self.droneRunRate = 75;
			//self.drone_run_cycle = %Thu_Relax_Stand_Walk_Pistol;
			if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
			{
				self.drone_run_cycle = %Gen_Civs_CasualWalk_Female;
				//self.drone_run_cycle = %Civ_CasualWalkV1;
			}
			else
			{
				self.drone_run_cycle = %Civ_CasualWalkV1;
			}

			self.running = false;
			self.animRate = 75;
			// play anim
			self thread ShooterRun_doRunAnim();

			randomAnimRate = undefined;

			//recalculate the distance to the next point since it changed now
			d = distance(self.origin, destinationPoint.origin);
			speed = (d / self.droneRunRate);
		}
		else if (event == "run")
		{
			// set movement rate and anim
			self.droneRunRate = 150;
			self.drone_run_cycle = %Thu_Relax_Stand_Run_Pistol;
			self.running = false;
			self.animRate = 150;
			// play anim
			self thread ShooterRun_doRunAnim();

			randomAnimRate = undefined;

			//recalculate the distance to the next point since it changed now
			d = distance(self.origin, destinationPoint.origin);
			speed = (d / self.droneRunRate);
		}
		else if (event == "sprint")
		{
			// set movement rate and anim
			self.droneRunRate = 200;
			self.drone_run_cycle = %Thu_Alrt_Stand_Sprint_Pistol;
			self.running = false;
			self.animRate = 200;
			// play anim
			self thread ShooterRun_doRunAnim();

			randomAnimRate = undefined;

			//recalculate the distance to the next point since it changed now
			d = distance(self.origin, destinationPoint.origin);
			speed = (d / self.droneRunRate);
		}


		// BOND MOND
		// MQL 11/15/07: revise calls to new mortar death func
		//
		// Mortar/Splosion Death Events
		//---------------------------------------------------------
		//check to see if he's in a low height area
		else if (event == "low_height")
		{
			self.lowheight = true;
		}
		else if (event == "mortardeath_up")
		{
			self thread drone_mortarDeath( AnglesToUp( self.angles ) );
			//self thread drone_mortarDeath("up");
			return;
		}
		else if (event == "mortardeath_forward")
		{
			self thread drone_mortarDeath( AnglesToForward( self.angles ) );
			//self thread drone_mortarDeath("forward");
			return;
		}
		else if (event == "mortardeath_back")
		{
			self thread drone_mortarDeath( vector_multiply( AnglesToForward( self.angles ), -1 ) );
			//self thread drone_mortarDeath("back");
			return;
		}
		else if (event == "mortardeath_left")
		{
			self thread drone_mortarDeath( vector_multiply( AnglesToRight( self.angles ), -1 ) );
			//self thread drone_mortarDeath("left");
			return;
		}
		else if (event == "mortardeath_right")
		{
			self thread drone_mortarDeath( AnglesToRight( self.angles ) );
			//self thread drone_mortarDeath("right");
			return;
		}


		// BOND MOND
		// MQL 11/15/07: revise calls to new mortar death func
		//
		// Shooting/Cover Events
		//---------------------------------------------------------
		else if (event == "shoot")
		{
			// set shooting angle
			forwardVec = anglestoforward(self.angles);
			rightVec = anglestoright(self.angles);
			upVec = anglestoup(self.angles);
			relativeOffset = (300,0,0);
			shootPos = self.origin;
			shootPos += vector_multiply(forwardVec, relativeOffset[0]);
			shootPos += vector_multiply(rightVec, relativeOffset[1]);
			shootPos += vector_multiply(upVec, relativeOffset[2]);
			self.shootTarget = spawn("script_origin",shootPos);
			
			// BOND MOD
			// MQL 11/15/07: removed call to a func that just calls another func
			//self thread ShooterShoot(self.shootTarget);

			// play shoot anim
			self thread ShooterShootThread(self.shootTarget);
			return;
		}
		else if (event == "cover_stand")
		{
			self thread drone_cover(event);
			
			// important waittill: will wait until drone gets this notify before continuing along the path
			self waittill ("drone out of cover");
			
			self setFlaggedAnimKnobAll ( "cover_exit", %Thu_cvrmidtns_stnd_ready2exp_Pistol, %body, 1, .1, 1);
			self waittillmatch("cover_exit", "end");
		}
		else if (event == "cover_crouch")
		{
			self thread drone_cover(event);
			
			// important waittill: will wait until drone gets this notify before continuing along the path
			self waittill ("drone out of cover");
			
			self setFlaggedAnimKnobAll ( "cover_exit", %Thu_cvrmidtns_crch_exp2ready_Pistol, %body, 1, .1, 1);
			self waittillmatch("cover_exit", "end");
		}
		
		// BOND_MOD: Civilian Behaviours
		else if (event == "phone_call")
		{
			self thread civ_action(event);

			self attach( "w_t_sony_phone", "TAG_WEAPON_LEFT" );

			//wait 300;
			self waittill("drone_event_end");
		}
		else if (event == "take_picture")
		{
			self thread civ_action(event);
			self waittill("drone_event_end");
		}
		else if (event == "sit_eating")
		{
			self thread civ_action(event);
			self waittill("drone_event_end");
		}
		else if (event == "sit_talking")
		{
			self thread civ_action(event);
			self waittill("drone_event_end");
		}
		else if (event == "sit_playing_cards")
		{
			self thread civ_action(event);
			self waittill("drone_event_end");
		}
		else if (event == "sit_reading")
		{
			self thread civ_action(event);

			self waittill("drone_event_end");
		}
		else if (event == "stand_talking")
		{
			self thread civ_action(event);
			self waittill("drone_event_end");
		}
		else if (event == "stand_casual")
		{
			self thread civ_action(event);
			self waittill("drone_event_end");
		}
		else if (event == "stand_arms_crossed")
		{
			self thread civ_action(event);
			self waittill("drone_event_end");
		}
		else if (event == "stand_cell_phone")
		{
			self thread civ_action(event);

			self attach( "w_t_sony_phone", "TAG_WEAPON_LEFT" );

			self waittill("drone_event_end");
		}
	}
	
	// Play Initial Anim/Traversal
	if (isdefined(customFirstAnim))
	{
		self.customFirstAnim = true;
		self.running = undefined;
		randomAnimRate = undefined;
		
		//figure out the offset of the animation so the dummy can be moved to the correct spot
		angles = VectorToAngles( destinationPoint.origin - self.origin );
		offset = getcycleoriginoffset( angles, customFirstAnim );
		endPos = self.origin + offset;
		endPos = physicstrace( (endPos + (0,0,64)), (endPos - (0,0,level.traceHeight)) );
		
		t = getanimlength(customFirstAnim);
		assert(t > 0);
		
		//guy does custom anim
		//TREYARCH: changed anim to exisiting ani
		//self clearanim( %combat_run_fast_3, 0 );
		// BOND MOD
		// change to bond run anim
		// MQL 11/6
		self clearanim( self.drone_run_cycle, 0 );
		self notify ("stop_run_anim");
		
		self moveto (endPos, t, 0, 0);
		
		//self animscripted( "drone_custom_anim", self.origin, self.angles, customFirstAnim );
		self setflaggedanimknobrestart( "drone_custom_anim" , customFirstAnim );
		self waittillmatch("drone_custom_anim","end");
		
		self.origin = endPos;
		self notify ("customFirstAnim done");
		
		//recalculate the distance to the next point since it changed now
		d = distance(self.origin, destinationPoint.origin);
		speed = (d/self.droneRunRate);
		
		// BOND MOD
		// MQL 11/15/07: commented out CoD2 special case anim
		//if ( ( (isdefined(event)) && (event == "jumpdown") ) && (level.script == "duhoc_assault") )
		//{
		//	structarray_remove(level.drones[self.team],self);
		//	if(isdefined(self.turrettarget))
		//		self.turrettarget delete();
		//	if(isdefined(self.shootTarget))
		//		self.shootTarget delete();
		//	self detachall();
		//	self delete();
		//	return;
		//}
	}
		
	self.customFirstAnim = undefined;
	
	// actually move the dummies now
	self drone_runto(destinationPoint, speed);

	if (self.drone_hasPath)
	{
		self drone_delay(destinationPoint);
	}

	prof_end("drone_math");
}

// move drone to next point
drone_runto(destinationPoint, totalMoveTime)
{
	//assert(totalMoveTime > 0);	// brianb (12/05/2007): took out this assert because we might be moving to the spawnpoint, and the return handles it.
	if (totalMoveTime < 0.1)
		return;
	//Make several moves to get there, each point tracing to the ground
	//X = (x2-x1) * p + x1
	
	if( !IsDefined( self ) )
	{
		return;
	}

	//drone loops run animation until he gets to his next point
	self thread ShooterRun_doRunAnim();

	// BOND MOD
	// MQL 11/16/07: add a way to stop if finished cowering
	// set endon to reset loop
	self endon( "cower_stop" );

	percentIncrement = 0.1;
	percentage = 0.0;
	incements = (1 / percentIncrement);
	dividedMoveTime = (totalMoveTime * percentIncrement);
	startingPos = self.origin;
	oldZ = startingPos[2];
	for (i=0;i<incements;i++)
	{
		prof_begin("drone_math");
			percentage += percentIncrement;
			x = (destinationPoint.origin[0] - startingPos[0]) * percentage + startingPos[0];
			y = (destinationPoint.origin[1] - startingPos[1]) * percentage + startingPos[1];
			if(self.lowheight == true)
				percentageMark = physicstrace((x,y,destinationPoint.origin[2] + 64), (x,y,destinationPoint.origin[2] - level.traceHeight));		
			else
				percentageMark = physicstrace((x,y,destinationPoint.origin[2] + level.traceHeight), (x,y,destinationPoint.origin[2] - level.traceHeight));
				
			//if drone was told to go up more than level.droneStepHeight(100) units, keep old height
			if ((percentageMark[2] - oldZ) > level.droneStepHeight )
				percentageMark = (percentageMark[0], percentageMark[1], oldZ);
			
			oldZ = percentageMark[2];
		prof_end("drone_math");
		
		//thread drone_debugLine(self.origin, percentageMark, (1,1,1), dividedMoveTime)

		// BOND MOD
		// MQL 11/16/07: pause movement loop for cowering
		while( IsDefined( self )&& IsDefined( self.cower_active ) && ( self.cower_active == true ) )
		{
			wait( 1 );
		}

		// move drone along path
		if( IsDefined( self ) )
		{
			self moveTo (percentageMark, dividedMoveTime, 0, 0);
			wait(dividedMoveTime);
		}
		else
		{
			return;
		}
	}
}

// BOND MOD
// MQL 11/15/07: Not sure what CoD uses these functions for.
//				 Not used by any script so far.
//CreateShooter( spawnFunction , spawnOrigin )
//{
//	if (!isdefined(spawnOrigin))
//		spawnOrigin = (0,0,0);
//	guy = spawn("script_model", spawnOrigin );
//	guy [[spawnFunction]]();
//	
//	guy InitShooter();
//	
//	return guy;
//}
//
//InitShooter()
//{
//	if (!isdefined (self.weaponModel))
//	{
//		self.weapon = "m1garand";
//		weaponModel = getWeaponModel(self.weapon);
//		self attach(weaponModel, "tag_weapon_right");
//    }
//	self.bulletsInClip = weaponClipSize( self.weapon );
//}

// BOND MOD
// MQL 11/15/07: Why make a funcs sole duty to call another func?
//				 This func doesn't even provide any extra functionality or ease of use.
//ShooterShoot( target )
//{
//    self thread ShooterShootThread(target);
//}

// play shooting anim
#using_animtree("fakeShooters");
ShooterShootThread(target)
{
	// clear up any previous shoot threads
    self notify ("Stop shooting");
    self notify ("drone_shooting");

	// set endon
    self endon ("Stop shooting");
    self UseAnimTree(#animtree);
	self.running = undefined;
    self thread aimAtTargetThread ( target, "Stop shooting" );

	// check to see if drone has a weapon
	Assert( IsDefined( self.bulletsInClip ), "Asking Drone to shoot with no weapon attached" );

    shootAnimLength = 0;
    while(isdefined(self))
    {
        if (self.bulletsInClip <= 0)    // Reload
        {
			// get valid weapon
        	weaponModel = getWeaponModel(self.weapon);
        	if (isdefined(self.weaponModel))
        		weaponModel = self.weaponModel;
        	
        	//see if this model is actually attached to this character
        	numAttached = self getattachsize();
        	attachName = [];
        	for (i=0;i<numAttached;i++)
        		attachName[i] = self getattachmodelname(i);
        	
			// BOND MOD
			// ATTENTION
			// MQL 11/15/07: Need to find out if tags are the same for bond
            self detach(weaponModel, "tag_weapon_right");
            self attach(weaponModel, "tag_weapon_left");
			// BOND MOD
			// ATTENTION
			// MQL 11/15/07: used bond pistol reload anim
			self setflaggedanimknoballrestart ( "shootinganim", %Thu_cvrmid_stnd_reload_Pistol, %root, 1, 0.4 );
            //self setflaggedanimknoballrestart ( "shootinganim", %reload_stand_rifle, %root, 1, 0.4 );
           
           	// SCRIPTER_MOD
			// JesseS (3/16/2007 ): took out clipsize call since it's gone now
            //self.bulletsInClip = self animscripts\weaponList::ClipSize();
            self waittillmatch ("shootinganim", "end");
            self detach(weaponModel, "tag_weapon_left");
            self attach(weaponModel, "tag_weapon_right");
        }

        // Aim for a while
        self Set3FlaggedAnimKnobs("no flag", "aim", "stand", 1, 0.3, 1);
        wait 1 + (randomfloat(2));
		
		if (!isdefined(self))
			return;
		
        // And shoot a few times
        numShots = randomint(4)+1;
        if (numShots > self.bulletsInClip)
        {
            numShots = self.bulletsInClip;
        }
        for (i=0; i<numShots; i++)
        {
        	if (!isdefined(self))
				return;
            self Set3FlaggedAnimKnobsRestart("shootinganim", "shoot", "stand", 1, 0.05, 1);
			
			playfxontag(level.drone_muzzleflash, self, "tag_flash");
			if (self.team == "axis")
			{
				// BOND MOD
				// ATTENTION
				// MQL 11/15/07: commented out sounds until we get bond sounds
				// slayback 10/21/07: updated weapon sounds
				//switch( level.campaign )
				//{
				//	case "american":
				//		//self playsound( "weap_type99_fire" );  // no Type 99 sounds yet
				//		break;
				//	case "russian":
				//		self playsound( "weap_kar98k_fire" );
				//		break;
				//	case "british":
				//		self playsound( "weap_kar98k_fire" );
				//		break;
				//}
			}
			else
			{
				// BOND MOD
				// ATTENTION
				// MQL 11/15/07: commented out sounds until we get bond sounds
				// slayback 10/21/07: updated weapon sounds
				//switch(level.campaign)
				//{
				//	case "american":
				//		self playsound ("weap_m1garand_fire");
				//		break;
				//	case "russian":
				//		self playsound ("weap_nagant_fire");
				//		break;
				//	case "british":
				//		self playsound ("weap_enfield_fire");
				//		break;
				//}
            }
            
            self.bulletsInClip--;

            // Remember how long the shoot anim is so we can cut it short in the future.
            if (shootAnimLength==0)
            {
                shootAnimLength = gettime();
                self waittillmatch ("shootinganim", "end");
                shootAnimLength = ( gettime() - shootAnimLength ) / 1000;
            }
            else
            {
                wait ( shootAnimLength - 0.1 + randomfloat(0.3) );
                if (!isdefined(self))
                	return;
            }
        }
    }
}

ShooterRun_doRunAnim(animRateMod)
{
	if ( (isdefined(self.running)) && (self.running == true) )
		return;
	self.running = true;
	if (!isdefined(animRateMod))
		animRateMod = 1.0;
	self endon ("stop_run_anim");
	adjustAnimRate = true;
	
	// BOND MOD
	// MQL 11/16/07: tie animrate modifier to drone, default 200
	if( !IsDefined( self.animRate ) )
	{
		self.animRate = 200;
	}

	// set default run animations
	if( !IsDefined( self.drone_run_cycle ) )
	{
		//self.drone_run_cycle = %Thu_Relax_Stand_Walk_Pistol;
		if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
		{
			self.drone_run_cycle = %Gen_Civs_CasualWalk_Female;
			//self.drone_run_cycle = %Civ_CasualWalkV1;
		}
		else
		{
			self.drone_run_cycle = %Civ_CasualWalkV1;
		}
	}

	while( (isdefined(self.running)) && (self.running == true) )
	{
		// BOND MOD
		// MQL 11/16/07: tie animrate modifier to drone, default 200
		animRate = (self.droneRunRate/self.animRate);
		//animRate = (self.droneRunRate/200);
		
		if (adjustAnimRate)
		{
			animRate = (animRate * animRateMod);
			adjustAnimRate = false;
		}
		//TREYARCH: changed anim to exisiting anim
		//self setflaggedanimknobrestart( "drone_run_anim" , %combat_run_fast_3, 1, .1, animRate );
		//self waittillmatch("drone_run_anim","end");
		//TREYARCH: changed anim to exisiting anim
		//self clearanim( %combat_run_fast_3, 0 );
		// BOND MOD
		// MQL 11/15/07: change to bond run anim

		if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
		{
			//print3d (self.origin + (0,0,70), "Walk Female", (1, .07, .57), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		}
		else
		{
			//print3d (self.origin + (0,0,70), "Walk", (.39, .58, .92), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		}

		self setflaggedanimknobrestart( "drone_run_anim" , self.drone_run_cycle, 1, .1, animRate );
		self waittillmatch("drone_run_anim","end");
		//self clearanim( self.drone_run_cycle, 0 );

		if (!isdefined(self))
			return;
	}
}

debugDummyLines(dummy, dummy_trace)
{
	dummy endon ("stop_debug_line");
	dummy_trace endon ("stop_debug_line");
	for (;;)
	{
		// SCRIPTER_MOD
		// JesseS (3/16/2007 ): added get players, and check against only first player instead of level.player
		//players = get_players();

		// BOND MOD
		// set players to level.player since we don't have co-op
		// MQL 11/5
		players = level.player;
		line( players[0].origin + (0,0,20), dummy.origin, (1,1,1) );
		line( players[0].origin + (0,0,20), dummy_trace.origin, (1,0,0) );
		wait 0.05;
	}
}

drone_debugLine(fromPoint, toPoint, color, durationFrames)
{
    for (i=0;i<durationFrames*20;i++)
    {
        line (fromPoint, toPoint, color);
        wait (0.05);
    }
}

// rotate drone to face next point
turnToFacePoint(point, speed)
{
    // TODO Make this turn gradually, not instantly.
	desiredAngles = VectorToAngles( point - self.origin );
	
	if (!isdefined( speed ))
		speed = 0.5;
	else if (speed > 0.5)
		speed = 0.5;
	
	if (speed < 0.1)
		return;
	
	self rotateTo((0,desiredAngles[1],0), speed, 0, 0);
}

anglesToPoint(point)
{
	desiredAngles = VectorToAngles( point - self.origin );
    return (0,desiredAngles[1],0);
}

//---------------------------------------------------------------------------------------------------------------

// blend 3 anims together
Set3FlaggedAnimKnobs(animFlag, animArray, pose, weight, blendTime, rate)
{
	if (!isdefined(self))
		return;
    self setAnimKnob(%combat_directions, weight, blendTime, rate);
    self SetFlaggedAnimKnob(animFlag,    level.drone_animArray[animArray][pose]["up"],			1, blendTime, 1);
    self SetAnimKnob(                    level.drone_animArray[animArray][pose]["straight"],    1, blendTime, 1);
    self SetAnimKnob(                    level.drone_animArray[animArray][pose]["down"],        1, blendTime, 1);
}

// blend 3 anims together
Set3FlaggedAnimKnobsRestart(animFlag, animArray, pose, weight, blendTime, rate)
{
	if (!isdefined(self))
		return;
    self setAnimKnobRestart(%combat_directions, weight, blendTime, rate);
    self SetFlaggedAnimKnobRestart(animFlag,	level.drone_animArray[animArray][pose]["up"],			1, blendTime, 1);
    self SetAnimKnobRestart(					level.drone_animArray[animArray][pose]["straight"],		1, blendTime, 1);
    self SetAnimKnobRestart(					level.drone_animArray[animArray][pose]["down"],			1, blendTime, 1);
}

// blend aiming anims groups set in animtree fakeShooters
applyBlend (offset)
{
    if (offset < 0)
    {
        unstraightAnim = %combat_down;
        self setanim( %combat_up,        0.01,    0, 1);
        offset *= -1;
    }
    else
    {
        unstraightAnim = %combat_up;
        self setanim( %combat_down,        0.01,    0, 1);
    }
    if (offset > 1)
        offset = 1;
    unstraight = offset;
    if (unstraight >= 1.0)
        unstraight = 0.99;
    if (unstraight <= 0)
        unstraight = 0.01;
    straight = 1 - unstraight;
    self setanim( unstraightAnim,         unstraight,    0, 1);
    self setanim( %combat_straight,        straight,    0, 1);
}    

// rotate drone to aim at target
aimAtTargetThread( target, stopString )
{
    self endon (stopString);
    while(isdefined(self))
    {
        targetPos = target.origin;
        turnToFacePoint(targetPos);
        offset = getTargetUpDownOffset(targetPos);
        applyBlend(offset);
        wait (0.05);
    }
}

// get vertical offset for aiming
getTargetUpDownOffset(target)
{
    pos = self.origin;// getEye();
    dir = (pos[0] - target[0], pos[1] - target[1], pos[2] - target[2]);
    dir = VectorNormalize( dir );
    fact = dir[2] * -1;
    return fact;
}

// set up array of shooting anims found in animtree fakeShooters
setAnimArray()
{
    level.drone_animArray["aim"]    ["stand"] ["down"]			= %Thu_stnd_aim_dn_Pistol;
    level.drone_animArray["aim"]    ["stand"] ["straight"]		= %Thu_stnd_aim_mid_Pistol;
    level.drone_animArray["aim"]    ["stand"] ["up"]			= %Thu_stnd_aim_up_Pistol;

    level.drone_animArray["aim"]    ["crouch"]["down"]			= %Thu_crouch_aim_dn_Pistol;
    level.drone_animArray["aim"]    ["crouch"]["straight"]		= %Thu_crouch_aim_mid_Pistol;
    level.drone_animArray["aim"]    ["crouch"]["up"]			= %Thu_crouch_aim_up_Pistol;

	level.drone_animArray["auto"]    ["stand"] ["down"]			= %Thu_stnd_aim_dnfire_Pistol;
	level.drone_animArray["auto"]    ["stand"] ["straight"]		= %Thu_stnd_aim_midfire_Pistol;
	level.drone_animArray["auto"]    ["stand"] ["up"]			= %Thu_stnd_aim_upfire_Pistol;

	level.drone_animArray["auto"]    ["crouch"]["down"]			= %Thu_crouch_aim_dnfire_Pistol;
	level.drone_animArray["auto"]    ["crouch"]["straight"]		= %Thu_crouch_aim_midfire_Pistol;
	level.drone_animArray["auto"]    ["crouch"]["up"]			= %Thu_crouch_aim_upfire_Pistol;

    level.drone_animArray["shoot"]    ["stand"] ["down"]		= %Thu_stnd_aim_dnfire_Pistol;
    level.drone_animArray["shoot"]    ["stand"] ["straight"]	= %Thu_stnd_aim_midfire_Pistol;
    level.drone_animArray["shoot"]    ["stand"] ["up"]			= %Thu_stnd_aim_upfire_Pistol;

	level.drone_animArray["shoot"]    ["crouch"]["down"]		= %Thu_crouch_aim_dnfire_Pistol;
	level.drone_animArray["shoot"]    ["crouch"]["straight"]	= %Thu_crouch_aim_midfire_Pistol;
	level.drone_animArray["shoot"]    ["crouch"]["up"]			= %Thu_crouch_aim_upfire_Pistol;
}

// setup cover anims to play
drone_cover(type)
{
	self endon ("drone_stop_cover");
		
	if( !IsDefined( self.a ) )
	{
		self.a = SpawnStruct(); 
	}
	
	self.running = undefined;
	
	anim_array = [];
			
	if (type == "cover_stand")
	{
		// BOND MOD
		// MQL 11/15/07: replace anim with bond anim
		anim_array["hide_idle"] = %Thu_cvrmid_stnd_idlready_Pistol;
		anim_array["hide_idle_twitch"] = array(	%Thu_cvrmid_stnd_peekup_Pistol,
												%Thu_cvrmidtns_stnd_ready2blindfire_Rifle,
												%Thu_cvrmidtns_stnd_blindfire2ready_Pistol );

		anim_array["hide_idle_flinch"] = array(	%Thu_Stand_Pain_HtReact_ChestHead_Pistol,
												%Thu_Stand_Pain_HtReact_RShoulder_Pistol,
												%Thu_Stand_Pain_HtReact_LShoulder_Pistol,
												%Thu_Stand_Pain_HtReact_RHand_Pistol );

		//anim_array["hide_idle"] = %coverstand_hide_idle;
		//anim_array["hide_idle_twitch"] = array(
		//%coverstand_hide_idle_twitch01,
		//%coverstand_hide_idle_twitch02,
		//%coverstand_hide_idle_twitch03,
		//%coverstand_hide_idle_twitch04,
		//%coverstand_hide_idle_twitch05
		//);
	
		//anim_array["hide_idle_flinch"] = array(
		//%coverstand_react01,
		//%coverstand_react02,
		//%coverstand_react03,
		//%coverstand_react04
		//);
		
		self.a.array = anim_array;	
		
		self setFlaggedAnimKnobAllRestart ( "cover_approach", %Thu_cvrmidtns_stnd_exp2ready_Pistol, %body, 1, .3, 1);
		self waittillmatch("cover_approach", "end");
		
		self thread drone_cover_think();
	}
	else if (type == "cover_crouch")
	{	
		// BOND MOD
		// MQL 11/15/07: replace anim with bond anim
		anim_array["hide_idle"] = %Thu_cvrlt_crch_idlready_Pistol;
		anim_array["hide_idle_twitch"] = array(	%Thu_cvrlt_crch_peekup_Pistol,
												%Thu_cvrmidtns_crch_ready2blindfire_Pistol,
												%Thu_cvrmidtns_crch_blindfire2ready_Pistol );

		//anim_array["hide_idle"] = %covercrouch_hide_idle;
		//anim_array["hide_idle_twitch"] = array(
		//%covercrouch_twitch_1,
		//%covercrouch_twitch_2,
		//%covercrouch_twitch_3,
		//%covercrouch_twitch_4
		//);
		
		self.a.array = anim_array;	
		
		self setFlaggedAnimKnobAllRestart ( "cover_approach", %Thu_cvrmidtns_crch_ready2exp_Pistol, %body, 1, .3, 1);
		self waittillmatch("cover_approach", "end");
		
		self thread drone_cover_think();	
	}
	else if (type == "conceal_stand")
	{
	}
	else if (type == "conceal_crouch")
	{
	}
}

// random cover anim to play
drone_cover_think()
{
	self endon ("drone_stop_cover");
		
	while( 1 )
	{
		useTwitch = (randomint(2) == 0);
		if ( useTwitch )
			idleanim = animArrayPickRandom("hide_idle_twitch");
		else
			idleanim = animarray("hide_idle");
		
		self drone_playIdleAnimation( idleAnim, useTwitch );
	}
}

// play cover anim
drone_playIdleAnimation( idleAnim, needsRestart, alt )
{
	self endon ("drone_stop_cover");
	self endon ("drone_stop_idle");
	
	if (IsDefined(alt) && alt)
	{
		self setFlaggedAnimKnobRestart("idle", idleAnim);
	}
	else if ( needsRestart )
	{
		self setFlaggedAnimKnobAllRestart( "idle", idleAnim, %body, 1, .1, 1);
	}
	else
	{
		self setFlaggedAnimKnobAll       ( "idle", idleAnim, %body, 1, .1, 1);
	}
	
	if (IsDefined(self.a))
	{
		self.a.coverMode = "hide";
	}
	
	self waittillmatch("idle", "end");
}


///////////////////////////////////////////////////////////////////
// BOND MOD
//
// All Bond specific Functions go below.
//	- Add new events to ShooterRun functions
//	- new key for trigger script_perfectsense sets if drones cower (default true)
//
///////////////////////////////////////////////////////////////////

// drone non-explosion ragdoll 
drone_bulletDeath( vDirection, vOrigin, fMagnitude )
{
	// unlink drone
	self unlink();

	// set default origin, damage, and direction
	if( !IsDefined( vDirection ) )
	{
		vDirection = vector_random( 10, 10, 10 );
	}
	if( !IsDefined( vOrigin ) )
	{
		vOrigin = self.origin;
	}
	if( !IsDefined( fMagnitude ) )
	{
		fMagnitude = 75;
	}

	// set drone in ragdoll & start physics
	self StartRagDoll();
	wait( 0.1 );
	PhysicsJolt( vOrigin, 256, 128, vector_multiply( vDirection, fMagnitude ) );
	
	// remove drone 
	self drone_doDeath();
	wait( 3 );
	if( IsDefined( self ) )
	{
		self moveto(self.origin - (0,0,100), 7);
	}
	wait( 7 );
	self drone_delete();
}

// drone cowering check
drone_cower()
{
	// check validity of drone
	if( !IsDefined( self ) )
	{
		return;
	}

	// endon conditions
	self endon( "damage" );

	// set default state of cowering
	if( !IsDefined( self.cower_active ) )
	{
		self.cower_active = false;
	}

	// loop to check to see if drone can see bond wpn
	while( IsDefined( self ) )
	{
		if( !IsDefined( self ) )
		{
			return;
		}

		// LOS check
		if( !sightTracePassed( self.origin + (0, 0, 32), level.player.origin, false, undefined ) )
		{
			self.cower_active = false;
			sWpn = undefined;
			wait( 1 );
			continue;
		}
		
		// check for Bonds weapon & cower if weapon unholstered
		sWpn = level.player GetCurrentWeapon();
		if( !IsDefined( sWpn ) || (sWpn == "")  || (sWpn == "phone")  || (sWpn == "none"))
		{
			self.cower_active = false;
		}
		else
		{
			if( !self.cower_active )
			{
				self thread drone_cower_anim();
			}
			self.cower_active = true;
		}
		wait( 1 );
	}
}

// drone cowering animation
drone_cower_anim()
{
	// check validity of drone
	if( !IsDefined( self ) )
	{
		return;
	}

	// endon conditions
	self endon( "damage" );

	// stop drone from moving if valid
	if( IsDefined( self.running ) && ( self.running == true ) )
	{
		// calculate point ahead of drone to move and stop at
		vGoalPos = self.origin + vector_multiply( AnglesToForward( self.angles ), 36 );
		self MoveTo( vGoalPos, 2, 0, 1 );
		self waittill( "movedone" );

		// stop locomotion anim
		self.running = false;
		self clearanim( self.drone_run_cycle, 0.5 );
	}
	wait( 0.5 );

	//cycle drone anim until players weapon disappears
	while( IsDefined( self.cower_active ) && ( self.cower_active == true ) )
	{
		// check validity of drone
		if( !IsDefined( self ) )
		{
			return;
		}

		// cycle cower anim
		self setflaggedanimknobrestart( "drone_cower_anim" , %Thu_cvrlt_crch_peekup_Pistol, 1, .2, 1 );
		self waittillmatch("drone_cower_anim", "end");

		// check validity of drone
		if( !IsDefined( self ) )
		{
			return;
		}
	}

	// check validity of drone
	if( !IsDefined( self ) )
	{
		return;
	}
	self.cower_active = false;

	// notify cower stop
	self notify( "cower_stop" );

	// sprint back to original destination or resume normal behavior
	if( !IsDefined(self._event) || (self._event == "walk") || (self._event == "run") || (self._event == "sprint" ) )
	{
		self ShooterRun( self._destinationPoint, "sprint" );
	}
	else if( self._event == "end_chain" )
	{
		return;
	}
	else
	{
		self ShooterRun( self._destinationPoint, self._event );
	}
}


// drone friendly fire check
drone_friendlyfire()
{
	bFriendlyFire = false;

	while( true )
	{
		// wait for damage
		self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, iType, sModelName, sAttachTag, sTagName ); 

		// if we dont know who the attacker is we can't do much, so ignore it. This is seldom to happen, but not impossible
		if( !IsDefined(sAttacker) )
			continue;

		// check to see if the death was caused by the player or the players turret
		if( sAttacker == level.player )
		{
			bFriendlyFire = true;
		}
		else if( IsDefined( sAttacker.classname ) && ( sAttacker.classname == "script_vehicle" ) )
		{
			entOwner = sAttacker GetVehicleOwner();
			if( IsDefined( entOwner ) && ( entOwner == level.player ) )
				bFriendlyFire = true;
		}

		if( bFriendlyFire )
		{
			// call mission fail
			maps\_utility::missionFailedWrapper();
		}
	}
}


// drone bump check
drone_bump()
{
	// check validity of drone
	if( !IsDefined( self ) )
	{
		return;
	}

	// endon conditions
	self endon( "damage" );

	// loop to check to see if drone can see bond wpn
	while( IsDefined( self ) )
	{
		// check to see if drone is running or cowering
		if( (IsDefined( self.running )) && (self.running == true) )
		{
			wait( 0.1 );
			continue;
		}
		if( (IsDefined( self.cower_active )) && (self.cower_active == true) )
		{
			wait( 0.1 );
			continue;
		}

		// check to if player is bumping against the drone
		if( (Distance( self.origin, level.player.origin ) < 32) && (level.player GetSpeed() > 40 ) )
		{
			// play drone collision animation
			///#
			//	if( GetDVarInt( "secr_camera_debug" ) == 1 )
			//	{	
			//		Print3d( self.origin + (0, 0, 64), Distance( self.origin, level.player.origin )+ " " + level.player GetSpeed(), (0, 1, 0), 1, 1, 45 );
			//	}
			//#/
			//wait( 1.5 );
			//self drone_bump_anim();
		}
		else
		{
			// play drone collision animation
			///#
			//	if( GetDVarInt( "secr_camera_debug" ) == 1 )
			//	{	
			//		Print3d( self.origin + (0, 0, 64), Distance( self.origin, level.player.origin )+ " " + level.player GetSpeed(), (1, 0, 0), 1, 1, 45 );
			//	}
			//#/
			wait( 0.1 );
		}
	}
}

// play bump animation
drone_bump_anim()
{

	// get original point
	vecTarget = self.origin + vector_multiply( AnglesToForward( self.angles ), 36 );

	// player bump animation
	self setflaggedanimknobrestart( "drone_bump_anim" , %Thu_Stand_Pain_HtReactHvy_RShoulder_Pistol, 1, .2, 1 );
	self waittillmatch("drone_bump_anim", "end");

	// turn to face bond
	self turnToFacePoint(level.player.origin, 0.5);

	// play bump reaction animation
	self setflaggedanimknobrestart( "drone_react_anim" , %Thu_Alrt_Stand_Idl_Pistol, 1, .2, 1 );
	self waittillmatch("drone_react_anim", "end");

	// clear previous animation
	self clearanim( %Thu_Alrt_Stand_Idl_Pistol, 0.5 );
	self notify( "drone_idle_anim", "end" );
	self notify( "idle", "end" );

	// turn to face original direction
	self turnToFacePoint(vecTarget, 0.5);
}

// function waiting for level notification "delete_drones" to delete
drone_wait_for_delete()
{
	level waittill( "delete_drones" );
	if( IsDefined( self ) )
	{
		self Delete();
	}
}

facialAnimWatcher()
{
	self endon("drone_stop_event");
	self endon("death");

	animRunning = false;
	while( 1 )
	{
		//print3d( self.origin, "o", (1,1,1) );

		if( isdefined(self.doFacialAnim) && self.doFacialAnim == true )
		{
			if( !animRunning )
			{
				//iprintlnbold("start face anim");

				self setFlaggedAnimKnobRestart("face", %Thu_Fac_Speak, 1.0, 0.1, 1.0 );

				animRunning = true;
			}
		}
		else if( animRunning )
		{
			//iprintlnbold("stop face anim");

			animRunning = false;

			self clearAnim( %Thu_Fac_Speak, 0.0 );
		}

		wait(0.05);
	}
}


// BOND_MOD: Civilian Behavours //////////////////////
civ_action(type)
{
	self endon("drone_stop_event");
	
	if( !IsDefined( self.a ) )
	{
		self.a = SpawnStruct(); 
	}
	self.a.coverMode = "hide";

	self thread facialAnimWatcher();

	//iprintlnbold("civ_action: " + type);
	
	switch (type)
	{
		case "phone_call": phone_call(); break;
		case "take_picture": take_picture(); break;
		case "sit_eating": sit_eating(); break;
		case "sit_talking": sit_talking(); break;
		case "sit_playing_cards": sit_playing_cards(); break;
		case "sit_reading": sit_reading(); break;
		case "stand_talking": stand_talking(); break;
		case "stand_casual": stand_casual(); break;
		case "stand_arms_crossed": stand_arms_crossed(); break;
		case "stand_cell_phone": stand_cell_phone(); break;
		default: assertmsg("not a valid civ action");
	}
	
	//self civ_action_end();
	self notify("drone_event_end");
}

phone_call()
{
	if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
	{
		//print3d (self.origin + (0,0,70), "Phone Call Female", (1, .07, .57), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["phone_call"] = array( %Gen_Civs_CellPhoneTalk_Female );
	}
	else
	{
		//print3d (self.origin + (0,0,70), "Phone Call", (.39, .58, .92), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["phone_call"] = array( %Gen_Civs_CellPhoneTalk );
	}
	
	self.a.array = anim_array;	
	while (1)
	{
		idleAnim = animArrayPickRandom("phone_call");
		self setFlaggedAnimKnobRestart("idle", idleAnim, 0.01, 0.2, 1.0);
		self waittillmatch("idle", "end");

	}
}

take_picture()
{
	if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
	{
		//print3d (self.origin + (0,0,70), "Taking Picture Female", (1, .07, .57), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["take_picture"] = array(	%Gen_Civs_PicTaking_Female );
	}
	else
	{
		//print3d (self.origin + (0,0,70), "Taking Picture", (.39, .58, .92), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["take_picture"] = array(	%Gen_Civs_PicTaking );
	}
	
	self.a.array = anim_array;	
	idleAnim = animArrayPickRandom("take_picture");
	
	while( 1 )
	{
		self setFlaggedAnimKnobRestart("idle", idleAnim);
		self waittillmatch("idle", "end");
	}
}

sit_eating()
{
	if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
	{
		//print3d (self.origin + (0,0,70), "Sit Eating Female", (1, .07, .57), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["sit_eating"] = array( %Gen_Civs_SitEating_Female );
	}
	else
	{
		//print3d (self.origin + (0,0,70), "Sit Eating", (.39, .58, .92), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["sit_eating"] = array( %Gen_Civs_SitEating );
	}
	
	self.a.array = anim_array;	
	idleAnim = animArrayPickRandom("sit_eating");

	while(1)
	{
		self setFlaggedAnimKnobRestart("idle", idleAnim);
		self waittillmatch("idle", "end");	
	}
}

sit_talking()
{
	if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
	{
		//print3d (self.origin + (0,0,70), "Sit Talking Female", (1, .07, .57), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["sit_talking"] = array( %Gen_Civs_SitConversation_A_Female, %Gen_Civs_SitConversation_B_Female, %Gen_Civs_SitConversation_Listen_Female );
	}
	else
	{
		//print3d (self.origin + (0,0,70), "Sit Talking", (.39, .58, .92), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["sit_talking"] = array( %Gen_Civs_SitConversation_A, %Gen_Civs_SitConversation_B, %Gen_Civs_SitConversation_Listen );
	}
	
	self.a.array = anim_array;	
	idleAnim = animArrayPickRandom("sit_talking");

	while(1)
	{
		self setFlaggedAnimKnobRestart("idle", idleAnim, 0.01, 0.2, 1.0);
		self waittillmatch("idle", "end");	
	}
}

sit_playing_cards()
{
	//print3d (self.origin + (0,0,70), "Playing Cards", (1,0,0), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
	anim_array["sit_playing_cards"] = array( %Gen_Civs_SeatedPlayingCards_A, %Gen_Civs_SeatedPlayingCards_C );
	
	self.a.array = anim_array;	
	idleAnim = animArrayPickRandom("sit_playing_cards");

	while(1)
	{
		self setFlaggedAnimKnobRestart("idle", idleAnim);
		self waittillmatch("idle", "end");	
	}
}

sit_reading()
{
	if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
	{
		//print3d (self.origin + (0,0,70), "Sit Reading Female", (1, .07, .57), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["sit_reading"] = array( %Gen_Civs_SitReading_B_Female, %Gen_Civs_SitReading_C_Female );
	}
	else
	{
		//print3d (self.origin + (0,0,70), "Sit Reading", (.39, .58, .92), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["sit_reading"] = array( %Gen_Civs_SitReading_B, %Gen_Civs_SitReading_C );
	}
	
	self.a.array = anim_array;	
	idleAnim = animArrayPickRandom("sit_reading");

	while(1)
	{
		self setFlaggedAnimKnobRestart("idle", idleAnim);
		self waittillmatch("idle", "end");	
	}
}

stand_talking()
{
	if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
	{
		//print3d (self.origin + (0,0,70), "Stand Talking Female", (1, .07, .57), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["stand_talking"] = array( %Gen_Civs_CasualStand_Female, %Gen_Civs_StndArmsCrossed_Female );
	}
	else
	{
		//print3d (self.origin + (0,0,70), "Stand Talking", (.39, .58, .92), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["stand_talking"] = array( %Gen_Civs_CasualStand, %Gen_Civs_StndArmsCrossed );
	}	

	self.a.array = anim_array;	
	idleAnim = animArrayPickRandom("stand_talking");

	while(1)
	{
		self setFlaggedAnimKnobRestart("idle", idleAnim, 0.01, 0.2, 1.0 );
		self waittillmatch("idle", "end");
	}
}

stand_casual()
{
	if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
	{
		//print3d (self.origin + (0,0,70), "Stand Casual Female", (1, .07, .57), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["stand_casual"] = array(	%Gen_Civs_CasualStand_Female, %Gen_Civs_StndArmsCrossed_Female );
	}
	else
	{
		//print3d (self.origin + (0,0,70), "Stand Casual", (.39, .58, .92), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["stand_casual"] = array(	%Gen_Civs_CasualStand, %Gen_Civs_StndArmsCrossed );
	}
	
	self.a.array = anim_array;	
	idleAnim = animArrayPickRandom("stand_casual");

	while(1)
	{
		self setFlaggedAnimKnobRestart("idle", idleAnim);
		self waittillmatch("idle", "end");	
	}
}

stand_arms_crossed()
{
	if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
	{
		//print3d (self.origin + (0,0,70), "Stand Arms Crossed Female", (1, .07, .57), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["stand_arms_crossed"] = array( %Gen_Civs_StndArmsCrossed_Female );
	}
	else
	{
		//print3d (self.origin + (0,0,70), "Stand Arms Crossed", (.39, .58, .92), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["stand_arms_crossed"] = array( %Gen_Civs_StndArmsCrossed );
	}
	
	self.a.array = anim_array;	
	idleAnim = animArrayPickRandom("stand_arms_crossed");

	while(1)
	{
		self setFlaggedAnimKnobRestart("idle", idleAnim);
		self waittillmatch("idle", "end");	
	}
}

stand_cell_phone()
{
	if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
	{
		//print3d (self.origin + (0,0,70), "Stand Cell Phone Female", (1, .07, .57), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["stand_cell_phone"] = array(	%Gen_Civs_CellPhoneTalk_Female );
	}
	else
	{
		//print3d (self.origin + (0,0,70), "Stand Cell Phone", (.39, .58, .92), 1, 1.5, 300);	// origin, text, RGB, alpha, scale
		anim_array["stand_cell_phone"] = array(	%Gen_Civs_CellPhoneTalk );
	}
	
	self.a.array = anim_array;	
	idleAnim = animArrayPickRandom("stand_cell_phone");

	while(1)
	{
		self setFlaggedAnimKnobRestart("idle", idleAnim, 0.01, 0.2, 1.0);
		self waittillmatch("idle", "end");	
	}
}


//**************************************************************
//**************************************************************

// head tracking thread
drone_headtrack()
{
	self endon( "damage" );

	while( IsDefined( self ) )
	{
		// check to if player is in range of player
		if( Distance( self.origin, level.player.origin ) < 256 )
		{
			Drone_StartLookAt(level.player, 0.2, 2);
			wait( 9 );
		}
		else
		{
			wait( 0.1 );
		}
	}
}

Drone_UpdateLookAt()
{
	self endon("death");
	self endon ("drone_death");
	//self endon ("drone_shooting");
	while(1)
	{
		if ( (isdefined(self.qEnableLookAt)) && (self.qEnableLookAt == 1) )
		{
			if( isdefined(self.m_LookAtDuration) 
			&& isdefined(self.m_LookAtLerpTime) 
			&& isdefined(self.m_LookAtEnt) 
			&& isdefined(self.m_LookAtYaw) 
			&& isdefined(self.m_LookAtPitch) 
			&& isdefined(self.m_LookAtTime) )
			{

				//This angle limit would better be set outside, and based on the specific animation
				maxLookAtRotYaw = 60.0;
				minLookAtRotYaw = -60.0;
				maxLookAtRotPitch = 45.0;
				minLookAtRotPitch = -45.0;

				
				//DRONE_TODO: will use tag_eye for drone lookAt once drone model has the tag_eye bone 
				//headPos = self gettagorigin("head");
				//headAng = self gettagangles("head");
		
				headPos = self gettagorigin("tag_eye");
				headAng = self gettagangles("tag_eye");

				lookAtPos = ( 0.0, 0.0, 0.0 );
				relAng = ( 0.0, 0.0, 0.0 );

				if( issentient( self.m_LookAtEnt ) )
				{
					lookAtPos = self.m_LookAtEnt geteye();
				}
				else
				{
					lookAtPos = self.m_LookAtEnt.origin;
				}

				if( isdefined(headPos) && isdefined(headAng) && isdefined(lookAtPos))
				{
					relAng = CalcAngleAround(headPos, lookAtPos, headAng);
				}
				else
				{
					relAng = ( 0.0, 0.0, 0.0 );
				}
				
				clampedYaw		= 0.0;
				clampedPitch	= 0.0;

				//clamp the value within [minLookAtRotYaw, maxLookAtRotYaw]
				if(relAng[1] < minLookAtRotYaw)
				{
					clampedYaw = minLookAtRotYaw;
				}
				else if (relAng[1] > maxLookAtRotYaw)
				{
					clampedYaw = maxLookAtRotYaw;
				}
				else
				{
					clampedYaw = relAng[1];
				}
				
				//clamp the value within [minLookAtRotYaw, maxLookAtRotYaw]
				if(relAng[0] < minLookAtRotPitch)
				{
					clampedPitch = minLookAtRotPitch;
				}
				else if (relAng[0] > maxLookAtRotPitch)
				{
					clampedPitch = maxLookAtRotPitch;
				}
				else
				{
					clampedPitch = relAng[0];
				}


				dampK = Drone_GetLookAtDampK(self.m_LookAtTime);

				if ( self.m_LookAtTime > (self.m_LookAtDuration - self.m_LookAtLerpTime) )
				{
					//End of lookAt
					if ( self.m_LookAtYaw > -0.5 && self.m_LookAtYaw < 0.5 )
					{
						self Drone_StopLookAt();
					}
					else
					{
						self.m_LookAtYaw =  dampK * self.m_LookAtYaw ;
						self.m_LookAtPitch = dampK * self.m_LookAtPitch;

						//self.m_LookAtYaw =  dampK * clampedYaw ;
						//self.m_LookAtPitch = dampK * clampedPitch;


					}
				}
				else 
				{

					self.m_LookAtYaw	= (clampedYaw * ( 1.0 - dampK ) + self.m_LookAtYaw * dampK);
					self.m_LookAtPitch	= (clampedPitch * ( 1.0 - dampK ) + self.m_LookAtPitch * dampK);
				}			

				self DroneUpdateLookAtInfo(self.qEnableLookAt, self.m_LookAtYaw, self.m_LookAtPitch);
				self.m_LookAtTime += 0.05;
			}
		}

		wait(0.05);
	}
}

//**************************************************************
//**************************************************************

Drone_GetLookAtDampK( lookAtTime)
{
		dampVal = 0.0;
		if (lookAtTime < self.m_LookAtLerpTime) 
		{
			// AI LOOKAT Start
			dampVal = lookAtTime/self.m_LookAtLerpTime;
			dampVal = 1.0 - (2.0*dampVal) + dampVal * dampVal; 
		}
		else if ( lookAtTime < (self.m_LookAtDuration - self.m_LookAtLerpTime))
		{
			// AI LOOKING AT 
			dampVal = 1.0;
		}
		else
		{
			//AI LOOKAT End
			dampVal = ( lookAtTime - self.m_LookAtDuration  + self.m_LookAtLerpTime ) / self.m_LookAtLerpTime;
			dampVal = 1.0 - dampVal * dampVal; 
		}

		//clamp the value within [0.0 - 1.0]
		if(dampVal < 0.0)
		{
			dampVal = 0.0;
		}
		else if (dampVal > 1.0)
		{
			dampVal = 1.0;
		}

		return dampVal;
}

//**************************************************************
//**************************************************************

Drone_StartLookAt(lookAtEntity, lookAtDuration, lookAtLerpTime)
{
	self endon("death");
	self endon ("drone_death");
	//self endon ("drone_shooting");
	if( ( !isdefined( self.qEnableLookAt ) ) || (( isdefined( self.qEnableLookAt ) && self.qEnableLookAt == 0 )) )
	{
		self.qEnableLookAt = 1;
		self.m_LookAtDuration	= (lookAtDuration + lookAtLerpTime + lookAtLerpTime);
		self.m_LookAtLerpTime	= lookAtLerpTime;
		self.m_LookAtEnt		= lookAtEntity;
		self.m_LookAtTime		= 0.0;
		self.m_LookAtYaw		= 0.0;
		self.m_LookAtPitch		= 0.0;
	}
}

//**************************************************************
//**************************************************************

Drone_StopLookAt( )
{
	self endon("death");
	self endon ("drone_death");
	//self endon ("drone_shooting");
	if( isdefined( self.qEnableLookAt ) )
	{
		self.qEnableLookAt = 0;
		self.m_LookAtDuration	= 0.0;
		self.m_LookAtLerpTime	= 0.0;
		self.m_LookAtTime		= 0.0;
		self.m_LookAtYaw		= 0.0;
		self.m_LookAtPitch		= 0.0;
	}

}

//**************************************************************
//**************************************************************
//Test code for Drone LookAt
startLookAt()
{
	self endon("death");
	self endon ("drone_death");

	wait (3);
	Drone_StartLookAt(level.player, 1, 1);
}
