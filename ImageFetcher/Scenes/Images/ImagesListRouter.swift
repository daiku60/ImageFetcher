//
//  ImagesListRouter.swift
//  iBooChallenge
//
//  Created by Jordi Serra i Font on 19/2/17.
//  Copyright (c) 2017 kudai. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol ImagesListRouterInput {
    func navigateToDetail(image: ImagesList.Search.Presentable.ViewModel.Image)
}

class ImagesListRouter: ImagesListRouterInput {
    weak var viewController: ImagesListViewController!
    
    // MARK: - Navigation
    
    func navigateToDetail(image: ImagesList.Search.Presentable.ViewModel.Image) {
        
        let detailViewController = ImageDetailViewController(imageURL: image.imageURL)
        viewController.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
}