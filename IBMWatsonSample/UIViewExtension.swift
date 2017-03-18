//
//  UIViewExtension.swift
//  IBMWatsonSample
//
//  Created by Sahand Edrisian on 3/18/17.
//  Copyright © 2017 DreamTeam5Ever. All rights reserved.
//

import UIKit



extension UIView {
    func animateAlpha(_ a: CGFloat, t: Double) {
        UIView.animate(withDuration: t, animations: {
            self.alpha = a
        })
    }
}
