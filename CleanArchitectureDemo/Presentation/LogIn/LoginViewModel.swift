import Foundation
import SwiftUI

struct LoginViewModelActions {
    let didLogin: () -> Void
    let failedToLogin: (Error) -> Void
    let resendPassword: (@escaping (_ Username: String) -> Void) -> Void
}

protocol LoginViewModelInput {
    func didLogin(userLogin: UserLogin)
    func didForgetPassword(forUser username: String)
}

protocol LoginViewModelOutput {
    var loggedInState: Observable<LoginState> { get }
    var loading: Observable<Bool> { get }
    var error: Observable<String> { get }
    var screenTitle: String { get }
    var loginUsernamePlaceholder: String { get }
    var loginPasswordPlaceholder: String { get }
}

typealias LoginViewModel = LoginViewModelInput & LoginViewModelOutput

final class DefaultUserLoginViewModel: LoginViewModel {
    private let userLoginUserCase: UserLogInUseCase
    private let actions: LoginViewModelActions
    private var userLoginTask: Cancellable? { willSet { userLoginTask?.cancel() } }
    
    // MARK: OUTPUT
    var loggedInState: Observable<LoginState> = Observable(.loggedOut)
    var loading: Observable<Bool> = Observable(false)
    var error: Observable<String> = Observable("")
    var screenTitle: String = "Log in"
    var loginUsernamePlaceholder: String = "Username"
    var loginPasswordPlaceholder: String = "Password"
    
    init(
        userLoginUserCase: UserLogInUseCase,
        actions: LoginViewModelActions
    ) {
        self.userLoginUserCase = userLoginUserCase
        self.actions = actions
    }
}

// MARK: INPUT
extension DefaultUserLoginViewModel {
    func didLogin(userLogin: UserLogin) {
        userLoginTask = userLoginUserCase.execute(
            requestValue: .init(username: userLogin.username, password: userLogin.password),
            cached: { _ in },
            completion: { [weak self] result in
                switch result {
                case .success:
                    self?.actions.didLogin()
                case .failure(let failure):
                    self?.actions.failedToLogin(failure)
                }
            })
    }
    
    func didForgetPassword(forUser username: String) {
        actions.resendPassword { username in
            // TODO:
        }
    }
}
