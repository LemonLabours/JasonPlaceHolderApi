import SwiftUI

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    
    func fetchUsers() {
        isLoading = true
        
        UserService().getUsers { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let users):
                    self.users = users
                case .failure(let error):
                    print("API request failed with error: \(error)")
                }
            }
        }
    }
    
    func createUser(user: User) {
        isLoading = true
        
        UserService().createUser(user: user) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let createdUser):
                    self.users.append(createdUser)
                case .failure(let error):
                    print("API request failed with error: \(error)")
                }
            }
        }
    }
    
    func updateUser(user: User) {
        isLoading = true
        
        UserService().updateUser(user: user) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let updatedUser):
                    if let index = self.users.firstIndex(where: { $0.id == updatedUser.id }) {
                        self.users[index] = updatedUser
                    }
                case .failure(let error):
                    print("API request failed with error: \(error)")
                }
            }
        }
    }
    
    func deleteUser(user: User) {
        isLoading = true
        
        UserService().deleteUser(id: user.id) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success:
                    if let index = self.users.firstIndex(where: { $0.id == user.id }) {
                        self.users.remove(at: index)
                    }
                case .failure(let error):
                    print("API request failed with error: \(error)")
                }
            }
        }
    }
}
