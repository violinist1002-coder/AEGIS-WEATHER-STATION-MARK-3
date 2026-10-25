# 🛡️ AEGIS — Environmental Monitoring & Early Warning

![AEGIS sun and cloud icon](assets/aegis_icon.png)

**AEGIS** is a prototype environmental monitoring system that combines real-time measurements from an Arduino sensor station with regional weather forecasts. It provides a local web dashboard and an Android app with charts, clear environmental summaries, and accessibility options.

> **Project status:** Hackathon prototype; Android V0.4 development line. The interpretation logic is currently **rule-based**, not a trained machine-learning model. The rain plate senses moisture, not rainfall quantity. This is not a certified safety or disaster-warning device.

## Features

- **Physical sensors:** Arduino Uno R3 with DHT11 for air temperature/humidity and an analog rain/moisture plate; OLED display and DS18B20 sensor in the Arduino hardware setup.
- **Local dashboard:** Streamlit + Plotly live charts, wet/dry alerts and sensor readings.
- **Regional forecast:** Open-Meteo current observations/forecasts and hourly outlooks.
- **Android app:** Native Kotlin/Jetpack Compose UI, charts, temperature unit selection (°C/°F), theme customization, spoken summaries, and a configurable local sensor-server connection.
- **Explainable summaries:** Compares local moisture readings against regional rain probability and flags disagreement.
- **Expandable concept:** Additional environmental hardware modules are planned, not active.

## Repository structure

```text
AEGIS/
├── android/             # Full Android Studio / Gradle project (V0.4)
├── dashboard/           # Streamlit web dashboard + Flask sensor API
│   ├── app.py
│   └── requirements.txt
├── firmware/            # Arduino sketch upload location + CSV protocol notes
├── assets/              # Branding icon
├── docs/                # Architecture and demo/setup documentation
├── Start_AEGIS_Dashboard.bat
├── .gitignore
└── README.md
```

## Quick start: dashboard (Windows)

1. Install Python 3 and connect the Arduino by USB. Upload the appropriate sensor sketch if it is not already installed.
2. Close Arduino IDE's Serial Monitor/Plotter so Python can open the COM port.
3. In a terminal at this repository's root:

   ```powershell
   py -m pip install -r dashboard/requirements.txt
   py -m streamlit run dashboard/app.py --server.address 0.0.0.0 --server.port 8501
   ```

   Or double-click `Start_AEGIS_Dashboard.bat` after installing dependencies.
4. Open `http://localhost:8501`. Pick the Arduino COM port in the sidebar (it may not be `COM9`).
5. Check the API on the laptop: `http://127.0.0.1:5000/api/readings`.

The Flask API starts inside `app.py` and exposes `/api/readings` on port 5000. The app reads the Arduino's 4-column CSV over serial at 115200 baud.

## Android build

1. Open the `android/` folder itself in Android Studio (the one with `settings.gradle.kts`).
2. Let Gradle sync, then select a device.
3. Use **Build → Generate App Bundles or APKs → Generate APKs** (or the equivalent Build APK action).
4. Debug APK: `android/app/build/outputs/apk/debug/app-debug.apk` after a successful build.

The application can retrieve regional forecast data on its own over an internet connection. Live Arduino data still requires network access to the laptop running AEGIS.

### Real-phone connection on a private Wi-Fi network

1. Start the dashboard and confirm `http://127.0.0.1:5000/api/readings` works on your laptop.
2. Connect your phone and laptop to a **trusted private network**, e.g. a Windows Mobile Hotspot. Do not expose the unauthenticated API to a public or campus network.
3. Find your computer's IP address on that private network (Windows hotspot often uses `192.168.137.1`, but **verify**).
4. In the phone browser, test `http://<computer-ip>:5000/api/readings`.
5. In the Android app: **Settings → Live Sensor Connection**; enter `http://<computer-ip>:5000` and choose **Connect & Save**. Grant local-network permission if Android asks.

Android emulator users can forward with `adb -s <emulator-id> reverse tcp:5000 tcp:5000` and use the default loopback API address.

## Data flow

```text
Arduino sensors → USB serial (CSV) → Python serial reader
                                         ├── Streamlit dashboard / charts
                                         └── Flask :5000 /api/readings → Android app
Open-Meteo forecast API ────────────────────────────────────→ dashboard and Android
```

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for details and [docs/DEMO_CHECKLIST.md](docs/DEMO_CHECKLIST.md) for demonstration steps.

## Hardware firmware

The exact Arduino `.ino` file wasn't included in this packaged source snapshot. **Add your tested sketch** to `firmware/` before publishing if you want others to reproduce the hardware station. Details of the required serial format are in [firmware/README.md](firmware/README.md).

## Security and limitations

- The Flask development server uses **unencrypted HTTP** and currently has **no authentication**. Only run it on a trusted, isolated network. **Do not port-forward TCP/5000 to the public internet.**
- This repo intentionally excludes generated APKs, local SDK paths, secrets, credentials, and machine-specific build artifacts.
- Temperature and humidity data from a DHT11 can be coarse; a wet rain plate means moisture was detected, not confirmed precipitation.
- On-device environmental explanation is rule-based. New modules should only display readings once physical sensors and their data paths are actually implemented.

## Future work

- Persist sensor history across app restarts.
- Integrate additional hardware (air quality, soil moisture, light/UV, water level).
- Improve remote connectivity and access controls before any broader deployment.
- Evaluate more advanced analysis with honest confidence and uncertainty reporting.

## License

**Not specified.** Choose and add a license before you want others to reuse the code under explicit terms. Public GitHub visibility alone doesn't automatically grant permission to reuse your code.

## Weather attribution

Regional weather forecast data: [Open-Meteo](https://open-meteo.com/).
