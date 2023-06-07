import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()
    @State private var showAlert = false
    @State private var selectedUser: User?
    @State private var isLoading = false

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.users) { user in
                    Text(user.name)
                }
                .onDelete(perform: delete)
            }
            
            Button(action: {
                isLoading = true
                viewModel.fetchUsers()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isLoading = false
                }
            }) {
                Text("Fetch Users")
            }
            .padding()

            
            Button("Create User") {
                let newUser = User(id: 0, name: "New User", username: "New", email: "New Email")
                viewModel.createUser(user: newUser)
            }
            .padding()
            
            if isLoading {
                ProgressView()
                    .padding()
            }
        }
        .onAppear {
            viewModel.fetchUsers()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Delete User"),
                message: Text("Are you sure you want to delete this user?"),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Delete"), action: deleteUser)
            )
        }
    }
    
    private func delete(at offsets: IndexSet) {
        if let index = offsets.first {
            selectedUser = viewModel.users[index]
            showAlert = true
        }
    }
    
    private func deleteUser() {
        if let user = selectedUser {
            viewModel.deleteUser(user: user)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
