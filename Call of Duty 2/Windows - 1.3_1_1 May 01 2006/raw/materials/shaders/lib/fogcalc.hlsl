#if defined( FOG_EXP )
static const bool useExpFog = true;
#else
static const bool useExpFog = false;
#endif

#if defined( FOG_LINEAR )
static const bool useLinearFog = true;
#else
static const bool useLinearFog = false;
#endif

static const bool useRadialFog = true;

// array indices into the 'fogConsts' global
#define FOG_LINEAR_SCALE	0
#define FOG_LINEAR_SHIFT	1
#define FOG_EXPONENT		2


float Fog_LinearFactor( float fogDist )
{
	return fogDist * fogConsts[FOG_LINEAR_SCALE] + fogConsts[FOG_LINEAR_SHIFT];
}


float Fog_ExponentialFactor( float fogDist )
{
	return exp( fogDist * fogConsts[FOG_EXPONENT] );
}


float Fog_RadialDist( float3 posInEyeSpace )
{
	return length( posInEyeSpace );
}


float Fog_ForwardDist( float3 posInEyeSpace )
{
	return posInEyeSpace.z;
}


float Fog_VertexFactor( const VertexInput vertex )
{
	float3	posInEyeSpace;
	float	fogDist;
	float	fogFactor;

	posInEyeSpace = Transform_ObjectToView( vertex.position );
	if ( useRadialFog )
		fogDist = Fog_RadialDist( posInEyeSpace );
	else
		fogDist = Fog_ForwardDist( posInEyeSpace );

	if ( useExpFog )
		return Fog_ExponentialFactor( fogDist );
	else
		return Fog_LinearFactor( fogDist );
}
