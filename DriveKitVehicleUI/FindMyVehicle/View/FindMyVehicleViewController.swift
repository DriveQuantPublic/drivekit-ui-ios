//
//  FindMyVehicleViewController.swift
//  DriveKitVehicleUI
//
//  Created by Amine Gahbiche on 05/11/2025.
//  Copyright © 2025 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import MapKit

class FindMyVehicleViewController: DKUIViewController {
    @IBOutlet private weak var findVehicleView: UIView!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var itineraryButton: ButtonWithLeftIcon!
    @IBOutlet private weak var centerMapButton: UIButton!
    @IBOutlet private weak var noTripView: UIView!
    @IBOutlet private weak var noTripLabel: UILabel!
    @IBOutlet private weak var noTripLabelContainer: UIView!

    private var userAnnotation: MKPointAnnotation?
    private var vehicleAnnotation: MKPointAnnotation?
    // swiftlint:disable:next no_magic_numbers
    private let insets = UIEdgeInsets.init(top: 50, left: 50, bottom: 50, right: 50)
    private var routeRect: MKMapRect?
    private let viewModel: FindMyVehicleViewModel

    public init(viewModel: FindMyVehicleViewModel = FindMyVehicleViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: FindMyVehicleViewController.self), bundle: Bundle.vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "dk_find_vehicle_title".dkVehicleLocalized()
        if viewModel.lastLocationCoordinates != nil {
            itineraryButton.configure(title: "dk_find_vehicle_itinerary".dkVehicleLocalized(), style: .full)
            itineraryButton.titleLabel?.font = DKStyles.headLine1.style.applyTo(font: .primary)
            setupCenterMapButton()
            mapView.delegate = self
            updateVehicleAnnotation()
            setupLabels()
            view.embedSubview(findVehicleView)
            showLoader()
            viewModel.delegate = self
            viewModel.retrieveUserLocation()
            viewModel.retrieveLastLocationAddress()
        } else {
            setupNoLastTripLocationView()
            view.embedSubview(noTripView)
        }
    }

    private func setupNoLastTripLocationView() {
        self.noTripLabelContainer.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        self.noTripLabelContainer.backgroundColor = DKUIColors.neutralColor.color
        noTripLabel.text = "dk_find_vehicle_empty".dkVehicleLocalized()
        noTripLabel.font = DKStyles.normalText.style.applyTo(font: .primary)
        noTripLabel.textColor = DKUIColors.mainFontColor.color
    }

    private func setupCenterMapButton() {
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
    
    private func updateVehicleAnnotation(address: String? = nil) {
        if let lastLocationCoordinates = viewModel.lastLocationCoordinates {
            let annotation = MKPointAnnotation(coordinate: lastLocationCoordinates)
            if let vehicleAnnotation {
                self.mapView.removeAnnotation(vehicleAnnotation)
            }
            vehicleAnnotation = annotation
            self.mapView.addAnnotation(annotation)

            if viewModel.shouldDrawAccuracyCircle {
                let circle = MKCircle(center: lastLocationCoordinates, radius: viewModel.accuracyCircleRadius)
                mapView.addOverlay(circle)
            }
        }
    }

    private func updateUserAnnotation() {
        if let userLocationCoordinates = viewModel.userLocationCoordinates {
            let annotation = MKPointAnnotation(coordinate: userLocationCoordinates)
            userAnnotation = annotation
            self.mapView.addAnnotation(annotation)
        }
    }

    private func setupLabels() {
        dateLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        distanceLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        dateLabel.textColor = DKUIColors.mainFontColor.color
        distanceLabel.textColor = DKUIColors.mainFontColor.color
        dateLabel.text = viewModel.getDateLabelText()
    }

    private func updateDistanceLabel() {
        distanceLabel.text = viewModel.getDistanceLabelText()
    }

    @IBAction func openItineraryApp() {
        viewModel.openItineraryApp()
    }

    private func drawLinePath() {
        guard let userLocationCoordinates = viewModel.userLocationCoordinates,
              let lastLocationCoordinates = viewModel.lastLocationCoordinates else {
            return
        }
        var coordinates = [userLocationCoordinates, lastLocationCoordinates]
        // swiftlint:disable:next no_magic_numbers
        let geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: 2)
        mapView.addOverlay(geodesicPolyline)
        self.routeRect = geodesicPolyline.boundingMapRect
        centerMap()
    }

    @IBAction func centerMap() {
        guard let routeRect else {
            guard let lastLocationCoordinates = viewModel.lastLocationCoordinates else { return }
            // swiftlint:disable:next no_magic_numbers
            let camera = MKMapCamera(lookingAtCenter: lastLocationCoordinates, fromDistance: 1_000, pitch: 0, heading: 0)
            mapView.setCamera(camera, animated: true)
            return
        }
        mapView.setVisibleMapRect(routeRect, edgePadding: insets, animated: true)
    }
}

extension FindMyVehicleViewController: MKMapViewDelegate {
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
            if let address = viewModel.addressString {
                let label = UILabel()
                label.numberOfLines = 0
                label.text = address
                view.detailCalloutAccessoryView = label
            }
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
            circleRenderer.fillColor = DKUIColors.mapTraceColor.color.withAlphaComponent(0.1)
            circleRenderer.strokeColor = UIColor.lightGray.withAlphaComponent(0.4)
            circleRenderer.lineWidth = 0.5
            return circleRenderer
        } else {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = DKUIColors.mapTraceColor.color
            renderer.lineDashPattern = [2, 5]
            renderer.lineWidth = 3
            return renderer
        }
        // swiftlint:enable no_magic_numbers
    }
}

extension FindMyVehicleViewController: FindMyVehicleViewModelDelegate {
    func userLocationUpdateFinished() {
        updateUserAnnotation()
        updateDistanceLabel()
        if viewModel.userLocationCoordinates == nil {
            hideLoader()
            centerMap()
        }
    }
    
    func addressGeocodingFinished() {
        updateVehicleAnnotation(address: viewModel.addressString)
    }
    
    func directionsRequestFinished() {
        hideLoader()
        
        if let polyline = viewModel.polyLine {
            mapView.addOverlay(polyline, level: MKOverlayLevel.aboveRoads)
            if let rect = viewModel.computeMapRect() {
                self.routeRect = rect
            }
            centerMap()
        } else {
            drawLinePath()
        }
    }
}

class ButtonWithLeftIcon: UIButton {
    let verticalPadding: CGFloat = 5
    let horizontalEdgePadding: CGFloat = 16
    let horizontalSpacePadding: CGFloat = 8
    let imageWidth: CGFloat = 25

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setImage(DKVehicleImages.itinerary.image?.resizeImage(imageWidth, opaque: false), for: .normal)
        self.setImage(DKVehicleImages.itinerary.image?.resizeImage(imageWidth, opaque: false), for: .highlighted)
        if #available(iOS 15.0, *) {
            self.configuration = UIButton.Configuration.filled()
            self.configuration?.baseBackgroundColor = DKUIColors.secondaryColor.color
            self.configuration?.baseForegroundColor = .white
            self.configuration?.cornerStyle = .capsule
            self.configuration?.imagePlacement = .leading
            self.configuration?.imagePadding = 8.0
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        guard imageView != nil else {
            return
        }
        if #unavailable(iOS 15.0) {
            imageEdgeInsets = UIEdgeInsets(
                top: verticalPadding,
                left: horizontalEdgePadding,
                bottom: verticalPadding,
                right: bounds.width - imageWidth - horizontalEdgePadding
            )
            titleEdgeInsets = UIEdgeInsets(
                top: verticalPadding,
                left: horizontalEdgePadding,
                bottom: verticalPadding,
                right: horizontalEdgePadding
            )
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        if #unavailable(iOS 15.0) {
            let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
            let desiredButtonSize = CGSize(
                width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right + imageWidth + horizontalSpacePadding,
                height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom
            )
            return desiredButtonSize
        } else {
            return super.intrinsicContentSize
        }
    }
}
