//
//  QuestDetailsViewController.swift
//  m-ios-client
//
//  Created by Denis Morozov on 10.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class QuestStepView: UIView {
    let label = UILabel()
    let uiSwitch = UISwitch()

    private let activityIndicator = UIActivityIndicatorView()
    private var buttonWidth: Constraint!

    var changedCheckedHandler: ((_ check: Bool) -> Void)?

    var isActivity: Bool {
        return uiSwitch.isHidden
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        addSubview(uiSwitch)

        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)

        label.snp.makeConstraints { maker in
            maker.top.leading.bottom.equalTo(self)
        }

        uiSwitch.snp.makeConstraints { maker in
            maker.leading.equalTo(label.snp.trailing)
            maker.top.trailing.bottom.equalTo(self)
            buttonWidth = maker.width.equalTo(0).constraint
        }

        activityIndicator.snp.makeConstraints { maker in
            maker.center.equalTo(uiSwitch)
        }

        uiSwitch.addTarget(self, action: #selector(QuestStepView.changeValueAction(sender:)), for: .valueChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(step: Sh_Generated_ShelterQuestStep) {
        label.text = step.demand.text
    }

    func showStatus(checked: Bool) {
        uiSwitch.isOn = checked
        buttonWidth.deactivate()
    }

    @objc private func changeValueAction(sender: Any) {
        CATransaction.setCompletionBlock({
            self.changedCheckedHandler?(self.uiSwitch.isOn)
        })
    }

    func startUpdating() {
        activityIndicator.startAnimating()
        uiSwitch.isHidden = true
    }

    func stopUpdating() {
        activityIndicator.stopAnimating()
        uiSwitch.isHidden = false
    }
}

class QuestDetailsViewController: UIViewController
{
    enum Style {
        case forPick
        case progress
        case done
    }

    let quest: Sh_Generated_ShelterQuest
    var record: Sh_Generated_ShelterQuestRecord?
    init(quest: Sh_Generated_ShelterQuest, record: Sh_Generated_ShelterQuestRecord?) {
        self.quest = quest
        self.record = record
        super.init(nibName: nil, bundle: nil)
    }

    private let scrollView = UIScrollView()
    private let contentScrollView = UIView()
    private let recordController = ShlterQuestRecordController()
    private var steps: UIStackView!
    private var bottomButtonContainer: UIStackView!
    private let activityIndicator = UIActivityIndicatorView()
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private let refreshControl = UIRefreshControl()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("task title", comment: "")

        view.backgroundColor = .white

        scrollView.refreshControl = refreshControl
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        if record != nil {
            refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        }

        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentScrollView)

        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.addSubview(titleLabel)

        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.addSubview(descriptionLabel)

        steps = UIStackView(arrangedSubviews: [])
        steps.axis = .vertical

        contentScrollView.addSubview(steps)

        bottomButtonContainer = UIStackView()
        bottomButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.addSubview(bottomButtonContainer)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(activityIndicator)

        updateUI()

        setupConstraints()
    }

    func startUpdating() {
        activityIndicator.startAnimating()
        scrollView.alpha = 0.5
        scrollView.isUserInteractionEnabled = false
    }

    func stopUpdating() {
        activityIndicator.stopAnimating()
        scrollView.alpha = 1.0
        scrollView.isUserInteractionEnabled = true
    }

    func updateDemand(demand: Sh_Generated_ShelterDemand, check: Bool, stepView: QuestStepView) {
        guard let record = record else { return }
        stepView.startUpdating()
        recordController.updateDemand(record: record, demand: demand, check: check) { result in
            stepView.stopUpdating()
            if !result {
                stepView.uiSwitch.isOn = !stepView.uiSwitch.isOn
            }
            if stepView.uiSwitch.isOn && !self.record!.doneDemandsIds.contains(demand.id) {
                self.record!.doneDemandsIds.append(demand.id)
            }
            else if stepView.uiSwitch.isOn == false {
                self.record!.doneDemandsIds = self.record!.doneDemandsIds.filter({ id in
                    id != demand.id
                })
            }

            self.updateUIIfNeeded()
        }
    }

    func updateUIIfNeeded() {
        let activityOrCheckOffViews = steps.arrangedSubviews.filter { view in
            return (view as? QuestStepView)?.isActivity == true || (view as? QuestStepView)?.uiSwitch.isOn == false
        }

        if activityOrCheckOffViews.count == 0 {
            updateUI()
        }
    }

    func updateUI() {
        titleLabel.text = quest.order.title
        descriptionLabel.text = quest.order.description_p

        steps.arrangedSubviews.forEach { subview in
            steps.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        steps.isUserInteractionEnabled = true
        steps.alpha = 1.0
        quest.steps.forEach { step in
            let stepView = QuestStepView()
            stepView.show(step: step)
            if let record = record {
                stepView.showStatus(checked: record.doneDemandsIds.contains(step.demand.id))
                stepView.changedCheckedHandler = { [weak self, weak stepView] check in
                    guard let stepView = stepView else { return }
                    self?.updateDemand(demand: step.demand, check: check, stepView: stepView)
                }
            }
            stepView.translatesAutoresizingMaskIntoConstraints = false
            steps.addArrangedSubview(stepView)
        }

        if let subview = bottomButtonContainer.arrangedSubviews.first {
            bottomButtonContainer.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        if record == nil {
            let pickButton = UIButton()
            pickButton.setTitle(NSLocalizedString("pick quest", comment: ""), for: .normal)
            pickButton.setTitleColor(.black, for: .normal)
            pickButton.translatesAutoresizingMaskIntoConstraints = false
            pickButton.addTarget(self, action: #selector(QuestDetailsViewController.startQuest(sender:)), for: .touchUpInside)

            bottomButtonContainer.addArrangedSubview(pickButton)
        }

        if let record = record, record.doneDemandsIds.count == record.shelterQuest.steps.count {
            steps.isUserInteractionEnabled = false
            steps.alpha = 0.5

            if record.status == .inProgress {
                let pickButton = UIButton()
                pickButton.setTitle(NSLocalizedString("done quest", comment: ""), for: .normal)
                pickButton.setTitleColor(.black, for: .normal)
                pickButton.translatesAutoresizingMaskIntoConstraints = false
                pickButton.addTarget(self, action: #selector(QuestDetailsViewController.doneQuest(sender:)), for: .touchUpInside)

                bottomButtonContainer.addArrangedSubview(pickButton)
            }
        }
    }
}

extension QuestDetailsViewController
{
    @objc private func startQuest(sender: Any) {
        startUpdating()
        recordController.start(shelterQuest: quest) { record in
            if record != nil {
                (UIApplication.shared.delegate as? AppDelegate)?.navigateToMyQuests()
            }
            self.stopUpdating()
        }
    }

    @objc private func doneQuest(sender: Any) {
        guard let record = record else { return }
        startUpdating()
        recordController.done(record: record) { record in
            if record != nil {
                self.record = record
                self.updateUI()
            }
            self.stopUpdating()
        }
    }

    @objc private func refreshWeatherData(_ sender: Any) {
        self.scrollView.isUserInteractionEnabled = false
        recordController.questRecord(shelterQuest: record!) { record in
            if let record = record {
                self.record = record
            }
            self.refreshControl.endRefreshing()
            self.scrollView.isUserInteractionEnabled = true
        }
    }
}

extension QuestDetailsViewController
{
    func setupConstraints()
    {
        scrollView.snp.makeConstraints { maker in
            maker.edges.equalTo(view)
        }

        contentScrollView.snp.makeConstraints { maker in
            maker.edges.width.equalTo(scrollView)
        }

        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(contentScrollView)
            maker.leading.equalTo(contentScrollView)
            maker.trailing.equalTo(contentScrollView)
        }

        descriptionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom)
            maker.leading.equalTo(contentScrollView)
            maker.trailing.equalTo(contentScrollView)
        }

        steps.snp.makeConstraints { maker in
            maker.top.equalTo(descriptionLabel.snp.bottom)
            maker.leading.equalTo(contentScrollView)
            maker.trailing.equalTo(contentScrollView)
        }

        bottomButtonContainer.snp.makeConstraints { maker in
            maker.top.equalTo(steps.snp.bottom)
            maker.leading.equalTo(contentScrollView)
            maker.trailing.equalTo(contentScrollView)
            maker.bottom.equalTo(contentScrollView)
        }

        activityIndicator.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }
}
