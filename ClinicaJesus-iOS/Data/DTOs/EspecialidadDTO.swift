//
//  EspecialidadDTO.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation

struct EspecialidadDTO: Decodable {
    let id: Int
    let nombre: String
    let descripcion: String?
    let activo: Bool
}
