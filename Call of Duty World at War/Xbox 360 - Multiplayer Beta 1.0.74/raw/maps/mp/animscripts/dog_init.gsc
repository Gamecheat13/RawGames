//#using_animtree ("dog");
#include maps\mp\animscripts\shared;
#include maps\mp\animscripts\utility;

main()
{
	level.dog_debug_orient = 0;
	level.dog_debug_anims = 0;
	level.dog_debug_anims_ent = 0;
	level.dog_debug_turns = 0;
	
	debug_anim_print("dog_init::main() " );
	
	firstInit();

	maps\mp\animscripts\dog_move::setup_sound_variables();
	
	anim_get_dvar_int("debug_dog_sound","0");
	anim_get_dvar_int("debug_dog_notetracks","0");
	
	self.ignoreSuppression = true;
	
	self.chatInitialized = false;
	self.noDodgeMove = true;

	//notetime = getNotetrackTimes( %german_shepherd_attack_player, "dog_melee" );
	//anim.dogAttackPlayerDist = length( getmovedelta( %german_shepherd_attack_player, 0, notetime[0] ) );
	level.dogAttackPlayerDist = 102; // hard code for now, above is not accurate.
	level.dogAttackPlayerCloseRangeDist = 50; 

	level.dogTurnAroundAngle = 135;  // if the turn delta is greater then this it will play the 180 anim
	level.dogTurnAngle = 70; // if the turn delta is greater then this it will play the 90 anim
	level.dogRunTurnSpeed = 20; // if the speed is greater then play the run turns
	level.dogRunPainSpeed = 20; // if the speed is greater then play the run pains
	level.dogTurnMinDistanceToGoal = 40; // if the distance to goal is under this then no turn anims play

	self.meleeAttackDist = 0;
	self thread setMeleeAttackDist();

	self.a = spawnStruct();
	self.a.pose = "stand";					// to use DoNoteTracks()
	self.a.nextStandingHitDying = false;	// to allow dogs to use bullet shield
	self.a.movement = "run";

	set_anim_playback_rate();
	
	self.suppressionThreshold = 1;
	self.disableArrivals = false;
	
	//anim.dogStoppingDistSq = lengthSquared( getmovedelta( %german_shepherd_run_stop, 0, 1 ) * 1.2 ) ;
	
	// need to do the getmovedelta.  took this value from sp
	level.dogStoppingDistSq = 3416.82;
	self.stopAnimDistSq = level.dogStoppingDistSq;

	self.pathEnemyFightDist = 512;

	self setTalkToSpecies( "dog" );

	//self.health = int( anim.dog_health * self.health );

	// effects used by dog
//	level._effect[ "dog_bite_blood" ] = loadfx( "impacts/fx_deathfx_bloodpool_view" );
//	level._effect[ "deathfx_bloodpool" ] = loadfx( "impacts/fx_deathfx_dogbite" );
	
	// setup random timings for dogs attacking the player
////	slices = 5;
////	array = [];
////	for ( i = 0; i <= slices; i++ )
////	{
////		array[ array.size ] = i / slices;
////	}
////	level.dog_melee_index = 0;
////	level.dog_melee_timing_array = maps\mp\_utility::array_randomize( array );
	
	level.lastDogMeleePlayerTime = 0;
	level.dogMeleePlayerCounter = 0;

	if ( !isdefined( level.dog_hits_before_kill ) )
		level.dog_hits_before_kill = 1;
}

firstInit()
{
	level.lastPlayerSighted = 100;
}

set_anim_playback_rate()
{
	self.animplaybackrate = 0.9 + randomfloat( 0.2 );
	self.moveplaybackrate = 1; 
}

setMeleeAttackDist()
{
	self endon( "death" );

	while ( 1 )
	{
		if ( isdefined( self.enemy ) )
		{
			
			if ( isplayer(self.enemy) )
			{
				stance = self.enemy getStance();
				
				if ( stance == "prone" )
				{
					self.meleeAttackDist = level.dogAttackPlayerCloseRangeDist;
				}				
				else
				{
					self.meleeAttackDist = level.dogAttackPlayerDist;
				}
			}
			else
			{
				self.meleeAttackDist = level.dogAttackPlayerDist;
			}
		}

		wait(1);
		//self waittill( "enemy" );
	}
}