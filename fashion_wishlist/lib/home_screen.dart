import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'fashion_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FashionItem> wishlist = [];

  String search = "";
  String selectedCategory = "All";

  final categoryController = TextEditingController();
  final brandController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  Uint8List? selectedImage;

  final List<String> categories = ["All", "Shoes", "Bags", "Tops", "Bottoms"];

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result != null && result.files.first.bytes != null) {
      selectedImage = result.files.first.bytes!;
    }
  }

  void addProduct() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add Product"),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    GestureDetector(
                      onTap: () async {
                        await pickImage();

                        setDialogState(() {});
                      },

                      child: Container(
                        height: 150,
                        width: 150,

                        decoration: BoxDecoration(
                          color: Colors.grey[200],

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: selectedImage == null
                            ? const Icon(Icons.add_a_photo, size: 50)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20),

                                child: Image.memory(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: categoryController,

                      decoration: const InputDecoration(labelText: "Category"),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: brandController,

                      decoration: const InputDecoration(labelText: "Brand"),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: nameController,

                      decoration: const InputDecoration(
                        labelText: "Product Name",
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: descriptionController,

                      maxLines: 3,

                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: priceController,

                      keyboardType: TextInputType.number,

                      decoration: const InputDecoration(labelText: "Price"),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () {
                    if (selectedImage == null) {
                      return;
                    }

                    setState(() {
                      wishlist.add(
                        FashionItem(
                          imageBytes: selectedImage!,
                          category: categoryController.text,
                          brand: brandController.text,
                          name: nameController.text,
                          description: descriptionController.text,
                          price: double.tryParse(priceController.text) ?? 0,
                        ),
                      );
                    });

                    brandController.clear();

                    nameController.clear();

                    descriptionController.clear();

                    priceController.clear();

                    selectedImage = null;

                    Navigator.pop(context);
                  },

                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void editProduct(FashionItem item) {
    categoryController.text = item.category;

    brandController.text = item.brand;

    nameController.text = item.name;

    descriptionController.text = item.description;

    priceController.text = item.price.toString();

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Product"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: "Category"),
                ),

                TextField(
                  controller: brandController,
                  decoration: const InputDecoration(labelText: "Brand"),
                ),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Product Name"),
                ),

                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "Description"),
                ),

                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Price"),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  item.category = categoryController.text;

                  item.brand = brandController.text;

                  item.name = nameController.text;

                  item.description = descriptionController.text;

                  item.price = double.tryParse(priceController.text) ?? 0;
                });

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = wishlist.where((item) {
      final searchMatch =
          item.name.toLowerCase().contains(search.toLowerCase()) ||
          item.brand.toLowerCase().contains(search.toLowerCase());

      final categoryMatch =
          selectedCategory == "All" ||
          item.category.toLowerCase() == selectedCategory.toLowerCase();

      return searchMatch && categoryMatch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 226, 226),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 202, 172, 193),

        elevation: 0,

        centerTitle: true,

        title: const Text(
          "♪ wishlisted & purchased list ♪",
          style: TextStyle(
            color: Color.fromARGB(255, 124, 145, 214),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                height: 260,
                width: double.infinity,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),

                  image: const DecorationImage(
                    image: AssetImage("assets/images/banner.png"),
                    fit: BoxFit.cover,
                  ),
                ),

                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),

                    color: Colors.black38,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text(
                        " ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        "curating my vibes",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // SEARCH
              TextField(
                decoration: InputDecoration(
                  hintText: "search a product in my list ✦",

                  prefixIcon: const Icon(Icons.search),

                  filled: true,

                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              // CATEGORY
              SizedBox(
                height: 45,

                child: ListView(
                  scrollDirection: Axis.horizontal,

                  children: categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),

                      child: ChoiceChip(
                        label: Text(
                          category,
                          style: TextStyle(
                            color: selectedCategory == category
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),

                        selected: selectedCategory == category,

                        selectedColor: const Color.fromARGB(255, 202, 172, 193),

                        backgroundColor: Colors.white,

                        side: const BorderSide(
                          color: Color.fromARGB(255, 124, 145, 214),
                          width: 0.5,
                        ),

                        onSelected: (value) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 25),

              const SizedBox(height: 15),

              GridView.builder(
                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                itemCount: filtered.length,

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.55,
                ),

                itemBuilder: (context, index) {
                  final item = filtered[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(20),

                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 8),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),

                            child: Image.memory(
                              item.imageBytes,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(10),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                item.brand,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),

                              Text(
                                item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                "₩${item.price.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,

                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color.fromARGB(255, 139, 139, 139),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      editProduct(item);
                                    },
                                  ),

                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Color.fromARGB(255, 139, 139, 139),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        wishlist.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 195, 188, 204),

        onPressed: addProduct,

        icon: const Icon(Icons.add),

        label: const Text("Add"),
      ),
    );
  }
}
