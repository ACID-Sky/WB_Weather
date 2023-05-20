//
//  MapViewController.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 17.05.2023.
//

import UIKit
import CoreLocation
import MapKit

final class MapViewController: UIViewController {
    private lazy var coreDataLocationService = CoreDataLocationServiceImp(delegate: nil)

    private let cLLocationManager = CLLocationManager()
    private lazy var mapView = MKMapView()
    private lazy var buttonWithMenuMapType = UIButton()
    private lazy var buttonWithMenuRouteType = UIButton()
    private lazy var label = UILabel()

    private lazy var transportType: MKDirectionsTransportType = .any
    private lazy var directions: CLLocationCoordinate2D? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = BackgroundView()
        self.cLLocationManager.delegate = self
        self.requestAccessToLocation()
        self.setupLabel()
        self.setupButtonWithMenuMapType()
        self.setupButtonWithMenuRouteType()
        self.setupMapView()

        self.addLocationPins()
    }

    /// Проверяем доступ к локации телефона
    private func requestAccessToLocation() {

        let locationStatus = self.cLLocationManager.authorizationStatus

        switch locationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.cLLocationManager.requestLocation()
            self.mapView.showsUserLocation = true

        case .notDetermined, .denied, .restricted:
            self.cLLocationManager.stopUpdatingLocation()
            break

        @unknown default:
            break
        }
    }

    private func setupLabel() {
        let text = "MapViewController.label.text".localized
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.clipsToBounds = true
        self.label.numberOfLines = 0
        self.label.textColor = .black
        self.label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.label.textAlignment = .left
        self.label.text  = text

        self.view.addSubview(self.label)


        NSLayoutConstraint.activate([
            self.label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.label.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }

    private func setupButtonWithMenuMapType() {
        let first = UIAction(title: "MapViewController.mapView.mapType.standard".localized) { _ in
            self.mapView.mapType = .standard
        }
        let second = UIAction(title: "MapViewController.mapView.mapType.satellite".localized) { _ in
            self.mapView.mapType = .satellite
        }
        let third = UIAction(title: "MapViewController.mapView.mapType.hybrid".localized) { _ in
            self.mapView.mapType = .hybrid
        }
        let four = UIAction(title: "MapViewController.mapView.mapType.satelliteFlyover".localized) { _ in
            self.mapView.mapType = .satelliteFlyover
        }
        let fifth = UIAction(title: "MapViewController.mapView.mapType.mutedStandard".localized) { _ in
            self.mapView.mapType = .mutedStandard
        }

        let elements = [first, second, third, four, fifth]

        let title = "MapViewController.mapView.menuMapType".localized

        let menuMapType = UIMenu(title: title, children: elements)

        self.buttonWithMenuMapType.translatesAutoresizingMaskIntoConstraints = false
        self.buttonWithMenuMapType.backgroundColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)
        self.buttonWithMenuMapType.setTitle(title, for: .normal)
        self.buttonWithMenuMapType.showsMenuAsPrimaryAction = true
        self.buttonWithMenuMapType.menu = menuMapType

        self.view.addSubview(self.buttonWithMenuMapType)

        NSLayoutConstraint.activate([
            self.buttonWithMenuMapType.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.buttonWithMenuMapType.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -8),
            self.buttonWithMenuMapType.bottomAnchor.constraint(equalTo: self.label.topAnchor, constant: -16),
            self.buttonWithMenuMapType.heightAnchor.constraint(equalToConstant: 40)
        ])

        self.buttonWithMenuMapType.layer.cornerRadius = 8
        self.buttonWithMenuMapType.layer.borderWidth = 0.5
        self.buttonWithMenuMapType.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    private func setupButtonWithMenuRouteType() {
        let first = UIAction(title: "MapViewController.mapView.transportType.any".localized) { _ in
            self.transportType = .any
            self.addRoute(to: self.directions)
        }
        let second = UIAction(title: "MapViewController.mapView.transportType.automobile".localized) { _ in
            self.transportType = .automobile
            self.addRoute(to: self.directions)
        }
        let third = UIAction(title: "MapViewController.mapView.transportType.transit".localized) { _ in
            self.transportType = .transit
            self.addRoute(to: self.directions)
        }
        let four = UIAction(title: "MapViewController.mapView.transportType.walking".localized) { _ in
            self.transportType = .walking
            self.addRoute(to: self.directions)
        }

        let elements = [first, second, third, four]

        let title = "MapViewController.mapView.menuRouteType".localized

        let menuRouteType = UIMenu(title: title, children: elements)

        self.buttonWithMenuRouteType.translatesAutoresizingMaskIntoConstraints = false
        self.buttonWithMenuRouteType.backgroundColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)
        self.buttonWithMenuRouteType.setTitle(title, for: .normal)
        self.buttonWithMenuRouteType.showsMenuAsPrimaryAction = true
        self.buttonWithMenuRouteType.menu = menuRouteType

        self.view.addSubview(self.buttonWithMenuRouteType)

        NSLayoutConstraint.activate([
            self.buttonWithMenuRouteType.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.buttonWithMenuRouteType.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 8),
            self.buttonWithMenuRouteType.bottomAnchor.constraint(equalTo: self.label.topAnchor, constant: -16),
            self.buttonWithMenuRouteType.heightAnchor.constraint(equalToConstant: 40)
        ])

        self.buttonWithMenuRouteType.layer.cornerRadius = 8
        self.buttonWithMenuRouteType.layer.borderWidth = 0.5
        self.buttonWithMenuRouteType.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    private func setupMapView() {
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.clipsToBounds = true
        self.mapView.mapType = .hybridFlyover
        self.mapView.delegate = self

        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32),
            self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.mapView.bottomAnchor.constraint(equalTo: self.buttonWithMenuMapType.topAnchor, constant: -16)
        ])
        self.mapView.layer.cornerRadius = 16
    }

    private func addLocationPins() {
        guard let locations = self.coreDataLocationService.getObjects() , locations.count != 0 else {return}
        locations.forEach({
            let locationPin = MKPointAnnotation()
            guard let locationLatitude: Double =  Double($0.locationLatitude ?? ""), let locationLongitude: Double =  Double($0.locationLongitude ?? "") else { return }
            locationPin.coordinate = CLLocationCoordinate2D(latitude: locationLatitude, longitude: locationLongitude)
            locationPin.title = $0.locationName
            self.mapView.addAnnotation(locationPin)
        })

    }

    private func addRoute(to coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        let overlays = self.mapView.overlays
        self.mapView.removeOverlays(overlays)

        let directionRequest = MKDirections.Request()

        guard let sourceCoordinate = self.cLLocationManager.location?.coordinate else { return }

        let sourcePlaceMark = MKPlacemark(coordinate: sourceCoordinate)
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)

        let destinationPlaceMark = MKPlacemark(coordinate: coordinate)
        let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)

        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = self.transportType

        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] response, error -> Void in
            guard let self = self else {
                return
            }

            guard let response = response else {
                if error != nil {
                    let alert = Alerts().showAlert(
                        with: "MapViewController.alert.title".localized,
                        message: "MapViewController.alert.message".localized,
                        preferredStyle: .alert
                    )

                    self.present(alert, animated: true)
                }

                return
            }
            response.routes.forEach({
                self.mapView.addOverlay($0.polyline, level: .aboveRoads)

                let rect = $0.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            })

        }
    }

}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("🚨", error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.requestAccessToLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.first! as CLLocation
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 100000, longitudinalMeters: 10000)
        self.mapView.setRegion(region, animated: true)
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        self.addRoute(to: annotation.coordinate)
        self.directions = annotation.coordinate
    }

    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        self.directions = nil
        let overlays = self.mapView.overlays
        self.mapView.removeOverlays(overlays)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(overlay: overlay)

        renderer.strokeColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)

        renderer.lineWidth = 5.0

        return renderer
    }
}


