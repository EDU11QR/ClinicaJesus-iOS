//
//  DependencyContainer.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import Foundation

@MainActor
final class DependencyContainer {
    static let shared = DependencyContainer()

    private init() {}

    func makeLoginViewController() -> LoginViewController {
        let authService = AuthService()
        let authRepository = AuthRepository(service: authService)
        let signInUseCase = SignInUseCase(repository: authRepository)

        let userService = UserService()
        let userRepository = UserRepository(service: userService)
        let getMyProfileUseCase = GetMyProfileUseCase(repository: userRepository)

        let viewModel = LoginViewModel(
            signInUseCase: signInUseCase,
            getMyProfileUseCase: getMyProfileUseCase
        )

        return LoginViewController(viewModel: viewModel)
    }

    func makeEspecialidadesViewController() -> EspecialidadesViewController {
        let catalogService = CatalogService()
        let catalogRepository = CatalogRepository(service: catalogService)
        let getSpecialtiesUseCase = GetSpecialtiesUseCase(repository: catalogRepository)
        let viewModel = EspecialidadesViewModel(getSpecialtiesUseCase: getSpecialtiesUseCase)
        return EspecialidadesViewController(viewModel: viewModel)
    }

    func makeDoctoresViewController(especialidad: Especialidad) -> DoctoresViewController {
        let catalogService = CatalogService()
        let catalogRepository = CatalogRepository(service: catalogService)
        let useCase = GetDoctorsBySpecialtyUseCase(repository: catalogRepository)
        let viewModel = DoctoresViewModel(getDoctorsBySpecialtyUseCase: useCase)
        return DoctoresViewController(viewModel: viewModel, especialidad: especialidad)
    }
}
