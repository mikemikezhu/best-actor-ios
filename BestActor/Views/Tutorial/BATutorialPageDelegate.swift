//
//  BATutorialPageDelegate.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/16/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import Foundation

protocol BATutorialPageDelegate: class {

	/**
	Called when the number of pages is updated.

	- parameter tutorialPageViewController: the BATutorialPageViewController instance
	- parameter count: the total number of pages.
	*/
	func tutorialPageViewController(_ tutorialPageViewController: BATutorialPageViewController,
									didUpdatePageCount count: Int)

	/**
	Called when the current index is updated.

	- parameter tutorialPageViewController: the BATutorialPageViewController instance
	- parameter index: the index of the currently visible page.
	*/
	func tutorialPageViewController(_ tutorialPageViewController: BATutorialPageViewController,
									didUpdatePageIndex index: Int)

}
