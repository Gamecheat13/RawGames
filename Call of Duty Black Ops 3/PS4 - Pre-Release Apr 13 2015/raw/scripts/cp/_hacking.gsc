#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\load_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_objectives;
#using scripts\cp\gametypes\_save;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_spawnlogic;

#namespace hacking;

#precache( "lui_menu", "HackingHUD" );
#precache( "lui_menu_data", "HackingProgress" );
#precache( "lui_menu_data", "HackingVisibleFPP" );
#precache( "lui_menu_data", "HackingVisibleTPP" );

function autoexec __init__sytem__() {     system::register("hacking",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	
	level.hacking = SpawnStruct();
	level.hacking flag::init( "in_progress" );
	level.hacking.progress = 0.0;
	level.hacking.hacker = undefined;
}

function on_player_connect()
{
	
}

function refresh_hack_hud()
{
	if ( level.hacking flag::get( "in_progress" ) )
	{
		if ( isdefined( level.hacking.hacker ) && level.hacking.hacker == self )
		{
			self SetLUIMenuData( self.hacking_menu, "HackingVisibleFPP", 1.0 );
			self SetLUIMenuData( self.hacking_menu, "HackingVisibleTPP", 0.0 );
		}
		else
		{
			self SetLUIMenuData( self.hacking_menu, "HackingVisibleFPP", 0.0 );
			self SetLUIMenuData( self.hacking_menu, "HackingVisibleTPP", 1.0 );
		}
		self SetLUIMenuData( self.hacking_menu, "HackingProgress", level.hacking.progress );
	}
	else
	{
		self SetLUIMenuData( self.hacking_menu, "HackingVisibleFPP", 0.0 );
		self SetLUIMenuData( self.hacking_menu, "HackingVisibleTPP", 0.0 );
	}
}

function on_player_spawned()
{
	self.hacking_menu = self OpenLUIMenu( "HackingHUD" );
	self SetLUIMenuData( self.hacking_menu, "HackingProgress", level.hacking.progress );
	self refresh_hack_hud();
}

function private freeze_player( b_do_freeze )
{
	if ( !b_do_freeze )
	{
		if ( IsDefined(self.freeze_origin) )
		{
			self Unlink();
			self.freeze_origin Delete();
			self.freeze_origin = undefined;
		}
	} else {
		if ( !IsDefined(self.freeze_origin) )
		{
			self.freeze_origin = Spawn( "script_model", self.origin );
			self.freeze_origin SetModel( "tag_origin" );
			self.freeze_origin.angles = self.angles;
			self PlayerLinkToDelta(self.freeze_origin, "tag_origin", 1.0, 45.0, 45.0, 45.0, 45.0 );
		}
	}
}

function process_hacking( n_time )
{
	// TODO: what happens when the hacker disconnects mid-hack?
	//
	level endon( "hacking_complete" );
	
	const start_ms = 500;
	
	if ( isdefined( level.hacking.hacker ) )
	{
		level.hacking.hacker thread scene::play( "cin_gen_player_hack_start", level.hacking.hacker );
	}
	
	n_time_ms = n_time * 1000;
	n_start_time = GetTime();
	
	do
	{
		n_cur_time = GetTime() - n_start_time;
		
		if ( isdefined( level.hacking.hacker ) )
		{
			if ( n_cur_time > start_ms && !( level.hacking.hacker UseButtonPressed() ) )
			{
				break;
			}
		}
		
		n_pct = n_cur_time / n_time_ms;
		if (n_pct < 0.0) {     n_pct = 0.0;    }    else if (n_pct > 1.0) {     n_pct = 1.0;    };
		
		foreach( e_player in level.players )
		{
			e_player SetLUIMenuData( e_player.hacking_menu, "HackingProgress", n_pct );
		}
		wait 0.5;
	} while ( n_cur_time < n_time_ms );
	
	if ( isdefined( level.hacking.hacker ) )
	{
		level.hacking.hacker thread scene::play( "cin_gen_player_hack_finish", level.hacking.hacker );
	}
	
	level notify( "hacking_complete", n_cur_time >= n_time_ms, level.hacking.hacker );
}

// Run the hacking hud.
//
// n_hacking_time: time in seconds the hack should last.
// e_hacking_player [optional]: player performing the hack
//
function hack( n_hacking_time, e_hacking_player )
{
	Assert( !(level.hacking flag::get( "in_progress" )), "Trying to start a hack when one is already in progress." );
	
	level.hacking.hacker = e_hacking_player;
	level.hacking.progress = 0.0;
	level.hacking flag::set( "in_progress" );
	
	foreach ( e_player in level.players )
	{
		e_player refresh_hack_hud();
	}
	
	level thread process_hacking( n_hacking_time );
	
	level waittill( "hacking_complete", b_success, e_hacker );
	
	level.hacking.hacker = undefined;
	level.hacking.progress = 0.0;
	level.hacking flag::clear( "in_progress" );
	
	foreach ( e_player in level.players )
	{
		e_player refresh_hack_hud();
	}
}

function private _run_hack_trigger( n_hacking_time )
{
	while ( true )
	{
		self waittill( "trigger", e_who );
		thread hack( n_hacking_time, e_who );
		level waittill( "hacking_complete", b_success, e_hacker );
		if ( b_success )
		{
			self notify( "trigger_hack", e_hacker );
			break;
		}
	}
}

// Sets up a player-usable hacking trigger which upon completion will trigger a notify.
//
// self == trigger
//
// n_hacking_time: time in seconds that the hack should last.
//
// upon completion the notify "trigger_hack" will be sent.
//
function init_hack_trigger( n_hacking_time )
{
	self thread _run_hack_trigger( n_hacking_time );
}

// Wait for a hacking trigger to finish its hacking
//
// self == trigger
// returns the player who performed the hack.
//
function trigger_wait()
{
	self waittill( "trigger_hack", e_who );
	return e_who;
}
