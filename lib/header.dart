class Header {
  static get header => {
        'content-type': 'application/json',
        'Access-Control-Allow-Origin': "*",
        'Access-Control-Allow-Headers': "Content-Type",
        'Referrer-Policy': "no-referrer-when-downgrade"
      };
}
