//
//  RegisterPacienteViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import UIKit

final class RegisterPacienteViewController: UIViewController {
    
    private let viewModel: RegisterPacienteViewModel
    
    //-------
    var onUserCreated: (() -> Void)?
    var isAdminMode: Bool = false
    
    private let nombreField = UITextField()
    private let apellidoField = UITextField()
    private let correoField = UITextField()
    private let telefonoField = UITextField()
    private let passwordField = UITextField()
    private let registerButton = UIButton(type: .system)
    
    init(viewModel: RegisterPacienteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        //---------------
        title = isAdminMode ? "Nuevo Usuario" : "Crear cuenta"
        
        configure(nombreField, placeholder: "Nombre")
        configure(apellidoField, placeholder: "Apellido")
        configure(correoField, placeholder: "Correo")
        configure(telefonoField, placeholder: "Teléfono")
        configure(passwordField, placeholder: "Contraseña")
        
        correoField.keyboardType = .emailAddress
        telefonoField.keyboardType = .phonePad
        passwordField.isSecureTextEntry = true
        //----------------
        registerButton.setTitle(isAdminMode ? "Registrar Usuario" : "Registrarme", for: .normal)
        registerButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [
            nombreField,
            apellidoField,
            correoField,
            telefonoField,
            passwordField,
            registerButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            nombreField.heightAnchor.constraint(equalToConstant: 44),
            apellidoField.heightAnchor.constraint(equalToConstant: 44),
            correoField.heightAnchor.constraint(equalToConstant: 44),
            telefonoField.heightAnchor.constraint(equalToConstant: 44),
            passwordField.heightAnchor.constraint(equalToConstant: 44),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configure(_ field: UITextField, placeholder: String) {
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
    }
    
    private func setupBindings() {
        viewModel.onSuccess = { [weak self] in
            guard let self else { return }
            
            if self.isAdminMode {
                self.onUserCreated?()
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            let alert = UIAlertController(
                title: "Cuenta creada",
                message: "Tu cuenta fue registrada correctamente. Ahora puedes iniciar sesión.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })
            
            self.present(alert, animated: true)
        }
        
        viewModel.onError = { [weak self] message in
            self?.showAlert(message)
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            self?.registerButton.isEnabled = !isLoading
            self?.registerButton.setTitle(
                isLoading ? "Registrando..." : (self?.isAdminMode == true ? "Registrar Usuario" : "Registrarme"),
                for: .normal
            )
        }
    }
    
    @objc private func didTapRegister() {
        viewModel.registrar(
            nombre: nombreField.text ?? "",
            apellido: apellidoField.text ?? "",
            correo: correoField.text ?? "",
            telefono: telefonoField.text ?? "",
            password: passwordField.text ?? ""
        )
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(
            title: "Aviso",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}
