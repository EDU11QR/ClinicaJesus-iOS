//
//  ConfirmarCitaViewModel.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

@MainActor
final class ConfirmarCitaViewModel {
    
    let doctor: Doctor
    let horario: HorarioDisponible
    
    private let reserveAppointmentUseCase: ReserveAppointmentUseCase
    
    var onValidationError: ((String) -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onSuccess: ((Int) -> Void)?
    var onError: ((String) -> Void)?
    
    init(
        doctor: Doctor,
        horario: HorarioDisponible,
        reserveAppointmentUseCase: ReserveAppointmentUseCase
    ) {
        self.doctor = doctor
        self.horario = horario
        self.reserveAppointmentUseCase = reserveAppointmentUseCase
    }
    
    var doctorName: String {
        doctor.nombreCompleto
    }
    
    var specialtyName: String {
        doctor.especialidadNombre
    }
    
    var fecha: String {
        horario.fecha
    }
    
    var hora: String {
        "\(horario.horaInicio) - \(horario.horaFin)"
    }
    
    func confirmarCita(motivo: String) {
        let motivoLimpio = motivo.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if motivoLimpio.isEmpty {
            onValidationError?("Debes ingresar el motivo de la consulta.")
            return
        }
        
        Task {
            onLoadingChanged?(true)
            
            do {
                let citaId = try await reserveAppointmentUseCase.execute(
                    doctorId: doctor.id,
                    horarioId: horario.id,
                    motivo: motivoLimpio
                )
                
                onLoadingChanged?(false)
                onSuccess?(citaId)
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
}
