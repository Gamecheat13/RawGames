#include common_scripts\utility;
#include maps\_utility;

main()
{
/#
	SetDvar( "MAR_inuse", 0 );
	SetDvar( "MAR_P", (0,0,0) );
	SetDvar( "MAR_A", (0,0,0) );
	SetDvar( "MAR_Node", "" );
	SetDvar( "MAR_ViewModel", 0 );

	level.player thread start_mocap_ar();	
#/
}

start_mocap_ar()
{
/#
	SetDvar( "MAR_inuse", 0 );
	//wait for transmission to start.
	while(( GetDvarInt( "MAR_inuse" ) == 0 ) || ( !isAlive ( self ) ) )
	{
		//IPrintLn("Waiting");
		wait 0.1;
	}
	start_node_name = ( GetDvar( "MAR_Node" ));
	//start_origin_node = null;
	//if (start_node_name != "")
	//{
		start_origin_node = getstruct( ( GetDvar( "MAR_Node" ) ), "script_noteworthy" );
	//}
		
	start_pos = self.origin;
	start_angles = self.angles;
	start_pos += (0,0,0);
	//start_angles = (0,0,0);
	mocap_ar_ent = Spawn( "script_model", start_pos );
	mocap_ar_ent SetModel( "tag_origin" );
	mocap_ar_ent.angles = self GetPlayerAngles();

	player_ent = Spawn( "script_model", start_pos );
	player_ent.angles = mocap_ar_ent.angles;
	player_ent SetModel( "tag_origin" );
 	player_ent LinkTo( mocap_ar_ent, "tag_player", ( 0, 0, -60 ), ( 0, 0, 0 ));
	self PlayerLinkToDelta( player_ent, "tag_origin", 1.0, 0, 0, 0, 0, 1 );

	if ( GetDvarInt( "MAR_ViewModel" ) == 1 )
	{
		self DisableWeapons();
		self DisableOffhandWeapons();	
		self HideViewModel();	
	}
	else
	{
		self giveWeapon("iw5_m4_mp");
		self SwitchToWeapon("iw5_m4_mp");
		self GiveMaxAmmo("iw5_m4_mp");
	}
	
	self AllowCrouch( false);
	self AllowProne( false );
	self AllowSprint( false );
	//self AllowAds( false );

	while( ( GetDvarInt( "MAR_inuse" ) == 1 ) && ( isAlive( self ) ) )
	{
		//IPrintLn( "Streaming" );
		mocapPos =  GetDvarVector( "MAR_P" , (0, 0, 0) );
		mocap_ar_ent.origin = mocapPos;
		mocap_ar_ent.angles = GetDvarVector( "MAR_A" , (0, 0, 0) );
		//keep ammo unlimited
		if ( GetDvarInt( "MAR_ViewModel" ) == 0 )
		{
			self GiveMaxAmmo("iw5_m4_mp");
		}
		//mocap_ar_ent.origin += (0,0,-72);
		if ( isdefined( start_origin_node ) )
		{
			mocap_ar_ent.origin += start_origin_node.origin;
		}
		else
		{
			mocap_ar_ent.origin += GetDvarVector( "MAR_O" , (0, 0, 0) );
		}
		wait 0.05;
	}
	
	player_ent unlink();
	mocap_ar_ent unlink();
	mocap_ar_ent delete();

	self.origin = start_pos;
	self.angles = start_angles;

	self enableweapons();
	self enableoffhandweapons();
	self showviewmodel();

	self AllowCrouch( true );
	self AllowProne( true );
	self AllowSprint( true );
	//self AllowAds( true );
	
	//if the player died, wait for him to come back to life
	while ( !isAlive( self ) )
	{
		//IPrintLn("Waiting fo respawn...");
		wait 0.1;
	}
	
	//Set Dvar back to 0
	SetDvar( "MAR_inuse", 0 );
	//restart waiting.
	self thread start_mocap_ar();
#/
}