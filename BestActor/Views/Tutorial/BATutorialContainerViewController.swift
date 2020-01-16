//
//  BATutorialContainerViewController.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/16/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

class BATutorialContainerViewController: BABaseViewController {

	@IBOutlet weak var pageControl: UIPageControl!

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if let tutorialPageViewController = segue.destination as? BATutorialPageViewController {
			tutorialPageViewController.tutorialDelegate = self
		}
	}
}

// MARK: - BATutorialPageDelegate

extension BATutorialContainerViewController: BATutorialPageDelegate {

	func tutorialPageViewController(_ tutorialPageViewController: BATutorialPageViewController,
									didUpdatePageCount count: Int) {
		pageControl.numberOfPages = count
	}

	func tutorialPageViewController(_ tutorialPageViewController: BATutorialPageViewController,
									didUpdatePageIndex index: Int) {
		pageControl.currentPage = index
	}
}
