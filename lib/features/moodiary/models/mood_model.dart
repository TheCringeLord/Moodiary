import 'package:cloud_firestore/cloud_firestore.dart';

class MoodModel {
  final String id;
  final DateTime date;
  final String mainMood;

  // Optional fields
  final List<String>? emotions;
  final List<String>? people;
  final List<String>? weather;
  final List<String>? hobbies;
  final List<String>? work;
  final List<String>? health;
  final List<String>? chores;
  final List<String>? relationship;
  final List<String>? other;
  final Map<String, List<String>>? customBlocks;

  final DateTime? sleepStart;
  final DateTime? sleepEnd;
  final String? exercise;
  final int? steps;
  final int? menstruationDay;
  final String? note;
  final List<String>? photos;
  final int? energyLevel;
  final int? stressLevel;
  final List<String>? tags;

  ///* Constructor
  MoodModel({
    required this.id,
    required this.date,
    required this.mainMood,
    this.emotions,
    this.people,
    this.weather,
    this.hobbies,
    this.work,
    this.health,
    this.chores,
    this.relationship,
    this.other,
    this.customBlocks,
    this.sleepStart,
    this.sleepEnd,
    this.exercise,
    this.steps,
    this.menstruationDay,
    this.note,
    this.photos,
    this.energyLevel,
    this.stressLevel,
    this.tags,
  });

  ///* Convert model to JSON
  Map<String, dynamic> toMap() {
    final data = {
      'id': id,
      'date': Timestamp.fromDate(date),
      'mainMood': mainMood,
      'emotions': emotions,
      'people': people,
      'weather': weather,
      'hobbies': hobbies,
      'work': work,
      'health': health,
      'chores': chores,
      'relationship': relationship,
      'other': other,
      'customBlocks': customBlocks,
      'sleepStart': sleepStart != null ? Timestamp.fromDate(sleepStart!) : null,
      'sleepEnd': sleepEnd != null ? Timestamp.fromDate(sleepEnd!) : null,
      'exercise': exercise,
      'steps': steps,
      'menstruationDay': menstruationDay,
      'note': note,
      'photos': photos,
      'energyLevel': energyLevel,
      'stressLevel': stressLevel,
      'tags': tags,
    };

    // Remove fields that are null
    data.removeWhere((key, value) => value == null);

    return data;
  }

  ///* Create MoodModel from Map (Firebase snapshot)
  factory MoodModel.fromMap(Map<String, dynamic> map) {
    return MoodModel(
      id: map['id'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      mainMood: map['mainMood'] ?? '',
      emotions:
          (map['emotions'] != null) ? List<String>.from(map['emotions']) : null,
      people: (map['people'] != null) ? List<String>.from(map['people']) : null,
      weather:
          (map['weather'] != null) ? List<String>.from(map['weather']) : null,
      hobbies:
          (map['hobbies'] != null) ? List<String>.from(map['hobbies']) : null,
      work: (map['work'] != null) ? List<String>.from(map['work']) : null,
      health: (map['health'] != null) ? List<String>.from(map['health']) : null,
      chores: (map['chores'] != null) ? List<String>.from(map['chores']) : null,
      relationship: (map['relationship'] != null)
          ? List<String>.from(map['relationship'])
          : null,
      other: (map['other'] != null) ? List<String>.from(map['other']) : null,
      customBlocks: (map['customBlocks'] != null)
          ? Map<String, List<String>>.from(
              (map['customBlocks'] as Map).map(
                (key, value) =>
                    MapEntry(key.toString(), List<String>.from(value)),
              ),
            )
          : null,
      sleepStart: (map['sleepStart'] != null)
          ? (map['sleepStart'] as Timestamp).toDate()
          : null,
      sleepEnd: (map['sleepEnd'] != null)
          ? (map['sleepEnd'] as Timestamp).toDate()
          : null,
      exercise: map['exercise'],
      steps: map['steps'],
      menstruationDay: map['menstruationDay'],
      note: map['note'],
      photos: (map['photos'] != null) ? List<String>.from(map['photos']) : null,
      energyLevel: map['energyLevel'],
      stressLevel: map['stressLevel'],
      tags: (map['tags'] != null) ? List<String>.from(map['tags']) : null,
    );
  }

  ///* Create MoodModel from DocumentSnapshot (Firebase)
  factory MoodModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MoodModel.fromMap(data);
  }

  ///* Copy with method
  MoodModel copyWith({
    String? id,
    DateTime? date,
    String? mainMood,
    List<String>? emotions,
    List<String>? people,
    List<String>? weather,
    List<String>? hobbies,
    List<String>? work,
    List<String>? health,
    List<String>? chores,
    List<String>? relationship,
    List<String>? other,
    Map<String, List<String>>? customBlocks,
    DateTime? sleepStart,
    DateTime? sleepEnd,
    String? exercise,
    int? steps,
    int? menstruationDay,
    String? note,
    List<String>? photos,
    int? energyLevel,
    int? stressLevel,
    List<String>? tags,
  }) {
    return MoodModel(
      id: id ?? this.id,
      date: date ?? this.date,
      mainMood: mainMood ?? this.mainMood,
      emotions: emotions ?? this.emotions,
      people: people ?? this.people,
      weather: weather ?? this.weather,
      hobbies: hobbies ?? this.hobbies,
      work: work ?? this.work,
      health: health ?? this.health,
      chores: chores ?? this.chores,
      relationship: relationship ?? this.relationship,
      other: other ?? this.other,
      customBlocks: customBlocks ?? this.customBlocks,
      exercise: exercise ?? this.exercise,
      steps: steps ?? this.steps,
      menstruationDay: menstruationDay ?? this.menstruationDay,
      note: note ?? this.note,
      photos: photos ?? this.photos,
      energyLevel: energyLevel ?? this.energyLevel,
      stressLevel: stressLevel ?? this.stressLevel,
      tags: tags ?? this.tags,
    );
  }

  ///* Helper Functions
  bool get hasEmotions => emotions != null && emotions!.isNotEmpty;
  bool get hasActivities {
    return (people != null && people!.isNotEmpty) ||
        (weather != null && weather!.isNotEmpty) ||
        (hobbies != null && hobbies!.isNotEmpty) ||
        (work != null && work!.isNotEmpty) ||
        (health != null && health!.isNotEmpty) ||
        (chores != null && chores!.isNotEmpty) ||
        (relationship != null && relationship!.isNotEmpty) ||
        (other != null && other!.isNotEmpty) ||
        (customBlocks != null && customBlocks!.isNotEmpty);
  }

  double get sleepDurationInHours {
    if (sleepStart == null || sleepEnd == null) return 0;
    return sleepEnd!.difference(sleepStart!).inMinutes / 60.0;
  }

  bool get hasNotes => note != null && note!.isNotEmpty;
  bool get hasPhotos => photos != null && photos!.isNotEmpty;

  int get moodScore {
    switch (mainMood) {
      case "veryHappy":
        return 5;
      case "happy":
        return 4;
      case "neutral":
        return 3;
      case "unhappy":
        return 2;
      case "sad":
        return 1;
      default:
        return 3;
    }
  }
}
