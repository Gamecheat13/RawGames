#include "globals.hlsl"

#define USE_DETAIL		0

#ifdef PIXEL_FOG
#define	FOGVAR texCoordsAndDist.w
typedef float4 tcdType;
#else
#define	FOGVAR fog
typedef float3 tcdType;
#endif

struct VertexInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
};


struct PixelInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	tcdType texCoordsAndDist : TEXCOORD0;	
	float4 screenCoords : TEXCOORD1;

#if OUTDOOR
	float3 outdoorMapPos : TEXCOORD3;
#endif

#if USE_FOG && !defined( PIXEL_FOG )
	float fog : FOG_SEMANTIC;
#endif
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "transform.hlsl"
#include "fog.hlsl"
#include "shade.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel = (PixelInput)0;
	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.texCoordsAndDist.xy = vertex.texCoords;
	
	pixel.color = vertex.color;
	Fog_VertexCalc( vertex, pixel );
	
	pixel.texCoordsAndDist.z = pixel.position.z * featherParms.x;

	// near-camera attenuation	
	pixel.color.a *= saturate( pixel.texCoordsAndDist.z );

	pixel.screenCoords = Transform_ClipSpacePosToTexCoords( pixel.position );

#if OUTDOOR
	pixel.outdoorMapPos = mul( vertex.position, worldOutdoorLookupMatrix );
#endif

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;
	half4 diffuse;
	float dist, diff;

	dist = tex2Dproj( floatZSampler, pixel.screenCoords ).r;	
	diff = dist * featherParms.x - pixel.texCoordsAndDist.z;

	diffuse = TexturedDiffuse( pixel.texCoordsAndDist.xy );

	fragment.color.rgba = pixel.color * diffuse;
	fragment.color.a *= saturate( abs( diff ) );

#if OUTDOOR
	float outdoorDiff;
	outdoorDiff = pixel.outdoorMapPos.z - tex2D( outdoorMapSampler, pixel.outdoorMapPos ).r;
	fragment.color.a *= saturate( outdoorDiff * outdoorFeatherParms.x );
#endif
	
	Fog_PixelCalc( pixel, fragment );
	
	return fragment;
}
