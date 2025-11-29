import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:here4u/mvvm/ui/view_model/emergency_view_model.dart';
import 'package:here4u/core/services/network_service.dart';
import 'package:here4u/mvvm/ui/widgets/buttons/rounded_button.dart';

class EmergencyView extends StatefulWidget {
  const EmergencyView({super.key});

  @override
  State<EmergencyView> createState() => _EmergencyViewState();
}

class _EmergencyViewState extends State<EmergencyView> {
  @override
  void initState() {
    super.initState();
    debugPrint("[EmergencyView] logging screen view");
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'EmergencyView',
      screenClass: 'EmergencyView',
    );
    // Start engagement timer in the ViewModel once the view is mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        // Use read here to avoid subscribing the whole State to changes.
        context.read<EmergencyViewModel>().startEngagementTimer();
      } catch (_) {
        // Provider may not be available in some test scenarios; ignore.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use `read` when we don't want the entire widget to rebuild on model changes.
    final vm = context.read<EmergencyViewModel>();

    return WillPopScope(
      onWillPop: () async {
        // Log engagement when the system back is pressed.
        await context.read<EmergencyViewModel>().logEngagement('EmergencyView');
        return true; // allow pop
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Emergency Contacts",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 24),

                    // Contact area: show spinner while loading, then contacts.
                    Selector<EmergencyViewModel, bool>(
                      selector: (_, vm) => vm.isLoading,
                      builder: (context, isLoading, _) {
                        if (isLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        // When not loading, render contacts (rebuild only when
                        // contacts change).
                        return Selector<EmergencyViewModel, List<dynamic>>(
                          selector: (_, model) => model.contacts,
                          builder: (context, contacts, _) {
                            if (contacts.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 40),
                                child: Text(
                                  "There are no contacts.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              );
                            }

                            return Wrap(
                              spacing: 28,
                              runSpacing: 20,
                              alignment: WrapAlignment.center,
                              children: contacts.map((c) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        customBorder: const CircleBorder(),
                                        onTap: () => vm.onTapContact(context, c.name),
                                        child: Ink(
                                          width: 96,
                                          height: 96,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF86D9F0),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.person,
                                            size: 44,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      c.name,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    // Add contact
                    RoundedButton(
                      text: "Add Contact",
                      color: const Color(0xFF8CC0CF),
                      textColor: Colors.black,
                      onPressed: () => vm.startAddContactFlow(context),
                      icon: Icons.add,
                      width: 200,
                    ),

                    const SizedBox(height: 16),

                    // Notify All button (mirrors Login/SignOut behavior)
                    Selector<NetworkService, bool>(
                      selector: (_, ns) => ns.isOnline,
                      builder: (context, isOnline, _) {
                        return RoundedButton(
                          text: isOnline ? 'Notify All' : 'Offline',
                          color: isOnline ? const Color(0xFFFFDBD2) : Colors.grey,
                          textColor: Colors.black,
                          onPressed: isOnline ? () => vm.notifyAllContacts(context) : null,
                          icon: Icons.notifications_active,
                          width: 200,
                        );
                      },
                    ),

                    const SizedBox(height: 32),
                    Text(
                      "Stay calm breath deeply",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    RoundedButton(
                      text: "Back",
                      onPressed: () => vm.goBack(context),
                      color: const Color(0xFF86D9F0),
                      icon: Icons.arrow_back,
                      width: 200,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
