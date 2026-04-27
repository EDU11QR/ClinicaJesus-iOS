//
//  AdminDoctorDTO.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 26/04/26.
//

import Foundation

struct AdminDoctorDTO: Decodable {
    let id: Int
    let usuario_id: Int
    let especialidad_id: Int
    let cmp: String?
    let biografia: String?
    let activo: Bool
    let nombre: String?
    let apellido: String?
    let correo: String?
    let telefono: String?
    let especialidad_nombre: String?
}
