# Shader Snippets for Metal (MSL)

## 1. Vertex Shader (Basic MVP)
```metal
struct VertexIn {
    float3 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
};

vertex VertexOut vertexMain(VertexIn in [[stage_in]],
                            constant matrix_float4x4 &mvp [[buffer(1)]])
{
    VertexOut out;
    out.position = mvp * float4(in.position, 1.0);
    return out;
}
```

## 2. Fragment Shader (Basic Lighting)
```metal
fragment float4 fragmentMain(VertexOut in [[stage_in]])
{
    // Ambient color
    float4 ambient = float4(0.1, 0.1, 0.1, 1.0);
    
    // Final output
    return ambient;
}
```

## 3. Best Practices
- **In-line Functions:** Use `inline` for small utility functions in shaders.
- **Precision:** Favor `half` precision over `float` when possible for performance.
- **Indexing:** Use `[[vertex_id]]` for indexing in vertex shaders when needed.
