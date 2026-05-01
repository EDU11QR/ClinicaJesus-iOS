//
//  MisCitasViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import UIKit

final class MisCitasViewController: UIViewController {
    
    private let viewModel: MisCitasViewModel
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mis citas"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .label
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Consulta y gestiona tus citas médicas"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    
    init(viewModel: MisCitasViewModel) {
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
        viewModel.loadCitas()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        title = viewModel.title
        
        tableView.register(MisCitaCell.self, forCellReuseIdentifier: MisCitaCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 135
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        loadingIndicator.hidesWhenStopped = true
        
        emptyLabel.text = "No tienes citas registradas."
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
        
        viewModel.onCancelSuccess = { [weak self] in
            self?.showAlert(title: "Cita cancelada", message: "La cita fue cancelada correctamente.")
        }
    }
    
    private func showDetalleCita(_ cita: Appointment, index: Int) {
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
        
        if viewModel.canCancel(at: index) {
            alert.addAction(UIAlertAction(title: "Cancelar cita", style: .destructive) { [weak self] _ in
                self?.confirmCancel(at: index)
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
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MisCitaCell.identifier,
            for: indexPath
        ) as? MisCitaCell else {
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
