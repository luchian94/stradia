import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home.model.dart';

class HomeGpsVerify extends ViewModelWidget<HomeModel> {
  HomeGpsVerify({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, HomeModel model) {
    if (model.isSettingUp) {
      if(model.gpServiceEnabled == false) {
        return Text('Attenzione! È necessario abilitare il servizio GPS per continuare');
      }
      if(!model.hasGpsPermission) {
        return Text('Attenzione! È necessario garantire il permesso della posizione per poter continuare');
      }
    }
    return Container();
  }
}
