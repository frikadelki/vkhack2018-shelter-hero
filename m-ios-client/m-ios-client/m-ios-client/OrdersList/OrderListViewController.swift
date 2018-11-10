//
//  OrderListViewController.swift
//  m-ios-client
//
//  Created by Denis Morozov on 10.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import Foundation
import UIKit

class OrderListViewController: UIViewController, UITableViewDataSource {
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView()

    private let orderTags: Set<String>
    private let timeWindow: Sh_Generated_TimeWindow

    private let orderListController = OrderListController()

    private var ordersList: Sh_Generated_OrdersResponse?

    init(orderTags: Set<String>, timeWindow: Sh_Generated_TimeWindow) {
        self.orderTags = orderTags
        self.timeWindow = timeWindow
        super.init(nibName: nil, bundle: nil)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("on map", comment: ""),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(OrderListViewController.onMapAction(sender:)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        view.addSubview(tableView)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        tableView.snp.makeConstraints { maker in
            maker.edges.equalTo(view)
        }

        activityIndicator.snp.makeConstraints { maker in
            maker.center.equalTo(view)
        }

        var request = Sh_Generated_SearchOrdersRequest()
        request.orderTags = Array(orderTags)
        request.timeWindow = timeWindow

        activityIndicator.startAnimating()
        orderListController.searchOrders(request: request) { result in
            switch result {
            case .success(let ordersList): self.ordersList = ordersList
            case .error(_): self.ordersList = nil
            }
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersList?.orders.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListCellID") ?? UITableViewCell(style: UITableViewCellStyle.subtitle,
                                                                                                       reuseIdentifier: "OrderListCellID")

        cell.textLabel?.text = ordersList!.orders[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = ordersList!.orders[indexPath.row].description_p
        cell.detailTextLabel?.numberOfLines = 0

        return cell
    }

    @objc private func onMapAction(sender: Any) {
        var mapObjects = Sh_Generated_MapObjectResponse()
        var shelterMapObjectMap: [Int32: Sh_Generated_ShelterMapObject] = [:]

        ordersList?.orders.forEach({ order in
            var shelterMapObject = shelterMapObjectMap[order.shelter.id]
            if shelterMapObject == nil {
                shelterMapObject = Sh_Generated_ShelterMapObject()
                shelterMapObject?.shelter = order.shelter
            }
            shelterMapObject?.availableOrders.append(order)
            shelterMapObjectMap[order.shelter.id] = shelterMapObject
        })

        mapObjects.shelters = shelterMapObjectMap.map({ $0.value })

        let mapVC = MapViewController(mapObjects: mapObjects)
        navigationController?.pushViewController(mapVC, animated: true)
    }
}
