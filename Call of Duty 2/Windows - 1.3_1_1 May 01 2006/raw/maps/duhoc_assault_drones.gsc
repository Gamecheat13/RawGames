#include maps\_utility;

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
/*
finish_struct_targeted_origins()
{
	level.struct = undefined;
	level.struct_targetname = undefined;
}
*/
drone_triggers_wait_axis()
{
	self build_struct_targeted_origins();
	
	qFakeDeath = false;
	
	assert(isdefined(self.targeted));
	assert(isdefined(self.targeted[0]));
	spawnPoint = self.targeted;
	assert(isdefined(spawnPoint[0]));
	
	self waittill ("trigger");
	if ( (isdefined(self.script_noteworthy)) && (self.script_noteworthy == "looping") )
	{
		//looping
		assert(isdefined(self.script_delay));
		assert(self.script_delay > 0);
		self endon ("stop_looping");
		for (;;)
		{
			//how many drones should spawn?
			spawnSize = undefined;
			if (isdefined (self.script_drones_min))
			{
				max = spawnpoint.size;
				if (isdefined (self.script_drones_max))
					max = self.script_drones_max;
				spawnSize = (self.script_drones_min + randomint(max - self.script_drones_min));
			}
			
			thread drone_axis_spawngroup(spawnpoint, qFakeDeath, spawnSize);
			wait (self.script_delay);
			if ( (isdefined(self.script_requires_player)) && (self.script_requires_player > 0) )
				self waittill ("trigger");
		}
	}
	else	//one time only
		thread drone_axis_spawngroup(spawnpoint, qFakeDeath);
}

drone_triggers_wait_allies()
{
	self build_struct_targeted_origins();
	
	qFakeDeath = false;
	
	assert(isdefined(self.targeted));
	assert(isdefined(self.targeted[0]));
	spawnPoint = self.targeted;
	assert(isdefined(spawnPoint[0]));
	
	self waittill ("trigger");
	if ( (isdefined(self.script_noteworthy)) && (self.script_noteworthy == "looping") )
	{
		//looping
		assert(isdefined(self.script_delay));
		assert(self.script_delay > 0);
		self endon ("stop_looping");
		for (;;)
		{
			//how many drones should spawn?
			spawnSize = undefined;
			if (isdefined (self.script_drones_min))
			{
				max = spawnpoint.size;
				if (isdefined (self.script_drones_max))
					max = self.script_drones_max;
				spawnSize = (self.script_drones_min + randomint(max - self.script_drones_min));
			}
			
			thread drone_allies_spawngroup(spawnpoint, qFakeDeath, spawnSize);
			wait (self.script_delay);
			if ( (isdefined(self.script_requires_player)) && (self.script_requires_player > 0) )
				self waittill ("trigger");
		}
	}
	else	//one time only
		thread drone_allies_spawngroup(spawnpoint, qFakeDeath);
}

drone_axis_spawngroup(spawnpoint, qFakeDeath, spawnSize)
{
	spawncount = spawnpoint.size;
	if (isdefined(spawnSize))
	{
		spawncount = spawnSize;
		spawnpoint = array_randomize(spawnpoint);
	}
	
	for (i=0;i<spawncount;i++)
		spawnpoint[i] thread drone_axis_spawn(qFakeDeath);
}

drone_allies_spawngroup(spawnpoint, qFakeDeath, spawnSize)
{
	spawncount = spawnpoint.size;
	if (isdefined(spawnSize))
	{
		spawncount = spawnSize;
		spawnpoint = array_randomize(spawnpoint);
	}
	
	for (i=0;i<spawncount;i++)
		spawnpoint[i] thread drone_allies_spawn(qFakeDeath);
}

drone_axis_spawn(qFakeDeath)
{
	if (!isdefined (qFakeDeath))
		qFakeDeath = false;
	
	//spawn a drone
	guy = spawn("script_model", self.origin);
	guy aitype\axis_nrmdy_wehr_reg_kar98::main();
	guy drone_axis_assignWeapon();
	guy.targetname = "drone";
	guy makeFakeAI();
	guy.fakeDeath = qFakeDeath;
	
	guy thread drone_think( self );
}

drone_allies_spawn(qFakeDeath)
{
	if (!isdefined (qFakeDeath))
		qFakeDeath = false;
	
	//spawn a drone
	guy = spawn("script_model", self.origin);
	guy character\american_ranger_normandy_low_wet::main();
	guy drone_allies_assignWeapon();
	guy.targetname = "drone";
	guy makeFakeAI();
	guy.fakeDeath = qFakeDeath;
	
	guy thread drone_think( self );
}

drone_axis_assignWeapon()
{
	randWeapon = randomint(4);
	switch(randWeapon)
	{
		case 0:
		case 1:
		case 2: self.weapon = "kar98k";	break;
		case 3:	self.weapon = "mp40";	break;
	}
	weaponModel = getWeaponModel(self.weapon);
	self attach(weaponModel, "tag_weapon_right");
	self.bulletsInClip = self animscripts\weaponList::ClipSize();
}

drone_allies_assignWeapon()
{
	randWeapon = randomint(5);
	switch(randWeapon)
	{
		case 0:
		case 1:
		case 2: self.weapon = "m1garand";	break;
		case 3: self.weapon = "BAR";		break;
		case 4:	self.weapon = "thompson";	break;
	}
	weaponModel = getWeaponModel(self.weapon);
	self attach(weaponModel, "tag_weapon_right");
	self.bulletsInClip = self animscripts\weaponList::ClipSize();
}

drone_think(firstNode)
{
	self endon ("drone_death");
	assert(isdefined(firstNode));
	
	//fake death if this drone is told to do so
	if ( (isdefined(self.fakeDeath)) && (self.fakeDeath == true) )
		self thread drone_fakeDeath();
	
	self drone_runChain(firstNode);
	
	if (!isdefined(self.dontDelete))
	{
		if (isdefined(self.dummy))
			self.dummy delete();
		if (isdefined(self.dummy_trace))
			self.dummy_trace delete();
		self detachall();
		self delete();
	}
}

#using_animtree("duhoc_drones");
drone_mortarDeath(direction)
{
	self useAnimTree(#animtree);
	switch(direction)
	{
		case "up":
			self thread drone_doDeath(%death_explosion_up10);
			break;
		case "forward":
			self thread drone_doDeath(%death_explosion_forward13);
			break;
		case "back":
			self thread drone_doDeath(%death_explosion_back13);
			break;
		case "left":
			self thread drone_doDeath(%death_explosion_left11);
			break;
		case "right":
			self thread drone_doDeath(%death_explosion_right13);
			break;
	}
}

#using_animtree("duhoc_drones");
drone_fakeDeath()
{
	self endon ("delete");
	self endon ("drone_death");
	
	while(isdefined(self))
	{
		self setCanDamage(true);
		self waittill ("damage");
		
		if ( (isdefined(self.customFirstAnim)) && (self.customFirstAnim == true) )
			continue;
		
		self notify ("Stop shooting");
		self.dontDelete = true;
		
		randDeath = randomint(5);
		deathAnim = undefined;
		self useAnimTree(#animtree);
		switch(randDeath)
		{
			case 0:
				deathAnim = %death_stand_dropinplace;
				break;
			case 1:
				deathAnim = %death_run_stumble;
				break;
			case 2:
				deathAnim = %death_run_onfront;
				break;
			case 3:
				deathAnim = %death_run_onleft;
				break;
			case 4:
				deathAnim = %death_run_forward_crumple;
				break;
		}
		
		self thread drone_doDeath(deathAnim);
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
	
	randDeath = randomint(5);
	deathAnim = undefined;
	self useAnimTree(#animtree);
	switch(randDeath)
	{
		case 0:
			deathAnim = %death_stand_dropinplace;
			break;
		case 1:
			deathAnim = %death_run_stumble;
			break;
		case 2:
			deathAnim = %death_run_onfront;
			break;
		case 3:
			deathAnim = %death_run_onleft;
			break;
		case 4:
			deathAnim = %death_run_forward_crumple;
			break;
	}
	
	self thread drone_doDeath(deathAnim, deathRemoveNotify);
	return;
}

#using_animtree("duhoc_drones");
drone_doDeath(deathAnim, deathRemoveNotify)
{
	self notify ("stop_drone_run_anim");
	self notify ("drone_death");
	self notify ("Stop shooting");
	self unlink();
	self useAnimTree(#animtree);
	self thread drone_doDeath_impacts();
	
	if (randomint(3) == 0)
	{
		alias = "generic_death_american_" + (1 + randomint(6));
		self thread playsoundinspace(alias);
	}
	
	prof_begin("drone_math");
	cancelRunningDeath = false;
	
	//trace last frame of animation to prevent the body from clipping on something coming up in its path
	//backup animation if trace fails: %death_stand_dropinplace
	
	offset = getcycleoriginoffset( self.angles, deathAnim );
	endAnimationLocation = (self.origin + offset);
	endAnimationLocation = physicstrace( (endAnimationLocation + (0,0,128)), (endAnimationLocation - (0,0,128)) );
	d1 = abs(endAnimationLocation[2] - self.origin[2]);
	
	if (d1 > 20)
		cancelRunningDeath = true;
	else
	{
		//trace even more forward than the animation (bounding box reasons)
		forwardVec = anglestoforward(self.angles);
		rightVec = anglestoright(self.angles);
		upVec = anglestoup(self.angles);
		relativeOffset = (50,0,0);
		secondPos = endAnimationLocation;
		secondPos += vectorMultiply(forwardVec, relativeOffset[0]);
		secondPos += vectorMultiply(rightVec, relativeOffset[1]);
		secondPos += vectorMultiply(upVec, relativeOffset[2]);
		secondPos = physicstrace( (secondPos + (0,0,128)), (secondPos - (0,0,128)) );
		d2 = abs(secondPos[2] - self.origin[2]);
		if (d2 > 20)
			cancelRunningDeath = true;
	}
	prof_end("drone_math");
	if (cancelRunningDeath)
		deathAnim = %death_stand_dropinplace;
	
	self setcontents(0);
	self animscripted("drone_death_anim", self.origin, self.angles, deathAnim, "deathplant");
	self waittillmatch("drone_death_anim","end");
	if (!isdefined(self))
		return;
	
	//remove their gun
	if (isdefined(self.weapon))
	{
		weaponModel = getWeaponModel(self.weapon);
		self detach(weaponModel, "tag_weapon_right");
	}
	
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
	if (isdefined(self.dummy))
		self.dummy delete();
	if (isdefined(self.dummy_trace))
		self.dummy_trace delete();
	self detachall();
	self delete();
}

drone_doDeath_impacts()
{
	bone[0] = "J_Knee_LE";
	bone[1] = "J_Ankle_LE";
	bone[2] = "J_Clavicle_LE";
	bone[3] = "J_Shoulder_LE";
	bone[4] = "J_Elbow_LE";
	
	impacts = (1 + randomint(2));
	for (i=0;i<impacts;i++)
	{
		playfxontag( level._effect["impact_flesh1"], self, bone[randomint(bone.size)] );
		self playsound ("bullet_small_flesh");
		wait 0.05;
	}
}

drone_runChain(point_start)
{
	self endon ("drone_death");
	self endon ("drone_shooting");
	
	while(isdefined(self))
	{
		if (!isdefined(point_start.targeted))
			break;
		point_end = point_start.targeted;
		if ( (!isdefined(point_end)) || (!isdefined(point_end[0])) )
			break;
		index = randomint(point_end.size);
		
		//check for script_death, script_death_min, and script_death_max
		//--------------------------------------------------------------
		//chad
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
			self thread drone_delayed_bulletdeath(randomfloat(point_start.script_death_min + (point_start.script_death_max - point_start.script_death_min)));
		}
		
		//--------------------------------------------------------------
		
		if (isdefined(point_start.script_noteworthy))
			self ShooterRun(point_end[index].origin, point_start.script_noteworthy);
		else
			self ShooterRun(point_end[index].origin);
		
		point_start = point_end[index];
	}
}

#using_animtree("fakeShooters");
ShooterRun(destinationPoint, event)
{
	if(!isdefined(self))
		return;
	self notify ("Stop shooting");
	self UseAnimTree(#animtree);
	
	//create a dummy that will be the fake drone bone
	dummy = spawn("script_model", self.origin);
	dummy_trace = spawn("script_model", self.origin);
	
	self.dummy = dummy;
	self.dummy_trace = dummy_trace;
	
	//thread debugDummyLines(dummy, dummy_trace);
	
	//orient the drone to his run point
	self turnToFacePoint( destinationPoint );
	
	//if I want the guy to do a jump first do that here before continuing the run
	customFirstAnim = undefined;
	if ( (isdefined(event)) && (event == "jump") )
		customFirstAnim = %jump_across_100;
	if ( (isdefined(event)) && (event == "jumpdown") )
		customFirstAnim = %jump_down_56;
	if ( (isdefined(event)) && (event == "dismount") )
		self.customFirstRunAnim = %duhoc_climber_dismount;
	if ( (isdefined(event)) && (event == "mortardeath_up") )
	{
		self thread drone_mortarDeath("up");
		dummy delete();
		dummy_trace delete();
		return;
	}
	if ( (isdefined(event)) && (event == "mortardeath_forward") )
	{
		self thread drone_mortarDeath("forward");
		dummy delete();
		dummy_trace delete();
		return;
	}
	if ( (isdefined(event)) && (event == "mortardeath_back") )
	{
		self thread drone_mortarDeath("back");
		dummy delete();
		dummy_trace delete();
		return;
	}
	if ( (isdefined(event)) && (event == "mortardeath_left") )
	{
		self thread drone_mortarDeath("left");
		dummy delete();
		dummy_trace delete();
		return;
	}
	if ( (isdefined(event)) && (event == "mortardeath_right") )
	{
		self thread drone_mortarDeath("right");
		dummy delete();
		dummy_trace delete();
		return;
	}
	if ( (isdefined(event)) && (event == "shoot") )
	{
		forwardVec = anglestoforward(self.angles);
		rightVec = anglestoright(self.angles);
		upVec = anglestoup(self.angles);
		relativeOffset = (300,0,50);
		shootPos = self.origin;
		shootPos += vectorMultiply(forwardVec, relativeOffset[0]);
		shootPos += vectorMultiply(rightVec, relativeOffset[1]);
		shootPos += vectorMultiply(upVec, relativeOffset[2]);
		shootTarget = spawn("script_origin",shootPos);
		
		self.dontDelete = true;
		self thread ShooterShoot(shootTarget);
		dummy delete();
		dummy_trace delete();
		return;
	}
	
	if (!isdefined(event))
	{
		if ( (isdefined(self.running)) && (self.running == false) )
			customFirstAnim = %drone_stand_to_run;
	}
	
	if (isdefined(customFirstAnim))
	{
		self.customFirstAnim = true;
		//figure out the offset of the animation so the dummy can be moved to the correct spot
		angles = VectorToAngles( destinationPoint - self.origin );
		offset = getcycleoriginoffset( angles, customFirstAnim );
		
		//move the dummy to the point where the custom animation will finish
		dummy.origin = (self.origin + offset);
		dummy_trace.angles = self.angles;
		dummy dummy_dropToGround(dummy_trace, self);
		
		//guy jumps
		self animscripted("drone_jump_anim", self.origin, self.angles, customFirstAnim);
		self waittillmatch("drone_jump_anim","end");
		if (!isdefined(self))
		{
			dummy delete();
			dummy_trace delete();
			return;
		}
	}
	self.customFirstAnim = undefined;
	
	//calculate the distance to the next run point and figure out how long it should take
	//to get there based on distance and run speed
	d = distance(self.origin, destinationPoint);
	if (!isdefined(level.droneRunRate))
		level.droneRunRate = 200;
	speed = (d/level.droneRunRate);
	
	//link the drone to the dummy for movement
	self linkto (dummy_trace);
	
	//drone loops run animation until he gets to his next point
	self thread ShooterRun_doRunAnim();
	
	//dummy will trace to the ground to keep ai on ground like magic
	dummy thread dummy_keepOnGround(speed, dummy_trace, self);
	
	//actually move the dummies now)
	dummy moveTo (destinationPoint, speed, 0, 0);
	
	//reached the point he's told to run to - stop run animations and end thread
	wait (speed);
	if (isdefined(self))
		self notify ("stop_drone_run_anim");
	
	dummy notify ("stop_debug_line");
	dummy delete();
	dummy_trace delete();
}

drones_init()
{
	level.drone_muzzleflash = loadfx ("fx/muzzleflashes/standardflashworld.efx");
	animscripts\weaponList::initWeaponList();
	setAnimArray();
}

drones_clear_variables()
{
	if(isdefined(self.voice))
		self.voice = undefined;
}

CreateShooter( spawnFunction , spawnOrigin )
{
	if (!isdefined(spawnOrigin))
		spawnOrigin = (0,0,0);
	guy = spawn("script_model", spawnOrigin );
	guy [[spawnFunction]]();
	
	guy InitShooter();
	
	return guy;
}

InitShooter()
{
	if (!isdefined (self.weaponModel))
	{
		self.weapon = "m1garand";
		weaponModel = getWeaponModel(self.weapon);
		self attach(weaponModel, "tag_weapon_right");
    }
	self.bulletsInClip = self animscripts\weaponList::ClipSize();
}

ShooterShoot( target )
{
    self thread ShooterShootThread(target);
}

#using_animtree("fakeShooters");
ShooterShootThread(target)
{
    self notify ("Stop shooting");
    self notify ("drone_shooting");
    self endon ("Stop shooting");
    self UseAnimTree(#animtree);

    self thread aimAtTargetThread ( target, "Stop shooting" );

    shootAnimLength = 0;
    while(isdefined(self))
    {
        if (self.bulletsInClip <= 0)    // Reload
        {
        	weaponModel = getWeaponModel(self.weapon);
        	if (isdefined(self.weaponModel))
        		weaponModel = self.weaponModel;
        	
        	//see if this model is actually attached to this character
        	numAttached = self getattachsize();
        	attachName = [];
        	for (i=0;i<numAttached;i++)
        		attachName[i] = self getattachmodelname(i);
        	
            self detach(weaponModel, "tag_weapon_right");
            self attach(weaponModel, "tag_weapon_left");
            self setflaggedanimknoballrestart ( "shootinganim", %reload_stand_rifle, %root, 1, 0.4 );
            self.bulletsInClip = self animscripts\weaponList::ClipSize();
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
            self playsound ("weap_m1garand_fire");
            
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

ShooterRun_doRunAnim()
{
	self endon ("stop_drone_run_anim");
	for (;;)
	{
		animRate = (level.droneRunRate/200);
		
		if (isdefined(self.customFirstRunAnim))
		{
			animName = self.customFirstRunAnim;
			self.customFirstRunAnim = undefined;
			self setflaggedanimknobrestart( "drone_run_anim" , animName, 1, .1, animRate );
		}
		else
			self setflaggedanimknobrestart( "drone_run_anim" , %drone_run_forward_1, 1, .1, animRate );
		self waittillmatch("drone_run_anim","end");
		if (!isdefined(self))
			return;
	}
}

dummy_keepOnGround(time, dummy_trace, drone)
{
	frames = (time * 20);
	for (i=0;i<frames;i++)
	{
		self dummy_dropToGround(dummy_trace, drone);
		wait 0.05;
	}
}

debugDummyLines(dummy, dummy_trace)
{
	dummy endon ("stop_debug_line");
	dummy_trace endon ("stop_debug_line");
	for (;;)
	{
		line( level.player.origin + (0,0,20), dummy.origin, (1,1,1) );
		line( level.player.origin + (0,0,20), dummy_trace.origin, (1,0,0) );
		wait 0.05;
	}
}

dummy_dropToGround(dummy_trace, drone)
{
	if (!isdefined(self))
		return;
	
	prof_begin("drone_traces");
		trace_Start = self.origin + (0,0,150);
		trace_End = self.origin - (0,0,150);
		dummy_trace.origin = physicstrace(trace_Start, trace_End);
	prof_end("drone_traces");
}

drone_debugLine(fromPoint, toPoint, color, durationFrames)
{
    for (i=0;i<durationFrames*20;i++)
    {
        line (fromPoint, toPoint, color);
        wait (0.05);
    }
}

turnToFacePoint(point)
{
    // TODO Make this turn gradually, not instantly.
	desiredAngles = VectorToAngles( point - self.origin );
	self.angles = (0,desiredAngles[1],0);
}

anglesToPoint(point)
{
	desiredAngles = VectorToAngles( point - self.origin );
    return (0,desiredAngles[1],0);
}

//---------------------------------------------------------------------------------------------------------------

Set3FlaggedAnimKnobs(animFlag, animArray, pose, weight, blendTime, rate)
{
	if (!isdefined(self))
		return;
    self setAnimKnob(%combat_directions, weight, blendTime, rate);
    self SetFlaggedAnimKnob(animFlag,    level.drone_animArray[animArray][pose]["up"],        1, blendTime, 1);
    self SetAnimKnob(                    level.drone_animArray[animArray][pose]["straight"],    1, blendTime, 1);
    self SetAnimKnob(                    level.drone_animArray[animArray][pose]["down"],        1, blendTime, 1);
}

Set3FlaggedAnimKnobsRestart(animFlag, animArray, pose, weight, blendTime, rate)
{
	if (!isdefined(self))
		return;
    self setAnimKnobRestart(%combat_directions, weight, blendTime, rate);
    self SetFlaggedAnimKnobRestart(animFlag,    level.drone_animArray[animArray][pose]["up"],        1, blendTime, 1);
    self SetAnimKnobRestart(                    level.drone_animArray[animArray][pose]["straight"],    1, blendTime, 1);
    self SetAnimKnobRestart(                    level.drone_animArray[animArray][pose]["down"],        1, blendTime, 1);
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
    pos = self.origin;// getEye();
    dir = (pos[0] - target[0], pos[1] - target[1], pos[2] - target[2]);
    dir = VectorNormalize( dir );
    fact = dir[2] * -1;
//    println ("offset "  + fact);
    return fact;
}


setAnimArray()
{
    level.drone_animArray["aim"]    ["stand"] ["down"]        = %stand_aim_down;
    level.drone_animArray["aim"]    ["stand"] ["straight"]    = %stand_aim_straight;
    level.drone_animArray["aim"]    ["stand"] ["up"]        = %stand_aim_up;

    level.drone_animArray["aim"]    ["crouch"]["down"]        = %crouch_aim_down;
    level.drone_animArray["aim"]    ["crouch"]["straight"]    = %crouch_aim_straight;
    level.drone_animArray["aim"]    ["crouch"]["up"]        = %crouch_aim_up;

    level.drone_animArray["auto"]    ["stand"] ["down"]        = %stand_shoot_auto_down;
    level.drone_animArray["auto"]    ["stand"] ["straight"]    = %stand_shoot_auto_straight;
    level.drone_animArray["auto"]    ["stand"] ["up"]        = %stand_shoot_auto_up;

    level.drone_animArray["auto"]    ["crouch"]["down"]        = %crouch_shoot_auto_down;
    level.drone_animArray["auto"]    ["crouch"]["straight"]    = %crouch_shoot_auto_straight;
    level.drone_animArray["auto"]    ["crouch"]["up"]        = %crouch_shoot_auto_up;

    level.drone_animArray["shoot"]    ["stand"] ["down"]        = %stand_shoot_down;
    level.drone_animArray["shoot"]    ["stand"] ["straight"]    = %stand_shoot_straight;
    level.drone_animArray["shoot"]    ["stand"] ["up"]        = %stand_shoot_up;

    level.drone_animArray["shoot"]    ["crouch"]["down"]        = %crouch_shoot_down;
    level.drone_animArray["shoot"]    ["crouch"]["straight"]    = %crouch_shoot_straight;
    level.drone_animArray["shoot"]    ["crouch"]["up"]        = %crouch_shoot_up;

//    level.drone_animArray["stand"]         = %crouch_cover_crouch_to_stand;
//    level.drone_animArray["crouch"]        = %crouch_cover_stand_to_crouch;
}
