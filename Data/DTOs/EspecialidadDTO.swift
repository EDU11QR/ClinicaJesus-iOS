//
//  EspecialidadDTO.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import Foundation

struct EspecialidadDTO: Decodable {
    let id: Int
    let nombre: String
    let descripcion: String?
    let activo: Bool
}
