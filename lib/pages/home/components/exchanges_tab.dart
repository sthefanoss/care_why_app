import 'package:care_why_app/providers/auth_provider.dart';
import 'package:care_why_app/providers/exchanges_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
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
            final buyer = getUserById(exchange.buyerId);

            return Container(
              color: i % 2 == 0 ? Colors.black.withOpacity(0.035) : null,
              padding: const EdgeInsets.all(8),
              child: ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      (exchange.coins).toString().padLeft(3, '0'),
                      style: TextStyle(
                        color: Color(0xFF4A2D00),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 4),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFD600),
                        shape: BoxShape.circle,
                      ),
                    )
                  ],
                ),
                title: Text(exchange.reason),
                subtitle: Text('@${buyer.username}\n'),
                trailing: Text(
                  Utils.formatDateTime(
                    exchange.createdAt,
                    format: "HH:mm\ndd/MM/yyyy",
                  ),
                  style: TextStyle(color: Constants.colors.primary),
                  textAlign: TextAlign.end,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
