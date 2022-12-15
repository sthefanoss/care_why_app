import 'package:care_why_app/providers/auth_provider.dart';
import 'package:care_why_app/providers/exchanges_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/utils.dart';

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
          padding: const EdgeInsets.only(bottom: 81),
          itemCount: exchangesProvider.exchanges.length,
          itemBuilder: (c, i) {
            final getUserById = exchangesProvider.getUserById;
            final exchange = exchangesProvider.exchanges[i];
            final seller = getUserById(exchange.sellerId);
            final buyer = getUserById(exchange.buyerId);

            return Container(
              color: i % 2 == 0 ? Colors.black.withOpacity(0.035) : null,
              padding: const EdgeInsets.all(8),
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        exchange.reason,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(Utils.formatDateTime(exchange.createdAt))
                  ],
                ),
                subtitle: Text(
                  'Custo \$ ${exchange.coins}\n'
                  'Recebedor: ${buyer.nickname} @${buyer.username}\n'
                  'Aprovado: ${seller.nickname} @${buyer.username}',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
