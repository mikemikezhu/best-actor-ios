//
//  BATutorialPageViewController.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/16/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

class BATutorialPageViewController: UIPageViewController {

	private(set) lazy var orderedViewControllers: [UIViewController] = {

		// The view controllers will be shown in this order
		return [findViewController("first_tutorial"),
				findViewController("second_tutorial"),
				findViewController("third_tutorial")]
	}()

	weak var tutorialDelegate: BATutorialPageDelegate?

	override func viewDidLoad() {

		super.viewDidLoad()

		dataSource = self
		delegate = self

		// Set first view controller
		if let firstViewController = orderedViewControllers.first {
			setViewControllers([firstViewController],
							   direction: .forward,
							   animated: true,
							   completion: nil)
		}

		// Update page count
		tutorialDelegate?.tutorialPageViewController(self, didUpdatePageCount: orderedViewControllers.count)
	}

	private func findViewController(_ identifier: String) -> UIViewController {

		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		return storyboard.instantiateViewController(withIdentifier: identifier)
	}
}

// MARK: - UIPageViewControllerDataSource

extension BATutorialPageViewController: UIPageViewControllerDataSource {

	func pageViewController(_ pageViewController: UIPageViewController,
							viewControllerBefore viewController: UIViewController) -> UIViewController? {

		guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
			return nil
		}

		let previousIndex = viewControllerIndex - 1

		guard previousIndex >= 0 else {
			// User is on the first view controller
			return nil
		}

		let orderedViewControllersCount = orderedViewControllers.count
		guard orderedViewControllersCount > previousIndex else {
			return nil
		}

		return orderedViewControllers[previousIndex]
	}

	func pageViewController(_ pageViewController: UIPageViewController,
							viewControllerAfter viewController: UIViewController) -> UIViewController? {

		guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
			return nil
		}

		let nextIndex = viewControllerIndex + 1
		let orderedViewControllersCount = orderedViewControllers.count

		guard orderedViewControllersCount != nextIndex else {
			// User is on the last view controller
			return nil
		}

		guard orderedViewControllersCount > nextIndex else {
			return nil
		}

		return orderedViewControllers[nextIndex]
	}
}

// MARK: - UIPageViewControllerDelegate

extension BATutorialPageViewController: UIPageViewControllerDelegate {

	func pageViewController(_ pageViewController: UIPageViewController,
							didFinishAnimating finished: Bool,
							previousViewControllers: [UIViewController],
							transitionCompleted completed: Bool) {

		if let contentViewControllers = pageViewController.viewControllers,
			let currentContentViewController = contentViewControllers.first,
			let index = orderedViewControllers.firstIndex(of: currentContentViewController) {

			// Update page index
			tutorialDelegate?.tutorialPageViewController(self, didUpdatePageIndex: index)
		}
	}
}
