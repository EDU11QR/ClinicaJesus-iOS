//
//  suario.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation

struct Usuario {
    let id: Int
    let authUserId: UUID
    let nombre: String?
    let apellido: String?
    let correo: String
    let telefono: String?
    let rol: String
    let activo: Bool
}
