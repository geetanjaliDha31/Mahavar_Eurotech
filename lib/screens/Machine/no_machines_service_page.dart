import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/screens/Machine/add_machine.dart';

class NoMachineServicePage extends StatefulWidget {
  const NoMachineServicePage({super.key});

  @override
  State<NoMachineServicePage> createState() => _NoMachineServicePageState();
}

class _NoMachineServicePageState extends State<NoMachineServicePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            height: 250,
            width: 250,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/add_machine.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        // SizedBox(
        //   height: 15,
        // ),
        Text(
          "No Devices added yet",
          style: TextStyle(
              color: color2, fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "Add Devices for further service requests",
          style: TextStyle(
              color: color2, fontWeight: FontWeight.w400, fontSize: 13),
        ),
        const SizedBox(
          height: 25,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddMachinePage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: color2,
              fixedSize: const Size(200, 45),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 27,
                width: 27,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.settings_suggest_outlined,
                  size: 26,
                  color: color2,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Add Machine',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        )
      ],
    );
  }
}
