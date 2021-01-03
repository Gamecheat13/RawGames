#using scripts\shared\array_shared;
#using scripts\shared\system_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\cp\_objectives;
#using scripts\cp\gametypes\_save;
#using scripts\cp\_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     



	


#namespace collectibles;

#precache( "string", "COLLECTIBLE_DISCOVERED" );
#precache( "triggerstring", "COLLECTIBLE_PICK_UP" );

function autoexec __init__sytem__() {     system::register("collectibles",&__init__,&__main__,undefined);    }
	
function __init__() 
{
	level.mission_name = GetMissionName();
	level.map_name = GetRootMapName();
	level.collectible_params = [];
}

function __main__()
{
	level.collectibles = [];
	mdl_collectibles = GetEntArray( "collectible", "script_noteworthy" );
	if( mdl_collectibles.size == 0 )
	{
		return;
	}
	if( !CollectiblesDisabled() )
	{
		foreach( mdl_collectible in mdl_collectibles )
		{
			init_collectible( mdl_collectible );
		}
		
		callback::on_spawned( &on_player_spawned );
	}
	else
	{
		foreach( mdl_collectible in mdl_collectibles )
		{
			mdl_collectible hide();
		}
	}
}

/@
"Name: add_collectible_params( <collectible_model>, [radius], [offset] )"
"Summary: Sets the parameters ( radius, trigger offset ) for a collectible"
"CallOn: NA"
"MandatoryArg: <collectible_model> The name of the model for the collectible."
"OptionalArg: [radius] The radius of the collectible's trigger"
"OptionalArg: [offset] The offset of the collectible's trigger from the collectible's origin"
"Example: collectibles::add_collectible_params( "p7_nc_cai_inf_02", 80, ( 0, 2, 0 ) );
@/
function add_collectible_params( collectible_model, radius = 60, offset = ( 0, 0, 0 ) )
{
	if( !IsDefined( level.collectible_params[ collectible_model ] ) )
	{
		level.collectible_params[ collectible_model ] = SpawnStruct();
	}
	level.collectible_params[ collectible_model ].radius = radius;
	level.collectible_params[ collectible_model ].offset = offset;
}

function private CollectiblesDisabled()
{
	return ( ( isdefined( level.collectibles_disabled ) && level.collectibles_disabled ) || ( SessionModeIsCampaignZombiesGame() ) );
}

function on_player_spawned()
{
	if( !IsDefined( self.collectibles_discovered ) )
	{
		self.collectibles_discovered = [];
	}
		
	foreach( collectible in level.collectibles )
	{		
		if( self GetDStat( "PlayerStatsByMap", level.map_name, "collectibles", collectible.index ) )
		{
			self.collectibles_discovered[ collectible.mdl_collectible.model ] = true;
			collectible.mdl_collectible SetInvisibleToPlayer( self );
			Objective_SetInvisibleToPlayer( collectible.objectiveid, self );
			collectible.trigger SetInvisibleToPlayer( self );

			if( array::contains( level.mission_names, ToUpper( level.mission_name ) ) )
			{
				//self savegame::get_player_data( "MISSION_" + ToUpper(level.mission_name) + "_COLLECTIBLE" ).current_value += 1;
				//accolades should do this by themselves now
			}
		}
		else
		{
			self.collectibles_discovered[ collectible.mdl_collectible.model ] = false;
		}
	}
}
	
function check_if_player_is_touching( )
{
	while( true )
	{
		self.trigger_radius waittill( "trigger" );
		do
		{
			num_players_touching = 0;
			
			foreach( e_player in level.players )
			{
				if( isDefined( e_player.collectibles_discovered ) && !e_player.collectibles_discovered[ self.mdl_collectible.model ] )
		   		{	
					if( e_player isTouching( self.trigger ) )
					{
						num_players_touching++;
						vec_forward = AnglesToForward( e_player GetPlayerAngles() );
						vec_forward_2d = VectorNormalize( ( vec_forward[0], vec_forward[1], 0 ) );
	
						vec_to_collectible = self.mdl_collectible.origin - e_player.origin;
						vec_to_collectible_2d = VectorNormalize( (vec_to_collectible[0], vec_to_collectible[1], 0 ) );
					
						dot_product = VectorDot( vec_forward_2d, vec_to_collectible_2d );
					
						if( dot_product > 0.9 )
						{
							Objective_SetVisibleToPlayer( self.objectiveid, e_player );
							continue;
						}
					}
					Objective_SetInvisibleToPlayer( self.objectiveid, e_player );
				}
			}
			wait 0.25;
		} while( num_players_touching > 0 );
	}
}

function private get_collectible_params( mdl_collectible )
{
	mdl_collectible.radius = 60;
	mdl_collectible.offset = ( 0, 0, 5 ); //default offset is a few units above the collectible origin, because if it's origin is obscured by certain material types it can't be interacted with
	
	collectible_params = level.collectible_params[ mdl_collectible.model ];
	
	if( isDefined( collectible_params ) )
	{
		mdl_collectible.radius = collectible_params.radius;
		mdl_collectible.offset += collectible_params.offset;
	}
	
	return mdl_collectible;
}

function init_collectible( mdl_collectible )
{	
	mdl_collectible = get_collectible_params( mdl_collectible );
	
	trigger_use = Spawn( "trigger_radius_use", mdl_collectible.origin + mdl_collectible.offset, 0, mdl_collectible.radius, mdl_collectible.radius );
	trigger_use TriggerIgnoreTeam();
	trigger_use SetVisibleToAll();
	trigger_use SetTeamForTrigger( "none" );
	trigger_use SetCursorHint( "HINT_INTERACTIVE_PROMPT" );
	trigger_use SetHintString( &"COLLECTIBLE_PICK_UP" );
	
	trigger_radius = Spawn( "trigger_radius", mdl_collectible.origin + mdl_collectible.offset, 0, mdl_collectible.radius, mdl_collectible.radius );
	trigger_radius TriggerIgnoreTeam();
	trigger_radius SetVisibleToAll();
	trigger_radius SetTeamForTrigger( "none" );
	
	istring = iString( mdl_collectible.model );
	
	collectible_object = gameobjects::create_use_object( "any", trigger_use, Array( mdl_collectible ), ( 0, 0, 0 ), istring );
	collectible_object gameobjects::allow_use( "any" );
	collectible_object gameobjects::set_use_time( 0.5 );
	collectible_object gameobjects::set_owner_team( "allies" );
	collectible_object gameobjects::set_visible_team( "any" );
	collectible_object.mdl_collectible = mdl_collectible;

	collectible_object.onUse = &onUse;
	collectible_object.onBeginUse = &onBeginUse;
	collectible_object.single_use = true;

	collectible_object.origin = mdl_collectible.origin;
	collectible_object.angles = collectible_object.angles;
	collectible_object.trigger_radius = trigger_radius;
	
	collectible_object.index = Int( GetSubStr( mdl_collectible.model, mdl_collectible.model.size - 2 ) ) - 1;
	
	array::add( level.collectibles, collectible_object );
	
	Objective_SetInvisibleToAll( collectible_object.objectiveid );
	
	collectible_object thread check_if_player_is_touching();
}

function onUse(e_player )
{
	e_player.collectibles_discovered[ self.mdl_collectible.model ] = true;
	self.mdl_collectible SetInvisibleToPlayer( e_player );
	self gameobjects::hide_waypoint(e_player);
	Objective_SetInvisibleToPlayer( self.objectiveid, e_player );
	self.trigger SetInvisibleToPlayer( e_player );		
	
	if( MissionHasCollectibles( GetRootMapName() ) )
	{
		e_player SetDStat( "PlayerStatsByMap", level.map_name, "collectibles", self.index, 1 );
		e_player AddRankXPValue( "picked_up_collectible", 500 );
		//e_player GiveUnlockToken( 1 );
				
		UploadStats( e_player );
				
		e_player update_player_collectible_completion_status();	
	}

	util::show_event_message( e_player, istring( "COLLECTIBLE_DISCOVERED" ) );

	e_player playsoundtoplayer( "uin_collectible_pickup", e_player );
	
	e_player notify ( "picked_up_collectible" );
}

function onBeginUse( e_player )
{
}


function update_player_collectible_completion_status()
{
	Assert( IsPlayer( self ) );
	
	numCollectiblesCollected = 0;
	
	foreach( collectible in level.collectibles )
	{		
		if( self GetDStat( "PlayerStatsByMap", level.map_name, "collectibles", collectible.index ) )
		{
			numCollectiblesCollected++;
		}
	}
	
	if( numCollectiblesCollected == level.collectibles.size )
	{
		self SetDStat( "PlayerStatsByMap", level.map_name, "allCollectiblesCollected", 1 );
	}	
	
	if( self HasCollectedAllCollectibles() )
	{
		/#Println("Collectibles: Player " + self.entNum + " has collected all collectibles in the game" );#/
		self SetDStat( "PlayerStatsList", "ALL_COLLECTIBLES_COLLECTED", "statValue", 1 );			
		self GiveDecoration( "cp_medal_all_collectibles" );
	}	
}