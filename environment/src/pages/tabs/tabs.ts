import { Component } from '@angular/core';

import { FinancePage } from '../finance/finance';
import { ContactPage } from '../contact/contact';
import { HomePage } from '../home/home';

@Component({
  templateUrl: 'tabs.html'
})
export class TabsPage {

  tab1Root = HomePage;
  tab2Root = FinancePage;
  tab3Root = ContactPage;

  constructor() {

  }
}
