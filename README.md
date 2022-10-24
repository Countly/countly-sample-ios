[![Codacy Badge](https://app.codacy.com/project/badge/Grade/07906a0d2547493daea6b869736d09ce)](https://www.codacy.com/gh/Countly/countly-sample-ios/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=Countly/countly-sample-ios&amp;utm_campaign=Badge_Grade)

## Countly iOS SDK test application

This repository includes sample iOS, iOS-Swift, watchOS, tvOS and macOS projects to demonstrate how to use [Countly iOS SDK](https://github.com/Countly/countly-sdk-ios).

## What is Countly?
[Countly](https://count.ly) is a product analytics solution and innovation enabler that helps teams track product performance and customer journey and behavior across [mobile](https://count.ly/mobile-analytics), [web](http://count.ly/web-analytics),
and [desktop](https://count.ly/desktop-analytics) applications. [Ensuring privacy by design](https://count.ly/privacy-by-design), Countly allows you to innovate and enhance your products to provide personalized and customized customer experiences, and meet key business and revenue goals.

Track, measure, and take action - all without leaving Countly.

* **Slack user?** [Join our Slack Community](https://slack.count.ly)
* **Questions or feature requests?** [Post in our Community Forum](https://support.count.ly/hc/en-us/community/topics)
* **Looking for the Countly Server?** [Countly Community Edition repository](https://github.com/Countly/countly-server)
* **Looking for other Countly SDKs?** [An overview of all Countly SDKs for mobile, web and desktop](https://support.count.ly/hc/en-us/articles/360037236571-Downloading-and-Installing-SDKs#officially-supported-sdks)

## Using the test application

These test applications can be used to: 

* Send a sample push notification
* Generate events with values and segmentations with count, sum, duration
* Send a sample user profile
* Send a custom user property
* Send a view (automatic or manual)
* Generate a crash (e.g out of bounds, null pointer, kill, etc or a custom crash log)

![iOS-sample-app](https://count.ly/github/countly-ios-sample-app.png)

Countly iOS SDK is added as a git submodule. Hence, you should do:

```shell
git submodule update --init
```

after you cloned this repository to get the latest Countly iOS SDK.

## Steps to deploy and send a sample push notification

1. Download demo [here](https://github.com/Countly/countly-sample-ios).

	* This repository includes samples for each platform. For iOS, use `ios`
	* SDK is added to project as a `git submodule`. You just need to fetch it.

2. Change application configuration as follows: 

	* Change Bundle ID CodeSigning configurations according to your developer account configurations.
	* Change Countly server URL and AppID: `config.appKey = @"YOUR_APP_KEY"; config.host = @"https://YOUR_COUNTLY_SERVER";`
	* Enable push notifications: `config.features = @[CLYPushNotifications];`

3. Create your push notification certificate and upload your Countly server.

4. Run your application. From the list on the screen, choose "Ask for Notification Permission", and confirm.

5. Push token will automatically be sent to Countly server. From this point forward, you will be able to send a push notification to that device. 

6. You can also send events, sample crashes, sample user profiles, and many more.

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
Glad you asked! We need ideas, feedback and constructive comments. All your suggestions will be taken care of with utmost importance. For feature requests and engaging with the community, join [our Slack Community](https://slack.count.ly) or [Community Forum](https://support.count.ly/hc/en-us/community/topics).

We are on [Twitter](http://twitter.com/gocountly), [Facebook](https://www.facebook.com/Countly) and [LinkedIn](https://www.linkedin.com/company/countly) if you would like to keep up with Countly related updates.
