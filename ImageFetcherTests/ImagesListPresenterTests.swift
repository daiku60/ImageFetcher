//
//  ImagesListPresenterTests.swift
//  iBooChallenge
//
//  Created by Jordi Serra i Font on 20/2/17.
//  Copyright © 2017 kudai. All rights reserved.
//

import XCTest
import Deferred
@testable import iBooChallenge

class ImagesListPresenterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    class ImagesListPresenterOutputSpy: ImagesListPresenterOutput {
        var displayCalled = false
        
        func display(_ presentable: ImagesList.Search.Presentable) {
            displayCalled = true
        }
    }
    
    func testPresenterShouldMarkEmptyJSONAsError() {
        
        // Given
        let presenter = ImagesListPresenter()
        let spy = ImagesListPresenterOutputSpy()
        presenter.output = spy
        
        let taskResult = TaskResult<[String:Any]>.success([:])
        let response = ImagesList.Search.Response(taskResult: taskResult)
        
        // When
        presenter.presentSearch(response: response)
        
        // Then
        XCTAssert(spy.displayCalled, "Display should be called!")
    }
    
    func testPresenterShouldParseJSONFromInteractor() {
        
        // Given
        guard let url = Bundle.main.url(forResource: "imagesList", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []),
            let json = jsonObj as? [String:Any] else {
                fatalError()
        }
        let taskResult = TaskResult<[String:Any]>.success(json)
        
        let presenter = ImagesListPresenter()
        let spy = ImagesListPresenterOutputSpy()
        presenter.output = spy
        let response = ImagesList.Search.Response(taskResult: taskResult)
        
        // When
        presenter.presentSearch(response: response)
        
        // Then
        XCTAssert(spy.displayCalled, "Display should be called!")
    }
    
}
