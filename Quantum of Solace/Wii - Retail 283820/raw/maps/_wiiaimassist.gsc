init_aimassist()
{
	

	if( useAimAssist() )
	{
		setDVar( "wii_use_bondeye", true );
	}
	else
	{
		setDVar( "wii_use_bondeye", false );
	}
	
	level.loadoutComplete = true;
	level notify ("AA complete");	
}

useAimAssist()
{
	
	if ( level.script == "constructionsite" || level.script == "casino_poison" )
	{
		return false;
	}
	
	return true;
}