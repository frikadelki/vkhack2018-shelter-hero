//
//  FilterViewController.swift
//  m-ios-client
//
//  Created by Denis Morozov on 09.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import UIKit

class RayButton: UIView {
    let button = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.backgroundColor = UIColor.ray_orange
        button.setTitle(NSLocalizedString("apply", comment: "").uppercased(), for: .normal)

        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4

        addSubview(button)

        button.snp.makeConstraints { maker in
            maker.top.equalTo(self).offset(32)
            maker.bottom.equalTo(self).offset(-16)
            maker.leading.equalTo(self).offset(32)
            maker.trailing.equalTo(self).offset(-32)
            maker.height.equalTo(56)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CheckBoxElement: UIView {
    let imageView: UIImageView
    let label: UILabel
    let checkBox: UISwitch
    override init(frame: CGRect) {
        imageView = UIImageView()
        checkBox = UISwitch()
        label = UILabel()
        super.init(frame: frame)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        checkBox.onTintColor = UIColor.ray_orange
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        addSubview(checkBox)

        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        imageView.snp.makeConstraints { maker in
            maker.top.equalTo(self).offset(20)
            maker.leading.equalTo(self).offset(30)
            maker.bottom.equalTo(self)
        }

        label.snp.makeConstraints { maker in
            maker.leading.equalTo(imageView.snp.trailing).offset(16)
            maker.centerY.equalTo(imageView)
        }

        checkBox.snp.makeConstraints { maker in
            maker.trailing.equalTo(self).offset(-30)
            maker.centerY.equalTo(label)
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

    private var durationLimitLabel: UILabel?
    private var durationLimitSlider: UISlider?

    private var distanceLimitLabel: UILabel?
    private var distanceLimitSlider: UISlider?
    private var transportSegmented: UISegmentedControl?

    init(venueTags: Set<String>,
         venueTagsCheked: Set<String>,
         taskTags: Set<String>,
         taskTagsCheked: Set<String>,
         style: Style) {
        self.venueTags = Array(venueTags)
        self.taskTags = Array(taskTags)
        self.venueTagsCheked = venueTagsCheked
        self.taskTagsCheked = taskTagsCheked
        self.style = style
        super.init(nibName: nil, bundle: nil)

        switch self.style {
        case .apply:
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("show all map objects", comment: ""),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(FilterViewController.showAllAction(sender:)))
        case .search:
            break
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

        if style == .search {
            views.append(addDurationLimit())
//            views.append(addDistanceLimit())
            views.append(addTransport())
        }

        let button = RayButton()
        switch style {
        case .apply:
            button.button.addTarget(self, action: #selector(applyAction(sender:)), for: .touchUpInside)
        case .search:
            button.button.addTarget(self, action: #selector(nextAction(sender:)), for: .touchUpInside)
        }
        views.append(button)

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
        title.font = UIFont.boldSystemFont(ofSize: 32)
        title.text = titleString
        view.addSubview(title)

        let tagsControls = tags.map({ tag -> CheckBoxElement in
            let checkBox = CheckBoxElement()
            checkBox.imageView.image = UIImage(named: tag + "-icon")
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
            maker.top.equalTo(view).offset(20)
            maker.leading.equalTo(view).offset(30)
            maker.trailing.equalTo(view).offset(-30)
        }

        checkboxsStackView.snp.makeConstraints { maker in
            maker.top.equalTo(title.snp.bottom)
            maker.leading.equalTo(view)
            maker.trailing.equalTo(view)
            maker.bottom.equalTo(view)
        }

        return (view, tagsControls)
    }

    func addDurationLimit() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        durationLimitLabel = label

        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(FilterViewController.durationLimitChanged(sender:)), for: .valueChanged)
        slider.minimumValue = 20
        slider.maximumValue = 480
        view.addSubview(slider)

        durationLimitSlider = slider

        durationLimitChanged(sender: slider)

        label.snp.makeConstraints { maker in
            maker.top.equalTo(view).offset(10)
            maker.leading.equalTo(view).offset(20)
            maker.trailing.equalTo(view).offset(-20)
        }

        slider.snp.makeConstraints { maker in
            maker.top.equalTo(label.snp.bottom).offset(10)
            maker.leading.equalTo(view).offset(20)
            maker.trailing.equalTo(view).offset(-20)
            maker.bottom.equalTo(view)
        }

        return view
    }

    func addDistanceLimit() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        view.addSubview(label)

        distanceLimitLabel = label

        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(FilterViewController.distanceLimitChanged(sender:)), for: .valueChanged)
        slider.minimumValue = 100
        slider.maximumValue = 10000
        view.addSubview(slider)

        distanceLimitSlider = slider

        distanceLimitChanged(sender: slider)

        label.snp.makeConstraints { maker in
            maker.top.equalTo(view).offset(10)
            maker.leading.equalTo(view).offset(20)
            maker.trailing.equalTo(view).offset(-20)
        }

        slider.snp.makeConstraints { maker in
            maker.top.equalTo(label.snp.bottom).offset(10)
            maker.leading.equalTo(view).offset(20)
            maker.trailing.equalTo(view).offset(-20)
            maker.bottom.equalTo(view)
        }

        return view
    }

    func addTransport() -> UIView {
        let view = UIView()
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
        let segmented = UISegmentedControl()
        segmented.insertSegment(withTitle: NSLocalizedString("on car", comment: ""), at: 0, animated: false)
        segmented.insertSegment(withTitle: NSLocalizedString("on public", comment: ""), at: 1, animated: false)
        segmented.insertSegment(withTitle: NSLocalizedString("on home", comment: ""), at: 2, animated: false)
        segmented.selectedSegmentIndex = 0

        transportSegmented = segmented

        segmented.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(segmented)

        segmented.snp.makeConstraints { maker in
            maker.top.equalTo(view).offset(20)
            maker.leading.equalTo(view).offset(20)
            maker.trailing.equalTo(view).offset(-20)
            maker.bottom.equalTo(view)
            maker.height.equalTo(52)
        }

        return view;
    }

    @objc func showAllAction(sender: Any) {
        delegate?.filterViewControllerApplyFilters(self,
                                                   venueTags: Set(),
                                                   taskTags: Set())
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

        var request = Sh_Generated_SearchQuestsRequest()
        request.orderTags = Array(taskTagsChacked)
        request.params.availabilityWindow = timeWindow
//        request.params.distanceLimit = (Int32(distanceLimitSlider!.value) / 100) * 100
        request.params.distanceLimit = .max
        request.params.timeLimit = (Int32(durationLimitSlider!.value) / 10) * 10
        if transportSegmented!.selectedSegmentIndex == 0 {
            request.params.transport = Sh_Generated_Transport.car
        } else if transportSegmented!.selectedSegmentIndex == 1 {
            request.params.transport = Sh_Generated_Transport.publicTransport
        } else {
            request.params.distanceLimit = 1
        }

        let ordersListVC = QuestsSearchViewController(request: request)
        navigationController?.pushViewController(ordersListVC, animated: true)
    }

    @objc func durationLimitChanged(sender: Any) {
        guard let slider = durationLimitSlider else { return }
        let hours = Int(slider.value) / 60
        let minutes = ((Int(slider.value) % 60) / 10) * 10
        var suffix = ""
        if (hours > 0) {
            suffix += " \(hours)" + " " + NSLocalizedString("hours", comment: "")
        }
        if (minutes > 0) {
            suffix += " \(minutes)" + " " + NSLocalizedString("minutes", comment: "")
        }

        durationLimitLabel?.text = NSLocalizedString("duration limit", comment: "") + suffix
    }

    @objc func distanceLimitChanged(sender: Any) {
        guard let slider = distanceLimitSlider else { return }
        let km = Int(slider.value) / 1000
        let meters = ((Int(slider.value) % 1000) / 100) * 100
        var suffix = ""
        if (km > 0) {
            suffix += " \(km)" + " " + NSLocalizedString("km", comment: "")
        }
        if (meters > 0) {
            suffix += " \(meters)" + " " + NSLocalizedString("meters", comment: "")
        }

        distanceLimitLabel?.text = NSLocalizedString("distance limit", comment: "") + suffix
    }
}
