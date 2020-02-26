#using_animtree ("dog");

main()
{
	self endon("killanimscript");

	if ( isdefined( self.enemy ) && isdefined( self.enemy.attacker ) && self.enemy.attacker == self )
		self.enemy.attacker = undefined;

	self clearanim(%root, 0.2);
	self setflaggedanimrestart("dog_anim", %german_shepherd_death_front, 1, 0.2, 1);
	self waittillmatch( "dog_anim", "end" );
}
