
















































#include maps\_utility;


#include animscripts\Utility;


#include animscripts\shared;
#include common_scripts\Utility;

init()
{
	
	
	

	
	setAnimArray();
	level.drone_impact		= loadfx ("impacts/flesh_hit");
	level.drone_muzzleflash = loadfx ("weapon/p99_discharge_a");
	
	
	if (!isdefined(level.traceHeight))
		level.traceHeight = 400;
	
	if (!isdefined(level.droneStepHeight))
		level.droneStepHeight = 100;
	
	
	if(!isdefined(level.max_drones))
		level.max_drones = [];
	
	
	
	
	
	
	if(!isdefined(level.max_drones["civilian"]))
		level.max_drones["civilian"] = 99999;

	
	if(!isdefined(level.drones))
		level.drones = [];
	
	
	
	
	
	
	if(!isdefined(level.drones["civilian"]))
		level.drones["civilian"] = struct_arrayspawn();

	
	init_struct_targeted_origins();

	
	
	
	
	
	array_thread (getentarray("drone_civs","targetname"), ::drone_triggers_wait_civs );
	
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





drone_triggers_wait_civs()
{
	
	self build_struct_targeted_origins();
	
	
	
	
	qHeadTrack = true;
	if ( (isdefined(self.script_sightrange)) && (self.script_sightrange == 0) )
	{
		qHeadTrack = false;
	}

	
	qFakeDeath = true;
	if ( (isdefined(self.script_allowdeath)) && (self.script_allowdeath == 0) )
	{
		qFakeDeath = false;
	}

	
	qSightTrace = false;
	if ( (isdefined(self.script_trace)) && (self.script_trace > 0) )
	{
		qSightTrace = true;
	}
	
	
	
	
	qCower = true;
	if ( (isdefined(self.script_perfectsense)) && (self.script_perfectsense == 0) )
	{
		qCower = false;
	}

	
	
	
	qFriendlyFire = false;
	if ( (isdefined(self.script_ignoreme)) && (self.script_ignoreme > 0) )
	{
		qFriendlyFire = true;
	}

	
	
	qBump = true;
	if( (IsDefined(self.script_fallback)) && (self.script_fallback == 0) )
	{
		qBump = false;
	}

	
	assert(isdefined(self.targeted));
	assert(isdefined(self.targeted[0]));
	
	
	spawnPoint = self.targeted;
	assert(isdefined(spawnPoint[0]));
	
	
	if( IsDefined( self.script_ender ) )
	{
		level endon( self.script_ender );
	}
	
	
	self waittill ("trigger");
	
	
	if (!isdefined (self.script_repeat))
	{
		repeat_times = 999999;
	}
	else
	{
		repeat_times = self.script_repeat;
	}
	
	
	if ( ( (isdefined(self.script_noteworthy)) && (self.script_noteworthy == "looping") ) || ( (isdefined(self.script_looping)) && (self.script_looping > 0) ) )
	{
		
		assert( isdefined(self.script_delay) || ( isdefined(self.script_delay_min) && isdefined(self.script_delay_max) ) );
		
		
		self endon ("stop_drone_loop");
		
		
		for (i = 0; i < repeat_times; i++)
		{
			
			
			level notify ("new drone spawn wave");
				
			
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
	else	
	{
		
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

		
		self drone_triggers_delay_first_spawn();

		
		thread drone_civ_spawngroup(spawnpoint, qHeadTrack, qFakeDeath, spawnSize, qSightTrace, qCower, qFriendlyFire, qBump);
	}
}



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




drone_civ_spawn(qHeadTrack, qFakeDeath, qSightTrace, qCower, qFriendlyFire, qBump)
{	
	
	
	
	level endon ("new drone spawn wave");

	
	if (!isdefined (qFakeDeath))
		qFakeDeath = false;

	
	if (!isdefined(qSightTrace))
		qSightTrace = false;
	while ( (qSightTrace) && (self spawnpoint_playersView()) )
		wait 0.2;

	
	
	if( !IsDefined(qHeadTrack) )
	{
		qHeadTrack = false;
	}

	
	
	
	if (!IsDefined(qCower))
	{
		qCower = true;
	}

	
	
	if (!IsDefined(qFriendlyFire))
	{
		qFriendlyFire = false;
	}

	
	
	if( !IsDefined( qBump ) )
	{
		qBump = false;
	}

	
	if (level.drones["civilian"].lastindex > level.max_drones["civilian"])
		return;

	
	guy = spawn("script_model", self.origin);
	if( IsDefined( self.angles ) )
	{
		guy.angles = self.angles;
	}
	
	
	
	
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

	
	
	
	if( IsDefined( self.script_int ) && ( self.script_int > 0 ) )
	{
		guy.female_skeleton = true;
	}
	else
	{
		guy.female_skeleton = false;
	}

	
	
	
	
	
	guy.targetname = "drone";
	
	
	
	guy.script_noteworthy = self.script_noteworthy;
	
	
	guy MakeFakeAI();
	
	
	guy.team = "civilian";

	
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

	
	
	guy thread drone_wait_for_delete();

	guy thread drone_think( self );
}


spawnpoint_playersView()
{
	
	if (!isdefined(level.cos80))
		level.cos80 = cos(80);
	
	
	
	

	
	
	
	players = level.player;
	player_view_count = 0;
	success = false;
	
	
	for (i=0; i < players.size; i++)
	{
		prof_begin("drone_math");
			forwardvec = anglestoforward(players[i].angles);
			normalvec = vectorNormalize(self.origin - (players[i] getOrigin()) );
			vecdot = vectordot(forwardvec,normalvec);
		prof_end("drone_math");
		if (vecdot > level.cos80)	
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
	
	
	return false;
}





drone_civ_assignweapon()
{
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	self.weapon = drone_civ_weapon();
	
	
	weaponModel = getWeaponModel(self.weapon);

	
	
	
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



drone_setName()
{
	wait 0.25;
	if (!isdefined(self))
		return;
	
	
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
	
}

#using_animtree("fakeshooters");

drone_think(firstNode)
{
	self endon("death");
	
	self.health = 1000000;

	
	
	
	
	
	
	

	
	self thread drones_clear_variables();

	
	structarray_add(level.drones[self.team],self);

	
	level notify ("new_drone");

	
	if (level.script != "duhoc_assault")
	{
		self.turrettarget = spawn ("script_origin",self.origin+(0,0,50));
		self.turrettarget linkto (self);
	}

	
	self endon ("drone_death");

	
	assert(isdefined(firstNode));

	
	self thread Drone_UpdateLookAt();

	
	
	if ( (isdefined(self.headTrack)) && (self.headTrack == true) )
		self thread drone_headtrack();
	
	

	
	if ( (isdefined(self.fakeDeath)) && (self.fakeDeath == true) )
		self thread drone_fakeDeath();
	
	
	
	
	if ( (isdefined(self.cower)) && (self.cower == true) )
		self thread drone_cower();

	
	
	if ( (isdefined(self.FriendlyFire)) && (self.FriendlyFire == false) )
		self thread drone_friendlyfire();

	
	
	
	

	
	self endon ("drone_shooting");

	
	
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

	
	
	
	
	
	
	
	self.drone_idleAnim = idleAnim;

	
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



#using_animtree("duhoc_drones");
drone_mortarDeath( vDirection, vOrigin, fMagnitude )
{
	
	self unlink();

	
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

	
	self StartRagDoll();
	wait(0.1);
	PhysicsJolt( vOrigin, 512, 256, vector_multiply( vDirection, fMagnitude ) );

	
	self drone_doDeath();
	wait( 3 );
	if( IsDefined( self ) )
	{
		self moveto(self.origin - (0,0,100), 7);
	}
	wait( 7 );
	self drone_delete();

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

#using_animtree("duhoc_drones");
drone_fakeDeath(instant)
{
	if (!isdefined(instant))
		instant = false;
	
	self endon ("delete");
	self endon ("drone_death");
	
	
	explosivedeath = false;
	
	
	
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
			
			
			self waittill ("damage", amount, attacker, parm1, parm2, parm3);
			
			
			
			
			
			
			
			if( parm3 == "MOD_GRENADE_SPLASH" || parm3 == "MOD_EXPLOSIVE" || parm3 == "MOD_EXPLOSIVE_SPLASH" )
			{
				self.damageweapon = "none";
				explosivedeath = true;
			}

			self notify ("death", attacker, parm3);
			

			
			
			self unlink();

			
			
			self thread drone_doDeath_impacts( parm2, attacker );

			
			
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
		
		
		
		
		if( explosivedeath )
		{
			if( IsDefined( amount ) && IsDefined( parm1 ) && IsDefined( parm2 ) )
			{
				self thread drone_mortarDeath( vector_multiply(parm1, -1), parm2, amount );
			}

			
			

			
			
			
			
			
			
			
			

			
			
			

			
			
			

			
			
			

			
			
			

			
			
			
			
			
			
			return;
		}
		
		else
		
		
		
		{
			if( IsDefined( amount ) && IsDefined( parm1 ) && IsDefined( parm2 ) )
			{
				self drone_bulletDeath( parm1, parm2, amount );
			}

			
			
			
			
		}
		
		
		
		
		
		
		
		
		
		self thread drone_doDeath();
		
		return;
	}
}


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




#using_animtree("duhoc_drones");
drone_doDeath(deathAnim, deathRemoveNotify)
{
	
	
	
	
	
	traceDeath = false;
	if ( (isdefined(self.running)) && (self.running == true) )
		traceDeath = true;
	self.running = undefined;
	self notify ("drone_death");
	self notify ("Stop shooting");
	self unlink();
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	if (!isdefined(self))
		return;

	
	self setcontents(0);

	
	if (isdefined(deathRemoveNotify))
		level waittill (deathRemoveNotify);
	else
		wait 3;

	
	if (!isdefined(self))
		return;

	
	self moveto(self.origin - (0,0,100), 7);
	wait 3;
	if (!isdefined(self))
		return;
	self.dontDelete = undefined;
	self thread drone_delete();
}




drone_doDeath_impacts( vImpactPoint, entAttacker )
{
	
	entOrigin = Spawn( "script_model", self.origin );
	entOrigin SetModel( "tag_origin" );
	if(!IsDefined( entAttacker ))
	{
		entAttacker = level.player;
	}
	entOrigin.angles = VectorToAngles( vImpactPoint - entAttacker.origin );
	entOrigin LinkTo( self );

	
	playfxontag( level.drone_impact, entOrigin, "tag_origin" );
	self playsound ("bullet_small_flesh");
	wait 0.05;
	entOrigin Delete();


	
	
	
	
	
	
	
	
	
	
	
	
	
}


drone_runChain(point_start)
{
	
	self endon ("drone_death");
	self endon ("drone_shooting");
	
	
	runPos = undefined;
	runPoint = undefined;

	self drone_delay(point_start);

	
	while(isdefined(self))
	{
		
		
		
		if (isdefined(point_start.script_death))
		{
			
			self.dontDelete = true;
			self thread drone_delayed_bulletdeath(0);
		}
		else
		if ( (isdefined(point_start.script_death_min)) && (isdefined(point_start.script_death_max)) )
		{
			
			self.dontDelete = true;
			self thread drone_delayed_bulletdeath(point_start.script_death_min + randomfloat( point_start.script_death_max - point_start.script_death_min));
		}
		
		if ( (isdefined(point_start.script_delete)) && (point_start.script_delete >= 0) )
			self thread drone_delete(point_start.script_delete);
		
		
		
		
		if (!isdefined(point_start.targeted))
		{
			
			
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
		
		
		if (isdefined(point_end[index].radius))
		{
			assert(point_end[index].radius > 0);
			
			
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
		
		
		self.drone_hasPath = true;
		if (isdefined(point_start.script_noteworthy))
			self ShooterRun(runPoint, point_start.script_noteworthy);
		else
			self ShooterRun(runPoint);
		
		point_start = point_end[index];
	}
	
	
	if (!isdefined(runPoint))
	{
		self.drone_hasPath = false;
		runPoint = point_start;
		
	}
	
	if (isdefined(point_start.script_noteworthy))
		self ShooterRun(runPoint, point_start.script_noteworthy);
	else
		self ShooterRun(runPoint);

	
	
	if( IsDefined( runPoint.angles ) )
	{
		self RotateTo(runPoint.angles, 0.5);
		self waittill( "rotatedone" );
	}

	
	if ( (isdefined(point_start.script_delete)) && (point_start.script_delete >= 0) )
		self thread drone_delete(point_start.script_delete);
}

drone_delay(point)
{
	
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




#using_animtree("fakeShooters");
ShooterRun(destinationPoint, event)
{
	
	if(!isdefined(self))
		return;
	self notify ("Stop shooting");
	self UseAnimTree(#animtree);
	
	
	
	
	self endon( "cower_stop" );

	
	
	self._destinationPoint = destinationPoint;
	self._event = event;

	
	
	wait( 0.05 );

	prof_begin("drone_math");
	

	
	
	
	
	
	
	
	
	
	
	minRate = 0.5;
	maxRate = 1.5;
	randomAnimRate = minRate + randomfloat( maxRate - minRate);

	
	
	
	
	
	
	
	
	
	
	
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
	
	self.lowheight = false;
	
	self turnToFacePoint( destinationPoint.origin, speed );
	
	

	if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
	{
		self.drone_run_cycle = %Gen_Civs_CasualWalk_Female;
		
	}
	else
	{
		self.drone_run_cycle = %Civ_CasualWalkV1;
	}
	

	
	
	
	
	
	
	
	
	customFirstAnim = undefined;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	
	
	
	
	if (IsDefined(event))
	{
		if (event == "walk")
		{
			
			self.droneRunRate = 75;
			
			if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
			{
				self.drone_run_cycle = %Gen_Civs_CasualWalk_Female;
				
			}
			else
			{
				self.drone_run_cycle = %Civ_CasualWalkV1;
			}

			self.running = false;
			self.animRate = 75;
			
			self thread ShooterRun_doRunAnim();

			randomAnimRate = undefined;

			
			d = distance(self.origin, destinationPoint.origin);
			speed = (d / self.droneRunRate);
		}
		else if (event == "run")
		{
			
			self.droneRunRate = 150;
			self.drone_run_cycle = %Thu_Relax_Stand_Run_Pistol;
			self.running = false;
			self.animRate = 150;
			
			self thread ShooterRun_doRunAnim();

			randomAnimRate = undefined;

			
			d = distance(self.origin, destinationPoint.origin);
			speed = (d / self.droneRunRate);
		}
		else if (event == "sprint")
		{
			
			self.droneRunRate = 200;
			self.drone_run_cycle = %Thu_Alrt_Stand_Sprint_Pistol;
			self.running = false;
			self.animRate = 200;
			
			self thread ShooterRun_doRunAnim();

			randomAnimRate = undefined;

			
			d = distance(self.origin, destinationPoint.origin);
			speed = (d / self.droneRunRate);
		}


		
		
		
		
		
		
		else if (event == "low_height")
		{
			self.lowheight = true;
		}
		else if (event == "mortardeath_up")
		{
			self thread drone_mortarDeath( AnglesToUp( self.angles ) );
			
			return;
		}
		else if (event == "mortardeath_forward")
		{
			self thread drone_mortarDeath( AnglesToForward( self.angles ) );
			
			return;
		}
		else if (event == "mortardeath_back")
		{
			self thread drone_mortarDeath( vector_multiply( AnglesToForward( self.angles ), -1 ) );
			
			return;
		}
		else if (event == "mortardeath_left")
		{
			self thread drone_mortarDeath( vector_multiply( AnglesToRight( self.angles ), -1 ) );
			
			return;
		}
		else if (event == "mortardeath_right")
		{
			self thread drone_mortarDeath( AnglesToRight( self.angles ) );
			
			return;
		}


		
		
		
		
		
		else if (event == "shoot")
		{
			
			forwardVec = anglestoforward(self.angles);
			rightVec = anglestoright(self.angles);
			upVec = anglestoup(self.angles);
			relativeOffset = (300,0,0);
			shootPos = self.origin;
			shootPos += vector_multiply(forwardVec, relativeOffset[0]);
			shootPos += vector_multiply(rightVec, relativeOffset[1]);
			shootPos += vector_multiply(upVec, relativeOffset[2]);
			self.shootTarget = spawn("script_origin",shootPos);
			
			
			
			

			
			self thread ShooterShootThread(self.shootTarget);
			return;
		}
		else if (event == "cover_stand")
		{
			self thread drone_cover(event);
			
			
			self waittill ("drone out of cover");
			
			self setFlaggedAnimKnobAll ( "cover_exit", %Thu_cvrmidtns_stnd_ready2exp_Pistol, %body, 1, .1, 1);
			self waittillmatch("cover_exit", "end");
		}
		else if (event == "cover_crouch")
		{
			self thread drone_cover(event);
			
			
			self waittill ("drone out of cover");
			
			self setFlaggedAnimKnobAll ( "cover_exit", %Thu_cvrmidtns_crch_exp2ready_Pistol, %body, 1, .1, 1);
			self waittillmatch("cover_exit", "end");
		}
		
		
		else if (event == "phone_call")
		{
			self thread civ_action(event);
			
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
			self waittill("drone_event_end");
		}
	}
	
	
	if (isdefined(customFirstAnim))
	{
		self.customFirstAnim = true;
		self.running = undefined;
		randomAnimRate = undefined;
		
		
		angles = VectorToAngles( destinationPoint.origin - self.origin );
		offset = getcycleoriginoffset( angles, customFirstAnim );
		endPos = self.origin + offset;
		endPos = physicstrace( (endPos + (0,0,64)), (endPos - (0,0,level.traceHeight)) );
		
		t = getanimlength(customFirstAnim);
		assert(t > 0);
		
		
		
		
		
		
		
		self clearanim( self.drone_run_cycle, 0 );
		self notify ("stop_run_anim");
		
		self moveto (endPos, t, 0, 0);
		
		
		self setflaggedanimknobrestart( "drone_custom_anim" , customFirstAnim );
		self waittillmatch("drone_custom_anim","end");
		
		self.origin = endPos;
		self notify ("customFirstAnim done");
		
		
		d = distance(self.origin, destinationPoint.origin);
		speed = (d/self.droneRunRate);
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
		
	self.customFirstAnim = undefined;
	
	
	self drone_runto(destinationPoint, speed);

	if (self.drone_hasPath)
	{
		self drone_delay(destinationPoint);
	}

	prof_end("drone_math");
}


drone_runto(destinationPoint, totalMoveTime)
{
	
	if (totalMoveTime < 0.1)
		return;
	
	
	
	if( !IsDefined( self ) )
	{
		return;
	}

	
	self thread ShooterRun_doRunAnim();

	
	
	
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
				
			
			if ((percentageMark[2] - oldZ) > level.droneStepHeight )
				percentageMark = (percentageMark[0], percentageMark[1], oldZ);
			
			oldZ = percentageMark[2];
		prof_end("drone_math");
		
		

		
		
		while( IsDefined( self )&& IsDefined( self.cower_active ) && ( self.cower_active == true ) )
		{
			wait( 1 );
		}

		
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




































#using_animtree("fakeShooters");
ShooterShootThread(target)
{
	
    self notify ("Stop shooting");
    self notify ("drone_shooting");

	
    self endon ("Stop shooting");
    self UseAnimTree(#animtree);
	self.running = undefined;
    self thread aimAtTargetThread ( target, "Stop shooting" );

	
	Assert( IsDefined( self.bulletsInClip ), "Asking Drone to shoot with no weapon attached" );

    shootAnimLength = 0;
    while(isdefined(self))
    {
        if (self.bulletsInClip <= 0)    
        {
			
        	weaponModel = getWeaponModel(self.weapon);
        	if (isdefined(self.weaponModel))
        		weaponModel = self.weaponModel;
        	
        	
        	numAttached = self getattachsize();
        	attachName = [];
        	for (i=0;i<numAttached;i++)
        		attachName[i] = self getattachmodelname(i);
        	
			
			
			
            self detach(weaponModel, "tag_weapon_right");
            self attach(weaponModel, "tag_weapon_left");
			
			
			
			self setflaggedanimknoballrestart ( "shootinganim", %Thu_cvrmid_stnd_reload_Pistol, %root, 1, 0.4 );
            
           
           	
			
            
            self waittillmatch ("shootinganim", "end");
            self detach(weaponModel, "tag_weapon_left");
            self attach(weaponModel, "tag_weapon_right");
        }

        
        self Set3FlaggedAnimKnobs("no flag", "aim", "stand", 1, 0.3, 1);
        wait 1 + (randomfloat(2));
		
		if (!isdefined(self))
			return;
		
        
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
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
			}
			else
			{
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
            }
            
            self.bulletsInClip--;

            
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
	
	
	
	if( !IsDefined( self.animRate ) )
	{
		self.animRate = 200;
	}

	
	if( !IsDefined( self.drone_run_cycle ) )
	{
		
		if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
		{
			self.drone_run_cycle = %Gen_Civs_CasualWalk_Female;
			
		}
		else
		{
			self.drone_run_cycle = %Civ_CasualWalkV1;
		}
	}

	while( (isdefined(self.running)) && (self.running == true) )
	{
		
		
		animRate = (self.droneRunRate/self.animRate);
		
		
		if (adjustAnimRate)
		{
			animRate = (animRate * animRateMod);
			adjustAnimRate = false;
		}
		
		
		
		
		
		
		

		if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
		{
			
		}
		else
		{
			
		}

		self setflaggedanimknobrestart( "drone_run_anim" , self.drone_run_cycle, 1, .1, animRate );
		self waittillmatch("drone_run_anim","end");
		

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


turnToFacePoint(point, speed)
{
    
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




Set3FlaggedAnimKnobs(animFlag, animArray, pose, weight, blendTime, rate)
{
	if (!isdefined(self))
		return;
    self setAnimKnob(%combat_directions, weight, blendTime, rate);
    self SetFlaggedAnimKnob(animFlag,    level.drone_animArray[animArray][pose]["up"],			1, blendTime, 1);
    self SetAnimKnob(                    level.drone_animArray[animArray][pose]["straight"],    1, blendTime, 1);
    self SetAnimKnob(                    level.drone_animArray[animArray][pose]["down"],        1, blendTime, 1);
}


Set3FlaggedAnimKnobsRestart(animFlag, animArray, pose, weight, blendTime, rate)
{
	if (!isdefined(self))
		return;
    self setAnimKnobRestart(%combat_directions, weight, blendTime, rate);
    self SetFlaggedAnimKnobRestart(animFlag,	level.drone_animArray[animArray][pose]["up"],			1, blendTime, 1);
    self SetAnimKnobRestart(					level.drone_animArray[animArray][pose]["straight"],		1, blendTime, 1);
    self SetAnimKnobRestart(					level.drone_animArray[animArray][pose]["down"],			1, blendTime, 1);
}


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


getTargetUpDownOffset(target)
{
    pos = self.origin;
    dir = (pos[0] - target[0], pos[1] - target[1], pos[2] - target[2]);
    dir = VectorNormalize( dir );
    fact = dir[2] * -1;
    return fact;
}


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
		
		
		anim_array["hide_idle"] = %Thu_cvrmid_stnd_idlready_Pistol;
		anim_array["hide_idle_twitch"] = array(	%Thu_cvrmid_stnd_peekup_Pistol,
												%Thu_cvrmidtns_stnd_ready2blindfire_Rifle,
												%Thu_cvrmidtns_stnd_blindfire2ready_Pistol );

		anim_array["hide_idle_flinch"] = array(	%Thu_Stand_Pain_HtReact_ChestHead_Pistol,
												%Thu_Stand_Pain_HtReact_RShoulder_Pistol,
												%Thu_Stand_Pain_HtReact_LShoulder_Pistol,
												%Thu_Stand_Pain_HtReact_RHand_Pistol );

		
		
		
		
		
		
		
		
	
		
		
		
		
		
		
		
		self.a.array = anim_array;	
		
		self setFlaggedAnimKnobAllRestart ( "cover_approach", %Thu_cvrmidtns_stnd_exp2ready_Pistol, %body, 1, .3, 1);
		self waittillmatch("cover_approach", "end");
		
		self thread drone_cover_think();
	}
	else if (type == "cover_crouch")
	{	
		
		
		anim_array["hide_idle"] = %Thu_cvrlt_crch_idlready_Pistol;
		anim_array["hide_idle_twitch"] = array(	%Thu_cvrlt_crch_peekup_Pistol,
												%Thu_cvrmidtns_crch_ready2blindfire_Pistol,
												%Thu_cvrmidtns_crch_blindfire2ready_Pistol );

		
		
		
		
		
		
		
		
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












drone_bulletDeath( vDirection, vOrigin, fMagnitude )
{
	
	self unlink();

	
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

	
	self StartRagDoll();
	wait( 0.1 );
	PhysicsJolt( vOrigin, 256, 128, vector_multiply( vDirection, fMagnitude ) );
	
	
	self drone_doDeath();
	wait( 3 );
	if( IsDefined( self ) )
	{
		self moveto(self.origin - (0,0,100), 7);
	}
	wait( 7 );
	self drone_delete();
}


drone_cower()
{
	
	if( !IsDefined( self ) )
	{
		return;
	}

	
	self endon( "damage" );

	
	if( !IsDefined( self.cower_active ) )
	{
		self.cower_active = false;
	}

	
	while( IsDefined( self ) )
	{
		if( !IsDefined( self ) )
		{
			return;
		}

		
		if( !sightTracePassed( self.origin + (0, 0, 32), level.player.origin, false, undefined ) )
		{
			self.cower_active = false;
			sWpn = undefined;
			wait( 1 );
			continue;
		}
		
		
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


drone_cower_anim()
{
	
	if( !IsDefined( self ) )
	{
		return;
	}

	
	self endon( "damage" );

	
	if( IsDefined( self.running ) && ( self.running == true ) )
	{
		
		vGoalPos = self.origin + vector_multiply( AnglesToForward( self.angles ), 36 );
		self MoveTo( vGoalPos, 2, 0, 1 );
		self waittill( "movedone" );

		
		self.running = false;
		self clearanim( self.drone_run_cycle, 0.5 );
	}
	wait( 0.5 );

	
	while( IsDefined( self.cower_active ) && ( self.cower_active == true ) )
	{
		
		if( !IsDefined( self ) )
		{
			return;
		}

		
		self setflaggedanimknobrestart( "drone_cower_anim" , %Thu_cvrlt_crch_peekup_Pistol, 1, .2, 1 );
		self waittillmatch("drone_cower_anim", "end");

		
		if( !IsDefined( self ) )
		{
			return;
		}
	}

	
	if( !IsDefined( self ) )
	{
		return;
	}
	self.cower_active = false;

	
	self notify( "cower_stop" );

	
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



drone_friendlyfire()
{
	bFriendlyFire = false;

	while( true )
	{
		
		self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, iType, sModelName, sAttachTag, sTagName ); 

		
		if( !IsDefined(sAttacker) )
			continue;

		
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
			
			SetSavedDVar( "ai_ChatEnable", "0" );
			level.player PlayLocalSound( "dia_mission_fail_civ" );
			wait( 0.05 );
			SetSavedDVar( "ai_ChatEnable", "1" );
			MissionFailed();
		}
	}
}



drone_bump()
{
	
	if( !IsDefined( self ) )
	{
		return;
	}

	
	self endon( "damage" );

	
	while( IsDefined( self ) )
	{
		
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

		
		if( (Distance( self.origin, level.player.origin ) < 32) && (level.player GetSpeed() > 40 ) )
		{
			
			
			
			
			
			
			
			
			
		}
		else
		{
			
			
			
			
			
			
			
			wait( 0.1 );
		}
	}
}


drone_bump_anim()
{

	
	vecTarget = self.origin + vector_multiply( AnglesToForward( self.angles ), 36 );

	
	self setflaggedanimknobrestart( "drone_bump_anim" , %Thu_Stand_Pain_HtReactHvy_RShoulder_Pistol, 1, .2, 1 );
	self waittillmatch("drone_bump_anim", "end");

	
	self turnToFacePoint(level.player.origin, 0.5);

	
	self setflaggedanimknobrestart( "drone_react_anim" , %Thu_Alrt_Stand_Idl_Pistol, 1, .2, 1 );
	self waittillmatch("drone_react_anim", "end");

	
	self clearanim( %Thu_Alrt_Stand_Idl_Pistol, 0.5 );
	self notify( "drone_idle_anim", "end" );
	self notify( "idle", "end" );

	
	self turnToFacePoint(vecTarget, 0.5);
}


drone_wait_for_delete()
{
	level waittill( "delete_drones" );
	if( IsDefined( self ) )
	{
		self Delete();
	}
}



civ_action(type)
{
	self endon("drone_stop_event");
	
	if( !IsDefined( self.a ) )
	{
		self.a = SpawnStruct(); 
	}
	self.a.coverMode = "hide";
	
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
	
	
	self notify("drone_event_end");
}

phone_call()
{
	if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
	{
		
		anim_array["phone_call"] = array( %Gen_Civs_CellPhoneTalk_Female );
	}
	else
	{
		
		anim_array["phone_call"] = array( %Gen_Civs_CellPhoneTalk );
	}
	
	self.a.array = anim_array;	
	while (1)
	{
		idleAnim = animArrayPickRandom("phone_call");
		self setFlaggedAnimKnobRestart("idle", idleAnim);
		self waittillmatch("idle", "end");
	}
}

take_picture()
{
	if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
	{
		
		anim_array["take_picture"] = array(	%Gen_Civs_PicTaking_Female );
	}
	else
	{
		
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
		
		anim_array["sit_eating"] = array( %Gen_Civs_SitEating_Female );
	}
	else
	{
		
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
		
		anim_array["sit_talking"] = array( %Gen_Civs_SitConversation_A_Female, %Gen_Civs_SitConversation_B_Female, %Gen_Civs_SitConversation_Listen_Female );
	}
	else
	{
		
		anim_array["sit_talking"] = array( %Gen_Civs_SitConversation_A, %Gen_Civs_SitConversation_B, %Gen_Civs_SitConversation_Listen );
	}
	
	self.a.array = anim_array;	
	idleAnim = animArrayPickRandom("sit_talking");

	while(1)
	{
		self setFlaggedAnimKnobRestart("idle", idleAnim);
		self waittillmatch("idle", "end");	
	}
}

sit_playing_cards()
{
	
	anim_array["sit_playing_cards"] = array( %Gen_Civs_SeatedPlayingCards_A, %Gen_Civs_SeatedPlayingCards_B, %Gen_Civs_SeatedPlayingCards_C );
	
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
		
		anim_array["sit_reading"] = array( %Gen_Civs_SitReading_B_Female, %Gen_Civs_SitReading_C_Female );
	}
	else
	{
		
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
		
		anim_array["stand_talking"] = array( %Gen_Civs_CasualStand_Female, %Gen_Civs_StndArmsCrossed_Female );
	}
	else
	{
		
		anim_array["stand_talking"] = array( %Gen_Civs_CasualStand, %Gen_Civs_StndArmsCrossed );
	}	

	self.a.array = anim_array;	
	idleAnim = animArrayPickRandom("stand_talking");

	while(1)
	{
		self setFlaggedAnimKnobRestart("idle", idleAnim);
		self waittillmatch("idle", "end");	
	}
}

stand_casual()
{
	if( isDefined(self.female_skeleton) && (self.female_skeleton == true) )
	{
		
		anim_array["stand_casual"] = array(	%Gen_Civs_CasualStand_Female, %Gen_Civs_StndArmsCrossed_Female );
	}
	else
	{
		
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
		
		anim_array["stand_arms_crossed"] = array( %Gen_Civs_StndArmsCrossed_Female );
	}
	else
	{
		
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
		
		anim_array["stand_cell_phone"] = array(	%Gen_Civs_CellPhoneTalk_Female );
	}
	else
	{
		
		anim_array["stand_cell_phone"] = array(	%Gen_Civs_CellPhoneTalk );
	}
	
	self.a.array = anim_array;	
	idleAnim = animArrayPickRandom("stand_cell_phone");

	while(1)
	{
		self setFlaggedAnimKnobRestart("idle", idleAnim);
		self waittillmatch("idle", "end");	
	}
}






drone_headtrack()
{
	self endon( "damage" );

	while( IsDefined( self ) )
	{
		
		if( Distance( self.origin, level.player.origin ) < 256 )
		{
			Drone_StartLookAt(level.player, 3, 1);
			wait( 10 );
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

				
				maxLookAtRotYaw = 60.0;
				minLookAtRotYaw = -60.0;
				maxLookAtRotPitch = 45.0;
				minLookAtRotPitch = -45.0;

				headPos = self gettagorigin("head");
				headAng = self gettagangles("head");
		
				
				
				

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
					
					if ( self.m_LookAtYaw > -0.5 && self.m_LookAtYaw < 0.5 )
					{
						self Drone_StopLookAt();
					}
					else
					{
						
						

						self.m_LookAtYaw =  dampK * clampedYaw ;
						self.m_LookAtPitch = dampK * clampedPitch;

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




Drone_GetLookAtDampK( lookAtTime)
{
		dampVal = 0.0;
		if (lookAtTime < self.m_LookAtLerpTime) 
		{
			
			dampVal = lookAtTime/self.m_LookAtLerpTime;
		}
		else if ( lookAtTime < (self.m_LookAtDuration - self.m_LookAtLerpTime))
		{
			
			dampVal = 0.8;
		}
		else
		{
			
			dampVal = ( lookAtTime - self.m_LookAtDuration  + self.m_LookAtLerpTime ) / self.m_LookAtLerpTime;
		}

		
		if(dampVal < 0.0)
		{
			dampVal = 0.0;
		}
		else if (dampVal > 1.0)
		{
			dampVal = 1.0;
		}

		dampVal = 1.0 - dampVal * dampVal; 

		return dampVal;
}




Drone_StartLookAt(lookAtEntity, lookAtDuration, lookAtLerpTime)
{
	self endon("death");
	self endon ("drone_death");
	
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




Drone_StopLookAt( )
{
	self endon("death");
	self endon ("drone_death");
	
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




startLookAt()
{
	self endon("death");
	self endon ("drone_death");

	wait (3);
	Drone_StartLookAt(level.player, 3, 1);
}
