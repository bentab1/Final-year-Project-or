import 'package:flutter/material.dart';
import 'package:quickmed/utils/sizes.dart';

import '../../../utils/image_path.dart';
import '../../../utils/widgets/TButton.dart';
import '../widgets/success_message_widget.dart';

class AppointmentRejectedScreen extends StatelessWidget {
  const AppointmentRejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(
            horizontal:   QSizes.md,
            vertical: QSizes.md,
          ),
          child: Column(
            children: [
              Center(
                child: SuccessMessageWidget(
                  title: "Appointment has been Rejected\nsuccessfully",
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
