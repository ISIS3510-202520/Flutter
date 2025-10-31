import 'package:flutter/material.dart';
import 'package:here4u/mvvm/ui/view/journaling/journal_detail_view.dart';
import 'package:provider/provider.dart';
import 'package:here4u/mvvm/ui/view_model/journal_list_view_model.dart';
import 'package:here4u/mvvm/ui/view_model/auth_view_model.dart';

class JournalListView extends StatelessWidget {
  const JournalListView({super.key});

  static Widget route() {
    return Builder(
      builder: (context) {
        final authVm = context.read<AuthViewModel>();
        final userId = authVm.userEntity?.id ?? 'me';

        return ChangeNotifierProvider(
          create: (_) => JournalListViewModel(userId: userId),
          child: const JournalListView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JournalListViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Your Journals")),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
              ? Center(child: Text(vm.errorMessage!))
              : ListView.builder(
                  itemCount: vm.journals.length,
                  itemBuilder: (context, index) {
                    final journal = vm.journals[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(journal.createdAt.toLocal().toString()),
                        subtitle: Text(
                          vm.formatDate(journal.createdAt),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JournalDetailView(journal: journal),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
