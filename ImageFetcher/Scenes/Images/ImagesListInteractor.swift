//
//  ImagesListInteractor.swift
//  iBooChallenge
//
//  Created by Jordi Serra i Font on 19/2/17.
//  Copyright (c) 2017 kudai. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol ImagesListInteractorInput {
    func searchImages(request: ImagesList.Search.Request)
}

protocol ImagesListInteractorOutput {
    func presentSearch(response: ImagesList.Search.Response)
}

class ImagesListInteractor: ImagesListInteractorInput {
    var output: ImagesListInteractorOutput!
    var fetcher: ImagesListFetcher
    
    init(withFetcher fetcher: ImagesListFetcher) {
        self.fetcher = fetcher
    }
    
    // MARK: - Business logic
    
    func searchImages(request: ImagesList.Search.Request) {
        let searchTask = fetcher.fetchImages(withSearchTerm: request.searchTerm, page: request.currentPage, pageSize: request.numberOfItems)
        
        searchTask.upon(DispatchQueue.main) { (result) in
            let response = ImagesList.Search.Response(taskResult: result)
            self.output.presentSearch(response: response)
        }
    }
}