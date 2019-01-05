//
//  ID3RecordingDayMonthFrameContentParsingOperationFactory.swift
//
//  Created by Fabrizio Duroni on 05/08/2018.
//  2018 Fabrizio Duroni.
//

import Foundation

class ID3RecordingDayMonthFrameContentParsingOperationFactory {
    static func make() -> ID3FrameStringContentParsingOperation {
        return ID3FrameStringContentParsingOperationFactory.make() { (id3Tag: ID3Tag, content: String) in
            let dayMonth = ID3CoupleOfNumbersAdapter().adapt(coupleOfNumbers: content)
            id3Tag.frames[.RecordingDayMonth] = ID3FrameRecordingDayMonth(day: dayMonth.0, month: dayMonth.1)
        }
    }
}
