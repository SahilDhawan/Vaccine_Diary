# Vaccine Diary
A Vaccination Reminder App that showcases all the vaccines for an infant along with their due dates in a list as well as Calendar View.
Application also tracks the current location of the user and provides the nearby hospitals and nearby doctors.
Local Notifications are also set for the vaccinations to update the user.

### Tech Used
* Xcode
* iOS 10
* Swift 3

### Cocoapods Used
* Firebase/Atuh
* Firebase/Database
* FBSDKLoginKit
* FBSDKCoreKit
* GooglePlaces
* GooglePlacePicker
* GoogleMaps
* JTAppleCalendar

### View Controllers

#### Login and Sign Up
User can login and sign up in app using these View Controllers. Firebase is used for authentication of the user via custom email or through facebook.

#### Vaccination Schedule
Gives a list of all the vaccines for a new born baby . This immunisation Record is based on the information provided by Indian Academy of Pediatrics (IAP).
Vaccinations also contain an icon where green colored icon indicates completed vaccine while red icon indicates due vaccine.

#### VaccinationCalendar
Vaccination Calendar highlights the dates of due vaccinations for better user visibilty.

#### User Profile
User Profile showcases the User Name and Date of Birth(DOB) of infant which is stored in the realtime database of Firebase. It also shows the current location of the user.

#### Nearby Hospitals
Nearby Hospitals View Controller showcases the nearby hospitals in a map view and also in the form of list which is fetched from the google places API.

#### Nearby Doctors
Nearby Doctors View Controller showcases all the nearby doctors in the form of list which is fetched from the google places API.
