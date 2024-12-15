//
//  PamphletController.swift
//  Nagaoka-Hanabi-clone
//
//  Created by MANSUB SHIN on 2024/12/12.
//

import PDFKit
import UIKit

class PamphletController: UIViewController {
    // MARK: - Properties
    
    private let scrollView = UIScrollView()
    private var pdfDocument: PDFDocument?
    private let pageControl = UIPageControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        loadPDF()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        navigationItem.title = "パンフレット"
        
        // UIScrollView 설정
        scrollView.frame = view.bounds
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        view.addSubview(scrollView)
        
        // TODO: - 랜더링된 이미지가 고정되지 않고 위치이동이 가능한 상태, 페이지전환은 가능하되 이미지는 고정원함
        
        // UIPageControl 설정
        pageControl.currentPageIndicatorTintColor = .systemPink // 현재 페이지 색상
        pageControl.pageIndicatorTintColor = .lightGray // 나머지 페이지 색상
        pageControl.hidesForSinglePage = true // 페이지가 1개일 때 숨김
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
        // 페이지 컨트롤 레이아웃 설정
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    // PDF 로드 및 페이지 렌더링
    private func loadPDF() {
        // 비동기 작업을 위한 글로벌 큐 사용
        DispatchQueue.global(qos: .userInitiated).async {
            guard let pdfURL = URL(string: "https://nagaokamatsuri.com/img/winter_fantasy2024.pdf"),
                  let pdfDocument = PDFDocument(url: pdfURL) else { return }
            
            self.pdfDocument = pdfDocument
            let pageCount = pdfDocument.pageCount
            
            // 각 페이지의 이미지를 렌더링
            var pageImages: [UIImage] = []
            for pageIndex in 0 ..< pageCount {
                guard let page = pdfDocument.page(at: pageIndex),
                      let pageImage = self.renderPDFPageAsImage(page: page) else { continue }
                pageImages.append(pageImage)
            }
            
            // UI 업데이트는 메인 스레드에서 처리
            DispatchQueue.main.async {
                self.pageControl.numberOfPages = pageCount
                self.scrollView.contentSize = CGSize(
                    width: self.scrollView.frame.width * CGFloat(pageCount),
                    height: self.scrollView.frame.height
                )
                
                for (pageIndex, pageImage) in pageImages.enumerated() {
                    let imageView = UIImageView(image: pageImage)
                    imageView.contentMode = .scaleAspectFit
                    imageView.frame = CGRect(
                        x: CGFloat(pageIndex) * self.scrollView.frame.width,
                        y: 0,
                        width: self.scrollView.frame.width,
                        height: self.scrollView.frame.height
                    )
                    self.scrollView.addSubview(imageView)
                }
            }
        }
    }
    
    // PDF 페이지를 UIImage로 변환
    private func renderPDFPageAsImage(page: PDFPage) -> UIImage? {
        let pageRect = page.bounds(for: .mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        return renderer.image { ctx in
            let context = ctx.cgContext
            context.saveGState()
            context.translateBy(x: 0, y: pageRect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.fill(pageRect)
            page.draw(with: .mediaBox, to: context)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension PamphletController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        pageControl.currentPage = pageIndex
    }
}
