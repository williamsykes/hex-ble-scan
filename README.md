# 🔍 BLE Scanner Flutter App

A modern, robust BLE Scanner app built with Flutter and [`flutter_reactive_ble`](https://pub.dev/packages/flutter_reactive_ble). It features:

- Real-time RSSI graphing using [`syncfusion_flutter_charts`](https://pub.dev/packages/syncfusion_flutter_charts) with a 10-second sliding window.
- Automatic scan stop after a timeout.
- Custom signal strength bars with color-coded RSSI indicators (green/orange/red).
- Parsing and displaying manufacturer data using a JSON file derived from the official Bluetooth SIG YAML file ([source here](https://bitbucket.org/bluetooth-SIG/public/src/main/assigned_numbers/company_identifiers/company_identifiers.yaml)) for accurate company name mapping.
- Polished dark-themed UI with pull-to-refresh on the device list and smooth chart animations.
- An About page containing my CV, contact information, and a button to download my resume PDF.
- A **custom app icon** created using an AI icon generator, designed to complement the app’s dark theme.

---

## 📦 Features

- **BLE Scanning & Auto Stop**
  Requests Bluetooth and Location permissions at runtime, scans for nearby BLE devices, and automatically stops scanning after a preset timeout.

- **Custom RSSI Signal Bars**
  Each device in the list shows a custom-built signal strength icon composed of 4 bars, color-coded based on normalized RSSI values:
  - Green for strong signals
  - Orange for medium
  - Red for weak signals

- **Manufacturer Data Parsing**
  Advertising packets are parsed to extract the Bluetooth Company Identifier (CID). This CID is mapped to a company name using a JSON file derived from the official Bluetooth SIG YAML file ([Bluetooth SIG Assigned Numbers](https://bitbucket.org/bluetooth-SIG/public/src/main/assigned_numbers/company_identifiers/company_identifiers.yaml)), allowing the app to display meaningful manufacturer information alongside raw payload data.

- **Live RSSI Graph**
  The `DeviceDetailScreen` continuously plots the RSSI values of the selected device on a smooth spline area chart that scrolls over a 10-second window, providing real-time visual feedback of signal strength.

- **UI/UX Enhancements**
  - Dark theme for readability and style.
  - Pull-to-refresh gesture on the device list.
  - Loading indicators and graceful error handling during scans.
  - Expansion tiles for detailed device info in a clean layout.

- **About Page**
  Contains my CV and contact details with a button to download my resume PDF or open a hosted version.

- **Custom App Icon**
  Created using an AI icon generator to perfectly fit the app’s dark theme and modern look.

---

## 📚 Project Structure
lib/
├── screens/
│   ├── home_screen.dart           # Main BLE scanning and device list
│   ├── device_detail_screen.dart  # Device services and RSSI graph
│   └── about_screen.dart          # Developer info, CV, contact
├── custom/
│   ├── device_tile.dart           # Custom widget showing device info & RSSI bars
│   └── rssi_chart.dart            # RSSI spline area chart widget
├── services/
│   └── company_ids.dart           # Loads and provides company ID → name mapping
├── constants/
│   └── app_constants.dart         # App-wide constants like scan timeout, chart interval
├── model/
│   └── rssi_data_point.dart       # Data model for RSSI time series
└── theme/
    └── text_styles.dart           # Centralized text styling

---

## 🚀 Running the App

1. Ensure Flutter is installed on your machine: [Flutter Install Guide](https://docs.flutter.dev/get-started/install)
2. Clone the repository and navigate to the project folder
3. Run `flutter pub get` to fetch dependencies
4. Connect a physical device or emulator with Bluetooth enabled
5. Run the app with `flutter run`

---

## 👤 Developer

For full CV and contact details, check the About page inside the app.