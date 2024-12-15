//
//  NotificationsController.swift
//  Nagaoka-Hanabi-clone
//
//  Created by MANSUB SHIN on 2024/12/12.
//

import UIKit

class NotificationsController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        navigationItem.title = "お知らせ"
    }
}
