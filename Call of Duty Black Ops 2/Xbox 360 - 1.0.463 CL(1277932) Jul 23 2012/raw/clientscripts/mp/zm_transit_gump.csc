#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;
//=============================================================================
// Run Forest Run!
//=============================================================================

init_transit_gump()
{
	waitforclient( 0 );
	waitforallclients();
	wait 0.05;

/#	PrintLn("CSCGUMP : initing zm_transit gump system...");	#/
	players = getlocalplayers(); //level.localPlayers;
/#	PrintLn("CSCGUMP : player size for gump = " + players.size);	#/

	machinelocal=machinelocalstorage();
	machinelocal.gumpname=[];
	machinelocal.gumpname[0]="none";
	machinelocal.gumpname[1]="none";
	machinelocal.gumpname[2]="none";
	machinelocal.gumpname[3]="none";
	machinelocal.gumpnamequeued=[];
	machinelocal.gumpnamequeued[0]="none";
	machinelocal.gumpnamequeued[1]="none";
	machinelocal.gumpnamequeued[2]="none";
	machinelocal.gumpnamequeued[3]="none";
	machinelocal.gump_loading = 0;

	if ( GetDvar( "ui_gametype" )=="zclassic" || GetDvar( "ui_gametype" )=="zsurvival" )
	{
		slots = players.size;
		/#
		if (slots<2)
			slots=2; // use 2 in debug to make sure we have room for 2 player splitscreen
		#/
		slots -= 1;
		thread load_gump_for_player( getlocalplayers()[0], slots, "zm_transit_gump_prealloc_0" );
		level waittill( "gump_loaded" );
		for( i = 0; i<slots; i++)
		{
			transit_gump_preallocate(i);
		}

		gump_trigs = GetEntArray( 0, "gump_triggers", "targetname" );

		if(IsDefined(gump_trigs))
		{
			array_thread(gump_trigs, ::gump_watch_trigger, 0 );
		}	

		thread watch_spectation(gump_trigs);
	}
	else
	{
		start_location = GetDvar( "ui_zm_mapstartlocation" );
		if ( start_location == "transit" )
			start_location = "busstation";
		if(start_location == "power")
		{
			start_location = "powerstation"; //need to do this because there is a character limit for the start location dvar
		}
		
		single_gump_name = "zm_transit_gump_" + start_location;
	/#	PrintLn("CSCGUMP: Encounter mode gump loading "+single_gump_name + "\n");	#/
		load_gump_for_player( getlocalplayers()[0], 0, single_gump_name );
		return;
	}


}


watch_spectation(gump_trigs)
{
	players = getlocalplayers(); 
	for (i=0;i<players.size;i++)
		players[i] thread watch_spectation_player(i,gump_trigs);
}

watch_spectation_player(lcn,gump_trigs)
{
	followed = PlayerBeingSpectated(lcn);
	for (;;)
	{
		// TODO - this needs to be event driven!!!
		wait 0.25;
		new_followed = PlayerBeingSpectated(lcn);
		if ( followed != new_followed )
		{
			followed = new_followed;
			self find_new_gump(gump_trigs,lcn,followed);
		}
	}
}

find_new_gump(gump_trigs,lcn,player)
{
	machinelocal=machinelocalstorage();
	for (i=0; i<gump_trigs.size;i++)
	{
		if ( IsDefined(gump_trigs[i].script_string) && player IsTouching(gump_trigs[i]) )
		{
			load_gump_for_player( player, lcn, gump_trigs[i].script_string );
			return;
		}
		//iprintlnbold("Player "+self.name+" is spectating "+player.name+" in no known gump\n");
	}
}


//=============================================================================
//
//=============================================================================
transit_gump_preallocate(localClientNum)
{
/#
	PrintLn("CSCGUMP : load prealloc gump" + localClientNum);
	wait(.01);
	gump = localClientNum; 
	load_gump_for_player( getlocalplayers()[localClientNum], gump, "zm_transit_gump_prealloc_"+gump );
	wait(.01);
	return;
#/
}

// somewhere to store stuff on a per-machine basis
machinelocalstorage()
{
	return level;
}

same_player( p1, p2 )
{
	if ( p1 GetEntityNumber() == p2 GetEntityNumber() )
	{
		assert( p1.name == p2.name, "Entity numbers match, but names don't for " + p1.name + " and " + p2.name );
		return true;
	}
	assert( p1.name != p2.name, "Entity numbers match, but names don't for " + p1.name + " numbers " + p1 GetEntityNumber() + " and " + p2 GetEntityNumber() );
	return false;
}

gump_watch_trigger(localClientNum)
{
	machinelocal=machinelocalstorage();
	players = getlocalplayers(); //level.localPlayers;
	gump = ( localClientNum != 0 );

	while( 1 )
	{
		self waittill( "trigger", who );
		
		if(who IsPlayer() && IsDefined(self.script_string))
		{
			if ( same_player( who, PlayerBeingSpectated(0) ) )
			{
				machinelocal.gumpnamequeued[0] = self.script_string;
				self thread trigger_thread(who, ::enter_gump_trigger0);
			}
			else if ( players.size > 1 && same_player( who, PlayerBeingSpectated(1) ) )
			{
				machinelocal.gumpnamequeued[1] = self.script_string;
				self thread trigger_thread(who, ::enter_gump_trigger1);
			}
			else if ( players.size > 2 && same_player( who, PlayerBeingSpectated(2) ) )
			{
				machinelocal.gumpnamequeued[2] = self.script_string;
				self thread trigger_thread(who, ::enter_gump_trigger2);
			}
			else if ( players.size > 3 && same_player( who, PlayerBeingSpectated(3) ) )
			{
				machinelocal.gumpnamequeued[3] = self.script_string;
				self thread trigger_thread(who, ::enter_gump_trigger3);
			}
		}
	}
}

enter_gump_trigger0(player)
{
	if (player IsPlayer())
		load_gump_for_player( player, 0, self.script_string );
}
enter_gump_trigger1(player)
{
	if (player IsPlayer())
		load_gump_for_player( player, 1, self.script_string );
}
enter_gump_trigger2(player)
{
	if (player IsPlayer())
		load_gump_for_player( player, 2, self.script_string );
}
enter_gump_trigger3(player)
{
	if (player IsPlayer())
		load_gump_for_player( player, 3, self.script_string );
}


//
// This is the main gump load wrapper. It is safely reentrant. 
//

load_gump_for_player( player, gump, name )
{
	machinelocal=machinelocalstorage();
	machinelocal.gumpnamequeued[gump] = name;

	// wait while other gumps load
	while( isdefined(machinelocal.gump_loading) && machinelocal.gump_loading )
		wait 0.25;

	machinelocal.gump_loading = 1;
	while( machinelocal.gumpname[gump] != machinelocal.gumpnamequeued[gump] )
	{
	/#	PrintLn("CSCGUMP: Loading "+machinelocal.gumpnamequeued[gump]+" in gump "+gump+" to replace "+machinelocal.gumpname[gump]+"\n");	#/
		machinelocal.gumpname[gump] = machinelocal.gumpnamequeued[gump];
		loadgump( machinelocal.gumpname[gump], gump );
		level waittill( "gump_loaded" );
	}
	machinelocal.gump_loading = 0;
}

