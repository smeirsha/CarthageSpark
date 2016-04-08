Particle Cloud SDK and Device Setup Library basic iOS app example - using Carthage dependecies

To get this example app running, clone it, open the project in XCode and:

1. Flash the `firmware.c` firmware to a photon under your account, use [Build](build.particle.io) - you can setup a new one also from within the app (device setup library)
2. Set it's name to the constant `deviceName` in the  `testCloudSDK()` function
3. Set your username/password to the appropriate constants, same place
4. Go the project root folder in your shell, run the `setup` shell script (under the /bin folder) which will build the latest Particle SDK Carthage dependencies
5. Drag the 3 created `.framework` files under /Carthage/Build/iOS to your project
6. Go to XCode's target general settings and also add those frameworks to "embedded binaries"
7. Run and experiment! 

Good luck