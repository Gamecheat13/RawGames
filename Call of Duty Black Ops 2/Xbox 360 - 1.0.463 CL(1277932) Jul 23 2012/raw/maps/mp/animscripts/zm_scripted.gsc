// Note that this script is called from the level script command animscripted, only for AI.  If animscripted 
// is done on a script model, this script is not called - startscriptedanim is called directly.

main()
{
	self endon ("death");
	self notify ("killanimscript");

	self endon ("end_sequence");

	if ( !IsDefined( self.codeScripted["animState"] ) )
	{
		return;
	}

	self StartScriptedAnim( self.codeScripted["origin"], self.codeScripted["angles"], self.codeScripted["animState"], self.codeScripted["animSubState"], self.codeScripted["AnimMode"] );

	self.a.script = "scripted";
	self.codeScripted = undefined;
	
	if (IsDefined (self.deathstring_passed))
	{
		self.deathstring = self.deathstring_passed;
	}

	self waittill("killanimscript");
}

init( origin, angles, animState, animSubState, AnimMode )
{
	self.codeScripted["origin"] = origin;
	self.codeScripted["angles"] = angles;
	self.codeScripted["animState"] = animState;
	self.codeScripted["animSubState"] = animSubState;

	if (IsDefined(AnimMode))
	{
		self.codeScripted["AnimMode"] = AnimMode;
	}
	else
	{
		self.codeScripted["AnimMode"] = "normal";
	}
}

//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------

end_script()
{
}