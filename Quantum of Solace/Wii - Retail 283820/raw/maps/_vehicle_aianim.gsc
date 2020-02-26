

#include maps\_utility;
#include common_scripts\utility;

#using_animtree ("generic_human");

guy_enter ( guy, vehicle, lastguy )
{
	assertEX( !isdefined( guy.ridingvehicle ), "ai can't ride two vehicles at the same time" );
	if ( !isdefined( lastguy ) )
	{
		lastguy = true;
	}
	
	type = self.vehicletype;
	vehicleanim = level.vehicle_aianims[ type ];
	maxpos = level.vehicle_aianims[ type ].size;

	
	if( isdefined( guy.script_vehiclewalk ) )
	{
		pos = set_walkerpos( guy, level.vehicle_walkercount[ type ] );
		thread WalkWithVehicle( guy, pos );
		return;
	}
	
	self.attachedguys[ self.attachedguys.size ] = guy;
	
	
	pos = set_pos( guy, maxpos );
	
	if ( !isdefined( pos ) )
	{
		return;		
	}
	
	animpos = anim_pos(self,pos);
	self.usedPositions[pos] = true;
	guy.pos = pos;
	
	if( isdefined( animpos.delay ) )
	{
		guy.delay = animpos.delay;
		if( isdefined( animpos.delayinc ) )
		{
			self.delayer = guy.delay;
		}
	}
	
	if( isdefined( animpos.delayinc ) )
	{
		self.delayer+= animpos.delayinc;
		guy.delay = self.delayer;
	}
	
	guy.ridingvehicle = self;
	guy.orghealth = guy.health;
	guy.vehicle_idle = animpos.idle;			
	guy.vehicle_standattack = animpos.standattack;

	guy.deathanim = animpos.death;
	guy.deathanimscript = animpos.deathscript;

	guy.standing = 0;
	if( isdefined( guy.deathanim ) && !isdefined( guy.magic_bullet_shield ) )
	{
		guy.allowdeath = 1;
	}

	self.riders[ self.riders.size ] = guy;
	
	
	thread guy_underAttack( guy );
	
	
	thread guy_blowup( guy, pos );

	
	thread fireing( guy, pos );

	
	thread guy_fireingdirection( guy, pos );
		
	org = self gettagorigin( animpos.sittag );
	angles = self gettagAngles( animpos.sittag );
	guy linkto( self, animpos.sittag, (0, 0, 0), (0, 0, 0) );

	
	
	
	
	if( isai( guy ) )
	{
		guy teleport( org, angles );
		
		guy.a.disablelongdeath = true;
		if ( isdefined( animpos.bHasGunWhileRiding ) && !animpos.bHasGunWhileRiding )
		{
			guy.holdingWeapon = false;
			guy animscripts\shared::placeWeaponOn( self.weapon, "none" );
		}
		
		if( isdefined( animpos.mgturret ) && !( isdefined( self.script_nomg ) && self.script_nomg > 0 ) )
		{
 			
 			thread guy_man_turret( guy, pos );
		}
		
		
		thread guy_deathspeed( guy, pos );
	}
	else
	{
		guy.origin = org;
		guy.angles = angles;
	}
	
	
	if ( pos == 0 )
	{
		
		thread driverdead( guy ); 
	}
	
	
	thread guy_handle(guy,pos);
	thread guy_idle(guy,pos);

	
	
	if( lastguy && isdefined( vehicleanim[ 0 ].delayinc ) )
	{
		self.driver.delay = self.delayer;
		self.delayer += vehicleanim[ 0 ].delayinc;
	}	
}

guy_array_enter ( guysarray, vehicle )
{
	lastguy = false;
	for(i=0;i<guysarray.size;i++)
	{	if(!(i+1<guysarray.size))
			lastguy = true;
		guy_enter(guysarray[i],vehicle,lastguy);
	}
}

handle_attached_guys ()
{
	type = self.vehicletype;
	if(isdefined(level.vehicle_walkercount[type]))
		for (i=0;i<level.vehicle_walkercount[type];i++)
		{
			self.walk_tags[i] = ("tag_walker" + i);
			self.walk_tags_used[i] = false;
		}
	self.attachedguys = [];
	if(!(isdefined(level.vehicle_aianims) && isdefined(level.vehicle_aianims[type])))
		return;
	maxpos = level.vehicle_aianims[type].size;
	
	if(isdefined(self.script_noteworthy) && self.script_noteworthy == "ai_wait_go")
		thread ai_wait_go();
		
	self.runningtovehicle = [];
	self.usedPositions = [];
	self.getinorgs = [];
	self.delayer = 0;
	vehicleanim = level.vehicle_aianims[type];
	for (i=0;i<maxpos;i++)
	{
		self.usedPositions[i] = false;
		if(isdefined(self.script_nomg) && self.script_nomg && isdefined(vehicleanim[i].bIsgunner) && vehicleanim[i].bIsgunner)
			self.usedpositions[1] = true; 
	}
	thread handle_detached_guys();
}

handle_loadnearby ()
{
	while(1)
	{
		self waittill ("load_nearby",dist);
		if(!isdefined(dist))
			dist = 1000;
		loaders = [];
		assert(isdefined(self.script_team));
		ai = getaiarray(self.script_team);
		for(i=0;i<ai.size && i<self.usedPositions.size;i++)
			if(distance(ai[i].origin,self.origin) < dist)
				loaders[loaders.size] = ai[i];
		self notify ("load",loaders);		
	}
}

is_rider ( guy )
{
	for(i=0;i<self.riders.size;i++)
		if(self.riders[i] == guy)
			return true;
	return false;
}

handle_detached_guys ()
{
	self endon ("death");
	thread handle_loadnearby();
	while(1)
	{
		self waittill ("load",array);
		guysarray = [];
		if(!isdefined(array))
		{
			array = [];
			ai = getaiarray(self.script_team );
			for(i=0;i<ai.size;i++)
				if(isdefined(ai[i].script_vehicleride) && ai[i].script_vehicleride == self.script_vehicleride)
					array[array.size] = ai[i];
		}
		for(i=0;i<array.size;i++)
			if(!is_rider(array[i]) && handle_detached_guys_check())
				thread guy_runtovehicle(array[i],self);
	}
}

handle_detached_guys_check()
{
	if(vehicle_hasavailablespots())
		return true;
	else
		assertmsg("script sent too many ai to vehicle (max is: "+level.vehicle_aianims[self.vehicletype].size+")");
}

vehicle_hasavailablespots()
{
	
	
	if(level.vehicle_aianims[self.vehicletype].size-self.runningtovehicle.size)
		return true;
	else
		return false;
}

guy_runtovehicle_loaded ( guy, vehicle )
{
	vehicle endon ("death");
	guy waittill_any ("long_death","death","enteredvehicle");
	vehicle.runningtovehicle = array_remove(vehicle.runningtovehicle,guy);
	if(!vehicle.runningtovehicle.size)
		vehicle notify ("loaded");
}

guy_runtovehicle ( guy, vehicle )
{
	vehicleanim = level.vehicle_aianims[vehicle.vehicletype];
	if(isdefined(vehicle.runtovehicleoverride))
	{
		vehicle thread [[vehicle.runtovehicleoverride]](guy);
		return;
	}
	vehicle endon ("death");
	guy endon ("death");
	vehicle.runningtovehicle[vehicle.runningtovehicle.size] = guy;
	thread guy_runtovehicle_loaded(guy,vehicle);
	availablepositions = [];
	chosenorg = undefined;
	origin = 0;
	
	
	bIsgettin = false;
	for(i=0;i<vehicleanim.size;i++)
		if(isdefined(vehicleanim[i].getin))
			bIsgettin = true;
			
	if(!bIsgettin)
	{
		guy notify ("enteredvehicle");
		guy_enter_vehicle(guy,vehicle);
		return;
	}
	
	while(vehicle getspeedmph() > 1)
		wait .05;
		
	availablepositions = vehicle get_availablepositions();
	if(!vehicle.usedPositions[0])
		chosenorg = vehicle vehicle_getInstart(0);  
	else
		chosenorg = getclosest(guy.origin,availablepositions);

	if(!isdefined(chosenorg))
		return; 

	origin = chosenorg.origin+vector_multiply(vectornormalize(chosenorg.origin-vehicle.origin),15); 
	angles = chosenorg.angles;

	guy.forced_startingposition = chosenorg.pos;

	
	vehicle.usedpositions[chosenorg.pos] = true;

	guy set_forcegoal();
	guy.goalradius = 16;
	guy setgoalpos (origin);
	guy waittill ("goal");
	guy unset_forcegoal();
	if(isdefined(chosenorg))
	{
		vehicle.allowdeath = false;
		vehicle animontag(guy,vehicleanim[chosenorg.pos].sittag,vehicleanim[chosenorg.pos].getin);
		vehicle.allowdeath = true;
	}
	guy notify ("enteredvehicle");
	guy_enter_vehicle(guy,vehicle);
}

driverdead ( guy )
{
	self.driver = guy;
	self endon ("death");
	guy waittill ("death");
	self.deaddriver = true;  
}


copy_cat()
{
	model = spawn("script_model",self.origin);
	model setmodel(self.model);
	size = self getattachsize();
	for(i=0;i<size;i++)
		model attach(self getattachmodelname(i));
	return model;
}


guy_deathinvehicle ()
{
	vehicleanim = level.vehicle_aianims[self.ridingvehicle.vehicletype];
	vehicle = self.ridingvehicle;

	if(!isdefined(vehicle) || vehicle.health <= 0)
	{
		self delete();
		return;
	}

	if(!isdefined(vehicleanim[self.pos].deathrollslow) && !isdefined(vehicleanim[self.pos].deathrollfast))
	{
		



		death = vehicleanim[self.pos].death;


		self orientmode ("face current");

		self SetFlaggedAnimKnobAll("deathanim", death, %root, 1, .05, 1);
		while(vehicle.health > 0)
		{
			angles = self.ridingvehicle gettagAngles (vehicleanim[self.pos].sittag);

			self orientmode ("face angle",angles[1]);				
			wait .05;
		}

		self delete();
		return;
	}

	angles = self.ridingvehicle gettagAngles (vehicleanim[self.pos].sittag);
	self orientmode ("face angle",angles[1]);	
	if(self.deathanim == vehicleanim[self.pos].deathslow)
		self SetFlaggedAnimKnobAll("deathanim", vehicleanim[self.pos].deathrollslow, %root, 1, .05, 1);
	else
		self SetFlaggedAnimKnobAll("deathanim", vehicleanim[self.pos].deathrollfast, %root, 1, .05, 1);
	self animscripts\shared::DoNoteTracks("deathanim");
	self unlink();
	self.ridingvehicle.riders = array_remove(self.ridingvehicle.riders,self);
}

guy_deathinvehicle_enddeathloop ()
{
	self.guy_deathinvehicle_enddeathloop = false;
	self waittillmatch ("animontagdone","end");
	self.guy_deathinvehicle_enddeathloop = true;
}

guy_deathspeed ( guy, pos )
{
	animpos = anim_pos(self,pos);
	self endon ("unload");
	self endon ("death");
	guy endon ("death");
	if(!isdefined(animpos.deathslow))
		return;
	while(1)
	{
		if(self getspeedmph() < 20)
			guy.deathanim = animpos.deathslow;
		else
			guy.deathanim = animpos.deathfast;
		wait .5;
	}
}

anim_pos ( vehicle, pos )
{
	return level.vehicle_aianims[vehicle.vehicletype][pos];
}

guy_deathhandle ( guy, pos )
{
	self endon ("death");
	guy waittill ("death");
	self.riders = array_remove(self.riders,guy);
	self.usedPositions[pos] = false;	
}

guy_handle ( guy, pos )
{
	guy.buddyevent = [];
	guy.vehicle_idling = true;
	guy.vehicleride_standing = false;
	guy.vehicleride_ducking = false;
	thread guy_deathhandle(guy,pos);
	guy endon ("death");
	guy endon ("jumpedout");
	level.vehicle_aianimthread = [];
	level.vehicle_aianimthread["idle"] = ::guy_idle;
	level.vehicle_aianimthread["duck"] = ::guy_duck;
	level.vehicle_aianimthread["stand"] = ::guy_stand;
	level.vehicle_aianimthread["turn_right"] = ::guy_turn_right;
	level.vehicle_aianimthread["turn_left"] = ::guy_turn_left;
	level.vehicle_aianimthread["turn_hardright"] = ::guy_turn_hardright;
	level.vehicle_aianimthread["turn_hardleft"] = ::guy_turn_hardleft;
	level.vehicle_aianimthread["turret_fire"] = ::guy_turret_fire;
	level.vehicle_aianimthread["turret_turnleft"] = ::guy_turret_turnleft;
	level.vehicle_aianimthread["turret_turnright"] = ::guy_turret_turnright;
	level.vehicle_aianimthread["unload"] = ::guy_unload;
	level.vehicle_aianimthread["reaction"] = ::guy_turret_turnright;
	while (1)
	{
		self waittill ("groupedanimevent",other);
		if(isdefined(level.vehicle_aianimthread[other]))
		{
			guy notify ("newanim");
			thread [[level.vehicle_aianimthread[other]]](guy,pos);

			


		}
		else
			println("leaaaaaaaaaaaaaak", other);
	}
}

guy_stand( guy, pos )
{
	animpos = anim_pos(self,pos);
	vehicleanim = level.vehicle_aianims[self.vehicletype];
	if(!isdefined(animpos.standup))
		return;
	anim_endons(guy);
	animontag(guy,animpos.sittag,animpos.standup);
	guy_stand_attack(guy,pos);
	guy.vehicleride_standing = true;
}

anim_endons ( guy )
{
	guy endon ("newanim");
	self endon ("death");
	guy endon ("death");	
}

guy_stand_attack ( guy, pos )
{
	animpos = anim_pos(self,pos);
	anim_endons(guy);
	guy.standing = 1;
	mintime = 0;
	while (1)
	{
		timer2 = gettime() + 2000;
		while (gettime() < timer2 && isdefined(guy.enemy))
			animontag(guy,animpos.sittag,guy.vehicle_standattack,undefined,undefined,"firing");
		rnum = randomint(5)+10;
		for(i=0;i<rnum;i++)
			animontag(guy,animpos.sittag,animpos.standidle);
	}
}

guy_stand_down ( guy, pos )
{
	animpos = anim_pos(self,pos);
	if(!isdefined(animpos.standdown))
	{
		thread guy_stand_attack(guy,pos);
		return;
	}
	animontag(guy,animpos.sittag,animpos.standdown);
	guy.standing = 0;
	thread guy_idle(guy,pos);
}

driver_idle_speed ( driver, pos )
{
	anim_endons(driver);
	animpos = anim_pos(self,pos);
	while (1)
	{
		if(self getspeedmph() == 0)
			driver.vehicle_idle = animpos.idle_animstop;
		else
			driver.vehicle_idle = animpos.idle_anim;
		wait .25;	
	}	
}

guy_reaction ( guy, pos )
{
	animpos = anim_pos(self,pos);
	anim_endons(guy);
	if(isdefined(animpos.reaction))
		animontag(guy,animpos.sittag,animpos.reaction);
	thread guy_idle(guy,pos);
}

guy_turret_turnleft ( guy, pos )
{
	animpos = anim_pos(self,pos);
	anim_endons(guy);
	while(1)
		animontag(guy,animpos.sittag,guy.turret_turnleft);
}

guy_turret_turnright ( guy, pos )
{
	anim_endons(guy);
	animpos = anim_pos(self,pos);
	while(1)
		animontag(guy,animpos.sittag,guy.turret_turnleft);
}

guy_turret_fire ( guy, pos )
{
	anim_endons(guy);
	animpos = anim_pos(self,pos);
	if(isdefined(animpos.turret_fire))
		animontag(guy,animpos.sittag,animpos.turret_fire);
	thread guy_idle(guy,pos);
}

guy_idle ( guy, pos )
{
	anim_endons(guy);

	guy endon ("newanim");
	self endon ("death");
	guy endon ("death");	

	guy.vehicle_idling = true;
	guy notify ("gotime");
	if(!isdefined(guy.vehicle_idle))
		return; 
	animpos = anim_pos(self,pos);
	if(isdefined(animpos.mgturret))
		return; 
	if(isdefined(animpos.idle_animstop) && isdefined(animpos.idle_anim))  
		thread driver_idle_speed(guy,pos);
	while(1)
	{
		guy notify ("idle");
		if(isdefined(guy.vehicle_idle_override))
			animontag(guy,animpos.sittag,guy.vehicle_idle_override);
		else if(isdefined(animpos.idleoccurrence))  
		{
			theanim = randomoccurrance(guy,animpos.idleoccurrence);
			animontag(guy,animpos.sittag,guy.vehicle_idle[theanim]);
		}
		else	
			animontag(guy,animpos.sittag,guy.vehicle_idle);
	}
}

randomoccurrance ( guy, occurrences )
{
	range = [];
	totaloccurrance = 0;
	for(i=0;i<occurrences.size;i++)
	{
		totaloccurrance += occurrences[i];
		range[i] = totaloccurrance;
	}
	pick = randomint(totaloccurrance);
	for(i=0;i<occurrences.size;i++)
		if(pick < range[i])
			return i;
}

guy_duck ( guy, pos )
{
	anim_endons(guy);
	animpos = anim_pos(self,pos);
	if(isdefined(animpos.duckin))
		animontag(guy,animpos.sittag, animpos.duckin);
	thread guy_duck_idle(guy,pos);
	guy.vehicleride_ducking = true;
}

guy_duck_idle ( guy, pos )
{
	anim_endons(guy);
	animpos = anim_pos(self,pos);
	theanim = randomoccurrance(guy,animpos.duckidleoccurrence);
	while(1)
		animontag(guy,animpos.sittag, animpos.duckidle[theanim]);
}

guy_duck_out ( guy, pos )
{
	animpos = anim_pos(self,pos);
	if(isdefined(animpos.ducking) && guy.ducking)
	{
		animontag(guy,animpos.sittag, animpos.duckout);
		guy.ducking = false;
	}
	thread guy_idle(guy,pos);
}

guy_unload_que(guy)
{
	self endon ("death");
	self.unloadque = array_add(self.unloadque,guy);
	guy waittill_any("death","jumpedout");
	self.unloadque = array_remove(self.unloadque,guy);
	if(!self.unloadque.size)
	{
		self notify ("unloaded");
		self.unload_group = "default";
	}
}

check_unloadgroup( pos )
{
	type = self.vehicletype;
	if(!isdefined(level.vehicle_unloadgroups[type]))
		return true; 
	group = level.vehicle_unloadgroups[type][self.unload_group];
	for(i=0;i<group.size;i++)
		if(pos == group[i])
			return true;
	return false;
}


getoutrig_model_idle( model,tag,animation )
{
	self endon ("unload");
	while(1)
		animontag (model,tag,animation);
}

getoutrig_model(animpos,model,tag,animation,bIdletillunload)
{
		type = self.vehicletype;
		if(bIdletillunload)
		{
			thread getoutrig_model_idle ( model, level.vehicle_attachedmodels[type][animpos.getoutrig].tag , level.vehicle_attachedmodels[type][animpos.getoutrig].idleanim);
			self waittill ("unload");
		}
		
		thread animontag (model,tag,animation);
		wait getanimlength(animation) - .2;

		model unlink();
		self.getoutrig[animpos.getoutrig] = false;
		wait 10;
		model delete();  
}
		

setanimrestart_once( vehicle_getoutanim )
{
	
	cycletime = getanimlength(vehicle_getoutanim);
	self setanimrestart(vehicle_getoutanim);
	wait cycletime;
	self clearanim(vehicle_getoutanim,0);
}

getout_rigspawn( animatemodel,pos , bIdletillunload)
{
			if(!isdefined(bIdletillunload))
				bIdletillunload = true;
			type = self.vehicletype;
			animpos = anim_pos(self,pos);
			
			if(!isdefined(animpos.getoutrig) || self.getoutrig[animpos.getoutrig])
				return; 
			origin =  animatemodel gettagorigin (level.vehicle_attachedmodels[type][animpos.getoutrig].tag);
			angles =  animatemodel gettagangles (level.vehicle_attachedmodels[type][animpos.getoutrig].tag);
			self.getoutriganimating[animpos.getoutrig] = true;
			self.getoutrig[animpos.getoutrig] = true;  
			getoutrig_model = spawn("script_model",origin);
			getoutrig_model.angles = angles;
			getoutrig_model.origin = origin;
			getoutrig_model setmodel(level.vehicle_attachedmodels[type][animpos.getoutrig].model);
			getoutrig_model UseAnimTree(#animtree);
			getoutrig_model linkto (animatemodel,level.vehicle_attachedmodels[type][animpos.getoutrig].tag,(0,0,0),(0,0,0));								
			thread getoutrig_model(animpos,getoutrig_model, level.vehicle_attachedmodels[type][animpos.getoutrig].tag , level.vehicle_attachedmodels[type][animpos.getoutrig].dropanim, bIdletillunload);
			return getoutrig_model;
}


guy_unload ( guy, pos )
{
	animpos = anim_pos(self,pos);
	type = self.vehicletype;
	
	if(!check_unloadgroup(pos))
	{
		 thread guy_idle(guy,pos);
		 return;
	}
	thread guy_unload_que(guy);
	self endon ("death");
	guy endon ("death");
	
	delay = 0;
	if(isdefined(animpos.delay))
		delay+= animpos.delay;
	if(isdefined(guy.delay))
		delay+= guy.delay;
	if(delay)
	{
		thread guy_idle(guy,pos);
		wait delay;
	}

	
	
	hascombatjumpout = isdefined(animpos.getout_combat);
	if(!hascombatjumpout && guy.standing)
		guy_stand_down ( guy, pos );
	else if(!hascombatjumpout && !guy.vehicle_idling && isdefined(guy.vehicle_idle))
		guy waittill ("idle");
		
	guy.deathanim = undefined;
	guy.deathanimscript = undefined;
	
	guy notify ("newanim");
	
	if(isai(guy))
		guy pushplayer(true);
	
	
	
	bNoanimUnload = false;
	if(isdefined(animpos.bNoanimUnload ))
		bNoanimUnload = true;
	else if(	!isdefined(animpos.getout) ||
				(!isdefined(self.script_unloadmgguy) && (isdefined(animpos.bIsgunner) && animpos.bIsgunner)) ||
				isdefined(self.script_keepdriver) && pos == 0)
	{
		self thread guy_idle(guy,pos);
		return;
	}
	
	if(isai(guy))
	if(!(isdefined(guy.magic_bullet_shield) && guy.magic_bullet_shield == true))
		guy.health = guy.orghealth;

	guy.orghealth = undefined;
	guy endon ("death");
	guy.allowdeath = 0; 

	
	if(isdefined(animpos.bHasGunWhileRiding) && !animpos.bHasGunWhileRiding)
	{
		guy.holdingWeapon = true;
		guy animscripts\shared::placeWeaponOn( self.weapon, "none" );
	}
	
	
	if(isdefined(animpos.exittag))
		tag = animpos.exittag;
	else
		tag = animpos.sittag;
		
	
	if(hascombatjumpout && guy.standing)
		animation = animpos.getout_combat;
	else
		animation = animpos.getout;

	animatemodel = getanimatemodel();
		
	if(isdefined(animpos.vehicle_getoutanim))
	{
		animatemodel useanimtree(level.vehicleanimtree[self.model]);
		animatemodel thread setanimrestart_once(animpos.vehicle_getoutanim);

		if(isdefined(animpos.vehicle_getoutsoundtag))
			origin = 	animatemodel gettagorigin(animpos.vehicle_getoutsoundtag);
		else 
			origin = animatemodel.origin;
		if(isdefined(animpos.vehicle_getoutsound))
			sound = animpos.vehicle_getoutsound;
		else
			sound = "truck_door_open";
		thread maps\_utility::play_sound_in_space(sound,origin);
	}

	
		
	if(!bNoanimUnload)
	{
		thread guy_unlink_on_death(guy);
		
		
		if(isdefined(animpos.getoutrig))
		{

			if(!self.getoutrig[animpos.getoutrig])
			{
				thread guy_idle(guy,pos); 
				
				getoutrig_model = self getout_rigspawn( animatemodel,guy.pos,false );
				
			}			
		}

		if(isdefined(animpos.getoutrig))
		{
			self thread play_sound_on_entity(animpos.getoutsnd);
			self thread play_loop_sound_on_entity(animpos.getoutloopsnd);
		}
		guy notify ("newanim");
		animontag(guy,tag, animation);
	}
	
	self.riders = array_remove(self.riders,guy);
	self.usedPositions[pos] = false;
	guy.ridingvehicle = undefined;
	
	if(isdefined(animpos.getout_delete) && animpos.getout_delete)
	{
		guy delete();
		return;	
	}
	
	if(!isalive(self))
	{
		guy delete();
		return;	
	}

	guy unlink();
	if(!isdefined(guy.magic_bullet_shield))
		guy.allowdeath = 1; 
	
	if(!isai(guy)) 
	{ 
      if (guy.drone_delete_on_unload == true)
      {	
      	guy delete();
      	return;
      }
      guy = makerealai(guy);
	}
	
	
	if(isalive(guy))
	{
		guy.a.disablelongdeath = false;
		guy notify ("jumpedout");
		guy unlink();
		guy allowedstances("stand","crouch","prone");
		guy pushplayer(false);
		
		
		qSetGoalPos = false;
		if ( !isdefined( guy.target ) )
			qSetGoalPos = true;
		else
		{
			targetedNodes = getNodeArray( guy.target, "targetname" );
			if ( targetedNodes.size == 0 )
				qSetGoalPos = true;
		}
		
		if ( qSetGoalPos )
		{
			guy.goalradius = 600;
			guy setGoalPos( guy.origin );
		}
	}
	guy.forced_startingposition = undefined;
}

animontag ( guy, tag , animation, notetracks, sthreads, flag )
{
	if(!isdefined(flag))
		flag = "animontagdone";
		
	if(isdefined(self.modeldummy))
		animatemodel = self.modeldummy;
	else
		animatemodel = self;
	if(!isdefined(tag))
	{
		org = guy.origin;
		angles = guy.angles;
	}
	else
	{
		org = animatemodel gettagOrigin (tag);
		angles = animatemodel gettagAngles (tag);
	}
	
	guy animscripted(flag, org, angles, animation);
	
	
	if(isai(guy))
		thread DoNoteTracks(guy,animatemodel,flag);

	if(isdefined(notetracks))
		for(i=0;i<notetracks.size;i++)
		{
			guy waittillmatch (flag,notetracks[i]);
			guy thread [[sthreads[i]]]();
		}
	guy waittillmatch (flag,"end");
}


DoNoteTracks(guy,vehicle,flag)
{
	vehicle anim_endons(guy);
	guy animscripts\shared::DoNoteTracks(flag);
}

animatemoveintoplace ( guy, org, angles, movetospotanim )
{
	guy animscripted("movetospot", org, angles, movetospotanim);
	guy waittillmatch ("movetospot","end");
}

fire ()
{
	self shoot();
}

guy_vehicle_death ( guy )
{
	
	self endon ("unload");
	self waittill("death"); 
	if(isdefined(guy))
		guy delete();
}

guy_fireingdirection ( guy, pos )
{
	animpos = anim_pos(self,pos);
	if(!isdefined(animpos.standattackright))
		return;
	self endon ("unload");
	guy endon("death");
	wait (.05*pos); 
	while(1)
	{
		wait .5;
		if(!isdefined(guy.enemy))
			continue;
		org1 = guy.origin;
		org2 = guy.enemy.origin;
		forwardvec = anglestoforward(flat_angle(self.angles));
		rightvec = anglestoright(flat_angle(self.angles));
		normalvec = vectorNormalize(org2-org1);
		vectordotup = vectordot(forwardvec,normalvec);
		vectordotright = vectordot(rightvec,normalvec);
		if(vectordotup > .866)
		{
			if(guy.vehicle_standattack != animpos.standattackforward)
			{
				guy.vehicle_standattack = animpos.standattackforward;
				guy notify ("firing","end");  
			}
		}
		else if(vectordotright > 0)
		{
			if(guy.vehicle_standattack != animpos.standattackright)
			{
				guy.vehicle_standattack = animpos.standattackright;
				guy notify ("firing","end");
			}
		}
		else if(vectordotright < 0)
		{
			if(guy.vehicle_standattack != animpos.standattackleft)
			{
				guy.vehicle_standattack = animpos.standattackleft;
				guy notify ("firing","end");
			}
		}
	}
}

fireing ( guy, pos )
{
	animpos = anim_pos(self,pos);
	if(isdefined(animpos.fakefire))
		fakefire = animpos.fakefire;
	else
		fakefire = false;
	
	while(1)
	{
		guy waittillmatch("firing","fire");
		if(fakefire)
			guy shoot(1000,guy gettagorigin("tag_flash")+ vector_multiply(anglestoforward(guy gettagangles("tag_flash")),500)+(0,0,50));
		else
			guy shoot();

	}
}

guy_turn_right ( guy, pos )
{
	animpos = level.vehicle_aianims[self.vehicletype][pos];
	if(isdefined(animpos.idle_right))
		guy.vehicle_idle_override = animpos.idle_right;
}

guy_turn_left ( guy, pos )
{
	animpos = level.vehicle_aianims[self.vehicletype][pos];
	if(isdefined(animpos.idle_left))
		guy.vehicle_idle_override = animpos.idle_left;
}

guy_turn_hardright ( guy, pos )
{
	animpos = level.vehicle_aianims[self.vehicletype][pos];
	if(isdefined(animpos.idle_hardright))
		guy.vehicle_idle_override = animpos.idle_hardright;
}

guy_turn_hardleft ( guy, pos )
{
	animpos = level.vehicle_aianims[self.vehicletype][pos];
	if(isdefined(animpos.idle_hardleft))
		guy.vehicle_idle_override = animpos.idle_hardleft;
}


ai_wait_go ()
{
	self endon ("death");
	self waittill ("loaded");
	maps\_vehicle::gopath(self);
}

set_pos ( guy, maxpos)
{
	pos = undefined;
	if (isdefined (guy.forced_startingposition))
	{
		pos = guy.forced_startingposition;
		assertEx(((pos < maxpos) && (pos >= 0)), "script_startingposition on a vehicle rider must be between "+maxpos+" and 0");
	}
	if (isdefined (guy.script_startingposition) && !self.usedpositions[guy.script_startingposition])
	{
		pos = guy.script_startingposition;
		assertEx(((pos < maxpos) && (pos >= 0)), "script_startingposition on a vehicle rider must be between "+maxpos+" and 0");
	}
	else
	{
		
		for (j=0;j<self.usedPositions.size;j++)
		{
			if (self.usedPositions[j] == true)
				continue;
			pos = j;
			break;
		}
	}
	return pos;
}

guy_man_turret ( guy , pos )
{
	animpos = anim_pos(self,pos);
	turret = self.mgturret[animpos.mgturret];
	turret endon ("death");
	guy endon ("death");
	level thread maps\_mgturret::mg42_setdifficulty(turret,getdifficulty());
	turret setmode("auto_ai");
	turret setturretignoregoals(true);
		
	while(1)
	{
		if (!isdefined( guy getturret() ))
			guy useturret(turret);
		wait 1;
	}
}

guy_unlink_on_death ( guy )
{
	guy endon("jumpedout");
	guy waittill("death");
	if(isdefined(guy))
		guy unlink();
}

guy_underAttack ( guy )
{
	type = self.vehicletype;
	if(!isdefined(level.vehicle_unloadwhenattacked[type]) || !level.vehicle_unloadwhenattacked[type])
		return;
	self endon ("unload");
	guy endon ("death");
	self endon ("death");
	
	for (;;)
	{
		guy waittill ("damage", amount, attacker);
		if (!isdefined (attacker))
			continue;
		if (!isdefined (attacker.team))
			continue;
		if ( (isdefined (self.allowUnloadIfAttacked)) && (self.allowUnloadIfAttacked == false) )
			continue;
		
		if (!isdefined (self))
			return;
		wait .1;
		self notify ("unload");
		return;
	}
}

deathremove ()
{
	self delete();
}

guy_blowup ( guy, pos)
{
	type = self.vehicletype;
	if(!isdefined(level.vehicle_aianims[type][pos].explosion_death))
	{
		thread guy_vehicle_death(guy);
		return;
	}
	guy endon ("death");
	self endon ("unload");
	self waittill ("explode");	
	guy.deathanim = level.vehicle_aianims[type][pos].explosion_death;
	guy.allowdeath = 1;
	angles = self.RidingTank gettagAngles (self.tankride_tag);
	guy orientmode ("face angle",angles[1]);
	guy traverseMode("gravity");
	guy unlink();
	guy dodamage( self.health+2000,self.ridingtank.origin);
}

vehicle_animate ( animation, animtree )
{
	self UseAnimTree(animtree);
	self setAnim(animation);	
}

vehicle_getInstart ( pos )
{
	animpos = anim_pos(self,pos);
	return vehicle_getanimstart(animpos.getin,animpos.sittag,pos);
}

vehicle_getanimstart ( animation, tag, pos )
{
	struct = spawnstruct();
	org = self gettagorigin(tag);
	ang = self gettagangles(tag);
	origin = getstartorigin(org,ang,animation);
	angles = getstartangles(org,ang,animation);
	
	struct.origin = origin;
	struct.angles = angles;
	struct.pos = pos;
	return struct;
}

get_availablepositions ()
{
	vehicleanim = level.vehicle_aianims[self.vehicletype];
	availablepositions = [];
	for(i=0;i<self.usedPositions.size;i++)
		if(!self.usedPositions[i] && isdefined(vehicleanim[i].getin))
			availablepositions[availablepositions.size] = vehicle_getInstart(i);
	return availablepositions;
}

set_walkerpos ( guy, maxpos )
{
	pos = undefined;
	if (isdefined (guy.script_startingposition))
	{
		pos = guy.script_startingposition;
		assertEx(((pos < maxpos) && (pos >= 0)), "script_startingposition on a vehicle rider must be between "+maxpos+" and 0");
	}
	else
	{
		
		pos = -1;
		for (j=0;j<self.walk_tags_used.size;j++)
		{
			if (self.walk_tags_used[j] == true)
				continue;
			pos = j;
			break;
		}
		assertEX (pos >= 0, "Vehicle ran out of walking spots. This is usually caused by making more than 6 AI walk with a vehicle.");
	}
	return pos;
}

WalkWithVehicle ( guy, pos)
{
	self.walkers[self.walkers.size] = guy;
	if (!isdefined (guy.FollowMode))
		guy.FollowMode = "close";
	guy.WalkingVehicle = self;
	if (guy.FollowMode == "close")
	{
		guy.vehiclewalkmember = pos;
		level thread vehiclewalker_freespot_ondeath(guy);
	}
	guy notify ("stop friendly think");
	guy vehiclewalker_updateGoalPos(self, "once");
	guy thread vehiclewalker_removeonunload(self);
	guy thread vehiclewalker_updateGoalPos(self);
	guy thread vehiclewalker_teamUnderAttack();
}

vehiclewalker_removeonunload ( vehicle )
{
	vehicle endon ("death");
	vehicle waittill ("unload");
	vehicle.walkers = array_remove(vehicle.walkers,self);
}



shiftSides (side)
{
	if (!isdefined (side))
		return;
	if ( (side != "left") && (side != "right") )
	{
		iprintln ("Valid sides are 'left' and 'right' only");
		return;
	}
		
	
	if (!isdefined (self.WalkingVehicle))
		return;
	
	
	if (self.WalkingVehicle.walk_tags[self.vehiclewalkmember].side == side)
		return;
	
	
	for (i=0;i<self.WalkingVehicle.walk_tags.size;i++)
	{
		if (self.WalkingVehicle.walk_tags[i].side != side)
			continue;
		if (self.WalkingVehicle.walk_tags_used[i] == false)
		{
			if (self.WalkingVehicle getspeedMPH() > 0)
			{
				
				self notify ("stop updating goalpos");
				self setgoalpos (self.WalkingVehicle.backpos.origin);
				self.WalkingVehicle.walk_tags_used[self.vehiclewalkmember] = false;
				self.vehiclewalkmember = i;
				self.WalkingVehicle.walk_tags_used[self.vehiclewalkmember] = true;
				self waittill ("goal");
				self thread vehiclewalker_updateGoalPos(self.WalkingVehicle);
			}
			else
				self.vehiclewalkmember = i;
			return;
		}
		iprintln ("TANKAI: Guy couldn't move to the " + side + " side of the tank because no positions on that side are free");
	}
}

vehiclewalker_freespot_ondeath ( guy )
{
	guy waittill ("death");
	if (!isdefined (guy.WalkingVehicle))
		return;
	guy.WalkingVehicle.walk_tags_used[guy.vehiclewalkmember] = false;
}

vehiclewalker_teamUnderAttack ()
{
	self endon ("death");
	for (;;)
	{
		self waittill ("damage", amount, attacker);
		if (!isdefined (attacker))
			continue;
		if ( (!isdefined (attacker.team)) || (attacker != level.player) )
			continue;
		
		if ( (isdefined (self.RidingTank)) && (isdefined (self.RidingTank.allowUnloadIfAttacked)) && (self.RidingTank.allowUnloadIfAttacked == false) )
			continue;
		if ( (isdefined (self.WalkingVehicle)) && (isdefined (self.WalkingVehicle.allowUnloadIfAttacked)) && (self.WalkingVehicle.allowUnloadIfAttacked == false) )
			continue;
		
		self.WalkingVehicle.teamUnderAttack = true;
		self.WalkingVehicle notify ("unload");
		return;
	}
}

GetNewNodePositionAheadofVehicle ( guy )
{
	minimumDistance = 300 + (50 * (self getspeedMPH()));
	
	nextNode = undefined;
	if (!isdefined (self.CurrentNode.target))
		return self.origin;
	
	nextNode = getVehicleNode(self.CurrentNode.target,"targetname");
	
	if (!isdefined (nextNode))
	{
		if (isdefined (guy.NodeAfterVehicleWalk))
			return guy.NodeAfterVehicleWalk.origin;
		else
			return self.origin;
	}
	
	
	if (distance(self.origin, nextNode.origin) >= minimumDistance)
		return nextNode.origin;
	
	for(;;)
	{
		
		if (distance(self.origin, nextNode.origin) >= minimumDistance)
			return nextNode.origin;
		if (!isdefined (nextNode.target))
			break;
		nextNode = getVehicleNode(nextNode.target,"targetname");
	}
	
	if (isdefined (guy.NodeAfterVehicleWalk))
		return guy.NodeAfterVehicleWalk.origin;
	else
		return self.origin;
}

vehiclewalker_updateGoalPos ( tank, option )
{
	self endon ("death");
	tank endon ("death");
	self endon ("stop updating goalpos");
	self endon ("unload");
	for (;;)
	{
		if (self.FollowMode == "cover nodes")
		{
			self.oldgoalradius = self.goalradius;
			self.goalradius = 300;
			self.walkdist = 64;
			position = tank GetNewNodePositionAheadofVehicle(self);
		}
		else 
		{
			self.oldgoalradius = self.goalradius;
			self.goalradius = 2;
			self.walkdist = 64;
			position = tank gettagOrigin(tank.walk_tags[self.vehiclewalkmember]);
		}
		
		
		if ( (isdefined (option)) && (option == "once") )
		{
			trace = bulletTrace((position + (0,0,100)), (position - (0,0,500)), false, undefined);
			if (self.FollowMode == "close")
				self teleport (trace["position"]);
			self setGoalPos (trace["position"]);
			return;
		}
		
		
		tankSpeed = tank getspeedmph();
		if (tankSpeed > 0)
		{
			trace = bulletTrace((position + (0,0,100)), (position - (0,0,500)), false, undefined);
			self setGoalPos (trace["position"]);
		}
		wait 0.5;
	}
}

fastrope_getpivot(origin)
{
	ent = spawn("script_origin",origin);
	ent.origin = origin;

	start = ent.origin;
	
	end = physicstrace(start, (start + (0,0,-10000)) );
	
	
	dist = distance(start, end) + 1;
	turndistance = 400;
	range = int(dist - (128+distance(ent.origin,self.origin)));

	turns = int(range/turndistance);
	remainder = range - (turndistance * turns);
	fraction = remainder / turndistance;
	time = (turns + fraction) * 1.6; 
	ang = (fraction * -360);
	angle = (ent.angles + (0, ang, 0));
	
	if(time < 0)
		time = 1; 

	ent.range		= range;
	ent.time		= time;
	ent.startangle	= angle;
	
	return ent;
}

getanimatemodel()
{
	if(isdefined(self.modeldummy))
		return self.modeldummy;
	else
		return self;	
}
