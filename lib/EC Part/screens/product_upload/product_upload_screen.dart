import 'dart:io';
import 'package:agro_plus_app/EC%20Part/provider/product_provider.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_upload/form_handler.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_product_list.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductUploadScreen extends StatefulWidget {
  static String routeName = '/upload_product';
  final String sellerId;

  ProductUploadScreen({required this.sellerId});

  @override
  State<ProductUploadScreen> createState() => _ProductUploadScreenState();
}

class _ProductUploadScreenState extends State<ProductUploadScreen> {
  Future<void> checkTaxAndDelivery() async {
    try {
      // Retrieve initial values directly from Firestore
      final DocumentSnapshot sellerSnapshot = await FirebaseFirestore.instance
          .collection('seller')
          .doc(widget.sellerId)
          .get();

      if (sellerSnapshot.exists) {
        final data = sellerSnapshot.data() as Map<String, dynamic>;

        if (!data.containsKey('tax') || !data.containsKey('deliveryFee')) {
          // Show a dialog to prompt the seller to fill in tax and deliveryFee
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Tax and Delivery Fee Setup'),
                content: const Text(
                    'It seems you haven\'t set up tax and delivery fee. Please fill in before starting upload product.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      // Navigate to SellerSettingScreen
                      Navigator.pushNamed(
                        context,
                        SellerSettingScreen.routeName,
                        arguments: widget.sellerId,
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (error) {
      // Handle errors
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch initial values when the widget is initialized
    checkTaxAndDelivery();
  }

  DateTime datepicked = DateTime.now();
  TimeOfDay timepicked = TimeOfDay.now();

  late final formHandler = FormHandler(
      ProductProvider(sellerId: widget.sellerId),
      isEditMode: false);

  //function/logic to handle the form submission
  void submitForm() async {
    final bool uploadStatus =
        await formHandler.submitForm(context, widget.sellerId);

    //if product is added successfully
    if (uploadStatus) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product is added successfully.'),
        ),
      );
      //navigate back to seller dashboard
      //Navigator.pop(context, true);

      //navigate to seller product listing screen
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, SellerProductListScreen.routeName,
          arguments: widget.sellerId);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form data is not valid.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color.fromARGB(255, 56, 38, 106),
        elevation: 5,
        title: const Text(
          'Upload Product',
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: uploadProductButton(),
      body: formHandler.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '* All the field are required except brand and model',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 5),
                  _buildTextField(
                    labelText: 'Product Name',
                    onChanged: (value) {
                      setState(() {
                        formHandler.productName = value;
                      });
                    },
                  ),
                  _buildTextField(
                    labelText: 'Brand (optional)',
                    onChanged: (value) {
                      setState(() {
                        formHandler.brand = value;
                      });
                    },
                  ),
                  _buildTextField(
                    labelText: 'Model (optional)',
                    onChanged: (value) {
                      setState(() {
                        formHandler.model = value;
                      });
                    },
                  ),
                  _buildTextField(
                    labelText: 'Product Description/Condition',
                    onChanged: (value) {
                      setState(() {
                        formHandler.productDescription = value;
                      });
                    },
                    maxLines: 4,
                  ),
                  _buildSellingTypeRadioButton(),
                  const SizedBox(height: 10),
                  formHandler.productType == ProductType.auction
                      ? _buildDateTimeWidget(context)
                      : const SizedBox.shrink(),
                  _buildTextField(
                    labelText: formHandler.productType == ProductType.fixedPrice
                        ? "Product Price (RM)"
                        : "Starting Price (RM)",
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        formHandler.price = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  _buildDropDownMenuCategory(),
                  Container(
                    margin:
                        const EdgeInsets.only(right: 10, left: 10, bottom: 15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // Color of the border
                        width: 1.0, // Width of the border
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: formHandler.image != null
                        ? Column(
                            children: [
                              Image.file(
                                formHandler.image!,
                                height: 150,
                                width: double.infinity,
                              ),
                              const SizedBox(height: 5),
                              ElevatedButton(
                                onPressed: showImagePickerDialog,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(243, 155, 198, 255),
                                  elevation: 3,
                                ),
                                child: const Text(
                                  'Reupload Product Image',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 5),
                                ElevatedButton(
                                  onPressed: showImagePickerDialog,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        243, 155, 198, 255),
                                    elevation: 3,
                                  ),
                                  child: const Text(
                                    'Upload Product Image',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  )
                ]),
              ),
            ),
    );
  }

  Future<void> showImagePickerDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Image Source'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  pickImage();
                  Navigator.pop(context);
                },
                child: const Text('Pick image from gallery'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  captureImage();
                  Navigator.pop(context);
                },
                child: const Text('Capture image using camera'),
              ),
            ],
          );
        });
  }

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file selected'),
        ),
      );
      return;
    }
    final selectedImage = File(image.path);

    setState(() => formHandler.image = selectedImage);
  }

  Future<void> captureImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file selected'),
        ),
      );
      return;
    }
    final selectedImage = File(image.path);
    setState(() => formHandler.image = selectedImage);
  }

  Widget _buildTextField({
    required String labelText,
    required ValueChanged<String> onChanged,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.only(right: 10, left: 10, bottom: 15),
      child: TextField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _buildDropDownMenuCategory() {
    return Container(
      margin: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 15),
      height: 62,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Choose Category',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              value: formHandler.category ?? 'Clothing and Accessories',
              onChanged: (String? newValue) {
                setState(() {
                  formHandler.category = newValue!;
                });
              },
              items: <String>[
                'Clothing and Accessories',
                'Digital Products',
                'Electronics',
                'Furniture',
                'Books',
                'Others',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSellingTypeRadioButton() {
    return Container(
      margin: const EdgeInsets.only(right: 10, left: 10),
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 133, 125, 125),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Selling Type',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
            ),
          ),
          SizedBox(
            height: 30,
            width: 300,
            child: ListTile(
              title: const Text('Fixed Price'),
              contentPadding: EdgeInsets.zero,
              leading: Radio<bool>(
                  value: true,
                  groupValue: formHandler.productType == ProductType.fixedPrice,
                  onChanged: (bool? value) {
                    setState(
                      () {
                        formHandler.productType = ProductType.fixedPrice;
                      },
                    );
                  }),
            ),
          ),
          SizedBox(
            height: 30,
            width: 300,
            child: ListTile(
              title: const Text('Auction'),
              contentPadding: EdgeInsets.zero,
              leading: Radio<bool>(
                  value: false,
                  groupValue: formHandler.productType == ProductType.fixedPrice,
                  onChanged: (bool? value) {
                    setState(
                      () {
                        formHandler.productType = ProductType.auction;
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Material(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  final date = await pickDate();
                  if (date == null) return;

                  setState(() {
                    datepicked = date;
                    formHandler.endTime = datepicked.add(
                      Duration(
                        hours: timepicked.hour,
                        minutes: timepicked.minute,
                      ),
                    );
                  });
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Enter End Date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.date_range),
                      const SizedBox(width: 10),
                      Text(
                        '${datepicked.year}/${datepicked.month}/${datepicked.day}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () async {
                  final time = await pickTime();
                  if (time == null) return;

                  setState(() {
                    timepicked = time;
                    formHandler.endTime = datepicked.add(
                      Duration(
                        hours: timepicked.hour,
                        minutes: timepicked.minute,
                      ),
                    );
                  });
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Enter End Time",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(width: 10),
                      Text(
                        timepicked.format(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: datepicked,
        firstDate: datepicked,
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> pickTime() =>
      showTimePicker(context: context, initialTime: timepicked);

  Widget uploadProductButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          submitForm();
        },
        style: ElevatedButton.styleFrom(
            //fixedSize: const Size(300, 50),
            backgroundColor: const Color.fromARGB(255, 56, 38, 106),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            )),
        child: const Text(
          'Upload New Product',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
