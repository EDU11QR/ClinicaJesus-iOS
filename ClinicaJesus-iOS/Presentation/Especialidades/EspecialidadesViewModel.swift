//
//  EspecialidadesViewModel.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation

@MainActor
final class EspecialidadesViewModel {
    private let getSpecialtiesUseCase: GetSpecialtiesUseCase

    private(set) var specialties: [Especialidad] = []

    var onLoadingChange: ((Bool) -> Void)?
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?

    init(getSpecialtiesUseCase: GetSpecialtiesUseCase) {
        self.getSpecialtiesUseCase = getSpecialtiesUseCase
    }

    func loadSpecialties() {
        Task {
            onLoadingChange?(true)
            do {
                let specialties = try await getSpecialtiesUseCase.execute()
                self.specialties = specialties
                print("Especialidades en ViewModel: \(specialties.count)")
                onLoadingChange?(false)
                onSuccess?()
            } catch {
                print("Error cargando especialidades: \(error)")
                onLoadingChange?(false)
                onError?(error.localizedDescription)
            }
        }
    }

    func numberOfRows() -> Int {
        specialties.count
    }

    func specialty(at index: Int) -> Especialidad {
        specialties[index]
    }
}
