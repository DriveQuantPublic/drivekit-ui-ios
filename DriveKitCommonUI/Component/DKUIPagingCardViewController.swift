//
//  DKUIPagingCardViewController.swift
//  DriveKitCommonUI
//
//  Created by Frédéric Ruaudel on 27/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit

public protocol DKUIPagingViewModel {
    associatedtype PageId: Hashable
    associatedtype PageViewModel
    // You need to define only these two requirement
    var allPageIds: [PageId] { get }
    var hasData: Bool { get }
    func pageViewModel(for pageId: PageId) -> PageViewModel?
    
    // Those are derived from allPageIds
    var numberOfPages: Int { get }
    var firstPageId: PageId { get }
    func position(of pageId: PageId) -> Int?
    func pageId(at position: Int) -> PageId?
    func pageId(before pageId: PageId) -> PageId?
    func pageId(after pageId: PageId) -> PageId?
}

extension DKUIPagingViewModel {
    public var firstPageId: PageId {
        allPageIds[0]
    }
    
    public var numberOfPages: Int {
        allPageIds.count
    }
    
    public func position(of pageId: PageId) -> Int? {
        allPageIds.firstIndex(of: pageId)
    }
    
    public func pageId(at position: Int) -> PageId? {
        guard allPageIds.indexRange.contains(position) else {
            assertionFailure("We should not ask a pageId out of bounds (ask index \(position) in \(allPageIds)")
            return nil
        }
        
        return allPageIds[position]
    }
    
    public func pageId(before pageId: PageId) -> PageId? {
        allPageIds.firstIndex(of: pageId).flatMap {
            $0 > allPageIds.startIndex ? allPageIds[$0 - 1] : nil
        }
    }
    
    public func pageId(after pageId: PageId) -> PageId? {
        allPageIds.firstIndex(of: pageId).flatMap {
            $0 >= (allPageIds.endIndex - 1) ? nil : allPageIds[$0 + 1]
        }
    }
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
    PageViewController: UIViewController,
    PagingViewModel: DKUIPagingViewModel
>: UIPageViewController where
PagingViewModel.PageId == PageId,
PageViewController: DKUIPageViewModel,
PageViewController.PageId == PageId,
PageViewController.ViewModel == PagingViewModel.PageViewModel {
    private weak var pagingControl: UIPageControl!
    private var pageViewControllers: [PageId: PageViewController] = [:]
    public var viewModel: PagingViewModel
    private var coordinator: Coordinator
    
    public required init(pagingControl: UIPageControl, viewModel: PagingViewModel) {
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
        
        if let firstPageController = pageController(for: viewModel.firstPageId) {
            self.setViewControllers(
                [firstPageController],
                direction: .forward,
                animated: false
            )
        }
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
        
        guard let pageController = self.pageController(for: selectedPageId) else {
            return
        }
        
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
    
    public func pageController(for pageId: PageId) -> PageViewController? {
        guard let pageViewModel = viewModel.pageViewModel(for: pageId) else {
            return nil
        }
        guard var pageVC = pageViewControllers[pageId]
        else {
            let newPageVC = PageViewController.init(pageId: pageId, pageViewModel: pageViewModel)
            pageViewControllers[pageId] = newPageVC
            return newPageVC
        }
        pageVC.viewModel = pageViewModel
        return pageVC
    }
    
    public func pageId(from pageController: UIViewController) -> PageId? {
        guard let pageController = pageController as? PageViewController else {
            assertionFailure("We should only have \(PageViewController.self) here")
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

extension DKUIPagingCardViewController {
    public static func createPagingViewController(
        configuredWith pagingViewModel: PagingViewModel,
        pagingControl: UIPageControl,
        embededIn pagingContainer: UIView,
        of parentViewController: UIViewController
    ) -> Self {
        let pagingViewController = Self.init(
            pagingControl: pagingControl,
            viewModel: pagingViewModel
        )
        var displayedViewController: UIViewController = pagingViewController
        if pagingViewModel.allPageIds.count > 1 && pagingViewModel.hasData {
            pagingViewController.configure()
            pagingControl.isHidden = false
        } else if let firstPageController = pagingViewController.pageController(
            for: pagingViewModel.firstPageId
        ) {
            displayedViewController = firstPageController
            pagingControl.isHidden = true
        } else {
            pagingContainer.isHidden = true
            pagingControl.isHidden = true
        }

        parentViewController.addChild(displayedViewController)
        pagingContainer.embedSubview(displayedViewController.view)
        pagingContainer.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        pagingContainer.clipsToBounds = true
        displayedViewController.didMove(toParent: parentViewController)
        
        return pagingViewController
    }
}
