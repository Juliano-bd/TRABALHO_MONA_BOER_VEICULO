import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Carrinho'),
        backgroundColor: Colors.amber[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Limpar Carrinho',
            onPressed: () => cart.clearCart(),
          )
        ],
      ),
      body: Column(
        children: [
          // Lista de Itens
          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text('Seu carrinho está vazio.'))
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(item.product.name),
                          subtitle: Text(currency.format(item.product.price)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => cart.decrementQuantity(item.product.id),
                              ),
                              Text('${item.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => cart.incrementQuantity(item.product.id),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => cart.removeItem(item.product.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          
          // Área de Cupom e Totais
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Column(
              children: [
                // Campo de Cupom
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _couponController,
                        decoration: const InputDecoration(
                          hintText: 'Cupom (ex: JOIA10)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        cart.applyCoupon(_couponController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(cart.couponApplied ? 'Cupom aplicado!' : 'Cupom inválido')),
                        );
                      },
                      child: const Text('Aplicar'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Resumo de Valores
                _buildSummaryRow('Subtotal:', cart.subtotal, currency),
                _buildSummaryRow('Frete:', cart.shippingCost, currency),
                _buildSummaryRow('Desconto:', -cart.discount, currency, isDiscount: true),
                const Divider(),
                _buildSummaryRow('TOTAL:', cart.total, currency, isTotal: true),
                
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    // Lógica de finalizar compra aqui
                  },
                  child: const Text('FINALIZAR COMPRA', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, NumberFormat currency, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 18 : 14)),
          Text(
            currency.format(value),
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
              color: isDiscount ? Colors.green : (isTotal ? Colors.amber[800] : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}