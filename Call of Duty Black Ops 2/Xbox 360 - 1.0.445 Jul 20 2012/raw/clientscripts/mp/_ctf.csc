#insert raw\maps\mp\_clientflags.gsh;

init()
{
	level._client_flag_callbacks["scriptmover"][CLIENT_FLAG_FLAG_AWAY] = ::setCTFAway;
}

setCTFAway( localClientNum, set )
{
	self SetFlagAsAway( localClientNum, set );
}