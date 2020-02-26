#include animscripts\anims;
#include animscripts\Utility;
#include animscripts\SetPoseMovement;
#include animscripts\Combat_utility;
#include maps\_anim;
#include maps\_utility;

#using_animtree ("generic_human");

flashBangAnim()
{
	self endon( "killanimscript" );
	self SetFlaggedAnimKnobAll( "flashed_anim", animArrayPickRandom("flashed"), %body );
	self animscripts\shared::DoNoteTracks( "flashed_anim" );
}

main()
{
	self endon( "killanimscript" );

	animscripts\utility::initialize("flashed");

	if ( self.a.pose == "prone" )
	{
		self ExitProneWrapper(1);
	}

	self.a.pose = "stand";
	
	self startFlashBanged();

	self animscripts\face::SayGenericDialogue("flashbang");
	self.allowdeath = true;
	
	if ( IsDefined( self.flashedanim ) )
	{
		self SetAnimKnobAll( self.flashedanim, %body );
	}
	else //if ( self.a.pose == "stand" ) // we have to play *something*, even if we're crouched
	{
		self thread flashBangAnim();
	}
	
	for(;;)
	{
		time = GetTime();
		
		if ( time > self.flashendtime )
		{
			self notify("stop_flashbang_effect");
			self SetFlashBanged( false );
			self.flashed = false;
			break;
		}

		wait(0.05);	
	}
}


//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------

end_script()
{
}