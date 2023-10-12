//
//  ID3PopularimeterFramesCreator.swift
//  mplayer
//
//  Created by Alex on 11 Jul 19.
//  Copyright © 2019 Aleksey Lebedev. All rights reserved.
//  Updated and integrated by Andy Clynes in 2023.

import Foundation

class ID3PopularimeterFramesCreator: ID3FrameCreator {
    
    private let frameHeaderCreator: FrameHeaderCreator
    private let stringToBytesAdapter: ID3ISO88591StringToByteAdapter
    
    init(frameConfiguration: ID3FrameConfiguration) {
        self.frameHeaderCreator = ID3FrameHeaderCreatorFactory.make()
        let paddingAdder = PaddingAdderToEndOfContentUsingNullChar()
        //We are forcing the encoding to ID3ISO88591StringToByteAdapter as the ID3
        //specification does not specify a format, and empirical testing suggests
        //that Unicode and/or a leading byte format identifier will cause other apps
        //to fail when parsing our frame.
        self.stringToBytesAdapter = ID3ISO88591StringToByteAdapter(paddingAdder: paddingAdder,
                                                                   frameConfiguration: frameConfiguration)
    }
    
    func createFrames(id3Tag: ID3Tag) -> [UInt8] {
        
        guard let popularimeter = id3Tag.frames[.popularimeter] as? ID3FramePopularimeter else {
            return []
        }
        
        var content: [UInt8] = []
        
        //Encode the email address, but don't put an ecoding byte at the start
        //because other parsers will fail to read the frame. Tested with Foobar2000,
        //EverTag and MP3Tag, all of which will see the leading byte as a separator
        //marking the end of an empty email address and then start trying to parse
        //the rating from the actual email address bytes.
        let emailData = stringToBytesAdapter.adaptWithoutEncodingByte(string: popularimeter.email, for: id3Tag.properties.version)
        content.append(contentsOf: emailData)
        
        //Append the rating.
        content.append(UInt8(popularimeter.rating))
        
        //Append the play counter.
        let counterData = UInt32ToByteArrayAdapterUsingUnsafePointer().adapt(uInt32: UInt32(popularimeter.counter))
        content.append(contentsOf: counterData)
        
        //Create the frame header
        let frameHeader = frameHeaderCreator.createUsing(version: id3Tag.properties.version, frameType: .popularimeter, frameBody: content)
        
        //Return the new frame as header plus content bytes.
        let frame = frameHeader + content
        
        return frame
        
    }
    
}
