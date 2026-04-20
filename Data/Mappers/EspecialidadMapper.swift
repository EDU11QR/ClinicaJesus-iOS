//
//  EspecialidadMapper.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import Foundation

enum EspecialidadMapper {
    static func toDomain(from dto: EspecialidadDTO) -> Especialidad {
        Especialidad(
            id: dto.id,
            nombre: dto.nombre,
            descripcion: dto.descripcion,
            activo: dto.activo
        )
    }
}
