# Mental-Health-TN-Gov

Open-Source App to take care of Mental Health: An initiative by IIT Madras and Tamil Nadu Government.

## About the Project

This project aims to provide a platform for students, teachers, psychiatrists, and health administrators to monitor, intervene, and improve the mental health of students. It includes functionalities like red flag identification, psychiatric consultation, referrals, and training modules for teachers and psychiatrists.

For an overview of the project, please go through the `Mental Health Application.IITM.pdf` file in the repository.

Figma file link for workflow: https://www.figma.com/design/7deDsVo0b5PB1o6NoQVY9u/TNMSS?node-id=64-441&t=qO40qrH0Plsawo9x-1

## Technologies Used

- **Frontend**: Flutter
- **Backend**: Node.js, Express, JWT Authentication
- **Database**: MongoDB

## Features
- Student mental health monitoring and intervention.
- Psychiatrist consultation management.
- Referrals to district hospitals and other health institutions.
- Training programs for teachers and mental health professionals.

## Hacktoberfest Contributions

We are participating in Hacktoberfest and welcome contributions to make this project even more impactful! To contribute:

1. **Find an Issue**: Look for issues labeled as `hacktoberfest`, `good first issue`, or `help wanted` to get started.
2. **Contribute Code**: We welcome contributions in Flutter for the mobile frontend, Node.js/Express for the backend, or database optimizations in MongoDB.
3. **Write Documentation**: Improving documentation or adding user guides is always helpful.

For more details, check out our [CONTRIBUTING.md](CONTRIBUTING.md).

## Getting Started

To get started with the project:

1. Fork the repository.
2. Clone your fork to your local machine:

   ```sh
   git clone https://github.com/Aadharcode/Mental-Health-TN-Gov.git
   ```

3. Set up your environment using the instructions below.

## Setting Up the Project

### Backend Setup

1. Navigate to the backend folder:

   ```sh
   cd backend
   ```

2. Install the necessary dependencies:

   ```sh
   npm install
   ```
3. Create a folder named "config" in the home directory and put your .env file containing various sensitive data into it

4. Start the backend server:

   ```sh
   npm start
   ```

### Frontend Setup

If you have cloned a Flutter project from GitHub, there are a few important steps you need to take to install the project's dependencies and prepare it to run. Here are the steps you should follow:

#### Step 1: Navigate to the Project Directory
After cloning the project, use the terminal to navigate to the frontend directory:

```sh
cd frontend
```

#### Step 2: Install Dependencies
Run the following command to install all dependencies listed in `pubspec.yaml`:

```sh
flutter pub get
```

This will download and install all the required packages that the project depends on.

#### Step 3: Check for Any Missing Platform-Specific Dependencies
If the project involves platform-specific plugins, such as Android or iOS dependencies, you should run the following commands to ensure everything is set up:

- **For iOS**:
  If the project has iOS components, navigate to the `ios` folder and run `pod install`:

  ```sh
  cd ios
  pod install
  cd ..
  ```

- **For Android**:
  Generally, running `flutter pub get` is enough. However, make sure that your Android Studio is set up with the necessary SDK versions.

#### Step 4: (Optional) Update Dependencies
If you want to update all dependencies to their latest versions, you can use:

```sh
flutter pub upgrade
```

This will attempt to get the latest compatible versions of each package.

#### Step 5: Run Flutter Doctor
This will help ensure your environment is properly set up to run Flutter projects:

```sh
flutter doctor
```

Fix any issues that are mentioned. This step ensures your environment is configured with all necessary tools and settings.

#### Step 6: Run the Project
Finally, to run the project, use:

```sh
flutter run
```

If you have multiple devices/emulators connected, Flutter will ask which one to use. You can also specify the target device:

```sh
flutter run -d chrome  # For web
flutter run -d macos   # For macOS
flutter run -d <device_id>  # For an Android or iOS device/emulator
```

### Summary of Commands
1. Navigate to the frontend directory:

   ```sh
   cd frontend
   ```

2. Install the dependencies:

   ```sh
   flutter pub get
   ```

3. For iOS dependencies (if applicable):

   ```sh
   cd ios
   pod install
   cd ..
   ```

4. Verify setup:

   ```sh
   flutter doctor
   ```

5. Run the project:

   ```sh
   flutter run
   ```

After following these steps, your project should be ready to run and test on the appropriate devices.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

If you have any questions or need more information, feel free to open an issue or reach out to the maintainers.
```
