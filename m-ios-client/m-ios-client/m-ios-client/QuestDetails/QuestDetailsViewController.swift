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
    let button = UISwitch()

    private let activityIndicator = UIActivityIndicatorView()
    private var buttonWidth: Constraint!

    var changedCheckedHandler: ((_ check: Bool) -> Void)?

    var isActivity: Bool {
        return button.isHidden
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)

        label.snp.makeConstraints { maker in
            maker.top.leading.bottom.equalTo(self)
        }

        button.snp.makeConstraints { maker in
            maker.leading.equalTo(label.snp.trailing)
            maker.top.trailing.bottom.equalTo(self)
            buttonWidth = maker.width.equalTo(0).constraint
        }

        activityIndicator.snp.makeConstraints { maker in
            maker.center.equalTo(button)
        }

        button.addTarget(self, action: #selector(QuestStepView.changeValueAction(sender:)), for: .valueChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(step: Sh_Generated_ShelterQuestStep) {
        label.text = step.demand.text
    }

    func showStatus(checked: Bool) {
        button.isOn = checked
        buttonWidth.deactivate()
    }

    @objc private func changeValueAction(sender: Any) {
        changedCheckedHandler?(button.isOn)
    }

    func startUpdating() {
        activityIndicator.startAnimating()
        button.isHidden = true
    }

    func stopUpdating() {
        activityIndicator.stopAnimating()
        button.isHidden = false
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
    let record: Sh_Generated_ShelterQuestRecord?
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentScrollView)

        let title = UILabel()
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = quest.order.title
        contentScrollView.addSubview(title)

        let description = UILabel()
        description.numberOfLines = 0
        description.translatesAutoresizingMaskIntoConstraints = false
        description.text = quest.order.description_p
        contentScrollView.addSubview(description)

        scrollView.snp.makeConstraints { maker in
            maker.edges.equalTo(view)
        }

        contentScrollView.snp.makeConstraints { maker in
            maker.edges.width.equalTo(scrollView)
        }

        title.snp.makeConstraints { maker in
            maker.top.equalTo(contentScrollView)
            maker.leading.equalTo(contentScrollView)
            maker.trailing.equalTo(contentScrollView)
        }

        description.snp.makeConstraints { maker in
            maker.top.equalTo(title.snp.bottom)
            maker.leading.equalTo(contentScrollView)
            maker.trailing.equalTo(contentScrollView)
        }

        steps = UIStackView(arrangedSubviews: [])
        steps.axis = .vertical

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

        view.addSubview(steps)

        steps.snp.makeConstraints { maker in
            maker.top.equalTo(description.snp.bottom)
            maker.leading.equalTo(contentScrollView)
            maker.trailing.equalTo(contentScrollView)
        }

        bottomButtonContainer = UIStackView()
        bottomButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.addSubview(bottomButtonContainer)

        bottomButtonContainer.snp.makeConstraints { maker in
            maker.top.equalTo(steps.snp.bottom)
            maker.leading.equalTo(contentScrollView)
            maker.trailing.equalTo(contentScrollView)
            maker.bottom.equalTo(contentScrollView)
        }

        if record == nil {
            let pickButton = UIButton()
            pickButton.setTitle(NSLocalizedString("pick quest", comment: ""), for: .normal)
            pickButton.setTitleColor(.black, for: .normal)
            pickButton.translatesAutoresizingMaskIntoConstraints = false
            pickButton.addTarget(self, action: #selector(QuestDetailsViewController.startQuest(sender:)), for: .touchUpInside)

            bottomButtonContainer.addArrangedSubview(pickButton)
        }
    }

    @objc private func startQuest(sender: Any) {
        recordController.start(shelterQuest: quest) { record in
            if record != nil {
                (UIApplication.shared.delegate as? AppDelegate)?.navigateToMyQuests()
            }
        }
    }

    func updateDemand(demand: Sh_Generated_ShelterDemand, check: Bool, stepView: QuestStepView) {
        guard let record = record else { return }
        stepView.startUpdating()
        recordController.updateDemand(record: record, demand: demand, check: check) { result in
            stepView.stopUpdating()
            if !result {
                stepView.button.isOn = !stepView.button.isOn
            }
            self.showOnReviewButtonIfNeeded()
        }
    }

    func showOnReviewButtonIfNeeded() {
        let activityOrCheckOffViews = steps.arrangedSubviews.filter { view in
            return (view as? QuestStepView)?.isActivity == true || (view as? QuestStepView)?.button.isOn == false
        }

        if let subview = bottomButtonContainer.arrangedSubviews.first {
            bottomButtonContainer.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        if activityOrCheckOffViews.count == 0 {

            let pickButton = UIButton()
            pickButton.setTitle(NSLocalizedString("done quest", comment: ""), for: .normal)
            pickButton.setTitleColor(.black, for: .normal)
            pickButton.translatesAutoresizingMaskIntoConstraints = false
            pickButton.addTarget(self, action: #selector(QuestDetailsViewController.doneQuest(sender:)), for: .touchUpInside)

            bottomButtonContainer.addArrangedSubview(pickButton)
        }
    }

    @objc private func doneQuest(sender: Any) {
        guard let record = record else { return }
        recordController.done(record: record) { record in
            if record != nil {
                if let subview = self.bottomButtonContainer.arrangedSubviews.first {
                    self.bottomButtonContainer.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
            }
        }
    }
}
