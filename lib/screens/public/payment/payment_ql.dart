class PaymentGraphQL {
  static const createInvoice = '''
        mutation {
          createInvoice {
            invoice {
              id
              qpayQrImage
              invoicedeeplinkSet {
                name
                logo
                link
              }
            }
          }
        }
      ''';
  static const queryInvoce = '''
    query {
      myInvoice {
        id
        qpayQrText
        qpayQrImage
        status
        invoicedeeplinkSet {
          name
          logo
          link
        }
      }
    }
  ''';

  static const statusCheck = """
    query (\$invoice: ID!){
      checkInvoiceStatus (invoice: \$invoice)
    }
  """;
}
