#include maps\_utility;
#include maps\_anim;
#include maps\mo_tools;

stairs()
{
	while(1)
	{
		self waittill("trigger", other);
	
		other thread stairs_proc(self);
	}
}

stairs_proc(trigger)
{
	self endon("death");
	
	if( isdefined(self.beforestairs_animplaybackrate) )
		return;
	self.beforestairs_animplaybackrate = self.animplaybackrate;
	
	self.animplaybackrate = .8;
		
	while( self istouching(trigger) )
		wait .05;
	
	self.animplaybackrate = self.beforestairs_animplaybackrate;
	
	wait .2;
	self.beforestairs_animplaybackrate = undefined;
}

escape_event()
{	
	type 	= "fx";
	fx 		= undefined;
	oneshotsnd = undefined; 
	loopsnd	= undefined;
	
	quake 	= 0;
	flags 	= undefined;
	
	rotang	= undefined;
	rottime	= undefined;
	rotacc	= undefined;
	rotdec 	= undefined;
	
	targets = undefined;
	gravity = -500;
	
	attr = strtok(self.script_parameters, ":;,= ");
	for(i=0; i<attr.size; i++)
	{
		switch( tolower( attr[i] ) )
		{
			 case "type":
			 	i++;
			 	type = attr[i];
			 	break;
			 case "quake":	
			 	i++;
			 	if( tolower( attr[i] ) == "true" )
			 		quake = 1;
			 	else if(tolower( attr[i] ) == "playeronly" )
			 		quake = 2;
			 	break;
			 case "fx":
			 	i++;
			 	fx = attr[i];
			 	break;
			 case "snd":
			 	i++;
			 	loopsnd = attr[i];
			 	break;
			 case "sndloop":
			 	i++;
			 	loopsnd = attr[i];
			 	break;
			 case "sndoneshot":
			 	i++;
			 	oneshotsnd = attr[i];
			 	break;
			 case "flag":
			 	i++;
			 	flags = attr[i];
			 	break;
			 case "rotang":
			 	i++;
			 	rotang = ( int(attr[i]), int(attr[i+1]), int(attr[i+2]) );
			 	i+=2;
			 	break;
			 case "rottime":
			 	i++;
			 	miliseconds = int(attr[i]);
			 	rottime = miliseconds * .001;
			 	break;
			 case "rotacc":
			 	i++;
			 	miliseconds = int(attr[i]);
			 	rotacc = miliseconds * .001;
			 	break;
			 case "rotdec":
			 	i++;
			 	miliseconds = int(attr[i]);
			 	rotdec = miliseconds * .001;
			 	break;
		}
	}
	
	self waittill("trigger");
	
	switch(type)
	{
		case "fx":
			targets = getstructarray(self.target, "targetname");
			for(i=0; i<targets.size; i++)
			{
				fxnode = spawn("script_model", targets[i].origin);
				fxnode.angles = targets[i].angles;
				fxnode setmodel("tag_origin");
				fxnode hide();
				
				fxnode thread escape_event_fx(fx, oneshotsnd, loopsnd, flags);
			}
			break;	
		case "physics":
			targets = getentarray(self.target, "targetname");
			for(i=0; i<targets.size; i++)
			{
				magnitude 	= gravity;
				offset 		= ( randomfloat(20),randomfloat(20),randomfloat(20) );
				contact 	= targets[i].origin + offset;
				velocity 	= anglestoup(level._sea_org.angles);
				
				if( isdefined(targets[i].target) )
				{
					return;
					/*
					struct = getstruct(targets[i].target, "targetname");
					if(	isdefined( struct.script_noteworthy ) )
						magnitude = int(struct.script_noteworthy);
					if( isdefined( struct.angles ) )
						velocity = anglestoforward( struct.angles );
					contact = struct.origin;
					*/
				}
												
				velocity = velocity * magnitude;
				targets[i] physicsLaunch( contact, velocity );
			}
			break;	
		case "rotate":
			targets = getentarray(self.target, "targetname");
			for(i=0; i<targets.size; i++)
			{
				if( isdefined(targets[i].target) )
				{
					attachments = getentarray(targets[i].target, "targetname");
					for(j=0; j<attachments.size; j++)
						attachments[j] linkto( targets[i] );	
				}
				oneshotsnd = loopsnd;
				targets[i] thread escape_event_rotate( oneshotsnd, rotdec, rotacc, rotang, rottime );
			}
			break;
	}
	
	
	if(!quake)
		return;
	
	if(quake > 1)
	{
		earthquake(0.25, .75, level.player.origin, 1024);
		return;
	}
	
	if( distance(level.player.origin, self.origin) < 700 )
	{
		earthquake(0.4, 1.25, level.player.origin, 1024);
		thread escape_event_player();
	}
		
	if(!isdefined(level.escape_stumble_num) )
		level.escape_stumble_num = 1;
	
	keys = getarraykeys( level.heroes3 );
	for(i=0; i<keys.size; i++)
	{
		key = keys[i];
		level.heroes3[ key ] thread escape_event_ai(level.escape_stumble_num);	
		if(level.escape_stumble_num < 3)
			level.escape_stumble_num++;
		else
			level.escape_stumble_num = 1;
	}
		
	array_wait(level.heroes3, "done_stumbling");
	level notify("let player up");
}

escape_event_rotate( snd, rotdec, rotacc, rotang, rottime )
{
	if(isdefined(snd))
		self thread play_sound_on_entity(snd);
		
	ang = self.angles;
	
	if(isdefined(rotdec))
		self rotateto(rotang, rottime, rotacc, rotdec);
	else if(isdefined(rotacc))
		self rotateto(rotang, rottime, rotacc);
	else
	{
		self rotateto(rotang, rottime);
		wait rottime;
		//now bounch
		newang = ang + vector_multiply(rotang, .3);
		newtime = rottime * .3;
		self rotateto(newang, newtime, 0, newtime);
		wait newtime;
		self rotateto(rotang, newtime, newtime, 0);
	}
}

escape_event_fx(fx, oneshotsnd, loopsnd, flags)
{
	playfxontag(level._effect[fx], self, "tag_origin");
	
	self thread escape_event_sndfx(oneshotsnd, loopsnd);
	if( !isdefined(flags) )
		return;
	
	flag_wait(flags);
	self delete();
}

escape_event_sndfx(oneshotsnd, loopsnd)
{
	if(isdefined(oneshotsnd))
		self play_sound_on_entity(oneshotsnd);
	if(isdefined(loopsnd))
		self play_sound_on_entity(loopsnd);
}

escape_event_ai(num)
{
	name = "stumble" + num;
	self.springleak = true;
	
	length = getanimlength( level.scr_anim[self.animname][name]);
	self thread anim_single_solo(self, name);
	
	wait length - .2;
	self stopanimscripted();
	self notify("single_anim_done");
	
	self notify("done_stumbling");
	self.springleak = false;
}

escape_event_player()
{
	level.player allowStand(false);
	level.player allowProne(false);
	level.player setvelocity( (0,1,0) );
	player_speed_set(135, .1);
	thread player_speed_set(185, 1.25);
	
	level waittill("let player up");
	
	level.player allowStand(true);
	wait .05;
	level.player allowCrouch(false);
	level.player allowStand(true);
	wait .05;
	level.player allowCrouch(true);	
}

misc_light_flicker( fxname, fxflag, startflag )
{
	minDelay = .25;
	maxDelay = .45;
	on = self getLightIntensity();
	off = 0;
	offmodel = undefined;
	onmodel = undefined;
	curr = on;
	num = 0;
	modelswap = false;
	fxswap = false;
	fxlight = undefined;
	
	if( isdefined( fxname ) )
	{
		fxarray = getfxarraybyID( fxname );
		fxlight = getClosestFx(self.origin, fxarray);
		fxswap = true;
	}
	
	modelarray = getentarray("script_lightmodel", "targetname");
	model = getClosest(self.origin, modelarray, 32);
	
	if( isdefined(model) )
	{
		onmodel = model.model;
		modelswap = true;
		switch(onmodel)
		{
			case "com_lightbox_on":
				offmodel = "com_lightbox";
				break;	
			case "ch_industrial_light_02_on":
				offmodel = "ch_industrial_light_02_off";
				break;	
			case "me_lightfluohang_on":
				offmodel = "me_lightfluohang";
				break;	
		}
	}
	
	if(isdefined( startflag ))
		flag_wait( startflag );
	
	while( 1 )
	{
		num = randomintrange(1, 10);
		while( num )
		{
			wait( randomfloatrange(.05, .1) );
			
			if(curr == on)
			{
				curr = off;
				self setLightIntensity(off);
				if(fxswap)
					fxlight pauseEffect();
				if(modelswap)
					model setmodel(offmodel);
			}
			else if( flag(fxflag) )
			{
				curr = on;
				self setLightIntensity(on);
				if(fxswap)
					fxlight restartEffect();
				if(modelswap)
					model setmodel(onmodel);
			}		
			else 
				flag_wait(fxflag);	
						
			num--;			
		}
			
		wait( randomfloatrange( minDelay, maxDelay ) );
	}
}

escape_heroes_holdtheline( pushdist , pack, sprintdist)
{
	self notify( "stop_dynamic_run_speed" );
	self endon( "stop_dynamic_run_speed" );
	self.oldwalkdist = self.walkdist;
	self.old_animplaybackrate = self.animplaybackrate;
	self.run_speed_state = "";
	self.oldanimname = self.animname;
	self.animname = "escape";
	self.dist = 0;
	self.springleak = false;
	if( !isdefined(sprintdist) )
		sprintdist = pushdist * .5;
		
	aimaxdist = 100;
	aimindist = 50;
	aimaxsprintdist = 200;
	aimaxsprintrate = 1.16;
	
	while ( true )
	{
		wait 0.05;
			
		self.dist = distance( self.origin, level.player.origin );
		dist = self.dist;
		
		order = escape_heroes_findorder(pack);
				
		if( order["last"].run_speed_state == "sprint")
		{
			switch(self.position)
			{
				case "lead":
					if( distance(self.origin, order["middle"].origin) < aimaxsprintdist )
						dist = order["last"].dist;
					break;
				case "middle":
					if( distance(self.origin, order["last"].origin) < aimaxsprintdist )
						dist = order["last"].dist;
					break;
			}
		}	
		
		else if(order["lead"].run_speed_state == "walk")
		{
			switch(self.position)
			{
				case "middle":
					if( distance(self.origin, order["lead"].origin) < aimaxdist )
						dist = order["lead"].dist;
					break;
				case "last":
					if( distance(self.origin, order["middle"].origin) < aimaxdist )
						dist = order["lead"].dist;
					break;
			}
		}	
		
		if( self.run_speed_state == "sprint" )
		{
			aimaxdist = 125;
			aimindist = 75;
		}
		else
		{
			aimaxdist = 100;
			aimindist = 50;
		}
		
		switch(self.position)
		{
			case "lead":
			{
				if( distance(self.origin, order["middle"].origin) < aimindist )
				{
					if( self.animplaybackrate < 1.2)
						self.animplaybackrate += .05;
				}
				else if( distance(self.origin, order["middle"].origin) > aimaxdist)
				{
					if( self.animplaybackrate > .8)
						self.animplaybackrate -= .05;
				}
				
				else if ( self.run_speed_state == "sprint"  && self.animplaybackrate != aimaxsprintrate)
					self.animplaybackrate = aimaxsprintrate;
				
				else if( self.animplaybackrate < 1)
					self.animplaybackrate += .05;
				else if( self.animplaybackrate > 1)
					self.animplaybackrate -= .05;
				
			}break;
			
			case "middle":	
			{
				if( distance(self.origin, order["last"].origin) < aimindist )
				{
					if( self.animplaybackrate < 1.2)
						self.animplaybackrate += .05;
				}
				else if( distance(self.origin, order["last"].origin) > aimaxdist)
				{
					if( self.animplaybackrate > .8)
						self.animplaybackrate -= .05;
				}
				
				else if ( self.run_speed_state == "sprint"  != self.animplaybackrate < aimaxsprintrate)
					self.animplaybackrate = aimaxsprintrate;
				
				else if( self.animplaybackrate < 1)
					self.animplaybackrate += .05;
				else if( self.animplaybackrate > 1)
					self.animplaybackrate -= .05;
			}break;
		}
		
		if ( dist < sprintdist )
		{							
			// sprint when player is inside half push dist or ai is not ahead of player.
			if ( self.run_speed_state == "sprint" || self.springleak == true)
				continue;
			
			if ( self.animplaybackrate < aimaxsprintrate)
				self.animplaybackrate = aimaxsprintrate;
									
			self.run_speed_state = "sprint";
			self set_run_anim( "sprint" );
		}
		else if ( dist < pushdist )
		{
			// run when player is inside push dist.
			if ( self.run_speed_state == "run" )
				continue;
			self.animplaybackrate = 1;
			self.run_speed_state = "run";
			self clear_run_anim();
		}
		else if ( dist < pushdist * 2 )
		{
			if ( self.run_speed_state == "walk" || self.springleak == true )
				continue;
			self.animplaybackrate = 1;
			self.run_speed_state = "walk";
			self set_run_anim( "jog" );
		}
	}
}

escape_heroes_findorder(pack)
{
	order = [];
	i=0;
	
	order["last"] 	= pack[0];			
	for(i=1; i<pack.size; i++)
	{
		comparison1 = distancesquared( order["last"].origin, level.player.origin );
		comparison2 = distancesquared( pack[i].origin, level.player.origin );
		if( comparison1 > comparison2 )
			order["last"] 	= pack[i];
	}
	
	order[2] 				= order["last"];
	order["last"].position 	= "last";	
	
	
	order["lead"] = pack[0];
	for(i=1; i<pack.size; i++)
	{
		comparison1 = distancesquared( order["lead"].origin, level.player.origin );
		comparison2 = distancesquared( pack[i].origin, level.player.origin );
		if( comparison1 < comparison2 )
			order["lead"] 	= pack[i];
	}
	
	order[0] 				= order["lead"];
	order["lead"].position 	= "lead";
	
	
	for(i=0; i<pack.size; i++)
	{
		if(pack[i] != order["lead"] && pack[i] != order["last"] )
		{
			order["middle"] = pack[i];	
			order[1] 		= pack[i];
			pack[i].position = "middle";
			break;
		}
	}	

	return order;
}

escape_heroes_run_wait(name)
{
	msg = name + "_flag";
	level endon( msg );
	
	temp = getnodearray(name + "_end","targetname");
	nodes = [];
	
	for(i=0; i<temp.size; i++)
		nodes[ int(temp[i].script_noteworthy) ] = temp[i];
	
	//who's furthest left
	pack = [];
	pack[ pack.size ] = level.heroes3["price"];
	pack[ pack.size ] = level.heroes3["alavi"];
	pack[ pack.size ] = level.heroes3["grigsby"];
	
	order = escape_heroes_findorder(pack);
	
	for(i=0; i< 3; i++)
	{
		if(order[i].script_noteworthy == self.script_noteworthy)
		{
			self thread enable_arrivals();
			self setgoalnode( nodes[ (i+1) ] );
			self.goalradius = 16;	
			break;
		}
	}	
}

escape_waterlevel_parts(model)
{
	switch(self.script_noteworthy)
	{
		case "path":
			model.path = self;
			break;
		case "fx_locked":
			fxnode = spawn("script_model", self.origin );
			fxnode.angles = self.angles + (-90,0,90);
			fxnode setmodel("tag_origin");
			fxnode linkto(model);
			
			model waittill("show");	
					
			self thread escape_waterlevel_parts_fx("sinking_waterlevel_center", fxnode, model);
			break;
		case "fx_norotate":
			fxpos = spawn("script_origin", self.origin );
			fxpos linkto(model);
			model waittill("show");
			fxnode = spawn("script_model", self.origin );
			fxnode.angles = self.angles + (-90,0,90);
			fxnode setmodel("tag_origin");
			
			self thread escape_waterlevel_parts_fx("sinking_waterlevel_edge", fxnode, model);
			fxnode endon ("death");
			while(1)
			{
				fxnode moveto(fxpos.origin, .1);
				wait .1;				
			}break;
	}	
}

escape_waterlevel_parts_fx(name, fxnode, model)
{
	startflag 	= undefined;
	endflag 	= undefined;
	
	attr = strtok(model.script_parameters, ":;,= ");
	for(i=0; i<attr.size; i++)
	{
		switch( tolower( attr[i] ) )
		{
			 case "fxstartflag":
			 	i++;
			 	startflag = attr[i];
			 	break;
			 case "fxendflag":
				 i++;
			 	endflag = attr[i];
			 	break;
		}
	}
	
	if( isdefined( startflag ) )
	{
		flag_wait( startflag );
		wait 1;
	}
		
	playfxontag(level._effect[name], fxnode, "tag_origin");
		
	if( isdefined( endflag ) )	
	{
		flag_wait( endflag );
		fxnode delete();
	}
}

escape_quake()
{
	level.player endon("stopquake");		
	while(1)
	{
		wait .1;
		earthquake(0.15, .1, level.player.origin, 256);
	}
}

escape_explosion_drops()
{
	bigcontainer = getent("escape_first_falling_container", "targetname");
	bigcontainerend = getent("escape_first_fallen_container","targetname");
	
	time = 2;
	acc = 0;
	dec = 0;
	
	bigcontainer rotateto( (0,45,0), 2);
	
	wait time;
	
	bigcontainer delete();
	bigcontainerend show();
	
	blockerstart = getentarray("escape_big_blocker_before","targetname");
	blockerend = getentarray("escape_big_blocker","targetname");
	
	for(i=0; i< blockerstart.size; i++)
		blockerstart[i] delete();
	
	for(i=0; i< blockerend.size; i++)
	{
		blockerend[i] show();
		blockerend[i] solid();
		if(blockerend[i].spawnflags & 1)
			blockerend[i] disconnectpaths();
	}
}

escape_shellshock()
{
	level.player shellshock("cargoship", 14);	
	
	org = spawn("script_model", level.player.origin);
	org.angles = level.player getplayerangles();
	org setmodel("tag_origin");
	level.player playerlinktodelta (org, "tag_origin", 1, 10, 10, 10, 10);
	org thread play_loop_sound_on_entity("shellshock_loop");	
	playerWeaponTake();
	
	org rotateto( (358.273, 286.02, -89.0164), .75, 0, 0);
	org moveto( ( org.origin + (-60, 0, 3) ) , .75);//rotate side
	wait .75;
	org rotateto( (344.064, 286.67, -93.2207), .2, 0, .2);//bounce up
	org moveto( ( org.origin + (0, 0, 16) ) , .2, 0, .2);
	wait .125;
	org rotateto( (358.273, 286.02, -89.0164), .2, .2, 0);//come down
	org moveto( ( org.origin + (0, 0, -8) ) , .2, .2, 0);
	wait 1.25;
	org rotateto( (321.374, 134.198, 58.7419), 4, 2, 2);
	org moveto( ( org.origin + (0, 0, -36) ) , 2, 2, 0);
	wait 2;
	org moveto( ( org.origin + (0, 0, 36) ) , 2, 0, 2);
	wait 2;
	level notify("escape_show_waterlevel");
	org rotateto( (330.674, 192.977, -13.8899), 2.25, 1, 1);
	org moveto( ( org.origin + (0, 0, -16) ) , 2.25, 2, 0);
	wait 2.25;
	org rotateto( (327.722, 180.996, -2.2776), 1, .5, .5);
	wait 1;
	
	wait .5;
	
	org rotateto( (-10, 180, 0), 1.25);
	org moveto( ( org.origin + (0, 0, 0) ) , 1.25);
	wait 1;
	
	org rotateto( (32.3864, 132.707, 29.6049), 1.25);
	wait .5;
	org moveto( ( org.origin + (0, 0, 10) ) , 1.5);
	wait .75;
	org rotateto( (0, 180, 10), 1.25);
	wait 1.24;
	org stop_loop_sound_on_entity("shellshock_loop");
	org thread play_sound_on_entity("shellshock_end");
	
	level notify("escape_unlink_player");
	level.player unlink();
	org delete();
}

PlayerMaskPuton()
{
	orig_nightVisionFadeInOutTime = GetDvar( "nightVisionFadeInOutTime" );
	orig_nightVisionPowerOnTime = GetDvar( "nightVisionPowerOnTime" );
	SetSavedDvar( "nightVisionPowerOnTime", 0.5 );
	SetSavedDvar( "nightVisionFadeInOutTime", 0.5 );
	SetSavedDvar( "overrideNVGModelWithKnife", 1 );
	SetSavedDvar( "nightVisionDisableEffects", 1 );

	wait( 0.01 ); //give the knife override a frame to catch up
	level.player ForceViewmodelAnimation( "facemask", "nvg_down" );
	wait( 2.0 );
	SetSavedDvar( "hud_gasMaskOverlay", 1 );
	wait( 2.5 );

	SetSavedDvar( "nightVisionDisableEffects", 0 );
	SetSavedDvar( "overrideNVGModelWithKnife", 0 );
	SetSavedDvar( "nightVisionPowerOnTime", orig_nightVisionPowerOnTime );
	SetSavedDvar( "nightVisionFadeInOutTime", orig_nightVisionFadeInOutTime );
}

priceCigarDelete()
{
	wait 26;
	self delete();
}

priceCigarExhaleFX(cigar)
{
	cigar endon ("death");
	for (;;)
	{
		self waittillmatch("single anim", "exhale");
		playfxOnTag (level._effect["cigar_exhale"], self, "tag_eye");
	}	
}

priceCigarPuffFX(cigar)
{
	cigar endon ("death");
	for (;;)
	{
		self waittillmatch("single anim", "puff");
		playfxOnTag (level._effect["cigar_glow_puff"], cigar, "tag_cigarglow");
		wait 1;
		playfxOnTag (level._effect["cigar_smoke_puff"], self, "tag_eye");
	}	
}

execute_ai_solo(guy, delay, numshots, accurate)
{
	ai = [];
	ai[0] = guy;
	if( !isdefined( accurate ) )
		accurate = false;
	execute_ai(ai, delay, numshots, accurate);
}

execute_ai(ai, delay, numshots, accurate)
{	
	shots = 0;
	if(!isdefined(delay))
		delay = 0;
	if(!isdefined(accurate))
		accurate = false;
	
	while( isdefined(self.execute_mode) && self.execute_mode == true )
		self waittill( "execute_mode" );
	
	self.execute_mode = true;
	
	cqboff = true;
	if( isdefined(self.cqbwalking) && self.cqbwalking)
		cqboff = false;
	
	for(i=0; i< ai.size; i++)
	{
		//select an enemy
		if( !isalive( ai[i] ) || isdefined( ai[i].execute_target ) )
			continue;
		
		//create a target and link it to the enemy
		ai[i].execute_target = true;
		target = spawn("script_origin", ai[i] gettagorigin("j_spine4"));
		target linkto(ai[i], "j_spine4");
		self enable_cqbwalk_ign_demo_wrapper();
		self cqb_aim( target );
		
		if( accurate )
		{
			while(	abs( vectordot(self gettagangles( "tag_flash" ), vectornormalize(target.origin - self gettagorigin( "tag_flash" )) ) ) < .95  )
				wait .05;
		}
		wait delay;
		
		//now fire on him until he's dead
		if(isdefined(numshots))
			shots = numshots;
		else
			shots = randomintrange(3,6);
		
		if( accurate )
		{
			while( isalive(ai[i]) )
				self burstshot(shots);
		}
		else
		{
			self burstshot(shots);
			ai[i] dodamage(ai[i].health + 300, self gettagorigin("tag_flash") );		
		}
		//wait .2;
		target delete();
		//wait a second, then find another target
		wait .1;
	}
	
	self cqb_aim( undefined );
	if(cqboff)
		self disable_cqbwalk_ign_demo_wrapper();
	self.execute_mode = false;
	self notify( "execute_mode" );
}

burstshot(shots)
{
	for(i=0; i<shots; i++)
	{
		self shoot();
		wait .1;
	}
}

#using_animtree("generic_human");
patrol()
{
	//self ==> the AI doing the patrol
	//eNode ==> (optional) the AI will patrol back and forth between connected nodes, 
	//           or just navigate and stay at the one node (optional because can just have AI target a node

	self thread patrol2();
	
	self allowedstances( "stand" );
	self.disableArrivals = true;

	self endon("patrol_stop");
	self endon ("damage");
	
	self.animname = "patrol";
	self set_run_anim( "walk" + randomintrange(1,5) );

	
	
	nodes = [];
	nodes[nodes.size] = getnode( self.target, "targetname" );
	while( isdefined( nodes[ nodes.size - 1 ].target ) )
		nodes[ nodes.size ] = getnode( nodes[ nodes.size - 1 ].target, "targetname" );
		
	self attach( "com_flashlight_on" ,"tag_inhand", true );
	self flashlight_light( true );
	
	self waittill("goal");
	
	index = 0;
	while( 1 )
	{		
		index++;
		if(index < nodes.size)
		{
			node = nodes[ index ];
			self setgoalnode( node );
			if(node.radius)
				self.goalradius = node.radius;
			else
				self.radius = 16;
			
			self waittill("goal");
			continue;
		}
		
		//self anim_single_solo(self, "pause");
		self anim_single_solo(self, "turn");
		
		index = 0;
		nodes = array_reverse(nodes);		
	}
}

patrol2()
{
	self waittill_either("damage", "patrol_stop");
	self notify("stopanimscripted");
	self stopanimscripted();
	
	self clear_run_anim();
	
	self thread enable_arrivals();
	
	self flashlight_light( false );
	self detach( "com_flashlight_on" ,"tag_inhand" );
}

flashlight_light( state )
{
	flash_light_tag = "tag_light";

	if ( state )
	{
		flashlight_fx_ent = spawn( "script_model", ( 0, 0, 0 ) );
		flashlight_fx_ent setmodel( "tag_origin" );
		flashlight_fx_ent hide();
		flashlight_fx_ent linkto( self, flash_light_tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );

		self thread flashlight_light_death( flashlight_fx_ent );
		playfxontag( level._effect["flashlight"], flashlight_fx_ent, "tag_origin" );
	}
	else
		self notify( "flashlight_off" );
}

flashlight_light_death( flashlight_fx_ent )
{
	self waittill_either( "death", "flashlight_off");
	flashlight_fx_ent delete();
}

door_opens( mod )
{
	self playsound ("wood_door_kick");
	rotation = -140;
	if ( isdefined( mod ) )
		rotation *= mod;
	self rotateyaw( rotation, .3, 0, .3);
}

txt_voice(time, color, line1, line2, line3, line4, size)
{
	self endon("death");
	clr = (0,1,0);//defaults to green
	txtsize = .5;
	if(isdefined(size))
		txtsize = size;
	
	if( isdefined( color ) )
	{	
		switch( color )
		{
			case "r":
				clr = (1,0,0); 
				break;
			case "b":
				clr = (0,0,1); 
				break;
			case "g":
				clr = (0,1,0); 
				break;
			case "y":
				clr = (1,1,0); 
				break;
		}
	}	
	
	msg = [];
	if(isdefined(line4))
		msg[msg.size] = line4;
	if(isdefined(line3))
		msg[msg.size] = line3;
	if(isdefined(line2))
		msg[msg.size] = line2;
	if(isdefined(line1))
		msg[msg.size] = line1;
	
	count = int(time * 20);
	
	if(self == level.player)
	{
		while (count)
		{
			ang = level.player getplayerangles();
			vec = anglestoforward(ang);
			vec = vector_multiply(vec, 96 );
			aboveHead = level.player.origin + vec + (0,0,64);
			txtsize = .25;
			clr = (1,1,0);
			
			for (i = 0 ; i < msg.size; i++)
			{
				print3d (aboveHead, msg[i], clr, 1, txtsize);	// origin, text, RGB, alpha, scale
				aboveHead += (0,0, 10 * txtsize);
			}
			wait 0.05;
			count--;
		}	
	}
	else
	{
		while (count)
		{
			aboveHead = self.origin + (0,0,64);
			for (i = 0 ; i < msg.size; i++)
			{
				print3d (aboveHead, msg[i], clr, 1, txtsize);	// origin, text, RGB, alpha, scale
				aboveHead += (0,0, 10 * txtsize);
			}
			wait 0.05;
			count--;
		}	
	}
}

heli_flypath(node)
{
	level.heli notify("heli_flypath");
	level.heli endon("heli_flypath");
	
	while( isdefined(node) )
	{
		stop = true;
		if( isdefined(node.target) )
			stop = false;
					
		level.heli.vehicle setvehgoalpos( node.origin + (0,0,150), stop );
		level.heli.vehicle setNearGoalNotifyDist( 150 );
		level.heli.vehicle waittill( "near_goal" );	
	
		if( isdefined(node.target) )
			node = getstruct( node.target, "targetname" );
		else
			node = undefined;
	}
}

heli_circle_area_start(name)
{
	self.vehicle setspeed( 20, 8, 8 );
	self.vehicle sethoverparams( 16, 10, 3 );
	self.vehicle cleartargetyaw();
	self.vehicle cleargoalyaw();
	self.vehicle clearlookatent();	
		
	self endon("stop_circling_area");
	
	spot = getstruct( name, "targetname");
	self thread heli_circle_area_gun();				
	while(1)
	{				
		self.vehicle setvehgoalpos( spot.origin, 1);
		self.vehicle setNearGoalNotifyDist( 64 );
		self.vehicle settargetyaw(spot.angles[1]);
		
		self.vehicle waittill( "near_goal" );
		wait 5;
		
		if( isdefined( spot.target ) )
			spot = getstruct( spot.target, "targetname" );
		else
			spot = getstruct( name, "targetname");
	}
}
heli_circle_area_gun()
{
	self endon("stop_circling_area");
	self.model.minigun[self.model.minigun_control] setplayerspread(15);
	self.model.minigun[self.model.minigun_control] setaispread(15);
	
	while(1)
	{
		if(isdefined(self.model.spotlight.targetobj))
		{
			self.model.minigun[self.model.minigun_control] settargetentity(self.model.spotlight.targetobj);
			self.model heli_minigun_burstfire();
		}
			
		wait 5;
		self.model heli_minigun_stopfire();
		self.model.minigun[self.model.minigun_control] cleartargetentity();
		wait 6;
	}
}

heli_circle_area_stop()
{
	self notify("stop_circling_area");
	self.model heli_minigun_stopfire();
	self.model.minigun[self.model.minigun_control] cleartargetentity();
}

heli_minigun_fire()
{
	self.minigun[self.minigun_control] thread heli_minigun_firethread(false);
}

heli_minigun_burstfire()
{
	self.minigun[self.minigun_control] thread heli_minigun_firethread(true);
}

heli_minigun_stopfire()
{
	self.minigun[self.minigun_control] notify( "stop_firing" );
}

heli_minigun_firethread(burst)
{
	self endon( "stop_firing" );
	while(1)
	{
		timer = randomfloatrange( 0.2, 0.7 ) * 20;
		
		for ( i = 0; i < timer; i++ )
		{
			self shootturret();
			self shootturret();
			self shootturret();
			wait( 0.05 );
		}
		
		if(isdefined(burst) && burst == true)
			wait( randomfloat( 0.5, 2 ) );
	}
}

deck_minigun_dodamage()
{
	self endon("stop_damage");
	self endon("death");
	
	glass = getentarray ("glass", "targetname");
		
	dist = 64;
	distsqrd = dist * dist;
	dist2 = 64;
	distsqrd2 = dist2 * dist2;
	
	while(1)
	{
		for( i = 0; i < glass.size; i++ )
		{
			if( !isdefined(glass[i]) )
				continue;
			if(distancesquared(glass[i] getorigin(), self.origin) < distsqrd)
			{
				glass[i] thread deck_minigun_dodamage_to_ent();		
				glass = array_remove(glass, glass[i]);
				break;
			}
		}
		
		for( i = 0; i < level.aftdeck_enemies.size; i++ )
		{
			if( !isdefined( level.aftdeck_enemies[ i ] ) )
				continue;
			if( !isalive( level.aftdeck_enemies[ i ] ) )
				continue;
			if( distancesquared( level.aftdeck_enemies[ i ] getorigin(), self.origin ) < distsqrd2 )
			{
				
				level.aftdeck_enemies[i] thread deck_minigun_dodamage_to_ent("generic_death_russian_" + randomintrange(1,8));	
				level.aftdeck_enemies = array_remove(level.aftdeck_enemies, level.aftdeck_enemies[i]);
				break;
			}
		}
		glass = array_removeUndefined(glass);
		level.aftdeck_enemies = array_removeDead(level.aftdeck_enemies);
		level.aftdeck_enemies = array_removeUndefined(level.aftdeck_enemies);
		wait .05;	
	}
}

deck_minigun_dodamage_to_ent(snd)
{
	wait .25;
	if(!isdefined(self))
		return;
		
	self dodamage(1000, level.heli.model.origin);
	
	if(isdefined(snd))
		thread play_sound_in_space(snd, self.origin );	
}

deck_enemies_see( enemy )
{
	//self is one of the good guys here
	setthreatbias(self.script_noteworthy , enemy.cgogroup, 0 );
	
	enemy notify( "stop_smoking" );
	enemy notify( "patrol_stop" );
	enemy notify( "see_enemy" );
	
	enemy stopanimscripted();
}

enemies_death_msg( msg )
{
	self waittill("damage", damage, other);
	if(isalive(self))
		self waittill("death");
		
	radio_msg_stack( msg );
}

deck_enemies_herokill()
{
	self endon("death");
	self endon("marked_for_death");
	
	if(self.ignoreme)
		self waittill("in_range");
		
	ai = level.heroes5;
	keys = getarraykeys(ai);
	maxdist = 700;
	maxdistsqrd = maxdist * maxdist;
	loop = true;
	
	while( loop )
	{
		for(i=0; i<keys.size; i++)
		{
			key = keys[i];
			check1 = distancesquared( ai[ key ].origin, self.origin ) < maxdistsqrd;
			if( check1 )
			{
				loop = false;
				if(ai[ key ] != level.player)
				{
					ai[ key ] thread execute_ai_solo( self, 0, undefined, true );
					self notify("marked_for_death");
				}		
			}
		}
		wait .1;
	}
}

deck_enemies_behavior()
{
	self endon("death");
			
	self.cgogroup = ( "deck_enemy" + self.ai_number );
	createthreatbiasgroup( self.cgogroup );
	self setthreatbiasgroup( self.cgogroup );
	
	ai = [];
	ai[ai.size] = level.player;
	ai = array_combine(ai, level.heroes5);

	for(i=0; i<ai.size; i++)
		setignoremegroup(ai[i].script_noteworthy , self.cgogroup );	
	
	maxdist = 700;
	maxdistsqrd = maxdist * maxdist;
	loop = true;
	
	while( loop )
	{
		for(i=0; i<ai.size; i++)
		{
			check1 = distancesquared( ai[i].origin, self.origin ) < maxdistsqrd;
			if( check1 )
			{
				loop = false;
				if(ai[i] != level.player)
				{
					ai[i] thread execute_ai_solo( self, 0, undefined, true );
					self notify("marked_for_death");
				}
				break;			
			}
		}
		wait .25;
	}
	
	self notify("in_range");
	
	maxdist = 350;
	maxdistsqrd = maxdist * maxdist;
	
	while( 1 )
	{
		for(i=0; i<ai.size; i++)
		{
			if( distancesquared( ai[i].origin, self.origin ) < maxdistsqrd  && self cansee(ai[i]) )
				ai[i] thread deck_enemies_see( self );
		}
		wait .25;
	}
}

deck_heli_minigun_fx()
{
	self endon ("death");
	while(1)
	{
		playfxontag(level._effect["heli_minigun_shells"], self, "tag_origin");	
		wait .05;
	}	
}

deck_heroes_holdtheline()
{
	flag_wait("walk_deck");
	maxrate = 1.13;
	avgrate = 1;
	minrate = .9;
	maxdist = 140;
	
	pack = [];
	keys = getarraykeys(level.heroes5);
	for(i=0; i<keys.size; i++)
	{
		key = keys[i];
		pack[ pack.size ] = level.heroes5[ key ];
	}
	
	for(i=0; i<pack.size; i++)
	{
		pack[i].oldanimplaybackrate = pack[i].animplaybackrate;
		pack[i].animplaybackrate = avgrate;
	}
	//this only works because the deck of the shit is on perfect 
	//angles and we're headed exactly in the 180 degree direction
	
	while( !flag("deck_windows") )
	{
		//(1) find the leader of the pack...and make his animrate a little slower
		//the leader is based on the x value - the furthest left is less than right
		leader = pack[0];
		for(i=0; i<pack.size; i++)
		{
			if(leader.origin[0] > pack[i].origin[0])
				leader = pack[i];
		}
		
		//(2) anyone who's too far behind, crank up their animrate
		//and anyone who's within range - take their animrate back down to avg
		for(i=0; i<pack.size; i++)
		{
			range = pack[i].origin[0] - leader.origin[0];
				
			if( range > maxdist && pack[i].animplaybackrate < maxrate)
				pack[i].animplaybackrate += .05;
			else if(pack[i].animplaybackrate > avgrate)
				pack[i].animplaybackrate -= .05;
		}
		
		wait .1;
	}
	for(i=0; i<pack.size; i++)
		pack[i].animplaybackrate = pack[i].oldanimplaybackrate;
	
	level.player.ignoreme = false;
}

heli_minigun_attach(side)
{
	self.minigun = [];
	name = undefined;
	switch( tolower( side ) )
	{
		case "right":
			name = "_r";
			break;
		case "left":
			name = "_l";
			break;
	}
	
	self.minigun[ tolower( side ) ] = spawnturret("misc_turret", self gettagorigin("tag_gun" + name), "heli_minigun_noai");
	self.minigun[ tolower( side ) ].angles = self gettagangles("tag_gun" + name);
	self.minigun[ tolower( side ) ] setmodel("weapon_minigun");//weapon_minigun //weapon_saw_MG_setup
	self.minigun[ tolower( side ) ] linkto(self, "tag_gun" + name);
	self.minigun[ tolower( side ) ] maketurretunusable();
	self.minigun[ tolower( side ) ] setmode("manual");
	self.minigun[ tolower( side ) ] setturretteam("allies");
	self.minigun_control = tolower(side);
}

heli_searchlight_on()
{
	self.spotlight = spawnturret("misc_turret", self gettagorigin("tag_barrel"), "heli_spotlight");
	self.spotlight.angles = self gettagangles("tag_barrel");
	self.spotlight setmodel("weapon_saw_MG_setup");
	self.spotlight linkto(self, "tag_barrel",(0,0,-16), (0,0,0));
	self.spotlight maketurretunusable();
	self.spotlight setmode("manual");
	self.spotlight settoparc(5);
	//self.spotlight hide();

	self.spotlight.dlight = spawn( "script_model", self gettagorigin("tag_barrel") );
	self.spotlight.dlight setModel( "tag_origin" );//self.spotlight.dlight setModel( "projectile_rpg7" );

	self.spotlight thread heli_searchlight_dlight();

	playfxontag (level._effect["heli_spotlight"], self.spotlight, "tag_flash");

	self.spotlight_default_target = spawn( "script_origin", self gettagorigin("tag_barrel") );
	self.spotlight_default_target linkto( self, "tag_turret", (0,0,-256), (0,0,0) );
	self thread heli_searchlight_target( "default" );
	
	wait .1;
	playfxontag (level._effect["spotlight_dlight"], self.spotlight.dlight, "tag_origin");
}

heli_searchlight_off()
{
	self.spotlight_default_target delete();
	
	self.spotlight notify("death");
	self.spotlight.dlight delete();
	
	temp = spawn( "script_model", self.spotlight.origin );
	temp setModel( "tag_origin" );
	self.spotlight linkto(temp);
	
	temp moveto( (0,0,-10000), .05);
	wait .25;
	self.spotlight delete();
	temp delete();
}

heli_searchlight_dlight()
{
	self endon("death");
		
	while(1)
	{
		forward = anglestoforward(self gettagangles("tag_flash"));
		//calculate
		dropspot = physicstrace(self gettagorigin("tag_flash"), ( self gettagorigin("tag_flash") + vector_multiply( forward, 1500 ) ) );
		
		vec = vector_multiply(forward, -64);
		dropspot = dropspot + vec;
		//move the dlight
		self.dlight moveto(dropspot, .1);
		wait .1;
	}
}

heli_searchlight_target_calcai(ai)
{
	playerforward = level.player getplayerangles();
	playerforward = anglestoforward(playerforward);
	
	dot = 0;
	target = ai[0];
	for(i=1; i<ai.size; i++)
	{
		vector = ai[i].origin - level.player.origin;
		vectornormalize(vector);
		
		compare = vectordot(vector, playerforward);
		
		if(compare > dot)
		{
			target = ai[i];
			dot = compare;
		}	
	}
	
	return target;
}

heli_searchlight_target(type, name)
{	
	target = undefined;
	switch(type)
	{
		case "aiarray":	
			ai = getaiarray(name);
			if(name == "allies")
			{
				ai = array_remove( ai, level.heroes7["pilot"] );
				ai = array_remove( ai, level.heroes7["copilot"] );
			}
			target = heli_searchlight_target_calcai(ai);
			break;
		case "player":	
			target = level.player;
			break;
		case "targetname":
			target = getent(name, type);
			break;
		case "script_noteworthy":
			target = getent(name, type);
			break;
		case "hero":
			target = level.heroes5[name];
			break;
		case "default":
			target = self.spotlight_default_target;
			break;
	}
	
	if(!isdefined(target))
		return;
	self notify("new_searchlight_target");
			
	self thread heli_searchlight_think(target);
	
	self endon("new_searchlight_target");
	switch(type)
	{
		case "aiarray":
			wait ( randomfloatrange( 2, 4 ) );
			self thread heli_searchlight_target(type, name);
			break;
	}
}
	
heli_searchlight_think(target)
{
	self endon("new_searchlight_target");
	self.spotlight settargetentity( target );
	self.spotlight.targetobj = target;
	target waittill("death");
	self.spotlight cleartargetentity();
}

player_speed_set(speed, time)
{
	currspeed = int( getdvar( "g_speed" ) );
	goalspeed = speed;
	if( !isdefined( level.player.g_speed ) )
		level.player.g_speed = currspeed;
	
	range = goalspeed - currspeed;
	interval = .05;
	numcycles = time / interval;
	fraction = range / numcycles;
	
	while( abs(goalspeed - currspeed) > abs(fraction * 1.1) )
	{
		currspeed += fraction;
		setsaveddvar( "g_speed", int(currspeed) );
		wait interval;
	}
	
	setsaveddvar( "g_speed", goalspeed );
}

player_speed_reset(time)
{
	if( !isdefined( level.player.g_speed ) )
		return;
	player_speed_set(level.player.g_speed, time);
	level.player.g_speed = undefined;
}

cargohold_1_light_sway( model )
{
	node = spawn("script_origin", self.origin );
	node linkto( model );
	
	while(1)
	{
		self moveto( node.origin, .1 );
		wait .1;	
	}
}

misc_light_sway()
{
	if( isdefined( self.script_noteworthy ) && self.script_noteworthy == "nosway" )
		return;
	ang = self.angles;
	pos = self.origin;
	ang += (0,90,0);
	while(1)
	{
		level._sea_org waittill("sway1");
		
		time =  (level._sea_org.time);
		acc = time * .5;
		
		//self rotateto( ang + (-5,0,0), time, acc, acc );
		self moveto( pos + (0,20,0), time, acc, acc );
		
		level._sea_org waittill("sway2");
		
		time =  (level._sea_org.time );
		acc = time * .5;
		
		//self rotateto( ang + (5,0, 0), time, acc, acc );
		self moveto( pos + (0,-20,0), time, acc, acc );
	}	
}

misc_tv_stairs_on()
{
	wait 1;
	self.usetrig notify("trigger");
	start = getent("start_bridge_standoff", "targetname");
	start waittill("trigger");
	self.usetrig notify("trigger");	
}

misc_tv()
{
	self setcandamage(true);
	self.damagemodel = undefined;
	self.offmodel = undefined;
	
	switch(self.model)
	{
		case "com_tv2_testpattern":
			self.damagemodel = "com_tv2_d";
			self.offmodel = "com_tv2";
			self.onmodel = "com_tv2_testpattern";
			break;
		case "com_tv1_testpattern":
			self.damagemodel = "com_tv2_d";
			self.offmodel = "com_tv1";
			self.onmodel = "com_tv1_testpattern";
			break;	
	}
		
	self.glow = undefined;
	self.gloworg = self.origin + (0,0,14) + vector_multiply(anglestoforward(self.angles), 55);
	self.usetrig = getent(self.target, "targetname");
	self.usetrig usetriggerrequirelookat();
	
	if( isdefined( self.usetrig.target ) )
	{
		self.lite = getent(self.usetrig.target, "targetname");
		if( isdefined( self.lite ) )
			self.liteintensity = self.lite getLightIntensity();
	}
	self thread misc_tv_damage();
	self thread misc_tv_off();
}

misc_tv_off()
{
	self.usetrig endon("death");
	
	while(1)
	{
		self.glow = spawn("script_model", self.gloworg);
		self.glow setmodel("tag_origin");
		self.glow hide();
		playfxontag( level._effect[ "aircraft_light_cockpit_blue" ], self.glow, "tag_origin" );
		
		if( isdefined( self.lite ) )
			self.lite setLightIntensity(self.liteintensity);
		
		wait .2;
		self.usetrig waittill("trigger");
		self setmodel(self.offmodel);
		
		self.glow delete();
		self.glow = undefined;
		
		if( isdefined( self.lite ) )
			self.lite setLightIntensity(0);
		
		wait .2;
		self.usetrig waittill("trigger");
		self setmodel(self.onmodel);
	}
}

misc_tv_damage()
{
	self waittill("damage", damage, other, direction_vec, P, type );
	
	self.usetrig notify("death");
		
	obj = spawn("script_model", self.origin);
	obj.angles = self.angles;
	obj setmodel(self.damagemodel);
	
	if(isdefined(self.glow))
		self.glow delete();
	
	if( isdefined( self.lite ) )
		self.lite setLightIntensity(0);
	
	self.usetrig delete();
	self delete();
	
	obj physicsLaunch( p, vector_multiply(direction_vec, damage) );
}

misc_vision()
{
	attr = strtok(self.script_parameters, ":;, ");
	time = 5;
	for(j=0;j<attr.size; j++)
	{
		if(attr[j] == "time")
		{
			j++;
			time = int(attr[j]);
		}
	}
	while(1)
	{
		self waittill("trigger");
		VisionSetNaked( self.script_noteworthy, time );
	}
}

misc_fx_handler_trig()
{
	if(!isdefined(level.fx_handlers))
		level.fx_handlers = [];
	level.fx_handlers[level.fx_handlers.size] = self.script_noteworthy;
	
	while(1)
	{
		self waittill("trigger");
		
		for(i=0; i<level.fx_handlers.size; i++)
		{
			if(level.fx_handlers[i] == self.script_noteworthy)
				flag_set( self.script_noteworthy );
			else
				flag_clear( level.fx_handlers[i] );
		}	
	}
}

circuit_box_main()
{
	struct = spawnstruct();
	struct.parts = [];
	struct.type = self.script_noteworthy;
	struct.parts[ "body" ] = self;
	struct.parts[ "attachment" ] = getent(self.target, "targetname");
	struct.rotateent = undefined;

	array_thread( struct.parts, ::circuit_box_logic, struct);
	
	switch(struct.type)
	{
		case "swap":	
			struct.parts[ "attachment" ] hide();
			break;	
	}
	
	struct waittill("damage");	
	
	switch(struct.type)
	{
		case "swap":	
			struct.parts[ "body" ]	delete();
			struct.parts[ "attachment" ] show();
			break;	
		case "door":
			node = getstruct(struct.parts[ "attachment" ].target, "targetname");
		
			struct.parts[ "attachment" ] delete();
			
			right = anglestoright(node.angles);
			fxnode = spawn("script_model", node.origin + vector_multiply(anglestoforward(node.angles), 4));
			fxnode.angles = node.angles;//vectortoangles(right);
			fxnode setmodel("tag_origin");
			fxnode hide();
			
			playfxontag(level._effect[ "circuit_box" ], fxnode, "tag_origin");
			break;
	}
}

circuit_box_logic( parent )
{
	parent endon("damage");
	self setcandamage(true);
	self waittill("damage");
	parent notify("damage");
}

handsignal(xanim, ender, waiter)
{
	if(isdefined(ender))
		level endon(ender);
	if(isdefined(waiter))
		level waittill(waiter);
	
	switch(xanim)
	{
		case "go":
			self setanim( %CQB_stand_wave_go_v1, 1, 0, 1.1 );
			break;	
		case "onme":
			self.animname = "guy";
			self anim_single_solo(self, "onme");
			break;
	}
	
	
}