//
//  HorariosViewModel.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

@MainActor
final class HorariosViewModel {
    
    let doctor: Doctor
    private let getAvailableSchedulesUseCase: GetAvailableSchedulesUseCase
    
    private(set) var horarios: [HorarioDisponible] = []
    
    var onHorariosChanged: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    init(
        doctor: Doctor,
        getAvailableSchedulesUseCase: GetAvailableSchedulesUseCase
    ) {
        self.doctor = doctor
        self.getAvailableSchedulesUseCase = getAvailableSchedulesUseCase
    }
    
    var title: String {
        "Reservar cita"
    }
    
    var doctorName: String {
        doctor.nombreCompleto
    }
    
    func loadHorarios(fecha: String) {
        Task {
            onLoadingChanged?(true)
            
            do {
                horarios = try await getAvailableSchedulesUseCase.execute(
                    doctorId: doctor.id,
                    fecha: fecha
                )
                
                onLoadingChanged?(false)
                onHorariosChanged?()
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
    
    func numberOfRows() -> Int {
        horarios.count
    }
    
    func horario(at index: Int) -> HorarioDisponible {
        horarios[index]
    }
}
