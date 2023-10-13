//
//  ID3PopularimeterFrameContentParsingOperationTest.swift
//
//  Created by Andy Clynes on 12/10/2023.
//  2023 Andy Clynes.
//

import XCTest
@testable import ID3TagEditor

class ID3PopularimeterFrameContentParsingOperationTest: XCTestCase {
    
    //The amount of time we will wait for an expectation to fail
    let failureTimeout = TimeInterval(0.25)
    
    func testframeContentValidPopularimeter() {
        let expectation = XCTestExpectation(description: "popularimeter")
        
        let popularimeterParsingOperation = ID3PopularimeterFrameContentParsingOperationFactory.make()
        
        popularimeterParsingOperation.parse(frame: frameV4Valid(), version: .version4, completed: { (frameName, frame) in
        
            XCTAssertEqual(frameName, .popularimeter)
            XCTAssertEqual((frame as? ID3FramePopularimeter)?.email, "john.doe@test.com")
            XCTAssertEqual((frame as? ID3FramePopularimeter)?.rating, PopularimeterRating(1))
            XCTAssertEqual((frame as? ID3FramePopularimeter)?.counter, 8)
            
            expectation.fulfill()

        })
        wait(for: [expectation], timeout: failureTimeout)
    }
    
    func testframeContentValidPopularimeterWithBigPlaycount() {
        let expectation = XCTestExpectation(description: "popularimeter")
        
        let popularimeterParsingOperation = ID3PopularimeterFrameContentParsingOperationFactory.make()
        
        popularimeterParsingOperation.parse(frame: frameV4ValidWithBigPlaycount(), version: .version4, completed: { (frameName, frame) in
        
            XCTAssertEqual(frameName, .popularimeter)
            XCTAssertEqual((frame as? ID3FramePopularimeter)?.email, "john.doe@test.com")
            XCTAssertEqual((frame as? ID3FramePopularimeter)?.rating, PopularimeterRating(196))
            XCTAssertEqual((frame as? ID3FramePopularimeter)?.counter, 129862)
            
            expectation.fulfill()

        })
        wait(for: [expectation], timeout: failureTimeout)
    }
    
    func testframeInvalidNoEmailTerminator() {
        let expectation = XCTestExpectation(description: "popularimeter")
        expectation.isInverted = true
        
        let popularimeterParsingOperation = ID3PopularimeterFrameContentParsingOperationFactory.make()
        
        popularimeterParsingOperation.parse(frame: frameV4InvalidNoEmailTerminator(), version: .version4, completed: { (frameName, frame) in
        
            //Fulfil the expectation, which is a failure because we somehow parsed the invalid frame.
            expectation.fulfill()

        })
        wait(for: [expectation], timeout: failureTimeout)
    }
    
    func testInvalidFrameNoRating() {
        let expectation = XCTestExpectation(description: "popularimeter")
        expectation.isInverted = true
        
        let popularimeterParsingOperation = ID3PopularimeterFrameContentParsingOperationFactory.make()
        
        popularimeterParsingOperation.parse(frame: frameV4InvalidNoRating(), version: .version4, completed: { (frameName, frame) in
        
            //No point checking the values. Just need to ensure it doesn't crash
            expectation.fulfill()

        })
        wait(for: [expectation], timeout: failureTimeout)
    }
    
    func testframeInvalidNoContent() {
        let expectation = XCTestExpectation(description: "popularimeter")
        expectation.isInverted = true
        
        let popularimeterParsingOperation = ID3PopularimeterFrameContentParsingOperationFactory.make()
        
        popularimeterParsingOperation.parse(frame: frameV4InvalidNoContent(), version: .version4, completed: { (frameName, frame) in
        
            //No point checking the values. Just need to ensure it doesn't crash
            expectation.fulfill()

        })
        wait(for: [expectation], timeout: 1)
    }
    
    func testframeInvalidNoPlayCount() {
        let expectation = XCTestExpectation(description: "popularimeter")
        expectation.isInverted = true
        
        let popularimeterParsingOperation = ID3PopularimeterFrameContentParsingOperationFactory.make()
        
        popularimeterParsingOperation.parse(frame: frameV4InvalidNoPlayCount(), version: .version4, completed: { (frameName, frame) in
        
            //No point checking the values. Just need to ensure it doesn't crash
            expectation.fulfill()

        })
        wait(for: [expectation], timeout: failureTimeout)
    }
    
    func testframeInvalidMalformedPlayCount() {
        let expectation = XCTestExpectation(description: "popularimeter")
        expectation.isInverted = true
        
        let popularimeterParsingOperation = ID3PopularimeterFrameContentParsingOperationFactory.make()
        
        popularimeterParsingOperation.parse(frame: frameV4InvalidMalformedPlayCount(), version: .version4, completed: { (frameName, frame) in
        
            //No point checking the values. Just need to ensure it doesn't crash
            expectation.fulfill()

        })
        wait(for: [expectation], timeout: failureTimeout)
    }
 
    private func frameV4Valid() -> Data {

        //Popularimeter   "POPM"
        //Frame size      $xx xx xx xx
        //Email to user   john.doe@test.com$00
        //Rating          $1
        //Counter         $xx xx xx 08 (xx ...)

        
        //Set up a byte array for a test frame.
        let email = "john.doe@test.com"
        let emailBytes: [UInt8] = email.utf8 + [0x00]
        let rating = 1
        let ratingBytes: [UInt8] = [UInt8(rating)]
        let playCount = 8
        let playCountBytes: [UInt8] = [0x00, 0x00, 0x00, UInt8(playCount)]

        let headerBytes: [UInt8] = [0x50, 0x4f, 0x50, 0x4d] //POPM
        var sizeBytes: [UInt8] = [0x00, 0x00, 0x00, 0x00]
        let flagBytes: [UInt8] = [0x00, 0x00]
        
        let newFrameContentBytes: [UInt8] =
            emailBytes + ratingBytes + playCountBytes
        
        sizeBytes[3] = UInt8(newFrameContentBytes.count)
        
        let testFrameBytes: [UInt8] = headerBytes + sizeBytes + flagBytes + newFrameContentBytes

        return Data(testFrameBytes)

        
    }
    
    private func frameV4ValidWithBigPlaycount() -> Data {

        //Popularimeter   "POPM"
        //Frame size      $xx xx xx xx
        //Email to user   john.doe@test.com$00
        //Rating          $1
        //Counter         $xx xx xx 08 (xx ...)

        
        //Set up a byte array for a test frame.
        let email = "john.doe@test.com"
        let emailBytes: [UInt8] = email.utf8 + [0x00]
        let rating = 196
        let ratingBytes: [UInt8] = [UInt8(rating)]
        let playCount: Int32 = 129862
        let playCountBytes: [UInt8] = withUnsafeBytes(of: playCount.bigEndian, Array.init)
        XCTAssertEqual(playCountBytes.count, 4)

        let headerBytes: [UInt8] = [0x50, 0x4f, 0x50, 0x4d] //POPM
        var sizeBytes: [UInt8] = [0x00, 0x00, 0x00, 0x00]
        let flagBytes: [UInt8] = [0x00, 0x00]
        
        let newFrameContentBytes: [UInt8] =
            emailBytes + ratingBytes + playCountBytes
        
        sizeBytes[3] = UInt8(newFrameContentBytes.count)
        
        let testFrameBytes: [UInt8] = headerBytes + sizeBytes + flagBytes + newFrameContentBytes

        return Data(testFrameBytes)

        
    }

    ///Return a frame that is valid apart from having removed the email terminator.
    private func frameV4InvalidNoEmailTerminator() -> Data {
        
        //Popularimeter   "POPM"
        //Frame size      $xx xx xx xx
        //Email to user   john.doe@test.com$00
        //Rating          $1
        //Counter         $xx xx xx 08 (xx ...)

        
        //Set up a byte array for a test frame.
        let email = "john.doe@test.com"
        let emailBytes: [UInt8] = [UInt8](email.utf8)/* + [0x00]*/
        let rating = 1
        let ratingBytes: [UInt8] = [UInt8(rating)]
        let playCount = 8
        let playCountBytes: [UInt8] = [0x00, 0x00, 0x00, UInt8(playCount)]

        let headerBytes: [UInt8] = [0x50, 0x4f, 0x50, 0x4d] //POPM
        var sizeBytes: [UInt8] = [0x00, 0x00, 0x00, 0x00]
        let flagBytes: [UInt8] = [0x00, 0x00]
        
        let newFrameContentBytes: [UInt8] =
            emailBytes + ratingBytes + playCountBytes
        
        sizeBytes[3] = UInt8(newFrameContentBytes.count)
        
        let testFrameBytes: [UInt8] = headerBytes + sizeBytes + flagBytes + newFrameContentBytes

        return Data(testFrameBytes)
        
        
    }
    
    ///Return a frame that is missing the rating.
    private func frameV4InvalidNoRating() -> Data {
        
        //Popularimeter   "POPM"
        //Frame size      $xx xx xx xx
        //Email to user   john.doe@test.com$00
        //Rating          $1
        //Counter         $xx xx xx 08 (xx ...)

        
        //Set up a byte array for a test frame.
        let email = "john.doe@test.com"
        let emailBytes: [UInt8] = [UInt8](email.utf8) + [0x00]
        //let rating = 1
        //let ratingBytes: [UInt8] = [UInt8(rating)]
        let playCount = 8
        let playCountBytes: [UInt8] = [0x00, 0x00, 0x00, UInt8(playCount)]

        let headerBytes: [UInt8] = [0x50, 0x4f, 0x50, 0x4d] //POPM
        var sizeBytes: [UInt8] = [0x00, 0x00, 0x00, 0x00]
        let flagBytes: [UInt8] = [0x00, 0x00]
        
        let newFrameContentBytes: [UInt8] =
            emailBytes + /*ratingBytes + */ playCountBytes
        
        sizeBytes[3] = UInt8(newFrameContentBytes.count)
        
        let testFrameBytes: [UInt8] = headerBytes + sizeBytes + flagBytes + newFrameContentBytes

        return Data(testFrameBytes)
        
        
    }
    
    ///Return a frame that is missing the play count.
    private func frameV4InvalidNoPlayCount() -> Data {
        
        //Popularimeter   "POPM"
        //Frame size      $xx xx xx xx
        //Email to user   john.doe@test.com$00
        //Rating          $1
        //Counter         $xx xx xx 08 (xx ...)

        
        //Set up a byte array for a test frame.
        let email = "john.doe@test.com"
        let emailBytes: [UInt8] = [UInt8](email.utf8) + [0x00]
        let rating = 1
        let ratingBytes: [UInt8] = [UInt8(rating)]
        //let playCount = 8
        //let playCountBytes: [UInt8] = [0x00, 0x00, 0x00, UInt8(playCount)]

        let headerBytes: [UInt8] = [0x50, 0x4f, 0x50, 0x4d] //POPM
        var sizeBytes: [UInt8] = [0x00, 0x00, 0x00, 0x00]
        let flagBytes: [UInt8] = [0x00, 0x00]
        
        //Remove the play count.
        let newFrameContentBytes: [UInt8] =
            emailBytes + ratingBytes /*+ playCountBytes*/
        
        sizeBytes[3] = UInt8(newFrameContentBytes.count)
        
        let testFrameBytes: [UInt8] = headerBytes + sizeBytes + flagBytes + newFrameContentBytes

        return Data(testFrameBytes)
        
        
    }
    
    ///Return a frame that has a 3-byte play count instead of 4-byte.
    private func frameV4InvalidMalformedPlayCount() -> Data {
        
        //Popularimeter   "POPM"
        //Frame size      $xx xx xx xx
        //Email to user   john.doe@test.com$00
        //Rating          $1
        //Counter         $xx xx xx 08 (xx ...)

        
        //Set up a byte array for a test frame.
        let email = "john.doe@test.com"
        let emailBytes: [UInt8] = [UInt8](email.utf8) + [0x00]
        let rating = 1
        let ratingBytes: [UInt8] = [UInt8(rating)]
        let playCount = 8
        //Remove one of the play count bytes
        let playCountBytes: [UInt8] = [/*0x00,*/ 0x00, 0x00, UInt8(playCount)]

        let headerBytes: [UInt8] = [0x50, 0x4f, 0x50, 0x4d] //POPM
        var sizeBytes: [UInt8] = [0x00, 0x00, 0x00, 0x00]
        let flagBytes: [UInt8] = [0x00, 0x00]
        
        let newFrameContentBytes: [UInt8] =
            emailBytes + ratingBytes + playCountBytes
        
        sizeBytes[3] = UInt8(newFrameContentBytes.count)
        
        let testFrameBytes: [UInt8] = headerBytes + sizeBytes + flagBytes + newFrameContentBytes

        return Data(testFrameBytes)
        
        
    }
    
    ///Return a frame that has no content, just a header.
    private func frameV4InvalidNoContent() -> Data {
        
        //Popularimeter   "POPM"
        //Frame size      $xx xx xx xx
        //Email to user   john.doe@test.com$00
        //Rating          $1
        //Counter         $xx xx xx 08 (xx ...)

        let headerBytes: [UInt8] = [0x50, 0x4f, 0x50, 0x4d] //POPM
        var sizeBytes: [UInt8] = [0x00, 0x00, 0x00, 0x00]
        let flagBytes: [UInt8] = [0x00, 0x00]
        
        let newFrameContentBytes: [UInt8] = []
        
        sizeBytes[3] = UInt8(newFrameContentBytes.count)
        
        let testFrameBytes: [UInt8] = headerBytes + sizeBytes + flagBytes + newFrameContentBytes

        return Data(testFrameBytes)
        
        
    }
    
    ///Return a frame that has an incorrect size byte
    private func frameV4InvalidWrongSize() -> Data {

        //Popularimeter   "POPM"
        //Frame size      $xx xx xx xx
        //Email to user   john.doe@test.com$00
        //Rating          $1
        //Counter         $xx xx xx 08 (xx ...)

        
        //Set up a byte array for a test frame.
        let email = "john.doe@test.com"
        let emailBytes: [UInt8] = email.utf8 + [0x00]
        let rating = 1
        let ratingBytes: [UInt8] = [UInt8(rating)]
        let playCount = 8
        let playCountBytes: [UInt8] = [0x00, 0x00, 0x00, UInt8(playCount)]

        let headerBytes: [UInt8] = [0x50, 0x4f, 0x50, 0x4d] //POPM
        var sizeBytes: [UInt8] = [0x00, 0x00, 0x00, 0x00]
        let flagBytes: [UInt8] = [0x00, 0x00]
        
        let newFrameContentBytes: [UInt8] =
            emailBytes + ratingBytes + playCountBytes
        
        sizeBytes[3] = UInt8(200)
        
        let testFrameBytes: [UInt8] = headerBytes + sizeBytes + flagBytes + newFrameContentBytes

        return Data(testFrameBytes)

        
    }

    static let allTests = [
        ("testframeContentValidPopularimeter", testframeContentValidPopularimeter),
        ("testframeContentValidPopularimeterWithBigPlaycount", testframeContentValidPopularimeterWithBigPlaycount),
        ("testframeInvalidNoEmailTerminator", testframeInvalidNoEmailTerminator),
        ("testInvalidFrameNoRating", testInvalidFrameNoRating),
        ("testframeInvalidNoContent", testframeInvalidNoContent),
        ("testframeInvalidNoPlayCount", testframeInvalidNoPlayCount),
        ("testframeInvalidNoPlayCount", testframeInvalidMalformedPlayCount)
    ]
}

