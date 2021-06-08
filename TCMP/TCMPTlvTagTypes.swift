//
//  TCMPTlvTypes.swift
//  TapTrackReader
//
//  Created by David Shalaby on 2021-06-06.
//  Copyright © 2021 David Shalaby. All rights reserved.
//
/*
 * Copyright (c) 2021. Papyrus Electronics, Inc d/b/a TapTrack.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * you may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

public enum TCMPTlvTag : UInt32 {
    case nulltlv = 0
    case pollingTimeout = 1
    case tappyTagCustomAid = 2
    case tappyTagShouldSwitchToKeyboardMode = 3
    case tappyTagResponseData = 4
    case tappyTagResponseDataAckOffset = 5
    case tappyTagResponseDataAckLength = 6
    case tappyTagInitialHandshakeData = 7
    
}
