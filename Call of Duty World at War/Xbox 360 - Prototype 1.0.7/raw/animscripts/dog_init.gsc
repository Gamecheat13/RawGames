#using_animtree ("dog");

main()
{
	self useAnimTree( #animtree );
	self.ignoreSuppression = true;
	
	self.chatInitialized = false;
	self.noDodgeMove = true;

	self.meleeAttackDist = 0;
	self thread setMeleeAttackDist();

	// hack to get around script assert for now	
	wait 1;
	self.pathEnemyFightDist = 200; //self.meleeAttackDist; 
	
	// to use DoNoteTracks()
	self.a = spawnStruct();
	self.a.pose = "stand";
}


setMeleeAttackDist()
{
	self endon( "death" );

	while ( 1 )
	{		
		self waittill( "enemy" );
		if ( isdefined( self.enemy ) && self.enemy == level.player )
			self.meleeAttackDist = anim.dogAttackPlayerDist;
		else
			self.meleeAttackDist = anim.dogAttackAIDist;
	}
}


initDogAnimations()
{
	anim.dogStoppingDist = length( getmovedelta( %german_shepherd_run_stop, 0, 1 ) );
	
	anim.dogAttackPlayerDist = length( getmovedelta( %german_shepherd_run_attack, 0, 1 ) );
	offset = getstartorigin( (0, 0, 0), (0, 0, 0), %german_shepherd_attack_AI_01_start_a );
	
	anim.dogAttackAIDist = length( offset );
}