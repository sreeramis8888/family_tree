import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(fontSize: 17),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: kWhite,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              scale: 8,
              'assets/pngs/familytree_logo.png',
            ),
            SizedBox(height: 16),
            SizedBox(height: 8),
            Text(
              '''The familytree is a non-profit organisation that strives to be the indispensable resource for the business community. It is a voluntary organisation of business owners who are investing their money and time in the true development of the country and its people - working together TO GIVE AND GROW TOGETHER GLOBALLY. Our main motto is to build business relationships and educate people to enable the business communities and members to prosper.''',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            SizedBox(height: 16),
            // Image.network('https://placehold.co/600x400/png'),
          ],
        ),
      ),
    );
  }
}
