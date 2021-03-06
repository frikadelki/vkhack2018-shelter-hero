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

    let tagLabel = UILabel()
    let nearLabel = UILabel()
    let nearIcon = UIImageView(image: UIImage(named: "small-location"))
    let questTitle = UILabel()
    let descriptionLabel = UILabel()
    let backView = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        separatorInset = .init(top: 0, left: 9999, bottom: 0, right: -9999)

        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = UIColor.ray_background
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 4
        contentView.addSubview(backView)

        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.font = UIFont.boldSystemFont(ofSize: 10)
        tagLabel.textColor = UIColor.ray_gray
        backView.addSubview(tagLabel)

        nearIcon.translatesAutoresizingMaskIntoConstraints = false
        backView.addSubview(nearIcon)

        nearLabel.translatesAutoresizingMaskIntoConstraints = false
        nearLabel.font = UIFont.systemFont(ofSize: 10)
        nearLabel.textColor = UIColor.ray_orange
        nearLabel.text = "Рядом с вами!"
        backView.addSubview(nearLabel)

        questTitle.font = UIFont.boldSystemFont(ofSize: 18)
        questTitle.translatesAutoresizingMaskIntoConstraints = false
        backView.addSubview(questTitle)

        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        backView.addSubview(descriptionLabel)

        tagLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(16)
            maker.bottom.equalTo(questTitle.snp.top).offset(-8)
        }

        nearLabel.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().offset(-16)
            maker.bottom.equalTo(questTitle.snp.top).offset(-8)
        }

        nearIcon.snp.makeConstraints { maker in
            maker.trailing.equalTo(nearLabel.snp.leading).offset(-4)
            maker.centerY.equalTo(nearLabel)
        }

        questTitle.snp.makeConstraints { maker in
            maker.top.equalTo(backView).offset(32)
            maker.leading.equalTo(backView).offset(16)
            maker.trailing.equalTo(backView).offset(-16)
        }

        descriptionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(questTitle.snp.bottom).offset(10)
            maker.leading.equalTo(questTitle)
            maker.trailing.equalTo(questTitle)
            maker.bottom.equalTo(backView).offset(-20)
        }

        backView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(6)
            maker.leading.equalToSuperview().offset(16)
            maker.bottom.equalToSuperview().offset(-6)
            maker.trailing.equalToSuperview().offset(-16)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class QuestsSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()
    private let errorLabel = UILabel()

    private let request: Sh_Generated_SearchQuestsRequest?
    private let questsSearchController: QuestsSearchController?

    private let questRecordController: ShlterQuestRecordController?

    private var questsResponse: Sh_Generated_SearchQuestsResponse?
    private var records: [Sh_Generated_ShelterQuestRecord]?

    private let refreshControl = UIRefreshControl()

    init(request: Sh_Generated_SearchQuestsRequest) {
        self.request = request
        questsSearchController = QuestsSearchController()
        questRecordController = nil
        super.init(nibName: nil, bundle: nil)

        self.title = NSLocalizedString("tasks title", comment: "")

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

        self.title = NSLocalizedString("tasks title", comment: "")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        tableView.refreshControl = refreshControl
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)

        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)

        errorLabel.snp.makeConstraints { maker in
            maker.center.equalTo(view)
        }
        errorLabel.isHidden = true

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

        reloadData(displayActivity: true)
    }

    func reloadData(displayActivity: Bool) {
        tableView.isUserInteractionEnabled = false

        if displayActivity {
            tableView.alpha = 0.5
            activityIndicator.startAnimating()
            self.errorLabel.isHidden = true
        }

        let completion = {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.tableView.isUserInteractionEnabled = true
            self.tableView.alpha = 1.0
        }

        if questsSearchController != nil, let request = request {
            questsSearchController?.search(request: request) { result in
                switch result {
                case .success(let questsResponse):
                    self.questsResponse = questsResponse
                    if questsResponse.quests.count == 0 {
                        self.errorLabel.text = "Список пуск"
                        self.errorLabel.isHidden = false
                    }
                case .error(_):
                    self.questsResponse = nil
                    self.errorLabel.text = "Произошла ошибка"
                    self.errorLabel.isHidden = false
                }
                completion()
            }
        } else if questRecordController != nil {
            questRecordController?.list(completion: { records in
                self.questsResponse = Sh_Generated_SearchQuestsResponse()
                self.records = records
                if let records = records {
                    self.questsResponse?.quests = records.map({ $0.shelterQuest })
                    if records.count == 0 {
                        self.errorLabel.text = "Список пуск"
                        self.errorLabel.isHidden = false
                    }
                } else {
                    self.errorLabel.text = "Произошла ошибка"
                    self.errorLabel.isHidden = false
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

        cell.questTitle.text = questsResponse!.quests[indexPath.row].order.title
        cell.questTitle.numberOfLines = 0

        cell.descriptionLabel.text = questsResponse!.quests[indexPath.row].order.description_p
        cell.descriptionLabel.numberOfLines = 0

        if let tag = questsResponse!.quests[indexPath.row].order.tags.first {
            cell.tagLabel.text = NSLocalizedString(tag, comment: "").uppercased()
        }

        cell.nearLabel.isHidden = indexPath.row >= 2
        cell.nearIcon.isHidden = indexPath.row >= 2

//        let record = getRecord(index: indexPath.row)
//        if let record = record {
//            switch record.status {
//            case .inProgress: cell.setStatus(NSLocalizedString("status in progress", comment: ""))
//            case .onReview: cell.setStatus(NSLocalizedString("status on reniew", comment: ""))
//            case .checked, .closed: cell.setStatus(NSLocalizedString("status is closed", comment: ""))
//            case .rejected: cell.setStatus(NSLocalizedString("status is rejecred", comment: ""))
//            case .canceled: cell.setStatus(NSLocalizedString("status is canceled", comment: ""))
//            default: assertionFailure("Unknown status")
//            }
//        }

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
        return records?[index]
    }

    @objc private func refreshWeatherData(_ sender: Any) {
        reloadData(displayActivity: false)
    }
}
