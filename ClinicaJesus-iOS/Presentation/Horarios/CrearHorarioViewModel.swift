//
//  CrearHorarioViewModel.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

@MainActor
final class CrearHorarioViewModel {
    
    private let crearHorarioDoctorUseCase: CrearHorarioDoctorUseCase
    
    var onLoadingChanged: ((Bool) -> Void)?
    var onSuccess: ((Int) -> Void)?
    var onError: ((String) -> Void)?
    
    init(crearHorarioDoctorUseCase: CrearHorarioDoctorUseCase) {
        self.crearHorarioDoctorUseCase = crearHorarioDoctorUseCase
    }
    
    func crearHorario(fecha: String, horaInicio: String, horaFin: String) {
        Task {
            onLoadingChanged?(true)
            
            do {
                let id = try await crearHorarioDoctorUseCase.execute(
                    fecha: fecha,
                    horaInicio: horaInicio,
                    horaFin: horaFin
                )
                
                onLoadingChanged?(false)
                onSuccess?(id)
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
}
