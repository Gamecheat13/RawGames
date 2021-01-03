#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

                                                                                                             	     	                                                                                                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     






	



#namespace AiSquads;

function autoexec __init__sytem__() {     system::register("ai_squads",&__init__,undefined,undefined);    }

function __init__()
{	
	level._squads = [];
	
	actorSpawnerArray = GetActorSpawnerTeamArray( "axis" );
	array::run_all( actorSpawnerArray, &spawner::add_spawn_function, &SquadMemberThink ); 
}
	
// ------- AI SQUAD -----------//	
class Squad
{
	var squadLeader;
	var squadMembers;
	var squadBreadCrumb;
		
	constructor()
	{
		squadLeader = 0;
		squadMembers = [];
		squadBreadCrumb = [];		
	}
	
	function addSquadBreadCrumbs( ai )
	{
		assert( squadLeader == ai );
			
		if( Distance2DSquared( squadBreadCrumb, ai.origin ) >= 96 * 96 )
		{
			/# RecordCircle( ai.origin, 4, ( 0, 0, 1 ), "Animscript", ai ); #/	
			squadBreadCrumb = ai.origin;		
		}
	}
	
	function getSquadBreadCrumb()
	{
		return squadBreadCrumb;
	}
	
	function GetLeader()
	{
		return squadLeader;
	}
	
	function GetMembers()
	{
		return squadMembers;
	}
		
	function AddAIToSquad( ai )
	{
		if( !IsInArray( squadMembers, ai ) )
		{
			// TEMP : Turn off other behaviors of the robot, to make sure that he will respect and follow the squad
			if( ai.archetype == "robot" )
			{
				ai ai::set_behavior_attribute( "move_mode", "squadmember" );
			}
			
			squadMembers[squadMembers.size] = ai;
		}
	}
	
	function RemoveAIFromSqaud( ai )
	{
		if( IsInArray( squadMembers, ai ) )
		{
			ArrayRemoveValue( squadMembers, ai, false );
			
			if( squadLeader === ai )
			{
				squadLeader = undefined;
			}
		}
	}
		
	function Think()
	{
		// update squad leader - pick the first one in the squadMembers list
		// remove the squad if no one is left
		if( (IsInt(squadLeader) && squadLeader == 0) || !IsDefined( squadLeader ) )
		{
			if( squadMembers.size > 0 )
			{
				squadLeader = squadMembers[0];				
				squadBreadCrumb = squadLeader.origin;
			}
			else
			{				
				return false;
			}			
		}	
		
		return true;
	}
}

function private CreateSquad( squadName )
{
	level._squads[squadName] = new Squad();	
	return level._squads[squadName];
}

function private RemoveSquad( squadName )
{
	if( IsDefined( level._squads ) && IsDefined( level._squads[squadName] ) )
	{
		level._squads[squadName] = undefined;
	}
}

function private GetSquad( squadName )
{
	return level._squads[squadName];
}

function private ThinkSquad( squadName )
{	
	while(1)
	{
		if( [[ level._squads[squadName] ]]->Think() )
		{
			wait 0.5;
		}
		else 
		{
			RemoveSquad( squadName );
			break;
		}
	}
}

function private SquadMemberDeath()
{
	self waittill( "death" );
	
	if( IsDefined( self.squadName ) && IsDefined( level._squads[self.squadName] ) )
	{
		[[ level._squads[self.squadName] ]]->RemoveAIFromSqaud( self );
	}
}

function private SquadMemberThink()
{
	self endon("death");
	
	if( !IsDefined( self.script_aisquadname ) )
		return;
	
	// wait for other ai systems to initialize
	wait 0.5;
	
	// Assign the squad name
	self.squadName = self.script_aisquadname;
		
	if( IsDefined( self.squadName ) )
	{
		// Create squad if it does not exist, then create it 
		if( !IsDefined( level._squads[self.squadName] ) )
		{
			squad = CreateSquad( self.squadName );
			newSquadCreated = true;
		}
		else
		{
			squad = GetSquad( self.squadName );
		}
		
		// Add this AI as a member of the squad
		[[squad]]->AddAIToSquad( self );
		
		// Handle the death of the sqaudMember and remove him from squad
		self thread SquadMemberDeath();
		
		// start ticking this squad
		if( ( isdefined( newSquadCreated ) && newSquadCreated ) )
		{
			level thread ThinkSquad( self.squadName );
		}
		
		// Keep updating and following the leader of the squad
		while(1)
		{			
			squadLeader = [[ level._squads[self.squadName] ]]->GetLeader();
			
			if( IsDefined( squadLeader ) && !(IsInt(squadLeader) && squadLeader == 0) )
			{
				if( squadLeader == self )
				{
					/# RecordEntText( self.squadName + ": LEADER", self, ( 0, 1, 0 ), "Animscript" ); #/
					/# RecordEntText( self.squadName + ": LEADER", self, ( 0, 1, 0 ), "Animscript" ); #/
					/# RecordCircle( self.origin, 300, ( 1, .5, 0 ), "Animscript", self ); #/	

					if( IsDefined( self.enemy ) )
					{
						self SetGoal( self.enemy );
					}
										
					[[squad]]->addSquadBreadCrumbs( self );										
				}
				else
				{
					/# RecordLine( self.origin, squadLeader.origin, ( 0, 1, 0 ), "Animscript", self ); #/
					/# RecordEntText( self.squadName+ ": FOLLOWER", self, ( 0, 1, 0 ), "Animscript" ); #/
					
					followPosition = [[squad]]->getSquadBreadCrumb();
					followDistSq = Distance2DSquared( self.goalPos, followPosition );
					
					if( IsDefined( squadLeader.enemy ) )
					{
						if( !IsDefined( self.enemy ) || ( IsDefined( self.enemy ) && self.enemy != squadLeader.enemy ) )
							self SetEntityTarget( squadLeader.enemy, 1 );
					}
					
					if( IsDefined( self.goalPos ) && followDistSq >= 16 * 16 )
					{
						if( followDistSq >= 150 * 150 )
						{
							self ai::set_behavior_attribute( "sprint", true );
						}
						else
						{
							self ai::set_behavior_attribute( "sprint", false );
						}
						
						self SetGoal( followPosition, true );
					}					
				}				
			}
			
			wait 1;
		}
	}
}

// ------- UTILITY -----------//
function isFollowingSquadLeader( ai )
{
	if( ai ai::get_behavior_attribute( "move_mode" ) != "squadmember" )
	{
		return false;
	}
	
	squadMember = isSquadMember( ai );
	currentSquadLeader = getSquadLeader( ai ) ;
	isAISquadLeader = IsDefined( currentSquadLeader ) && currentSquadLeader == ai;
	
	if( squadMember && !isAISquadLeader )
	{
		return true; 
	}
	
	return false;	
}

function isSquadMember( ai )
{
	if( IsDefined( ai.squadName ) )
	{
		squad = GetSquad( ai.squadName );
		
		if( IsDefined( squad ) )
		{
			return IsInArray( [[squad]]->GetMembers(), ai );
		}
	}
	
	return false;
}

function isSquadLeader( ai )
{
	if( IsDefined( ai.squadName ) )
	{
		squad = GetSquad( ai.squadName );
		
		if( IsDefined( squad ) )
		{
			squadLeader = [[squad]]->GetLeader();
			
			return IsDefined( squadLeader ) && squadLeader == ai;
		}
	}
	
	return false;
}

function getSquadLeader( ai )
{
	if( IsDefined( ai.squadName ) )
	{
		squad = GetSquad( ai.squadName );
		
		if( IsDefined( squad ) )
		{
			return [[squad]]->GetLeader();
		}
	}
	
	return undefined;
}