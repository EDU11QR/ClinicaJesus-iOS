//
//  AdminUsuariosViewModel.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import Foundation

@MainActor

enum AdminUsuarioFiltro {
    case todos
    case pacientes
    case doctores
    case admins
    case activos
    case inactivos
}

final class AdminUsuariosViewModel {
    
    private let adminObtenerUsuariosUseCase: AdminObtenerUsuariosUseCase
    private let adminCambiarRolUsuarioUseCase: AdminCambiarRolUsuarioUseCase
    private let adminDesactivarUsuarioUseCase: AdminDesactivarUsuarioUseCase
    private let adminEditarUsuarioUseCase: AdminEditarUsuarioUseCase
    private let adminCambiarEstadoUsuarioUseCase: AdminCambiarEstadoUsuarioUseCase
    private let getSpecialtiesUseCase: GetSpecialtiesUseCase
    private let getMyProfileUseCase: GetMyProfileUseCase
    
    private var currentAuthUserId: UUID?
    //---filtro
    private var filtroActual: AdminUsuarioFiltro = .todos
    
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
        adminEditarUsuarioUseCase: AdminEditarUsuarioUseCase,
        adminCambiarEstadoUsuarioUseCase: AdminCambiarEstadoUsuarioUseCase,
        getSpecialtiesUseCase: GetSpecialtiesUseCase,
        getMyProfileUseCase: GetMyProfileUseCase
    ) {
        self.adminObtenerUsuariosUseCase = adminObtenerUsuariosUseCase
        self.adminCambiarRolUsuarioUseCase = adminCambiarRolUsuarioUseCase
        self.adminDesactivarUsuarioUseCase = adminDesactivarUsuarioUseCase
        self.adminEditarUsuarioUseCase = adminEditarUsuarioUseCase
        self.adminCambiarEstadoUsuarioUseCase = adminCambiarEstadoUsuarioUseCase
        self.getSpecialtiesUseCase = getSpecialtiesUseCase
        self.getMyProfileUseCase = getMyProfileUseCase
    }
    
    //-------funcion para buscar por fiultro
    func aplicarFiltro(_ filtro: AdminUsuarioFiltro) {
        filtroActual = filtro
        
        switch filtro {
        case .todos:
            usuariosFiltrados = usuarios
            
        case .pacientes:
            usuariosFiltrados = usuarios.filter { $0.rol == "PACIENTE" }
            
        case .doctores:
            usuariosFiltrados = usuarios.filter { $0.rol == "DOCTOR" }
            
        case .admins:
            usuariosFiltrados = usuarios.filter { $0.rol == "ADMIN" }
            
        case .activos:
            usuariosFiltrados = usuarios.filter { $0.activo }
            
        case .inactivos:
            usuariosFiltrados = usuarios.filter { !$0.activo }
        }
        
        onUsuariosChanged?()
    }
    
    func cargarDatos() {
        Task {
            onLoadingChanged?(true)
            
            do {
                if let perfilActual = try? await getMyProfileUseCase.execute() {
                    currentAuthUserId = perfilActual.authUserId
                } else {
                    currentAuthUserId = nil
                }
                
                async let usuariosResponse = adminObtenerUsuariosUseCase.execute()
                async let especialidadesResponse = getSpecialtiesUseCase.execute()
                
                usuarios = try await usuariosResponse
                usuariosFiltrados = usuarios   // siempre muestra TODOS por defecto
                especialidades = try await especialidadesResponse
                
                onLoadingChanged?(false)
                onUsuariosChanged?()
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
    //--------------TOLERA ACENTOS, ERRORES ORTOGRAFICOS
    func buscar(texto: String) {
        let textoLimpio = limpiarTexto(texto)
        
        if textoLimpio.isEmpty {
            usuariosFiltrados = usuarios
        } else {
            usuariosFiltrados = usuarios.filter { usuario in
                
                let nombre = limpiarTexto(usuario.nombre ?? "")
                let apellido = limpiarTexto(usuario.apellido ?? "")
                let nombreCompleto = "\(nombre) \(apellido)"
                let correo = limpiarTexto(usuario.correo)
                let telefono = limpiarTexto(usuario.telefono ?? "")
                let rol = limpiarTexto(usuario.rol)
                
                return nombreCompleto.contains(textoLimpio)
                || correo.contains(textoLimpio)
                || telefono.contains(textoLimpio)
                || rol.contains(textoLimpio)
            }
        }
        
        onUsuariosChanged?()
    }
    
    private func limpiarTexto(_ texto: String) -> String {
        return texto
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func editarUsuario(
        usuario: Usuario,
        nombre: String,
        apellido: String,
        correo: String,
        telefono: String
    ) {
        
        if usuario.activo == false {
            onError?("No puedes editar un usuario inactivo.")
            return
        }
        
        let nombreLimpio = nombre.trimmingCharacters(in: .whitespacesAndNewlines)
        let apellidoLimpio = apellido.trimmingCharacters(in: .whitespacesAndNewlines)
        let correoLimpio = correo.trimmingCharacters(in: .whitespacesAndNewlines)
        let telefonoLimpio = telefono.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !nombreLimpio.isEmpty,
              !apellidoLimpio.isEmpty,
              !correoLimpio.isEmpty,
              !telefonoLimpio.isEmpty else {
            onError?("Completa todos los campos.")
            return
        }
        
        guard correoLimpio.contains("@") else {
            onError?("Ingresa un correo válido.")
            return
        }
        
        Task {
            onLoadingChanged?(true)
            
            do {
                let mensaje = try await adminEditarUsuarioUseCase.execute(
                    usuarioId: usuario.id,
                    nombre: nombreLimpio,
                    apellido: apellidoLimpio,
                    correo: correoLimpio,
                    telefono: telefonoLimpio
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
    
    func cambiarRol(
        usuario: Usuario,
        nuevoRol: String,
        especialidadId: Int?
    ) {
        if usuario.activo == false {
            onError?("No puedes modificar un usuario inactivo.")
            return
        }
        
        if usuario.authUserId == currentAuthUserId {
            onError?("No puedes cambiar tu propio rol.")
            return
        }
        
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
    
    func cambiarEstadoUsuario(usuario: Usuario, activo: Bool) {
        if usuario.authUserId == currentAuthUserId {
            onError?("No puedes cambiar tu propio estado.")
            return
        }
        
        Task {
            onLoadingChanged?(true)
            
            do {
                let mensaje = try await adminCambiarEstadoUsuarioUseCase.execute(
                    usuarioId: usuario.id,
                    activo: activo
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
