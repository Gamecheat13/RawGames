#if !defined( USE_SPECULAR )
#error USE_SPECULAR is undefined
#endif


// WS = world space; TS = tangent space
//
// normalWS = normalize( normalTS * invTrans( basisTS ) * invTrans( worldMatrix ) )
// eyeDirWS = normalize( eyePosition - vertPos * worldMatrix )
// lightDirWS = normalize( lightPosition0 - vertPos * worldMatrix )
// halfAngleWS = normalize( eyePosition + lightPosition0 )
//
// 'basisTS' is always a rotation matrix, so 'invTrans( basisTS )' is simply 'basisTS'.
// 'worldMatrix' is restricted to rotation and uniform scale, so 'invTrans( worldMatrix )' is simply 'worldMatrix / scale^2'
// So, we have
// normalWS = normalize( normalTS * basisTS * worldMatrix / scale^2 )
// normalWS = normalTS * basisTS * worldMatrix / scale
//
// dot( normalWS, vecWS ) = normalWS * transpose( vecWS )
// dot( normalWS, vecWS ) = normalTS * basisTS * worldMatrix / scale * transpose( vecWS )
// dot( normalWS, vecWS ) = normalTS * ((basisTS * worldMatrix) * transpose( vecWS )) / scale
// dot( normalWS, vecWS ) = normalTS * transpose( vecWS * transpose( basisTS * worldMatrix )) / scale
// dot( normalWS, vecWS ) = dot( normalTS, vecWS * transpose( basisTS * worldMatrix ) / scale )
//
// If the world space vector 'vecWS' needs to be normalized anyway, then the division by 'scale' is not needed.

void Phong_VertexSetup( const VertexInput vertex, const half3 lightDir, inout PixelInput pixel )
{
#if USE_SPECULAR
	float3	worldVertPos;
	float3	eyeDir;

	worldVertPos = Transform_ObjectToWorld( vertex.position );

	eyeDir = normalize( eyePosition - worldVertPos );
	pixel.halfAngle = normalize( eyeDir + lightDir );
#endif // #if USE_SPECULAR
}


half3 Phong_SpecularStrength( float power, float NdotH )
{
	return tex2D( specularitySampler, float2( power, NdotH ) ).rgb;
}


half3 Phong_SpecularLighting( const PixelInput pixel, const half3 normal )
{
#if USE_SPECULAR

	half4	specularSample;
	half	NdotH;

	specularSample = tex2D( specularMapSampler, pixel.texCoords );
	NdotH = dot( normalize( half3( pixel.halfAngle ) ), normal );
	return lightSpecular0 * specularSample.rgb * Phong_SpecularStrength( specularSample.a, NdotH );

#else

	return 0;

#endif
}


half3 Phong_DiffuseLighting( const PixelInput pixel, const half3 normal, const half3 lightDir )
{
	half NdotL;
	half angleAttenuation;

	NdotL = dot( lightDir, normal );
	angleAttenuation = max( 0, NdotL );
	return lightColor0 * angleAttenuation;
}


half3 Phong_Lighting( const PixelInput pixel, const half3 normal, const half3 diffuseColor, const half3 lightDir )
{
	half3	diffuse;
	half3	specular;

	diffuse = diffuseColor.rgb * Phong_DiffuseLighting( pixel, normal, lightDir );
	specular = Phong_SpecularLighting( pixel, normal );
	return diffuse + specular;
}


half3 Phong_SpecularVisibility( const half3 sunlightVisibility )
{
	return lerp( 0.3, 1.0, sunlightVisibility );
}
