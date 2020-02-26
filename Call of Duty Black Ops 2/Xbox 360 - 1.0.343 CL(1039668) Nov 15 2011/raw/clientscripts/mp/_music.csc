
music_init()
{
	level.activeMusicState = "";
	level.nextMusicState = "";
	level.musicStates = [];
	level.musicEnt = spawnfakeent(0);
	level.stingerEnt = spawnfakeent(0);

	thread updateMusic();
	
	thread demoFixup();

	clientscripts\mp\_utility::registerSystem("musicCmd", ::musicCmdHandler);

	declareMusicState("SILENT");
		musicAliasloop("null",0,1);

	if( !SessionModeIsZombiesGame() )
	{
		declareMusicState("SPAWN_WAGER");
			musicAlias("mus_spawn_wager",0.5);	

		declareMusicState("SPAWN_OPS");
			musicAlias("mus_spawn_ops",0.5);	
				
		declareMusicState("SPAWN_OP4");
			musicAlias("mus_spawn_op4",0.5);			
				
		declareMusicState("SPAWN_RUS");
			musicAlias("mus_spawn_rus",0.5);			
				
		declareMusicState("SPAWN_CUB");
			musicAlias("mus_spawn_cub",0.5);			
				
		declareMusicState("SPAWN_SOG");
			musicAlias("mus_spawn_sog",0.5);			
				
		declareMusicState("SPAWN_NVA");
			musicAlias("mus_spawn_nva",0.5);			
			
		declareMusicState("SPAWN");
			musicAlias("mus_spawn",0.5);			


		declareMusicState("SPAWN_SHORT");
			musicAlias("mus_spawn_short",0.5);		
		
		declareMusicState("UNDERSCORE");
			musicAlias("mus_underscore",1);		
			
		declareMusicState("ACTION");
			musicAliasloop("mus_action",1);

		declareMusicState("TIME_OUT");
			musicAlias("mus_time_running_out",1);

		declareMusicState("VICTORY");
			musicAlias("mus_victory",0.5);

		declareMusicState("LOSE");
			musicAlias("mus_loss",0.5);				

		declareMusicState("DRAW");
			musicAlias("mus_draw",0.5);
			
		declareMusicState("ROUND_END");
			musicAlias("mus_halftime",0.5);
		
		declareMusicState("ROUND_SWITCH");
			musicAlias("mus_halftime",0.5);			

		declareMusicState("MP_LAST_STAND");
			musicAlias("mus_last_stand" ,0.5);
			musicAliasloop("null",0,1);			

		declareMusicState("MP_LAST_STAND_DIE");
			musicAlias("mus_spawn_short",0.5);
			musicAliasloop("null",0,1);			

		declareMusicState("MP_LAST_STAND_REVIVE");
			musicAlias("mus_spawn_short",0.5);
			musicAliasloop("null",0,1);						
			
		declareMusicState("CTF_WE_SCORE");
			musicAlias("mus_ctf_we_score",0.5);

		declareMusicState("CTF_WE_TAKE");
			musicAlias("mus_ctf_we_take",0.5);

		declareMusicState("CTF_THEY_TAKE");
			musicAlias("mus_ctf_they_take",0.5);

		declareMusicState("SUSPENSE");
			//musicAlias("mus_match_end",0.5);
			musicAliasloop("mus_suspense",1,1);
			
		declareMusicState("CTF_THEY_SCORE");
			musicAlias("mus_ctf_they_score",0.5);

		declareMusicState("CTF_THEY_SCORE");
			musicAlias("mus_ctf_they_score",0.5);
			
		declareMusicState("MATCH_END");
			musicAlias("mus_time_running_out",0.5);
			musicAliasloop("mus_underscore",0,1);

	//  ***UNUSED MUSIC STATES***
			
		declareMusicState("DEM_WE_PLANT");
			musicAlias("mus_ctf_we_take",0.5);

		declareMusicState("DEM_THEY_PLANT");
			musicAlias("mus_ctf_they_take",0.5);
			
		declareMusicState("DEM_WE_DEFUSE");
			musicAlias("mus_ctf_we_score",0.5);
		    
		declareMusicState("DEM_THEY_DEFUSE");
			musicAlias("mus_ctf_they_score",0.5);  
		    
		declareMusicState("DEM_WE_SCORE");
			musicAlias("mus_ctf_we_score",0.5);
			
		declareMusicState("DEM_THEY_SCORE");
			musicAlias("mus_ctf_they_score",0.5);
			
		declareMusicState("DEM_ONE_LEFT_UNDERSCORE");
			musicAliasloop("mus_underscore",0,1);		
	}					          					
}


musicCmdHandler(clientNum, state, oldState)
{
	if(clientNum != 0)
		return;

	level.nextMusicState = state;
	
	//CDC REMOVE ME
	//iprintlnbold("music debug: got state '"+state+"'");
	
	level notify("new_music");
}


demoFixup()
{
	for(;;)
	{
		level waittill( "demo_jump" );
		level.nextMusicState = "SILENT";
		level notify("new_music");
	}
}


updateMusic()
{
	while(1)
	{
		if(level.activeMusicState == level.nextMusicState) //state didn't change during transition
			level waittill("new_music");
		
		if(level.activeMusicState == level.nextMusicState) //got same one twice, ignore
			continue;

		active = level.activeMusicState;
		next = level.nextMusicState;

		if(next != "" && !isdefined(level.musicStates[next]))
		{
			assertmsg("unknown music state '"+next+"'");
			level.nextMusicState = level.activeMusicState; //keep current if we dont know what we just got
			continue;
		}

		if(active != "")
			transitionOut(active, next);

		if(next != "")
			transitionIn(active, next);
			
		level.activeMusicState = next;
	}
}


fadeOutAndStopSound(id, time)
{
	rate = 0;
	if(time != 0)
		rate = 1.0 / time;

	setSoundVolumeRate(id, rate);
	setSoundVolume(id, 0.0);
	
	wait(time);

	stopSound(id);
}


transitionOut(previous, next)
{
	if(previous == "")
		return;
		
	if(!isdefined(level.musicStates[previous]))
	{
		assertmsg("unknown music state '"+previous+"'");
		return;
	}

	//println("MUSIC: transitioning out of "+previous);

	ent	 = level.musicStates[previous].aliasEnt;
	loopalias = level.musicStates[previous].loopalias;
	oneshotalias = level.musicStates[previous].oneshotalias;
	fadeout = level.musicStates[previous].fadeout;
	waittilldone = level.musicStates[previous].waittilldone;
	waittillstingerdone = level.musicStates[previous].waittillstingerdone;
	stinger = level.musicStates[previous].stinger;
	id = level.musicStates[previous].id;
	startDelay = level.musicStates[previous].startDelay;
	forceStinger = level.musicStates[previous].forceStinger;

	//level.musicStates["a"].blah;

	if(next == "")
	{
		nextloopalias = "";
		nextoneshotalias = "";
	}
	else
	{
		nextloopalias = level.musicStates[next].loopalias;
		nextoneshotalias = level.musicStates[next].oneshotalias;
	}

	stingerid = -1;

	loopMatches = loopalias == nextloopalias;
	haveOneShot   = nextoneshotalias != "";
	
	if(stinger != "" && (!loopMatches || haveOneShot || forceStinger)) //stinger only plays if loop changes
	{
		stingerid = playSound(0, stinger, (0,0,0));

	}

	if(loopalias != "")
	{
		if(loopalias != nextloopalias || nextoneshotalias != "") //dont stop if its the same sound
		{
			//println("stopping loop "+loopalias);

			stopLoopSound( 0, ent, fadeout );

			if(waittilldone)
			{
				//println("*** waiting on music to finish "+loopalias);
				wait(fadeout);
			}
		}
		else
		{
			//println("not stopping loop "+loopalias+" "+nextloopalias+" "+nextoneshotalias);
		}
	}
	else
	{
		if(waittilldone)
		{
			while(SoundPlaying(id))
			{
				//println("*** waiting on music to finish");
				wait(.1);
			}
			//println("*** done waiting on music to finish "+id);
		}
		else
		{
			//println("MUSIC: fade out and stop");
			thread fadeOutAndStopSound(id,fadeout);
		}
	}
	
	while(startDelay > 0 && SoundPlaying(stingerid) && GetPlaybackTime(stingerid) < startDelay * 1000)
			wait(.01);

	if(waittillstingerdone)
	{
		//println("*** waiting on stinger to finish");
		while(SoundPlaying(stingerid))
			wait(.1);
	}


	if(loopalias != nextloopalias)
		level.musicStates[previous].id = -1;
}


transitionIn(previous, next)
{
	ent	 = level.musicStates[next].aliasEnt;
	loopalias   = level.musicStates[next].loopalias;
	oneshotalias   = level.musicStates[next].oneshotalias;
	fadein  = level.musicStates[next].fadein;
	loop	= level.musicStates[next].loop;

	//println("MUSIC: transitioning in to "+next);

	if(previous == "")
	{
		oldloopalias = "";
		oldoneshotalias = "";
		oldid = -1;
		oldstartDelay = 0;
		startDelay = 0;
	}
	else
	{
		oldloopalias = level.musicStates[previous].loopalias;
		oldoneshotalias = level.musicStates[previous].oneshotalias;
		oldid = level.musicStates[previous].id;		
	}
	
	if(oneshotalias != "")
	{
		level.musicStates[next].id = playSound( 0, oneshotalias, (0,0,0) );
		if(loopalias != "") //if both are specified play this one
			while(SoundPlaying(level.musicStates[next].id))
			{
				if(level.nextMusicState != next)
				{
					//println("MUSIC: bailing transition due to early state change");
					thread fadeOutAndStopSound(level.musicStates[next].id,level.musicStates[next].fadeout); //hack
					return;
				}
				wait(.1);
			}
		//println("done with one shot");
	}
	

	//println("loop state "+oldloopalias+" "+loopalias+" "+oneshotalias+" "+oldid);
	if(oldloopalias == loopalias && oldid != -1 && oneshotalias == "")
	{
		//println("using old loop");
		level.musicStates[next].id = level.musicStates[previous].id;
		level.musicStates[previous].id = -1;
		oldent = level.musicStates[previous].aliasEnt;
		level.musicStates[previous].aliasEnt = level.musicStates[next].aliasEnt;
		level.musicStates[next].aliasEnt = oldent;
	}
	else if(loopalias != "")
	{
		//println("starting loop");
		level.musicStates[next].id = playLoopSound( 0, ent, loopalias, fadein );
	}
	
}


declareMusicState(name)
{
	if ( isdefined( level.musicStates[name] ) )
		return;

	level.musicDeclareName = name;
	level.musicStates[name] = spawnStruct();
	level.musicStates[name].aliasEnt = spawnfakeent(0);
	level.musicStates[name].loopalias = "";
	level.musicStates[name].oneshotalias = "";
	level.musicStates[name].fadein  = 0;
	level.musicStates[name].fadeout = 0;
	level.musicStates[name].id = -1;
	level.musicStates[name].waittilldone = false;
	level.musicStates[name].stinger = "";
	level.musicStates[name].waittillstingerdone = false;
	level.musicStates[name].startDelay = 0;
	level.musicStates[name].forceStinger = false;
}


musicWaitTillDone()
{
	assert(isdefined(level.musicDeclareName));
	
	name = level.musicDeclareName;
	
	level.musicStates[name].waittilldone = true;
}

musicWaitTillStingerDone()
{
	assert(isdefined(level.musicDeclareName));
	
	name = level.musicDeclareName;
	
	level.musicStates[name].waittillstingerdone = true;
}


musicStinger(stinger, delay, force)
{
	assert(isdefined(level.musicDeclareName));

	if(!isdefined(delay))
		delay = 0;
	
	name = level.musicDeclareName;
	
	level.musicStates[name].stinger = stinger;
	level.musicStates[name].startDelay = delay; 

	if(isdefined(force))
	{
		level.musicStates[name].forceStinger = force;
	}
}


_musicAlias(alias, fadein, fadeout, loop)
{
	assert(isdefined(level.musicDeclareName));
	
	name = level.musicDeclareName;
	
	if(loop)
		level.musicStates[name].loopalias = alias;
	else
		level.musicStates[name].oneshotalias = alias;

	if(!isDefined(fadeout))
	{
		fadeout = 0.0;
	}

	if(!isDefined(fadein))
	{
		fadein = 0.0;
	}
	
	level.musicStates[name].fadein  = fadein;
	level.musicStates[name].fadeout = fadeout;
}


musicAliasLoop(alias, fadein, fadeout)
{
	_musicAlias(alias, fadein, fadeout, true);
}


musicAlias(alias, fadeout) //for non looping aliases
{
	_musicAlias(alias, 0, fadeout, false);
}






