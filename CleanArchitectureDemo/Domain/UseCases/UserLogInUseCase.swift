import Foundation

protocol UserLogInUseCase {
    func execute(
        requestValue: UserLogInUseCaseRequestValue,
        cached: @escaping (User) -> Void,
        completion: @escaping (Result<User, Error>) -> Void
    ) -> Cancellable?
}

struct UserLogInUseCaseRequestValue {
    let username: String
    let password: String
}

final class DefaultUserLogInUseCase: UserLogInUseCase {
    
    private let userRepository: UserRepository
    private let loginResultRepository: LoginResultRepository
    
    init(userRepository: UserRepository, loginResultRepository: LoginResultRepository) {
        self.userRepository = userRepository
        self.loginResultRepository = loginResultRepository
    }
    
    func execute(
        requestValue: UserLogInUseCaseRequestValue,
        cached: @escaping (User) -> Void,
        completion: @escaping (Result<User, Error>) -> Void)
    -> Cancellable? {
        return userRepository.login(
            userLogin: UserLogin(
                username: requestValue.username,
                password: requestValue.password
            ),
            cached: cached,
            completion: { result in
                self.cache(result: result)
                completion(result)
            })
        
    }
    
    private func cache(result: Result<User, Error>) {
        let state: LoginState
        switch result {
        case .success:
            state = .loggedIn
        case .failure:
            state = .loggedOut
        }
        
        loginResultRepository.saveRecentLoginStatus(state, completion: { _ in })
    }
}
