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
    
    ///Test that we can load frames that aren't handled by our parser and can be stored as
    ///ID3FrameRaw for later use when saving the file or so that the caller can parse them.
    ///Note that we can have multiple files with the same framename (e.g. TXXX).
    func testReadUnknownFrames() throws {
        
        let id3Tag = try id3TagEditor.read(from: PathLoader().pathFor(name: "example-with-unknown-frames", fileType: "mp3"))
        
        //The file example-with-unknown-frames.mp3 has two TXXX frames which are not
        //currently handled by the ID3TagEditor framework. Loop through all frames and
        //make sure we can find the two frames have been loaded as ID3FrameRaw type.
        var tx00FrameCount = 0
        for (frameName, frame) in id3Tag!.frames {
            if case let FrameName.raw(frameName, _) = frameName {
                XCTAssertEqual(frameName, "TXXX")
                XCTAssertTrue(frame is ID3FrameRaw)
                tx00FrameCount += 1
            }
        }
        XCTAssertEqual(2, tx00FrameCount)

    }
    
    ///Load a file containing frames that we don't recognize, and then re-save the file and
    ///preserve these tags in their original format.
    func testWriteUnknownFrames() throws {
        
        let pathMp3ToOriginal = PathLoader().pathFor(name: "example-with-unknown-frames", fileType: "mp3")
        let pathMp3Generated = NSHomeDirectory() + "/example-with-unknown-frames.mp3"
        
        var id3Tag = try id3TagEditor.read(from: PathLoader().pathFor(name: "example-with-unknown-frames", fileType: "mp3"))!

        XCTAssertNoThrow(try id3TagEditor.write(
            tag: id3Tag,
            to: pathMp3ToOriginal,
            andSaveTo: pathMp3Generated
            ))
        
        //Load the file generated file.
        id3Tag = try id3TagEditor.read(from: pathMp3Generated)!
        
        //The file example-with-unknown-frames.mp3 has two TXXX frames which are not
        //currently handled by the ID3TagEditor framework. Loop through all frames and
        //make sure we can find the two frames have been loaded as ID3FrameRaw type.
        var tx00FrameCount = 0
        for (frameName, frame) in id3Tag.frames {
            if case let FrameName.raw(frameName, _) = frameName {
                XCTAssertEqual(frameName, "TXXX")
                XCTAssertTrue(frame is ID3FrameRaw)
                tx00FrameCount += 1
            }
        }
        XCTAssertEqual(2, tx00FrameCount)

        
        
    }
}
