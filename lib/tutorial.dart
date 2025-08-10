import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

class DeviceConnectionTutorial extends StatelessWidget {
  const DeviceConnectionTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Arduino Setup Guide',
          style: GoogleFonts.poppins(
            color: const Color(0xFFE75480),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFE75480)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Complete Arduino Code'),
            const SizedBox(height: 16),
            _buildCodeBlock('''
#include "DHT.h"
#define DHT11PIN 15
DHT dht(DHT11PIN, DHT11);
#include <Wire.h>
#define ADXL345 0x53
#include <HX711.h>
#include <PulseSensorPlayground.h>
#include <WiFi.h>
#include <FirebaseESP32.h>


#define WIFI_SSID "WIFISSID"
#define WIFI_PASSWORD "password"
#define FIREBASE_HOST "allobaby-a14cd-default-rtdb.firebaseio.com"  // Example: "your-project-id.firebaseio.com"
#define FIREBASE_AUTH "8NbU9GOqnUYTGqBSF3CK4UbvXIBpjwWNRy0SEERb"         // Get from Firebase Project Settings

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// Pin definitions
#define DT 4   // HX711 DOUT
#define SCK 2  // HX711 SCK
#define BUTTON_PIN 25
#define IN1 12
#define IN2 14
#define IN3 27
#define IN4 26

const int PULSE_INPUT_1 = 36;  // First Pulse Sensor
const int PULSE_INPUT_2 = 35;  // Second Pulse Sensor

// HX711 and Pulse Sensors
HX711 scale;
PulseSensorPlayground pulseSensor1;
PulseSensorPlayground pulseSensor2;

// Constants
const float area_cm2 = 10.0;                  // Force application area in cm²
const float area_m2 = area_cm2 / 10000.0;     // Convert cm² to m²
long randNumber;

// Variables
int buttonState = 0;

void setup() {
  Serial.begin(115200);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println("\nConnected to WiFi");

  // Firebase Configuration
  config.host = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  // Initialize pins
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);

  // Initialize HX711
  initializeHX711();

  // Initialize DHT11
  dht.begin();

  // Initialize ADXL345
  initializeADXL345();

  // Initialize Pulse Sensors
  initializePulseSensors();
}

void loop() {
  readAndDisplayHX711Data();
  readAndDisplayDHTData();
  readAndDisplayHeartRate();
  readAndDisplayAccelerometerData();
  controlMotorAndSolenoid();
  delay(500); // Stability delay
}

// Initialize HX711
void initializeHX711() {
  scale.begin(DT, SCK);
  Serial.println("Initializing HX711...");
  delay(1000);
  if (scale.is_ready()) {
    Serial.println("HX711 is ready.");
    scale.set_scale(1000);  // Calibration factor (adjust as needed)
    scale.tare();
  } else {
    Serial.println("HX711 not found.");
    while (1);
  }
}

// Initialize ADXL345
void initializeADXL345() {
  Wire.begin();
  Wire.beginTransmission(ADXL345);
  Wire.write(0x2D);
  Wire.write(0);
  Wire.endTransmission();
  Wire.beginTransmission(ADXL345);
  Wire.write(0x2D);
  Wire.write(16);
  Wire.endTransmission();
  Wire.beginTransmission(ADXL345);
  Wire.write(0x2D);
  Wire.write(8);
  Wire.endTransmission();
}

// Initialize Pulse Sensors
void initializePulseSensors() {
  pulseSensor1.analogInput(PULSE_INPUT_1);
  pulseSensor1.setThreshold(250);

  pulseSensor2.analogInput(PULSE_INPUT_2);
  pulseSensor2.setThreshold(250);

  if (pulseSensor1.begin() && pulseSensor2.begin()) {
    Serial.println("Pulse Sensors Initialized");
  }
}

// Read and display HX711 data
void readAndDisplayHX711Data() {
  if (scale.is_ready()) {
    float weight_grams = scale.get_units(10);  // Read weight in grams
    float weight_kg = weight_grams / 1000.0;   // Convert to kg
    float force_N = weight_kg * 9.81;         // Convert to force (Newtons)
    float pressure_Pa = force_N / area_m2;    // Calculate pressure in Pascals
    float pressure_psi = pressure_Pa * 0.000145038; // Convert to PSI

    Serial.print("Weight: ");
    Serial.print(weight_grams);
    Serial.print(" g | Pressure: ");
    Serial.print(pressure_psi);
    Serial.println(" PSI");
    Firebase.setFloat(fbdo, "sensors/xvoICUzkCXbaKMlGvJ0vo1zcKKI3/bloodpressure", pressure_psi);
  } else {
    Serial.println("HX711 not ready.");
  }
}

// Read and display DHT11 data
void readAndDisplayDHTData() {
  float humi = dht.readHumidity();
  float temp = dht.readTemperature();
  Serial.print("Temperature: ");
  Serial.print(temp);
  Serial.print("ºC ");
  Serial.print("Humidity: ");
  Serial.println(humi);
  Firebase.setFloat(fbdo, "sensors/xvoICUzkCXbaKMlGvJ0vo1zcKKI3/temperature", temp);
  Firebase.setFloat(fbdo, "sensors/xvoICUzkCXbaKMlGvJ0vo1zcKKI3/humidity", humi);
}

// Read and display heart rate data
void readAndDisplayHeartRate() {
  int heartRate1 = pulseSensor1.getBeatsPerMinute();
  if (heartRate1 > 0) {
    Serial.print("Heart Rate Sensor 1: ");
    Serial.println(heartRate1);
  }

  int heartRate2 = pulseSensor2.getBeatsPerMinute();
  if (heartRate2 > 0) {
    Serial.print("Heart Rate Sensor 2: ");
    Serial.println(heartRate2);
    Firebase.setFloat(fbdo, "sensors/xvoICUzkCXbaKMlGvJ0vo1zcKKI3/heartbeat", heartRate2);
  }
}

// Read and display accelerometer data
void readAndDisplayAccelerometerData() {
  int x = 0, y = 0, z = 0;
  Wire.beginTransmission(ADXL345);
  Wire.write(0x32);
  Wire.endTransmission();
  Wire.requestFrom(ADXL345, 6);
  if (6 <= Wire.available()) {
    x = Wire.read() | Wire.read() << 8;
    y = Wire.read() | Wire.read() << 8;
    z = Wire.read() | Wire.read() << 8;
  }
  Serial.print("X: ");
  Serial.print(x);
  Serial.print(" | Y: ");
  Serial.print(y);
  Serial.print(" | Z: ");
  Serial.println(z);

  Firebase.setFloat(fbdo, "sensors/xvoICUzkCXbaKMlGvJ0vo1zcKKI3/x", x);
  Firebase.setFloat(fbdo, "sensors/xvoICUzkCXbaKMlGvJ0vo1zcKKI3/y", y);
  Firebase.setFloat(fbdo, "sensors/xvoICUzkCXbaKMlGvJ0vo1zcKKI3/z", z);


}

// Motor and solenoid control logic
void controlMotorAndSolenoid() {
  buttonState = digitalRead(BUTTON_PIN);
  if (buttonState == HIGH) {
    Serial.println("Solenoid ON");
    digitalWrite(IN3, HIGH);  // Activate solenoid
    digitalWrite(IN4, LOW);

    Serial.println("Motor Started");
    digitalWrite(IN1, HIGH); // Start motor
    digitalWrite(IN2, LOW);

    long randNumber = random(100, 150); // Generate random number
    Serial.println(randNumber);
    Firebase.setInt(fbdo, "sensors/xvoICUzkCXbaKMlGvJ0vo1zcKKI3/bloodpressure", randNumber);

  } else {
    // Turn everything off
    digitalWrite(IN1, LOW);
    digitalWrite(IN2, LOW);
    digitalWrite(IN3, LOW);
    digitalWrite(IN4, LOW);
  }
}
'''),
            const SizedBox(height: 24),
            _buildSectionTitle('Setup Instructions'),
            _buildStep(
              number: 1,
              title: "Install Required Libraries",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLibraryItem("FirebaseESP32"),
                  _buildLibraryItem("PulseSensorPlayground"),
                  _buildLibraryItem("DHT sensor library"),
                  _buildLibraryItem("WiFi"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildStep(
              number: 2,
              title: "Hardware Connections",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildConnectionItem("DHT11 VCC → 3.3V"),
                  _buildConnectionItem("DHT11 GND → GND"),
                  _buildConnectionItem("DHT11 DATA → GPIO4"),
                  _buildConnectionItem("Pulse Sensor VCC → 3.3V"),
                  _buildConnectionItem("Pulse Sensor GND → GND"),
                  _buildConnectionItem("Pulse Sensor SIG → GPIO34"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildStep(
              number: 3,
              title: "Configuration",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildConfigItem("WIFI_SSID", "Your WiFi network name"),
                  _buildConfigItem("WIFI_PASSWORD", "Your WiFi password"),
                  _buildConfigItem("FIREBASE_HOST", "From Firebase console"),
                  _buildConfigItem("FIREBASE_AUTH", "Database secret key"),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  const codeText = '''
#include "DHT.h"
#define DHT11PIN 15
DHT dht(DHT11PIN, DHT11);
#include <Wire.h>
#define ADXL345 0x53
#include <HX711.h>
#include <PulseSensorPlayground.h>
#include <WiFi.h>
#include <FirebaseESP32.h>


#define WIFI_SSID "WIFIID"
#define WIFI_PASSWORD "Password"
#define FIREBASE_HOST "allobaby-a14cd-default-rtdb.firebaseio.com"  // Example: "your-project-id.firebaseio.com"
#define FIREBASE_AUTH "8NbU9GOqnUYTGqBSF3CK4UbvXIBpjwWNRy0SEERb"         // Get from Firebase Project Settings

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// Pin definitions
#define DT 4   // HX711 DOUT
#define SCK 2  // HX711 SCK
#define BUTTON_PIN 25
#define IN1 12
#define IN2 14
#define IN3 27
#define IN4 26

const int PULSE_INPUT_1 = 36;  // First Pulse Sensor
const int PULSE_INPUT_2 = 35;  // Second Pulse Sensor

// HX711 and Pulse Sensors
HX711 scale;
PulseSensorPlayground pulseSensor1;
PulseSensorPlayground pulseSensor2;

// Constants
const float area_cm2 = 10.0;                  // Force application area in cm²
const float area_m2 = area_cm2 / 10000.0;     // Convert cm² to m²
long randNumber;

// Variables
int buttonState = 0;

void setup() {
  Serial.begin(115200);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println("\nConnected to WiFi");

  // Firebase Configuration
  config.host = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  // Initialize pins
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);

  // Initialize HX711
  initializeHX711();

  // Initialize DHT11
  dht.begin();

  // Initialize ADXL345
  initializeADXL345();

  // Initialize Pulse Sensors
  initializePulseSensors();
}

void loop() {
  readAndDisplayHX711Data();
  readAndDisplayDHTData();
  readAndDisplayHeartRate();
  readAndDisplayAccelerometerData();
  controlMotorAndSolenoid();
  delay(500); // Stability delay
}

// Initialize HX711
void initializeHX711() {
  scale.begin(DT, SCK);
  Serial.println("Initializing HX711...");
  delay(1000);
  if (scale.is_ready()) {
    Serial.println("HX711 is ready.");
    scale.set_scale(1000);  // Calibration factor (adjust as needed)
    scale.tare();
  } else {
    Serial.println("HX711 not found.");
    while (1);
  }
}

// Initialize ADXL345
void initializeADXL345() {
  Wire.begin();
  Wire.beginTransmission(ADXL345);
  Wire.write(0x2D);
  Wire.write(0);
  Wire.endTransmission();
  Wire.beginTransmission(ADXL345);
  Wire.write(0x2D);
  Wire.write(16);
  Wire.endTransmission();
  Wire.beginTransmission(ADXL345);
  Wire.write(0x2D);
  Wire.write(8);
  Wire.endTransmission();
}

// Initialize Pulse Sensors
void initializePulseSensors() {
  pulseSensor1.analogInput(PULSE_INPUT_1);
  pulseSensor1.setThreshold(250);

  pulseSensor2.analogInput(PULSE_INPUT_2);
  pulseSensor2.setThreshold(250);

  if (pulseSensor1.begin() && pulseSensor2.begin()) {
    Serial.println("Pulse Sensors Initialized");
  }
}

// Read and display HX711 data
void readAndDisplayHX711Data() {
  if (scale.is_ready()) {
    float weight_grams = scale.get_units(10);  // Read weight in grams
    float weight_kg = weight_grams / 1000.0;   // Convert to kg
    float force_N = weight_kg * 9.81;         // Convert to force (Newtons)
    float pressure_Pa = force_N / area_m2;    // Calculate pressure in Pascals
    float pressure_psi = pressure_Pa * 0.000145038; // Convert to PSI

    Serial.print("Weight: ");
    Serial.print(weight_grams);
    Serial.print(" g | Pressure: ");
    Serial.print(pressure_psi);
    Serial.println(" PSI");
    Firebase.setFloat(fbdo, "sensors/xvoICUzkCXbaKMlGvJ0vo1zcKKI3/bloodpressure", pressure_psi);
  } else {
    Serial.println("HX711 not ready.");
  }
}

// Read and display DHT11 data
void readAndDisplayDHTData() {
  float humi = dht.readHumidity();
  float temp = dht.readTemperature();
  Serial.print("Temperature: ");
  Serial.print(temp);
  Serial.print("ºC ");
  Serial.print("Humidity: ");
  Serial.println(humi);
  Firebase.setFloat(fbdo, "sensors/xvoICUzkCXbaKMlGvJ0vo1zcKKI3/temperature", temp);
  Firebase.setFloat(fbdo, "sensors/xvoICUzkCXbaKMlGvJ0vo1zcKKI3/humidity", humi);
}

// Read and display heart rate data
void readAndDisplayHeartRate() {
  int heartRate1 = pulseSensor1.getBeatsPerMinute();
  if (heartRate1 > 0) {
    Serial.print("Heart Rate Sensor 1: ");
    Serial.println(heartRate1);
  }

  int heartRate2 = pulseSensor2.getBeatsPerMinute();
  if (heartRate2 > 0) {
    Serial.print("Heart Rate Sensor 2: ");
    Serial.println(heartRate2);
    Firebase.setFloat(fbdo, "sensors/xvoICUzkCXbaKMlGvJ0vo1zcKKI3/heartbeat", heartRate2);
  }
}

// Read and display accelerometer data
void readAndDisplayAccelerometerData() {
  int x = 0, y = 0, z = 0;
  Wire.beginTransmission(ADXL345);
  Wire.write(0x32);
  Wire.endTransmission();
  Wire.requestFrom(ADXL345, 6);
  if (6 <= Wire.available()) {
    x = Wire.read() | Wire.read() << 8;
    y = Wire.read() | Wire.read() << 8;
    z = Wire.read() | Wire.read() << 8;
  }
  Serial.print("X: ");
  Serial.print(x);
  Serial.print(" | Y: ");
  Serial.print(y);
  Serial.print(" | Z: ");
  Serial.println(z);

  Firebase.setFloat(fbdo, "sensors/xvoICUzkCXbaKMlGvJ0vo1zcKKI3/x", x);
  Firebase.setFloat(fbdo, "sensors/xvoICUzkCXbaKMlGvJ0vo1zcKKI3/y", y);
  Firebase.setFloat(fbdo, "sensors/xvoICUzkCXbaKMlGvJ0vo1zcKKI3/z", z);


}

// Motor and solenoid control logic
void controlMotorAndSolenoid() {
  buttonState = digitalRead(BUTTON_PIN);
  if (buttonState == HIGH) {
    Serial.println("Solenoid ON");
    digitalWrite(IN3, HIGH);  // Activate solenoid
    digitalWrite(IN4, LOW);

    Serial.println("Motor Started");
    digitalWrite(IN1, HIGH); // Start motor
    digitalWrite(IN2, LOW);

    long randNumber = random(100, 150); // Generate random number
    Serial.println(randNumber);
    Firebase.setInt(fbdo, "sensors/xvoICUzkCXbaKMlGvJ0vo1zcKKI3/bloodpressure", randNumber);

  } else {
    // Turn everything off
    digitalWrite(IN1, LOW);
    digitalWrite(IN2, LOW);
    digitalWrite(IN3, LOW);
    digitalWrite(IN4, LOW);
  }
}
''';

                  Clipboard.setData(const ClipboardData(text: codeText)).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Code copied to clipboard')),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE75480),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Copy Code',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color(0xFFE75480),
      ),
    );
  }

  Widget _buildCodeBlock(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          code,
          style: GoogleFonts.robotoMono(
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildStep({required int number, required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFE75480),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: content,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildLibraryItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.library_books, size: 16, color: Color(0xFFE75480)),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.robotoMono()),
        ],
      ),
    );
  }

  Widget _buildConnectionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Color(0xFFE75480)),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.poppins()),
        ],
      ),
    );
  }

  Widget _buildConfigItem(String variable, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            variable,
            style: GoogleFonts.robotoMono(
              color: const Color(0xFFE75480),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}