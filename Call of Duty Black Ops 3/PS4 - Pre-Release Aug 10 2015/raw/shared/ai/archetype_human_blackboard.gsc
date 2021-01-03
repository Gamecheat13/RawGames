#using scripts\shared\array_shared;

#using scripts\shared\ai_shared;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_locomotion_utility;

           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
                                                                  	                             	  	                                      
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace Blackboard;

//*****************************************************************************
// NOTE! When adding a new blackboard variable you must also declare the 
// blackboard variable within the ast_definitions file found at:
//
// //t7/main/game/share/raw/animtables/ast_definitions.json
//
// This allows the Animation Selector Table system to determine how to create
// queries based on the blackboard variable.
//
// Also, all blackboard values must be lowercased! No convert to lower is
// perform when assigning values to the blackboard.
//
//*****************************************************************************
function RegisterActorBlackBoardAttributes()
{
	Blackboard::RegisterBlackBoardAttribute(self,"_tactical_arrival_facing_yaw",undefined,&BB_GetTacticalArrivalFacingYaw);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_tactical_arrival_facing_yaw");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_human_locomotion_movement_type",undefined,&BB_GetLocomotionMovementType);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_human_locomotion_movement_type");#/    }; 
	Blackboard::RegisterBlackBoardAttribute(self,"_human_cover_flankability",undefined,&BB_GetCoverFlankability);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_human_cover_flankability");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_arrival_type",undefined,&BB_GetArrivalType);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_arrival_type");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_human_locomotion_variation",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_human_locomotion_variation");#/    };
}

function private BB_GetArrivalType()
{
	if( self ai::get_behavior_attribute( "disablearrivals" ) )
		return "dont_arrive_at_goal";
	
	return "arrive_at_goal";
}

function private BB_GetTacticalArrivalFacingYaw()
{
	return AngleClamp180( self.angles[ 1 ] - self.node.angles[ 1 ] );
}

function private BB_GetLocomotionMovementType()
{	
	if ( !ai::GetAiAttribute( self, "disablesprint" ) )
	{
		// if the script interface needs sprinting
		if ( ai::GetAiAttribute( self, "sprint" ) )
		{
			return "human_locomotion_movement_sprint";
		}
			
		// should sprint if too far away from enemy
		if ( IsDefined( self.enemy ) && IsDefined( self.runAndGunDist ) )
		{
			if ( DistanceSquared( self.origin, self LastKnownPos( self.enemy ) ) 
			   > self.runAndGunDist * self.runAndGunDist )
			{
				return "human_locomotion_movement_sprint";
			}
		}
		else if ( IsDefined( self.goalpos ) && IsDefined( self.runAndGunDist ) )
		{
			if ( DistanceSquared( self.origin, self.goalpos ) 
			   > self.runAndGunDist * self.runAndGunDist )
			{
				return "human_locomotion_movement_sprint";
			}
		}
	}
	
	return "human_locomotion_movement_default";
}

function private BB_GetCoverFlankability()
{
	if( self ASMIsTransitionRunning() )
	{
		return "unflankable";
	}
	
	if( !IsDefined( self.node ) )
	{
		return "unflankable";
	}
			
	coverMode = Blackboard::GetBlackBoardAttribute( self, "_cover_mode" );
				
	if( IsDefined( coverMode ) )
	{			
		coverNode = self.node;
		
		if( coverMode == "cover_alert" || coverMode == "cover_mode_none" )
		{
			return "flankable";
		}
		
		if( (coverNode.type == "Cover Pillar") )
		{
			return ( coverMode == "cover_blind" );
		}
		else if( (coverNode.type == "Cover Left") || (coverNode.type == "Cover Right") )			
		{
			return ( coverMode == "cover_blind" || coverMode == "cover_over" );
		}
		else if( (coverNode.type == "Cover Stand" || coverNode.type == "Conceal Stand") || (coverNode.type == "Cover Crouch" || coverNode.type == "Cover Crouch Window" || coverNode.type == "Conceal Crouch" ) )
		{
			return "flankable";
		}				
	}

	return "unflankable";
}
