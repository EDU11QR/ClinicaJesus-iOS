//
//  LoginViewModel.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import Foundation

@MainActor
final class LoginViewModel {
    private let signInUseCase: SignInUseCase
    private let getMyProfileUseCase: GetMyProfileUseCase

    var onLoadingChange: ((Bool) -> Void)?
    var onSuccess: ((Usuario) -> Void)?
    var onError: ((String) -> Void)?

    init(
        signInUseCase: SignInUseCase,
        getMyProfileUseCase: GetMyProfileUseCase
    ) {
        self.signInUseCase = signInUseCase
        self.getMyProfileUseCase = getMyProfileUseCase
    }

    func signIn(email: String, password: String) {
        Task {
            onLoadingChange?(true)
            do {
                try await signInUseCase.execute(email: email, password: password)
                let usuario = try await getMyProfileUseCase.execute()
                onLoadingChange?(false)
                onSuccess?(usuario)
            } catch {
                onLoadingChange?(false)
                onError?(error.localizedDescription)
            }
        }
    }
}
