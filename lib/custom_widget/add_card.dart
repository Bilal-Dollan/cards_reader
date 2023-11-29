import 'package:flutter/material.dart';
import 'package:personal_cards_reader/pages/add_card_manualy_view.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        semanticContainer: true,
        child: OutlinedButton(
          style: const ButtonStyle(
            side: MaterialStatePropertyAll(
              BorderSide(style: BorderStyle.none),
            ),
          ),
          onPressed: () {
            showBottomDialog(context);
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Icon(
                      Icons.add_circle_outline,
                      size: 50,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      "Add Card",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showBottomDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,

    builder: (BuildContext context) {
      return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Select option',
                textScaler: TextScaler.linear(1.4),
              ),
              const Divider(),
              const SizedBox(height: 16.0),
              OutlinedButton(
                onPressed: () {},
                child: const Text("Fill data from camera"),
              ),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FormFields(),
                      ),
                    );
                  },
                  child: const Text("Fill data manualy"))
            ],
          ),
        ),
      );
    },
    barrierColor: Colors.black.withOpacity(0.5),
    isDismissible: true, // Set isDismissible to true
    enableDrag: true,
  );
}
