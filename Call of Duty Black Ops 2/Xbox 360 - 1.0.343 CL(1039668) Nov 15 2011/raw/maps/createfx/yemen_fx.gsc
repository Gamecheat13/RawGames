//_createfx generated. Do not touch!!
main()
{
// CreateFX entities placed: 2
     	ent = maps\_utility::createOneshotEffect( "fx_smk_fire_md_black" );
     	ent.v[ "origin" ] = ( -578.684, 1675.02, -0.875 );
     	ent.v[ "angles" ] = ( 270, 0, 0 );
     	ent.v[ "type" ] = "oneshotfx";
     	ent.v[ "fxid" ] = "fx_smk_fire_md_black";
     	ent.v[ "delay" ] = -15;
 
     	ent = maps\_utility::createExploder( "fx_bridge_explosion01" );
     	ent.v[ "origin" ] = ( -9227.35, -13658.5, 768.125 );
     	ent.v[ "angles" ] = ( 0, 0, 0 );
     	ent.v[ "type" ] = "exploder";
     	ent.v[ "fxid" ] = "fx_bridge_explosion01";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "exploder" ] = 750;
 
}
