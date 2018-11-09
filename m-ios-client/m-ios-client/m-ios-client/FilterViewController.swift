//
//  FilterViewController.swift
//  m-ios-client
//
//  Created by Denis Morozov on 09.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import UIKit

class CheckBoxElement: UIView {
    let label: UILabel
    let checkBox: UISwitch
    override init(frame: CGRect) {
        checkBox = UISwitch()
        label = UILabel()
        super.init(frame: frame)

        checkBox.translatesAutoresizingMaskIntoConstraints = false
        addSubview(checkBox)

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        checkBox.snp.makeConstraints { maker in
            maker.leading.equalTo(self).offset(20)
            maker.top.equalTo(self).offset(10)
            maker.bottom.equalTo(self).offset(-10)
        }

        label.snp.makeConstraints { maker in
            maker.leading.equalTo(checkBox.snp.trailing).offset(16)
            maker.centerY.equalTo(checkBox)
            maker.trailing.equalTo(self).offset(-16)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol FilterViewControllerDelegate: AnyObject {
    func filterViewControllerApplyFilters(_ controller: FilterViewController, venueTags: Set<String>, taskTags: Set<String>)
}

class FilterViewController: UIViewController {

    weak var delegate: FilterViewControllerDelegate?

    private let venueTags: [String]
    private let venueTagsCheked: Set<String>
    private let taskTags: [String]
    private let taskTagsCheked: Set<String>

    private var venueTagsControls: [CheckBoxElement]?
    private var taskTagsControls: [CheckBoxElement]?

    private let scrollView = UIScrollView()

    init(venueTags: Set<String>, venueTagsCheked: Set<String>, taskTags: Set<String>, taskTagsCheked: Set<String>) {
        self.venueTags = Array(venueTags)
        self.taskTags = Array(taskTags)
        self.venueTagsCheked = venueTagsCheked
        self.taskTagsCheked = taskTagsCheked
        super.init(nibName: nil, bundle: nil)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "apply",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(FilterViewController.applyAction(sender:)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let (venuesView, venueTagsControls) = makeViews(tags: venueTags,
                                                        checkedTags: venueTagsCheked,
                                                        title: NSLocalizedString("venues tags", comment: ""))
        self.venueTagsControls = venueTagsControls

        let (tasksView, taskTagsControls) = makeViews(tags: taskTags,
                                                      checkedTags: taskTagsCheked,
                                                      title: NSLocalizedString("tasks tags", comment: ""))

        self.taskTagsControls = taskTagsControls

        var views: [UIView] = []

        if let venuesView = venuesView {
            views.append(venuesView)
        }

        if let tasksView = tasksView {
            views.append(tasksView)
        }

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let stackViews = UIStackView(arrangedSubviews: views)
        stackViews.translatesAutoresizingMaskIntoConstraints = false
        stackViews.axis = .vertical
        scrollView.addSubview(stackViews)

        stackViews.snp.makeConstraints { maker in
            maker.edges.width.equalTo(scrollView)
        }

        scrollView.snp.makeConstraints { maker in
            maker.edges.equalTo(view)
        }
    }

    func makeViews(tags: [String], checkedTags: Set<String>, title: String) -> (view: UIView?, controls: [CheckBoxElement]?) {
        guard !venueTags.isEmpty else {
            return (nil, nil)
        }
        let venuesView = UIView()
        venuesView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(venuesView)

        let venuesTitles = UILabel()
        venuesTitles.translatesAutoresizingMaskIntoConstraints = false
        venuesTitles.font = UIFont.systemFont(ofSize: 22)
        venuesTitles.text = title
        venuesView.addSubview(venuesTitles)

        let venueTagsControls = tags.map({ venueTag -> CheckBoxElement in
            let checkBox = CheckBoxElement()
            checkBox.translatesAutoresizingMaskIntoConstraints = false
            checkBox.checkBox.isOn = checkedTags.contains(venueTag)
            checkBox.label.text = NSLocalizedString(venueTag, comment: "")
            return checkBox
        })

        let venuesCheckboxsStackView = UIStackView(arrangedSubviews: venueTagsControls.map { $0 as UIView })
        venuesCheckboxsStackView.translatesAutoresizingMaskIntoConstraints = false
        venuesCheckboxsStackView.axis = .vertical
        venuesView.addSubview(venuesCheckboxsStackView)

        venuesTitles.snp.makeConstraints { maker in
            maker.top.equalTo(venuesView).offset(16)
            maker.leading.equalTo(venuesView).offset(20)
            maker.trailing.equalTo(venuesView).offset(-20)
        }

        venuesCheckboxsStackView.snp.makeConstraints { maker in
            maker.top.equalTo(venuesTitles.snp.bottom).offset(8)
            maker.leading.equalTo(venuesView)
            maker.trailing.equalTo(venuesView)
            maker.bottom.equalTo(venuesView)
        }

        return (venuesView, venueTagsControls)
    }

    @objc func applyAction(sender: Any) {

        var venueTagsChacked: Set<String> = Set()

        venueTagsControls?.enumerated().forEach({ index, element in
            if element.checkBox.isOn {
                venueTagsChacked.insert(venueTags[index])
            }
        })

        var taskTagsChacked: Set<String> = Set()

        taskTagsControls?.enumerated().forEach({ index, element in
            if element.checkBox.isOn {
                taskTagsChacked.insert(taskTags[index])
            }
        })

        delegate?.filterViewControllerApplyFilters(self,
                                                   venueTags: venueTagsChacked,
                                                   taskTags: taskTagsChacked)
    }
}
