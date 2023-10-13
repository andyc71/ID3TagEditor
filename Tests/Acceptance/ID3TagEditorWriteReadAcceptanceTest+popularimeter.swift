//
//  ID3TagEditorWriteReadAcceptanceTest+popularimeter.swift
//  ID3TagEditor
//
//  Created by Andy Clynes on 11.10.23.
//  Copyright © 2023 Andy Clynes. All rights reserved.
//

// swiftlint:disable type_body_length
// swiftlint:disable function_body_length
// swiftlint:disable line_length
// swiftlint:disable file_length

import XCTest
@testable import ID3TagEditor

extension ID3TagEditorWriteReadAcceptanceTest {
    
    func testReadPopularimeter() throws {
        let email = "john.doe@test.com"
        let rating = 196
        let counter = 8

        let path = PathLoader().pathFor(name: "example-cover", fileType: "jpg")
        let cover = try Data(contentsOf: URL(fileURLWithPath: path))
        
        let id3Tag = try id3TagEditor.read(from: PathLoader().pathFor(name: "example-with-rating", fileType: "mp3"))
        
        XCTAssertEqual((id3Tag?.frames[.popularimeter] as? ID3FramePopularimeter)?.email, "john.doe@test.com")
        XCTAssertEqual((id3Tag?.frames[.popularimeter] as? ID3FramePopularimeter)?.rating, PopularimeterRating(196))
        XCTAssertEqual((id3Tag?.frames[.popularimeter] as? ID3FramePopularimeter)?.counter, 8)
    }
    
    
    func testWritePopularimeter() throws {
        
        let email = "john.doe@test.com"
        let rating = 196
        let counter = 8
        
        let art: Data = try! Data(
            contentsOf: URL(fileURLWithPath: PathLoader().pathFor(name: "example-cover", fileType: "jpg"))
        )
        let pathMp3ToCompare = PathLoader().pathFor(name: "example-with-rating", fileType: "mp3")
        let pathMp3Generated = NSHomeDirectory() + "/example-with-rating-v2.mp3"
        var id3Tag = ID3Tag(
            version: .version2,
            frames: [
                .artist : ID3FrameWithStringContent(content: "example artist"),
                .albumArtist : ID3FrameWithStringContent(content: "example album artist"),
                .album : ID3FrameWithStringContent(content: "example album"),
                .title : ID3FrameWithStringContent(content: "example song"),
                .attachedPicture(.frontCover) : ID3FrameAttachedPicture(picture: art, type: .frontCover, format: .jpeg),
                .popularimeter : ID3FramePopularimeter(email: email, rating: PopularimeterRating(rating), counter: counter)
            ]
        )
        
        XCTAssertNoThrow(try id3TagEditor.write(
            tag: id3Tag,
            to: PathLoader().pathFor(name: "example-with-rating", fileType: "mp3"),
            andSaveTo: pathMp3Generated
            ))
        XCTAssertEqual(
            try! Data(contentsOf: URL(fileURLWithPath: pathMp3Generated)),
            try! Data(contentsOf: URL(fileURLWithPath: pathMp3ToCompare))
        )
        
        //Load the file generated file.
        id3Tag = try id3TagEditor.read(from: pathMp3Generated)!
        
        XCTAssertEqual((id3Tag.frames[.popularimeter] as? ID3FramePopularimeter)?.rating, PopularimeterRating(rating))
        XCTAssertEqual((id3Tag.frames[.popularimeter] as? ID3FramePopularimeter)?.email, email)
        XCTAssertEqual((id3Tag.frames[.popularimeter] as? ID3FramePopularimeter)?.counter, counter)
        
    }
}
