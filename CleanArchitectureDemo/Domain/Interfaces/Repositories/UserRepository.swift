import Foundation

protocol UserRepository {
    @discardableResult
    func login(
        userLogin: UserLogin,
        cached: @escaping (User) -> Void,
        completion: @escaping (Result<User, Error>) -> Void
    ) -> Cancellable?
}
