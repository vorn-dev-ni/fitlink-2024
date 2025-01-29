import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CurrentUserInfoTmp extends StatelessWidget {
  const CurrentUserInfoTmp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    debugPrint('user ${user}');
    return Column(
      children: [
        Center(child: Text("User name ${user?.displayName}")),
        Center(child: Text("Email ${user?.email}")),
        Center(
            child:
                Text("User login using ${user?.providerData[0]?.providerId}")),
        Center(child: Text("User phone ${user?.phoneNumber}")),
        Center(child: Text("Email verify ${user?.emailVerified}")),
        Center(child: Text("Token Id ${user?.uid}")),
      ],
    );
  }
}
