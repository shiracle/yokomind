import 'package:flutter/material.dart';
import 'package:yoko_mind/api/api.dart';
import 'package:yoko_mind/screens/public/payment/payment_bank.dart.dart';
import 'package:yoko_mind/theme/color.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  @override
  void initState() {
    super.initState();
    fetchInvoices();
  }

  Map invoiceData = {};
  Future<void> fetchCreatedInvoice() async {
    Map invoice = await SendRequests.createInvoice();
    if (invoice.isNotEmpty) {
      setState(() {
        invoiceData = invoice;
      });
    }
  }

  Future<void> fetchInvoices() async {
    Map invoice = await SendRequests.queryInvoices();
    if (invoice.isNotEmpty) {
      if (invoice["status"] == "PENDING") {
        setState(() {
          invoiceData = invoice;
        });
      } else {
        fetchCreatedInvoice();
      }
    } else {
      fetchCreatedInvoice();
    }
  }

  @override
  Widget build(BuildContext context) {
    return invoiceData.isNotEmpty
        ? PaymentBankList(
            invoice: invoiceData['invoicedeeplinkSet'],
            invoiceId: invoiceData['id'],
            invoiceQr: invoiceData['qpayQrImage'],
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColor.outLine,
              ),
            ),
          );
  }
}
