// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	a[0] = "shanty_civ_body_1a";
	a[1] = "shanty_civ_body_1b";
	a[2] = "shanty_civ_body_1c";
	a[3] = "shanty_civ_body_3a";
	a[4] = "shanty_civ_body_3blue";
	a[5] = "shanty_civ_body_3navy";
	a[6] = "shanty_civ_body_3red";
	a[7] = "shanty_civ_body_3tan";
	a[8] = "shanty_civ_body_5blue";
	a[9] = "shanty_civ_body_5green";
	a[10] = "shanty_civ_body_5lime";
	a[11] = "shanty_civ_body_5olive";
	a[12] = "shanty_civ_body_5orange";
	a[13] = "shanty_civ_body_5pink";
	a[14] = "shanty_civ_body_5tan";
	a[15] = "shanty_civ_body_5yellow";
	return a;
}


getnextmodel()
{
	if( !isdefined( level.nextXModel ) )
	{
		level.nextXModel = [];
	}

	if( !isdefined( level.nextXModel["shanty_civ_bodies_Body"] ) )
	{
		startIndex = randomint(16);
		level.nextXModel["shanty_civ_bodies_Body"] = startIndex;
	}
	index = level.nextXModel["shanty_civ_bodies_Body"];
	level.nextXModel["shanty_civ_bodies_Body"] = index+1;

	if( level.nextXModel["shanty_civ_bodies_Body"] >= 16 )
		level.nextXModel["shanty_civ_bodies_Body"] = 0;

	if( (index >= 16) || (index < 0))
		index = randomint(16);

	a = main();
	return a[ index ];
}