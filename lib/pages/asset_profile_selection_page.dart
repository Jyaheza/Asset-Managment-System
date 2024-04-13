import 'package:flutter/material.dart';
import 'package:ocassetmanagement/view_models/create_asset_profile.dart';
import 'package:provider/provider.dart';

enum IconLabel {
   laptop(
    'Laptop',
    Icons.cloud_outlined,
  ),
  projector('Projector', Icons.sentiment_satisfied_outlined),
  brush('Brush', Icons.brush_outlined),
  heart('Heart', Icons.favorite);

  const IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}

class AssetProfileSelectionPage extends StatefulWidget {
  const AssetProfileSelectionPage({super.key, required this.callBack});
  final void Function(String?) callBack;

  @override
  State<AssetProfileSelectionPage> createState() =>
      _AssetProfileSelectionPageState();

      
}



class _AssetProfileSelectionPageState extends State<AssetProfileSelectionPage> {
  final TextEditingController colorController = TextEditingController();
  final TextEditingController iconController = TextEditingController();
  //ColorLabel? selectedColor;
  IconLabel? selectedIcon;

@override
void dispose() {
    // implement dispose
    final notifier = Provider.of<CreateAssetNotifier>(context, listen: false);
    notifier.completeProfileScreen();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          children: [
              SizedBox(
                      width: 100,
                      child: 
                      IconButton(onPressed: () {
                        dispose();
                      } , icon: const Icon(Icons.arrow_back))),

          ],
        ),
        Center(
          child: Column(
            children: [
              const SizedBox(height: 150,),
              const Text("Select a profile for new Asset(s)", style: TextStyle(fontSize: 20),),
              Card(
                child: SizedBox(
                  width: 400,
                  height: 300,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownMenu<IconLabel>(
                          controller: iconController,
                          enableFilter: true,
                          requestFocusOnTap: true,
                          width: 350,
                          leadingIcon: const Icon(Icons.search),
                          label: const Text('Select Profile...'),
                          inputDecorationTheme: const InputDecorationTheme(
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                          ),
                          onSelected: (IconLabel? icon) {
                            setState(() {
                              selectedIcon = icon;
                            });
                          },
                          dropdownMenuEntries:
                              IconLabel.values.map<DropdownMenuEntry<IconLabel>>(
                            (IconLabel icon) {
                              return DropdownMenuEntry<IconLabel>(
                                value: icon,
                                label: icon.label,
                                leadingIcon: Icon(icon.icon),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Spacer(),
                            TextButton(
                                onPressed: () {
                                  final notifier = Provider.of<CreateAssetNotifier>(context, listen: false);
                                  notifier.completeProfileSelectionScren(assetName: null);
                                  // widget.callBack(null);
                                },
                                child: const Text('Continue without profile')),
                            ElevatedButton(
                                onPressed: () {
                                  final notifier = Provider.of<CreateAssetNotifier>(context, listen: false);
                                  widget.callBack(selectedIcon?.label);
                                  notifier.completeProfileSelectionScren(assetName: selectedIcon?.label);
                                },
                                child: const Text('Continue'))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
