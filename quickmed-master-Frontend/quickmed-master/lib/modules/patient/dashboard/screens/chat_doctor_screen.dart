import 'package:flutter/material.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/appointment_widget.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/chat_box_widget.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/custom_back_button.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/profile_pic.dart';
import 'package:quickmed/utils/device_utility.dart';
import 'package:quickmed/utils/image_path.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';
import 'package:quickmed/utils/widgets/TButton.dart';
import 'package:quickmed/utils/widgets/text_input_widget.dart';

class ChatDoctorScreen extends StatelessWidget {
  const ChatDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              CustomBackButton(),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      /// --------- DOCTOR PROFILE WITH APPOINTMENT---------///

                      Container(
                        width: 410,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: QColors.brand100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: ProfilePic(
                                      imagePath: QImagesPath.doctorProfileImg,
                                      onTap: () {},
                                    ),
                                  ),
                                  Expanded(
                                    child: QButton(
                                      text: "Dr Sara John - Cardiology ",
                                      buttonType: QButtonType.text,
                                      onPressed: () {},
                                    ),
                                  ),
                                  SizedBox(width: 60),
                                ],
                              ),
                              AppointmentWidget(
                                date: "10 October 2025",
                                time: "10:30 AM",
                                status: Status.accepted,
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      /// --------- DOCTOR PROFILE WITH APPOINTMENT---------///


                      /// -------------- DOCTOR PATIENT CHATS --------------///

                      ChatBoxWidget(chat: "Hello!"),
                      ChatBoxWidget(
                        chat: "My illness need urgent attention now",
                      ),
                      ChatBoxWidget(chat: "Hello Doe !", isReceived: true),
                      ChatBoxWidget(
                        chat: "I am on my way now",
                        isReceived: true,
                      ),
                      ChatBoxWidget(chat: "Ok"),

                      /// -------------- DOCTOR PATIENT CHATS --------------///

                    ],
                  ),
                ),
              ),

              /// --------- TEXT INPUT FIELD WIDGET WITH SEND BUTTON ---------///

              Row(
                children: [
                  Expanded(
                    child: TextInputWidget(
                      dark: isDark,
                      hintText: "Type your message",
                    ),
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: QColors.primary,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: QColors.lightBackground,
                    ),
                  ),
                  SizedBox(width: 5),

                  /// --------- TEXT INPUT FIELD WIDGET WITH SEND BUTTON ---------///

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
