//
//  MapViewController.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 16/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import CoreLocation
import DriveKitDriverData
import MapKit


class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var adviceButton: UIButton!
    
    let inset = UIEdgeInsets.init(top: 66, left: 22, bottom: 22, right: 22)
    var viewModel: TripDetailViewModel
    
    var polyLine: MKPolyline?
    var distractionPolyLines: [MKPolyline]?
    
    var startAnnotation : MKPointAnnotation? = nil
    var endAnnotation: MKPointAnnotation? = nil
    
    var safetyAnnotations: [MKPointAnnotation]? = nil
    var distractionAnnotations: [MKPointAnnotation]? = nil
    
    var allAnnotations: [MKPointAnnotation]? = nil
    
    let lineWidth: CGFloat = 3.0
    
    let config : TripListViewConfig
    let detailConfig: TripDetailViewConfig
    
    init(viewModel: TripDetailViewModel, config: TripListViewConfig, detailConfig: TripDetailViewConfig) {
        self.viewModel = viewModel
        self.config = config
        self.detailConfig = detailConfig
        super.init(nibName: String(describing: MapViewController.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsCompass = false
        self.mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func traceRoute(mapItem: MapItem?) {
        adviceButton.isHidden = true
        if let route = viewModel.route {
            DispatchQueue.main.async {
                if let route = self.viewModel.route {
                    if (self.polyLine == nil){
                        self.polyLine = MKPolyline.init(coordinates: route.polyLine, count: route.numberOfCoordinates)
                        self.mapView.addOverlay(self.polyLine!, level: MKOverlayLevel.aboveRoads)
                    }
                }
                
                if (mapItem == .distraction || (self.viewModel.configurableMapItems.contains(.distraction) && mapItem == .interactiveMap)){
                    self.computeDistractionPolylines {
                        self.drawDistraction(route: route)
                    }
                }else{
                    if let distractionPolyLines = self.distractionPolyLines{
                        for distractionPolyline in distractionPolyLines {
                            self.mapView.removeOverlay(distractionPolyline)
                        }
                    }
                }
                self.drawStartEndMarker(route: route)
                self.drawMarker(mapItem: mapItem, route: route)
                self.fitPath()
            }
        }
    }
    
    private func computeDistractionPolylines(completion: @escaping () -> Void){
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            if let route = self.viewModel.route {
                if self.viewModel.configurableMapItems.contains(.distraction) && self.distractionPolyLines == nil{
                    self.distractionPolyLines = []
                    for distractionPolylinePart in route.distractionPolyLine {
                        let distractionPolyLine = MKPolyline.init(coordinates: distractionPolylinePart, count: distractionPolylinePart.count)
                        self.distractionPolyLines?.append(distractionPolyLine)
                    }
                }
            }
            completion()
        }
    }
    
    private func drawDistraction(route: Route){
        if  let distractionPolyLines = self.distractionPolyLines {
            for distractionPolyline in distractionPolyLines {
                if let line = self.polyLine {
                    self.mapView.insertOverlay(distractionPolyline, above: line)
                }else{
                     self.mapView.addOverlay(distractionPolyline, level: MKOverlayLevel.aboveRoads)
                }
            }
        }else{
            self.distractionPolyLines = []
            for distractionPolylinePart in route.distractionPolyLine {
                let distractionPolyLine = MKPolyline.init(coordinates: distractionPolylinePart, count: distractionPolylinePart.count)
                self.distractionPolyLines?.append(distractionPolyLine)
                if let line = self.polyLine {
                    self.mapView.insertOverlay(distractionPolyLine, above: line)
                }else{
                     self.mapView.addOverlay(distractionPolyLine, level: MKOverlayLevel.aboveRoads)
                }
            }
        }
    }
    
    private func drawMarker(mapItem: MapItem?, route: Route){
        if let mapItem = mapItem {
            switch mapItem {
            case .ecoDriving:
                cleanAllMarkers()
                cleanSafetyDistractionMarkers()
                break
            case .safety:
                cleanAllMarkers()
                drawSafetyMarker()
            case .distraction:
                cleanAllMarkers()
                drawDistractionMarker()
            case .interactiveMap:
                cleanSafetyDistractionMarkers()
                cleanStartEndMarkers()
                drawAllMarker()
            }
        } else {
            cleanAllMarkers()
            cleanSafetyDistractionMarkers()
        }
    }
    
    private func cleanSafetyDistractionMarkers(){
        if let distractionEvents = self.distractionAnnotations{
            self.mapView.removeAnnotations(distractionEvents)
        }
        if let safetyEvents = self.safetyAnnotations {
            self.mapView.removeAnnotations(safetyEvents)
        }
    }
    
    private func cleanStartEndMarkers(){
        if let start = self.startAnnotation{
            self.mapView.removeAnnotation(start)
            self.startAnnotation = nil
        }
        if let end = self.endAnnotation {
            self.mapView.removeAnnotation(end)
            self.endAnnotation = nil
        }
   }
    
    private func cleanAllMarkers(){
        if let all = self.allAnnotations{
            self.mapView.removeAnnotations(all)
        }
    }
    
    private func drawStartEndMarker(route: Route) {
        if startAnnotation == nil {
            let start = MKPointAnnotation()
            start.coordinate = route.startLocation
            self.mapView.addAnnotation(start)
            startAnnotation = start
        }
        
        if endAnnotation == nil {
            let end = MKPointAnnotation()
            end.coordinate = route.endLocation
            self.mapView.addAnnotation(end)
            self.endAnnotation = end
        }
    }
    
    private func drawSafetyMarker() {
        if safetyAnnotations == nil {
            self.safetyAnnotations = []
            self.viewModel.safetyEvents.forEach { safety in
                let annotation = MKPointAnnotation()
                annotation.coordinate = safety.position
                self.safetyAnnotations!.append(annotation)
                self.mapView.addAnnotation(annotation)
            }
        }else{
            self.safetyAnnotations?.forEach({ annotation in
                self.mapView.addAnnotation(annotation)
            })
        }
    }
    
    private func drawDistractionMarker() {
        if distractionAnnotations == nil {
            self.distractionAnnotations = []
            self.viewModel.distractionEvents.forEach { distractionEvent in
                let annotation = MKPointAnnotation()
                annotation.coordinate = distractionEvent.position
                self.distractionAnnotations!.append(annotation)
                self.mapView.addAnnotation(annotation)
            }
        }else{
            self.distractionAnnotations?.forEach({ annotation in
                self.mapView.addAnnotation(annotation)
            })
        }
    }
    
    private func drawAllMarker() {
        if allAnnotations == nil {
            self.allAnnotations = []
            self.viewModel.events.forEach { event in
                let annotation = MKPointAnnotation()
                annotation.coordinate = event.position
                self.allAnnotations!.append(annotation)
                self.mapView.addAnnotation(annotation)
            }
        }else{
            self.allAnnotations?.forEach({ annotation in
                self.mapView.addAnnotation(annotation)
            })
        }
    }
    
   func setupAdviceButton() {
        self.adviceButton.layer.cornerRadius = adviceButton.bounds.size.width / 2
        adviceButton.setTitle("", for: .normal)
        adviceButton.layer.masksToBounds = true
        adviceButton.backgroundColor = config.secondaryColor
        adviceButton.tintColor = .white
    }
    
    func zoomToEvent(event : TripEvent){
        self.zoom(to: event.position)
    }
    
    func zoom(to position: CLLocationCoordinate2D) {
        mapView.zoomIn(coordinate: position, withLevel: 200)
    }
    
    func fitPath() {
        DispatchQueue.main.async { [unowned self] in
            if let polyLine = self.polyLine {
                self.mapView.setVisibleMapRect(polyLine.boundingMapRect, edgePadding: self.inset, animated: true)
            }
        }
    }
    
    func updateTipsButton() {
        if let currentItem = self.viewModel.displayMapItem {
            self.adviceButton.isHidden = true
            let image = UIImage(named: currentItem.adviceImageID(), in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            self.adviceButton.setImage(image, for: .normal)
            self.adviceButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
}

extension MapViewController: MapViewControllerDelegate {
    func didUpdateMapItem() {
        traceRoute(mapItem: viewModel.displayMapItem)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay === self.polyLine {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = detailConfig.mapTrace
            polylineRenderer.lineWidth = self.lineWidth
            return polylineRenderer
        }
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = detailConfig.mapTraceWarningColor
        polylineRenderer.lineWidth = self.lineWidth
        return polylineRenderer
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let selection = view.annotation else {
            return
        }
        
        if let allEvents = allAnnotations as NSArray?{
            let indexForEvent = allEvents.index(of: selection)
            if indexForEvent != NSNotFound {
                self.viewModel.setSelectedEvent(position: indexForEvent)
                self.zoom(to: viewModel.events[indexForEvent].position)
            }
        }

        (view as! ResistantAnnotationView).resistantLayer.resistantZPosition = 1001
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let reuseIdentifier = "reuseIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = ResistantAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        
        let view = annotationView as! ResistantAnnotationView
        
        view.canShowCallout = true
        
       if annotation.isEqual(startAnnotation) {
            let startImage = UIImage(named: "dk_map_start_event", in: Bundle.driverDataUIBundle, compatibleWith: nil)
            view.image = startImage?.resizeImage(32, opaque: false, contentMode: .scaleAspectFit)
            view.resistantLayer.resistantZPosition = 1000
            let tripViewModel = viewModel
            if let start = tripViewModel.startEvent {
                var city = tripViewModel.trip!.departureCity
                if tripViewModel.trip!.departureAddress != "" {
                    city = tripViewModel.trip!.departureAddress
                }
                if city != nil {
                    view.setupAsTripEventCallout(with: start, location: city!, detailConfig: detailConfig, config: self.config)
                }
                else {
                    view.setupAsTripEventCallout(with: start, location: detailConfig.startText, detailConfig: detailConfig, config: self.config)
                }
            }
        }
        else if annotation.isEqual(endAnnotation) {
            let endImage = UIImage(named: "dk_map_end_event", in: Bundle.driverDataUIBundle, compatibleWith: nil)
            
            view.image = endImage?.resizeImage(32, opaque: false, contentMode: .scaleAspectFit)
            view.resistantLayer.resistantZPosition = 1000
            let tripViewModel = viewModel
            if let end = tripViewModel.endEvent {
                var city = tripViewModel.trip!.arrivalCity
                if tripViewModel.trip!.arrivalAddress != "" {
                    city = tripViewModel.trip!.arrivalAddress
                }
                if city != nil {
                    view.setupAsTripEventCallout(with: end, location: city!, detailConfig: detailConfig, config: self.config)
                }else {
                    view.setupAsTripEventCallout(with: end, location:detailConfig.endText, detailConfig: detailConfig, config: self.config)
                }
            }
        } else {
            if viewModel.displayMapItem != .interactiveMap {
                if let safetyEvents = safetyAnnotations as NSArray?{
                    let indexForSafetyEvent = safetyEvents.index(of: annotation)
                    if indexForSafetyEvent != NSNotFound {
                        let event = viewModel.safetyEvents[indexForSafetyEvent]
                        let image = event.getMapImageID()
                        view.image = UIImage(named: image, in: Bundle.driverDataUIBundle, compatibleWith: nil)
                        view.image = annotationView?.image?.resizeImage(36, opaque: false, contentMode: .scaleAspectFit)
                        view.centerOffset = CGPoint(x: 0, y: -(annotationView?.image?.size.height)! / 2)
                        view.resistantLayer.resistantZPosition = CGFloat(event.getZIndex())
                        view.setupAsTripEventCallout(with: event, location: "", detailConfig: detailConfig, config: config)
                        if let infoView = view.rightCalloutAccessoryView as! UIButton? {
                            infoView.tag = indexForSafetyEvent
                            infoView.addTarget(self, action: #selector(safetyInfoClicked), for: .touchUpInside)
                        }
                    }
                }
                
                if let distractionEvents = distractionAnnotations as NSArray? {
                    let indexForDistractionEvent = distractionEvents.index(of: annotation)
                    if indexForDistractionEvent != NSNotFound {
                        let event = viewModel.distractionEvents[indexForDistractionEvent]
                        view.image = UIImage(named: event.getMapImageID(), in: Bundle.driverDataUIBundle, compatibleWith: nil)
                        view.image = annotationView?.image?.resizeImage(36, opaque: false, contentMode: .scaleAspectFit)
                        view.centerOffset = CGPoint(x: 0, y: -(annotationView?.image?.size.height)! / 2)
                        view.setupAsTripEventCallout(with: event, location: "", detailConfig: detailConfig, config: config)
                        if let infoView = view.rightCalloutAccessoryView as! UIButton? {
                            infoView.tag = indexForDistractionEvent
                            infoView.addTarget(self, action: #selector(distractionInfoClicked), for: .touchUpInside)
                        }
                    }
                }
            } else {
                if let events = allAnnotations as NSArray?{
                    let indexForEvent = events.index(of: annotation)
                    if indexForEvent != NSNotFound {
                        let event = viewModel.events[indexForEvent]
                        let image = event.getMapImageID()
                        view.image = UIImage(named: image, in: Bundle.driverDataUIBundle, compatibleWith: nil)
                        view.image = annotationView?.image?.resizeImage(36, opaque: false, contentMode: .scaleAspectFit)
                        view.centerOffset = CGPoint(x: 0, y: -(annotationView?.image?.size.height)! / 2)
                        view.resistantLayer.resistantZPosition = CGFloat(event.getZIndex())
                        view.setupAsTripEventCallout(with: event, location: "", detailConfig: detailConfig, config: config)
                        if let infoView = view.rightCalloutAccessoryView as! UIButton?, event.type != .start && event.type != .end {
                            infoView.tag = indexForEvent
                            infoView.addTarget(self, action: #selector(allInfoClicked(_:)), for: .touchUpInside)
                        }
                    }
                }
            }
        }
        
        view.annotation = annotation
        return view
    }
    
    @objc private func safetyInfoClicked(_ sender: UIButton) {
        let safetyEvent = viewModel.safetyEvents[sender.tag]
        let alert = UIAlertController(title: safetyEvent.getTitle(detailConfig: detailConfig), message: safetyEvent.getExplanation(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: config.okText, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func distractionInfoClicked(_ sender: UIButton) {
        let distractionEvent = viewModel.distractionEvents[sender.tag]
        let alert = UIAlertController(title: distractionEvent.getTitle(detailConfig: detailConfig), message: distractionEvent.getExplanation(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:config.okText, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func allInfoClicked(_ sender: UIButton) {
        let event = viewModel.events[sender.tag]
        let alert = UIAlertController(title: event.getTitle(detailConfig: detailConfig), message: event.getExplanation(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:config.okText, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MKMapView{
    func zoomIn(coordinate: CLLocationCoordinate2D, withLevel level:CLLocationDistance = 10000){
        let camera =
            MKMapCamera(lookingAtCenter: coordinate, fromEyeCoordinate: coordinate, eyeAltitude: level)
        self.setCamera(camera, animated: true)
    }
}

protocol MapViewControllerDelegate {
    func didUpdateMapItem()
}
