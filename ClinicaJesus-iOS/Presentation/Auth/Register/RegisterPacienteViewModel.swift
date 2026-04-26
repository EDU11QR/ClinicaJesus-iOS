//
//  RegisterPacienteViewModel.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

@MainActor
final class RegisterPacienteViewModel {
    
    private let signUpPacienteUseCase: SignUpPacienteUseCase
    
    var onLoadingChanged: ((Bool) -> Void)?
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(signUpPacienteUseCase: SignUpPacienteUseCase) {
        self.signUpPacienteUseCase = signUpPacienteUseCase
    }
    
    func registrar(
        nombre: String,
        apellido: String,
        correo: String,
        telefono: String,
        password: String
    ) {
        let nombre = nombre.trimmingCharacters(in: .whitespacesAndNewlines)
        let apellido = apellido.trimmingCharacters(in: .whitespacesAndNewlines)
        let correo = correo.trimmingCharacters(in: .whitespacesAndNewlines)
        let telefono = telefono.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !nombre.isEmpty,
              !apellido.isEmpty,
              !correo.isEmpty,
              !telefono.isEmpty,
              !password.isEmpty else {
            onError?("Completa todos los campos.")
            return
        }
        
        guard password.count >= 6 else {
            onError?("La contraseña debe tener al menos 6 caracteres.")
            return
        }
        
        Task {
            onLoadingChanged?(true)
            
            do {
                let request = RegisterPacienteRequest(
                    nombre: nombre,
                    apellido: apellido,
                    correo: correo,
                    telefono: telefono,
                    password: password
                )
                
                _ = try await signUpPacienteUseCase.execute(request: request)
                onLoadingChanged?(false)
                onSuccess?()
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
}
