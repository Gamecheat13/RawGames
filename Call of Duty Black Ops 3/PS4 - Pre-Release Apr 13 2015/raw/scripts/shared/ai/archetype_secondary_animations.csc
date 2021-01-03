#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;

                                                                                                             	   	
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  

// SUMEET TODO
// A very temp secondary (facial only currently) system for AI's.
// Need to make it data driven and support many things after DPS
// We can possibly use this system for any archetype to animate some bones which are 
// purely for cosmetic reasons.







	



	
function autoexec main()
{
	ai::add_archetype_spawn_function( "human", &SecondaryAnimationsInit );
}

function private SecondaryAnimationsInit( localClientNum )
{
	if( !IsDefined( level.__facialAnimationsList ) )
	{
		BuildAndValidateFacialAnimationList( localClientNum );
	}
	
	// Handle facial animations
	self thread SecondaryFacialAnimationThink( localClientNum );
}

function BuildAndValidateFacialAnimationList( localClientNum )
{
	assert( !IsDefined( level.__facialAnimationsList ) );
	
	level.__facialAnimationsList = [];
	
	level.__facialAnimationsList["combat"] 			= array( "ai_face_male_generic_idle_1","ai_face_male_generic_idle_2","ai_face_male_generic_idle_3" );
	level.__facialAnimationsList["combat_aim"] 		= array( "ai_face_male_aim_idle_1","ai_face_male_aim_idle_2","ai_face_male_aim_idle_3" );
	level.__facialAnimationsList["combat_shoot"] 	= array( "ai_face_male_aim_fire_1","ai_face_male_aim_fire_2","ai_face_male_aim_fire_3" );
	level.__facialAnimationsList["death"] 			= array( "ai_face_male_death_1","ai_face_male_death_2","ai_face_male_death_3" );	
	level.__facialAnimationsList["melee"] 			= array( "ai_face_male_melee_1" );	
	level.__facialAnimationsList["pain"] 			= array( "ai_face_male_pain_1" );	
		
	// validate death animations against looping flag
	deathAnims = level.__facialAnimationsList["death"];
	
	foreach( deathAnim in deathAnims )
	{
		assert( !IsAnimLooping( localClientNum, deathAnim ), "FACIAL ANIM - Death facial animation " + deathAnim + " is set to looping in the GDT. It needs to be non-looping." );
	}
}

function private SecondaryFacialAnimationThink( localClientNum )
{
	assert( IsDefined( self.archetype ) && self.archetype == "human" );
	
	self endon ("entityshutdown");
	
	self._currentFaceState 	= "inactive";
	
	while(1)
	{	
		if( self ASMGetStatus( localClientNum ) == "asm_status_terminated" )
		{
			ClearAllFacialAnims();
			break;
		}
		
		if( self ASMGetStatus( localClientNum ) == "asm_status_inactive" )
		{
			self._currentFaceState = "inactive";
			self ClearAllFacialAnims();
			
			wait 0.1;
			continue;
		}
		
		closestPlayer = array::get_closest( self.origin, level.localPlayers, 600 );
		
		if( !IsDefined( closestPlayer ) )
		{
			wait 0.1;
			continue;
		}
		
		currFaceState = self._currentFaceState;
		nextFaceState = self._currentFaceState;
		
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
		
		if(	self._currentFaceState == "inactive" || currFaceState != nextFaceState )
		{
			Assert( IsDefined( level.__facialAnimationsList[nextFaceState] ) );
			
			ApplyNewFaceAnim( array::random( level.__facialAnimationsList[nextFaceState] ) );
			self._currentFaceState = nextFaceState;
		}
		
		if( self._currentFaceState == "death" )
			break;
				
		wait 0.1;
	}
}

function private ApplyNewFaceAnim( animation )
{
	ClearAllFacialAnims();
	
	if( IsDefined( animation ) )
	{
		self._currentFaceAnim = animation;
		self SetFlaggedAnimKnob( "ai_secondary_facial_anim", animation, 1.0, 0.1, 1.0 );
	}
}

function private ClearAllFacialAnims()
{
	if( IsDefined( self._currentFaceAnim ) )
		self ClearAnim( self._currentFaceAnim, 0.2 );
}
