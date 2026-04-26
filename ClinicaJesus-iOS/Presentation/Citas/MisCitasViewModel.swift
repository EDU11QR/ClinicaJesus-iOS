//
//  MisCitasViewModel.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

@MainActor
final class MisCitasViewModel {
    
    private let getMyAppointmentsUseCase: GetMyAppointmentsUseCase
    private let cancelAppointmentUseCase: CancelAppointmentUseCase
    
    private(set) var citas: [Appointment] = []
    
    var onCitasChanged: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onCancelSuccess: (() -> Void)?
    
    init(
        getMyAppointmentsUseCase: GetMyAppointmentsUseCase,
        cancelAppointmentUseCase: CancelAppointmentUseCase
    ) {
        self.getMyAppointmentsUseCase = getMyAppointmentsUseCase
        self.cancelAppointmentUseCase = cancelAppointmentUseCase
    }
    
    var title: String {
        "Mis citas"
    }
    
    func loadCitas() {
        Task {
            onLoadingChanged?(true)
            
            do {
                citas = try await getMyAppointmentsUseCase.execute()
                onLoadingChanged?(false)
                onCitasChanged?()
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
    
    func cancelCita(at index: Int) {
        let cita = citas[index]
        
        Task {
            onLoadingChanged?(true)
            
            do {
                _ = try await cancelAppointmentUseCase.execute(citaId: cita.id)
                onLoadingChanged?(false)
                onCancelSuccess?()
                loadCitas()
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
    
    func numberOfRows() -> Int {
        citas.count
    }
    
    func cita(at index: Int) -> Appointment {
        citas[index]
    }
    
    func canCancel(at index: Int) -> Bool {
        let estado = citas[index].estado.uppercased()
        return estado != "CANCELADA" && estado != "ATENDIDA"
    }
}
