import SwiftUI
import SceneKit
import CoreLocation

struct VR360View: UIViewRepresentable {
    let locationName: String
    let coordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        let scene = SCNScene()

        // Try to load the image
        var panoramaTexture: Any = UIColor.red // fallback color
        if let image = UIImage(named: "Image.jpg") {
            print("✅ Loaded 360 image: Image.jpg")
            panoramaTexture = image
        } else {
            print("❌ Failed to load 360 image: Image.jpg")
        }

        // Create the 360° sphere
        let sphere = SCNSphere(radius: 10)
        sphere.firstMaterial?.isDoubleSided = true
        sphere.firstMaterial?.diffuse.contents = panoramaTexture
        sphere.firstMaterial?.diffuse.wrapS = .repeat
        sphere.firstMaterial?.diffuse.wrapT = .clamp

        let sphereNode = SCNNode(geometry: sphere)
        scene.rootNode.addChildNode(sphereNode)

        // Camera at the center
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(cameraNode)

        // Add a test marker inside the sphere to check visibility
        let marker = SCNSphere(radius: 0.2)
        marker.firstMaterial?.diffuse.contents = UIColor.blue
        let markerNode = SCNNode(geometry: marker)
        markerNode.position = SCNVector3(x: 0, y: 0, z: -5)
        scene.rootNode.addChildNode(markerNode)

        // SceneView setup
        sceneView.scene = scene
        sceneView.pointOfView = cameraNode
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = UIColor.black

        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        // No dynamic updates needed
    }
}
