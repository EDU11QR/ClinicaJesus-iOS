//
//  MisCitasViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import UIKit

final class MisCitasViewController: UIViewController {
    
    private let viewModel: MisCitasViewModel
    
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    
    init(viewModel: MisCitasViewModel) {
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
        viewModel.loadCitas()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = viewModel.title
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CitaCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.tableFooterView = UIView()
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No tienes citas registradas."
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
        
        viewModel.onCancelSuccess = { [weak self] in
            self?.showAlert(title: "Cita cancelada", message: "La cita fue cancelada correctamente.")
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

extension MisCitasViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cita = viewModel.cita(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitaCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(cita.doctorNombreCompleto) - \(cita.estado)"
        content.secondaryText = """
        \(cita.especialidadNombre)
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
            Doctor: \(cita.doctorNombreCompleto)
            Especialidad: \(cita.especialidadNombre)
            Fecha: \(cita.fecha)
            Hora: \(cita.horaInicio) - \(cita.horaFin)
            Estado: \(cita.estado)
            Motivo: \(cita.motivo)
            """,
            preferredStyle: .alert
        )
        
        if viewModel.canCancel(at: indexPath.row) {
            alert.addAction(UIAlertAction(title: "Cancelar cita", style: .destructive) { [weak self] _ in
                self?.confirmCancel(at: indexPath.row)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cerrar", style: .cancel))
        present(alert, animated: true)
    }

    private func confirmCancel(at index: Int) {
        let alert = UIAlertController(
            title: "Confirmar cancelación",
            message: "¿Seguro que deseas cancelar esta cita?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Sí, cancelar", style: .destructive) { [weak self] _ in
            self?.viewModel.cancelCita(at: index)
        })
        
        present(alert, animated: true)
    }
}
