import 'package:flutter/material.dart';
import '../services/product_service.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  double _discount = 0.0;
  final double _shippingCost = 13.00; // Frete fixo solicitado
  bool _couponApplied = false;

  List<CartItem> get items => _items;
  double get shippingCost => _items.isEmpty ? 0.0 : _shippingCost;
  double get discount => _discount;
  bool get couponApplied => _couponApplied;

  // Subtotal (soma dos itens)
  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  // Total Final
  double get total => (subtotal + shippingCost) - _discount;

  void addToCart(Product product) {
    // Verifica se já existe no carrinho
    int index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void incrementQuantity(String productId) {
    int index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String productId) {
    int index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        // Se for 1 e diminuir, remove o item
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _discount = 0.0;
    _couponApplied = false;
    notifyListeners();
  }

  int get totalItemCount {
  return _items.fold(0, (sum, item) => sum + item.quantity);
}

  // Lógica de Cupom
  void applyCoupon(String coupon) {
    if (coupon.toUpperCase() == 'JOIA10') {
      // Exemplo: 10% de desconto no subtotal
      _discount = subtotal * 0.10;
      _couponApplied = true;
    } else if (coupon.toUpperCase() == 'FRETEGRATIS') {
      _discount = _shippingCost; // Desconto igual ao frete
      _couponApplied = true;
    } else {
      _discount = 0.0;
      _couponApplied = false;
    }
    notifyListeners();
  }
}