//
//  PacienteDoctorCell.swift
//  ClinicaJesus-iOS
//
//  Created by Anthony on 27/04/26.
//

import UIKit

final class PacienteDoctorCell: UITableViewCell {
    
    static let identifier = "PacienteDoctorCell"
    
    private let iconView = UIImageView()
    private let nombreLabel = UILabel()
    private let especialidadLabel = UILabel()
    private let cmpLabel = UILabel()
    private let bioLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        
        iconView.image = UIImage(systemName: "person.crop.circle.fill")
        iconView.tintColor = .systemTeal
        iconView.contentMode = .scaleAspectFit
        
        nombreLabel.font = .boldSystemFont(ofSize: 16)
        
        especialidadLabel.font = .systemFont(ofSize: 13)
        especialidadLabel.textColor = .secondaryLabel
        
        cmpLabel.font = .systemFont(ofSize: 12)
        cmpLabel.textColor = .secondaryLabel
        
        bioLabel.font = .systemFont(ofSize: 12)
        bioLabel.textColor = .secondaryLabel
        bioLabel.numberOfLines = 2
        
        let textStack = UIStackView(arrangedSubviews: [
            nombreLabel,
            especialidadLabel,
            cmpLabel,
            bioLabel
        ])
        
        textStack.axis = .vertical
        textStack.spacing = 3
        
        let container = UIStackView(arrangedSubviews: [
            iconView,
            textStack
        ])
        
        container.spacing = 12
        container.alignment = .top
        
        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(_ doctor: Doctor) {
        nombreLabel.text = doctor.nombreCompleto
        especialidadLabel.text = doctor.especialidadNombre
        cmpLabel.text = "CMP: \(doctor.cmp ?? "No registrado")"
        bioLabel.text = doctor.biografia ?? "Sin biografía"
    }
}
