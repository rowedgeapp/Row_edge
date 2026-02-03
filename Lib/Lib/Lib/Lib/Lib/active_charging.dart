import 'package:flutter/material.dart';
import 'db.dart';

class ActiveChargingScreen extends StatefulWidget {
  const ActiveChargingScreen({super.key});

  @override
  State<ActiveChargingScreen> createState() => _ActiveChargingScreenState();
}

class _ActiveChargingScreenState extends State<ActiveChargingScreen> {
  List<Map<String, dynamic>> tickets = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    tickets = await DB.activeTickets();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active Charging')),
      body: tickets.isEmpty
          ? const Center(child: Text('No active tickets'))
          : ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (_, i) {
                final t = tickets[i];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${t['ticketNumber']}'),
                  ),
                  title: Text('${t['phoneType']} - ₦${t['price']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.check_circle),
                    onPressed: () async {
                      await DB.completeTicket(t['id']);
                      _load();
                    },
                  ),
                );
              },
            ),
    );
  }
}
