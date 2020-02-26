#include clientscripts\mp\_utility; 
#include clientscripts\mp\_fx;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\_filter;

init()
{
	if ( GetDvar( "createfx" ) == "on" )
	{
		return;
	}

	level._CLIENTFLAG_PLAYER_TURNED_VISIONSET = 4;

	register_clientflag_callback("player",level._CLIENTFLAG_PLAYER_TURNED_VISIONSET,::zombie_turned_visionset);
	//thread apply_turned_visionsets();

	
	//init_filter_hud_outline( self );

	//const n_filter_index = 0;
	//const n_amount = 120;
	//set_filter_hud_outline_reveal_amount( self, n_filter_index, n_amount );


}

apply_turned_visionsets()
{
	waitforallclients();

	players = GetLocalPlayers();
	for (i = 0; i<players.size; i++)
		players[i] thread player_apply_turned_visionsets();
}

player_apply_turned_visionsets()
{
	  	

}

zombie_turned_visionset(localClientNum, set, newEnt)
{

	if(!self isLocalPlayer() )
	{
		return;
	}

	if(!isDefined(self GetLocalClientNumber() ))
	{
		return;
	}
	if(isDefined(self.zombie_turned_visionset_on) && self.zombie_turned_visionset_on==set)
	{
		return;
	}

	
	lcn = (self GetLocalClientNumber()!=0); 
//name = self.script_friendname;
//if (!IsDefined(name)) name = "";
	if(set)
	{
//println("EOVISION zombie_turned "+name+" "+lcn+" \n");
		prev = GetVisionSetNaked(lcn);
		if (prev != "zombie_turned")
			self.zombie_turned_previous_visionset = prev; 
		VisionSetNaked( lcn, "zombie_turned", 2.0 );

		if ( !IsSplitscreen() )
		{
			set_filter_hud_outline_reveal_amount( self, 0, 120 );
			enable_filter_hud_outline( self, 0, 0 );
    		self SetSonarAttachmentEnabled( true );
		}
	}
	else
	{
//println("EOVISION "+self.zombie_turned_previous_visionset+" "+name+" "+lcn+" \n");
		if (isdefined(self.zombie_turned_previous_visionset))
			VisionSetNaked( lcn, self.zombie_turned_previous_visionset, 1.0 );
		else
			VisionSetNaked( lcn, "zm_meat", 1.0 );

		if ( !IsSplitscreen() )
		{
			set_filter_hud_outline_reveal_amount( self, 0, 120 );
			disable_filter_hud_outline( self, 0, 0 );
    		self SetSonarAttachmentEnabled( false );
		}
	}
	self.zombie_turned_visionset_on=set;
}

