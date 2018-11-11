//
//  MapView.swift
//  m-ios-client
//
//  Created by Denis Morozov on 10.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import Foundation
import MapKit

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

class MapView: MKMapView, MKMapViewDelegate, CLLocationManagerDelegate {

    let mkMap = MKMapView()

    var locationManager = CLLocationManager()
    var needMoveCameraToUser = false

    var mapObjects: Sh_Generated_MapObjectResponse? {
        didSet {
            mkMap.removeAnnotations(mkMap.annotations)

            if let mapObjects = mapObjects {

                var annotations: [MKAnnotation] = []

                mapObjects.shelters.forEach({ shelter in
                    let annotation = ShelterAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: shelter.shelter.coordinate.lat,
                                                                   longitude: shelter.shelter.coordinate.lon)
                    annotation.shelter = shelter
                    annotations.append(annotation)
                })

                mapObjects.venues.forEach({ venue in
                    let annotation = VenueAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: venue.venue.coordinate.lat,
                                                                   longitude: venue.venue.coordinate.lon)
                    annotation.venue = venue
                    annotations.append(annotation)
                })

                mkMap.addAnnotations(annotations)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        mkMap.translatesAutoresizingMaskIntoConstraints = false
        mkMap.delegate = self
        mkMap.showsUserLocation = true
        addSubview(mkMap)

        mkMap.snp.makeConstraints { maker in
            maker.edges.equalTo(self)
        }

        let me = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        me.image = UIImage(named: "my-location")
        me.translatesAutoresizingMaskIntoConstraints = false
        me.isUserInteractionEnabled = true
        addSubview(me)
        me.snp.makeConstraints { maker in
            maker.trailing.equalTo(self).offset(-16)
            maker.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(MapView.myLocation(sender:)))
        me.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func myLocation(sender: Any?) {
        mkMap.setRegion(.init(center: mkMap.userLocation.coordinate,
                                span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05)),
                          animated: true)
    }

    func cameraPositionToUser() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if (!mkMap.userLocation.isUpdating || mkMap.userLocation.location != nil) {
                myLocation(sender: nil)
            } else {
                needMoveCameraToUser = true
            }
        } else if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
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
            annotationView.badgeCount = annotationShetler.shelter.availableOrders.count
            annotationView.image = UIImage(named: annotationShetler.shelter.shelter.iconName)
            return annotationView
        } else  if let annotationVenue = annotation as? VenueAnnotation {
            let annotationView: VenueAnnotationView
            if let unwrapAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "VenueAnnotation") as? VenueAnnotationView {
                annotationView = unwrapAnnotationView
                annotationView.annotation = annotation
            } else {
                annotationView = VenueAnnotationView(annotation: annotation, reuseIdentifier: "VenueAnnotation")
            }
            annotationView.image = UIImage(named: annotationVenue.venue.venue.iconName)
            return annotationView
        }
        return nil
    }
}
