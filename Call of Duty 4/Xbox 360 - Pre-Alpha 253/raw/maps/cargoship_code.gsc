#include maps\_utility;
#include maps\_anim;
#include maps\mo_tools;

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
	
	heroes = [];
	keys = getarraykeys( level.heroes );
	for(i=0; i<keys.size; i++)
	{
		key = keys[i];
		if( issubstr(key, "pilot") || issubstr(key, "seat") )
			continue;
		heroes[ heroes.size ] = level.heroes[ key ];
	}
	
	if(!isdefined(level.escape_stumble_num) )
		level.escape_stumble_num = 1;
	
	for(i=0; i<heroes.size; i++)
	{
		heroes[ i ] thread escape_event_ai(level.escape_stumble_num);	
		if(level.escape_stumble_num < 3)
			level.escape_stumble_num++;
		else
			level.escape_stumble_num = 1;
	}
		
	array_wait(heroes, "done_stumbling");
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
			self set_run_anim( "path_slow" );
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
	pack[ pack.size ] = level.heroes["price"];
	pack[ pack.size ] = level.heroes["alavi"];
	pack[ pack.size ] = level.heroes["grigsby"];
	
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
	SetSavedDvar( "nightVisionDisableEffects", 1 );
	level.player ForceViewmodelAnimation( "facemask", "nvg_down" );
	wait( 2.0 );
	SetSavedDvar( "hud_gasMaskOverlay", 1 );
	wait( 2.5 );
	SetSavedDvar( "nightVisionDisableEffects", 0 );
}

smoking_loop(node, flagmsg)
{	
	self.animname = "smoker";	
		
	self endon("damage");
	self endon("stop_smoking");
	
	cigar = spawn("script_model", self gettagorigin("tag_inhand") );
	cigar.angles = self gettagangles("tag_inhand");
	cigar linkto(self, "tag_inhand");
	cigar setmodel("prop_price_cigar");
	node.lite = getent(node.target, "targetname");
	node.cigar = cigar;
	
	self thread smoking_loop2(node);
	
	if( isdefined(flagmsg) )
	{
		cigar hide();
		if( isdefined(node.lite) )
			node.lite setLightIntensity(0);
		node thread anim_loop_solo(self, "idle", undefined, "stoploop");
		flag_wait(flagmsg);
		node notify("stoploop");
	//	node anim_single_solo( self, "idle_to_smoke" );//this just takes too damn long
		if( isdefined(node.lite) )
			node.lite setLightIntensity(1);
		cigar show();
	}
		
	playfxontag (level._effect["cigar_glow"], cigar, "tag_cigarglow");
		
	while(1)
	{
		node anim_single_solo( self, "smoke" );
		node anim_single_solo( self, "smoke2" );
	}
}

smoking_loop2(node)
{
	self waittill("damage");
	if( isdefined(node.lite) )
		node.lite setLightIntensity(0);
	node.cigar delete();
	self stopanimscripted();
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
	}	
}

execute_ai_solo(guy, delay, numshots)
{
	ai = [];
	ai[0] = guy;
	execute_ai(ai, delay, numshots);
}

execute_ai(ai, delay, numshots)
{	
	shots = 0;
	if(!isdefined(delay))
		delay = 0;
	
	while( isdefined(self.execute_mode) && self.execute_mode == true )
		self waittill( "execute_mode" );
	
	self.execute_mode = true;
	
	for(i=0; i< ai.size; i++)
	{
		//select an enemy
		if( !isalive( ai[i] ) || isdefined( ai[i].execute_target ) )
			continue;
		
		//create a target and link it to the enemy
		ai[i].execute_target = true;
		self cqb_aim( ai[i] );
		wait delay;
		//now fire on him until he's dead
		if(isdefined(numshots))
			shots = numshots;
		else
			shots = randomintrange(3,6);
		self burstshot(shots);
		ai[i] dodamage(ai[i].health + 300, self gettagorigin("tag_flash") );		
		wait .2;
		
		//wait a second, then find another target
		wait .1;
	}
	
	self cqb_aim( undefined );
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
	self.walkdist = 99999;
	self.disableArrivals = true;
	
	self.oldwalk_noncombatanim 	= self.walk_noncombatanim;
	self.oldwalk_noncombatanim2 	= self.walk_noncombatanim2;
	self.oldrun_combatanim			= self.run_combatanim;
	self.oldanim_combatrunanim		= self.anim_combatrunanim;
	self.oldrun_noncombatanim		= self.run_noncombatanim;

	self endon("patrol_stop");
	self endon ("damage");

	patrolwalk[0] = %patrolwalk_bounce;
	patrolwalk[1] = %patrolwalk_tired;
	patrolwalk[2] = %patrolwalk_swagger;
	patrolstand[0] = %patrolstand_twitch;
	patrolstand[1] = %patrolstand_look;
	patrolstand[2] = %patrolstand_idle;
		
	self.walk_noncombatanim 	= random(patrolwalk);
	self.walk_noncombatanim2 	= random(patrolwalk);
	self.run_combatanim			= random(patrolwalk);
	self.anim_combatrunanim		= random(patrolwalk);
	self.run_noncombatanim		= random(patrolwalk);
	self.animname = "patrol";
	
	node = getnode( self.target, "targetname" );
	
	while( isdefined( node ) )
	{		
		self waittill("goal");
		if( isdefined( node.target ) )
			node = getnode( node.target, "targetname" );
		else
			break;
		
		self setgoalnode(node);
		if(node.radius)
			self.goalradius = node.radius;
		else
			self.radius = 16;
	}
	
	self thread anim_loop_solo(self, "idle", undefined, "stopanimscripted");
}

patrol2()
{
	self waittill_either("damage", "patrol_stop");
	self notify("stopanimscripted");
	self stopanimscripted();
	
	self.walk_noncombatanim 	= self.oldwalk_noncombatanim;
	self.walk_noncombatanim2 	= self.oldwalk_noncombatanim2;
	self.run_combatanim			= self.oldrun_combatanim;
	self.anim_combatrunanim		= self.oldanim_combatrunanim;
	self.run_noncombatanim		= self.oldrun_noncombatanim;
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
			wait( 0.05 );
		}
		
		if(isdefined(burst) && burst == true)
			wait( randomfloat( 0.5, 2 ) );
	}
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
	self.minigun[ tolower( side ) ] setmodel("weapon_saw_MG_setup");
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
			target = level.heroes[name];
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