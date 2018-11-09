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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ""

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("filter", comment: ""),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(MapViewController.filterAction(sender:)))

        mapView = MapView(frame: view.bounds)
        mapView.showsUserLocation = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)

        mapView.cameraPositionToUser()

        mapContoller.allObjects { result in
            switch result {
            case .success(let mapObjects): self.mapObjects = mapObjects
            case .error(_): self.mapObjects = nil
            }
        }
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

        if !taskTagsCheked.isEmpty {
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
        }

        if !venueTagsCheked.isEmpty {
            mapObjects.venues = mapObjects.venues.filter { venue in
                return !Set(venueTagsCheked).intersection(venue.tags).isEmpty
            }
        }

        return mapObjects
    }
}
