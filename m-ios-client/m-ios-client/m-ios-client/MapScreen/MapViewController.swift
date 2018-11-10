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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, FilterViewControllerDelegate {

    var mapView: MapView!

    let mapContoller = MapController()

    var mapObjects: Sh_Generated_MapObjectResponse? {
        didSet {
            filteredMapObjects = filter(mapObjects: mapObjects)
        }
    }

    var filteredMapObjects: Sh_Generated_MapObjectResponse? {
        didSet {
            mapView.mapObjects = filteredMapObjects
        }
    }

    var venueTagsCheked: Set<String> = Set()
    var taskTagsCheked: Set<String> = Set()

    private let presetMapObjects: Sh_Generated_MapObjectResponse?

    init(mapObjects: Sh_Generated_MapObjectResponse?) {
        presetMapObjects = mapObjects
        super.init(nibName: nil, bundle: nil)

        if presetMapObjects == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("filter", comment: ""),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(MapViewController.filterAction(sender:)))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = nil

        mapView = MapView(frame: view.bounds)
        mapView.showsUserLocation = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)

        mapView.cameraPositionToUser()

        if let presetMapObjects = presetMapObjects {
            mapObjects = presetMapObjects
        } else {
            mapContoller.allObjects { result in
                switch result {
                case .success(let mapObjects): self.mapObjects = mapObjects
                case .error(_): self.mapObjects = nil
                }
            }
        }
    }

    @objc func filterAction(sender: Any) {
        let filterVC = FilterViewController(venueTags: Set(mapObjects?.venues.flatMap({ $0.tags }) ?? []),
                                            venueTagsCheked: venueTagsCheked,
                                            taskTags: Set(mapObjects?.shelters.flatMap({ $0.availableOrders.flatMap({ $0.tags }) }) ?? []),
                                            taskTagsCheked: taskTagsCheked,
                                            style: .apply)
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

        if !taskTagsCheked.isEmpty {
            mapObjects.shelters = mapObjects.shelters
                .map { shelter in
                    var mappedShelter = shelter
                    mappedShelter.availableOrders = shelter.availableOrders.filter({ task in
                        return !Set(task.tags).intersection(taskTagsCheked).isEmpty
                    })
                    return mappedShelter
                }
                .filter { shelter in
                    return !shelter.availableOrders.isEmpty
            }
        }

        if !venueTagsCheked.isEmpty {
            mapObjects.venues = mapObjects.venues.filter { venue in
                return !Set(venueTagsCheked).intersection(venue.tags).isEmpty
            }
        }

        return mapObjects
    }
}
