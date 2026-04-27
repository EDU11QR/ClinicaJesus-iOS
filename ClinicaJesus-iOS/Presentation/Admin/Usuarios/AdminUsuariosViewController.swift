//
//  AdminUsuariosViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import UIKit

final class AdminUsuariosViewController: UIViewController {
    
    private let viewModel: AdminUsuariosViewModel
    
    init(viewModel: AdminUsuariosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) no ha sido implementado")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Gestión de Usuarios"
        label.font = .boldSystemFont(ofSize: 30)
        label.numberOfLines = 2
        label.textColor = .label
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Directorio unificado de Pacientes, Doctores y Administradores"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        return label
    }()
    
    private let newUserButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Nuevo Usuario", for: .normal)
        button.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
        button.backgroundColor = .systemTeal
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 14
        return button
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()
    
    private let directoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Directorio (0)"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Buscar por nombre, email o usuario..."
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    
    private var filtroButtons: [UIButton] = []
    
    private let filtrosStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTable()
        setupBindings()
        viewModel.cargarDatos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.cargarDatos()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGray6
        
        newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(searchChanged), for: .editingChanged)
        
        [titleLabel, subtitleLabel, newUserButton, cardView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [directoryLabel, searchTextField, filtrosStack, tableView].forEach {
            cardView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupFilterButtons()
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: 210),
            
            newUserButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            newUserButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newUserButton.widthAnchor.constraint(equalToConstant: 155),
            newUserButton.heightAnchor.constraint(equalToConstant: 44),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            cardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            directoryLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            directoryLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            directoryLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            searchTextField.topAnchor.constraint(equalTo: directoryLabel.bottomAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 42),
            
            filtrosStack.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            filtrosStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            filtrosStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            filtrosStack.heightAnchor.constraint(equalToConstant: 36),
            
            tableView.topAnchor.constraint(equalTo: filtrosStack.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupFilterButtons() {
        let buttons = [
            crearBotonFiltro("Todos", action: #selector(filtroTodos)),
            crearBotonFiltro("Pac.", action: #selector(filtroPacientes)),
            crearBotonFiltro("Doc.", action: #selector(filtroDoctores)),
            crearBotonFiltro("Admin", action: #selector(filtroAdmins)),
            crearBotonFiltro("Act.", action: #selector(filtroActivos)),
            crearBotonFiltro("Inact.", action: #selector(filtroInactivos))
        ]
        
        filtroButtons = buttons
        buttons.forEach { filtrosStack.addArrangedSubview($0) }
        
        actualizarFiltroSeleccionado(buttons[0])
    }
    
    private func actualizarFiltroSeleccionado(_ selectedButton: UIButton) {
        filtroButtons.forEach { button in
            let isSelected = button == selectedButton
            button.backgroundColor = isSelected ? .systemTeal : .systemGray5
            button.setTitleColor(isSelected ? .white : .label, for: .normal)
        }
    }
    
    private func crearBotonFiltro(_ titulo: String, action: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(titulo, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        btn.backgroundColor = .systemGray5
        btn.setTitleColor(.label, for: .normal)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: action, for: .touchUpInside)
        return btn
    }
    
    private func setupTable() {
        tableView.register(AdminUsuarioCell.self, forCellReuseIdentifier: AdminUsuarioCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 105
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
    }
    
    private func setupBindings() {
        viewModel.onUsuariosChanged = { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                self.directoryLabel.text = "Directorio (\(self.viewModel.numberOfRows()))"
                self.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(title: "Error", message: message)
            }
        }
        
        viewModel.onSuccessMessage = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(title: "Correcto", message: message)
            }
        }
    }
    
    @objc private func searchChanged() {
        viewModel.buscar(texto: searchTextField.text ?? "")
    }
    
    @objc private func didTapNewUser() {
        let vc = DependencyContainer.shared.makeAdminRegisterUserViewController { [weak self] in
            self?.viewModel.cargarDatos()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //--------- FILTRO BOTONES
    
    @objc private func filtroTodos(_ sender: UIButton) {
        actualizarFiltroSeleccionado(sender)
        viewModel.aplicarFiltro(.todos)
    }

    @objc private func filtroPacientes(_ sender: UIButton) {
        actualizarFiltroSeleccionado(sender)
        viewModel.aplicarFiltro(.pacientes)
    }

    @objc private func filtroDoctores(_ sender: UIButton) {
        actualizarFiltroSeleccionado(sender)
        viewModel.aplicarFiltro(.doctores)
    }

    @objc private func filtroAdmins(_ sender: UIButton) {
        actualizarFiltroSeleccionado(sender)
        viewModel.aplicarFiltro(.admins)
    }

    @objc private func filtroActivos(_ sender: UIButton) {
        actualizarFiltroSeleccionado(sender)
        viewModel.aplicarFiltro(.activos)
    }

    @objc private func filtroInactivos(_ sender: UIButton) {
        actualizarFiltroSeleccionado(sender)
        viewModel.aplicarFiltro(.inactivos)
    }
    
//--------------------------------------------------------------------------
    
    
    private func confirmAdminChange(usuario: Usuario) {
        let alert = UIAlertController(
            title: "Confirmar cambio",
            message: "¿Seguro que deseas convertir a ADMIN a \(usuario.nombre ?? usuario.correo)?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirmar", style: .destructive) { [weak self] _ in
            self?.viewModel.cambiarRol(usuario: usuario, nuevoRol: "ADMIN", especialidadId: nil)
        })
        present(alert, animated: true)
    }
    
    private func confirmPatientChange(usuario: Usuario) {
        let alert = UIAlertController(
            title: "Confirmar cambio",
            message: "¿Seguro que deseas convertir a PACIENTE a \(usuario.nombre ?? usuario.correo)?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirmar", style: .destructive) { [weak self] _ in
            self?.viewModel.cambiarRol(usuario: usuario, nuevoRol: "PACIENTE", especialidadId: nil)
        })
        present(alert, animated: true)
    }
    
    private func showRoleOptions(usuario: Usuario) {
        if usuario.activo == false {
            showAlert(title: "Usuario inactivo", message: "Este usuario está desactivado. Primero debes activarlo.")
            return
        }
        
        let alert = UIAlertController(
            title: "Cambiar rol",
            message: "\(usuario.nombre ?? "") \(usuario.apellido ?? "")",
            preferredStyle: .actionSheet
        )

        if usuario.rol == "PACIENTE" {
            alert.addAction(UIAlertAction(title: "Doctor", style: .default) { [weak self] _ in
                self?.showSpecialtyOptions(usuario: usuario)
            })
            
            alert.addAction(UIAlertAction(title: "Admin", style: .default) { [weak self] _ in
                self?.confirmAdminChange(usuario: usuario)
            })
        } else if usuario.rol == "DOCTOR" {
            alert.addAction(UIAlertAction(title: "Admin", style: .default) { [weak self] _ in
                self?.confirmAdminChange(usuario: usuario)
            })
        } else if usuario.rol == "ADMIN" {
            alert.addAction(UIAlertAction(title: "Doctor", style: .default) { [weak self] _ in
                self?.showSpecialtyOptions(usuario: usuario)
            })
            
            alert.addAction(UIAlertAction(title: "Paciente", style: .default) { [weak self] _ in
                self?.confirmPatientChange(usuario: usuario)
            })
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showSpecialtyOptions(usuario: Usuario) {
        if usuario.activo == false { return }
        
        let alert = UIAlertController(
            title: "Seleccionar especialidad",
            message: "Necesaria para asignar rol Doctor",
            preferredStyle: .actionSheet
        )
        
        for especialidad in viewModel.especialidades {
            alert.addAction(UIAlertAction(title: especialidad.nombre, style: .default) { [weak self] _ in
                self?.viewModel.cambiarRol(
                    usuario: usuario,
                    nuevoRol: "DOCTOR",
                    especialidadId: especialidad.id
                )
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
    
    private func confirmChangeStatus(usuario: Usuario) {
        let nuevoEstado = !usuario.activo
        let accion = nuevoEstado ? "Activar" : "Desactivar"
        
        let alert = UIAlertController(
            title: "\(accion) usuario",
            message: "¿Seguro que deseas \(accion.lowercased()) a \(usuario.nombre ?? usuario.correo)?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: accion, style: nuevoEstado ? .default : .destructive) { [weak self] _ in
            self?.viewModel.cambiarEstadoUsuario(usuario: usuario, activo: nuevoEstado)
        })
        
        present(alert, animated: true)
    }
    
    private func showEditUsuarioForm(usuario: Usuario) {
        if usuario.activo == false {
            showAlert(title: "Usuario inactivo", message: "No puedes editar un usuario desactivado.")
            return
        }
        
        let alert = UIAlertController(
            title: "Editar usuario",
            message: "Modifica los datos",
            preferredStyle: .alert
        )
        
        alert.addTextField { tf in
            tf.placeholder = "Nombre"
            tf.text = usuario.nombre
        }
        
        alert.addTextField { tf in
            tf.placeholder = "Apellido"
            tf.text = usuario.apellido
        }
        
        alert.addTextField { tf in
            tf.placeholder = "Correo"
            tf.text = usuario.correo
            tf.keyboardType = .emailAddress
        }
        
        alert.addTextField { tf in
            tf.placeholder = "Teléfono"
            tf.text = usuario.telefono
            tf.keyboardType = .phonePad
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self else { return }
            
            self.viewModel.editarUsuario(
                usuario: usuario,
                nombre: alert.textFields?[0].text ?? "",
                apellido: alert.textFields?[1].text ?? "",
                correo: alert.textFields?[2].text ?? "",
                telefono: alert.textFields?[3].text ?? ""
            )
        })
        
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}

extension AdminUsuariosViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AdminUsuarioCell.identifier,
            for: indexPath
        ) as? AdminUsuarioCell else {
            return UITableViewCell()
        }
        
        let usuario = viewModel.usuario(at: indexPath.row)
        cell.configure(usuario: usuario)
        
        cell.onRoleTapped = { [weak self] in
            self?.showRoleOptions(usuario: usuario)
        }
        
        cell.onDeactivateTapped = { [weak self] in
            self?.confirmChangeStatus(usuario: usuario)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuario = viewModel.usuario(at: indexPath.row)
        showEditUsuarioForm(usuario: usuario)
    }
}
