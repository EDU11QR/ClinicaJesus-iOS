//
//  AdminEspecialidadesViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import UIKit

final class AdminEspecialidadesViewController: UIViewController {
    
    private let viewModel: AdminEspecialidadesViewModel
    
    init(viewModel: AdminEspecialidadesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) no ha sido implementado")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Especialidades"
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Administra las especialidades médicas disponibles"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let newButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Nueva Especialidad", for: .normal)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.backgroundColor = .systemTeal
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 14
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return button
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "Listado (0)"
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Buscar especialidad..."
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTable()
        setupBindings()
        viewModel.cargarEspecialidades()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        title = "Especialidades"
        
        newButton.addTarget(self, action: #selector(didTapNew), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(searchChanged), for: .editingChanged)
        
        [titleLabel, subtitleLabel, newButton, cardView, activityIndicator].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [countLabel, searchTextField, tableView].forEach {
            cardView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            // TITLE
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // SUBTITLE
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // BUTTON (BAJA DEBAJO, NO AL COSTADO)
            newButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 14),
            newButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            newButton.widthAnchor.constraint(equalToConstant: 210),
            newButton.heightAnchor.constraint(equalToConstant: 44),
            
            // CARD
            cardView.topAnchor.constraint(equalTo: newButton.bottomAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            // COUNT
            countLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            countLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            countLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            // SEARCH
            searchTextField.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 42),
            
            // TABLE
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            // LOADING
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTable() {
        tableView.register(AdminEspecialidadCell.self, forCellReuseIdentifier: AdminEspecialidadCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 96
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
    }
    
    private func setupBindings() {
        viewModel.onDataChanged = { [weak self] in
            guard let self else { return }
            self.countLabel.text = "Listado (\(self.viewModel.numberOfRows()))"
            self.tableView.reloadData()
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
        
        viewModel.onError = { [weak self] message in
            self?.showAlert(title: "Error", message: message)
        }
        
        viewModel.onSuccessMessage = { [weak self] message in
            self?.showAlert(title: "Correcto", message: message)
        }
    }
    
    @objc private func searchChanged() {
        viewModel.buscar(texto: searchTextField.text ?? "")
    }
    
    @objc private func didTapNew() {
        showEspecialidadForm(especialidad: nil)
    }
    
    private func showEspecialidadForm(especialidad: Especialidad?) {
        let isEditing = especialidad != nil
        
        let alert = UIAlertController(
            title: isEditing ? "Editar especialidad" : "Nueva especialidad",
            message: isEditing ? "Modifica los datos" : "Completa los datos",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Nombre"
            textField.text = especialidad?.nombre
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Descripción"
            textField.text = especialidad?.descripcion
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Precio consulta"
            textField.keyboardType = .decimalPad
            if let precio = especialidad?.precio {
                textField.text = "\(precio)"
            }
        }
        
        if isEditing {
            alert.addAction(UIAlertAction(
                title: (especialidad?.activo ?? true) ? "Desactivar" : "Activar",
                style: .default
            ) { [weak self] _ in
                guard let self, let especialidad else { return }
                let nombre = alert.textFields?[0].text ?? ""
                let descripcion = alert.textFields?[1].text ?? ""
                let precio = alert.textFields?[2].text ?? ""
                
                self.viewModel.editar(
                    especialidad: especialidad,
                    nombre: nombre,
                    descripcion: descripcion,
                    precioTexto: precio,
                    activo: !(especialidad.activo)
                )
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        alert.addAction(UIAlertAction(title: isEditing ? "Guardar" : "Crear", style: .default) { [weak self] _ in
            guard let self else { return }
            let nombre = alert.textFields?[0].text ?? ""
            let descripcion = alert.textFields?[1].text ?? ""
            let precio = alert.textFields?[2].text ?? ""
            
            if let especialidad {
                self.viewModel.editar(
                    especialidad: especialidad,
                    nombre: nombre,
                    descripcion: descripcion,
                    precioTexto: precio,
                    activo: especialidad.activo
                )
            } else {
                self.viewModel.crear(
                    nombre: nombre,
                    descripcion: descripcion,
                    precioTexto: precio
                )
            }
        })
        
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}

extension AdminEspecialidadesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AdminEspecialidadCell.identifier,
            for: indexPath
        ) as? AdminEspecialidadCell else {
            return UITableViewCell()
        }
        
        let especialidad = viewModel.especialidad(at: indexPath.row)
        cell.configure(especialidad: especialidad)
        
        cell.onEditTapped = { [weak self] in
            self?.showEspecialidadForm(especialidad: especialidad)
        }
        
        return cell
    }
}
