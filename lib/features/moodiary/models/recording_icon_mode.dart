
class RecordingIconModel {
  final String id;           // unique e.g. "excited"
  String label;              // display name e.g. "Excited"
  String iconPath;           // asset path or URL
  bool isCustom;             // user-created?

  RecordingIconModel({
    required this.id,
    required this.label,
    required this.iconPath,
    this.isCustom = false,
  });

  factory RecordingIconModel.fromMap(Map<String, dynamic> map) {
    return RecordingIconModel(
      id: map['id'],
      label: map['label'],
      iconPath: map['iconPath'],
      isCustom: map['isCustom'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'iconPath': iconPath,
      'isCustom': isCustom,
    };
  }
}
