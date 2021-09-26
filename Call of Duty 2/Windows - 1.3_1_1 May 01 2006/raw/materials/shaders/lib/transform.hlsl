float4 Transform_ObjectToWorld( float4 objectSpacePosition )
{
	return mul( objectSpacePosition, worldMatrix );
}


float4 Transform_ObjectToView( float4 objectSpacePosition )
{
	return mul( objectSpacePosition, worldViewMatrix );
}


float4 Transform_ObjectToClip( float4 objectSpacePosition )
{
	return mul( objectSpacePosition, worldViewProjectionMatrix );
}


float4 Transform_WorldToView( float4 worldSpacePosition )
{
	return mul( worldSpacePosition, viewMatrix );
}


float4 Transform_WorldToClip( float4 worldSpacePosition )
{
	return mul( worldSpacePosition, viewProjectionMatrix );
}


float4 Transform_ViewToClip( float4 viewSpacePosition )
{
	return mul( viewSpacePosition, projectionMatrix );
}


float3 Transform_Dir_ObjectToWorld( float3 objectSpaceDir )
{
	return mul( objectSpaceDir, inverseTransposeWorldMatrix );
}


float3 Transform_Dir_ObjectToView( float3 objectSpaceDir )
{
	return mul( objectSpaceDir, inverseTransposeWorldViewMatrix );
}


float3 Transform_Dir_ObjectToClip( float3 objectSpaceDir )
{
	return mul( objectSpaceDir, inverseTransposeWorldViewProjectionMatrix );
}


float3 Transform_Dir_WorldToView( float3 worldSpaceDir )
{
	return mul( worldSpaceDir, inverseTransposeViewMatrix );
}


float3 Transform_Dir_WorldToClip( float3 worldSpaceDir )
{
	return mul( worldSpaceDir, inverseTransposeViewProjectionMatrix );
}


float3 Transform_Dir_ViewToClip( float3 viewSpaceDir )
{
	return mul( viewSpaceDir, inverseTransposeProjectionMatrix );
}


float3 Transform_Normal_WorldToTangent( const float3x3 tangentSpaceMatrix, const float3 worldDirection )
{
	float3x3	worldDirToLocalDir;
	float3		localDirection;
	
	worldDirToLocalDir = transpose( mul( tangentSpaceMatrix, worldMatrix ) );
	localDirection = mul( worldDirection, worldDirToLocalDir );
	return localDirection;
}


float4 Transform_ClipSpacePosToTexCoords( float4 position )
{
	return position * clipSpaceLookupScale + position.w * clipSpaceLookupOffset;
}
