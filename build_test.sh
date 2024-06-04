clear
echo "Cleaning Xcode derived data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*

echo "Building for iOS..."
OUTPUT=`xcodebuild -project ios/CountlyTestApp-iOS.xcodeproj/ -target "CountlyTestApp-iOS" -configuration Debug -sdk iphonesimulator build`
RESULT=`echo "$OUTPUT" | grep "BUILD SUC"`

if [ "$RESULT" != "** BUILD SUCCEEDED **" ]
then
	echo "${OUTPUT}"
else
	echo "${RESULT}"
fi

sudo rm -rf ios/build


echo "Building for iOS-Swift..."
OUTPUT=`xcodebuild -project ios-swift/CountlyTestApp-iOS-swift.xcodeproj/ -target "CountlyTestApp-iOS-swift" -configuration Debug -sdk iphonesimulator build`
RESULT=`echo "$OUTPUT" | grep "BUILD SUC"`

if [ "$RESULT" != "** BUILD SUCCEEDED **" ]
then
    echo "${OUTPUT}"
else
    echo "${RESULT}"
fi

sudo rm -rf ios-swift/build


echo "Building for tvOS..."
OUTPUT=`xcodebuild -project tvos/CountlyTestApp-tvOS.xcodeproj/ -target "CountlyTestApp-tvOS" -configuration Debug -sdk appletvsimulator build`
RESULT=`echo "$OUTPUT" | grep "BUILD SUC"`

if [ "$RESULT" != "** BUILD SUCCEEDED **" ]
then
	echo "${OUTPUT}"
else
	echo "${RESULT}"
fi

sudo rm -rf tvos/build


echo "Building for watchOS..."
OUTPUT=`xcodebuild -project watchos/CountlyTestApp-watchOS.xcodeproj/ -target "CountlyTestApp-watchOS WatchKit App" -configuration Debug -sdk watchsimulator build`
RESULT=`echo "$OUTPUT" | grep "BUILD SUC"`

if [ "$RESULT" != "** BUILD SUCCEEDED **" ]
then
	echo "${OUTPUT}"
else
	echo "${RESULT}"
fi

sudo rm -rf watchos/build


echo "Building for macOS..."
OUTPUT=`xcodebuild -project macos/CountlyTestApp-macOS.xcodeproj/ -target "CountlyTestApp-macOS" -configuration Debug build`
RESULT=`echo "$OUTPUT" | grep "BUILD SUC"`

if [ "$RESULT" != "** BUILD SUCCEEDED **" ]
then
	echo "${OUTPUT}"
else
	echo "${RESULT}"
fi

sudo rm -rf macos/build