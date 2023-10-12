//
//  ID3PopularimeterFramesCreator.swift
//  mplayer
//
//  Created by Alex on 11 Jul 19.
//  Copyright © 2019 Aleksey Lebedev. All rights reserved.
//

import Foundation

class ID3PopularimeterFramesCreator: ID3FrameCreator {
//    private var id3FrameConfiguration: ID3FrameConfiguration
//    private let frameContentSizeCalculator: FrameContentSizeCalculator
//    private let frameFlagsCreator: FrameFlagsCreator
    
    //private let timestampCreator: TimestampCreator
    //private let frameCreator: FrameFromStringContentCreator
    private let frameHeaderCreator: FrameHeaderCreator
    //private let stringToBytesAdapter: StringToBytesAdapter
    private let stringToBytesAdapter: ID3ISO88591StringToByteAdapter


    /*
    init(stringToBytesAdapter: StringToBytesAdapter,
         id3FrameConfiguration: ID3FrameConfiguration,
         frameContentSizeCalculator: FrameContentSizeCalculator,
         frameFlagsCreator: FrameFlagsCreator) {
        self.stringToBytesAdapter = stringToBytesAdapter
        self.id3FrameConfiguration = id3FrameConfiguration
        self.frameContentSizeCalculator = frameContentSizeCalculator
        self.frameFlagsCreator = frameFlagsCreator
    }*/
    
    init(frameConfiguration: ID3FrameConfiguration) {
        self.frameHeaderCreator = ID3FrameHeaderCreatorFactory.make()
        let paddingAdder = PaddingAdderToEndOfContentUsingNullChar()
        self.stringToBytesAdapter = ID3ISO88591StringToByteAdapter(paddingAdder: paddingAdder,
                        frameConfiguration: frameConfiguration)
    }

    func createFrames(id3Tag: ID3Tag) -> [UInt8] {

        if let popularimeter = id3Tag.frames[.popularimeter] as? ID3FramePopularimeter {

            var content: [UInt8] = []
            let emailData = stringToBytesAdapter.adaptWithoutEncodingByte(string: popularimeter.email, for: id3Tag.properties.version)
            content.append(contentsOf: emailData)

            content.append(UInt8(popularimeter.rating))

            //let counterDataCount = MemoryLayout<UInt32>.size
            let counterData = UInt32ToByteArrayAdapterUsingUnsafePointer().adapt(uInt32: UInt32(popularimeter.counter))
//            let counterData = withUnsafePointer(to: popularimeter.counter.bigEndian) {
//                $0.withMemoryRebound(to: UInt8.self, capacity: counterDataCount) {
//                    UnsafeBufferPointer(start: $0, count: counterDataCount)
//                }
//            }
            content.append(contentsOf: counterData)
            

            /*
            tag.append(contentsOf: id3FrameConfiguration.identifierFor(
                frameType: .popularimeter,
                version: id3Tag.properties.version
            ))
            tag.append(contentsOf: frameContentSizeCalculator.calculateSizeOf(
                content: content,
                version: id3Tag.properties.version
            ))
            tag.append(contentsOf: frameFlagsCreator.createFor(version: id3Tag.properties.version))
            tag.append(contentsOf: content)
             */
            
            let frameHeader = frameHeaderCreator.createUsing(version: id3Tag.properties.version, frameType: .popularimeter, frameBody: content)
            let frame = frameHeader + content
            
            return frame
        
        }
        
        return []

    }
}
