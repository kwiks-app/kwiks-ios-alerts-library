# KwiksSystemsAlerts

[![CI Status](https://img.shields.io/travis/26388491/KwiksSystemsAlerts.svg?style=flat)](https://travis-ci.org/26388491/KwiksSystemsAlerts)
[![Version](https://img.shields.io/cocoapods/v/KwiksSystemsAlerts.svg?style=flat)](https://cocoapods.org/pods/KwiksSystemsAlerts)
[![License](https://img.shields.io/cocoapods/l/KwiksSystemsAlerts.svg?style=flat)](https://cocoapods.org/pods/KwiksSystemsAlerts)
[![Platform](https://img.shields.io/cocoapods/p/KwiksSystemsAlerts.svg?style=flat)](https://cocoapods.org/pods/KwiksSystemsAlerts)

## Usage
```
var alert = KwiksSystemAlerts()

self.alert = KwiksSystemAlerts(presentingViewController: self, popupType: .authenticationError)

self.alert.engagePopup()

        self.alert.callback = { (data) in
            
            switch self.alert.responseType {
                
            case .contactSupportEmail: print("contactSupportEmail")
            case .dismiss: print("dismiss")
            case .kwiksUnavailable: print("kwiksUnavailable")
            case .serverDown: print("serverDown")
                
            }
        }
```
## Popup Switch Model
```
public enum PopupType{
        case noInternetConnection
        case somethingWentWrong
        case suspended
        case tempLocked
        case kwiksUnavailable
        case waitingResponse
        case loginApproved
        case timeOut
        case networkConnectionTimeout
        case sessionExpired
        case accessDenied
        case serverError
        case authenticationError
        case authenticationDenied
        case updateKwiks
    }
```

## Response Model
```
 public enum ResponseType {
        case dismiss
        case serverDown
        case contactSupportEmail
        case kwiksUnavailable
    }
```
    
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

KwiksSystemsAlerts is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KwiksSystemsAlerts'
```

## Author

  KWIKS CTO, charlie@kwiks.com

## License

KwiksSystemsAlerts is available under the MIT license. See the LICENSE file for more info.
