//
//  FindVehicleViewController.swift
//  DriveKitVehicleUI
//
//  Created by Amine Gahbiche on 05/11/2025.
//  Copyright © 2025 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import MapKit

class FindVehicleViewController: DKUIViewController {
    @IBOutlet private weak var findVehicleView: UIView!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var itineraryButton: UIButton!
    @IBOutlet private weak var centerMapButton: UIButton!
    @IBOutlet private weak var noTripView: UIView!
    @IBOutlet private weak var noTripLabel: UILabel!
    @IBOutlet private weak var noTripLabelContainer: UIView!

    private var userAnnotation: MKPointAnnotation?
    private var vehicleAnnotation: MKPointAnnotation?
    // swiftlint:disable:next no_magic_numbers
    private let insets = UIEdgeInsets.init(top: 50, left: 50, bottom: 50, right: 50)
    private var routeRect: MKMapRect?
    private let viewModel: FindVehicleViewModel

    public init(viewModel: FindVehicleViewModel = FindVehicleViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: FindVehicleViewController.self), bundle: Bundle.vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "dk_find_vehicle_title".dkVehicleLocalized()
        if viewModel.lastLocationCoordinates != nil {
            itineraryButton.configure(style: .full)
            itineraryButton.setTitle("dk_find_vehicle_itinerary".dkVehicleLocalized(), for: .normal)
            itineraryButton.titleLabel?.font = DKStyles.headLine1.style.applyTo(font: .primary)
            setupCenterMapButton()
            mapView.delegate = self
            updateVehicleAnnotation()
            viewModel.delegate = self
            viewModel.retrieveUserLocation()
            viewModel.retrieveLastLocationAddress()
            view.embedSubview(findVehicleView)
        } else {
            setupNoTripView()
            view.embedSubview(noTripView)
        }
    }

    func setupNoTripView() {
        self.noTripLabelContainer.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        self.noTripLabelContainer.backgroundColor = DKUIColors.neutralColor.color
        noTripLabel.text = "dk_find_vehicle_empty".dkVehicleLocalized()
        noTripLabel.font = DKStyles.normalText.style.applyTo(font: .primary)
        noTripLabel.textColor = DKUIColors.mainFontColor.color
    }

    func setupCenterMapButton() {
        centerMapButton.layer.borderColor = UIColor.black.cgColor
        let half = 0.5
        centerMapButton.layer.cornerRadius = centerMapButton.bounds.size.width * half
        centerMapButton.layer.masksToBounds = true
        centerMapButton.backgroundColor = .white
        centerMapButton.setImage(DKImages.centerMap.image, for: .normal)
        centerMapButton.tintColor = .black
        let margin: CGFloat = 12
        centerMapButton.imageEdgeInsets = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        centerMapButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func updateVehicleAnnotation() {
        if let lastLocationCoordinates = viewModel.lastLocationCoordinates {
            let annotation = MKPointAnnotation(coordinate: lastLocationCoordinates)
            annotation.title = viewModel.addressString
            vehicleAnnotation = annotation
            self.mapView.addAnnotation(annotation)

            if viewModel.shouldDrawAccuracyCircle {
                let circle = MKCircle(center: lastLocationCoordinates, radius: viewModel.accuracyCircleRadius)
                mapView.addOverlay(circle)
            }
        }
    }

    func updateUserAnnotation() {
        if let userLocationCoordinates = viewModel.userLocationCoordinates {
            let annotation = MKPointAnnotation(coordinate: userLocationCoordinates)
            self.mapView.addAnnotation(annotation)
            userAnnotation = annotation
        }
    }

    func updateLabels() {
        dateLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        distanceLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        dateLabel.textColor = DKUIColors.mainFontColor.color
        distanceLabel.textColor = DKUIColors.mainFontColor.color
        dateLabel.text = viewModel.getDateLabelText()
        distanceLabel.text = viewModel.getDistanceLabelText()
    }

    @IBAction func openItineraryApp() {
        viewModel.openItineraryApp()
    }
}

extension FindVehicleViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        let reuseIdentifier = "reuseIdentifier"
        let expectedImageSize: CGFloat = 32
        let view: MKAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        ?? MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        if let vehicleAnnotation, let displayedAnnotation = annotation as? MKPointAnnotation, displayedAnnotation == vehicleAnnotation {
            view.canShowCallout = true
            let targetImage = DKVehicleImages.targetLocation.image
            view.image = targetImage?.resizeImage(expectedImageSize, opaque: false, contentMode: .scaleAspectFit)
        } else {
            view.canShowCallout = false
            let userLocImage = DKVehicleImages.currentLocation.image
            view.image = userLocImage?.resizeImage(expectedImageSize, opaque: false, contentMode: .scaleAspectFit)
        }
        return view
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // swiftlint:disable no_magic_numbers
        if let circle = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: circle)
            circleRenderer.fillColor = UIColor.lightGray.withAlphaComponent(0.1)
            circleRenderer.strokeColor = UIColor.lightGray.withAlphaComponent(0.4)
            circleRenderer.lineWidth = 0.5
            return circleRenderer
        } else {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.dkMapTrace
            renderer.lineDashPattern = [2, 5]
            renderer.lineWidth = 3
            return renderer
        }
        // swiftlint:enable no_magic_numbers
    }
}

extension FindVehicleViewController: FindVehicleViewModelDelegate {
    func userLocationUpdateFinished() {
        updateUserAnnotation()
        updateLabels()
    }
    
    func addressGeocodingFinished() {
        updateVehicleAnnotation()
    }
    
    func directionsRequestFinished() {
        guard let polyLine = viewModel.polyLine else {
            drawLinePath()
            return
        }
        mapView.addOverlay(polyLine, level: MKOverlayLevel.aboveRoads)
        let rect = polyLine.boundingMapRect
        self.routeRect = rect
        centerMap()
    }

    func drawLinePath() {
        guard let userLocationCoordinates = viewModel.userLocationCoordinates,
              let lastLocationCoordinates = viewModel.lastLocationCoordinates else {
            return
        }
        var coordinates = [userLocationCoordinates, lastLocationCoordinates]
        // swiftlint:disable:next no_magic_numbers
        let geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: 2)
        mapView.addOverlay(geodesicPolyline)
        let rect = geodesicPolyline.boundingMapRect
        self.routeRect = rect
        centerMap()
    }

    @IBAction func centerMap() {
        guard let routeRect else { return }
        mapView.setVisibleMapRect(routeRect, edgePadding: insets, animated: true)
    }
}

extension UIColor {
    // swiftlint:disable:next no_magic_numbers
    public static let dkMapTrace = UIColor(hex: 0x116ea9)
}
