import 'library.dart';
import '../modules/my_agent/controllers/my_agent_controller.dart';

class DropdownTile extends StatelessWidget {
  final String title;
  final RxList<String> items;
  final MyAgentController controller;

  const DropdownTile({
    super.key,
    required this.title,
    required this.items,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 4,
      child: ExpansionTile(
        title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide.none,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide.none,
        ),
        childrenPadding: const EdgeInsets.only(bottom: 8),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        children: items
            .map(
              (item) => Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => controller.addItem(item),
              child: Text(item,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white)),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}
