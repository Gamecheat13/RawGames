
///////////////////////////////////////////////////////////
////////////////OKI2 UTILITY FUNCTIONS/////////////////////
///////////////////////////////////////////////////////////

#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;


okiPrint( txt ) // used for various debug prints, so they can all be enabled/disabled at will
{
	PrintLn( "  *** OKI2: " + txt );
}

// look_target can be undefined if he doesn't have one
dialogue( dialoguename, look_target )
{
	//anim_single_solo( self, dialoguename ); // used to be just this
	self endon( "death" );
	
	realdialoguename = level.scr_sound[self.animname][dialoguename];
	
	self thread maps\_anim::anim_facialFiller( "dialogue_sound_done", look_target );
	self animscripts\face::SaySpecificDialogue( undefined, realdialoguename, 1.0, "dialogue_sound_done" );
	self waittill( "dialogue_sound_done" );
}

// plays a water on the camera effect when you pass under a waterfall
watersheet_on_trigger( targetname )
{
	trig = getent( targetname, "targetname" );
	while( true )
	{
		trig waittill( "trigger", who );
		
		if( isDefined(who) )
		{
			who setwatersheeting(true, 3);
			wait( 0.1 );
		}
	}
}

// displays explanation on how to use satchel charges
hud_satchel_hint()
{
	self endon("death");
	self endon("disconnect");
	self notify("restarting_satchel_hint");
	self thread hud_satchel_deathwatch();

	self setup_client_hintelem();
	self.hintelem setText(&"OKI2_SATCHEL_HINT1");
	wait(5);
	self.hintelem settext("");
	
	self endon("restarting_satchel_hint"); // because technically this gets run twice, both E1 start and E2 start
	while( self GetCurrentWeapon() != "satchel_charge_new" ) // wait for the player to actually switch to the satchel
	{
		wait(0.25);
	}
	self.hintelem setText(&"OKI2_SATCHEL_HINT2");
	wait(5);
	self.hintelem Destroy();
	self notify("hud_destroyed");
}

hud_satchel_deathwatch()
{
	self endon("hud_destroyed");
	self waittill("death");
	
	if(isDefined(self.hintelem))
	{
		self.hintelem destroy();
	}
}

setup_client_hintelem()
{
	self endon("death");
	self endon("disconnect");
	
	if(!isDefined(self.hintelem))
	{
		self.hintelem = newclienthudelem(self);
	}
	self.hintelem init_hint_hudelem(320, 220, "center", "bottom", 1.3, 1.0);
}

players_satchel_hint()
{
	players = get_players();
	array_thread(players,::hud_satchel_hint);
}

init_hint_hudelem(x, y, alignX, alignY, fontscale, alpha)
{
	self.x = x;
	self.y = y;
	self.alignX = alignX;
	self.alignY = alignY;
	self.fontScale = fontScale;
	self.alpha = alpha;
	self.sort = 20;
	//self.font = "objective";
}

guy_follow_target_entity( target, goalradius )
{
	self endon( "death" );
	self endon( "stop_following" );
	
	if( isDefined(goalradius) )
	{
		self.goalradius = goalradius;
	}
	
	self.disableArrivals = true;
	self.disableExits = true;
	
	while( true )
	{
		self setGoalPos( target.origin );
		//wait(1);
		self waittill( "goal" );
	}
}

// settings for a guy to run to a goal while ignoring everything and being ignored
guy_to_goal_blind()
{
	self.ignoreme = true;
	self.ignoreall = true;
	self.goalradius = 64;
	
	self waittill("goal");
	
	self.ignoreme = false;
	self.ignoreall = false;
}

fade_to_black( fadeTime )
{
	if( !IsDefined( fadeTime ) )
	{
		fadeTime = 5;
	}
	
	// fade to black
	level.fadetoblack = NewHudElem(); 
	level.fadetoblack.x = 0; 
	level.fadetoblack.y = 0; 
	level.fadetoblack.alpha = 0; 
	
	level.fadetoblack.foreground = false;
	level.fadetoblack.sort = 50;
		
	level.fadetoblack.horzAlign = "fullscreen"; 
	level.fadetoblack.vertAlign = "fullscreen"; 
	level.fadetoblack.foreground = false; 
	level.fadetoblack.sort = 50; 	
	level.fadetoblack SetShader( "black", 640, 480 ); 

	// Fade into black
	level.fadetoblack FadeOverTime( fadeTime );
	level.fadetoblack.alpha = 1;
}

fade_from_black( fadeTime )
{
	if( !IsDefined( fadeTime ) )
	{
		fadeTime = 5;
	}

	// Fade into black
	level.fadetoblack FadeOverTime( fadeTime );
	level.fadetoblack.alpha = 0;
	wait( fadeTime );
	level.fadetoblack Destroy(); // get rid of it, if it's not visible
}

fade_cleanup()
{
	if( isDefined( level.fadetoblack ) )
	{
		level.fadetoblack Destroy();
	}
	
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		player = players[i];

		player SetClientDvar( "hud_showStance", "1" ); 
		player SetClientDvar( "compass", "1" ); 
		player SetClientDvar( "ammoCounterHide", "0" );
		player setClientDvar ( "miniscoreboardhide", "0" );
		if(isDefined(player.warpblack))
		{
			player.warpblack destroy();
		}
	}
}


hud_fade_to_black(time)
{
	self endon("death");
	self endon("disconnect");
	
	if(!isDefined(time))
	{
		time = 1;
	}	
	if(!isDefined(self.warpblack))
	{
		self.warpblack = NewClientHudElem( self ); 
		self.warpblack.x = 0; 
		self.warpblack.y = 0; 
		self.warpblack.horzAlign = "fullscreen"; 
		self.warpblack.vertAlign = "fullscreen"; 
		self.warpblack.foreground = false;
		self.warpblack.sort = 50;
		
		self.warpblack.alpha = 0; 
		self.warpblack SetShader( "black", 640, 480 );	
	}
	self.warpblack FadeOverTime( time ); 
	self.warpblack.alpha = 1;	
}

hud_fade_in(time)
{
	self.warpblack FadeOverTime( time ); 
	self.warpblack.alpha = 0;
}





/*------------------------------------
spawn in guys thru script. 
------------------------------------*/
simple_spawn( name, spawn_func, delay )
{
	
	spawners = getEntArray( name, "targetname" );
	// add spawn function to each spawner if specified
	if( isdefined( spawn_func ) )
	{
		for( i  = 0; i < spawners.size; i++ )
		{
			spawners[i] add_spawn_function( spawn_func );
		}
	}

	ai_array = [];

	for( i = 0; i < spawners.size; i++ )
	{
		
		if( i % 2)
		{
			//wait for a new network frame to be sent out before spawning in 
			//another guy
			wait_network_frame();
		}
		
		// check if we want to forcespawn him
		if( IsDefined( spawners[i].script_forcespawn ) )
		{
			ai = spawners[i] StalingradSpawn(); 
		}
		else
		{
			ai = spawners[i] DoSpawn(); 
		}
		
		okiPrint( "Spawning " + spawners[i].targetname );
		
		spawn_failed( ai );
		
		// for debug purposes (so entinfo displays their name)
		if( isdefined( ai ) )
		{
			ai.targetname = name + "_alive";
			if(isDefined(spawners[i].script_noteworthy))
			{
				ai.script_noteworthy = spawners[i].script_noteworthy;
			}
		}
		
		ai_array = add_to_array( ai_array, ai );
	}
	
	return ai_array;
}

simple_floodspawn( name, spawn_func )
{
	
	spawners = getEntArray( name, "targetname" );

	assertex( spawners.size, "no spawners with targetname " + name + " found!" );	
	
	// add spawn function to each spawner if specified
	if( isdefined( spawn_func ) )
	{
		for( i  = 0; i < spawners.size; i++ )
		{
			spawners[i] add_spawn_function( spawn_func );
		}
	}
	
	for( i=0; i< spawners.size; i++ )
	{
		
		if( i % 2 )
		{
			//wait for a new network frame to be sent out before spawning in another guy
			wait_network_frame();
		}
		
		spawners[i] thread maps\_spawner::flood_spawner_init();
		spawners[i] thread maps\_spawner::flood_spawner_think();
	}
}


do_dialogue(dialogue,aname )
{
	self.old_animname = self.animname;
	self.animname = aname;
	self anim_single_solo( self, dialogue );
	self.animname = self.old_animname;
	//St = trim_dialogue(dialogue,aname);
	//iprintlnbold(self.name + ": " + st );
}

trim_dialogue(dialogue,aname)
{
	
	strng = level.scr_sound[aname][dialogue];
	newstr = "";
	for(x=strng.size -1;x>5;x--)
	{
		newstr = strng[x] + newstr;
	}
	
	return (newstr);
}


// disable colors on all guys
disable_friendly_color()
{
	ai = getaiarray("allies");
	
	for (i = 0; i < ai.size; i++)
	{
		ai[i] disable_ai_color();
	}
}

// enable colors on all guys
enable_friendly_color()
{
	ai = getaiarray("allies");
	
	for (i = 0; i < ai.size; i++)
	{
		ai[i] enable_ai_color();
	}
}

// enable colors on all guys
enable_friendly_color_gradual( delay )
{
	ai = getaiarray("allies");
	
	for (i = 0; i < ai.size; i++)
	{
		ai[i] enable_ai_color();
		wait( delay );
	}
}

players_enable_rain()
{
	players = getplayers();
	for(i=0; i<players.size; i++)
	{
		players[i] setwaterdrops(25);	
	}	
}

players_disable_rain()
{
	players = getplayers();
	for(i=0; i<players.size; i++)
	{
		players[i] setwaterdrops(0);	
	}	
}

// there's parts of this level that are nonlinear.  I want the squad to stick near the
// player, so what this does is make them stick by player0, (the first player).  Having
// them follow all the players obviously is just going to lead to mixed signals and chaos.

// so, what you do is set up some cover nodes and color them along with an appropriate trigger.
// Then place another trigger there that'll repeat, and detect whether the first player is
// who's triggering it.  If so, trigger that trigger's noteworthy entity.
trigger_noteworthy_if_player0( trigger, end_notify )
{
	self endon( end_notify );
	
	trigger = getent( trigger, "targetname" ); // get the trigger_multiple
	if( isdefined(trigger) )
	{
		okiPrint( "trigger_noteworthy_if_player0 found trigger: " + trigger.targetname );
	}
	
	while( isdefined(trigger) )
	{
		if( isdefined(trigger.script_noteworthy) )
		{
			target = getent( trigger.script_noteworthy, "targetname" ); // grab the target via script_noteworthy
			if( isdefined(target) )
			{
				target.script_color_auto_disable = false; // we want the color nodes to be re-triggerable
				trigger waittill( "trigger" ); // wait for the trigger_multiple to be touched
				players = get_players();
				if( players[0] istouching(trigger) ) // check whether player0 is inside the volume
				{
					okiPrint( "Activating targetname: " + trigger.script_noteworthy );
					target notify("trigger"); // activate the target if so
				}
			}
			else
			{
				okiPrint( "Couldn't find match for script_noteworthy!" );
				return;
			}
			
		}
		else
		{
			okiPrint( "No script_noteworthy on trigger!" );
			return;
		}
		
		wait(2.0); // so this doesn't loop ridiculously fast
	}
}


/*------------------------------------
moves the players to script_structs 
- used for setting start points
------------------------------------*/
move_players(spots)
{

	players = get_players();
	points = getstructarray(spots,"targetname");
	
	for(x =0;x<players.size;x++)
	{
		players[x] setorigin(points[x].origin);
		players[x] setplayerangles( points[x].angles ); // JAS Jun 30 2008, setplayerangles uses angles, not a vector
	}
	
}

// spawns each spawner with a matching targetname, then returns the list of resultant guys
spawn_array_once( targetname, fieldname )
{
	guys = [];
	
	spawners = getentarray( targetname, fieldname );
	if( isDefined(spawners) )
	{
		for( i=0; i<spawners.size; i++ )
		{
			guy = spawners[i] StalingradSpawn();
			if( isDefined(guy) )
			{
				okiPrint( "Spawning " + targetname + " #" + i );
				guys[guys.size] = guy;
			}
			if( i % 2 == 1 ) // wait a network frame after every other guy
			{
				wait_network_frame();
			}
		}
	}
	
	return guys;
}

// Respawns a guy until his spawner runs out
maintain_mg_guy( endmsg, spawntargetname, guytargetname, threatbiasgroup )
{
	level endon(endmsg);

	spawner = getent( spawntargetname, "targetname" );
	okiPrint( "maintain_mg_guy found " + spawner.targetname );
	spawner add_spawn_function( ::guy_to_goal_blind );

	while( isDefined(spawner) ) // spawner could run out of count
	{
		guy = spawner stalingradspawn();
		if( isDefined(guy) ) // eventually the spawn counter can run out
		{
			guy.targetname = guytargetname;
			guy waittill( "death" );
			if( isDefined( threatbiasgroup) )
			{
				guy setThreatBiasGroup( threatbiasgroup );	
			}
			wait( 5 );
		}
		else
		{
			return;
		}
	}
}


/*------------------------------------
set stances on the friendlies
------------------------------------*/
set_friendly_stances(a,b,c)
{
	friends = get_ai_group_ai("dasquad");//getentarray("friends","targetname");

	for(i=0;i<friends.size;i++)
	{
		
		if(isDefined(a))
		{
			if(isDefined(b))
			{
				if(isDefined(c))
				{
					friends[i] allowedstances(a,b,c);
				}
				else
				{
					friends[i] allowedstances(a,b);
				}
			}
			else
			{
				friends[i] allowedstances(a);
			}
		}		
	}
}

seek_players( )
{
	self endon( "death" );
	
	wait(randomfloatrange(1,10));
	while( issentient( self ) )
	{
		self SetGoalEntity( get_closest_player(self.origin));
		if( self.goalradius > 200 )
		{
			self.goalradius -= 200; 
		}
		wait( 6 );
	}
}


get_free_ai()
{
	ai = getaiarray("allies");
	for(i=0;i<ai.size;i++)
	{
		if(ai[i] !=  level.sarge && ai[i] != level.guy1)
		{
			return ai[i];
		}
	}
}


// Fake death
// self = the guy getting worked
bloody_death( die, delay )
{
	self endon( "death" );

	if( !is_active_ai( self ) )
	{
		return;
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return;
	}

	self.bloody_death = true;

	if( IsDefined( delay ) )
	{
		wait( RandomFloat( delay ) );
	}

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";
	
	for( i = 0; i < 2; i++ )
	{
		random = RandomIntRange( 0, tags.size );
		//vec = self GetTagOrigin( tags[random] );
		self thread bloody_death_fx( tags[random], undefined );
		wait( RandomFloat( 0.1 ) );
	}

	if( die )
	{
		self DoDamage( self.health + 150, self.origin );
	}
}	

// self = the AI on which we're playing fx
bloody_death_fx( tag, fxName ) 
{ 
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["flesh_hit"];
	}

	PlayFxOnTag( fxName, self, tag );
}

is_active_ai( suspect )
{
	if( IsDefined( suspect ) && IsSentient( suspect ) && IsAlive( suspect ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}


random_death(time)
{

	if(!isDefined(time))
	{
		time = randomintrange(2,5);
	}
	
	//self doDamage( self.health + 1, self.origin );
	self bloody_death(true,time );
}

//uses a script_struct like a trigger radius ( keep down those ent counts! )
org_trigger(org,radius,notification)
{
	
	trig = false;
	while(!trig)
	{
		players = get_players();
		for(i=0;i<players.size;i++)
		{
			if( distancesquared(players[i].origin,org) < radius * radius)
			{
				trig = true;
			}
		}
		wait(.1);
	}
	
	if(isDefined(notification))	
	{
		level notify(notification);
	}
}


/*------------------------------------
moves the ai after spawning them in
used in skipto's/starts
------------------------------------*/
move_ai(spots)
{
	ai = get_ai_group_ai("dasquad"); //getaiarray("allies");

	points = getstructarray(spots,"targetname");
	
	for(x=0;x<ai.size;x++)
	{
		okiPrint( "move_ai: Moving AI to " + points[x].origin );
		
		ai[x].anchor = spawn("script_origin",ai[x].origin);
		ai[x] linkto( ai[x].anchor);
		ai[x].anchor moveto(points[x].origin,.02);
		ai[x].anchor waittill("movedone");
		if(isDefined(points[x].angles))
		{
			ai[x].anchor.angles = points[x].angles;
		}
		ai[x] unlink();
		ai[x].anchor delete();
		
		okiPrint( "move_ai: AI location is now " + ai[x].origin );
	}
}

move_ai_single( guy, nodename )
{
	node = getstruct( nodename,"targetname" );
	
	guy.anchor = spawn("script_origin",guy.origin);
	guy linkto( guy.anchor);
	guy.anchor moveto(node.origin,.02);
	guy.anchor waittill("movedone");
	if(isDefined(node.angles))
	{
		guy.anchor.angles = node.angles;
	}
	guy unlink();
	guy.anchor delete();
}

notify_when_trigger_hit( triggername, notifystring, endmsg )
{
	if( isDefined(endmsg) )
	{
		level endon( endmsg );	
	}
	
	trig = getent( triggername, "targetname" );
	trig waittill( "trigger" );
	level notify(notifystring);
}

manage_spawners_nogoal( strSquadName, mincount, maxcount, ender, spawntime, spawnfunction, wave_delay_min, wave_delay_max )
{
	println("********************************");
	println("SQUAD ",strSquadName);
	println("must have ",mincount," alive until we hit we get this \"",ender,"\" message");
	println("spawning every ",spawntime," seconds");
	println("********************************");

	self endon (ender);

	//---------------------------------------------------------------------------
	//	set up 
	//---------------------------------------------------------------------------

	//	squad_spawn will be just the spawn points for this squad
	spawn_index = 0;	//	an index into the spawn array

	squad_spawn = spawn_array(strSquadName);
	
	if ( squad_spawn.size == 0 )
	{
		maps\_utility::error("SQUAD MANAGER:  Could not find spawners for squad " + strSquadName);
		return;
	}
	
	//---------------------------------------------------------------------------
	//	main loop
	//---------------------------------------------------------------------------


	if (!isdefined(spawntime))
		spawntime = 0.05;
		
	while(1)
	{
		aSquad = alive_array(strSquadName);	//	alive squad ai's
		//	we don't have enough guys in the squad 
		//	spawn a new one
		
		okiPrint( "Squad " + strSquadName + " population is " + aSquad.size );
		
		if (aSquad.size < mincount)
		{
			level notify (strSquadName + " min threshold reached");
			//println (strSquadName + " min threshold reached");
			while ( aSquad.size < maxcount )
			{

				// if the variable is set use the stalingradspawn function which 
				// forces the spawn even if the player can see the spawn point
				if(	isdefined(squad_spawn[spawn_index].script_forcespawn) 
					&& squad_spawn[spawn_index].script_forcespawn )
				{	
					spawned = squad_spawn[spawn_index] stalingradSpawn();
				}
				else
				{
					spawned = squad_spawn[spawn_index] doSpawn();
				}
				
				//	if we spawned ok then we can set the goal 
				if (isdefined(spawned))
				{

					wait(0.02);

					aSquad[aSquad.size] = spawned;
					
					// call the given spawn function on the spawned guy
					if ( isDefined(spawnfunction) )
					{
						spawned thread [[spawnfunction]]();
					}
				}
				//	move to next spawn point , bounds checking it 
				spawn_index = spawn_index + 1;
				if (spawn_index>=squad_spawn.size)
					spawn_index = 0;
					
				wait(spawntime);				
			}
		}
		wave_delay = 0.2;
		if(isDefined(wave_delay_min))
		{
			min = wave_delay_min;
			max = wave_delay_min + .05;
			if(isDefined(wave_delay_max))
			{
				max = wave_delay_max;
			}
			wave_delay = randomfloatrange(min,max);
		}
		wait(wave_delay);
	}
}

alive_array(strSquadName)
{
	aSquad = [];
	aRoster = getaiarray();
	for (i=0;i<aRoster.size;i++)
	{
		if (isdefined(aRoster[i].script_squadname))
		{
			if (aRoster[i].script_squadname == strSquadName)
			{
				aSquad[aSquad.size] = aRoster[i];
			}
		}
	}	
	return(aSquad);
}

spawn_array(strSquadName)
{
	squad_spawn = [];	//	the spawn array , never updates
	aSpawner = getspawnerarray();	

	for(i=0; i<aSpawner.size; i++)
	{
		//	find a spawner for my squad 
		if (isdefined (aSpawner[i].script_squadname))
		{
			if (aSpawner[i].script_squadname == strSquadName)
			{
				squad_spawn[squad_spawn.size] = aSpawner[i];
			}
		}
	}
	return(squad_spawn);
}

cleanup_trigger_disable( triggername )
{
	trig = getent( triggername, "targetname" );
	trig trigger_off();
}

// turn the specified trigger on, and try to delete all the
// axis guys out of it, waiting for no player presense to do so
cleanup_trigger_enable( triggername )
{
	trig = getent( triggername, "targetname" );
	trig trigger_on();
	
	to_delete = [];
	numdelete = 0;
	
	okiPrint( "cleanup_trigger_enable starting on " + triggername );
	
	// get all the axis and work out which ones are within the trigger
	guys = getaiarray("axis");
	if( isdefined(guys) )
	{
		okiPrint( "cleanup_trigger_enable found " + guys.size + " guys" );
		for( i=0; i<guys.size; i++ )
		{
			if( guys[i]	isTouching(trig) )
			{
				to_delete[numdelete] = guys[i];
				numdelete++;
			}
		}
		
		okiPrint( "cleanup_trigger_enable found " + to_delete.size + " axis touching trigger" );
		
		players_touching = true;
		
		// now wait for no players to be touching the trigger
		while( players_touching == true )
		{
			wait(1.5);
			players = get_players();
			players_touching = false; // start with false
			for( i=0; i<players.size; i++ )
			{
				if( players[i] isTouching(trig) )
				{
					players_touching = true; // if anyone's touching the trigger, back to true	
				}
			}
		}
		
		okiPrint( "cleanup_trigger_enable detected no players touching " + triggername );
		
		// if we get here, no players were touching the trigger, so go ahead and kill the guys
		for( i=0; i<guys.size; i++ )
		{
			if( isDefined(guys[i]) )
			{
				if( guys[i] isTouching(trig) )
				{
					guys[i] thread random_death();
					okiPrint( "cleanup_trigger_enable removing AI touching trigger " + triggername + " at origin " + guys[i].origin );
				}
			}
		}
	}
	
	trig trigger_off();
}