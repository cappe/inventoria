/* eslint no-multi-spaces: off */

import gs1js from 'gs1js';
import Gs1Product from './Gs1Product';

class Gs1Parser {
  /** Product variables  */
  static GTIN_IDENTIFIER              = '01';
  static LOT_NUMBER                   = '10';
  static MANUFACTURE_DATE             = '11';
  static EXPIRY_DATE                  = '17';

  /** Error messages */
  static ERROR_GENERAL                = 'Jotakin meni pieleen';
  static ERROR_INVALID_BARCODE        = 'Tuotekoodi on virheellinen';
  static ERROR_IDENTIFIER_MISMATCH    = 'Onko tämä tuotekoodi GS1-standardin mukainen?';

  constructor(barcode) {
    this.parser = new gs1js.GS1Reader(barcode);
  }

  createGs1Product() {
    const ais = this.parser.getApplicationIdentifiers();

    const gs1ProductParams = ais.reduce((params, ai) => {
      switch (ai.identifier) {
        case Gs1Parser.GTIN_IDENTIFIER:
          Object.assign(params, { gtin: ai.value });
          break;

        case Gs1Parser.LOT_NUMBER:
          Object.assign(params, { lot: ai.value });
          break;

        case Gs1Parser.MANUFACTURE_DATE:
          Object.assign(params, { manufactureDate: ai.value });
          break;

        case Gs1Parser.EXPIRY_DATE:
          Object.assign(params, { expiryDate: ai.value });
          break;

        default:
          throw new Error(Gs1Parser.ERROR_IDENTIFIER_MISMATCH);
      }

      return params;
    }, {});

    const gs1Product = new Gs1Product(gs1ProductParams);

    return gs1Product;
  }

  static createProductFromBarode(barcode) {
    if (typeof barcode !== 'string' || barcode.length <= 0) {
      throw new Error(Gs1Parser.ERROR_INVALID_BARCODE);
    }

    const gs1Parser = new Gs1Parser(barcode);
    const gs1Product = gs1Parser.createGs1Product();

    return gs1Product;
  }
}

export default Gs1Parser;
