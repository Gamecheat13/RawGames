// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	a[0] = "lc_thug_2_body_blueshirt_casino";
	a[1] = "lc_thug_2_body_casino";
	a[2] = "lc_thug_2_body_redshirt_casino";
	a[3] = "lc_thug_2_body_pinkshirt_casino";
	a[4] = "lc_thug_2_body_yellowshirt_casino";
	a[5] = "lc_thug_2_body_greyshirt_casino";
	return a;
}


getnextmodel()
{
	if( !isdefined( level.nextXModel ) )
	{
		level.nextXModel = [];
	}

	if( !isdefined( level.nextXModel["lc_thug_bodies_casino_Body"] ) )
	{
		startIndex = randomint(6);
		level.nextXModel["lc_thug_bodies_casino_Body"] = startIndex;
	}
	index = level.nextXModel["lc_thug_bodies_casino_Body"];
	level.nextXModel["lc_thug_bodies_casino_Body"] = index+1;

	if( level.nextXModel["lc_thug_bodies_casino_Body"] >= 6 )
		level.nextXModel["lc_thug_bodies_casino_Body"] = 0;

	if( (index >= 6) || (index < 0))
		index = randomint(6);

	a = main();
	return a[ index ];
}