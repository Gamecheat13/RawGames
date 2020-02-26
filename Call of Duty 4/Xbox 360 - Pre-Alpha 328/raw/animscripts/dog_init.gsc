#using_animtree( "dog" );

main()
{
	self useAnimTree( #animtree );
	
	initDogAnimations();
	animscripts\init::firstInit();
	
	self.ignoreSuppression = true;
	
	self.chatInitialized = false;
	self.noDodgeMove = true;
	self.root_anim = %root;

	self.meleeAttackDist = 0;
	self thread setMeleeAttackDist();

	self.a = spawnStruct();
	self.a.pose = "stand";					// to use DoNoteTracks()
	self.a.nextStandingHitDying = false;	// to allow dogs to use bullet shield
	self.a.movement = "run";

	animscripts\init::set_anim_playback_rate();

	self.suppressionThreshold = 1;
	self.disableArrivals = false;
	self.stopAnimDistSq = anim.dogStoppingDistSq;

	self thread animscripts\combat_utility::monitorFlash();

	self.pathEnemyFightDist = 512;
	self setTalkToSpecies( "dog" );
	
	if ( isdefined( level.gameskill ) )
		gameskill = level.gameskill;
	else
		gameskill = getdvarint( "g_gameskill" );
	
	switch( gameskill )
	{
	case 0:		
		self.health = int( self.health / 4 );
		self.hitsBeforeKillingBlow = 2;		
		break;
		
	case 1:		
		self.health = int( self.health / 2 );
		self.hitsBeforeKillingBlow = 1;		
		break;
		
	default:	
		self.hitsBeforeKillingBlow = 0;		
		break;
	}
}


setMeleeAttackDist()
{
	self endon( "death" );

	while ( 1 )
	{
		if ( isdefined( self.enemy ) && self.enemy == level.player )
			self.meleeAttackDist = anim.dogAttackPlayerDist;
		else
			self.meleeAttackDist = anim.dogAttackAIDist;

		self waittill( "enemy" );
	}
}


initDogAnimations()
{
	// Initialization that should happen once per level
	if ( isDefined( anim.NotFirstTimeDogs ) )// Use this to trigger the first init
		return;
	
	anim.NotFirstTimeDogs = 1;
	anim.dogStoppingDistSq = lengthSquared( getmovedelta( %german_shepherd_run_stop, 0, 1 ) * 1.2 ) ;
	anim.dogStartMoveDist = length( getmovedelta( %german_shepherd_run_start, 0, 1 ) );
	
	// notetime = getNotetrackTimes( %german_shepherd_attack_player, "dog_melee" );
	// anim.dogAttackPlayerDist = length( getmovedelta( %german_shepherd_attack_player, 0, notetime[ 0 ] ) );
	anim.dogAttackPlayerDist = 102;// hard code for now, above is not accurate.

	offset = getstartorigin( ( 0, 0, 0 ), ( 0, 0, 0 ), %german_shepherd_attack_AI_01_start_a );
	anim.dogAttackAIDist = length( offset );
	
	anim.dogTraverseAnims = [];
	anim.dogTraverseAnims[ "wallhop" ]			 = %german_shepherd_run_jump_40;
	anim.dogTraverseAnims[ "jump_down_40" ]		 = %german_shepherd_traverse_down_40;
	anim.dogTraverseAnims[ "jump_up_40" ]		 = %german_shepherd_traverse_up_40;
	anim.dogTraverseAnims[ "jump_up_80" ]		 = %german_shepherd_traverse_up_80;

	// Dog start move animations
	// number indexes correspond to keyboard number directions
	anim.dogStartMoveAngles[8] = 0;
	anim.dogStartMoveAngles[6] = 90;
	anim.dogStartMoveAngles[4] = -90;
	anim.dogStartMoveAngles[3] = 180;
	anim.dogStartMoveAngles[1] = -180;
	
	anim.dogStartMoveAnim[8] = %german_shepherd_run_start;
	anim.dogStartMoveAnim[6] = %german_shepherd_run_start_L;
	anim.dogStartMoveAnim[4] = %german_shepherd_run_start_R;
	anim.dogStartMoveAnim[3] = %german_shepherd_run_start_180_L;
	anim.dogStartMoveAnim[1] = %german_shepherd_run_start_180_R;

	// effects used by dog
	level._effect[ "dog_bite_blood" ] = loadfx( "impacts/deathfx_dogbite" );
	level._effect[ "deathfx_bloodpool" ] = loadfx( "impacts/deathfx_bloodpool_view" );
	
	// setup random timings for dogs attacking the player
	slices = 5;
	array = [];
	for ( i = 0; i <= slices; i++ )
	{
		array[ array.size ] = i / slices;
	}
	level.dog_melee_index = 0;
	level.dog_melee_timing_array = maps\_utility::array_randomize( array );
	
	setdvar( "friendlySaveFromDog", "1" );
}
