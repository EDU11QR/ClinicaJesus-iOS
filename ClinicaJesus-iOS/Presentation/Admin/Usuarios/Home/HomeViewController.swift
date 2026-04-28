//
//  HomeViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let usuario: Usuario
    private let container = DependencyContainer.shared
    
    // HEADER
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .label
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // BUTTONS (cards)
    private let reservarButton = AdminMenuButton(
        title: "Reservar Cita",
        subtitle: "Agenda una nueva cita médica",
        icon: "calendar.badge.plus"
    )
    
    private let misCitasButton = AdminMenuButton(
        title: "Mis citas",
        subtitle: "Ver y gestionar tus citas",
        icon: "calendar"
    )
    
    private let verCitasDoctorButton = AdminMenuButton(
        title: "Mis citas",
        subtitle: "Ver citas asignadas",
        icon: "calendar"
    )
    
    private let crearHorarioButton = AdminMenuButton(
        title: "Crear horario",
        subtitle: "Agregar disponibilidad",
        icon: "clock.badge.plus"
    )
    
    private let misHorariosButton = AdminMenuButton(
        title: "Mis horarios",
        subtitle: "Ver horarios creados",
        icon: "clock"
    )
    
    private let logoutButton = AdminMenuButton(
        title: "Cerrar sesión",
        subtitle: "Salir de la cuenta",
        icon: "rectangle.portrait.and.arrow.right",
        isDestructive: true
    )
    
    // contacto
    private let contactoButton = AdminMenuButton(
        title: "Contacto",
        subtitle: "WhatsApp y ubicación de la clínica",
        icon: "message.fill"
    )
    
    init(usuario: Usuario) {
        self.usuario = usuario
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        navigationItem.hidesBackButton = true
        
        let nombreCompleto = [usuario.nombre, usuario.apellido]
            .compactMap { $0 }
            .joined(separator: " ")
        
        titleLabel.text = nombreCompleto.isEmpty
            ? "Bienvenido"
            : "Bienvenido, \(nombreCompleto)"
        
        //subtitleLabel.text = "Rol: \(usuario.rol)"
        if usuario.rol.uppercased() == "PACIENTE" {
            subtitleLabel.text = "Agenda y gestiona tus citas"
        } else if usuario.rol.uppercased() == "DOCTOR" {
            subtitleLabel.text = "Gestiona tus horarios y citas"
        } else {
            subtitleLabel.text = "Bienvenido al sistema"
        }
        
        
        var arrangedViews: [UIView] = [
            titleLabel,
            subtitleLabel
        ]
        
        if usuario.rol.uppercased() == "PACIENTE" {
            arrangedViews.append(contentsOf: [
                reservarButton,
                misCitasButton,
                contactoButton
            ])
        } else if usuario.rol.uppercased() == "DOCTOR" {
            arrangedViews.append(contentsOf: [
                verCitasDoctorButton,
                crearHorarioButton,
                misHorariosButton
            ])
        }
        
        arrangedViews.append(logoutButton)
        
        let stack = UIStackView(arrangedSubviews: arrangedViews)
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
        
        reservarButton.addTarget(self, action: #selector(didTapReservar), for: .touchUpInside)
        misCitasButton.addTarget(self, action: #selector(didTapMisCitas), for: .touchUpInside)
        
        verCitasDoctorButton.addTarget(self, action: #selector(didTapDoctorCitas), for: .touchUpInside)
        crearHorarioButton.addTarget(self, action: #selector(didTapCrearHorario), for: .touchUpInside)
        misHorariosButton.addTarget(self, action: #selector(didTapMisHorarios), for: .touchUpInside)
        
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        
        contactoButton.addTarget(self, action: #selector(didTapContacto), for: .touchUpInside)
    }
    
    // MARK: ACTIONS
    
    @objc private func didTapReservar() {
        let vc = container.makeEspecialidadesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapMisCitas() {
        let vc = container.makeMisCitasViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapContacto() {
        let vc = container.makePacienteContactoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapDoctorCitas() {
        let vc = container.makeCitasDoctorViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapCrearHorario() {
        let vc = container.makeCrearHorarioViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapMisHorarios() {
        let vc = container.makeHorariosDoctorViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapLogout() {
        Task {
            do {
                try await DependencyContainer.shared.signOutUseCase.execute()
                
                let loginVC = DependencyContainer.shared.makeLoginViewController()
                navigationController?.setViewControllers([loginVC], animated: true)
                
            } catch {
                showAlert("No se pudo cerrar sesión")
            }
        }
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}
