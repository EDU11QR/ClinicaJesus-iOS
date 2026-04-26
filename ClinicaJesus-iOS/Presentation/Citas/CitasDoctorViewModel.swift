//
//  CitasDoctorViewModel.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

@MainActor
final class CitasDoctorViewModel {
    
    private let obtenerCitasDoctorUseCase: ObtenerCitasDoctorUseCase
    private let cambiarEstadoCitaDoctorUseCase: CambiarEstadoCitaDoctorUseCase
    
    private(set) var citas: [CitaDoctor] = []
    
    var onCitasChanged: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onEstadoChanged: (() -> Void)?
    
    init(
        obtenerCitasDoctorUseCase: ObtenerCitasDoctorUseCase,
        cambiarEstadoCitaDoctorUseCase: CambiarEstadoCitaDoctorUseCase
    ) {
        self.obtenerCitasDoctorUseCase = obtenerCitasDoctorUseCase
        self.cambiarEstadoCitaDoctorUseCase = cambiarEstadoCitaDoctorUseCase
    }
    
    var title: String {
        "Mis citas"
    }
    
    func cargarCitas() {
        Task {
            onLoadingChanged?(true)
            
            do {
                citas = try await obtenerCitasDoctorUseCase.execute()
                onLoadingChanged?(false)
                onCitasChanged?()
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
    
    func cambiarEstado(at index: Int, nuevoEstado: String) {
        let cita = citas[index]
        
        Task {
            onLoadingChanged?(true)
            
            do {
                _ = try await cambiarEstadoCitaDoctorUseCase.execute(
                    citaId: cita.id,
                    nuevoEstado: nuevoEstado
                )
                
                onLoadingChanged?(false)
                onEstadoChanged?()
                cargarCitas()
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
    
    func numberOfRows() -> Int {
        citas.count
    }
    
    func cita(at index: Int) -> CitaDoctor {
        citas[index]
    }
}
