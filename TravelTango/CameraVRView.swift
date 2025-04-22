import SwiftUI
import SceneKit

struct CameraVRView: View {
    var imageName: String = "sample360" // Default 360° image in Assets

    var body: some View {
        SceneView(
            scene: {
                let scene = SCNScene()

                let sphere = SCNSphere(radius: 10)
                sphere.firstMaterial?.isDoubleSided = true
                sphere.firstMaterial?.diffuse.contents = UIImage(named: imageName)

                let node = SCNNode(geometry: sphere)
                node.eulerAngles = SCNVector3(x: 0, y: .pi, z: 0)

                scene.rootNode.addChildNode(node)
                return scene
            }(),
            options: [.allowsCameraControl, .autoenablesDefaultLighting]
        )
        .edgesIgnoringSafeArea(.all)
    }
}
