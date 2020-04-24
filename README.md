# react-native-fitnesskit
`react-native-fitnesskit` is a fitness library that works on both `iOS` and `Android` with it you can interact with Apple Healthkit and Google Fit.
Currently the lib provides a set of [API](#API) that you can use to read steps count, distance count, HeartRate count, Energy count for a given period of time.
Note:
We're open to receive PRs that contains new features or improvements, so feel free to contribute to this repo.
## Getting started
`npm install @memorres/react-native-fitnesskit --save`
or
`yarn add @memorres/react-native-fitnesskit`
### Mostly automatic installation
`react-native link @memorres/react-native-fitnesskit`
### Manual installation
#### iOS
### Pods
1. Add the line below to your `Podfile`.
    ```pod
    pod 'react-native-fitnesskit', :path => '../node_modules/@memorres/react-native-fitnesskit'`
    ```
2. Run `pod install` in your iOS project directory.
3. In XCode, select your project, go to `Build Phases` ➜ `Link Binary With Libraries` and add `libreact-native-fitnesskits.a`.
4. Add following to your `Info.plist` in order to ask permissions.
    ```xml
    <key>NSHealthShareUsageDescription</key>
    <string>Read and understand health data.</string>
    <key>NSHealthUpdateUsageDescription</key>
    <string>Share workout data with other apps.</string>
    ```
### Manually
1. In XCode's project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `memorres`➜ `rereact-native-fitnesskit and select `RNFitnesskit.xcodeproj`
3. In XCode select your project, go to `Build Phases` ➜ `Link Binary With Libraries` and add `libRNFitnesskit.a`.
4. Run your project (`Cmd+R`)
In order to make it run, it is necessary to turn on `Health Kit` in the `Capabilities`.
#### Android
1. Use below link to enable google fit api on google console. https://console.developers.google.com/flows/enableapi?apiid=fitness
2. Open up `MainApplication.java`
    - Add `import com.memorres.fitnesskit.RNFitnesskitPackage;` to the imports at the top of the file
    - Add `new RNFitnesskitPackage()` to the list returned by the `getPackages()` method
3. Append the following lines to `android/settings.gradle`:
  	```java
  	include ':@memorres_react-native-fitnesskit'
  	project(':@memorres_react-native-fitnesskit').projectDir = new File(rootProject.projectDir, 	'../node_modules/@memorres/react-native-fitnesskit/android')
  	```
4. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```java
    compile project(':@memorres_react-native-fitnesskit')
  	```
## Get Started
1. Initialize Fitnesskit. This will show the Fitnesskit permissions prompt for any read permissions.Due to Apple's privacy model if an app user has previously denied a specific permission then they can not be prompted again for that same permission. The app user would have to go into the Apple Health app
2. If new read/write permissions are added to the options object then the app user will see the Healthkit permissions prompt with the new permissions to allow.
## Usage
```javascript
import Fitnesskit,{Permission} from 'react-native-fitnesskit';
let options = {
  permissions: {
      read: [Permission.StepCount,Permission.Distance],
      write:[Permission.StepCount,Permission.Distance]
  }
};
Fitness.isAuthorized(permissions)
  .then((authorized) => {
    // Do something
  })
  .catch((error) => {
    // Do something
  });
```
### API
- **Fitness.isAuthorized(permissions)**
 Check if  permissions are granted or not. It works on Android >= google play services 7.0 or higher and iOS >=12.0 ,while  it returns an error if condition not satisfied.
- **Fitness.requestPermissions(permissions)**
```javascript
Fitnesskit.requestPermissions(options)
           .then((success) => {
                     })
           .catch((err) => {
                     });
```
- **Fitness.getStepCount()**
Fetch steps on a given period of time. It requires an `Object` with `startDate` and `endDate` attributes as string. If `startDate` is not provided an error will be thrown.
```javascript
let optionsSteps = {
   startDate: "2020-4-17",
   endDate:   "2020-4-21",
   };
 Fitnesskit.getStepCount(optionsSteps).then(res => {
}).catch(err => {
  });
```
- **Fitness.getDistance()**
Fetch distance in meters on a given period of time. It requires an `Object` with `startDate` and `endDate` attributes as string. If `startDate` is not provided an error will be thrown.
```javascript
let options = {
  startDate: "2020-4-17",
  endDate:   "2020-4-21",
  type:     Permission.Distance,
};
```
Here type is only for ios becuase ios provide also distance for `DistanceSwimming` and `DistanceCycling` and default type parameter for ios is `DistanceWalkingRunning`
- **Fitness.getEnergy()**
Fetch calories burnt in kilocalories on a given period of time.. It requires an `Object` with `startDate` and `endDate` attributes as string. If `startDate` is not provided an error will be thrown.
```javascript
let options = {
  startDate: "2020-4-17",
  endDate:   "2020-4-21",
  type:     Permission.Energy,
};
```
Here type is only for ios becuase ios provide also energy for `BasalEnergyBurned` and `DietaryEnergy` and default and default type parameter for ios is `ActiveEnergyBurned`
- **Fitness.getHeartRate()**
Fetch heart rate bpm on a given period of time. It requires an `Object` with `startDate` and `endDate` attributes as string. If `startDate` is not provided an error will be thrown.
### Attributes
#### Platform
Return the used provider.
#### PermissionKind
Return the information of what kind of Permission can be asked.
At the moment the list of possible kinds is:
 - ***StepCount***: to required the access for `Step`
 - ***Distance***: to required the access for `DistanceWalkingRunning` for ios and `Distance` for android
 - ***DistanceSwimming***: to required the access for `DistanceSwimming` only for ios
 -  ***DistanceCycling***: to required the access for `DistanceCycling` only for ios
 - ***Energy***: to required the access for `Calorie` for android and `ActiveEnergyBurned` for ios
 -  ***BasalEnergyBurned***:  to required the access for `BasalEnergyBurned` only for ios
 -  ***DietaryEnergy***:  to required the access for `DietaryEnergy` only for ios
 - ***HeartRate***: to required the access for `Heart rate`
#### PermissionAccess
Return the information of what kind of Access can be asked.
The list of possible kinds is:
 - ***Read***: to required the access to `Read`
 - ***Write***: to required the access to `Write`
#### Error
Return the list of meaningful errors that can be possible thrown.
On Android below error occur.
 ***dateNotCorrect***: thrown if received date is not correct
Possible error for iOS only
 - ***hkNotAvailable***: thrown if HealthKit is not available
 - ***methodNotAvailable***: thrown if `isAuthorized` is called on iOS < 12.0
 -  ***dateNotCorrect***: thrown if received date is not correct
 - ***errorEmptyPermissions***: thrown if no read permissions are provided
 - ***errorNoEvents***: thrown if an error occurs while try to retrieve data
