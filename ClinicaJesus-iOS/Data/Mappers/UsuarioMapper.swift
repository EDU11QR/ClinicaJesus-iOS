//
//  UsuarioMapper.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation

enum UsuarioMapper {
    static func toDomain(from dto: UsuarioDTO) -> Usuario {
        Usuario(
            id: dto.id,
            authUserId: dto.auth_user_id,
            nombre: dto.nombre,
            apellido: dto.apellido,
            correo: dto.correo,
            telefono: dto.telefono,
            rol: dto.rol,
            activo: dto.activo
        )
    }
}
