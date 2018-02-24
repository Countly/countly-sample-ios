## Countly sample test application

This repository includes sample iOS, iOS-Swift, watchOS, tvOS and macOS projects to demonstrate how to use Countly iOS SDK. It can be used to: 

* Send a sample push notification
* Generate events with values and segmentations with count, sum, duration
* Send a sample user profile
* Send a custom user property
* Send a view (automatic or manual)
* Generate a crash (e.g out of bounds, null pointer, kill, etc or a custom crash log)

![iOS-sample-app](https://count.ly/github/countly-ios-sample-app.png)

Countly iOS SDK is added as a git submodule. Hence, you should do:

<pre class="prettyprint">
	git submodule update --init
</pre>

after you cloned this repository to get the latest Countly iOS SDK.

## Steps to deploy and send a sample push notification

1. Download demo [here](https://github.com/Countly/countly-sample-ios).

- This repository includes samples for each platform. For iOS, use `ios`
- SDK is added to project as a `git submodule`. You just need to fetch it.

2. Change application configuration as follows: 

- Change Bundle ID CodeSigning configurations according to your developer account configurations.
- Change Countly server URL and AppID: `config.appKey = @"YOUR_APP_KEY"; config.host = @"https://YOUR_COUNTLY_SERVER";`
- Enable push notifications: `config.features = @[CLYPushNotifications];`

3. Create your push notification certificate and upload your Countly server.

4. Run your application. From the list on the screen, choose "Ask for Notification Permission", and confirm.

5. Push token will automatically be sent to Countly server. From this point forward, you will be able to send a push notification to that device. 

6. You can also send events, sample crashes, sample user profiles, and many more.
