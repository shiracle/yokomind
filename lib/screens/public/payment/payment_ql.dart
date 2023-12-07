class PaymentGraphQL {
  static const createInvoice =
      '''
    mutation{
      createInvoice{
        invoice{
          id
          qpayQrImage
          invoiceStockSet{
            name
            description
            logo
            link
          }
        }
      }
    }
  ''';
  static const queryInvoce =
      '''
    query{
      invoiceByStudent{
        id
        qpayQrText
        qpayQrImage
        status
        invoiceStockSet{
          name
          description
          logo
          link
        }
      }
    }
  ''';

  static const statusCheck =
      """
        query checkInvoiceStatus (\$id: Int!) {
            checkInvoiceStatus (id: \$id)
        }
      """;
}
