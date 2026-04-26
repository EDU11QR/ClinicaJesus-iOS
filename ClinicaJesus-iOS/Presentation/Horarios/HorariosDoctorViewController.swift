//
//  HorariosDoctorViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import UIKit

final class HorariosDoctorViewController: UIViewController {
    
    private let viewModel: HorariosDoctorViewModel
    
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    
    init(viewModel: HorariosDoctorViewModel) {
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
        viewModel.cargarHorarios()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = viewModel.title
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HorarioDoctorCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 90
        tableView.tableFooterView = UIView()
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No tienes horarios registrados."
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
        viewModel.onHorariosChanged = { [weak self] in
            guard let self = self else { return }
            self.emptyLabel.isHidden = !self.viewModel.horarios.isEmpty
            self.tableView.reloadData()
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
        }
        
        viewModel.onError = { [weak self] message in
            self?.showAlert(title: "Error", message: message)
        }
        
        viewModel.onDesactivarSuccess = { [weak self] in
            self?.showAlert(title: "Horario eliminado", message: "El horario fue desactivado correctamente.")
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

extension HorariosDoctorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let horario = viewModel.horario(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "HorarioDoctorCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(horario.fecha) | \(horario.horaInicio) - \(horario.horaFin)"
        if horario.reservado {
            content.secondaryText = "Reservado"
        } else if horario.activo {
            content.secondaryText = "Disponible"
        } else {
            content.secondaryText = "Inactivo"
        }
        cell.contentConfiguration = content
        cell.accessoryType = horario.activo ? .disclosureIndicator : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let horario = viewModel.horario(at: indexPath.row)
        
        if horario.reservado {
            showAlert(
                title: "No permitido",
                message: "Este horario ya tiene una cita asociada y no puede desactivarse."
            )
            return
        }

        guard horario.activo else { return }
        
        let alert = UIAlertController(
            title: "Horario",
            message: """
            Fecha: \(horario.fecha)
            Hora: \(horario.horaInicio) - \(horario.horaFin)
            """,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Desactivar horario", style: .destructive) { [weak self] _ in
            self?.confirmarDesactivar(index: indexPath.row)
        })
        
        alert.addAction(UIAlertAction(title: "Cerrar", style: .cancel))
        present(alert, animated: true)
    }
    
    private func confirmarDesactivar(index: Int) {
        let alert = UIAlertController(
            title: "Confirmar",
            message: "¿Seguro que deseas desactivar este horario?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Sí, desactivar", style: .destructive) { [weak self] _ in
            self?.viewModel.desactivarHorario(at: index)
        })
        
        present(alert, animated: true)
    }
}
