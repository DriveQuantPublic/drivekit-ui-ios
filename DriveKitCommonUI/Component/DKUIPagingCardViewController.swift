//
//  DKUIPagingCardViewController.swift
//  DriveKitCommonUI
//
//  Created by Frédéric Ruaudel on 27/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit

public protocol DKUIPagingCardViewModel {
    associatedtype PageId: Hashable
    associatedtype PageViewModel
    var numberOfPages: Int { get }
    var firstPageId: PageId { get }
    func position(of pageId: PageId) -> Int?
    func pageId(at position: Int) -> PageId?
    func pageId(before context: PageId) -> PageId?
    func pageId(after context: PageId) -> PageId?
    func pageViewModel(for kind: PageId) -> PageViewModel?
}

public protocol DKUIPageViewModel {
    associatedtype PageId: Hashable
    associatedtype ViewModel
    var viewModel: ViewModel { get set }
    var pageId: PageId { get }
    init(pageId: PageId, pageViewModel: ViewModel)
}

public class DKUIPagingCardViewController<
    PageId: Hashable,
    ViewController: UIViewController,
    ViewModel: DKUIPagingCardViewModel
>: UIPageViewController where
ViewModel.PageId == PageId,
ViewController: DKUIPageViewModel,
ViewController.PageId == PageId,
ViewController.ViewModel == ViewModel.PageViewModel {
    private weak var pagingControl: UIPageControl!
    private var pageViewControllers: [PageId: ViewController] = [:]
    public var viewModel: ViewModel
    private var coordinator: Coordinator
    
    public init(pagingControl: UIPageControl, viewModel: ViewModel) {
        self.viewModel = viewModel
        self.pagingControl = pagingControl
        self.coordinator = Coordinator()
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        self.coordinator.viewControllerBefore = { [weak self] in
            guard let self else { return nil }
            return self.pageId(from: $0).flatMap { currentPageId in
                return viewModel.pageId(before: currentPageId).flatMap(self.pageController(for:))
            }
        }
        self.coordinator.viewControllerAfter = { [weak self] in
            guard let self else { return nil }
            return self.pageId(from: $0).flatMap { currentPageId in
                return viewModel.pageId(after: currentPageId).flatMap(self.pageController(for:))
            }
        }
        self.coordinator.didCompleteTransition = { [weak self] in
            guard let self else { return }
            if let currentVC = self.viewControllers?.first,
               let currentPageId = self.pageId(from: currentVC) {
                self.pagingControl.currentPage = self.viewModel.position(of: currentPageId) ?? 0
            }
        }
        self.dataSource = coordinator
        self.delegate = coordinator
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {
        pagingControl.numberOfPages = viewModel.numberOfPages
        pagingControl.currentPage = 0
        pagingControl.pageIndicatorTintColor = .dkPageIndicatorTintColor
        pagingControl.currentPageIndicatorTintColor = DKUIColors.secondaryColor.color
        
        pagingControl.addTarget(
            self,
            action: #selector(didTapPagingControl(_:)),
            for: .valueChanged
        )
        
        self.setViewControllers(
            [pageController(for: viewModel.firstPageId)],
            direction: .forward,
            animated: false
        )
    }
    
    @objc private func didTapPagingControl(_ sender: Any) {
        guard
            let selectedPageId = viewModel.pageId(
                at: self.pagingControl.currentPage
            )
        else {
            assertionFailure("We should always have a page that match an existing context")
            return
        }
        
        let pageController = self.pageController(for: selectedPageId)
        
        var direction = UIPageViewController.NavigationDirection.forward
        if let currentPageController = self.viewControllers?.first,
           let previousPageId = self.pageId(from: currentPageController) {
            direction = (
                viewModel.position(of: previousPageId) ?? -1
                <
                viewModel.position(of: selectedPageId) ?? -1
            )
            ? .forward
            : .reverse
        }
        
        self.setViewControllers(
            [pageController],
            direction: direction,
            animated: true
        )
    }
    
    public func pageController(for pageId: PageId) -> ViewController {
        guard let pageVC = pageViewControllers[pageId]
        else {
            let pageViewModel = viewModel.pageViewModel(for: pageId)!
            let newPageVC = ViewController.init(pageId: pageId, pageViewModel: pageViewModel)
            pageViewControllers[pageId] = newPageVC
            return newPageVC
        }
        
        return pageVC
    }
    
    public func pageId(from pageController: UIViewController) -> PageId? {
        guard let pageController = pageController as? ViewController else {
            assertionFailure("We should only have DrivingConditionsContextViewController here")
            return nil
        }
        
        return pageController.pageId
    }
    
}

// The coordinator is here because DKUIPagingCardViewController can't
// conforms to @objc methods of UIPageViewControllerDataSource and
// UIPageViewControllerDelegate because it has generic parameters
// if you try, you'll get the compiler error `@objc is not supported within
// extensions of generic classes.`
private class Coordinator: NSObject {
    var viewControllerBefore: ((UIViewController) -> UIViewController?)?
    var viewControllerAfter: ((UIViewController) -> UIViewController?)?
    var didCompleteTransition: (() -> Void)?
    
    override init() {
        super.init()
    }
}

extension Coordinator: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        self.viewControllerBefore?(viewController)
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        self.viewControllerAfter?(viewController)
    }
}

extension Coordinator: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed {
            self.didCompleteTransition?()
        }
    }
}
