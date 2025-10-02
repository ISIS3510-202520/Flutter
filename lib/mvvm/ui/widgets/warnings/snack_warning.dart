import 'package:flutter/material.dart';

class SnackWarning {
	static void show(BuildContext context, String message) {
		ScaffoldMessenger.of(context).showSnackBar(
			SnackBar(
				content: Text(
					message,
					style: const TextStyle(color: Colors.black),
				),
				backgroundColor: const Color(0xFF8CC0CF),
				behavior: SnackBarBehavior.floating,
			),
		);
	}
}