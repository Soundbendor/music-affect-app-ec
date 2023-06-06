import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PersonalDataRoute extends StatefulWidget {
  final SharedPreferences preferences;
  final String uid;
  final void Function() updateState;
  const PersonalDataRoute(
      {Key? key,
      required this.preferences,
      required this.uid,
      required this.updateState})
      : super(key: key);

  @override
  State<PersonalDataRoute> createState() => _PersonalDataRouteState();
}

class _PersonalDataRouteState extends State<PersonalDataRoute> {
  final _formKey = GlobalKey<FormState>();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final locationController = TextEditingController();
  final primaryLanguageController = TextEditingController();
  final listeningHabitsController = TextEditingController();
  final musicExperienceController = TextEditingController();
  final hearingLossController = TextEditingController();

  String habits = "Select your listening habits";
  String experience = "Select your music experience";
  String hearingLoss = "Select a response";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Music Affect Data")),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: [
                    const Text(
                      "Additional Information",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: ageController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Age',
                          ),
                          validator: (value) {
                            if (value != null && int.tryParse(value) == null) {
                              return 'Please enter a valid age';
                            }
                            return null;
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: genderController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Gender'),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: locationController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Location',
                              hintText: 'The country you are from'),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: primaryLanguageController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Primary Language',
                              hintText: 'What is your primary language?'),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Listening Habits',
                          ),
                          value: habits,
                          items: const [
                            DropdownMenuItem(
                                value: "Many times a day",
                                child: Text("Many times a day")),
                            DropdownMenuItem(
                                value: "Once A day", child: Text("Once A day")),
                            DropdownMenuItem(
                                value: "Many Times a week",
                                child: Text("Many Times a week")),
                            DropdownMenuItem(
                                value: "Once a week",
                                child: Text("Once a week")),
                            DropdownMenuItem(
                                value: "Once a Month",
                                child: Text("Once a Month")),
                            DropdownMenuItem(
                              value: "Once a year",
                              child: Text("Once a year"),
                            ),
                            DropdownMenuItem(
                                value: "Select your listening habits",
                                child: Text("Select your listening habits")),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              habits = value!;
                            });
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Music Experience',
                          ),
                          value: experience,
                          items: const [
                            DropdownMenuItem(
                                value: "None", child: Text("None")),
                            DropdownMenuItem(
                                value: "Hobbyist", child: Text("Hobbyist")),
                            DropdownMenuItem(
                                value: "Professional",
                                child: Text("Professional")),
                            DropdownMenuItem(
                                value: "Select your music experience",
                                child: Text("Select your music experience")),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              experience = value!;
                            });
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Do you suffer from hearing loss',
                          ),
                          value: hearingLoss,
                          items: const [
                            DropdownMenuItem(value: "false", child: Text("No")),
                            DropdownMenuItem(value: "true", child: Text("Yes")),
                            DropdownMenuItem(
                                value: "Select a response",
                                child: Text("Select a response")),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              hearingLoss = value!;
                            });
                          },
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              widget.preferences
                                  .setBool('hasFilledOutPersonalData', true);

                              var url = Uri.https(
                                  'qzb9rm0k6c.execute-api.us-west-2.amazonaws.com',
                                  'test/resource');

                              await http.put(url,
                                  body: jsonEncode({
                                    "table": "users",
                                    "user_data": {
                                      "user_id": widget.uid,
                                      "age": int.parse(ageController.text),
                                      "gender": genderController.text,
                                      "location": locationController.text,
                                      "primary_language": primaryLanguageController.text,
                                      "listening_habits": listeningHabitsController.text,
                                      "music_experience": musicExperienceController.text,
                                      "hearing_loss": hearingLossController.text,
                                    }
                                  }));

                              widget.preferences.setBool(widget.uid, true);
                              widget.updateState();
                            },
                            child: const Text("Save")),
                        MaterialButton(
                            onPressed: () {
                                widget.preferences.setBool(widget.uid, false);
                                widget.updateState();
                            },
                            child: const Text("Skip")),
                      ],
                    )
                  ],
                ))));
  }
}
