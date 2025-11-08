# 🧾 Flutter Quote Builder

A Flutter app to create, preview, and download professional quotes or invoices with auto-calculations, tax handling, and responsive design.

---

## 🚀 Features

✅ **Quote Form UI**

* Input client info (Name, Address, Reference)
* Add multiple line items (Product/Service, Quantity, Rate, Discount, Tax %)
* Add or remove rows dynamically

✅ **Auto Calculations**

* Per-item total: `((rate - discount) * quantity) + tax`
* Quote subtotal and grand total update automatically

✅ **Responsive Layout**

* Works seamlessly on mobile, tablet, and web

✅ **Preview & PDF Download**

* Instant on-screen quote preview
* Download professional-looking **PDF invoice/quote** with one click
* Includes date, client details, and itemized breakdown

✅ **Optional Add-ons**

* Save quotes locally
* Toggle tax-inclusive / exclusive mode
* Currency formatting
* Quote status tracking (Draft, Sent, Accepted)

---

## 🧩 Tech Stack

* **Flutter 3.19+**
* **Dart**
* **PDF** & **Printing** packages for PDF generation
* **Intl** for currency/date formatting
* **Shared Preferences** for local storage

---

## ⚙️ Installation

```bash
git clone https://github.com/kanish-dev/flutter_quote_builder.git
cd flutter_quote_builder
flutter pub get
flutter run
```

---

## 📸 Screenshots

| Quote Form                           | Quote Preview                                    | PDF Download                                |
| ------------------------------------ | ------------------------------------------------ | ------------------------------------------- |
| ![Form](https://github.com/kanish-dev/flutter_quote_builder/blob/main/screenshot/home%20page.png) | ![Preview](https://github.com/kanish-dev/flutter_quote_builder/blob/main/screenshot/line%20items1.png) | ![PDF](https://github.com/kanish-dev/flutter_quote_builder/blob/main/screenshot/document%20recipt%20.pdf) |

---

## 💡 Future Enhancements

* Cloud sync for saved quotes
* Email or WhatsApp PDF directly
* Add company logo and digital signature

---

## 👨‍💻 Author

**Kanishka R Reddy**
📍 Karnataka, India
🔗 [LinkedIn](https://linkedin.com/in/kanish7) | [GitHub](https://github.com/kanish-dev)


### Home Screen
![Home Screen](https://github.com/kanish-dev/flutter_quote_builder/blob/main/screenshot/home%20page.png)

### Quote Preview
![Quote Preview](https://github.com/kanish-dev/flutter_quote_builder/blob/main/screenshot/line%20items1.png)

![Quote Preview](https://github.com/kanish-dev/flutter_quote_builder/blob/main/screenshot/line%20items%202.png)
### Receipt Example
![Receipt](https://github.com/kanish-dev/flutter_quote_builder/blob/main/screenshot/saving%20as%20pdf%20.png)
