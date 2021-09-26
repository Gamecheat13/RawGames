main()
{
	level._effect["mortar"]					= loadfx ("fx/impacts/dirthit_mortar.efx");
	level._effectType["mortar"]				= "mortar";
	
	level._effect["artillery"]				= loadfx ("fx/impacts/largemortar_dirt3.efx");
	level._effectType["artillery"]			= "artillery";
	
	level._effect["bomb"]					= loadfx ("fx/impacts/largemortar_dirt3.efx");
	level._effectType["bomb"]				= "bomb";

	level.mortar 							= level._effect["mortar"];	 

	level._effect["mortar_impact"]			= level._effect["mortar"];
	level._effectType["mortar_impact"]		= level._effectType["mortar"];

	level._effect["german flare"]			= loadfx ("fx/smoke/flare.efx");
	level._effectDuration["german flare"]	= 20;	
}