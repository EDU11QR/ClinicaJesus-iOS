//
//  CitasDoctorViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import UIKit

final class CitasDoctorViewController: UIViewController {
    
    private let viewModel: CitasDoctorViewModel
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mis citas"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .label
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Gestiona las citas asignadas a tu agenda"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    
    init(viewModel: CitasDoctorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) no ha sido implementado")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.cargarCitas()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        title = viewModel.title
        
        tableView.register(CitaDoctorCell.self, forCellReuseIdentifier: CitaDoctorCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 135
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        loadingIndicator.hidesWhenStopped = true
        
        emptyLabel.text = "No tienes citas asignadas."
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.numberOfLines = 0
        emptyLabel.isHidden = true
        
        [titleLabel, subtitleLabel, tableView, loadingIndicator, emptyLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 18),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func setupBindings() {
        viewModel.onCitasChanged = { [weak self] in
            guard let self else { return }
            self.emptyLabel.isHidden = !self.viewModel.citas.isEmpty
            self.tableView.reloadData()
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            guard let self else { return }
            isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
        }
        
        viewModel.onError = { [weak self] message in
            self?.showAlert(title: "Error", message: message)
        }
        
        viewModel.onEstadoChanged = { [weak self] in
            self?.showAlert(title: "Estado actualizado", message: "La cita fue actualizada correctamente.")
        }
    }
    
    private func showDetalleCita(_ cita: CitaDoctor, index: Int) {
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
                self?.viewModel.cambiarEstado(at: index, nuevoEstado: "CONFIRMADA")
            })
            
            alert.addAction(UIAlertAction(title: "Marcar ATENDIDA", style: .default) { [weak self] _ in
                self?.viewModel.cambiarEstado(at: index, nuevoEstado: "ATENDIDA")
            })
            
            alert.addAction(UIAlertAction(title: "Marcar CANCELADA", style: .destructive) { [weak self] _ in
                self?.viewModel.cambiarEstado(at: index, nuevoEstado: "CANCELADA")
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cerrar", style: .cancel))
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

extension CitasDoctorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CitaDoctorCell.identifier,
            for: indexPath
        ) as? CitaDoctorCell else {
            return UITableViewCell()
        }
        
        let cita = viewModel.cita(at: indexPath.row)
        cell.configure(with: cita)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cita = viewModel.cita(at: indexPath.row)
        showDetalleCita(cita, index: indexPath.row)
    }
}
