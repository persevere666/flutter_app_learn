# flutter_app_learn

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# GetFlutter is now GetWidget

# image_picker插件 版本 0.8.7
 IOS端
    Add the following keys to your Info.plist file, located in <project root>/ios/Runner/Info.plist:
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Used to demonstrate image picker plugin</string>
    <key>NSCameraUsageDescription</key>
    <string>Used to demonstrate image picker plugin</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>Used to capture audio for image picker plugin</string>

 Andoid端


# geolocator插件
    安卓
    来源：https://pub.flutter-io.cn/packages/geolocator
    一
    1 Add the following to your "gradle.properties" file:
        android.useAndroidX=true
        android.enableJetifier=true
    2 Make sure you set the compileSdkVersion in your "android/app/build.gradle" file to 33:
        android {
            compileSdkVersion 33
            ...
        }
    二  open the AndroidManifest.xml file, add Permissions
        <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
        <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
        <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
    IOS
    On iOS you'll need to add the following entries to your Info.plist file
        <key>NSLocationWhenInUseUsageDescription</key>
        <string>This app needs access to location when open.</string>
        <key>NSLocationAlwaysUsageDescription</key>
        <string>This app needs access to location when in the background.</string>

## App requires Multidex support
    Enable multidex.
    Open [project_folder]/app/build.gradle and add following lines.
        defaultConfig {
            ...
    
            multiDexEnabled true
        }
    //

## User denied permissions to access the device's location.

## geolocator 9.0.2
    
# 往虚拟机添加图片