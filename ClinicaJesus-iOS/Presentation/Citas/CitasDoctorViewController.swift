//
//  CitasDoctorViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import UIKit

final class CitasDoctorViewController: UIViewController {
    
    private let viewModel: CitasDoctorViewModel
    
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    
    init(viewModel: CitasDoctorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.cargarCitas()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = viewModel.title
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CitaDoctorCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.tableFooterView = UIView()
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No tienes citas asignadas."
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.numberOfLines = 0
        emptyLabel.isHidden = true
        
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func setupBindings() {
        viewModel.onCitasChanged = { [weak self] in
            guard let self = self else { return }
            self.emptyLabel.isHidden = !self.viewModel.citas.isEmpty
            self.tableView.reloadData()
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
        }
        
        viewModel.onError = { [weak self] message in
            self?.showAlert(title: "Error", message: message)
        }
        
        viewModel.onEstadoChanged = { [weak self] in
            self?.showAlert(title: "Estado actualizado", message: "La cita fue actualizada correctamente.")
        }
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

extension CitasDoctorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cita = viewModel.cita(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitaDoctorCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(cita.pacienteNombreCompleto) - \(cita.estado)"
        content.secondaryText = """
        \(cita.fecha) | \(cita.horaInicio) - \(cita.horaFin)
        Motivo: \(cita.motivo)
        """
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cita = viewModel.cita(at: indexPath.row)
        
        let alert = UIAlertController(
            title: "Detalle de cita",
            message: """
            Paciente: \(cita.pacienteNombreCompleto)
            Correo: \(cita.pacienteCorreo)
            Fecha: \(cita.fecha)
            Hora: \(cita.horaInicio) - \(cita.horaFin)
            Estado actual: \(cita.estado)
            Motivo: \(cita.motivo)
            """,
            preferredStyle: .actionSheet
        )
        
        let estado = cita.estado.uppercased()

        if estado != "CANCELADA" && estado != "ATENDIDA" {
            alert.addAction(UIAlertAction(title: "Marcar CONFIRMADA", style: .default) { [weak self] _ in
                self?.viewModel.cambiarEstado(at: indexPath.row, nuevoEstado: "CONFIRMADA")
            })
            
            alert.addAction(UIAlertAction(title: "Marcar ATENDIDA", style: .default) { [weak self] _ in
                self?.viewModel.cambiarEstado(at: indexPath.row, nuevoEstado: "ATENDIDA")
            })
            
            alert.addAction(UIAlertAction(title: "Marcar CANCELADA", style: .destructive) { [weak self] _ in
                self?.viewModel.cambiarEstado(at: indexPath.row, nuevoEstado: "CANCELADA")
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cerrar", style: .cancel))
        
        present(alert, animated: true)
    }
}
