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

    enum Style {
        case apply
        case search
    }

    weak var delegate: FilterViewControllerDelegate?

    private let venueTags: [String]
    private let venueTagsCheked: Set<String>
    private let taskTags: [String]
    private let taskTagsCheked: Set<String>
    private let style: Style

    private var venueTagsControls: [CheckBoxElement]?
    private var taskTagsControls: [CheckBoxElement]?

    private let scrollView = UIScrollView()

    init(venueTags: Set<String>, venueTagsCheked: Set<String>, taskTags: Set<String>, taskTagsCheked: Set<String>, style: Style) {
        self.venueTags = Array(venueTags)
        self.taskTags = Array(taskTags)
        self.venueTagsCheked = venueTagsCheked
        self.taskTagsCheked = taskTagsCheked
        self.style = style
        super.init(nibName: nil, bundle: nil)

        switch self.style {
        case .apply:
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("apply", comment: ""),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(FilterViewController.applyAction(sender:)))
        case .search:
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("search", comment: ""),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(FilterViewController.nextAction(sender:)))
        }
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

    func makeViews(tags: [String], checkedTags: Set<String>, title titleString: String) -> (view: UIView?, controls: [CheckBoxElement]?) {
        guard !tags.isEmpty else {
            return (nil, nil)
        }
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 22)
        title.text = titleString
        view.addSubview(title)

        let tagsControls = tags.map({ tag -> CheckBoxElement in
            let checkBox = CheckBoxElement()
            checkBox.translatesAutoresizingMaskIntoConstraints = false
            checkBox.checkBox.isOn = checkedTags.contains(tag)
            checkBox.label.text = NSLocalizedString(tag, comment: "")
            return checkBox
        })

        let checkboxsStackView = UIStackView(arrangedSubviews: tagsControls.map { $0 as UIView })
        checkboxsStackView.translatesAutoresizingMaskIntoConstraints = false
        checkboxsStackView.axis = .vertical
        view.addSubview(checkboxsStackView)

        title.snp.makeConstraints { maker in
            maker.top.equalTo(view).offset(16)
            maker.leading.equalTo(view).offset(20)
            maker.trailing.equalTo(view).offset(-20)
        }

        checkboxsStackView.snp.makeConstraints { maker in
            maker.top.equalTo(title.snp.bottom).offset(8)
            maker.leading.equalTo(view)
            maker.trailing.equalTo(view)
            maker.bottom.equalTo(view)
        }

        return (view, tagsControls)
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

    @objc func nextAction(sender: Any) {
        var taskTagsChacked: Set<String> = Set()

        taskTagsControls?.enumerated().forEach({ index, element in
            if element.checkBox.isOn {
                taskTagsChacked.insert(taskTags[index])
            }
        })

        var timeWindow = Sh_Generated_TimeWindow()
        timeWindow.from = 0
        timeWindow.to = Int32.max

        let ordersListVC = OrderListViewController(orderTags: taskTagsChacked, timeWindow: timeWindow)
        navigationController?.pushViewController(ordersListVC, animated: true)
    }
}
