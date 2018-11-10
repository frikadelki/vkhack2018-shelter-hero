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
    let button = UIButton()

    var buttonWidth: Constraint!

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        label.snp.makeConstraints { maker in
            maker.top.leading.bottom.equalTo(self)
        }

        button.snp.makeConstraints { maker in
            maker.leading.equalTo(label.snp.trailing)
            maker.top.trailing.bottom.equalTo(self)
            buttonWidth = maker.width.equalTo(0).constraint
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(step: Sh_Generated_ShelterQuestStep) {
        label.text = step.demand.text
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

        let steps = UIStackView(arrangedSubviews: [])
        steps.axis = .vertical

        quest.steps.forEach { step in
            let stepView = QuestStepView()
            stepView.show(step: step)
            stepView.translatesAutoresizingMaskIntoConstraints = false
            steps.addArrangedSubview(stepView)
        }

        view.addSubview(steps)

        steps.snp.makeConstraints { maker in
            maker.top.equalTo(description.snp.bottom)
            maker.leading.equalTo(contentScrollView)
            maker.trailing.equalTo(contentScrollView)

            if self.record != nil {
                maker.bottom.equalTo(contentScrollView)
            }
        }

        if record == nil {
            let pickButton = UIButton()
            pickButton.setTitle(NSLocalizedString("pick quest", comment: ""), for: .normal)
            pickButton.setTitleColor(.black, for: .normal)
            pickButton.translatesAutoresizingMaskIntoConstraints = false
            pickButton.addTarget(self, action: #selector(QuestDetailsViewController.startQuest(sender:)), for: .touchUpInside)
            contentScrollView.addSubview(pickButton)
            pickButton.snp.makeConstraints { maker in
                maker.top.equalTo(steps.snp.bottom)
                maker.leading.equalTo(contentScrollView)
                maker.trailing.equalTo(contentScrollView)
                maker.bottom.equalTo(contentScrollView)
            }
        }
    }

    @objc private func startQuest(sender: Any) {
        recordController.start(shelterQuest: quest) { record in
            if let record = record {
                (UIApplication.shared.delegate as? AppDelegate)?.navigateToInprogressOrder(record: record)
            }
        }
    }
}
