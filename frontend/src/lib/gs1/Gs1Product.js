class Gs1Product {
  constructor({
    lot,
    gtin,
    manufactureDate,
    expiryDate,
  }) {
    this.lot = lot;
    this.gtin = gtin.substring(1); // Drops the first character

    this.manufactureDate = `20${manufactureDate}`;
    this.expiryDate = `20${expiryDate}`;
  }

  toString() {
    return {
      lot: this.lot,
      gtin: this.gtin,
      manufactureDate: this.manufactureDate,
      expiryDate: this.expiryDate,
    };
  }
}

export default Gs1Product;
