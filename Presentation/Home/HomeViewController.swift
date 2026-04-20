//
//  HomeViewController.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import UIKit

final class HomeViewController: UIViewController {
    private let usuario: Usuario

    private let welcomeLabel = UILabel()
    private let roleLabel = UILabel()
    private let specialtiesButton = UIButton(type: .system)

    init(usuario: Usuario) {
        self.usuario = usuario
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Inicio"
        setupUI()
    }

    private func setupUI() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        roleLabel.translatesAutoresizingMaskIntoConstraints = false
        specialtiesButton.translatesAutoresizingMaskIntoConstraints = false

        welcomeLabel.textAlignment = .center
        roleLabel.textAlignment = .center

        welcomeLabel.font = .boldSystemFont(ofSize: 24)
        roleLabel.font = .systemFont(ofSize: 18)

        let nombreCompleto = [usuario.nombre, usuario.apellido]
            .compactMap { $0 }
            .joined(separator: " ")

        welcomeLabel.text = nombreCompleto.isEmpty
            ? "Bienvenido"
            : "Bienvenido, \(nombreCompleto)"

        roleLabel.text = "Rol: \(usuario.rol)"

        specialtiesButton.setTitle("Ver especialidades", for: .normal)
        specialtiesButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        specialtiesButton.addTarget(self, action: #selector(didTapSpecialties), for: .touchUpInside)

        view.addSubview(welcomeLabel)
        view.addSubview(roleLabel)
        view.addSubview(specialtiesButton)

        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            roleLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16),
            roleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            roleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            specialtiesButton.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 32),
            specialtiesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func didTapSpecialties() {
        let vc = DependencyContainer.shared.makeEspecialidadesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
