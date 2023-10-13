//
//  ID3PopularimeterFrameCreatorTest.swift
//
//  Created by Andy Clynes on 09/10/2023.
//  2023 Andy Clynes.
//

import XCTest
@testable import ID3TagEditor

class ID3PopularimeterFrameCreatorTest: XCTestCase {
    
    func testFrameCreationWhenThereIsAPopularimeter() throws {
        
        //Popularimeter   "POPM"
        //Frame size      $xx xx xx xx
        //Email to user   john.doe@test.com$00
        //Rating          $1
        //Counter         $xx xx xx 08 (xx ...)

        
        //Set up a byte array for a test frame.
        let email = "john.doe@test.com"
        let emailBytes: [UInt8] = [0x6a, 0x6f, 0x68, 0x6e, 0x2e, 0x64, 0x6f, 0x65, 0x40, 0x74, 0x65, 0x73, 0x74, 0x2e, 0x63, 0x6f, 0x6d, 0x00]
        let rating = 1
        let ratingBytes: [UInt8] = [0x01]
        let playCount = 8
        let playCountBytes: [UInt8] = [0x00, 0x00, 0x00, 0x08]

        let headerBytes: [UInt8] = [0x50, 0x4f, 0x50, 0x4d] //POPM
        var sizeBytes: [UInt8] = [0x00, 0x00, 0x00, 0x00]
        let flagBytes: [UInt8] = [0x00, 0x00]
        
        let newFrameContentBytes: [UInt8] =
            emailBytes + ratingBytes + playCountBytes
        
        sizeBytes[3] = UInt8(newFrameContentBytes.count)

        let testFrameBytes: [UInt8] = headerBytes + sizeBytes + flagBytes + newFrameContentBytes

        //Create a test frame using the API.
        let id3tag = ID3Tag(
            version: .version4,
            frames: [.popularimeter : ID3FramePopularimeter(email: email, rating: PopularimeterRating(rating), counter: playCount)]
        )
        
        let frameConfiguration = ID3FrameConfiguration()
        let id3PopularimeterFrameCreator = ID3PopularimeterFramesCreator(frameConfiguration: frameConfiguration)
        
        let newTagBytes = id3PopularimeterFrameCreator.createFrames(id3Tag: id3tag)

        //Compare the expected bytes of the test frame with the frame bytes created through the API.
        XCTAssertEqual(testFrameBytes, newTagBytes)

        //Parse the returned frame bytes and compare with the original values.
        ID3PopularimeterFrameContentParsingOperation(id3FrameConfiguration: ID3FrameConfiguration()).parse(frame: Data(newTagBytes), version: ID3Version.version4) { frameName, frame in
            XCTAssertEqual(frameName, FrameName.popularimeter)
            XCTAssertEqual(frameName, FrameName.popularimeter)
            let popluarimeterFrame = frame as! ID3FramePopularimeter
            XCTAssertEqual(popluarimeterFrame.email, email)
            XCTAssertEqual(popluarimeterFrame.rating, PopularimeterRating(rating))
            XCTAssertEqual(popluarimeterFrame.counter, playCount)
        }
    }
    
    func testFrameCreationWhenThereIsAPopularimeterWithNoEmail() throws {
        
        //Popularimeter   "POPM"
        //Frame size      $xx xx xx xx
        //Email to user   john.doe@test.com$00
        //Rating          $1
        //Counter         $xx xx xx 08 (xx ...)

        
        //Set up a byte array for a test frame.
        let email = ""
        let emailBytes: [UInt8] = [0x00]
        let rating = 1
        let ratingBytes: [UInt8] = [0x01]
        let playCount = 8
        let playCountBytes: [UInt8] = [0x00, 0x00, 0x00, 0x08]

        let headerBytes: [UInt8] = [0x50, 0x4f, 0x50, 0x4d] //POPM
        var sizeBytes: [UInt8] = [0x00, 0x00, 0x00, 0x00]
        let flagBytes: [UInt8] = [0x00, 0x00]
        
        let newFrameContentBytes: [UInt8] =
            emailBytes + ratingBytes + playCountBytes
        
        sizeBytes[3] = UInt8(newFrameContentBytes.count)

        let testFrameBytes: [UInt8] = headerBytes + sizeBytes + flagBytes + newFrameContentBytes

        //Create a test frame using the API.
        let id3tag = ID3Tag(
            version: .version4,
            frames: [.popularimeter : ID3FramePopularimeter(email: email, rating: PopularimeterRating(rating), counter: playCount)]
        )
        
        let frameConfiguration = ID3FrameConfiguration()
        let id3PopularimeterFrameCreator = ID3PopularimeterFramesCreator(frameConfiguration: frameConfiguration)
        
        let newTagBytes = id3PopularimeterFrameCreator.createFrames(id3Tag: id3tag)

        //Compare the expected bytes of the test frame with the frame bytes created through the API.
        XCTAssertEqual(testFrameBytes, newTagBytes)

        //Parse the returned frame bytes and compare with the original values.
        ID3PopularimeterFrameContentParsingOperation(id3FrameConfiguration: ID3FrameConfiguration()).parse(frame: Data(newTagBytes), version: ID3Version.version4) { frameName, frame in
            XCTAssertEqual(frameName, FrameName.popularimeter)
            XCTAssertEqual(frameName, FrameName.popularimeter)
            let popluarimeterFrame = frame as! ID3FramePopularimeter
            XCTAssertEqual(popluarimeterFrame.email, email)
            XCTAssertEqual(popluarimeterFrame.rating, PopularimeterRating(rating))
            XCTAssertEqual(popluarimeterFrame.counter, playCount)
        }
    }
    

}
