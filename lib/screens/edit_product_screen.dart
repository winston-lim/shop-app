// Form() TextFormField() - NOTE: TextFormFields take as much width as it can get by default, so take caution in nesting it within a Row()
// FocusNode() - .hasFocus and FocusScope()
// GlobaKey()
// currentState.save() .validate()
// double.tryParse, string.startsWith(), string.endsWith()
// CircularProgressIndicator()
// try, catch, finally
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/product_provider.dart";
import "../providers/products_provider.dart";

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-screen";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  // FocusNode() is a class that lets you decide which field is currently in focus, where we attach it to a focusNode: property in a field.
  final _imageUrlController = TextEditingController();
  // When working with forms, we do not require manaully assigning controllers, UNLESS we require using certain values before submitting the form
  // In this case, we want users to be able to preview the image based on the URL they enter, so we require the URL BEFORE they submit the form
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  // Our submit function requires us to have a way to access/interact with form, which is somewhere down in the widget tree
  // We can use GlobalKey to access something that is not normally accessible, and we establish a connection to a widget using the key: property
  var _editedProduct = Product(
    id: null,
    title: "",
    description: "",
    imageUrl: "",
    price: 0,
  );

  var _initValues = {
    "title": "",
    "description": "",
    "imageUrl": "",
    "price": "",
  };
  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith("http") &&
              !_imageUrlController.text.startsWith("https")) ||
          (!_imageUrlController.text.endsWith(".jpg") &&
              !_imageUrlController.text.endsWith(".png") &&
              !_imageUrlController.text.endsWith(".jpeg"))) {
        return;
      }
      setState(() {});
    }
  }

  var _isLoading = false;
  Future<void> _submitForm() async {
    // explanation for async and await is in products_provider.dart
    final isValidSubmission = _form.currentState.validate();
    // .validate() will run the validator functions on all the formfields, and returns true if there are no errors.
    if (isValidSubmission) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
        // changes the state of isLoading to false, so that we render something when our data is loading and not just freeze
      });
      if (_editedProduct.id != null) {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_editedProduct);
        } catch (error) {
          await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("An error occurred!"),
              content: Text(error.toString()),
              actions: [
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () => Navigator.of(ctx).pop(),
                )
              ],
            ),
          );
        }
        // } finally {
        //   setState(() {
        //     _isLoading = false;
        //     Navigator.of(context).pop();
        //   });
        // }
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
    // Form() is a stateful widget, and we access its state using _form which was assigned to GlobalKey<FormState>()
    // .save is a method by Flutter that saves the state of the Form.
    // .save() runs the function declared on onSaved: on each of the fields within the form
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    // adds a listener that executes whenever _imageUrlFocusNode changes hasFocus>!hasFocus
    super.initState();
  }

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "imageUrl": _editedProduct.imageUrl,
          "price": _editedProduct.price.toString(),
        };
        _imageUrlController.text = _initValues["imageUrl"];
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    // FocusNode()s stay in memory, therefore to prevent memory leaks, we ensure to dispose of it in our state object.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      // When using Form(), we do not have to set up controllers, flutter does that for us behind the scenes
                      decoration: InputDecoration(labelText: "Title"),
                      initialValue: _initValues["title"],
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        // When field is submitted i.e. textInputAction button is pressed, we want move to the next field, and we do so by refering its focusNode value.
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },

                      onSaved: (newValue) {
                        _editedProduct = Product(
                          title: newValue,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a value";
                        }
                        return null;
                      },
                      // textInputAction controls what the bottom-right button of soft keyboard displayes, usually either next or done or submit
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Price"),
                      initialValue: _initValues["price"],
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      // Keyboard type configures what type of softkeyboard appears when you click on the textfield
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                          imageUrl: _editedProduct.imageUrl,
                          price: double.parse(newValue),
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a value";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please enter a number";
                        }
                        if (double.parse(value) <= 0) {
                          return "Please enter a value greater than 0";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      // When using Form(), we do not have to set up controllers, flutter does that for us behind the scenes
                      decoration: InputDecoration(labelText: "Description"),
                      initialValue: _initValues["description"],
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      // when maxLines is configured to a value greater than 3, then a keyboardType of multiline helps us configure a default textInputAction (to go to next line)
                      // and we cannot configure onFieldSubmitted because we do not know when user intends to go to next line or is done with that field
                      focusNode: _descriptionFocusNode,
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: newValue,
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a value";
                        }
                        if (value.length < 10) {
                          return "Please enter a description of at least 10 characters";
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text("Enter a URL")
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "Image URL"),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              setState(() {});
                              _submitForm();
                            },
                            onSaved: (newValue) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                id: _editedProduct.id,
                                isFavourite: _editedProduct.isFavourite,
                                imageUrl: newValue,
                                price: _editedProduct.price,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter a value";
                              }
                              if (!value.startsWith("http") &&
                                  !value.startsWith("https")) {
                                return "Please enter a valid URL";
                              }
                              if (!value.endsWith(".jpg") &&
                                  !value.endsWith(".png") &&
                                  !value.endsWith(".jpeg")) {
                                return "Please enter a valid image URL";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
