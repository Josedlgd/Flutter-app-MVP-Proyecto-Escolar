import 'package:flutter/material.dart';

dashboardTabs() => const [
      Tab(
        icon: Icon(
          Icons.pending,
        ),
        text: 'Próximos a entregar',
      ),
      Tab(
        icon: Icon(
          Icons.check_circle_outline,
        ),
        text: 'Entregadas',
      ),
    ];
