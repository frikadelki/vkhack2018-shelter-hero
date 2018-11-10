//
//  QuestsSearchViewController.swift
//  m-ios-client
//
//  Created by Denis Morozov on 10.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import Foundation
import UIKit

class QuestsSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView()

    private let request: Sh_Generated_SearchQuestsRequest?
    private let questsSearchController: QuestsSearchController?

    private let questRecordController: ShlterQuestRecordController?

    private var questsResponse: Sh_Generated_SearchQuestsResponse?
    private var records: [Sh_Generated_ShelterQuestRecord]?

    init(request: Sh_Generated_SearchQuestsRequest) {
        self.request = request
        questsSearchController = QuestsSearchController()
        questRecordController = nil
        super.init(nibName: nil, bundle: nil)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("on map", comment: ""),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(QuestsSearchViewController.onMapAction(sender:)))
    }

    init() {
        self.questRecordController = ShlterQuestRecordController()
        self.request = nil
        questsSearchController = nil
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
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

        if questsSearchController != nil, let request = request {
            activityIndicator.startAnimating()
            questsSearchController?.search(request: request) { result in
                switch result {
                case .success(let questsResponse): self.questsResponse = questsResponse
                case .error(_): self.questsResponse = nil
                }
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        } else if questRecordController != nil {
            activityIndicator.startAnimating()
            questRecordController?.list(completion: { records in

                self.questsResponse = Sh_Generated_SearchQuestsResponse()
                self.records = records

                if let records = records {
                    self.questsResponse?.quests = records.map({ $0.shelterQuest })
                }

                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            })
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questsResponse?.quests.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestCellID") ?? UITableViewCell(style: UITableViewCellStyle.subtitle,
                                                                                                   reuseIdentifier: "QuestCellID")

        cell.textLabel?.text = questsResponse!.quests[indexPath.row].order.title
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = questsResponse!.quests[indexPath.row].order.description_p
        cell.detailTextLabel?.numberOfLines = 0

        return cell
    }

    @objc private func onMapAction(sender: Any) {
        var mapObjects = Sh_Generated_MapObjectResponse()
        var shelterMapObjectMap: [Int32: Sh_Generated_ShelterMapObject] = [:]

        questsResponse?.quests.forEach({ quest in
            var shelterMapObject = shelterMapObjectMap[quest.order.shelter.id]
            if shelterMapObject == nil {
                shelterMapObject = Sh_Generated_ShelterMapObject()
                shelterMapObject?.shelter = quest.order.shelter
            }
            shelterMapObject?.availableOrders.append(quest.order)
            shelterMapObjectMap[quest.order.shelter.id] = shelterMapObject
        })

        mapObjects.shelters = shelterMapObjectMap.map({ $0.value })

        let mapVC = MapViewController(mapObjects: mapObjects)
        navigationController?.pushViewController(mapVC, animated: true)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record = records?.first(where: { record in
            record.shelterQuest.id == questsResponse!.quests[indexPath.row].id
        })
        let detailsVC = QuestDetailsViewController(quest: questsResponse!.quests[indexPath.row],
                                                   record: record)
        navigationController?.pushViewController(detailsVC, animated: true)

        DispatchQueue.main.async {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
