import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardList extends StatelessWidget {
  String personName;
  String companyName;

  CardList({
    super.key,
    this.personName = 'Person Name',
    this.companyName = 'Comapny Name',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Card(
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: OutlinedButton(
          onPressed: () {},
          style: const ButtonStyle(
              side:
                  MaterialStatePropertyAll(BorderSide(style: BorderStyle.none)),
              foregroundColor: MaterialStatePropertyAll(Colors.indigo)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: Icon(
                      Icons.circle,
                      size: 50,
                      color: Colors.amber[80],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 16, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          personName,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.normal),
                        ),
                        Text(
                          companyName,
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
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
