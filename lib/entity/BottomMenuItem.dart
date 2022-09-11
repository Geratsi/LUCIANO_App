
class BottomMenuItem {
  final String name;
  // final Widget widget;
  final bool isPadding;
  final String selectedImagePath;
  final String unselectedImagePath;

  const BottomMenuItem({
    required this.name,
    // required this.widget,
    required this.selectedImagePath,
    required this.unselectedImagePath,
    this.isPadding = false,
  });
}
