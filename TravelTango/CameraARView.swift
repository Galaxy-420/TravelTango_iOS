import SwiftUI
import RealityKit
import ARKit

struct ARCampingModel: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String  // For the sidebar icon
    let modelName: String  // Name of the USDZ file
    
    static let campingModels = [
        ARCampingModel(name: "Tent", imageName: "tent.fill", modelName: "camping_tent"),
        ARCampingModel(name: "Campfire", imageName: "flame.fill", modelName: "campfire"),
        ARCampingModel(name: "Chair", imageName: "chair.fill", modelName: "camping_chair"),
        ARCampingModel(name: "Cooler", imageName: "refrigerator.fill", modelName: "camping_cooler"),
        ARCampingModel(name: "Backpack", imageName: "bag.fill", modelName: "hiking_backpack"),
        ARCampingModel(name: "Cabin", imageName: "house.fill", modelName: "camping_cabin")
    ]
}

struct CameraARView: View {
    @State private var selectedModel: ARCampingModel?
    @State private var modelConfirmationShown = false
    
    var body: some View {
        ZStack {
            ARViewContainer(selectedModel: $selectedModel)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        // Optionally add custom action or just rely on swipe back
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
                
                // When model selected, show the place button
                if let selectedModel = selectedModel {
                    Button(action: {
                        modelConfirmationShown = true
                    }) {
                        HStack {
                            Image(systemName: selectedModel.imageName)
                            Text("Place \(selectedModel.name)")
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                    }
                    .padding(.bottom, 20)
                    .alert(isPresented: $modelConfirmationShown) {
                        Alert(
                            title: Text("Place \(selectedModel.name)"),
                            message: Text("Plane detection isn't available. The \(selectedModel.name) will be placed in front of you."),
                            primaryButton: .default(Text("Place")) {
                                // Notifies the AR view to place the object
                                NotificationCenter.default.post(name: Notification.Name("placeModel"), object: nil)
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            
            // Side model selection bar
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    ScrollView {
                        VStack(spacing: 15) {
                            Text("Camping Items")
                                .font(.headline)
                                .padding(.top, 8)
                                .foregroundColor(.white)
                            
                            ForEach(ARCampingModel.campingModels) { model in
                                Button(action: {
                                    selectedModel = model
                                }) {
                                    VStack {
                                        Image(systemName: model.imageName)
                                            .font(.system(size: 30))
                                            .padding(12)
                                            .background(selectedModel?.id == model.id ? Color.blue : Color.gray.opacity(0.8))
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        
                                        Text(model.name)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        .padding(12)
                    }
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(15)
                    .frame(width: 100)
                    .padding(.trailing, 10)
                    Spacer()
                }
            }
        }
        .navigationTitle("Camping AR")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var selectedModel: ARCampingModel?
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        arView.session.run(config)
        
        // Set the coordinator as an observer for the placeModel notification
        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.placeModelFromNotification),
            name: Notification.Name("placeModel"),
            object: nil
        )
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(sender:)))
        arView.addGestureRecognizer(tapGesture)
        
        return arView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        context.coordinator.view = self
        context.coordinator.arView = uiView
    }
    
    class Coordinator: NSObject {
        var view: ARViewContainer
        var arView: ARView?
        var selectedModelEntity: ModelEntity?
        
        init(_ view: ARViewContainer) {
            self.view = view
            super.init()
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        @objc func placeModelFromNotification() {
            guard let arView = arView,
                  let selectedModel = view.selectedModel else {
                print("Cannot place model: AR view or selected model is nil")
                return
            }
            
            // Get current camera transform
            guard let cameraTransform = arView.session.currentFrame?.camera.transform else {
                print("Cannot get camera transform")
                return
            }
            
            // Create a transform 1 meter in front of the camera
            var transform = cameraTransform
            transform.columns.3.z -= 1.0  // 1 meter in front
            
            // Create an anchor
            let anchor = AnchorEntity(world: transform)
            
            // Load the model entity
            let modelEntity = loadCampingModel(named: selectedModel.modelName)
            
            // Enable tap gesture for the model
            modelEntity.generateCollisionShapes(recursive: true)
            arView.installGestures([.translation], for: modelEntity)
            
            // Add to the anchor and scene
            anchor.addChild(modelEntity)
            arView.scene.addAnchor(anchor)
            
            print("Model placed: \(selectedModel.name)")
        }
        
        @objc func handleTap(sender: UITapGestureRecognizer) {
            guard let arView = arView else { return }
            
            let tapLocation = sender.location(in: arView)
            
            let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
            
            if let firstResult = results.first {
                placeModel(tapLocation: tapLocation)
            } else {
                print("No surface detected")
            }
        }
        
        func placeModel(tapLocation: CGPoint) {
            guard let arView = arView,
                  let selectedModel = view.selectedModel else {
                print("Cannot place model: AR view or selected model is nil")
                return
            }
            
            // Perform a ray cast to find a suitable placement location
            let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
            
            if let firstResult = results.first {
                // Create an anchor at the tap location
                let anchor = AnchorEntity(raycastResult: firstResult)
                
                // Load the model entity
                let modelEntity = loadCampingModel(named: selectedModel.modelName)
                
                // Enable tap gesture for the model
                modelEntity.generateCollisionShapes(recursive: true)
                arView.installGestures([.translation], for: modelEntity)
                
                // Add the model to the anchor
                anchor.addChild(modelEntity)
                
                // Add the anchor to the scene
                arView.scene.addAnchor(anchor)
                
                print("Model placed: \(selectedModel.name)")
            } else {
                print("No surface detected")
            }
        }
        
        func loadCampingModel(named modelName: String) -> ModelEntity {
            // Create different placeholder models based on the model name
            switch modelName {
            case "camping_tent":
                // Create a tent using a combination of a box and a cone
                let tentBase = MeshResource.generateBox(width: 0.4, height: 0.01, depth: 0.4)
                let tentTop = MeshResource.generateCone(height: 0.3, radius: 0.28)
                let baseMaterial = SimpleMaterial(color: .brown, isMetallic: false)
                let topMaterial = SimpleMaterial(color: .green, isMetallic: false)
                
                let baseEntity = ModelEntity(mesh: tentBase, materials: [baseMaterial])
                let topEntity = ModelEntity(mesh: tentTop, materials: [topMaterial])
                topEntity.position = SIMD3(0, 0.155, 0)
                
                let tentEntity = ModelEntity()
                tentEntity.addChild(baseEntity)
                tentEntity.addChild(topEntity)
                return tentEntity
                
            case "campfire":
                let base = MeshResource.generateCylinder(height: 0.05, radius: 0.2)
                let fire = MeshResource.generateCone(height: 0.2, radius: 0.15)
                let baseMaterial = SimpleMaterial(color: .gray, isMetallic: false)
                let fireMaterial = SimpleMaterial(color: .orange, isMetallic: false)
                
                let baseEntity = ModelEntity(mesh: base, materials: [baseMaterial])
                let fireEntity = ModelEntity(mesh: fire, materials: [fireMaterial])
                fireEntity.position = SIMD3(0, 0.125, 0)
                
                let fireModel = ModelEntity()
                fireModel.addChild(baseEntity)
                fireModel.addChild(fireEntity)
                return fireModel
                
            case "camping_chair":
                let seat = MeshResource.generateBox(width: 0.4, height: 0.05, depth: 0.4)
                let back = MeshResource.generateBox(width: 0.4, height: 0.4, depth: 0.05)
                let material = SimpleMaterial(color: .blue, isMetallic: false)
                
                let seatEntity = ModelEntity(mesh: seat, materials: [material])
                let backEntity = ModelEntity(mesh: back, materials: [material])
                seatEntity.position = SIMD3(0, 0.25, 0)
                backEntity.position = SIMD3(0, 0.45, -0.175)
                
                let chairEntity = ModelEntity()
                chairEntity.addChild(seatEntity)
                chairEntity.addChild(backEntity)
                return chairEntity
                
            case "camping_cooler":
                let cooler = MeshResource.generateBox(width: 0.3, height: 0.25, depth: 0.2)
                let material = SimpleMaterial(color: .red, isMetallic: true)
                return ModelEntity(mesh: cooler, materials: [material])
                
            case "hiking_backpack":
                let bag = MeshResource.generateBox(width: 0.25, height: 0.35, depth: 0.15)
                let material = SimpleMaterial(color: .orange, isMetallic: false)
                return ModelEntity(mesh: bag, materials: [material])
                
            case "camping_cabin":
                // Create a cabin with a box for base
                let base = MeshResource.generateBox(width: 0.5, height: 0.3, depth: 0.5)
                let roof = MeshResource.generateBox(width: 0.6, height: 0.05, depth: 0.6)
                let baseMaterial = SimpleMaterial(color: .brown, isMetallic: false)
                let roofMaterial = SimpleMaterial(color: .red, isMetallic: false)
                
                let baseEntity = ModelEntity(mesh: base, materials: [baseMaterial])
                let roofEntity = ModelEntity(mesh: roof, materials: [roofMaterial])
                
                // Position the roof at the top of the cabin
                roofEntity.position = SIMD3(0, 0.325, 0)
                
                let cabinEntity = ModelEntity()
                cabinEntity.addChild(baseEntity)
                cabinEntity.addChild(roofEntity)
                
                return cabinEntity
                
            default:
                // Fallback generic model
                let mesh = MeshResource.generateBox(size: 0.2)
                let material = SimpleMaterial(color: .purple, isMetallic: true)
                return ModelEntity(mesh: mesh, materials: [material])
            }
        }
    }
}
