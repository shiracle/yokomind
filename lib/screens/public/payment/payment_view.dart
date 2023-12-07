import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:yoko_mind/screens/public/payment/payment_bank.dart.dart';
import 'package:yoko_mind/screens/public/payment/payment_ql.dart';

class PaymentView extends HookWidget {
  final String type;
  final Map user;
  const PaymentView({super.key, required this.type, required this.user});

  @override
  Widget build(BuildContext context) {
    final invoiceData = useState({});
    final mutation = useMutation(
      MutationOptions(
        document: gql(PaymentGraphQL.createInvoice),
        fetchPolicy: FetchPolicy.noCache,
        onCompleted: (data) {
          if (data != null) {
            invoiceData.value = data['createInvoice']['invoice'];
          }
        },
      ),
    );
    return Query(
      options: QueryOptions(
        document: gql(PaymentGraphQL.queryInvoce),
        fetchPolicy: FetchPolicy.noCache,
        onComplete: (data) {
          if (data['invoiceByUser'] != null) {
            invoiceData.value = data['invoiceByUser'];
          } else {
            mutation.runMutation({});
          }
        },
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.hasException) {
          return Scaffold(
            body: SafeArea(
              child: Text(
                result.exception.toString(),
              ),
            ),
          );
        }

        if (result.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (invoiceData.value.isNotEmpty) {
          return PaymentBankList(
            invoice: invoiceData.value['invoiceStockSet'],
            invoiceId: invoiceData.value['id'],
            invoiceQr: invoiceData.value['qpayQrImage'],
            userData: {"type": type, "user": user},
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
