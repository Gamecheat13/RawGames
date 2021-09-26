#include "globals.hlsl"

float4 particleParms;

struct VertexInput
{
	float4 position : POSITION;
	float2 texCoords : TEXCOORD0;
};


struct VertexOutput
{
	float4 position : POSITION;
	float2 texCoords : TEXCOORD0;
#if OUTDOOR
	float3 outdoorMapPos : TEXCOORD1;
#endif
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "transform.hlsl"


VertexOutput vs_main( const VertexInput vertex )
{
	float2 perturbedTexCoords;	
	float4 offset2d;	
	float4 viewPos;
	VertexOutput vertexOutput;

	vertexOutput = (VertexOutput)0;

	viewPos = Transform_ObjectToView( vertex.position );
	perturbedTexCoords.xy = vertex.texCoords.xy - 0.5f;
	offset2d = 0;
	offset2d.xy = perturbedTexCoords.x * particleCloudMatrix.xy + perturbedTexCoords.y * particleCloudMatrix.zw;
	viewPos = Transform_ViewToClip( viewPos + offset2d );
	vertexOutput.position = viewPos;
	vertexOutput.texCoords = vertex.texCoords;

#if OUTDOOR
	vertexOutput.outdoorMapPos = mul( vertex.position, worldOutdoorLookupMatrix );
#endif

	return vertexOutput;
}


PixelOutput ps_main( const VertexOutput pixel )
{
	PixelOutput fragment;	

	fragment.color = tex2D( colorMapSampler, pixel.texCoords ) * particleCloudColor;

#if OUTDOOR	
	if ( pixel.outdoorMapPos.z < tex2D( outdoorMapSampler, pixel.outdoorMapPos ).r )
		fragment.color.a = 0.0f;
#endif

	return fragment;
}
