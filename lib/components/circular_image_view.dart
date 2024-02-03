import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CircularImageView extends StatelessWidget {
  final Image child;
  final double size;

  const CircularImageView({Key? key, required this.child, this.size = 50})
      : super(key: key);

  CircularImageView.admin({Key? key, this.size = 50})
      : child = Image.network(
          FirebaseAuth.instance.currentUser?.photoURL ?? '',
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/admin_picture.png',
          ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(size),
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size),
          child: child,
        ),
      ),
    );
  }
}
