//
//  AdminDoctorMapper.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 26/04/26.
//

import Foundation

enum AdminDoctorMapper {
    static func toDomain(from dto: AdminDoctorDTO) -> AdminDoctor {
        AdminDoctor(
            id: dto.id,
            usuarioId: dto.usuario_id,
            especialidadId: dto.especialidad_id,
            cmp: dto.cmp,
            biografia: dto.biografia,
            activo: dto.activo,
            nombre: dto.nombre,
            apellido: dto.apellido,
            correo: dto.correo,
            telefono: dto.telefono,
            especialidadNombre: dto.especialidad_nombre
        )
    }
}
