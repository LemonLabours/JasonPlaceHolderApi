import SwiftUI
struct UserService {
    enum APIError: Error {
        case invalidURL
        case requestFailed
        case noData
        case decodingError
        case encodingError
    }
    
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
    
    func getUsers(completion: @escaping (Result<[User], APIError>) -> Void) {
        let url = baseURL.appendingPathComponent("users")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Request failed with error: \(error)")
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(.success(users))
            } catch {
                print("Decoding failed with error: \(error)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func createUser(user: User, completion: @escaping (Result<User, APIError>) -> Void) {
        let url = baseURL.appendingPathComponent("users")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            print("Encoding failed with error: \(error)")
            completion(.failure(.encodingError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request failed with error: \(error)")
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let createdUser = try JSONDecoder().decode(User.self, from: data)
                completion(.success(createdUser))
            } catch {
                print("Decoding failed with error: \(error)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func updateUser(user: User, completion: @escaping (Result<User, APIError>) -> Void) {
        let url = baseURL.appendingPathComponent("users/\(user.id)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            print("Encoding failed with error: \(error)")
            completion(.failure(.encodingError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request failed with error: \(error)")
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let updatedUser = try JSONDecoder().decode(User.self, from: data)
                completion(.success(updatedUser))
            } catch {
                print("Decoding failed with error: \(error)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func deleteUser(id: Int, completion: @escaping (Result<Void, APIError>) -> Void) {
        let url = baseURL.appendingPathComponent("users/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request failed with error: \(error)")
                completion(.failure(.requestFailed))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            
            if response.statusCode == 200 {
                completion(.success(()))
            } else {
                completion(.failure(.requestFailed))
            }
        }.resume()
    }
}
