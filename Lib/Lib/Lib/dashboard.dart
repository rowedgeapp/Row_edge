import 'package:flutter/material.dart';
import 'db.dart';

class NewTicketScreen extends StatefulWidget {
  const NewTicketScreen({super.key});

  @override
  State<NewTicketScreen> createState() => _NewTicketScreenState();
}

class _NewTicketScreenState extends State<NewTicketScreen> {
  final _nameCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();

  String phoneType = 'Android';
  int price = 300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Ticket')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField(
              value: phoneType,
              items: const [
                DropdownMenuItem(value: 'Android', child: Text('Android')),
                DropdownMenuItem(value: 'iPhone', child: Text('iPhone')),
                DropdownMenuItem(value: 'Power Bank', child: Text('Power Bank')),
              ],
              onChanged: (v) => setState(() => phoneType = v!),
              decoration: const InputDecoration(labelText: 'Phone Type'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price (₦)'),
              initialValue: '300',
              onChanged: (v) => price = int.tryParse(v) ?? 300,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Customer Name (optional)',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _modelCtrl,
              decoration: const InputDecoration(
                labelText: 'Phone Model (optional)',
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveTicket,
              child: const Text('Print Ticket'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _saveTicket() async {
    final ticketNo = await DB.nextTicketNumber();

    await DB.insertTicket(
      ticketNumber: ticketNo,
      phoneType: phoneType,
      price: price,
      customerName: _nameCtrl.text,
      phoneModel: _modelCtrl.text,
    );

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ticket Created'),
        content: Text('Ticket Number: $ticketNo'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}
