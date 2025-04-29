import 'package:get/get.dart';
import '../models/activity_model.dart';

class ActivityCustomizationController extends GetxController {
  static ActivityCustomizationController get instance => Get.find();

  // Original (saved) categories
  final RxList<Map<String, dynamic>> allCategories = <Map<String, dynamic>>[].obs;

  // Working draft (unsaved changes)
  final RxList<Map<String, dynamic>> draftCategories = <Map<String, dynamic>>[].obs;

  // Flag to track if there are unsaved changes
  final RxBool hasUnsavedChanges = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialCategories();
  }

  void _loadInitialCategories() {
    // Load default categories
    final initialCategories = [
      {
        'id': 'emotions',
        'title': 'Emotions',
        'icons': ActivityCategory.getEmotionIcons(),
        'isVisible': true,
        'isCustom': false,
      },
      {
        'id': 'people',
        'title': 'People',
        'icons': ActivityCategory.getPeopleIcons(),
        'isVisible': true,
        'isCustom': false,
      },
      {
        'id': 'weather',
        'title': 'Weather',
        'icons': ActivityCategory.getWeatherIcons(),
        'isVisible': true,
        'isCustom': false,
      },
    ];

    allCategories.value = initialCategories;

    // Create a deep copy for draft
    draftCategories.value = _deepCopyCategories(initialCategories);
  }

  // Deep copy helper
  List<Map<String, dynamic>> _deepCopyCategories(List<Map<String, dynamic>> source) {
    return source.map((category) => {
      'id': category['id'],
      'title': category['title'],
      'icons': List.from(category['icons']),
      'isVisible': category['isVisible'],
      'isCustom': category['isCustom'],
    }).toList();
  }

  // Get visible categories from draft
  List<Map<String, dynamic>> getVisibleCategories() {
    return draftCategories.where((category) => category['isVisible'] == true).toList();
  }

  // Get hidden categories from draft
  List<Map<String, dynamic>> getHiddenCategories() {
    return draftCategories.where((category) => category['isVisible'] == false).toList();
  }

  // Operations now modify the draft
  void updateCategoryTitle(String categoryId, String newTitle) {
    final index = draftCategories.indexWhere((c) => c['id'] == categoryId);
    if (index != -1) {
      final category = Map<String, dynamic>.from(draftCategories[index]);
      category['title'] = newTitle;
      draftCategories[index] = category;
      hasUnsavedChanges.value = true;
    }
  }

  void toggleCategoryVisibility(String categoryId) {
    final index = draftCategories.indexWhere((c) => c['id'] == categoryId);
    if (index != -1) {
      final category = Map<String, dynamic>.from(draftCategories[index]);
      final isVisible = !(category['isVisible'] as bool);
      category['isVisible'] = isVisible;
      draftCategories[index] = category;
      hasUnsavedChanges.value = true;
    }
  }

  void deleteCategory(String categoryId) {
    draftCategories.removeWhere((c) => c['id'] == categoryId);
    hasUnsavedChanges.value = true;
  }

  void createNewCategory(String title) {
    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    draftCategories.add({
      'id': id,
      'title': title,
      'icons': <ActivityIcon>[],
      'isVisible': true,
      'isCustom': true,
    });
    hasUnsavedChanges.value = true;
  }

  // Apply changes to save draft to main categories
  void saveChanges() {
    allCategories.value = _deepCopyCategories(draftCategories);
    hasUnsavedChanges.value = false;

    // In the future, this would save to persistent storage
    // saveToStorage();
  }

  // Discard changes
  void discardChanges() {
    draftCategories.value = _deepCopyCategories(allCategories);
    hasUnsavedChanges.value = false;
  }
}
