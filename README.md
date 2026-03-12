[![Codacy Badge](https://app.codacy.com/project/badge/Grade/07906a0d2547493daea6b869736d09ce)](https://app.codacy.com/gh/Countly/countly-sample-ios/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

## Countly iOS SDK Sample Application

Sample iOS, iOS-Swift, watchOS, tvOS, and macOS projects demonstrating how to use the [Countly iOS SDK](https://github.com/Countly/countly-sdk-ios).

## What is Countly?

[Countly](https://count.ly) is a product analytics solution and innovation enabler that helps teams track product performance and customer journey and behavior across [mobile](https://count.ly/mobile-analytics), [web](https://count.ly/web-analytics),
and [desktop](https://count.ly/desktop-analytics) applications. [Ensuring privacy by design](https://count.ly/privacy-by-design), Countly allows you to innovate and enhance your products to provide personalized and customized customer experiences, and meet key business and revenue goals.

Track, measure, and take action - all without leaving Countly.

* **Questions or feature requests?** [Join the Countly Community on Discord](https://discord.gg/countly)
* **Looking for the Countly Server?** [Countly Community Edition repository](https://github.com/Countly/countly-server)
* **Looking for other Countly SDKs?** [An overview of all Countly SDKs for mobile, web and desktop](https://support.count.ly/hc/en-us/articles/360037236571-Downloading-and-Installing-SDKs#officially-supported-sdks)

## Requirements

* iOS 15.0+
* Xcode 15+

## Getting Started

The Countly iOS SDK is included as a git submodule. After cloning this repository, run:

```shell
git submodule update --init
```

### Running the iOS Sample App

1. Open `ios/CountlyTestApp-iOS.xcodeproj` in Xcode.
2. Update your Countly server URL and app key in `AppDelegate.m`:

   ```objc
   config.appKey = @"YOUR_APP_KEY";
   config.host = @"https://YOUR_COUNTLY_SERVER";
   ```

3. Update the Bundle ID and code signing to match your developer account.
4. Build and run on a simulator or device.

## iOS App Structure

The iOS sample app is organized into grouped sections, each covering a specific area of the SDK:

### Data & Events

| Section            | Description                                                      |
| ------------------ | ---------------------------------------------------------------- |
| **Custom Events**  | Record events with keys, segmentation, count, sum, and duration  |
| **Remote Config**  | Fetch, list, and manage remote config values and A/B experiments |
| **Content Builder** | Enter/exit/refresh content zones, change device ID              |

### User & Analytics

| Section            | Description                                              |
| ------------------ | -------------------------------------------------------- |
| **User Details**   | Set standard and custom user properties                  |
| **View Tracking**  | Start/stop views, automatic view tracking, view actions  |
| **Attribution**    | Record direct and indirect attribution                   |

### Stability & Performance

| Section              | Description                                                          |
| -------------------- | -------------------------------------------------------------------- |
| **Crash Reporting**  | Generate test crashes, record handled exceptions, crash breadcrumbs  |
| **APM**              | Custom network traces, app performance monitoring                    |

### Engagement

| Section                | Description                                        |
| ---------------------- | -------------------------------------------------- |
| **Push Notifications** | Request permission, send test push tokens          |
| **Feedback**           | NPS, surveys, star ratings, feedback widgets       |
| **Location**           | Set GPS coordinates and IP-based location          |

### SDK Management

| Section              | Description                                                       |
| -------------------- | ----------------------------------------------------------------- |
| **Consents**         | Grant/revoke individual or all feature consents                   |
| **Queue Operations** | Flush queues, manage app keys, direct requests                    |
| **SDK Lifecycle**    | Change device ID, host, app key; halt SDK; session management     |
| **Multithreading**   | Stress-test SDK thread safety                                     |

## Other Platforms

| Platform    | Project Path |
| ----------- | ------------ |
| iOS (Swift) | `ios-swift/` |
| macOS       | `macos/`     |
| tvOS        | `tvos/`      |
| watchOS     | `watchos/`   |

## Push Notification Setup

1. Create your push notification certificate and upload it to your Countly server.
2. Enable push notifications in your config:
   * **Objective-C**: `config.features = @[CLYPushNotifications];`
   * **Swift**: `config.features = @[CLYFeature.pushNotifications];`
3. Run the app, choose "Ask for Notification Permission", and confirm.
4. The push token is automatically sent to the Countly server.

## Security

Security is very important to us. If you discover any issue regarding security, please disclose the information responsibly by sending an email to security@count.ly and **not by creating a GitHub issue**.

## Badges

If you like Countly, [why not use one of our badges](https://count.ly/brand-assets) and give a link back to us so others know about this wonderful platform?

<a href="https://count.ly/f/badge" rel="nofollow"><img style="width:145px;height:60px" src="https://count.ly/badges/dark.svg?v2" alt="Countly - Product Analytics" /></a>

```JS
<a href="https://count.ly/f/badge" rel="nofollow"><img style="width:145px;height:60px" src="https://count.ly/badges/dark.svg" alt="Countly - Product Analytics" /></a>
```

<a href="https://count.ly/f/badge" rel="nofollow"><img style="width:145px;height:60px" src="https://count.ly/badges/light.svg?v2" alt="Countly - Product Analytics" /></a>

```JS
<a href="https://count.ly/f/badge" rel="nofollow"><img style="width:145px;height:60px" src="https://count.ly/badges/light.svg" alt="Countly - Product Analytics" /></a>
```

## How can I help you with your efforts?

Glad you asked! For community support, feature requests, and engaging with the Countly Community, please join us at [our Discord Server](https://discord.gg/countly). We're excited to have you there!

Also, we are on [Twitter](https://twitter.com/gocountly) and [LinkedIn](https://www.linkedin.com/company/countly) if you would like to keep up with Countly related updates.
