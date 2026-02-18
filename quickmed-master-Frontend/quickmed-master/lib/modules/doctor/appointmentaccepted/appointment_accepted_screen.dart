import 'package:flutter/material.dart';

import '../../../utils/image_path.dart';
import '../../../utils/widgets/TButton.dart';
import '../widgets/success_message_widget.dart';

class AppointmentAcceptedScreen extends StatelessWidget {
  const AppointmentAcceptedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          child: Column(
            children: [
              Center(
                child: SuccessMessageWidget(
                  title: "Appointment has been accepted\nsuccessfully",
                  subTitle: "Notification sent to the Patient",
                  iconPath: QImagesPath.successfully,
                ),
              ),
        Spacer(),
        QButton(
          text: "Done",
          onPressed: () {
            Navigator.pop(context);
          },),
              SizedBox(height: 26),

              
            ],
          ),
        ),

      ),
    );
  }
}
