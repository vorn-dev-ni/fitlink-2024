import 'package:demo/utils/constant/enums.dart';

class Activity {
  final String title;
  final ActivityTag tag;
  final DateTime createdDate;
  final String imageUrl;

  Activity({
    required this.title,
    required this.imageUrl,
    required this.tag,
    required this.createdDate,
  });
}
