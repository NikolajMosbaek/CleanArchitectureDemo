import Foundation

protocol LoginResultRepository {
    func saveRecentLoginStatus(
        _ state: LoginState,
        completion: @escaping (Result<User, Error>) -> Void
    )
}

enum LoginState: Equatable {
    case loggedIn
    case loggedOut
}
