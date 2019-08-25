class Gs1Product {
  constructor({
    lot,
    gtin,
    manufactureDate,
    expiryDate,
    datamatrix,
  }) {
    this.lot = lot;
    this.gtin = gtin;
    this.datamatrix = datamatrix;

    this.manufactureDate = `20${manufactureDate}`;
    this.expiryDate = `20${expiryDate}`;
  }

  toString() {
    return {
      lot: this.lot,
      gtin: this.gtin,
      manufactureDate: this.manufactureDate,
      expiryDate: this.expiryDate,
      datamatrix: this.datamatrix,
    };
  }
}

export default Gs1Product;
