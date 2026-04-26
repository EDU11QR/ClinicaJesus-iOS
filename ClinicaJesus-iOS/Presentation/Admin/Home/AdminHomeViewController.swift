//
//  AdminHomeViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import UIKit

final class AdminHomeViewController: UIViewController {
    
    private let container = DependencyContainer.shared
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Panel Administrador"
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .label
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Gestiona usuarios, doctores, pacientes y especialidades"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let usersButton = AdminMenuButton(
        title: "Gestión de Usuarios",
        subtitle: "Ver usuarios, cambiar roles y desactivar cuentas",
        icon: "person.3.fill"
    )
    
    private let specialtiesButton = AdminMenuButton(
        title: "Especialidades",
        subtitle: "Crear y administrar especialidades médicas",
        icon: "stethoscope"
    )
    
    private let logoutButton = AdminMenuButton(
        title: "Cerrar sesión",
        subtitle: "Salir de la cuenta administrador",
        icon: "rectangle.portrait.and.arrow.right",
        isDestructive: true
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGray6
        navigationItem.hidesBackButton = true
        
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            usersButton,
            specialtiesButton,
            logoutButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 18
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        usersButton.addTarget(self, action: #selector(openUsers), for: .touchUpInside)
        specialtiesButton.addTarget(self, action: #selector(openSpecialties), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    @objc private func openUsers() {
        let vc = container.makeAdminUsuariosViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func openSpecialties() {
        let vc = container.makeAdminEspecialidadesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func logout() {
        Task {
            do {
                try await DependencyContainer.shared.signOutUseCase.execute()
                
                await MainActor.run {
                    let loginVC = DependencyContainer.shared.makeLoginViewController()
                    navigationController?.setViewControllers([loginVC], animated: true)
                }
            } catch {
                await MainActor.run {
                    showAlert(title: "Error", message: "No se pudo cerrar sesión.")
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}
