import 'package:demo/data/service/firestore/base_service.dart';

class ProfileRepository extends BaseUserService {
  late BaseUserService baseService;

  ProfileRepository({
    required this.baseService,
  });

  @override
  Future updateCoverImage(Map<String, dynamic> data) async {
    try {
      await baseService.updateCoverImage(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future updateProfile(Map<String, dynamic> data) async {
    try {
      await baseService.updateProfile(data);
    } catch (e) {
      rethrow;
    }
  }
}
