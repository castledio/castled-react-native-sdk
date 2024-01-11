class CastledUserAttributes {
  static readonly FIRST_NAME = 'first_name';
  static readonly LAST_NAME = 'last_name';
  static readonly EMAIL = 'email';
  static readonly NAME = 'name';
  static readonly DOB = 'date_of_birth';
  static readonly GENDER = 'gender';
  static readonly PHONE_NUMBER = 'phone_number';
  static readonly CITY = 'city';
  static readonly COUNTRY = 'country';

  // TypeScript Map to store attributes
  private attributes = new Map<string, any>();

  setName(name: string) {
    this.attributes.set(CastledUserAttributes.NAME, name);
  }

  setFirstName(firstName: string) {
    this.attributes.set(CastledUserAttributes.FIRST_NAME, firstName);
  }

  setLastName(lastName: string) {
    this.attributes.set(CastledUserAttributes.LAST_NAME, lastName);
  }

  setEmail(email: string) {
    this.attributes.set(CastledUserAttributes.EMAIL, email);
  }

  setDOB(dob: Date) {
    this.attributes.set(CastledUserAttributes.DOB, dob);
  }

  setGender(gender: string) {
    this.attributes.set(CastledUserAttributes.GENDER, gender);
  }

  setPhone(phone: string) {
    this.attributes.set(CastledUserAttributes.PHONE_NUMBER, phone);
  }

  setCity(city: string) {
    this.attributes.set(CastledUserAttributes.CITY, city);
  }

  setCountry(country: string) {
    this.attributes.set(CastledUserAttributes.COUNTRY, country);
  }

  setCustomAttribute(key: string, value: any) {
    this.attributes.set(key, value);
  }

  getAttributes(): Map<string, any> {
    return this.attributes;
  }
}

export default CastledUserAttributes;
