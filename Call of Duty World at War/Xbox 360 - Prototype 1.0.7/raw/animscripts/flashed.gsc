#include animscripts\Utility;
#include animscripts\SetPoseMovement;
#include animscripts\Combat_utility;
#include maps\_anim;
#include maps\_utility;
#using_animtree ("generic_human");


set_standing_flashed_array()
{
	array = [];

	array["stand_flash1"] = %exposed_flashbang_v1;
	array["stand_flash2"] = %exposed_flashbang_v2;
	array["stand_flash3"] = %exposed_flashbang_v3;
	array["stand_flash4"] = %exposed_flashbang_v4;
	array["stand_flash5"] = %exposed_flashbang_v5;
	if(self.a.pose == "prone")
		self ExitProneWrapper(1);
	self.a.pose = "stand";

	self.a.array = array;
}

main()
{
	self endon( "killanimscript" );
	if( isdefined( self.script_immunetoflash ) && self.script_immunetoflash != 0 )
		return; 
	// we only have animations for exposed stand right now	
	self set_standing_flashed_array();
	
	percent = self getFlashBangedStrength();
	if(!isdefined(self.flashduration))
		duration = 4500 * percent;
	else
		duration = self.flashduration;
	self.flashendtime = gettime() + duration;
	self set_battlechatter( false );
	self.allowdeath = true;
	
	if(isdefined(self.flashedanim))
	{	
		self setanimknoball(self.flashedanim,%body);
	}
	else
	{
		if(self.a.pose == "stand")
		{
			num = (1 + randomint(5));

			self setflaggedanimknoball("anim",self.a.array["stand_flash" + num],%body);
			self animscripts\shared::DoNoteTracks("anim");
		}
	}
	for(;;)
	{
		time = gettime();
		
		if(time > self.flashendtime)
		{
			self notify("stop_flashbang_effect");
			self setFlashBanged( false );
			self.flashed = false;
			break;
		}
		wait(0.05);	
	}
}
