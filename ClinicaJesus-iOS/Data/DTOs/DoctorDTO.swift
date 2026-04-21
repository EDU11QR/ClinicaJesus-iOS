//
//  DoctorDTO.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation

struct DoctorDTO: Decodable {
    let id: Int
    let usuario_id: Int
    let especialidad_id: Int
    let usuarios: UsuarioDoctorDTO
}

struct UsuarioDoctorDTO: Decodable {
    let id: Int
    let nombre: String
    let apellido: String
    let correo: String
    let telefono: String?
}
