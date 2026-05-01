//
//  CitaDoctorCell.swift
//  ClinicaJesus-iOS
//
//  Created by Anthony on 30/04/26.
//

// admin (anthony@gmail.com 123456)
// paciente (paciente1@gmail.com 12345)
// doctor (jorge@gmail.com 12345)


import UIKit

final class CitaDoctorCell: UITableViewCell {
    
    static let identifier = "CitaDoctorCell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1.2
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()
    
    private let pacienteLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    
    private let estadoBadge: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    private let fechaLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let motivoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let correoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemTeal
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cardView.backgroundColor = .systemBackground
        cardView.layer.borderColor = UIColor.systemGray5.cgColor
        estadoBadge.backgroundColor = .systemGray
        estadoBadge.textColor = .white
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        [pacienteLabel, estadoBadge, fechaLabel, motivoLabel, correoLabel].forEach {
            cardView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            pacienteLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            pacienteLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            pacienteLabel.trailingAnchor.constraint(lessThanOrEqualTo: estadoBadge.leadingAnchor, constant: -8),
            
            estadoBadge.centerYAnchor.constraint(equalTo: pacienteLabel.centerYAnchor),
            estadoBadge.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            estadoBadge.heightAnchor.constraint(equalToConstant: 22),
            estadoBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 92),
            
            correoLabel.topAnchor.constraint(equalTo: pacienteLabel.bottomAnchor, constant: 4),
            correoLabel.leadingAnchor.constraint(equalTo: pacienteLabel.leadingAnchor),
            correoLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            
            fechaLabel.topAnchor.constraint(equalTo: correoLabel.bottomAnchor, constant: 6),
            fechaLabel.leadingAnchor.constraint(equalTo: pacienteLabel.leadingAnchor),
            fechaLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            
            motivoLabel.topAnchor.constraint(equalTo: fechaLabel.bottomAnchor, constant: 4),
            motivoLabel.leadingAnchor.constraint(equalTo: pacienteLabel.leadingAnchor),
            motivoLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            motivoLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14)
        ])
    }
    
    func configure(with cita: CitaDoctor) {
        pacienteLabel.text = cita.pacienteNombreCompleto
        correoLabel.text = cita.pacienteCorreo
        fechaLabel.text = "\(cita.fecha) | \(cita.horaInicio) - \(cita.horaFin)"
        motivoLabel.text = "Motivo: \(cita.motivo)"
        
        let estado = cita.estado.uppercased()
        estadoBadge.text = estado.capitalized
        
        applyEstadoStyle(estado)
    }
    
    private func applyEstadoStyle(_ estado: String) {
        switch estado {
        case "PENDIENTE":
            cardView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.10)
            cardView.layer.borderColor = UIColor.systemYellow.cgColor
            estadoBadge.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.25)
            estadoBadge.textColor = UIColor.systemOrange
            
        case "CONFIRMADA":
            cardView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.08)
            cardView.layer.borderColor = UIColor.systemGreen.cgColor
            estadoBadge.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.18)
            estadoBadge.textColor = UIColor.systemGreen
            
        case "CANCELADA":
            cardView.backgroundColor = UIColor.systemRed.withAlphaComponent(0.08)
            cardView.layer.borderColor = UIColor.systemRed.cgColor
            estadoBadge.backgroundColor = UIColor.systemRed.withAlphaComponent(0.14)
            estadoBadge.textColor = UIColor.systemRed
            
        case "ATENDIDA":
            cardView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.08)
            cardView.layer.borderColor = UIColor.systemBlue.cgColor
            estadoBadge.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.15)
            estadoBadge.textColor = UIColor.systemBlue
            
        default:
            cardView.backgroundColor = .systemBackground
            cardView.layer.borderColor = UIColor.systemGray5.cgColor
            estadoBadge.backgroundColor = UIColor.systemGray5
            estadoBadge.textColor = .secondaryLabel
        }
    }
}
