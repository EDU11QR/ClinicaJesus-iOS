//
//  EspecialidadMapper.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation

enum EspecialidadMapper {
    static func toDomain(from dto: EspecialidadDTO) -> Especialidad {
        Especialidad(
            id: dto.id,
            nombre: dto.nombre,
            descripcion: dto.descripcion,
            precio: dto.precio,
            activo: dto.activo
        )
    }
}
