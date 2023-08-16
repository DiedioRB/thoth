import 'package:thoth/models/interfaces/item_form.dart';

abstract class ItemFormModel {
  static List<ItemForm> getFields(ItemForm? source) {
    return [];
  }
}
