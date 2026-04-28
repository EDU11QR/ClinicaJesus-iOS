//
//  PacienteContactoViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 27/04/26.
//

import UIKit
import MapKit
import CoreLocation

final class PacienteContactoViewController: UIViewController {
    
    private let clinicPhone = "51935315177"
    private let clinicAddress = "Clínica Jesus"
    
    private let clinicCoordinate = CLLocationCoordinate2D(
        latitude: -12.046374,
        longitude: -77.042793
    )
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Contacto"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .label
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Comunícate con la clínica o revisa nuestra ubicación"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let contactCard: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()
    
    private let phoneIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "phone.circle.fill"))
        imageView.tintColor = .systemTeal
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let phoneTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Atención por WhatsApp"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "+51 935 315 177"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let whatsappButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enviar mensaje por WhatsApp", for: .normal)
        button.backgroundColor = .systemTeal
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 14
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()
    
    private let mapCard: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()
    
    private let mapTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ubicación"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 16
        map.clipsToBounds = true
        return map
    }()
    
    private let openMapsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Abrir ubicación", for: .normal)
        button.setTitleColor(.systemTeal, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupMap()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        title = "Contacto"
        
        [titleLabel, subtitleLabel, contactCard, mapCard].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [phoneIcon, phoneTitleLabel, phoneLabel, whatsappButton].forEach {
            contactCard.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [mapTitleLabel, mapView, openMapsButton].forEach {
            mapCard.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            contactCard.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            contactCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contactCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            phoneIcon.topAnchor.constraint(equalTo: contactCard.topAnchor, constant: 20),
            phoneIcon.leadingAnchor.constraint(equalTo: contactCard.leadingAnchor, constant: 20),
            phoneIcon.widthAnchor.constraint(equalToConstant: 42),
            phoneIcon.heightAnchor.constraint(equalToConstant: 42),
            
            phoneTitleLabel.topAnchor.constraint(equalTo: phoneIcon.topAnchor),
            phoneTitleLabel.leadingAnchor.constraint(equalTo: phoneIcon.trailingAnchor, constant: 14),
            phoneTitleLabel.trailingAnchor.constraint(equalTo: contactCard.trailingAnchor, constant: -20),
            
            phoneLabel.topAnchor.constraint(equalTo: phoneTitleLabel.bottomAnchor, constant: 4),
            phoneLabel.leadingAnchor.constraint(equalTo: phoneTitleLabel.leadingAnchor),
            phoneLabel.trailingAnchor.constraint(equalTo: phoneTitleLabel.trailingAnchor),
            
            whatsappButton.topAnchor.constraint(equalTo: phoneIcon.bottomAnchor, constant: 20),
            whatsappButton.leadingAnchor.constraint(equalTo: contactCard.leadingAnchor, constant: 20),
            whatsappButton.trailingAnchor.constraint(equalTo: contactCard.trailingAnchor, constant: -20),
            whatsappButton.heightAnchor.constraint(equalToConstant: 50),
            whatsappButton.bottomAnchor.constraint(equalTo: contactCard.bottomAnchor, constant: -20),
            
            mapCard.topAnchor.constraint(equalTo: contactCard.bottomAnchor, constant: 20),
            mapCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mapCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mapCard.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            mapTitleLabel.topAnchor.constraint(equalTo: mapCard.topAnchor, constant: 20),
            mapTitleLabel.leadingAnchor.constraint(equalTo: mapCard.leadingAnchor, constant: 20),
            mapTitleLabel.trailingAnchor.constraint(equalTo: mapCard.trailingAnchor, constant: -20),
            
            mapView.topAnchor.constraint(equalTo: mapTitleLabel.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: mapCard.leadingAnchor, constant: 20),
            mapView.trailingAnchor.constraint(equalTo: mapCard.trailingAnchor, constant: -20),
            mapView.heightAnchor.constraint(equalToConstant: 240),
            
            openMapsButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 14),
            openMapsButton.centerXAnchor.constraint(equalTo: mapCard.centerXAnchor),
            openMapsButton.heightAnchor.constraint(equalToConstant: 44),
            openMapsButton.bottomAnchor.constraint(equalTo: mapCard.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupMap() {
        let region = MKCoordinateRegion(
            center: clinicCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        mapView.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = clinicCoordinate
        annotation.title = "Clínica Jesus"
        annotation.subtitle = "Ubicación de la clínica"
        mapView.addAnnotation(annotation)
    }
    
    private func setupActions() {
        whatsappButton.addTarget(self, action: #selector(didTapWhatsApp), for: .touchUpInside)
        openMapsButton.addTarget(self, action: #selector(didTapOpenMaps), for: .touchUpInside)
    }
    
    @objc private func didTapWhatsApp() {
        let message = "Hola, quisiera realizar una consulta."
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://wa.me/\(clinicPhone)?text=\(encodedMessage)"
        
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc private func didTapOpenMaps() {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: clinicCoordinate))
        mapItem.name = clinicAddress
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}
