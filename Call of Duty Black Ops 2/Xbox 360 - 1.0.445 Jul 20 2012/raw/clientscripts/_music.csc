#include clientscripts\_utility;

music_init()
{
	level.activeMusicState = "";
	level.nextMusicState = "";
	level.musicStates = [];
	level.musicEnt = spawnfakeent(0);
	level.stingerEnt = spawnfakeent(0);

	thread updateMusic();

	thread musicSaveWait();

	registerSystem("musicCmd", ::musicCmdHandler);

	/# thread change_music_state_from_dvar(); #/
}


musicSaveWait()
{
	for(;;)
	{
		level waittill("save_restore");

		if(level.nextMusicState == "")
			level.nextMusicState = level.activeMusicState;
		level.activeMusicState = "";

		/#println("resetting music state to "+level.nextMusicState);#/

		states = getArrayKeys( level.musicStates );

		for ( i = 0; i < states.size; i++ )
		{
			stopLoopSound( 0, level.musicStates[states[i]].aliasEnt, 0 );
		}

		thread updateMusic();
	}
}


/#
change_music_state_from_dvar()
{
	level endon( "save_restore" );
	print_msg = false;
	
	while( 1 )
	{
		current_music_state = level.activeMusicState;
		next_music_state = level.nextMusicState;
		new_music_state = GetDvar( "snd_set_music_state" );

		if( ( new_music_state != "" ) && ( new_music_state != current_music_state ) && ( new_music_state != next_music_state ) )
		{
			if( !IsDefined( level.musicStates[new_music_state] ) )
			{
				if( !print_msg )
					printLn( "new music state entered '" + new_music_state + "' is not valid" );
				print_msg = true;
			}
			else
			{
				printLn( "^5current music state: " + current_music_state + " new music state: " + new_music_state );
				musicCmdHandler( 0, new_music_state, current_music_state );
				print_msg = false;
			}
		}
		wait( 1 );
	}
}
#/


musicCmdHandler(clientNum, state, oldState)
{
	if(clientNum != 0)
		return;

	level.nextMusicState = state;
	
	/#println("music debug: got state '"+state+"'");#/
	
	level notify("new_music");
}


updateMusic()
{
	level endon("save_restore");

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

		level.activeMusicState = next;

		if(active != "")
			thread transitionOut(active, next);

		// check if state changed again during transitionOut (not sure this can happen since it's threaded......................
		if(level.activeMusicState != level.nextMusicState) 
			continue;

		if(next != "")
			thread transitionIn(active, next);
			
		
	}
}


fadeOutAndStopSound(id, time)
{
	rate = 0;
	if(isdefined(time) && time != 0)
		rate = 1.0 / time;

	setSoundVolumeRate(id, rate);
	setSoundVolume(id, 0.0);
	
	wait(time);

	stopSound(id);
}

waitWithStateChangeCheck(waitTime)
{
	endWait = getrealtime() + waitTime * 1000;
	
	while(getrealtime() < endWait)
	{
		waitrealtime(0.01);

		if(level.activeMusicState != level.nextMusicState)
		{
			return false;
		}
	}

	if(level.activeMusicState != level.nextMusicState)
	{
		return false;
	}
	
	return true;
}

transitionOut(previous, next)
{
	if(previous == "")
		return;
		
	/#println("music transition out state "+next);#/

	if(!isdefined(level.musicStates[previous]))
	{
		assertmsg("unknown music state '"+previous+"'");
		return;
	}

	ent	 = level.musicStates[previous].aliasEnt;
	loopalias = level.musicStates[previous].loopalias;
	oneshotalias = level.musicStates[previous].oneshotalias;
	fadeoutloop = level.musicStates[previous].fadeoutloop;
	waittilldone = level.musicStates[previous].waittilldone;
	waittilldelay = level.musicStates[previous].waittilldelay;	
	stinger = level.musicStates[previous].stinger;
	id = level.musicStates[previous].id;
	startDelay = level.musicStates[previous].startDelay;
	loopDelay = level.musicStates[previous].loopDelay;
	fadeout = level.musicStates[previous].fadeout;
	forceStinger = level.musicStates[previous].forceStinger;

	level.musicStates[previous].stingerid = -1;

	sameState = true;
	
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
		level.musicStates[previous].stingerid = stingerid;
	}

	if(loopalias != "")
	{
		if(loopalias != nextloopalias || nextoneshotalias != "") //dont stop if its the same sound
		{
			//println("stopping loop "+loopalias);

			stopLoopSound( 0, ent, fadeoutloop );

			if(waittilldone)
			{
				//println("*** waiting on music to finish "+loopalias);
				sameState = waitWithStateChangeCheck(fadeoutloop);
			}
		}
		else
		{
			//println("not stopping loop "+loopalias+" "+nextloopalias+" "+nextoneshotalias);
		}
	}

	// fade out one shot (if still playing)
	if(id != 0 && sameState)
	{
		if(waittilldone)
		{
			while(SoundPlaying(id))
			{	
				//println("*** waiting on music to finish");
				wait(.01);

				if(level.activeMusicState != level.nextMusicState)
				{
					sameState = false;
					break;
				}
			}
			//println("*** done waiting on music to finish "+id);
		}
		else
		if(waittilldelay)
		{
			if(SoundPlaying(id))
			{
				while(getrealtime() < (level.musicStates[previous].loopDelayEndTime - (fadeout * 1000)) 
				      &&  SoundPlaying(id) && GetPlaybackTime(id) < ((loopDelay * 1000) - (fadeout * 1000)))
				{
					wait(.01);

					if(level.activeMusicState != level.nextMusicState)
					{
						sameState = false;
						break;
					}					
				}

				if(!sameState)
				{
					fadeout = 0.010;
				}

				thread fadeOutAndStopSound(id,fadeout); 
			}
		}
		else
		{
			thread fadeOutAndStopSound(id,fadeout);  
		}
	}	
}


transitionIn(previous, next)
{
	ent	 = level.musicStates[next].aliasEnt;
	loopalias   = level.musicStates[next].loopalias;
	oneshotalias   = level.musicStates[next].oneshotalias;
	fadein  = level.musicStates[next].fadein;
	fadeinloop = level.musicStates[next].fadeinloop;
	loop	= level.musicStates[next].loop;
	startDelay = 0; 
	waittillstingerdone = false; 	
	stingerid = -1; 
	
	
	if ( isdefined(previous) && previous != "" )
	{
		startDelay = level.musicStates[previous].startDelay;
		waittillstingerdone = level.musicStates[previous].waittillstingerdone;		
		stingerid = level.musicStates[previous].stingerid;
	}

	/#println("music transition in state "+next);#/

	if(previous == "")
	{
		oldloopalias = "";
		oldoneshotalias = "";
		oldid = -1;
	}
	else
	{
		oldloopalias = level.musicStates[previous].loopalias;
		oldoneshotalias = level.musicStates[previous].oneshotalias;
		oldid = level.musicStates[previous].loopid;		
	}

	level.musicStates[next].loopDelayEndTime = getrealtime() + (level.musicStates[next].loopDelay * 1000);
		
	sameState = true;	
			
	if( startDelay > 0 && stingerid >= 0 )
	{
		while(startDelay > 0 && SoundPlaying(stingerid) && (GetPlaybackTime(stingerid) < startDelay * 1000) && level.activeMusicState == level.nextMusicState)
		wait(.01);
		
		sameState = level.activeMusicState == level.nextMusicState;
	}
		
	if(waittillstingerdone && level.activeMusicState == level.nextMusicState && stingerid >= 0)
	{
		//println("*** waiting on stinger to finish");
		while(SoundPlaying(stingerid) && level.activeMusicState == level.nextMusicState)
			wait(.01);
				
		level.musicStates[previous].stingerid = -1;
		
		sameState = level.activeMusicState == level.nextMusicState;
	}	
				
	
	if(oneshotalias != "" && sameState)
	{
		level.musicStates[next].id = playSound( 0, oneshotalias, (0,0,0), 1.0, fadein );
		
		
		if( level.musicStates[next].loopDelay == 0 )
		{
			if(loopalias != "") //if both are specified play this one
			{
				while(SoundPlaying(level.musicStates[next].id) )
				{
					length = GetKnownLength(level.musicStates[next].id);
					time = 0;
					if(length != 0)
					{
						time = GetPlaybackTime(level.musicStates[next].id); //need to start xfade to loop
						if(length-time <=  fadein*1000 )
							break;
					}

					wait(.01);
				}
			}
		}
		else
		{
			sameState = waitWithStateChangeCheck(level.musicStates[next].loopDelay);
		}
	}
	
	if(oldloopalias == loopalias && oldid != -1 && oneshotalias == "")
	{
		//println("using old loop");
		level.musicStates[next].loopid = level.musicStates[previous].loopid;
		level.musicStates[previous].loopid = -1;
		oldent = level.musicStates[previous].aliasEnt;
		level.musicStates[previous].aliasEnt = level.musicStates[next].aliasEnt;
		level.musicStates[next].aliasEnt = oldent;
	}
	else if(loopalias != "" && sameState)
	{

		//println("starting loop");				
		level.musicStates[next].loopid = playLoopSound( 0, ent, loopalias, fadeinloop );
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
	level.musicStates[name].fadeinloop  = 0;
	level.musicStates[name].fadeout = 0;
	level.musicStates[name].fadeoutloop = 0;	
	level.musicStates[name].id = -1;
	level.musicStates[name].loopid = -1;
	level.musicStates[name].waittilldone = false;
	level.musicStates[name].stinger = "";
	level.musicStates[name].waittillstingerdone = false;
	level.musicStates[name].waittilldelay = false;
	level.musicStates[name].startDelay = 0;
	level.musicStates[name].forceStinger = false;
	level.musicStates[name].loopDelay = 0;
}


musicWaitTillDone()
{
	assert(isdefined(level.musicDeclareName));
	
	name = level.musicDeclareName;
	
	level.musicStates[name].waittilldone = true;
}

musicWaitTillDelay()
{
	assert(isdefined(level.musicDeclareName));
	
	name = level.musicDeclareName;
	
	level.musicStates[name].waittilldelay = true;
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


_musicAlias(alias, fadein, fadeout, loopDelay)
{
	assert(isdefined(level.musicDeclareName));
	
	name = level.musicDeclareName;
	
	level.musicStates[name].oneshotalias = alias;
	level.musicStates[name].fadein  = fadein;
	level.musicStates[name].fadeout = fadeout;

	assert(level.musicStates[name].loopDelay == 0);

	if(isdefined(loopDelay))
	{
		assert(loopDelay > fadeout);

		level.musicStates[name].loopDelay = loopDelay;		
	}
	else
	{
		level.musicStates[name].loopDelay = 0;
	}

	if(!isdefined(level.musicStates[name].fadein))
	{
		level.musicStates[name].fadein = 0;
	}

	if(!isdefined(level.musicStates[name].fadeout))
	{
		level.musicStates[name].fadeout = 0;
	}
}

_musicAliasLoop(alias, fadein, fadeout)
{
	assert(isdefined(level.musicDeclareName));
	
	name = level.musicDeclareName;
	
	level.musicStates[name].loopalias = alias;
	level.musicStates[name].fadeinloop  = fadein;
	level.musicStates[name].fadeoutloop = fadeout;

	if(!isdefined(level.musicStates[name].fadeinloop))
	{
		level.musicStates[name].fadeinloop = 0;
	}

	if(!isdefined(level.musicStates[name].fadeoutloop))
	{
		level.musicStates[name].fadeoutloop = 0;
	}
}


musicAliasLoop(alias, fadein, fadeout)
{
	_musicAliasLoop(alias, fadein, fadeout);
}


musicAlias(alias, fadeout, fadein, loopDelay) //for non looping aliases
{
	_musicAlias(alias, fadein, fadeout, loopDelay);
}






