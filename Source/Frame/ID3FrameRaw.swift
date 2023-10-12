//
//  ID3FrameRaw.swift
//
//  Created by Andy Clynes on 12 Oct 23.
//  Copyright © 2023 Andy Clynes. All rights reserved.
//

import Foundation

///Wraps the raw data of a ID3 frame that is currently unsupported by the Framework.
///There are two uses cases:
///1. We can load the frame, keep a copy, and then when we re-save the MP3
///  we can save this frame "as is", meaining that nothing is lost.
///2. We can provide a copy to a consumer of the framework and let them parse it.
public class ID3FrameRaw: ID3Frame, CustomDebugStringConvertible {

    public let data: Data

    public var debugDescription: String {
        return data.map { String(format: "%02x", $0) }.joined()
    }

    public init(data: Data) {
        self.data = data
    }
}
