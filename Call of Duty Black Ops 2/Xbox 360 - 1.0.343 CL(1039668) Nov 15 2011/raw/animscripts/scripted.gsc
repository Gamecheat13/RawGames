// Note that this script is called from the level script command animscripted, only for AI.  If animscripted 
// is done on a script model, this script is not called - startscriptedanim is called directly.

#using_animtree ("generic_human");
main()
{
	//thread [[anim.println]]("Entering animscripts\\scripted. anim: ",self.codeScripted["anim"],",  notify: ",self.codeScripted["notifyName"],", dialogue: ",self.scripted_dialogue,", facial: ",self.facial_animation, "root: ", self.codeScripted["root"]);#/
	self endon ("death");
//	animscripts\utility::handleSuppressingEnemy();
//	wait (0);
	self notify ("killanimscript");
	self notify ("clearSuppressionAttack");
	self.a.suppressingEnemy = false;
	

	self.codeScripted["root"] = %body;	// TEMP!

    self trackScriptState( "Scripted Main", "code" );
	self endon ("end_sequence");

	self StartScriptedAnim(self.codeScripted["notifyName"], self.codeScripted["origin"], self.codeScripted["angles"], self.codeScripted["anim"], self.codeScripted["AnimMode"], self.codeScripted["root"], self.codeScripted["rate"], self.codeScripted["goalTime"], self.codeScripted["lerpTime"] );

	self.a.script = "scripted";
	self.codeScripted = undefined;
//	if (IsDefined (self.facial_animation))
//	{
//		self SetFlaggedAnimRestart("scripted_anim_facedone", self.facial_animation, 1, .1, 1);
//		self.facial_animation = undefined;
//	}
	if ( IsDefined (self.scripted_dialogue) || IsDefined (self.facial_animation) )
	{
		self animscripts\face::SaySpecificDialogue(self.facial_animation, self.scripted_dialogue, 0.9, "scripted_anim_facedone");
		self.facial_animation = undefined;
		self.scripted_dialogue = undefined;
	}

	if (IsDefined (self.deathstring_passed))
	{
		self.deathstring = self.deathstring_passed;
	}

	self waittill("killanimscript");
}

#using_animtree ("generic_human");
init(notifyName, origin, angles, theAnim, AnimMode, root, rate, goalTime, lerpTime)
{
	self.codeScripted["notifyName"] = notifyName;
	self.codeScripted["origin"] = origin;
	self.codeScripted["angles"] = angles;
	self.codeScripted["anim"] = theAnim;

	if (IsDefined(AnimMode))
	{
		self.codeScripted["AnimMode"] = AnimMode;
	}
	else
	{
		self.codeScripted["AnimMode"] = "normal";
	}

	if (IsDefined(root))
	{
		self.codeScripted["root"] = root;
	}
	else
	{
		self.codeScripted["root"] = %body;
	}

	self.codeScripted["rate"] = rate;

	if (IsDefined(goalTime))
	{
		self.codeScripted["goalTime"] = goalTime;
	}
	else
	{
		self.codeScripted["goalTime"] = 0.2;
	}
	
	if( IsDefined( lerpTime ) )
	{
		self.codeScripted["lerpTime"] = lerpTime;
	}
	else
	{
		self.codeScripted["lerpTime"] = 0.0;
	}
}

//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------

end_script()
{
}