// _createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
	level.player = GetEntArray( "player", "classname" )[0]; 
	if ( IsUsingHDR() )
	{
		maps\createart\fusion_fog_hdr::main();
	}
	else
	{
		maps\createart\fusion_fog::main();
	}

}
