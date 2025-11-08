import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const QuoteApp());
}

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote Builder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
        useMaterial3: true,
      ),
      home: const QuoteFormPage(),
    );
  }
}

class QuoteFormPage extends StatefulWidget {
  const QuoteFormPage({super.key});

  @override
  State<QuoteFormPage> createState() => _QuoteFormPageState();
}

class _QuoteFormPageState extends State<QuoteFormPage> {
  final clientNameController = TextEditingController();
  final clientAddressController = TextEditingController();
  final clientRefController = TextEditingController();

  bool taxInclusive = false;
  String selectedCurrency = '₹';

  List<Map<String, dynamic>> lineItems = [
    {
      'name': '',
      'quantity': 1,
      'rate': 0.0,
      'discount': 0.0,
      'tax': 0.0,
      'total': 0.0,
    }
  ];

  double get subtotal =>
      lineItems.fold(0.0, (sum, item) => sum + (item['total'] as double));

  double get grandTotal => subtotal;

  void _calculateItemTotal(int index) {
    final item = lineItems[index];
    final rate = item['rate'] ?? 0.0;
    final quantity = item['quantity'] ?? 1;
    final discount = item['discount'] ?? 0.0;
    final tax = item['tax'] ?? 0.0;

    double base = (rate - discount) * quantity;

    double total = taxInclusive ? base : base + (base * tax / 100);

    setState(() {
      lineItems[index]['total'] = total;
    });
  }

  void _addNewItem() {
    setState(() {
      lineItems.add({
        'name': '',
        'quantity': 1,
        'rate': 0.0,
        'discount': 0.0,
        'tax': 0.0,
        'total': 0.0,
      });
    });
  }

  void _removeItem(int index) {
    if (lineItems.length == 1) return;
    setState(() {
      lineItems.removeAt(index);
    });
  }

  void _openPreview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuotePreviewPage(
          clientName: clientNameController.text,
          clientAddress: clientAddressController.text,
          clientRef: clientRefController.text,
          items: lineItems,
          subtotal: subtotal,
          grandTotal: grandTotal,
          currency: selectedCurrency,
          taxInclusive: taxInclusive,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_IN', symbol: selectedCurrency);

    return Scaffold(
      appBar: AppBar(title: const Text("Quote Builder")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Client Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: clientNameController,
              decoration: const InputDecoration(labelText: "Client Name"),
            ),
            TextField(
              controller: clientAddressController,
              decoration: const InputDecoration(labelText: "Address"),
            ),
            TextField(
              controller: clientRefController,
              decoration: const InputDecoration(labelText: "Reference"),
            ),
            const SizedBox(height: 16),

            // ⚙️ Currency & Tax Options
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCurrency,
                    decoration: const InputDecoration(labelText: "Currency"),
                    items: const [
                      DropdownMenuItem(value: '₹', child: Text('INR (₹)')),
                      DropdownMenuItem(value: '\$', child: Text('USD (\$)')),
                      DropdownMenuItem(value: '€', child: Text('EUR (€)')),
                    ],
                    onChanged: (value) {
                      setState(() => selectedCurrency = value!);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SwitchListTile(
                    title: const Text("Tax Inclusive"),
                    value: taxInclusive,
                    onChanged: (val) {
                      setState(() {
                        taxInclusive = val;
                        for (int i = 0; i < lineItems.length; i++) {
                          _calculateItemTotal(i);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Text("Line Items",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lineItems.length,
              itemBuilder: (context, index) {
                final item = lineItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        TextField(
                          decoration:
                              const InputDecoration(labelText: "Product/Service"),
                          onChanged: (v) {
                            item['name'] = v;
                            setState(() {});
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(labelText: "Quantity"),
                                onChanged: (v) {
                                  item['quantity'] = int.tryParse(v) ?? 1;
                                  _calculateItemTotal(index);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(labelText: "Rate"),
                                onChanged: (v) {
                                  item['rate'] = double.tryParse(v) ?? 0.0;
                                  _calculateItemTotal(index);
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: "Discount"),
                                onChanged: (v) {
                                  item['discount'] = double.tryParse(v) ?? 0.0;
                                  _calculateItemTotal(index);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(labelText: "Tax %"),
                                onChanged: (v) {
                                  item['tax'] = double.tryParse(v) ?? 0.0;
                                  _calculateItemTotal(index);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Item Total: ${currencyFormatter.format(item['total'])}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeItem(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),
            Center(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Item"),
                onPressed: _addNewItem,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),

            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Subtotal: ${currencyFormatter.format(subtotal)}"),
                  Text("Grand Total: ${currencyFormatter.format(grandTotal)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Preview & Print Quote"),
                onPressed: _openPreview,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuotePreviewPage extends StatelessWidget {
  final String clientName;
  final String clientAddress;
  final String clientRef;
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final double grandTotal;
  final String currency;
  final bool taxInclusive;

  const QuotePreviewPage({
    super.key,
    required this.clientName,
    required this.clientAddress,
    required this.clientRef,
    required this.items,
    required this.subtotal,
    required this.grandTotal,
    required this.currency,
    required this.taxInclusive,
  });

  Future<pw.Document> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    final formatter = NumberFormat.currency(symbol: currency, locale: 'en_IN');

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('QUOTE RECEIPT',
                    style: pw.TextStyle(
                        fontSize: 22, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text('Client: $clientName'),
                pw.Text('Address: $clientAddress'),
                pw.Text('Reference: $clientRef'),
                pw.SizedBox(height: 10),
                pw.Text('Tax Mode: ${taxInclusive ? "Inclusive" : "Exclusive"}'),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: ['Product', 'Qty', 'Rate', 'Discount', 'Tax %', 'Total'],
                  data: items.map((e) {
                    return [
                      e['name'],
                      e['quantity'].toString(),
                      e['rate'].toString(),
                      e['discount'].toString(),
                      e['tax'].toString(),
                      formatter.format(e['total']),
                    ];
                  }).toList(),
                ),
                pw.SizedBox(height: 20),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Subtotal: ${formatter.format(subtotal)}'),
                      pw.Text('Grand Total: ${formatter.format(grandTotal)}',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quote Preview")),
      body: PdfPreview(
        build: (format) => _generatePdf(format).then((pdf) => pdf.save()),
        allowPrinting: true,
        allowSharing: true,
      ),
    );
  }
}
