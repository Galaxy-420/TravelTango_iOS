import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class UserManager: ObservableObject {
    static let shared = UserManager()

    @Published var userId: String?
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var profileImage: UIImage? = nil
    @Published var profileImageUrl: String = ""

    private var db = Firestore.firestore()
    private var storage = Storage.storage()

    private init() {
        loadUserDetails()
    }

    func loadUserDetails() {
        if let user = Auth.auth().currentUser {
            self.userId = user.uid
            self.email = user.email ?? ""
            self.name = user.displayName ?? "No Name"

            // Load more detailed user data from Firestore
            db.collection("users").document(user.uid).getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    self.name = data?["fullName"] as? String ?? self.name
                    self.profileImageUrl = data?["profileImageUrl"] as? String ?? ""

                    if !self.profileImageUrl.isEmpty {
                        self.downloadProfileImage(from: self.profileImageUrl)
                    }
                } else {
                    print("User document not found or error: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        } else {
            print("No user logged in")
        }
    }

    func downloadProfileImage(from url: String) {
        let storageRef = storage.reference(forURL: url)
        storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = image
                }
            } else {
                print("Failed to download profile image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            self.userId = nil
            self.name = ""
            self.email = ""
            self.profileImage = nil
        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }
}
