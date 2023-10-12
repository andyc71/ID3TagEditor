//
//  ID3 PopularimeterFrameContentParsingOperation.swift
//  mplayer
//
//  Created by Alex on 11 Jul 19.
//  Copyright © 2019 Aleksey Lebedev. All rights reserved.
//

import Foundation

class ID3PopularimeterFrameContentParsingOperation: FrameContentParsingOperation {
    private let id3FrameConfiguration: ID3FrameConfiguration

    init(id3FrameConfiguration: ID3FrameConfiguration) {
        //private let stringContentParser: ID3FrameStringContentParser
        //self.stringContentParser = stringContentParser
        self.id3FrameConfiguration = id3FrameConfiguration
    }

    func parse(frame: Data, version: ID3Version, completed: (FrameName, ID3Frame) -> ()) {
        
        let headerSize = id3FrameConfiguration.headerSizeFor(version: version)
        let frameContentRangeStart = headerSize

        //Strip off the frame header.
        guard frameContentRangeStart < frame.count else { return}
        let frameContent = frame.subdata(in: frameContentRangeStart..<frame.count)
        
        //Extract the rating and counter from the end of the string.
        let ratingAndPositionLength = 5
        guard frame.count - ratingAndPositionLength > 5 else { return }
        
        let ratingPosition = frameContent.count - 5
        let counterPosition = frameContent.count - 4
        
        let nsDataFrame = frameContent as NSData
        var rating: UInt8 = 0
        nsDataFrame.getBytes(&rating, range: NSMakeRange(ratingPosition, 1))
        var counter: UInt32 = 0
        nsDataFrame.getBytes(&counter, range: NSMakeRange(counterPosition, 4))
        counter = counter.bigEndian

        //Parse the email.
        let emailLength = frame.count - ratingAndPositionLength
        guard emailLength > 0 else { return }
        let emailData = frameContent.subdata(in: 0..<ratingPosition)
        
        //Check that the last byte is the null terminator.
        guard emailData[emailData.count - 1] == 0x0 else { return }

        let email: String
        if emailData.count == 1 {
            //If we only have a single byte, it must be the terminator so
            //we have an empty string.
            email = ""
        } else {
            //Parse the string using the ISO88591 decoder. See comments in
            //ID3PopularimeterFramesCreator as to why we're always creating
            //strings in ISO88591 format.
            let emailStringEncoding = ID3StringEncodingConverter().convert(id3Encoding: .ISO88591, version: version)
            if let emailDecoded = String(data: emailData, encoding: emailStringEncoding) {
                let paddingRemover = PaddingRemoverUsingTrimming()
                email = paddingRemover.removeFrom(string: emailDecoded)
            }
            else {
                return
            }
        }
        
        completed(.popularimeter, ID3FramePopularimeter(email: email, rating: Int(rating), counter: Int(counter)))
    }
}
