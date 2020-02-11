//
//  BAFacialExpressionLoadingViewController.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/18/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

class BAFacialExpressionLoadingViewController: UIViewController {

	@IBOutlet weak var indicatorView: UIActivityIndicatorView!

	override func viewDidLoad() {
		super.viewDidLoad()

		if #available(iOS 13.0, *) {
			indicatorView.style = .large
		}
		view.backgroundColor = UIColor.customLoadingViewBackgroundColor
	}
}
