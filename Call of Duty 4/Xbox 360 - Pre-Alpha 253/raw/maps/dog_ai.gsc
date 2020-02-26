#include maps\_utility;
#include common_scripts\utility;


main()
{
	maps\_load::main();
	
	array_thread( getaispeciesarray( "allies" ), ::think_allies );
	array_thread( getaispeciesarray( "axis" ), ::think_axis );

	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
}


think_allies()
{
	//self delete();
	self.goalradius = 2048;
	//self thread magic_bullet_shield();
}


think_axis()
{
	self.goalradius = 2048;
	//self.goalradius = 30;
	//self thread magic_bullet_shield();
}