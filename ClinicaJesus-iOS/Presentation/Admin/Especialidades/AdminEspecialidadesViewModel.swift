//
//  AdminEspecialidadesViewModel.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import Foundation

@MainActor
final class AdminEspecialidadesViewModel {
    
    private let obtenerUseCase: AdminObtenerEspecialidadesUseCase
    private let crearUseCase: AdminCrearEspecialidadUseCase
    private let editarUseCase: AdminEditarEspecialidadUseCase
    
    private(set) var especialidades: [Especialidad] = []
    private(set) var especialidadesFiltradas: [Especialidad] = []
    
    var onDataChanged: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onSuccessMessage: ((String) -> Void)?
    
    init(
        obtenerUseCase: AdminObtenerEspecialidadesUseCase,
        crearUseCase: AdminCrearEspecialidadUseCase,
        editarUseCase: AdminEditarEspecialidadUseCase
    ) {
        self.obtenerUseCase = obtenerUseCase
        self.crearUseCase = crearUseCase
        self.editarUseCase = editarUseCase
    }
    
    func cargarEspecialidades() {
        Task {
            onLoadingChanged?(true)
            do {
                especialidades = try await obtenerUseCase.execute()
                especialidadesFiltradas = especialidades
                onLoadingChanged?(false)
                onDataChanged?()
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
    
    func buscar(texto: String) {
        let textoLimpio = texto.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if textoLimpio.isEmpty {
            especialidadesFiltradas = especialidades
        } else {
            especialidadesFiltradas = especialidades.filter {
                $0.nombre.lowercased().contains(textoLimpio) ||
                ($0.descripcion ?? "").lowercased().contains(textoLimpio)
            }
        }
        
        onDataChanged?()
    }
    
    func crear(nombre: String, descripcion: String, precioTexto: String) {
        let nombreLimpio = nombre.trimmingCharacters(in: .whitespacesAndNewlines)
        let descripcionLimpia = descripcion.trimmingCharacters(in: .whitespacesAndNewlines)
        let precio = Double(precioTexto.replacingOccurrences(of: ",", with: ".")) ?? 0
        
        guard !nombreLimpio.isEmpty else {
            onError?("El nombre de la especialidad es obligatorio.")
            return
        }
        
        Task {
            onLoadingChanged?(true)
            do {
                let mensaje = try await crearUseCase.execute(
                    nombre: nombreLimpio,
                    descripcion: descripcionLimpia,
                    precio: precio
                )
                onLoadingChanged?(false)
                onSuccessMessage?(mensaje)
                cargarEspecialidades()
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
    
    func editar(
        especialidad: Especialidad,
        nombre: String,
        descripcion: String,
        precioTexto: String,
        activo: Bool
    ) {
        let nombreLimpio = nombre.trimmingCharacters(in: .whitespacesAndNewlines)
        let descripcionLimpia = descripcion.trimmingCharacters(in: .whitespacesAndNewlines)
        let precio = Double(precioTexto.replacingOccurrences(of: ",", with: ".")) ?? 0
        
        guard !nombreLimpio.isEmpty else {
            onError?("El nombre de la especialidad es obligatorio.")
            return
        }
        
        Task {
            onLoadingChanged?(true)
            do {
                let mensaje = try await editarUseCase.execute(
                    id: especialidad.id,
                    nombre: nombreLimpio,
                    descripcion: descripcionLimpia,
                    precio: precio,
                    activo: activo
                )
                onLoadingChanged?(false)
                onSuccessMessage?(mensaje)
                cargarEspecialidades()
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
    
    func numberOfRows() -> Int {
        especialidadesFiltradas.count
    }
    
    func especialidad(at index: Int) -> Especialidad {
        especialidadesFiltradas[index]
    }
}
