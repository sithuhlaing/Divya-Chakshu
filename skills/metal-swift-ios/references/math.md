# 3D Math Reference for Metal

## Model-View-Projection (MVP)
The full transformation from model space to NDC is:
`Position_NDC = Projection * View * Model * Position_Model`

### 1. Model Matrix
Transform objects from their local space to the world space.
- **Translate:** `matrix_float4x4` with `t.x, t.y, t.z` in the last column.
- **Scale:** `matrix_float4x4` with `s.x, s.y, s.z` on the diagonal.
- **Rotate:** Use `simd_quaternion` for smooth rotations.

### 2. View Matrix (Camera)
Represents the camera's position and orientation in the world.
- Often derived using `lookAt` (Eye, Center, Up).

### 3. Projection Matrix
Transforms the 3D scene into a 2D viewport.
- **Perspective:** `fieldOfView`, `aspectRatio`, `nearZ`, `farZ`.
- Metal's NDC Z ranges from 0.0 to 1.0.

## Utility Functions (Swift)
```swift
extension matrix_float4x4 {
    static func translation(_ vector: SIMD3<Float>) -> matrix_float4x4 {
        var matrix = matrix_identity_float4x4
        matrix.columns.3 = SIMD4<Float>(vector.x, vector.y, vector.z, 1)
        return matrix
    }
}
```
