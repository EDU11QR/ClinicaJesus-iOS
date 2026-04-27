//
//  AdminDoctor.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 26/04/26.
//

import Foundation

struct AdminDoctor {
    let id: Int
    let usuarioId: Int
    let especialidadId: Int
    let cmp: String?
    let biografia: String?
    let activo: Bool
    let nombre: String?
    let apellido: String?
    let correo: String?
    let telefono: String?
    let especialidadNombre: String?
    
    var nombreCompleto: String {
        "Dr. \((nombre ?? "").trimmingCharacters(in: .whitespacesAndNewlines)) \((apellido ?? "").trimmingCharacters(in: .whitespacesAndNewlines))"
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
