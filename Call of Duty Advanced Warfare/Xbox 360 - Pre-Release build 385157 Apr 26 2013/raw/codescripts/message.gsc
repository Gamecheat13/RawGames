/*================
Called by code when we recieve an instant message
================*/
CodeCallback_HandleInstantMessage( message )
{
	if( isdefined( level.globalInstantMessageHandler ) )
	{
		[[level.globalInstantMessageHandler]]( message );
	}
	else
		IPrintLnBold("no level handler for: " + message );
}