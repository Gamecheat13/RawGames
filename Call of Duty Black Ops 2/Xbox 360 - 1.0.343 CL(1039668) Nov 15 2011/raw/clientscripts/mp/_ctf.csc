init()
{
	level._client_flag_callbacks["scriptmover"][level.const_flag_flag_away] = ::setCTFAway;
}

setCTFAway( localClientNum, set )
{
	self SetFlagAsAway( localClientNum, set );
}