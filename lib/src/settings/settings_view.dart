import 'package:flutter/material.dart';
import 'package:microbial_source_tracking/src/settings/settings_model.dart';
import 'package:microbial_source_tracking/src/widgets/profile_card.dart';
import 'package:microbial_source_tracking/src/widgets/settings_card.dart';




class SettingsView extends StatefulWidget {
  const SettingsView({
    super.key,
    });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      //ignore: prefer_const_constructors
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start ,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ProfileCard(),
                const SizedBox(height: 0.005),
                const Divider(),
                const SizedBox(height: 10),
                Column(
                  children: List.generate(
                    settings.length, 
                    (index) => SettingsCard(settings: settings[index]),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}








