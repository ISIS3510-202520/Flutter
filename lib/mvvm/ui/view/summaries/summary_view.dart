import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:here4u/mvvm/ui/view_model/summary_view_model.dart';
import 'package:here4u/mvvm/ui/widgets/buttons/rounded_button.dart';

class SummaryView extends StatelessWidget {
  const SummaryView({super.key});

  /// Úsalo al navegar: Navigator.push(context, MaterialPageRoute(builder: (_) => SummaryView.route()));
  static Widget route() {
    return ChangeNotifierProvider(
      create: (_) => SummaryViewModel()..init(),
      child: const SummaryView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SummaryViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth;
            final buttonW = maxW * 0.70 > 360 ? 360.0 : maxW * 0.70;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título
                  Text(
                    'Summaries',
                    textAlign: TextAlign.center,
                    style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),

                  // Contenido central
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Bloque: sentimiento más común
                            Text(
                              '[${vm.commonFeeling}] you highlighted:\n${vm.highlights}',
                              textAlign: TextAlign.center,
                              style: textTheme.headlineMedium?.copyWith(height: 1.25),
                            ),
                            const SizedBox(height: 28),

                            // Bloque: insights recomendados
                            Text(
                              'Your recommended insights are:\n${vm.insights}',
                              textAlign: TextAlign.center,
                              style: textTheme.headlineMedium?.copyWith(height: 1.25),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Botón Back
                  Center(
                    child: SizedBox(
                      width: buttonW,
                      child: RoundedButton(
                        text: "Back",
                        onPressed: () => vm.onTapBack(context),
                        isBold: false,
                        color: const Color(0xFF8EDAF0), // azul claro del mock
                        textColor: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
