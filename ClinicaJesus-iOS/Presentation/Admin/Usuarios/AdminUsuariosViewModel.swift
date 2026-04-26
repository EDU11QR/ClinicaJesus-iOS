//
//  AdminUsuariosViewModel.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import Foundation

@MainActor
final class AdminUsuariosViewModel {
    
    private let adminObtenerUsuariosUseCase: AdminObtenerUsuariosUseCase
    private let adminCambiarRolUsuarioUseCase: AdminCambiarRolUsuarioUseCase
    private let adminDesactivarUsuarioUseCase: AdminDesactivarUsuarioUseCase
    private let getSpecialtiesUseCase: GetSpecialtiesUseCase
    
    private(set) var usuarios: [Usuario] = []
    private(set) var usuariosFiltrados: [Usuario] = []
    private(set) var especialidades: [Especialidad] = []
    
    var onUsuariosChanged: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onSuccessMessage: ((String) -> Void)?
    
    init(
        adminObtenerUsuariosUseCase: AdminObtenerUsuariosUseCase,
        adminCambiarRolUsuarioUseCase: AdminCambiarRolUsuarioUseCase,
        adminDesactivarUsuarioUseCase: AdminDesactivarUsuarioUseCase,
        getSpecialtiesUseCase: GetSpecialtiesUseCase
    ) {
        self.adminObtenerUsuariosUseCase = adminObtenerUsuariosUseCase
        self.adminCambiarRolUsuarioUseCase = adminCambiarRolUsuarioUseCase
        self.adminDesactivarUsuarioUseCase = adminDesactivarUsuarioUseCase
        self.getSpecialtiesUseCase = getSpecialtiesUseCase
    }
    
    func cargarDatos() {
        Task {
            onLoadingChanged?(true)
            
            do {
                async let usuariosResponse = adminObtenerUsuariosUseCase.execute()
                async let especialidadesResponse = getSpecialtiesUseCase.execute()
                
                usuarios = try await usuariosResponse
                usuariosFiltrados = usuarios
                especialidades = try await especialidadesResponse
                
                onLoadingChanged?(false)
                onUsuariosChanged?()
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
    
    func buscar(texto: String) {
        let textoLimpio = texto.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if textoLimpio.isEmpty {
            usuariosFiltrados = usuarios
        } else {
            usuariosFiltrados = usuarios.filter { usuario in
                let nombreCompleto = "\(usuario.nombre ?? "") \(usuario.apellido ?? "")".lowercased()
                let correo = usuario.correo.lowercased()
                let telefono = usuario.telefono?.lowercased() ?? ""
                let rol = usuario.rol.lowercased()
                
                return nombreCompleto.contains(textoLimpio)
                || correo.contains(textoLimpio)
                || telefono.contains(textoLimpio)
                || rol.contains(textoLimpio)
            }
        }
        
        onUsuariosChanged?()
    }
    
    func cambiarRol(
        usuario: Usuario,
        nuevoRol: String,
        especialidadId: Int?
    ) {
        if usuario.rol == "DOCTOR" && nuevoRol == "PACIENTE" {
            onError?("Un doctor no puede volver a paciente.")
            return
        }
        
        if nuevoRol == "DOCTOR" && especialidadId == nil {
            onError?("Debes seleccionar una especialidad para asignar el rol Doctor.")
            return
        }
        
        Task {
            onLoadingChanged?(true)
            
            do {
                let mensaje = try await adminCambiarRolUsuarioUseCase.execute(
                    usuarioId: usuario.id,
                    nuevoRol: nuevoRol,
                    especialidadId: especialidadId
                )
                
                onLoadingChanged?(false)
                onSuccessMessage?(mensaje)
                cargarDatos()
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
    
    func desactivarUsuario(usuario: Usuario) {
        Task {
            onLoadingChanged?(true)
            
            do {
                let mensaje = try await adminDesactivarUsuarioUseCase.execute(
                    usuarioId: usuario.id
                )
                
                onLoadingChanged?(false)
                onSuccessMessage?(mensaje)
                cargarDatos()
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
    
    func numberOfRows() -> Int {
        usuariosFiltrados.count
    }
    
    func usuario(at index: Int) -> Usuario {
        usuariosFiltrados[index]
    }
    
    func especialidadIdPorDefecto() -> Int? {
        especialidades.first?.id
    }
}
