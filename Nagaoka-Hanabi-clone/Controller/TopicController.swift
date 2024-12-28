//
//  TopicController.swift
//  Nagaoka-Hanabi-clone
//
//  Created by MANSUB SHIN on 2024/12/20.
//

import Alamofire
import SwiftSoup
import UIKit

class TopicController: UIViewController {
    // MARK: - Properties

    let baseURL = "https://nagaokamatsuri.com/topics/page/"
    let pageRange = 1 ... 12 // 1~12 페이지까지
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        startCrawling()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    private func startCrawling() {
        for pageNumber in pageRange {
            guard let url = URL(string: "\(baseURL)\(pageNumber)/") else { return }
            
            fetchHTML(from: url) { result in
                switch result {
                case .success(let html):
                    self.parseHTML(html, pageNumber: pageNumber)
                case .failure(let error):
                    print("Error fetching page \(pageNumber): \(error.localizedDescription)")
                }
            }
        }
    }
    
    // HTML 데이터를 가져오는 함수
    private func fetchHTML(from url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        AF.request(url).responseString { response in
            if let error = response.error {
                completion(.failure(error))
                return
            }

            if let html = response.value {
                completion(.success(html))
            } else {
                let error = NSError(domain: "HTML Fetching", code: -1, userInfo: [NSLocalizedDescriptionKey: "No HTML data received"])
                completion(.failure(error))
            }
        }
    }
    
    // HTML 데이터를 파싱하는 함수
    private func parseHTML(_ html: String, pageNumber: Int) {
        do {
            let doc = try SwiftSoup.parse(html)
            let elements = try doc.select("#wrap > main > section > div > ul > li")

            for element in elements {
                let title = try element.select("div.box.boxTxt > .ttl").text()
                let date = try element.select("div.box.boxTxt > .date").text()
                let image = try element.select("div.box.boxImg > img").attr("src")
                let link = try element.select(".boxLink").attr("href")
                let newDate = date.replacingOccurrences(of: ".", with: "/", options: .literal, range: nil)

                print("------ Page \(pageNumber) ------")
                print("Title: \(title)")
                print("Date: \(newDate)")
                print("Image: \(image)")
                print("Link: \(link)")
                print("-----------------------------")
            }
        } catch {
            print("Error parsing HTML on page \(pageNumber): \(error.localizedDescription)")
        }
    }
}
