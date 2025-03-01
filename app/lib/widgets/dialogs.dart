import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:profit_taker_analyzer/utils/utils.dart';

import 'package:window_manager/window_manager.dart';

/// Displays an error dialog to the user.
///
/// This method creates an AlertDialog with a title indicating that there was an error closing the parser.
/// The content of the dialog tells the user to try again. The dialog has two action buttons: 'FORCE QUIT' and 'Okay'.
///
/// Clicking the 'FORCE QUIT' button closes the dialog and forces the destruction of the window.
/// Clicking the 'Okay' button simply closes the dialog.
///
/// The method uses the `showDialog` function to display the AlertDialog. The `showDialog` function
/// requires a context and a builder function.
/// The builder function returns the AlertDialog to be displayed.
void showErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
          title: const Text('There was an error closing parser.'),
          content: const Text('Please try again.'),
          actions: [
            TextButton(
                child: Text('FORCE QUIT',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await windowManager.destroy();
                }),
            TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ]);
    },
  );
}

/// Displays a connection error dialog when the app fails to connect to the parser.
///
/// This function shows a dialog with a title of "Error!" and content advising the user
/// to restart the program. If the problem persists, they are instructed to contact Basi.
/// The user can close the dialog by pressing the "OK" button.
void showParserConnectionErrorDialog(
    BuildContext context, String errorText, String errorTitle) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(errorText),
            content: Text(errorTitle),
            actions: <Widget>[
              TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ]);
      });
}

/// Shows a dialog warning about a bugged run.
///
/// This method displays a dialog with a warning message about a bugged run.
///
/// Parameters:
///   - context: The build context.
///   - errorText: The text content of the dialog.
///   - errorTitle: The title of the dialog.
void showBuggedRunWarningDialog(
    BuildContext context, String errorText, String errorTitle) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(errorText),
            content: Text(errorTitle),
            actions: <Widget>[
              TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ]);
      });
}

/// Displays an about dialog with information about the app.
///
/// This function shows a dialog with a title of "About", and a small easter egg.
/// The user can close the dialog by pressing the "OK" button.
void showAboutAppDialog(
    BuildContext context, String aboutTitle, String aboutDescription) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(aboutTitle),
        content: Text(aboutDescription),
        actions: <Widget>[
          TextButton(
            child: Text(FlutterI18n.translate(context, "buttons.ok")),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

/// Displays a contacts dialog with information about how to contact Basi.
///
/// This function shows a dialog with a title of "Contact Basi", and content describing
/// the author of the app and instructions for contacting. The user can close the
/// dialog by pressing the "OK" button.
void showContactsAppDialog(
    BuildContext context, String contactText, String description) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(contactText),
        content: Text(description),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

/// Displays a dialog with information about donating to Basi.
///
/// This function shows a dialog with a title of "Donations", and content describing
/// the author of the app and reasonings for donations. The user can close the
/// dialog by pressing the "OK" button.
void showDonationDialog(BuildContext context, String title, String main,
    String donatePaypalButton, String okayText) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(main),
        actions: <Widget>[
          TextButton(
            child: Text(donatePaypalButton),
            onPressed: () {
              launchURL("https://www.paypal.com/paypalme/basigraphics");
            },
          ),
          TextButton(
            child: Text(okayText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

/// Displays a text input dialog.
///
/// This method shows a dialog with a text input field, allowing the user to enter a new name.
/// When the user confirms the input, the [updateCallback] function is called with the new name
/// and the file name.
///
/// Parameters:
///   - context: The build context.
///   - controller: The text editing controller for the input field.
///   - fileName: The name of the file associated with the input.
///   - hintText: The hint text displayed in the input field.
///   - changeFileNameText: The title of the dialog.
///   - cancelText: The text for the cancel button.
///   - okText: The text for the confirm button.
///   - updateCallback: The callback function to be called after updating the name.
///
/// Returns: A future that completes when the dialog is closed.
Future<void> displayTextInputDialog(
    BuildContext context,
    TextEditingController controller,
    String fileName,
    String hintText,
    String changeFileNameText,
    String cancelText,
    String okText,
    List<String> existingNames,
    Function updateCallback) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(changeFileNameText),
        content: TextField(
          controller: controller,
          maxLength: 14,
          maxLengthEnforcement:
              MaxLengthEnforcement.truncateAfterCompositionEnds,
          decoration: InputDecoration(hintText: hintText),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(cancelText),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(okText),
            onPressed: () {
              var newName = controller.text;
              if (existingNames.contains(newName)) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title:
                          Text(FlutterI18n.translate(context, 'errors.error')),
                      content: Text(FlutterI18n.translate(
                          context, 'errors.existing_name')),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                              FlutterI18n.translate(context, 'buttons.ok')),
                          onPressed: () {
                            Navigator.pop(context); // Close the error dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                updateRunName(newName, fileName).then((_) {
                  updateCallback(newName, fileName);
                  if (!context.mounted) {
                    return;
                  }
                  Navigator.pop(context);
                  controller.clear();
                });
              }
            },
          ),
        ],
      );
    },
  );
}

/// Shows a confirmation dialog.
///
/// This method displays a dialog with a confirmation message and two buttons: one for canceling
/// the action and the other for confirming the action. Returns a future that completes with a boolean
/// value indicating whether the action was confirmed or canceled.
///
/// Parameters:
///   - context: The build context.
///   - title: The title of the dialog.
///   - confirmation: The confirmation message.
///   - cancelButton: The text for the cancel button.
///   - deleteButton: The text for the delete button.
///
/// Returns: A future that completes with a boolean value indicating whether the action was confirmed.
Future<bool> showConfirmationDialog(BuildContext context, String title,
    String confirmation, String cancelButton, String deleteButton) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(confirmation),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(cancelButton),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(deleteButton,
                    style: const TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      ) ??
      false;
}

/// Updates the name of a run in the corresponding JSON file.
///
/// This method updates the name of a run in the JSON file associated with the given [fileName].
///
/// Parameters:
///   - newName: The new name to be set.
///   - fileName: The name of the JSON file to be updated.
///
/// Returns: A future that completes when the update is done.
Future<void> updateRunName(String newName, String fileName) async {
  // Define the path to the JSON file
  var mainPath = Platform.resolvedExecutable;
  mainPath = mainPath.substring(0, mainPath.lastIndexOf("\\"));
  var storagePath = "$mainPath\\storage\\$fileName.json";

  // Load the JSON file
  final File jsonFile = File(storagePath);
  final String jsonString = await jsonFile.readAsString();

  // Parse the JSON string into a Dart Map
  final Map<String, dynamic> jsonData = jsonDecode(jsonString);

  // Update the value of the "pretty_name" key
  jsonData['pretty_name'] = newName;

  // Convert the updated Map back into a JSON string
  final String updatedJsonString = jsonEncode(jsonData);

  // Write the updated JSON string back to the file
  await jsonFile.writeAsString(updatedJsonString);

  // Update the variable
  // customRunName = newName;
}
