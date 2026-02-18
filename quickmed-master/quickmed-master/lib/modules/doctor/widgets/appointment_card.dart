import 'package:flutter/material.dart';
class AppointmentCard1 extends StatelessWidget {
  final String name;
  final String status;
  final String date;
  final String time;
  final String medicalHistory;
  final String symptoms;
  final String imagePath;
  final String distance;
  final VoidCallback onDirectionTap;

  const AppointmentCard1({
    super.key,
    required this.name,
    required this.status,
    required this.date,
    required this.time,
    required this.medicalHistory,
    required this.symptoms,
    required this.imagePath,
    required this.distance,
    required this.onDirectionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- TOP ROW ----------------
          Container(
            width: 384,

            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(imagePath),
                    ),
                    const SizedBox(width: 10),

                    // Name + Status
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                        ),
                      ),
                    ),

                    Text(
                      status,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),


          const SizedBox(height: 12),

          // ---------------- DETAILS ----------------
          Row(
            children: [
              Text(
                "Date: ",
                style: _bold(),
              ),
              Text(date),
              const SizedBox(width: 10),
              Text(
                " | Time: ",
                style: _bold(),
              ),
              Text(time),
            ],
          ),

          const SizedBox(height: 6),

          Text.rich(
            TextSpan(
              text: "Medical History : ",
              style: _bold(),
              children: [
                TextSpan(
                  text: medicalHistory,
                  style: _normal(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Text.rich(
            TextSpan(
              text: "Current Symptoms: ",
              style: _bold(),
              children: [
                TextSpan(
                  text: symptoms,
                  style: _normal(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ---------------- BOTTOM DIRECTION BOX ----------------
          GestureDetector(
            onTap: onDirectionTap,
            child: Container(
              padding:  EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_pin, size: 20, color: Colors.red),
                  SizedBox(width: 6),
                  Text(
                    "Get direction",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    height: 18,
                    width: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    distance,
                    style: const TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------- TEXT STYLES -----------
  TextStyle _bold() => const TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w700,
  );

  TextStyle _normal() => const TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w400,
  );
}