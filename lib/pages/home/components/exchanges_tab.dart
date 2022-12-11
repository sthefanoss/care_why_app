import 'package:care_why_app/providers/auth_provider.dart';
import 'package:care_why_app/providers/exchanges_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExchangesTab extends StatefulWidget {
  const ExchangesTab({Key? key}) : super(key: key);

  @override
  State<ExchangesTab> createState() => _ExchangesTabState();
}

class _ExchangesTabState extends State<ExchangesTab> {
  late final ExchangesProvider exchangesProvider;

  @override
  void initState() {
    exchangesProvider = Provider.of<ExchangesProvider>(context, listen: false);
    exchangesProvider.getExchangesFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) => Consumer<ExchangesProvider>(
        builder: (_, exchangesProvider, __) => ListView.builder(
          itemCount: exchangesProvider.exchanges.length,
          itemBuilder: (c, i) => Container(
            color: i % 2 == 0 ? Colors.black.withOpacity(0.035) : null,
            child: ListTile(
              title: Text(exchangesProvider.exchanges[i].reason),
              subtitle: Text(
                'Custo \$ ${exchangesProvider.exchanges[i].coins}\n'
                'Recebedor: ${exchangesProvider.exchanges[i].buyerId}'
                'Aprovado por: ${exchangesProvider.exchanges[i].sellerId}',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
