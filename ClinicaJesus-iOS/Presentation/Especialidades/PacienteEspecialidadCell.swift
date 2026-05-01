//
//  PacienteEspecialidadCell.swift
//  ClinicaJesus-iOS
//
//  Created by Anthony on 27/04/26.
//

import UIKit

final class PacienteEspecialidadCell: UITableViewCell {
    
    static let identifier = "PacienteEspecialidadCell"
    
    private let iconView = UIImageView()
    private let nombreLabel = UILabel()
    private let descripcionLabel = UILabel()
    private let precioLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        
        iconView.image = UIImage(systemName: "stethoscope")
        iconView.tintColor = .systemTeal
        
        nombreLabel.font = .boldSystemFont(ofSize: 16)
        
        descripcionLabel.font = .systemFont(ofSize: 13)
        descripcionLabel.textColor = .secondaryLabel
        descripcionLabel.numberOfLines = 2
        
        precioLabel.font = .boldSystemFont(ofSize: 14)
        precioLabel.textColor = .systemTeal
        
        let textStack = UIStackView(arrangedSubviews: [
            nombreLabel,
            descripcionLabel,
            precioLabel
        ])
        textStack.axis = .vertical
        textStack.spacing = 4
        
        let container = UIStackView(arrangedSubviews: [
            iconView,
            textStack
        ])
        container.spacing = 12
        container.alignment = .center
        
        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 28),
            
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(_ item: Especialidad) {
        nombreLabel.text = item.nombre
        descripcionLabel.text = item.descripcion ?? "Sin descripción"
        precioLabel.text = "S/ \(item.precio ?? 0)"
    }
}

