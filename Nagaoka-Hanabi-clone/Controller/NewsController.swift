//
//  NewsController.swift
//  Nagaoka-Hanabi-clone
//
//  Created by MANSUB SHIN on 2024/12/12.
//

import Pageboy
import Tabman
import UIKit

class NewsController: UIViewController {
    // MARK: - Properties

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    // MARK: - Helpers

    func configureUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
    }
}
