
# 📝 Moodiary  
Your Personal Mood Tracker App — Built with Flutter & Firebase  

![Moodiary Banner](assets/banner.png) <!-- optional banner image -->  

---

## 📱 About  
**Moodiary** is a minimalist, daily mood tracking application inspired by popular apps like **Daylio** and **DailyBean**. It helps users visualize emotional patterns through **calendar logs**, **charts**, and **reports**, offering insights into mental well-being over time.  

---

## ✨ Key Features  
- 📅 **Mood Calendar** — Log daily moods with icons & custom notes.  
- 📊 **Mood Flow Reports** — Visualize trends monthly and yearly via charts.  
- 📈 **Statistics & Analytics** — Frequent moods, best/worst days, icons breakdown.  
- 🎨 **Custom Recording Blocks** — Personalize activities (sleep, work, exercise).  
- 🔔 **Reminders & Notifications** — Encourage consistent journaling.  
- ☁️ **Firebase Integration** — Realtime cloud sync, auth, and Firestore storage.  

---

## 🛠️ Tech Stack  
| Technology | Usage       |
|------------|-------------|
| Flutter    | Frontend UI |
| Firebase   | Backend (Auth, Firestore, Storage) |
| GetX       | State Management, Navigation |
| FL_Chart   | Data Visualization |
| Hive       | Local Storage (optional) |

---

## 📂 Project Structure (Simplified)
```
lib/
├── features/
│   └── moodiary/
│       ├── controllers/
│       ├── models/
│       ├── screens/
│       ├── widgets/
├── utils/
├── main.dart
```

---

## 🚀 Getting Started  

### 1️⃣ Prerequisites  
- Flutter SDK (Stable)  
- Firebase Project (Firestore, Auth enabled)  

### 2️⃣ Installation  
```bash
git clone https://github.com/yourusername/moodiary.git
cd moodiary
flutter pub get
flutterfire configure
flutter run
```

---

## 🔑 Environment Setup  
Create a `.env` file or configure Firebase directly:
```
API_KEY=your_firebase_api_key
APP_ID=your_firebase_app_id
PROJECT_ID=your_firebase_project_id
```

---

## 📸 Screenshots  
| Calendar View | Mood Report | Customize Block |
|:--:|:--:|:--:|
| ![](assets/calendar.png) | ![](assets/report.png) | ![](assets/customize.png) |

---

## 📌 Roadmap  
- [x] Daily Mood Logging  
- [x] Calendar View  
- [x] Annual & Monthly Reports  
- [x] Custom Recording Blocks  
- [ ] Cloud Backup (Firestore Sync)  
- [ ] Dark / Light Themes  
- [ ] Export Data as CSV  

---

## 🧑‍💻 Contributing  
Pull requests are welcome. Please follow conventional commits and include clear descriptions.  

---

## 📄 License  
[MIT License](LICENSE)  

---

## 🙌 Acknowledgements  
Inspired by:  
- Daylio  
- DailyBean  

Thanks to the Flutter and Firebase communities for their incredible support.  
