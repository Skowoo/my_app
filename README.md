# 🎮 Flutter Tic-Tac-Toe

Aplikacja mobilna Flutter umożliwiająca grę w kółko i krzyżyk lokalnie lub online przez SignalR.

## ✅ Funkcje
- Rozgrywka jednoosobowa (offline)
- Rozgrywka dla dwóch osób (online)
- Automatyczne parowanie graczy

## 📱 Ekrany

- **Menu główne** – wybór trybu gry
- **Gra single** – gra lokalna
- **Gra online** – gra z innym graczem (SignalR)
- **Ustawienia** – zmiana adresu backendu

## 🧰 Technologie

- Flutter + Provider
- ASP.NET Core SignalR (backend)
- `signalr_core` do komunikacji przez WebSocket

## ▶️ Uruchomienie

1. Uruchom backend ASP.NET Core na `https://10.0.2.2:5028`
2. Uruchom aplikację Flutter na emulatorze Android:

   ```bash
   flutter pub get
   flutter run

3. W ustawieniach aplikacji wpisz adres backendu (domyślnie zakodowany jest adres z sieci lokalnej)

⚠️ Uwaga
Certyfikaty deweloperskie są akceptowane w kodzie SignalR (dla emulatora Androida).
