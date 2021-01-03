#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\callbacks_shared;

                                                                                                             	     	                                                                                                                                                                
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                              	         	    	                                                                                                   
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

// SUMEET TODO
// A very temp secondary (facial only currently) system for AI's.
// Need to make it data driven and support many things after DPS
// We can possibly use this system for any archetype to animate some bones which are 
// purely for cosmetic reasons.







	




#using_animtree( "generic" );

function autoexec main()
{
	ai::add_archetype_spawn_function( "human", &SecondaryAnimationsInit );
	ai::add_archetype_spawn_function( "zombie", &SecondaryAnimationsInit );	

	ai::add_ai_spawn_function( &on_entity_spawn );
}

function private SecondaryAnimationsInit( localClientNum )
{
	if( !IsDefined( level.__facialAnimationsList ) )
	{
		BuildAndValidateFacialAnimationList( localClientNum );
	}
	
	self callback::on_shutdown( &on_entity_shutdown );

	// Handle facial animations
	self thread SecondaryFacialAnimationThink( localClientNum );
}

function private on_entity_spawn( localClientNum )
{
	if ( self HasDObj( localClientNum ) )
	{
		self ClearAnim( %faces, 0 );	// stale facial anims from the previous entity may still be running
	}
	self._currentFaceState = "inactive";
}

function private on_entity_shutdown( localClientNum )
{	
	if( isdefined( self ) )
	{
		self notify("stopFacialThread");
	
		if ( ( isdefined( self.facialDeathAnimStarted ) && self.facialDeathAnimStarted ) )
			return;

		self ApplyDeathAnim( localClientNum );	
		self.facialDeathAnimStarted = true;
	}
}

function BuildAndValidateFacialAnimationList( localClientNum )
{
	assert( !IsDefined( level.__facialAnimationsList ) );
	
	level.__facialAnimationsList = [];
	
	// HUMANS
	level.__facialAnimationsList["human"] = [];
	level.__facialAnimationsList["human"]["combat"] 			= array( "ai_face_male_generic_idle_1","ai_face_male_generic_idle_2","ai_face_male_generic_idle_3" );
	level.__facialAnimationsList["human"]["combat_aim"] 		= array( "ai_face_male_aim_idle_1","ai_face_male_aim_idle_2","ai_face_male_aim_idle_3" );
	level.__facialAnimationsList["human"]["combat_shoot"] 	= array( "ai_face_male_aim_fire_1","ai_face_male_aim_fire_2","ai_face_male_aim_fire_3" );
	level.__facialAnimationsList["human"]["death"] 			= array( "ai_face_male_death_1","ai_face_male_death_2","ai_face_male_death_3" );
	level.__facialAnimationsList["human"]["melee"] 			= array( "ai_face_male_melee_1" );
	level.__facialAnimationsList["human"]["pain"] 			= array( "ai_face_male_pain_1" );
		
	// ZOMBIES
	level.__facialAnimationsList["zombie"] = [];
	level.__facialAnimationsList["zombie"]["combat"] 		= array( "ai_face_zombie_generic_idle_1" );
	level.__facialAnimationsList["zombie"]["combat_aim"] 	= array( "ai_face_zombie_generic_idle_1" );
	level.__facialAnimationsList["zombie"]["combat_shoot"] 	= array( "ai_face_zombie_generic_idle_1" );
	level.__facialAnimationsList["zombie"]["death"] 			= array( "ai_face_zombie_generic_death_1" );
	level.__facialAnimationsList["zombie"]["melee"] 			= array( "ai_face_zombie_generic_attack_1" );
	level.__facialAnimationsList["zombie"]["pain"] 			= array( "ai_face_zombie_generic_pain_1" );
	
	
	// validate death animations against looping flag
	deathAnims = [];
	
	foreach( animation in level.__facialAnimationsList["human"]["death"] )
	{
		array::add( deathAnims, animation );
	}
	
	foreach( animation in level.__facialAnimationsList["zombie"]["death"] )
	{
		array::add( deathAnims, animation );
	}
	
	foreach( deathAnim in deathAnims )
	{
		assert( !IsAnimLooping( localClientNum, deathAnim ), "FACIAL ANIM - Death facial animation " + deathAnim + " is set to looping in the GDT. It needs to be non-looping." );
	}
}

function private SecondaryFacialAnimationThink( localClientNum )
{
	assert( IsDefined( self.archetype ) && ( self.archetype == "human" || self.archetype == "zombie" ) );
	
	self endon ("entityshutdown");
	self endon ("stopFacialThread");
	
	self._currentFaceState 	= "inactive";
	
	while(1)
	{	
		switch(self ASMGetStatus( localClientNum ))
		{
		case "asm_status_terminated":
			ClearAllFacialAnims(localClientNum);
			return;
		case "asm_status_inactive":
			self._currentFaceState = "inactive";
			self ClearAllFacialAnims(localClientNum);
			
			wait 0.1;
			continue;
		}
		
		closestPlayer = ArrayGetClosest( self.origin, level.localPlayers, GetDvarInt( "ai_clientFacialCullDist", 2000 ) );
		
		if( !IsDefined( closestPlayer ) )
		{
			wait 0.1;
			continue;
		}
		
		if( !self HasDObj(localClientNum) || !self HasAnimTree() )
		{
			wait 0.1;
			continue;
		}
		
		currFaceState = self._currentFaceState;
		currentASMState = ToLower( self ASMGetCurrentState( localClientNum ) );
		
		if( self ASMIsTerminating( localClientNum ) )
		{
			nextFaceState = "death";
		}
		else if( IsDefined( currentASMState ) && IsSubStr( currentASMState, "pain" ) )
		{
			nextFaceState = "pain";
		}
		else if( IsDefined( currentASMState ) && IsSubStr( currentASMState, "melee" ) )
		{
			nextFaceState = "melee";
		}
		else if( self ASMIsShootLayerActive( localClientNum ) )
		{
			nextFaceState = "combat_shoot";
		}
		else if( self ASMIsAimLayerActive( localClientNum ) )
		{
			nextFaceState = "combat_aim";
		}
		else
		{
			nextFaceState = "combat";
		}
		
		if(	currFaceState == "inactive" || currFaceState != nextFaceState )
		{
			Assert( IsDefined( level.__facialAnimationsList[self.archetype][nextFaceState] ) );
			
			clearOnCompletion = false;
			
			if( nextFaceState == "death" )
			{
				clearOnCompletion = true;
			}
			
			ApplyNewFaceAnim( localClientNum, array::random( level.__facialAnimationsList[self.archetype][nextFaceState] ), clearOnCompletion );
			self._currentFaceState = nextFaceState;
		}
		
		if( self._currentFaceState == "death" )
			break;
				
		wait 0.1;
	}
}

function private ApplyNewFaceAnim( localClientNum, animation, clearOnCompletion = false )
{
	ClearAllFacialAnims(localClientNum);
	
	if( IsDefined( animation ) )
	{
		self._currentFaceAnim = animation;
		
		if( self HasDObj(localClientNum) && self HasAnimTree() )
		{
			self SetFlaggedAnimKnob( "ai_secondary_facial_anim", animation, 1.0, 0.1, 1.0 );
		
			if( clearOnCompletion )
			{
				wait( GetAnimLength( animation ) );
				ClearAllFacialAnims(localClientNum);
			}
		}
	}
}

function private ApplyDeathAnim( localClientNum )
{
	if( IsDefined( self._currentFaceState ) && self._currentFaceState == "death" )
		return;
	
	if( IsDefined( self ) && IsDefined( level.__clientFacialAnimationsList ) && IsDefined( level.__clientFacialAnimationsList["death"] ) )
	{
		self._currentFaceState = "death";
		ApplyNewFaceAnim( localClientNum, array::random( level.__clientFacialAnimationsList["death"] ) );
	}
}

function private ClearAllFacialAnims(localClientNum)
{
	if( IsDefined( self._currentFaceAnim ) && self HasDObj(localClientNum) && self HasAnimTree() )
	{
		self ClearAnim( self._currentFaceAnim, 0.2 );
	}
	
	self._currentFaceAnim = undefined;
}
