//
//  EspecialidadesViewModel.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import Foundation

@MainActor
final class EspecialidadesViewModel {
    private let getSpecialtiesUseCase: GetSpecialtiesUseCase

    var onLoadingChange: ((Bool) -> Void)?
    var onSuccess: (([Especialidad]) -> Void)?
    var onError: ((String) -> Void)?

    init(getSpecialtiesUseCase: GetSpecialtiesUseCase) {
        self.getSpecialtiesUseCase = getSpecialtiesUseCase
    }

    func loadSpecialties() {
        Task {
            onLoadingChange?(true)
            do {
                let specialties = try await getSpecialtiesUseCase.execute()
                onLoadingChange?(false)
                onSuccess?(specialties)
            } catch {
                onLoadingChange?(false)
                onError?(error.localizedDescription)
            }
        }
    }
}
