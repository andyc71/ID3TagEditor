//
//  ID3RawFrameCreator.swift
//
//  Created by Andy Clynes on 23 Oct 2023.
//  Copyright © 2023 Andy Clynes. All rights reserved.

import Foundation

class ID3RawFrameCreator: ID3FrameCreator {

    init() {
    }
    
    func createFrames(id3Tag: ID3Tag) -> [UInt8] {
 
        var frameData = Data()
        for (_, frame) in id3Tag.frames {
            if let rawFrame = frame as? ID3FrameRaw {
                frameData.append(rawFrame.data)
            }
        }
                        
        return [UInt8](frameData)
        
    }
    
}
