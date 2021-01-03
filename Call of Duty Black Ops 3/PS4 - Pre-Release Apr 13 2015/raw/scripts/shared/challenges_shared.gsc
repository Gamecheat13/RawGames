#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

// SUMEET TODO
// A very temp facial animation system for players for April 13th Demo.
// After the demo, I will be looking at adding mode support and make it data driven.

#namespace clientfaceanim;

function autoexec __init__sytem__() {     system::register("clientfaceanim_shared",undefined,&main,undefined);    }






	



	
function main()
{
	callback::on_spawned( &on_player_spawned );
	callback::on_shutdown( &on_player_shutdown );
}

function private on_player_spawned( localClientNum )
{	
	FacialAnimationsInit( localClientNum );
	
	// local player needs to handle the death as they dont get shutdown on death
	self thread on_player_death( localClientNum );
}

function private on_player_shutdown( localClientNum )
{	
	if( self IsPlayer() )
	{
		self notify("stopFacialThread");
					
		callback::remove_callback( #"on_entity_shutdown", &on_player_shutdown, level );
		
		corpse = self GetPlayerCorpse();
		if ( ( isdefined( corpse.facialDeathAnimStarted ) && corpse.facialDeathAnimStarted ) )
			return;
		
		corpse util::waittill_dobj( localClientNum );	
		corpse ApplyDeathAnim( localClientNum );	
		corpse.facialDeathAnimStarted = true;
	}
}

function private on_player_death( localClientNum )
{	
	self endon("entityshutdown");
	self waittill("death");
	
	if( self IsPlayer() )
	{
		self notify("stopFacialThread");
					
		corpse = self GetPlayerCorpse();
		if ( ( isdefined( corpse.facialDeathAnimStarted ) && corpse.facialDeathAnimStarted ) )
			return;
		
		corpse util::waittill_dobj( localClientNum );	
		corpse ApplyDeathAnim( localClientNum );	
		corpse.facialDeathAnimStarted = true;
	}
}

function private FacialAnimationsInit( localClientNum )
{
	BuildAndValidateFacialAnimationList( localClientNum );		
	
	if( self IsPlayer() )
	{
		self thread FacialAnimationThink( localClientNum );
	}
}

function BuildAndValidateFacialAnimationList( localClientNum )
{
	if( !IsDefined( level.__clientFacialAnimationsList ) )
	{
		level.__clientFacialAnimationsList = [];
		
		level.__clientFacialAnimationsList["combat"] 		= array( "ai_face_male_generic_idle_1","ai_face_male_generic_idle_2","ai_face_male_generic_idle_3" );
		level.__clientFacialAnimationsList["combat_shoot"] 	= array( "ai_face_male_aim_fire_1","ai_face_male_aim_fire_2","ai_face_male_aim_fire_3" );
		level.__clientFacialAnimationsList["death"] 			= array( "ai_face_male_death_1","ai_face_male_death_2","ai_face_male_death_3" );	
		level.__clientFacialAnimationsList["melee"] 			= array( "ai_face_male_melee_1" );	
		level.__clientFacialAnimationsList["pain"] 			= array( "ai_face_male_pain_1" );	
			
		// validate death animations against looping flag
		deathAnims = level.__clientFacialAnimationsList["death"];
		
		foreach( deathAnim in deathAnims )
		{
			assert( !IsAnimLooping( localClientNum, deathAnim ), "FACIAL ANIM - Death facial animation " + deathAnim + " is set to looping in the GDT. It needs to be non-looping." );
		}
	}
}

function private FacialAnimationThink( localClientNum )
{		
	self endon ("entityshutdown");
	self endon("stopFacialThread");
	
	// Facial animation only required to be initialized for one local client.
	if( IsDefined( self.__clientFacialAnimationsThinkStarted ) )
		return;
	
	self.__clientFacialAnimationsThinkStarted = true;
	
	assert( self IsPlayer() );
	
	self util::waittill_dobj( localClientNum );	
	
	while(1)
	{	
		UpdateFacialAnimForPlayer( localClientNum, self );
		wait 0.1;
	}
}

function private UpdateFacialAnimForPlayer( localClientNum, player )
{
	if( !IsDefined( player._currentFaceState ) )
		player._currentFaceState 	= "inactive";
	
	currFaceState = player._currentFaceState;
	nextFaceState = player._currentFaceState;
	
	if( player IsInScritpedAnim() )
	{
		ClearAllFacialAnims(localClientNum);
		
		player._currentFaceState = "inactive";
		return;
	}
				
	if( player IsPlayerDead() )
	{
		nextFaceState = "death";
	}
	else if( player IsPlayerFiring() )
	{
		nextFaceState = "combat_shoot";
	}
	else
	{
		nextFaceState = "combat";
	}
			
	if(	player._currentFaceState == "inactive" || currFaceState != nextFaceState )
	{
		Assert( IsDefined( level.__clientFacialAnimationsList[nextFaceState] ) );
		
		ApplyNewFaceAnim( localClientNum, array::random( level.__clientFacialAnimationsList[nextFaceState] ) );
		player._currentFaceState = nextFaceState;
	}		
}

function private ApplyNewFaceAnim( localClientNum, animation )
{
	ClearAllFacialAnims(localClientNum);
	
	if( IsDefined( animation ) )
	{
		self._currentFaceAnim = animation;
		self SetFlaggedAnimKnob( "ai_secondary_facial_anim", animation, 1.0, 0.1, 1.0 );
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
	if( IsDefined( self._currentFaceAnim ) && self hasdobj(localClientNum) )
	{
		self ClearAnim( self._currentFaceAnim, 0.2 );
	}
	self._currentFaceAnim = undefined;
}
