<p align="center" >
<img src="http://oi60.tinypic.com/116jd51.jpg" alt="Particle" title="Particle">
</p>

## Particle Cloud SDK and Device Setup Library basic iOS app example - using Carthage dependecies

[![Platform](https://img.shields.io/badge/platform-iOS-10a4fa.svg)]() [![license](https://img.shields.io/hexpm/l/plug.svg)]() [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

This app is meant to serve as basic example for using the Particle Cloud SDK and Device Setup Library in the [Carthage](https://www.github.com/carthage/carthage) dependecies form. This takes a different approach than using Cocoapods and is now the recommended way to use Particle SDKs as it will ease complex/swift-containing builds.

To get this example app running, clone it, open the project in XCode and:

1. Flash the `firmware.c` firmware to a photon under your account, use [Build](https://build.particle.io) - you can setup a new one also from within the app (device setup library)
2. Set it's name to the constant `deviceName` in the  `testCloudSDK()` function
3. Set your username/password to the appropriate constants, same place
4. Go the project root folder in your shell, run the `setup` shell script (under the /bin folder) which will build the latest Particle SDK Carthage dependencies
5. Drag the 3 created `.framework` files under /Carthage/Build/iOS to your project
6. Go to XCode's target general settings and also add those frameworks to "embedded binaries"
7. Run and experiment! 

