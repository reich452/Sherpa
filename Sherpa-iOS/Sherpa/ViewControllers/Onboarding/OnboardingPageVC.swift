//
//  OnboardingPageVC.swift
//  Sherpa
//
//  Created by Nick Reichard on 8/5/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

class OnboardingPageVC: UIPageViewController {
    
    public var pageControl = UIPageControl()
    var pageIndex = 0 {
        didSet {
            updateCurrentPage()
        }
    }
    
    lazy var pages: [UIViewController] = {
        let firstOnboardVC = FirstOnboardVC.instantiate(fromAppStoryboard: .Onboard)
        let secondOnboardVC = SecondOnboardVC.instantiate(fromAppStoryboard: .Onboard)
        let thirdOnboardVC = ThirdOnboardVC.instantiate(fromAppStoryboard: .Onboard)
        return [firstOnboardVC, secondOnboardVC, thirdOnboardVC]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate  = self
        configurePageControl()
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.alpha = 0.5
        pageControl.tintColor = .black
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .black
        view.addSubview(pageControl)
    }
    
    public func updateCurrentPage() {
        pageControl.currentPage = pageIndex
    }
}

extension OnboardingPageVC: UIPageViewControllerDataSource {
    
    // MARK: - DataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return pages.last }
        guard pages.count > previousIndex else { return nil }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil }
        return pages[nextIndex]
    }
}

extension OnboardingPageVC: UIPageViewControllerDelegate {
    
    // MARK: - Delegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let pageContentViewController = pageViewController.viewControllers?.first else { return }
        let index = pages.firstIndex(of: pageContentViewController) ?? 0
        self.pageIndex = index
        self.pageControl.currentPage = index
    }
}

// MARK: - UIPageViewController Extention helper

extension UIPageViewController {
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentViewController = viewControllers?.first else { return }
        if let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) {
            setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
        }
    }
}
