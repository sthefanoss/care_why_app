import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class MoneyIndicator extends StatelessWidget {
  const MoneyIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white,
      borderRadius: BorderRadius.circular(40)

      ),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Consumer<AuthProvider>(
            builder: (context, provider, _) => Text(
              (provider.authUser?.coins ?? 0).toString().padLeft(3, '0'),
              style: TextStyle(
                color: Color(0xFF4A2D00),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 4),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Color(0xFFFFD600),
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
    );
  }
}
