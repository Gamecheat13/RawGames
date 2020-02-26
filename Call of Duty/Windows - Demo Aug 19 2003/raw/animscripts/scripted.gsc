// Note that this script is called from the level script command animscripted, only for AI.  If animscripted 
// is done on a script model, this script is not called - startscriptedanim is called directly.

#using_animtree ("generic_human");
main()
{
	[[anim.println]]("Entering animscripts\\scripted. anim: ",self.codeScripted["anim"],",  notify: ",self.codeScripted["notifyName"],", dialogue: ",self.scripted_dialogue,", facial: ",self.facial_animation, "root: ", self.codeScripted["root"]);
	self.codeScripted["root"] = %body;

    self trackScriptState( "Scripted Main", "code" );
	self endon ("end_sequence");
	self startscriptedanim(self.codeScripted["notifyName"], self.codeScripted["origin"], self.codeScripted["angles"], self.codeScripted["anim"], self.codeScripted["animMode"], self.codeScripted["root"]);

	self.anim_script = "scripted";
	self.codeScripted = undefined;
//	if (isdefined (self.facial_animation))
//	{
//		self SetFlaggedAnimRestart("scripted_anim_facedone", self.facial_animation, 1, .1, 1);
//		self.facial_animation = undefined;
//	}
	if ( isdefined (self.scripted_dialogue) || isdefined (self.facial_animation) )
	{
		self animscripts\face::SaySpecificDialogue(self.facial_animation, self.scripted_dialogue, 0.9, "scripted_anim_facedone");
		self.facial_animation = undefined;
		self.scripted_dialogue = undefined;
	}

	if (isdefined (self.deathstring_passed))
		self.deathstring = self.deathstring_passed;

	self waittill("killanimscript");
	[[anim.println]]("Finished animscripts\\scripted.");
}

#using_animtree ("generic_human");
init(notifyName, origin, angles, theAnim, animMode, root)
{
	if (isDefined(root))
		[[anim.println]]("scripted::init: root is defined!");
	else
		[[anim.println]]("scripted::init: root is not defined!");
	self.codeScripted["notifyName"] = notifyName;
	self.codeScripted["origin"] = origin;
	self.codeScripted["angles"] = angles;
	self.codeScripted["anim"] = theAnim;
	if (isDefined(animMode))
		self.codeScripted["animMode"] = animMode;
	else
		self.codeScripted["animMode"] = "normal";
	if (isDefined(root))
		self.codeScripted["root"] = root;
	else
		self.codeScripted["root"] = %body;
}
