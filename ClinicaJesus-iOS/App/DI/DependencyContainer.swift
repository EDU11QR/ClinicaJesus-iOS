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
    
    lazy var signUpPacienteUseCase = SignUpPacienteUseCase(repository: authRepository)
    
    lazy var signInUseCase = SignInUseCase(repository: authRepository)
    lazy var signOutUseCase = SignOutUseCase(repository: authRepository)
    lazy var getMyProfileUseCase = GetMyProfileUseCase(repository: userRepository)
    lazy var getSpecialtiesUseCase = GetSpecialtiesUseCase(repository: catalogRepository)
    lazy var getDoctorsBySpecialtyUseCase = GetDoctorsBySpecialtyUseCase(repository: catalogRepository)
    lazy var getAvailableSchedulesUseCase = GetAvailableSchedulesUseCase(repository: catalogRepository)
    
    lazy var appointmentService: AppointmentServiceProtocol = AppointmentService()
    lazy var appointmentRepository: AppointmentRepositoryProtocol = AppointmentRepository(service: appointmentService)
    lazy var reserveAppointmentUseCase = ReserveAppointmentUseCase(repository: appointmentRepository)
    lazy var getMyAppointmentsUseCase = GetMyAppointmentsUseCase(repository: appointmentRepository)
    lazy var cancelAppointmentUseCase = CancelAppointmentUseCase(repository: appointmentRepository)
    
    lazy var obtenerCitasDoctorUseCase = ObtenerCitasDoctorUseCase(repository: appointmentRepository)
    lazy var cambiarEstadoCitaDoctorUseCase = CambiarEstadoCitaDoctorUseCase(repository: appointmentRepository)
    lazy var crearHorarioDoctorUseCase = CrearHorarioDoctorUseCase(repository: appointmentRepository)
    
    lazy var obtenerHorariosDoctorUseCase = ObtenerHorariosDoctorUseCase(repository: appointmentRepository)
    lazy var desactivarHorarioDoctorUseCase = DesactivarHorarioDoctorUseCase(repository: appointmentRepository)
    
    // conectamos Usecases para admin
    lazy var adminObtenerUsuariosUseCase = AdminObtenerUsuariosUseCase(repository: userRepository)
    lazy var adminCambiarRolUsuarioUseCase = AdminCambiarRolUsuarioUseCase(repository: userRepository)
    lazy var adminDesactivarUsuarioUseCase = AdminDesactivarUsuarioUseCase(repository: userRepository)
    lazy var adminEditarUsuarioUseCase =
    AdminEditarUsuarioUseCase(repository: userRepository)
    lazy var adminCambiarEstadoUsuarioUseCase =
    AdminCambiarEstadoUsuarioUseCase(repository: userRepository)
    
    // conectamos Usecases para especialidades
    
    lazy var adminObtenerEspecialidadesUseCase =
    AdminObtenerEspecialidadesUseCase(repository: catalogRepository)

    lazy var adminCrearEspecialidadUseCase =
    AdminCrearEspecialidadUseCase(repository: catalogRepository)

    lazy var adminEditarEspecialidadUseCase =
    AdminEditarEspecialidadUseCase(repository: catalogRepository)
    
    //-------------
    lazy var getCurrentUserSessionUseCase =
    GetCurrentUserSessionUseCase(repository: authRepository)
    
    
    // DOCTORES
    lazy var adminObtenerDoctoresUseCase =
    AdminObtenerDoctoresUseCase(repository: catalogRepository)

    lazy var adminEditarDoctorUseCase =
    AdminEditarDoctorUseCase(repository: catalogRepository)
    
    // MARK: - Factories
    
    func makeRegisterPacienteViewController() -> RegisterPacienteViewController {
        let viewModel = RegisterPacienteViewModel(
            signUpPacienteUseCase: signUpPacienteUseCase
        )
        return RegisterPacienteViewController(viewModel: viewModel)
    }
    
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
    
    func makeHorariosViewController(doctor: Doctor) -> HorariosViewController {
        let viewModel = HorariosViewModel(
            doctor: doctor,
            getAvailableSchedulesUseCase: getAvailableSchedulesUseCase
        )
        return HorariosViewController(viewModel: viewModel)
    }
    
    func makeConfirmarCitaViewController(
        doctor: Doctor,
        horario: HorarioDisponible
    ) -> ConfirmarCitaViewController {
        
        let viewModel = ConfirmarCitaViewModel(
            doctor: doctor,
            horario: horario,
            reserveAppointmentUseCase: reserveAppointmentUseCase
        )
        
        return ConfirmarCitaViewController(viewModel: viewModel)
    }
    
    func makeMisCitasViewController() -> MisCitasViewController {
        let viewModel = MisCitasViewModel(
            getMyAppointmentsUseCase: getMyAppointmentsUseCase,
            cancelAppointmentUseCase: cancelAppointmentUseCase
        )
        return MisCitasViewController(viewModel: viewModel)
    }
    
    func makeCitasDoctorViewController() -> CitasDoctorViewController {
        let viewModel = CitasDoctorViewModel(
            obtenerCitasDoctorUseCase: obtenerCitasDoctorUseCase,
            cambiarEstadoCitaDoctorUseCase: cambiarEstadoCitaDoctorUseCase
        )
        return CitasDoctorViewController(viewModel: viewModel)
    }
    
    func makeCrearHorarioViewController() -> CrearHorarioViewController {
        let viewModel = CrearHorarioViewModel(
            crearHorarioDoctorUseCase: crearHorarioDoctorUseCase
        )
        return CrearHorarioViewController(viewModel: viewModel)
    }
    
    func makeHorariosDoctorViewController() -> HorariosDoctorViewController {
        let viewModel = HorariosDoctorViewModel(
            obtenerHorariosDoctorUseCase: obtenerHorariosDoctorUseCase,
            desactivarHorarioDoctorUseCase: desactivarHorarioDoctorUseCase
        )
        return HorariosDoctorViewController(viewModel: viewModel)
    }
    
    func makePacienteContactoViewController() -> PacienteContactoViewController {
        return PacienteContactoViewController()
    }
    
    //------------------ADMIN-------
    func makeAdminUsuariosViewController() -> AdminUsuariosViewController {
        let viewModel = AdminUsuariosViewModel(
            adminObtenerUsuariosUseCase: adminObtenerUsuariosUseCase,
            adminCambiarRolUsuarioUseCase: adminCambiarRolUsuarioUseCase,
            adminDesactivarUsuarioUseCase: adminDesactivarUsuarioUseCase,
            adminEditarUsuarioUseCase: adminEditarUsuarioUseCase,
            adminCambiarEstadoUsuarioUseCase: adminCambiarEstadoUsuarioUseCase,
            getSpecialtiesUseCase: getSpecialtiesUseCase,
            getMyProfileUseCase: getMyProfileUseCase
        )
        
        return AdminUsuariosViewController(viewModel: viewModel)
    }
    
    func makeAdminHomeViewController() -> AdminHomeViewController {
        return AdminHomeViewController()
    }
    
    //----------ESPECIALIDADES--------------
    func makeAdminEspecialidadesViewController() -> AdminEspecialidadesViewController {
        let viewModel = AdminEspecialidadesViewModel(
            obtenerUseCase: adminObtenerEspecialidadesUseCase,
            crearUseCase: adminCrearEspecialidadUseCase,
            editarUseCase: adminEditarEspecialidadUseCase
        )
        
        return AdminEspecialidadesViewController(viewModel: viewModel)
    }
    
    //----------REGISTRAR USUARIO
    func makeAdminRegisterUserViewController(
        onCreated: @escaping () -> Void
    ) -> RegisterPacienteViewController {
        
        let viewModel = RegisterPacienteViewModel(
            signUpPacienteUseCase: signUpPacienteUseCase
        )
        
        let vc = RegisterPacienteViewController(viewModel: viewModel)
        vc.isAdminMode = true
        vc.onUserCreated = onCreated
        return vc
    }
    
}
