//
//  After15TestVC.swift
//  ResizeView
//
//  Created by nick on 2021/6/28.
//

import UIKit

final class After15TestVC: BaseTestVC, UISheetPresentationControllerDelegate {
    
    override func tapTest() {
        let nextVC: TestTableVC = TestTableVC()
        nextVC.delegate = self

        if let sheet = nextVC.sheetPresentationController {
            sheet.detents = [.large(), .medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.delegate = self
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 0
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.smallestUndimmedDetentIdentifier = .medium
            sheet.animateChanges { }
        }
        present(nextVC, animated: true)
    }
    
    // MARK: - UISheetPresentationControllerDelegate
    
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        print(msg: sheetPresentationController.selectedDetentIdentifier?.rawValue)
    }
    
}
