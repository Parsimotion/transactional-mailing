'use strict'

app.factory 'OrderSample', ->
  tags: ["tag1", "tag2"]
  integrations: [ {
    integrationId: 970353805
    app: 'Meli'
  } ]
  channel: 'Meli'
  contact:
    name: 'Nombre del Contacto'
    contactPerson: 'Nombre y Apellido'
    mail: 'account@server.com'
    phoneNumber: '0123-5555-1234'
    taxId: '20999999996'
    location:
      streetName: 'Calle False'
      streetNumber: '123'
      addressNotes: '1º B'
      state: 'Estado'
      city: 'Ciudad'
      zipCode: '4400'
    notes: 'Notas de usuario'
    type: 'Customer'
    priceList: null
    profile:
      app: 'Meli'
      integrationId: 42214211
    id: 575096
  lines: [ {
    price: 279
    product:
      description: 'Descripción Producto'
      sku: 'AA001122'
      id: 97
    variation:
      primaryColor: 'Blanco'
      secondaryColor: 'Rojo'
      size: '35'
      id: 892880
      barcode: '1234567890123'
    quantity: 1
    conversation: questions: [
      {
        id: 357079
        text: 'Primer pregunta del comprador'
        answer: 'Primer respuesta del vendedor. Saludos cordiales'
      }
      {
        id: 357080
        text: 'Segunda pregunta del comprador'
        answer: 'Segunda respuesta del vendedor. Saludos cordiales'
      }
    ]
  } ]
  isOpen: true
  isCanceled: false
  warehouse: 'Deposito'
  payments: [ {
    date: '2015-07-06T00:11:45'
    amount: 373.99
    method: 'MercadoPago'
    integration:
      integrationId: 1242735781
      app: 'Meli'
    notes: 'Notas del pago'
    id: 531233
  } ]
  shipments: [ {
    date: '2015-07-06T00:11:39'
    products: [ {
      product: 97
      variation: 892880
      quantity: 1
    } ]
    method:
      trackingNumber: '3867500000009243156'
      status: 'PickingPending'
    integration:
      app: 'Meli'
      integrationId: 21436070570
      id: 170728
    id: 377201
  } ]
  amount: 373.99
  shippingCost: 94.99
  paymentStatus: 'Done'
  deliveryStatus: 'PickingPending'
  paymentFulfillmentStatus: 'Done'
  deliveryFulfillmentStatus: 'Pending'
  deliveryMethod: 'Ship'
  paymentTerm: 'Advance'
  customId: null
  date: '2015-07-06T00:08:30'
  notes: 'Notas del pedido'
  id: 810125
