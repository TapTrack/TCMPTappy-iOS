# TapTrack iOS SDK for TappyBLE NFC readers

## Cocoapod dependency:

 `pod 'TCMPTappy'`

## Supported:

* All framing and de-framing for data sent to and received from the Tappy reader
* TappyBLE support with Core Bluetooth (deployment target set to iOS v 8.0)
  * Scanning for TappyBLE readers
  * Connecting to TappyBLE readers
  * Sending commands and receiving responses in [TCMP format](https://docs.google.com/document/d/1MjHizibAd6Z1PGZAWnbStXnCBVggptx3TIh2HRqEluk/edit?usp=sharing)
* Commands supported currently
  * Reading NDEF formatted tags
  * Writing NDEF text records
  * Stop command	
