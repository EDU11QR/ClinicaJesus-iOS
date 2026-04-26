//
//  HorariosDoctorViewModel.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

@MainActor
final class HorariosDoctorViewModel {
    
    private let obtenerHorariosDoctorUseCase: ObtenerHorariosDoctorUseCase
    private let desactivarHorarioDoctorUseCase: DesactivarHorarioDoctorUseCase
    
    private(set) var horarios: [HorarioDoctor] = []
    
    var onHorariosChanged: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onDesactivarSuccess: (() -> Void)?
    
    init(
        obtenerHorariosDoctorUseCase: ObtenerHorariosDoctorUseCase,
        desactivarHorarioDoctorUseCase: DesactivarHorarioDoctorUseCase
    ) {
        self.obtenerHorariosDoctorUseCase = obtenerHorariosDoctorUseCase
        self.desactivarHorarioDoctorUseCase = desactivarHorarioDoctorUseCase
    }
    
    var title: String {
        "Mis horarios"
    }
    
    func cargarHorarios() {
        Task {
            onLoadingChanged?(true)
            
            do {
                horarios = try await obtenerHorariosDoctorUseCase.execute()
                onLoadingChanged?(false)
                onHorariosChanged?()
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
    
    func desactivarHorario(at index: Int) {
        let horario = horarios[index]
        
        Task {
            onLoadingChanged?(true)
            
            do {
                _ = try await desactivarHorarioDoctorUseCase.execute(horarioId: horario.id)
                onLoadingChanged?(false)
                onDesactivarSuccess?()
                cargarHorarios()
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
    
    func numberOfRows() -> Int {
        horarios.count
    }
    
    func horario(at index: Int) -> HorarioDoctor {
        horarios[index]
    }
}
