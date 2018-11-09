//
//  ViewController.swift
//  m-ios-client
//
//  Created by Denis Morozov on 09.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class ShelterAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var shelter: Sh_Generated_ShelterMapObject = Sh_Generated_ShelterMapObject()
}

class VenueAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var venue: Sh_Generated_VenueMapObject = Sh_Generated_VenueMapObject()
}

class ShelterAnnotationView: MKAnnotationView {
    var badgeCount: Int = 0 {
        didSet {
            badgeLabel.text = "\(badgeCount)"
            badgeLabel.isHidden = badgeCount <= 0
        }
    }
    var iconImage: UIImage? {
        didSet {
            imageView.image = iconImage
        }
    }

    private let imageView = UIImageView()
    private let badgeLabel = UILabel()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(badgeLabel)
        badgeLabel.backgroundColor = .red
        badgeLabel.layer.masksToBounds = true
        badgeLabel.layer.cornerRadius = 8
        badgeLabel.textColor = .white
        badgeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        badgeLabel.textAlignment = .center
        badgeLabel.snp.makeConstraints { maker in
            maker.width.equalTo(16)
            maker.height.equalTo(16)
            maker.trailing.equalTo(self).offset(7)
            maker.top.equalTo(self).offset(-4)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VenueAnnotationView: MKAnnotationView {
    private let imageView = UIImageView()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, FilterViewControllerDelegate {

    var mapView: MKMapView!

    var locationManager = CLLocationManager()
    var needMoveCameraToUser = false

    let mapContoller = MapController()

    var mapObjects: Sh_Generated_MapObjectResponse? {
        didSet {
            filteredMapObjects = filter(mapObjects: mapObjects)
        }
    }

    var filteredMapObjects: Sh_Generated_MapObjectResponse? {
        didSet {
            mapView.removeAnnotations(mapView.annotations)

            if let mapObjects = filteredMapObjects {

                var annotations: [MKAnnotation] = []

                mapObjects.shelters.forEach({ shelter in
                    let annotation = ShelterAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: shelter.coordinate.latitude,
                                                                   longitude: shelter.coordinate.longitude)
                    annotation.shelter = shelter
                    annotations.append(annotation)
                })

                mapObjects.venues.forEach({ venue in
                    let annotation = VenueAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: venue.coordinate.latitude,
                                                                   longitude: venue.coordinate.longitude)
                    annotation.venue = venue
                    annotations.append(annotation)
                })

                mapView.addAnnotations(annotations)
            }
        }
    }

    var venueTagsCheked: Set<String> = Set()
    var taskTagsCheked: Set<String> = Set()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "filter",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(MapViewController.filterAction(sender:)))

        mapView = MKMapView(frame: view.bounds)
        mapView.showsUserLocation = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        view.addSubview(mapView)

        let me = UILabel(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        me.backgroundColor = .white
        me.translatesAutoresizingMaskIntoConstraints = false
        me.isUserInteractionEnabled = true
        me.textAlignment = .center
        me.text = "me"
        view.addSubview(me)
        me.snp.makeConstraints { maker in
            maker.trailing.equalTo(view).offset(-16)
            maker.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            maker.width.equalTo(44)
            maker.height.equalTo(44)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(MapViewController.myLocation(sender:)))
        me.addGestureRecognizer(tap)

        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if (!mapView.userLocation.isUpdating) {
                myLocation(sender: nil)
            } else {
                needMoveCameraToUser = true
            }
        } else if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }

        mapContoller.allObjects { result in
            switch result {
            case .success(let mapObjects): self.mapObjects = mapObjects
            case .error(_): self.mapObjects = nil
            }
        }
    }

    @objc func myLocation(sender: Any?) {
        mapView.setRegion(.init(center: mapView.userLocation.coordinate,
                                span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05)),
                          animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        myLocation(sender: nil)
        locationManager.delegate = nil
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if needMoveCameraToUser {
            needMoveCameraToUser = false
            myLocation(sender: nil)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotationShetler = annotation as? ShelterAnnotation {
            let annotationView: ShelterAnnotationView
            if let unwrapAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ShelterAnnotation") as? ShelterAnnotationView {
                annotationView = unwrapAnnotationView
                annotationView.annotation = annotation
            } else {
                annotationView = ShelterAnnotationView(annotation: annotation, reuseIdentifier: "ShelterAnnotation")
            }
            annotationView.badgeCount = annotationShetler.shelter.availableTasks.count
            annotationView.image = UIImage(named: annotationShetler.shelter.iconName)
            return annotationView
        } else  if let annotationVenue = annotation as? VenueAnnotation {
            let annotationView: VenueAnnotationView
            if let unwrapAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "VenueAnnotation") as? VenueAnnotationView {
                annotationView = unwrapAnnotationView
                annotationView.annotation = annotation
            } else {
                annotationView = VenueAnnotationView(annotation: annotation, reuseIdentifier: "VenueAnnotation")
            }
            annotationView.image = UIImage(named: annotationVenue.venue.iconName)
            return annotationView
        }
        return nil
    }

    @objc func filterAction(sender: Any) {
        let filterVC = FilterViewController(venueTags: Set(["veterinary clinic"]),
                                            venueTagsCheked: venueTagsCheked,
                                            taskTags: Set(["tag1", "tag2"]),
                                            taskTagsCheked: taskTagsCheked)
        filterVC.delegate = self
        navigationController?.pushViewController(filterVC, animated: true)
    }

    func filterViewControllerApplyFilters(_ controller: FilterViewController, venueTags: Set<String>, taskTags: Set<String>) {
        venueTagsCheked = venueTags
        taskTagsCheked = taskTags

        navigationController?.popToViewController(self, animated: true)

        self.filteredMapObjects = filter(mapObjects: mapObjects)
    }

    func filter(mapObjects: Sh_Generated_MapObjectResponse?) -> Sh_Generated_MapObjectResponse? {
        guard var mapObjects = mapObjects else {
            return nil
        }

        guard !taskTagsCheked.isEmpty || !venueTagsCheked.isEmpty else {
            return mapObjects
        }

        mapObjects.shelters = mapObjects.shelters
            .map { shelter in
                var mappedShelter = shelter
                mappedShelter.availableTasks = shelter.availableTasks.filter({ task in
                    return !Set(task.tags).intersection(taskTagsCheked).isEmpty
                })
                return mappedShelter
            }
            .filter { shelter in
                return !shelter.availableTasks.isEmpty
            }

        mapObjects.venues = mapObjects.venues.filter { venue in
            return !Set(venueTagsCheked).intersection(venue.tags).isEmpty
        }

        return mapObjects
    }
}
