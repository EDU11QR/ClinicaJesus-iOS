//
//  DependencyContainer.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation
import UIKit

@MainActor
final class DependencyContainer {
    
    static let shared = DependencyContainer()
    
    private init() {}
    
    // MARK: - Services
    
    private lazy var authService: AuthServiceProtocol = AuthService()
    private lazy var userService: UserServiceProtocol = UserService()
    private lazy var catalogService: CatalogServiceProtocol = CatalogService()
    
    // MARK: - Repositories
    
    private lazy var authRepository: AuthRepositoryProtocol = AuthRepository(service: authService)
    private lazy var userRepository: UserRepositoryProtocol = UserRepository(service: userService)
    private lazy var catalogRepository: CatalogRepositoryProtocol = CatalogRepository(service: catalogService)
    
    // MARK: - UseCases
    
    lazy var signInUseCase = SignInUseCase(repository: authRepository)
    lazy var getMyProfileUseCase = GetMyProfileUseCase(repository: userRepository)
    lazy var getSpecialtiesUseCase = GetSpecialtiesUseCase(repository: catalogRepository)
    lazy var getDoctorsBySpecialtyUseCase = GetDoctorsBySpecialtyUseCase(repository: catalogRepository)
    
    // MARK: - Factories
    
    func makeLoginViewController() -> LoginViewController {
        let viewModel = LoginViewModel(
            signInUseCase: signInUseCase,
            getMyProfileUseCase: getMyProfileUseCase
        )
        return LoginViewController(viewModel: viewModel)
    }
    
    func makeEspecialidadesViewController() -> EspecialidadesViewController {
        let viewModel = EspecialidadesViewModel(
            getSpecialtiesUseCase: getSpecialtiesUseCase
        )
        return EspecialidadesViewController(viewModel: viewModel)
    }
    
    func makeDoctoresViewController(
        specialtyId: Int,
        specialtyName: String
    ) -> DoctoresViewController {
        let viewModel = DoctoresViewModel(
            specialtyId: specialtyId,
            specialtyName: specialtyName,
            getDoctorsBySpecialtyUseCase: getDoctorsBySpecialtyUseCase
        )
        return DoctoresViewController(viewModel: viewModel)
    }
}
