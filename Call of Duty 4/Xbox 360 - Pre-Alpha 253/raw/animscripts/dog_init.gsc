#using_animtree ("dog");

main()
{
	self useAnimTree( #animtree );
	
	initDogAnimations();
	
	self.ignoreSuppression = true;
	
	self.chatInitialized = false;
	self.noDodgeMove = true;

	self.meleeAttackDist = 0;
	self thread setMeleeAttackDist();

	self.a = spawnStruct();
	self.a.pose = "stand";					// to use DoNoteTracks()
	self.a.nextStandingHitDying = false;	// to allow dogs to use bullet shield

	self.suppressionThreshold = 1;
	self.stopAnimDistSq = anim.dogStoppingDistSq;

	// hack to get around script assert for now	
	self endon( "death" );
	wait 1;
	self.pathEnemyFightDist = 200; //self.meleeAttackDist; 
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
	if ( isDefined (anim.NotFirstTimeDogs) ) // Use this to trigger the first init
		return;
	
	anim.NotFirstTimeDogs = 1;
	anim.dogStoppingDistSq = lengthSquared( getmovedelta( %german_shepherd_run_stop, 0, 1 ) ) / 2;	// TEMP cut off animation earlier, delta is too big right now
	
	//notetime = getNotetrackTimes( %german_shepherd_attack_player, "dog_melee" );
	//anim.dogAttackPlayerDist = length( getmovedelta( %german_shepherd_attack_player, 0, notetime[0] ) );
	anim.dogAttackPlayerDist = 102; // hard code for now, above is not accurate.

	offset = getstartorigin( (0, 0, 0), (0, 0, 0), %german_shepherd_attack_AI_01_start_a );
	anim.dogAttackAIDist = length( offset );
	
	anim.dogTraverseAnims = [];
	anim.dogTraverseAnims["wallhop"]		= %german_shepherd_run_jump_40;
	anim.dogTraverseAnims["jump_down_40"]	= %german_shepherd_traverse_down_40;
	anim.dogTraverseAnims["jump_up_40"]		= %german_shepherd_traverse_up_40;

	animscripts\dog_combat::PlayerView_Precache();
}