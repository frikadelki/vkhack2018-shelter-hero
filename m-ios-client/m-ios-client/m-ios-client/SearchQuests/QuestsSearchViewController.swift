//
//  QuestsSearchViewController.swift
//  m-ios-client
//
//  Created by Denis Morozov on 10.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class QuestViewCell : UITableViewCell {

    let questTitle = UILabel()
    let questStatus = UILabel()

    var statusWidth: Constraint!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        questTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(questTitle)

        questStatus.font = UIFont.systemFont(ofSize: 12)
        questStatus.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(questStatus)

        questTitle.snp.makeConstraints { maker in
            maker.top.equalTo(contentView).offset(10)
            maker.leading.equalTo(contentView).offset(20)
            maker.trailing.equalTo(contentView).offset(-20)
        }

        questStatus.snp.makeConstraints { maker in
            maker.top.equalTo(questTitle.snp.bottom)
            maker.leading.equalTo(questTitle)
            maker.bottom.equalTo(contentView).offset(-10)
            statusWidth = maker.height.equalTo(0).constraint
        }
    }

    func setStatus(_ status: String) {
        statusWidth.deactivate()
        questStatus.text = status
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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

        view.backgroundColor = .white

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        tableView.snp.makeConstraints { maker in
            maker.edges.equalTo(view)
        }

        activityIndicator.snp.makeConstraints { maker in
            maker.center.equalTo(view)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.isUserInteractionEnabled = false
        tableView.alpha = 0.5
        activityIndicator.startAnimating()

        let completion = {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.tableView.isUserInteractionEnabled = true
            self.tableView.alpha = 1.0
        }

        if questsSearchController != nil, let request = request {
            questsSearchController?.search(request: request) { result in
                switch result {
                case .success(let questsResponse): self.questsResponse = questsResponse
                case .error(_): self.questsResponse = nil
                }
                completion()
            }
        } else if questRecordController != nil {
            questRecordController?.list(completion: { records in
                self.questsResponse = Sh_Generated_SearchQuestsResponse()
                self.records = records
                if let records = records {
                    self.questsResponse?.quests = records.map({ $0.shelterQuest })
                }
                completion()
            })
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questsResponse?.quests.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: QuestViewCell! = tableView.dequeueReusableCell(withIdentifier: "QuestCellID") as? QuestViewCell
        if cell == nil {
            cell = QuestViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "QuestCellID")
        }

        let record = getRecord(index: indexPath.row)

        cell.questTitle.text = questsResponse!.quests[indexPath.row].order.title
        cell.questTitle.numberOfLines = 0

        if let record = record {
            switch record.status {
            case .inProgress: cell.setStatus(NSLocalizedString("status in progress", comment: ""))
            case .onReview: cell.setStatus(NSLocalizedString("status on reniew", comment: ""))
            case .checked, .closed: cell.setStatus(NSLocalizedString("status is closed", comment: ""))
            case .rejected: cell.setStatus(NSLocalizedString("status is rejecred", comment: ""))
            case .canceled: cell.setStatus(NSLocalizedString("status is canceled", comment: ""))
            default: assertionFailure("Unknown status")
            }
        }

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
        let record = getRecord(index: indexPath.row)
        let detailsVC = QuestDetailsViewController(quest: questsResponse!.quests[indexPath.row],
                                                   record: record)
        navigationController?.pushViewController(detailsVC, animated: true)

        DispatchQueue.main.async {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func getRecord(index: Int) -> Sh_Generated_ShelterQuestRecord? {
        return records?.first(where: { record in
            record.shelterQuest.id == questsResponse!.quests[index].id
        })
    }
}
