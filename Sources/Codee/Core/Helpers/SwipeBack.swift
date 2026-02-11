//
//  File.swift
//  Codee
//
//  Created by Eryk Chrustek on 11/02/2026.
//

import SwiftUI
import UIKit

private struct PopGestureEnabler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        Controller()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    public final class Controller: UIViewController, UIGestureRecognizerDelegate {
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            navigationController?.interactivePopGestureRecognizer?.delegate = self
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            (navigationController?.viewControllers.count ?? 0) > 1 // min 2 VC
        }
    }
}

public extension View {
    func enableSwipeBack() -> some View {
        background(PopGestureEnabler())
    }
}
