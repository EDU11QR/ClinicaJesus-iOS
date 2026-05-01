//
//  HorariosDoctorViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import UIKit

final class HorariosDoctorViewController: UIViewController {
    
    private let viewModel: HorariosDoctorViewModel
    
    // MARK: - UI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mis Horarios"
        label.font = .boldSystemFont(ofSize: 28)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Gestiona tu disponibilidad para atender pacientes"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+  Agregar Horario", for: .normal)
        btn.backgroundColor = .systemTeal
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        return btn
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()
    
    private let cardTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let tableView = UITableView()
    
    private let loading = UIActivityIndicatorView(style: .large)
    
    // MARK: - Init
    
    init(viewModel: HorariosDoctorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.cargarHorarios()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        
        addButton.addTarget(self, action: #selector(goToCreate), for: .touchUpInside)
        
        tableView.register(HorarioDoctorCell.self, forCellReuseIdentifier: HorarioDoctorCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        cardTitleLabel.text = "Horarios Registrados (0)"
        
        let fechaHeader = makeHeader("Fecha")
        let inicioHeader = makeHeader("Hora Inicio")
        let finHeader = makeHeader("Hora Fin")
        
        headerStack.addArrangedSubview(fechaHeader)
        headerStack.addArrangedSubview(inicioHeader)
        headerStack.addArrangedSubview(finHeader)
        
        [titleLabel, subtitleLabel, addButton, cardView, loading].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [cardTitleLabel, headerStack, tableView].forEach {
            cardView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            addButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            addButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            addButton.widthAnchor.constraint(equalToConstant: 180),
            
            cardView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            cardTitleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            cardTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            headerStack.topAnchor.constraint(equalTo: cardTitleLabel.bottomAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func makeHeader(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        
        viewModel.onHorariosChanged = { [weak self] in
            guard let self else { return }
            self.cardTitleLabel.text = "Horarios Registrados (\(self.viewModel.horarios.count))"
            self.tableView.reloadData()
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            guard let self else { return }
            isLoading ? self.loading.startAnimating() : self.loading.stopAnimating()
        }
        
        viewModel.onError = { [weak self] msg in
            self?.showAlert(msg)
        }
        
        viewModel.onDesactivarSuccess = { [weak self] in
            self?.showAlert("Horario desactivado correctamente")
        }
    }
    
    // MARK: - Navigation
    
    @objc private func goToCreate() {
        let vc = DependencyContainer.shared.makeCrearHorarioViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Utils
    
    private func showAlert(_ msg: String) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}

extension HorariosDoctorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HorarioDoctorCell.identifier,
            for: indexPath
        ) as? HorarioDoctorCell else {
            return UITableViewCell()
        }
        
        let horario = viewModel.horario(at: indexPath.row)
        cell.configure(with: horario)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let horario = viewModel.horario(at: indexPath.row)
        
        if horario.reservado {
            showAlert("Este horario está reservado y no puede modificarse.")
            return
        }
        
        let alert = UIAlertController(
            title: "Gestionar horario",
            message: """
            Fecha: \(horario.fecha)
            Hora: \(horario.horaInicio) - \(horario.horaFin)
            """,
            preferredStyle: .actionSheet
        )
        
        if horario.activo {
            alert.addAction(UIAlertAction(title: "Desactivar horario", style: .destructive) { [weak self] _ in
                self?.confirmarDesactivar(index: indexPath.row)
            })
        } else {
            alert.addAction(UIAlertAction(title: "Activar horario", style: .default) { [weak self] _ in
                self?.showAlert("Aún falta implementar activar horario en backend.")
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
    
    private func confirmarDesactivar(index: Int) {
        let alert = UIAlertController(
            title: "Confirmar desactivación",
            message: "¿Seguro que deseas desactivar este horario?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Sí, desactivar", style: .destructive) { [weak self] _ in
            self?.viewModel.desactivarHorario(at: index)
        })
        
        present(alert, animated: true)
    }
}
