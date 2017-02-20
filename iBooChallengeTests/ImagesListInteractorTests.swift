//
//  iBooChallengeTests.swift
//  iBooChallengeTests
//
//  Created by Jordi Serra i Font on 19/2/17.
//  Copyright © 2017 kudai. All rights reserved.
//

import XCTest
import Deferred
@testable import iBooChallenge

class ImagesListInteractorTests: XCTestCase {
    
    let anyString = "Any String"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    class FetcherFake: ImagesListFetcher {
        var fetcherCalled = false
        
        func fetchImages(withSearchTerm: String, page: Int, pageSize: Int) -> Task<[String : Any]> {
            fetcherCalled = true
            let deferred = Deferred<TaskResult<[String: Any]>>()
            deferred.fill(with: .success(["images":"fake"]))
            
            return Task(future: Future(deferred))
        }
    }
    
    class ImagesListInteractorSpyOutput: ImagesListInteractorOutput {
        var presentSearchCalled = false
        
        func presentSearch(response: ImagesList.Search.Response) {
            presentSearchCalled = true
        }
    }
    
    func testSearchImagesShouldCallGettyFetcherFake() {
        
        let exp = expectation(description: "Calls fetcher and waits result to be forwarded to the presenter")
        
        //Given
        let fetcher = FetcherFake()
        let interactor = ImagesListInteractor(withFetcher: fetcher)
        let spyOutput = ImagesListInteractorSpyOutput()
        interactor.output = spyOutput
        let request = ImagesList.Search.Request(searchTerm: anyString)
        
        //When
        interactor.searchImages(request: request)
        
        //Then
        XCTAssert(fetcher.fetcherCalled, "Fetcher must be called!")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            XCTAssert(spyOutput.presentSearchCalled, "Output not called")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
    }
    
    func testSearchImagesShouldCallGettyFetcherGetty() {
        
        let exp = expectation(description: "Calls fetcher and waits result to be forwarded to the presenter")
        
        //Given
        let fetcher = GettyFetcher.instance
        let interactor = ImagesListInteractor(withFetcher: fetcher)
        let spyOutput = ImagesListInteractorSpyOutput()
        interactor.output = spyOutput
        let request = ImagesList.Search.Request(searchTerm: anyString)
        
        //When
        interactor.searchImages(request: request)
        
        //Then
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 8) {
            XCTAssert(spyOutput.presentSearchCalled, "Output not called")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
    }
}
