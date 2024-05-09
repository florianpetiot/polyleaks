import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PageAPropos extends StatelessWidget {
  const PageAPropos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aPropos0),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.aPropos1,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.aPropos2,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.aPropos3,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.aPropos4,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.aPropos5,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.aPropos6,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.aPropos7,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}