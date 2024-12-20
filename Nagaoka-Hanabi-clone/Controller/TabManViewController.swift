//
//  TabManViewController.swift
//  Nagaoka-Hanabi-clone
//
//  Created by MANSUB SHIN on 2024/12/20.
//

import Pageboy
import Tabman
import UIKit

class TabManViewController: TabmanViewController {
    // MARK: - Properties

    private var viewControllers: [UIViewController] = []
    let newsVC = NewsController()
    let topicVC = TopicController()
//

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    // MARK: - Helpers

    func configureUI() {
        viewControllers.append(newsVC)
        viewControllers.append(topicVC)

        view.backgroundColor = UIColor(named: "backgroundColor")

        dataSource = self

        let bar = TMBar.ButtonBar()
        settingTabBar(bar: bar)

        // 탭바 추가 - 제약 조건 개선
        addBar(bar, dataSource: self, at: .top)
    }

    func settingTabBar(bar: TMBarView<TMHorizontalBarLayout, TMLabelBarButton, TMLineBarIndicator>) {
        // 탭바 레이아웃 설정
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 10

        // 배경색
        bar.backgroundView.style = .clear
        bar.backgroundColor = UIColor(named: "backgroundColor")

        // 간격설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        // 버튼 글시 커스텀
        bar.buttons.customize { button in
            button.font = UIFont.systemFont(ofSize: 16)
            button.tintColor = UIColor(named: "normalIconColor")
            button.selectedTintColor = UIColor(named: "selectedIconColor")
        }

        // indicator
        bar.indicator.weight = .custom(value: 3.5)
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = UIColor(named: "selectedIconColor")

        // separator
        let separator = UIView()
        separator.backgroundColor = UIColor.darkGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        bar.addSubview(separator)

        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 0.5), // 구분선 높이
            separator.leadingAnchor.constraint(equalTo: bar.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: bar.trailingAnchor),
            separator.topAnchor.constraint(equalTo: bar.bottomAnchor, constant: -1) // 인디케이터 바로 뒤
        ])
    }
}

// MARK: - TabManViewController

extension TabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "トピックス")
        case 1:
            return TMBarItem(title: "ニュース")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
