#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\table_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\cp\gametypes\_save;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\_util;

#namespace accolades;






	


function autoexec __init__sytem__() {     system::register("accolades",&__init__,&__main__,undefined);    }
	
function __init__()
{
	if( AccoladesDisabled() )
	{
		return;
	}
	//There's no good way to check stat paths, so the mission names are hardcoded
	//and checked before stats are committed
	mission_names = [];
	mission_names[ mission_names.size ] = "AQUIFER";
	mission_names[ mission_names.size ] = "BIODOMES";
	mission_names[ mission_names.size ] = "BLACKSTATION";
	mission_names[ mission_names.size ] = "INFECTION";
	mission_names[ mission_names.size ] = "LOTUS";
	mission_names[ mission_names.size ] = "NEWWORLD";
	mission_names[ mission_names.size ] = "PROLOGUE";
	mission_names[ mission_names.size ] = "RAMSES";
	mission_names[ mission_names.size ] = "SGEN";
	mission_names[ mission_names.size ] = "VENGEANCE";
	mission_names[ mission_names.size ] = "ZURICH";
	
	level.accolades = [];
	
	//hacky way to get mission_name until it is put into the gdt
	level.root_map_name = GetRootMapName();
	level.mission_name = GetMissionName();
	
	
	//only register the default accolades if the mission name is listed above
	if( IsDefined( level.mission_name ) && MissionHasAccolades( level.root_map_name ) )
	{
		//get mission name index
		for( i = 0; i < mission_names.size; i++ )
		{
			if( mission_names[ i ] == ToUpper( level.mission_name ) )
			{
				level.mission_index = i + 1; //need the +1 so that the index is never 0 ( the default lastMissionIndex stat value )
				break;
			}
		}
		
		callback::on_connect( &on_player_connect );
		callback::on_spawned( &on_player_spawned );
		callback::on_disconnect( &on_player_disconnect );
		
		//Register default accolades
		
		level.default_accolades_prefix = "MISSION_" + ToUpper( level.mission_name ) + "_";
		
		register( level.default_accolades_prefix + "UNTOUCHED", undefined, true ); //set notify to when player is hit
		register( level.default_accolades_prefix + "SCORE" );
		register( level.default_accolades_prefix + "COLLECTIBLE", "picked_up_collectible" );
	}
}

function __main__()
{
	if( AccoladesDisabled() )
	{
		return;
	}
}

//UTILITY FUNCTIONS
function get_accolade( str_accolade )
{
	return self savegame::get_player_data( "accolades" )[str_accolade];
}

function set_accolade( str_accolade, new_accolade )
{
	accolade_array = self savegame::get_player_data( "accolades" );
	accolade_array[ str_accolade ] = new_accolade;
	self savegame::set_player_data( "accolades", accolade_array );
}

function GetAccoladeMapStat( accolade_index )
{
	return self GetDStat( "PlayerStatsByMap", level.root_map_name, "accolades", accolade_index );
}

function SetAccoladeMapStat( accolade_index, value )
{
	self SetDStat( "PlayerStatsByMap", level.root_map_name, "accolades", accolade_index, value );
	/#
		self.accolades_dirty = true; //refresh debug ui
	#/
}

function GetAccoladeMapStatValue( accolade_index )
{
	stat_value = self GetAccoladeMapStat( accolade_index );
	stat_value = stat_value & ~(7 << 29);
	return stat_value;
}

function SetAccoladeMapStatValue( accolade_index, value )
{
	stat_value = self GetAccoladeMapStat( accolade_index );
	state = stat_value & (7 << 29);
	stat_value = value | state;
	self SetAccoladeMapStat( accolade_index, stat_value );
}

function AddAccoladeMapStatValue( accolade_index, value )
{
	statValue = self GetAccoladeMapStatValue( accolade_index );
	self SetAccoladeMapStatValue( accolade_index, statValue + value );
	return statValue + value;
}

function GetAccoladeMapStatState( accolade_index )
{
	stat_value = self GetAccoladeMapStat( accolade_index );
	state = stat_value >> 29;
	return state;
}

function SetAccoladeMapStatState( accolade_index, state )
{
	stat_value = self GetAccoladeMapStat( accolade_index );
	stat_value = stat_value & ~(7 << 29); //clear out old state
	stat_value = stat_value | ( state << 29 );
	self SetAccoladeMapStat( accolade_index, stat_value );
}

function SaveCheckpointAccolades()
{
	if( self == level )
	{
		foreach( player in level.players )
		{
			player SaveCheckpointAccolades();
		}
	}
	else
	{
		accolades = self savegame::get_player_data( "accolades" );
		
		if( !IsDefined( accolades ) )
		{
			return;
		}
		
		foreach( str_accolade, s_accolade in level.accolades )
		{
			accolade = accolades[ str_accolade ];

			if( accolade.current_value > self GetAccoladeMapStatValue( accolade.index ) )
			{
				self SetAccoladeMapStatValue( accolade.index, accolade.current_value );
			}
		}
	}	
}

function private _accolade_is_completed( str_accolade, accolade_value )
{
	accolade_table_row = TableLookupRowNum( "gamedata/stats/cp/statsmilestones1.csv", 4, str_accolade );
	accolade_target_value = TableLookupColumnForRow( "gamedata/stats/cp/statsmilestones1.csv", accolade_table_row, 2 );
	return ( Int( accolade_target_value ) <= accolade_value );
}

function private AccoladesDisabled()
{
	return ( ( isdefined( level.accolades_disabled ) && level.accolades_disabled ) || ( SessionModeIsCampaignZombiesGame() ) );
}

function is_beginning_of_mission()
{
	return !IsMapSubLevel() && ( GetDvarString( "skipto" ) == "" || GetDvarString( "skipto" ) == "level_start" );
}

function accolade_rewards_unlock_token( str_accolade )
{
	does_reward_token = TableLookup( "gamedata/stats/cp/statsmilestones1.csv", 4, ToUpper( str_accolade ), 7 );
	return does_reward_token != "";
}

function get_accolade_xp( str_accolade )
{
	accolade_xp = TableLookup( "gamedata/stats/cp/statsmilestones1.csv", 4, ToUpper( str_accolade ), 6 );
	if( accolade_xp != "" )
	{
		return Int( accolade_xp );
	}
	return 0;
}

function add_unlock_token( num_tokens = 1 )
{
	num_unlock_tokens = self GetDStat( "unlocks", 0 );
	num_unlock_tokens += num_tokens;
	self SetDStat( "unlocks", 0, num_unlock_tokens );
}

/@
"Name: register( <str_accolade>, [str_increment_notify], [is_inverted] )"
"Summary: Register an accolade for this level.  The accolade name needs to match the name in the stats table."
"CallOn: NA"
"MandatoryArg: <str_accolade> The accolade name."
"OptionalArg: [str_increment_notify] A notify that, when send to a player, will increment that player's stat for this accolade."
"OptionalArg: [is_inverted] If this accolade is awarded by not meeting the condition."
"Example: accolades::register( "sgen_kill_x_stuff, "stuff_killed" )"
@/
function register( str_accolade, str_increment_notify, is_inverted )
{
	if( AccoladesDisabled() )
	{
		return;
	}
	if( !IsDefined( level.accolades[ str_accolade ] ) )
	{
		level.accolades[ str_accolade ] = SpawnStruct();
		level.accolades[ str_accolade ].increment_notify = str_increment_notify;
		level.accolades[ str_accolade ].index = level.accolades.size - 1; //0 indexed
		level.accolades[ str_accolade ].is_inverted = ( isdefined( is_inverted ) && is_inverted );
	}
}

/@
"Name: increment( <str_accolade>, [n_val = 1] )"
"Summary: Increment an accolade stat.  Progress is only saved at skiptos."
"CallOn: level for all players, or on an individual player."
"MandatoryArg: <str_accolade> The accolade name."
"OptionalArg: [n_val] How much to increment the stat by."
"Example: accolades::increment( "sgen_kill_x_stuff, "stuff_killed" )"
@/
function increment( str_accolade, n_val = 1, dont_print )
{
	if( AccoladesDisabled() )
	{
		return;
	}
	if ( self == level )
	{
		foreach ( player in level.players )
		{
			player increment( str_accolade );
		}
	}
	else
	{
		accolade = self get_accolade( str_accolade );
		
		if( GetAccoladeMapStatState( accolade.index ) != 0 )
		{
			return;
		}
		if( !( isdefined( accolade.is_inverted ) && accolade.is_inverted ) )
		{
			accolade.current_value += n_val;
		}
		else
		{
			accolade.current_value = 0;
		}
		/#
			//TODO update the csv file when we get to other milestones
		if( !( isdefined( dont_print ) && dont_print ) )
		{
			accolade_string = TableLookupIString("gamedata/stats/cp/statsmilestones1.csv", 4, str_accolade, 5);
			IPrintLn(accolade_string);
		}
			self.accolades_dirty = true;
		#/
		
		//check current value against target value
		if( !_accolade_is_completed( str_accolade, accolade.current_value ) )
		{
			return;
		}
		
		self SetAccoladeMapStatState( accolade.index, 1 );
		self SetAccoladeMapStatValue( accolade.index, accolade.current_value );
		
		// Show Event Notification only to the player who earned the accolade.
		accolade_string_complete = TableLookupIString("gamedata/stats/cp/statsmilestones1.csv", 4, str_accolade, 8);
		
		// If there's a "COMPLETED" string for this accolade, show it with an event notification
		if ( isdefined(accolade_string_complete) )
		{
			util::show_event_message(self, accolade_string_complete);
			self playlocalsound ("uin_accolade");
		}

		/#
			accolade.is_completed = true;
		#/
		if( ( isdefined( accolade.gives_unlock_token ) && accolade.gives_unlock_token ) )
		{
			self GiveUnlockToken( 1 );
		}
		
		self AddRankXPValue( "award_accolade", accolade.award_xp );
		
		UploadStats( self ); //commit all accolades to stats
	}
}

// self == player
function private _increment_by_notify( str_accolade, str_notify )
{
	self endon("_reset_incomplete_accolades");
	self endon( "disconnect" );
	
	if( !IsDefined( self.accolades_notify_threads ) )
	{
		self.accolades_notify_threads = [];
	}
	if( ( isdefined( self.accolades_notify_threads[ str_notify ] ) && self.accolades_notify_threads[ str_notify ] ) )
	{
		return; //accolade notify thread already exists
	}
	self.accolade_notify_threads[ str_notify ] = true;
	
	while ( true )
	{
		self waittill( str_notify, n_val );
		self increment( str_accolade, n_val );
	}
}

function private _reset_incomplete_accolades()
{
	self notify("_reset_incomplete_accolades");
	
	accolades = [];
	self savegame::set_player_data( "accolades", accolades ); //overwrite any old accolades
	
	foreach ( str_accolade, s_accolade in level.accolades )
	{
	
		newAccolade = SpawnStruct();
		newAccolade.index = s_accolade.index;
		newAccolade.is_inverted = s_accolade.is_inverted;
				
		if( self GetAccoladeMapStatState( s_accolade.index ) != 0 )
		{
			newAccolade.current_value = GetAccoladeMapStatValue( s_accolade.index );
			/#
				newAccolade.is_completed = true;
			#/
			self set_accolade( str_accolade, newAccolade );
			continue;
		}
		
		if( IsDefined( s_accolade.increment_notify ) && !( isdefined( strendswith( str_accolade, "COLLECTIBLE" ) ) && strendswith( str_accolade, "COLLECTIBLE" ) ) )
		{
			self thread _increment_by_notify( str_accolade, s_accolade.increment_notify );
		}
		
		if( s_accolade.is_inverted )
		{
			newAccolade.current_value = 1; //inverted start at 1
		}
		else
		{
			newAccolade.current_value = 0; //all other stats start at 0
		}	
				
		//special case for collectible accolade
		if( ( isdefined( strendswith( str_accolade, "COLLECTIBLE" ) ) && strendswith( str_accolade, "COLLECTIBLE" ) ) ) 
	    {
			newAccolade.current_value = GetAccoladeMapStatValue( s_accolade.index );
		}
		
		if( accolade_rewards_unlock_token( str_accolade ) )
		{
			newAccolade.gives_unlock_token = true;
		}
		
		newAccolade.award_xp = get_accolade_xp( str_accolade );
		
		self set_accolade( str_accolade, newAccolade );
	}
	
	/#
		self.accolades_dirty = true;
	#/
	
	self savegame::set_player_data( "last_mission", GetMissionName() );
	//self SaveCheckPointAccolades(); //overwrite the old checkpoint accolades
	
}

function check_collectibles_accolade()
{
	self endon( "disconnect" );
	
	while( true )
	{
		self waittill( "picked_up_collectible" );
		
		self AddAccoladeMapStatValue( level.accolades[ level.default_accolades_prefix + "COLLECTIBLE" ].index, 1 );
		self increment( level.default_accolades_prefix + "COLLECTIBLE" );
		//TODO: uncomment UploadStats( self );
	}
}

function check_damage_accolade()
{
	self endon( "disconnect" );
	
	while( true )
	{
		self waittill( "damage", damage, attacker );
		if( IsDefined( attacker ) && attacker.classname != "worldspawn" )
		{
			increment( level.default_accolades_prefix + "UNTOUCHED" );
			break;
		}
	}
}

function check_score_accolade()
{
	self endon( "disconnect" );
        
    last_score = self GetDStat( "PlayerStatsList", "SCORE", "statValue" );
	
	while( true )
	{
        wait 3.0;
        delta_score = self GetDStat( "PlayerStatsList", "SCORE", "statValue" ) - last_score;
        last_score = delta_score + last_score; //last_score
        if( delta_score != 0 )
        {
        	increment( level.default_accolades_prefix + "SCORE", delta_score, true );
        }
	}
}

	
// self == player
function on_player_connect()
{
	if( AccoladesDisabled() )
	{
		return;
	}
	/#
		if( IsDefined( level.accolades ) )
		{
			self.accolades_dirty = true;
			self devgui_init();
			self thread manage_accolades_gui();
		}
	#/

		return;
}

function on_player_spawned()
{
	if( self savegame::get_player_data( "last_mission" ) === GetMissionName() )
	{
		//should be the same mission as before
		foreach( str_accolade, s_accolade in level.accolades )
		{
			if( IsDefined( s_accolade.increment_notify ) )
			{
				self thread _increment_by_notify( str_accolade, s_accolade.increment_notify );
			}
		}
	}
	else
	{
		self _reset_incomplete_accolades();
	}
	
	self thread commit_checkpoint_accolades();
	self thread check_damage_accolade();
	self thread check_collectibles_accolade();
    self thread check_score_accolade();
}


function on_player_disconnect()
{
	foreach( str_accolade, s_accolade in level.accolades )
	{
		if( self GetAccoladeMapStatState( s_accolade.index ) == 1)
		{
			self SetAccoladeMapStatState( s_accolade.index, 2 );
		}
	}
	self savegame::set_player_data( "accolades", undefined );
	self savegame::set_player_data( "last_mission", "" );
	//save all stats?
}


/#
	
function manage_accolades_gui()
{
	self endon( "disconnect" );
	
	while( true )
	{
		//======= Handle debug increments
		cmd = GetDvarString( "scr_increment_accolade" );
		
		if( IsDefined( cmd ) && cmd != "" )
		{
			self debug_increment_accolade( Int( cmd ) );
		}
		
		if ( cmd != "" )
		{
			SetDvar( "scr_increment_accolade", "" );
		}
		
		//======= Manage debug ui
		if( self.accolades_dirty == true && IsDefined( self.accolades_text ) )
		{
			destroy_accolades_text();
		}
		if( GetDvarInt( "scr_show_accolades" ) > 0 )
		{
			self print_accolades();
		}
		else
		{
			self notify( "destroy_accolades" );
		}
		wait 1.0;
	}
}

function destroy_accolades_text_helper()
{
	self endon( "disconnect" );
	self waittill( "destroy_accolades" );
	
	destroy_accolades_text();
}

function destroy_accolades_text()
{
	if( IsDefined( self.accolades_text ) )
	{
		foreach( accolades_text in self.accolades_text )
		{
			accolades_text destroy();
		}
		foreach( accolades_count_text in self.accolades_count_text ) 
		{
			accolades_count_text destroy();
		}
		foreach( accolades_stat_text in self.accolades_stats_text )
		{
			accolades_stat_text destroy();
		}
		
		self.accolades_text = undefined;
		self.accolades_count_text = undefined;
		self.accolades_stats_text = undefined;
	}
}

function print_accolades()
{
	x = 0;
	y = 0;
	
	accolades_string = "";
	accolades_count_string = "";
	accolades_stats_string = "";
	
	if( !IsDefined( level.accolades  ) || IsDefined( self.accolades_text ) || !IsDefined( self savegame::get_player_data( "accolades" ) ) )
	{
		return;
	}
	
	self.accolades_text = [];
	self.accolades_count_text = [];
	self.accolades_stats_text = [];
	
	num_accolades = 0;
	
	accolades_text = NewClientHudElem( self );
	accolades_count_text = NewClientHudElem( self );
	accolades_stats_text = NewClientHudElem( self );
	
	foreach ( str_accolade, s_accolade in level.accolades )
	{
		if( num_accolades % 7 == 6 )
		{			
			accolades_text.x = x + 2;
			accolades_text.y = y + 2;
			accolades_text.alignX = "left";
			accolades_text.alignY = "top";
			accolades_text setText( accolades_string );
			accolades_text.hidewheninmenu = true;
			accolades_text.font = "default";
			accolades_text.foreground = true;
			
			accolades_count_text.x = x + 120;
			accolades_count_text.y = y + 2;
			accolades_count_text.alignX = "left";
			accolades_count_text.alignY = "top";
			accolades_count_text setText( accolades_count_string );
			accolades_count_text.hidewheninmenu = true;
			accolades_count_text.font = "default";
			accolades_count_text.foreground = true;
			
			accolades_stats_text.x = x + 180;
			accolades_stats_text.y = y + 2;
			accolades_stats_text.alignX = "left";
			accolades_stats_text.alignY = "top";
			accolades_stats_text setText( accolades_stats_string );
			accolades_stats_text.hidewheninmenu = true;
			accolades_stats_text.font = "default";
			accolades_stats_text.foreground = true;
			
			self.accolades_text[self.accolades_text.size] = accolades_text;
			self.accolades_count_text[self.accolades_count_text.size] = accolades_count_text;
			self.accolades_stats_text[ self.accolades_stats_text.size] = accolades_stats_text;
			
			accolades_text = NewClientHudElem( self );
			accolades_count_text = NewClientHudElem( self );
			accolades_stats_text = NewClientHudElem( self );
			
			y += 73;
			
			num_accolades = 1;
			
			accolades_string = str_accolade + "\n";
			
			accolades_count_string = self get_accolade( str_accolade ).current_value;
			if( ( isdefined( self get_accolade( str_accolade ).is_completed ) && self get_accolade( str_accolade ).is_completed ) )
			{
				accolades_count_string += " - Completed";
			}
			accolades_count_string += "\n";
			accolades_stats_string = self GetAccoladeMapStatValue( s_accolade.index ) + "\n";
		}
		else
		{
			accolades_string += str_accolade + "\n";
			
			accolades_count_string += self get_accolade( str_accolade ).current_value;
			if( ( isdefined( self get_accolade( str_accolade ).is_completed ) && self get_accolade( str_accolade ).is_completed ) )
			{
				accolades_count_string += " - Completed";
			}
			accolades_count_string += "\n";
			accolades_stats_string += self GetAccoladeMapStatValue( s_accolade.index ) + "\n";
			num_accolades++;
		} 
	}

	accolades_text.x = x + 2;
	accolades_text.y = y + 2;
	accolades_text.alignX = "left";
	accolades_text.alignY = "top";
	accolades_text setText( accolades_string );
	accolades_text.hidewheninmenu = true;
	accolades_text.font = "default";
	accolades_text.foreground = true;
	
	accolades_count_text.x = x + 120;
	accolades_count_text.y = y + 2;
	accolades_count_text.alignX = "left";
	accolades_count_text.alignY = "top";
	accolades_count_text setText( accolades_count_string );
	accolades_count_text.hidewheninmenu = true;
	accolades_count_text.font = "default";
	accolades_count_text.foreground = true;
	
	accolades_stats_text.x = x + 180;
	accolades_stats_text.y = y + 2;
	accolades_stats_text.alignX = "left";
	accolades_stats_text.alignY = "top";
	accolades_stats_text setText( accolades_stats_string );
	accolades_stats_text.hidewheninmenu = true;
	accolades_stats_text.font = "default";
	accolades_stats_text.foreground = true;

	self.accolades_text[self.accolades_text.size] = accolades_text;
	self.accolades_count_text[self.accolades_count_text.size] = accolades_count_text;
	self.accolades_stats_text[ self.accolades_stats_text.size] = accolades_stats_text;
	
	self thread destroy_accolades_text_helper();
	
	self.accolades_dirty = false;

}

function debug_increment_accolade( accolade_index )
{
	current_index = 0;
	foreach( str_accolade, s_accolade in level.accolades )
	{
		if( current_index == accolade_index )
		{
			self increment( str_accolade );
			break;
		}
		current_index++;
	}
}

function devgui_init()
{
	SetDvar( "scr_increment_accolade", "" );
	SetDvar( "scr_show_accolades", "0" );
	
	AddDebugCommand( "devgui_cmd \"Player/Accolades:2/Show Accolades\" \"toggle scr_show_accolades 0 1\"\n");
	for( i = 0; i < level.accolades.size; i++ )
	{
		AddDebugCommand( "devgui_cmd \"Player/Accolades:2/Increment accolade " + i + ":" + i + "\" \"set  scr_increment_accolade " + i + "\"\n" );
	}
	
}

#/

/@
"Name: updateDStats()"
"Summary: Updates the player's accolade stats."
"CallOn: level for all players, or on an individual player."
"Example: level accolades::updateDStats()"
@/
function updateDStats()
{
	if ( self == level )
	{
		foreach ( player in level.players )
		{		
			player updateDStats();
		}
	}
	else if ( IsArray( self savegame::get_player_data( "accolades" ) ) )
	{		
		foreach ( str_accolade, s_accolade in self savegame::get_player_data( "accolades" ) )
		{
			if( self GetAccoladeMapStatState( s_accolade.index ) == 2 )
			{
				continue; //no need to update
			}
			commit_value = s_accolade.current_value;
			if( IsDefined( s_accolade.previous_value ) )
			{
				commit_value = s_accolade.current_value - s_accolade.previous_value;
			}
			//need a special case for inverted accolades
			if( s_accolade.is_inverted )
			{
				self SetAccoladeMapStatValue( s_accolade.index, s_accolade.current_value );
			}
			else
			{
				self AddAccoladeMapStatValue( s_accolade.index, commit_value );
				s_accolade.previous_value = s_accolade.current_value;
			}
		}
	}
}

function commit_checkpoint_accolades()
{
	self endon( "disconnect" );
	
	while( true )
	{
		level waittill( "checkpoint_save" );
		self SaveCheckpointAccolades();
		UploadStats( self );
	}
}

function restore_checkpoint_accolades()
{
	self endon( "disconnect" );
	
	while( true )
	{
		self waittill( "save_restore" );

		if( is_beginning_of_mission() )
		{
			continue;
		}

	}
}

function commit()
{
	if( AccoladesDisabled() )
	{
		return;
	}
	
	if ( self == level )
	{
		foreach ( player in level.players )
		{		
			player commit();
		}
	}
	else if ( IsArray( self savegame::get_player_data( "accolades" ) ) )
	{	
		foreach( str_accolade, s_accolade in level.accolades )
		{
			accolade = self get_accolade( str_accolade );
			if( self GetAccoladeMapStatState( accolade.index ) != 0 )
			{
				continue;
			}
			if( _accolade_is_completed( str_accolade, accolade.current_value ) )
			{
				self SetAccoladeMapStatState( accolade.index, 1 );
				self SetAccoladeMapStatValue( accolade.index, accolade.current_value );
				if( ( isdefined( accolade.gives_unlock_token ) && accolade.gives_unlock_token ) )
				{
					self GiveUnlockToken( 1 );
				}
			}
		}
		//check score accolade
		//self updateDStats();
	}
}
