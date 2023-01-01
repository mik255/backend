class Header {
  static get header => {
        'content-type': 'application/json',
        'Access-Control-Allow-Origin': "*",
        'Access-Control-Allow-Headers': "Origin, X-Requested-With, Content-Type, Accept",
        'Referrer-Policy': "no-referrer-when-downgrade",
        "Access-Control-Allow-Methods": "GET,PUT,PATCH,POST,DELETE"
      };
}
