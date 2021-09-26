#ifndef USE_FLOAT_Z
#error "USE_FLOAT_Z must be defined"
#endif

#include "globals.hlsl"

float4 distortionScale;

struct VertexInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
	float3 tangent : TEXCOORD1;
	float3 binormal : TEXCOORD2;
};


struct PixelInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
	float4 tangent : TEXCOORD1;
	float4 binormal : TEXCOORD2;
	float4 worldPos : TEXCOORD3;
#if USE_FLOAT_Z
	float distance : TEXCOORD4;
#endif
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "transform.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel = (PixelInput)0;

	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.color = vertex.color;
	pixel.texCoords = vertex.texCoords;
	pixel.worldPos = Transform_ClipSpacePosToTexCoords( pixel.position );

	// Similarly, the normalMapSampler returns values (du,dv) in the range [0, 1] that need to be expanded to the range [-a, a].
	// This can be done by (du,dv)' = (du,dv) * 2a - a.
	// du and dv are multiplied by tangent and binormal then added to worldPos, so the scale factors can be baked into those.
	pixel.tangent = distortionScale.x * float4( 1.0, -1.0, 1.0, 1.0 ) * clipSpaceLookupScale * Transform_ObjectToClip( float4( vertex.tangent, 0 ) );
	pixel.binormal = -distortionScale.y * float4( 1.0, -1.0, 1.0, 1.0 ) * clipSpaceLookupScale * Transform_ObjectToClip( float4( vertex.binormal, 0 ) );

#if USE_FLOAT_Z
	pixel.distance = pixel.position.z;
#else
	pixel.worldPos -= pixel.tangent + pixel.binormal;
	pixel.tangent *= 2;
	pixel.binormal *= 2;
#endif

	return pixel;
}


half4 DistortionSample( const PixelInput pixel )
{
	half2 distortion;
	float4 offsetPos;
	half4 screenSampleOffset;
	half4 screenSampleWorld;
	half4 screenSample;
	float screenDepthOffset;

#if USE_FLOAT_Z

	distortion = tex2D( normalMapSampler, pixel.texCoords ).xy * 2 - 1;
	offsetPos = pixel.worldPos + distortion.x * pixel.tangent + distortion.y * pixel.binormal;
	screenSampleOffset = tex2Dproj( colorMapSampler, offsetPos );
	screenSampleWorld = tex2Dproj( colorMapSampler, pixel.worldPos );
	screenDepthOffset = tex2Dproj( floatZSampler, offsetPos ).r;
	return (screenDepthOffset < pixel.distance) ? screenSampleWorld : screenSampleOffset;

#else // #if USE_FLOAT_Z

	distortion = tex2D( normalMapSampler, pixel.texCoords ).xy;
	offsetPos = pixel.worldPos + distortion.x * pixel.tangent + distortion.y * pixel.binormal;
	return tex2Dproj( colorMapSampler, offsetPos );

#endif // #else // #if USE_FLOAT_Z
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput	fragment;

	half4 distortion;
	half4 screenSample;

	distortion = tex2D( normalMapSampler, pixel.texCoords );
	screenSample = DistortionSample( pixel );

	fragment.color.rgb = pixel.color.rgb * screenSample.rgb;
	fragment.color.a = pixel.color.a * distortion.a;

	return fragment;
}
