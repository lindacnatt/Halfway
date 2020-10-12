//
//  ViewToUIImage.swift
//  Halfway
//
//  Created by Johannes on 2020-10-10.
//  Copyright © 2020 Halfway. All rights reserved.
//
//  About: Extensions to SwiftUI View and UIView that converts the former to the latter
//  and then converts that new UIView to a UIImage. Needed for using SwiftUI to make custom Mapkit
//  annotations.

import SwiftUI
import UIKit

extension View {
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        
        //Making the background transparent in case the SwiftUI View is not rectagular
        controller.view.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        //Calling the function in the UIView extension below.
        let image = controller.view.asUIImage()
        
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    // Converts UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
