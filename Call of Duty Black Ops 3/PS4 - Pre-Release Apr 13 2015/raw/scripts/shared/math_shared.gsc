#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace music;

function autoexec __init__sytem__() {     system::register("music",&__init__,undefined,undefined);    }

function __init__()
{
	level.activeMusicState = "";
	level.nextMusicState = "";
	level.musicStates = [];
	level.musicEnt = spawnfakeent(0);
	level.stingerEnt = spawnfakeent(0);

	thread updateMusic();
	
	thread demoFixup();

	util::register_system( "musicCmd", &musicCmdHandler );

	declareMusicState("SILENT");
		musicAliasloop("null",0,1);

	if( !SessionModeIsZombiesGame() )
	{
		declareMusicState("SPAWN_WAGER");
			musicAlias("mus_spawn_wager",0.5);	
			musicwaittilldone();
			
		declareMusicState("SPAWN_SHORT");
			musicAlias("mus_spawn_short",0.1);	
			musicwaittilldone();	
			
		declareMusicState("SPAWN_ST6");
			musicAlias("mus_spawn_st6",0.5);	
			musicwaittilldone();
			
		declareMusicState("SPAWN_SHORT_ST6");
			musicAlias("mus_spawn_short_st6",0.5);
			musicwaittilldone();

		declareMusicState("VICTORY_ST6");
			musicAlias("mus_victory_st6",0.5);
			musicwaittilldone();				
			
		declareMusicState("SPAWN_FBI");
			musicAlias("mus_spawn_fbi",0.5);			
			musicwaittilldone();
			
		declareMusicState("SPAWN_SHORT_FBI");
			musicAlias("mus_spawn_short_fbi",0.5);
			musicwaittilldone();	
			
		declareMusicState("VICTORY_FBI");
			musicAlias("mus_victory_fbi",0.5);
			musicwaittilldone();			
			  			  
		declareMusicState("SPAWN_CIA");
			musicAlias("mus_spawn_cia",0.5);			
			musicwaittilldone();
			
		declareMusicState("SPAWN_SHORT_CIA");
			musicAlias("mus_spawn_short_cia",0.5);
			musicwaittilldone();				

		declareMusicState("VICTORY_CIA");
			musicAlias("mus_victory_cia",0.5);
			musicwaittilldone();		
			
		declareMusicState("SPAWN_PMC");
			musicAlias("mus_spawn_pmc",0.5);			
			musicwaittilldone();
	
		declareMusicState("SPAWN_SHORT_PMC");
			musicAlias("mus_spawn_short_pmc",0.5);
			musicwaittilldone();
			
		declareMusicState("VICTORY_PMC");
			musicAlias("mus_victory_pmc",0.5);
			musicwaittilldone();			
			
		declareMusicState("SPAWN_PLA");
			musicAlias("mus_spawn_pla",0.5);			
			musicwaittilldone();
			
		declareMusicState("SPAWN_SHORT_PLA");
			musicAlias("mus_spawn_short_pla",0.5);
			musicwaittilldone();	

		declareMusicState("VICTORY_PLA");
			musicAlias("mus_victory_pla",0.5);
			musicwaittilldone();				
			
		declareMusicState("SPAWN_TER");
			musicAlias("mus_spawn_ter",0.5);
			musicwaittilldone();

		declareMusicState("SPAWN_SHORT_TER");
			musicAlias("mus_spawn_short_ter",0.5);
			musicwaittilldone();					
			
		declareMusicState("VICTORY_TER");
			musicAlias("mus_victory_ter",0.5);
			musicwaittilldone();			
			
		declareMusicState("SPAWN");
			musicAlias("mus_spawn",0.5);
			musicwaittilldone();


		declareMusicState("SPAWN_SHORT");
			musicAlias("mus_spawn_short",0.5);		
		
		declareMusicState("UNDERSCORE");
			musicAlias("mus_underscore",1);		
			
		declareMusicState("ACTION");
			musicAliasloop("mus_action",1, 1);

		declareMusicState("TIME_OUT");
			musicAlias("mus_time_running_out",1);

		declareMusicState("VICTORY");
			musicAlias("mus_victory",0.5);

		declareMusicState("LOSE");
			musicAlias("mus_loss",0.5);				

		declareMusicState("DRAW");
			musicAlias("mus_draw",0.5);
			
		declareMusicState("ROUND_END");
			musicAlias("mus_round_end",0.5);
		
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
			musicStinger ("mus_ctf_we_score", 0);
			//musicAlias("mus_ctf_we_score",0.5);

		declareMusicState("CTF_WE_TAKE");
			musicStinger("mus_ctf_we_take",0.5);

		declareMusicState("CTF_THEY_TAKE");
			musicStinger("mus_ctf_they_take",0.5);

		declareMusicState("SUSPENSE");
			//musicAlias("mus_match_end",0.5);
			musicAliasloop("mus_suspense",1,1);
			
		declareMusicState("CTF_THEY_SCORE");
			musicStinger("mus_ctf_they_score",0.5);

		declareMusicState("CTF_THEY_SCORE");
			musicStinger("mus_ctf_they_score",0.5);
			
		declareMusicState("MATCH_END");
			musicAlias("mus_time_running_out",0.5);
			musicAliasloop("mus_underscore",0,1);
			
		declareMusicState("FR_MUSIC");
			musicAliasloop("mus_free_run",1, 1);

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


function musicCmdHandler(clientNum, state, oldState)
{
	state = ToLower(state);
	soundsetmusicstate(state);
}


function demoFixup()
{
	for(;;)
	{
		level waittill( "demo_jump" );
		level.nextMusicState = "SILENT";
		level notify("new_music");
	}
}


function updateMusic()
{
	
}


function fadeOutAndStopSound(id, time)
{
	rate = 0;
	if(time != 0)
		rate = 1.0 / time;

	setSoundVolumeRate(id, rate);
	setSoundVolume(id, 0.0);
	
	wait(time);

	stopSound(id);
}


function transitionOut(previous, next)
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


function transitionIn(previous, next)
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


function declareMusicState(name)
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


function musicwaittilldone()
{
	assert(isdefined(level.musicDeclareName));
	
	name = level.musicDeclareName;
	
	level.musicStates[name].waittilldone = true;
}

function musicWaitTillStingerDone()
{
	assert(isdefined(level.musicDeclareName));
	
	name = level.musicDeclareName;
	
	level.musicStates[name].waittillstingerdone = true;
}


function musicStinger(stinger, delay, force)
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


function _musicAlias(alias, fadein, fadeout, loop)
{
	assert(isdefined(level.musicDeclareName));
	
	name = level.musicDeclareName;
	
	if(loop)
		level.musicStates[name].loopalias = alias;
	else
		level.musicStates[name].oneshotalias = alias;

	if(!isdefined(fadeout))
	{
		fadeout = 0.0;
	}

	if(!isdefined(fadein))
	{
		fadein = 0.0;
	}
	
	level.musicStates[name].fadein  = fadein;
	level.musicStates[name].fadeout = fadeout;
}


function musicAliasloop(alias, fadein, fadeout)
{
	_musicAlias(alias, fadein, fadeout, true);
}


function musicAlias(alias, fadeout) //for non looping aliases
{
	_musicAlias(alias, 0, fadeout, false);
}






