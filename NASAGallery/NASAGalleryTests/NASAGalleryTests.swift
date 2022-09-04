//
//  NASAGalleryTests.swift
//  NASAGalleryTests
//
//  Created by ahdivio mendes on 31/08/22.
//

import XCTest
@testable import NASAGallery

enum testUrl: String{
    case normalUrl = "https://apod.nasa.gov/apod/image/1912/NGC6744_FinalLiuYuhang1024.jpg"
    case secondNonfake = "https://apod.nasa.gov/apod/image/1912/M27_Mazlin_2000.jpg"
    case fakeUrl = "https://test.com"
}

class NASAGalleryTests: XCTestCase {
    let homViewModel = HomeViewModel()
    let nukeImageManager = NukeImageLoader()
    let detailViewModel = DetailedViewModel()
    let cellSizeConstant:CGFloat = 16384

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //test the functionlaty of decoding json
    func testDecodeJson() throws {
        let value = try JSONDecoder().decodeNASAGalaryData()
        XCTAssertNoThrow(value)
    }
    
    //tests the conversion of string to url
    func testConversionOfStringToURl() throws {
        let val = testUrl.normalUrl.rawValue.returnURl()
        XCTAssertNotNil(val, val!.absoluteString)
        XCTAssert(UIApplication.shared.canOpenURL(val! as URL))
    }
    
    
    //size for cell remains constant in the current code
    func testloadImageCell() throws {
        let cellSize = CGFloat().generateCGFSize()
        XCTAssertNotNil(cellSize, "cell size")
        XCTAssert(cellSize == cellSizeConstant)
    }
    
}

//MARK: - HomdeView Molde
extension NASAGalleryTests {
        //HomdeView Molde
        func testSetHomdeViewModel() throws {
            homViewModel.setModel()
            XCTAssertNotNil(homViewModel.nasaGalleryData, "Not Nil Data")
        }
    
    
        func testCountReturn() throws {
            let count = homViewModel.returnCountOfImages()
            XCTAssertNotNil(count)
        }
    
        func testReturnModel() throws {
            XCTAssertNotNil(homViewModel.getModelData)
        }
    
}


//MARK: - NUKEExtension
extension NASAGalleryTests {
    
    func testNukeImageLoadingOptionsPrequisite() throws {
        let imageLoadingOpts = nukeImageManager.makeImageLoadingOptions()
        let failuerImage = imageLoadingOpts.failureImage
        let cellHolder = imageLoadingOpts.placeholder
        XCTAssertNotNil(failuerImage)
        XCTAssertNotNil(cellHolder)
    }
    
    func testImageHolder() throws {
        XCTAssertNotNil(nukeImageManager.makeErrorAndHolderImage(name: "failerImageSet"))
    }
    
    func testNegativeImageHolder() throws {
        XCTAssertNil(nukeImageManager.makeErrorAndHolderImage(name: "failer"))
    }
    
    
    func testNukeImageRequest() throws {
        XCTAssertNotNil(nukeImageManager.createImageRequest(url: testUrl.normalUrl.rawValue.returnURl()!, cellSize: cellSizeConstant))
    }
    
 
    func testLoadFullImage() {
        let imageView = UIImageView()
        let expect = expectation(description: "returns uiimage from url")
        nukeImageManager.loadFullImage(imageView: imageView, url: testUrl.normalUrl.rawValue.returnURl()!) { error, image in
            XCTAssertNotNil(image)
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 5)
    }
    
    
   @MainActor func testLoadCollectionCells() {
        let imageView = UIImageView()
       nukeImageManager.loadImageCell(url: testUrl.secondNonfake.rawValue.returnURl()!, imageView: imageView, cellSize: cellSizeConstant)
       XCTAssertNotNil(imageView.image)
        
    }
}


//Detailed view model test
extension NASAGalleryTests {
    func testFetchNext() {
        
        //Prequisites required
        detailViewModel.NasaGalaryData = homViewModel.getModelData
        detailViewModel.testImageView = UIImageView()
        
        
        let expectation = expectation(description: "retrve the nextImage")
        detailViewModel.fetchNextImage{ error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testFetchPrevious() {
        
        //Prequisites required
        detailViewModel.NasaGalaryData = homViewModel.getModelData
        detailViewModel.indexOfObject = 3
        detailViewModel.testImageView = UIImageView()
        
        
        let expectation = expectation(description: "retrve the nextImage")
        detailViewModel.fetchPrevious{ error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testCodeToCheckTheEdgeOfData() {
        XCTAssert(detailViewModel.isLastImage() == true)
    }
    
    func testCheckIsLastItem() {
        detailViewModel.NasaGalaryData = homViewModel.getModelData
        detailViewModel.indexOfObject = 10
        XCTAssert(detailViewModel.isLastImage() == false)
    }
    
    
    //Fase
    func testIndexWithinBoundsT() {
        detailViewModel.indexOfObject = 10
        XCTAssert(detailViewModel.isIndexWithinBounds() == false)
    }
    
    
    //True
    func testIndexWithinBoundsF() {
        detailViewModel.NasaGalaryData = homViewModel.getModelData
        detailViewModel.indexOfObject = 10
        XCTAssert(detailViewModel.isIndexWithinBounds() == true)
    }
    
    func testReturnTitle() {
        detailViewModel.NasaGalaryData = homViewModel.getModelData
        detailViewModel.indexOfObject = 10
        XCTAssertNotNil(detailViewModel.getImageTitle())
    }
    
    func testReturnCopyRight() {
        detailViewModel.NasaGalaryData = homViewModel.getModelData
        detailViewModel.indexOfObject = 10
        XCTAssertNotNil(detailViewModel.getCopyRight())
    }
    
    func testReturnDate() {
        detailViewModel.NasaGalaryData = homViewModel.getModelData
        detailViewModel.indexOfObject = 10
        XCTAssertNotNil(detailViewModel.getDate())
    }
    
    
    func testReturnDescription() {
        detailViewModel.NasaGalaryData = homViewModel.getModelData
        detailViewModel.indexOfObject = 10
        XCTAssertNotNil(detailViewModel.getImageExplanation())
    }
    
    
    func testReturnUrl() {
        detailViewModel.NasaGalaryData = homViewModel.getModelData
        detailViewModel.indexOfObject = 10
        XCTAssertNotNil(detailViewModel.getHdUrl())
    }
    
    
    func testReturnHDURl() {
        detailViewModel.NasaGalaryData = homViewModel.getModelData
        detailViewModel.indexOfObject = 10
        XCTAssertNotNil(detailViewModel.getHdUrl())
    }
 
 
}
