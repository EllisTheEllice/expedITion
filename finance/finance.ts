import { Component } from '@angular/core';
import { NavController } from 'ionic-angular';
import {Item} from '../../models/item';
import { Http, Response } from "@angular/http";
//import { Headers, RequestOptions } from '@angular/http';
//import { Observable } from 'rxjs';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/toPromise';

@Component({
    selector: 'page-finance',
    templateUrl: 'finance.html'
})
export class FinancePage {

    public date: String;
    public items: Item[] = [];
    private _http: Http;

    constructor(public navCtrl: NavController, http: Http) {
        this._http = http;
        var tempDate = new Date();
        this.date = tempDate.getDate() + "." + (tempDate.getMonth() + 1) + "." + tempDate.getFullYear();

        //        var item1 = new Item("Capgemini DE", "2.000 €", true,"29.11.        2017");
        //        var item2 = new Item("Edeka Kelts", "89,15 €", false,"28.11.        2017");
        //        var item3 = new Item("Kita Ratingen", "183,50 €", false,"26.11.        2017");
        //        var item4 = new Item("Eva Eagle", "100,00 €", true,"26.11.        2017");
        //        var item5 = new Item("Ellie Elephant", "83,50 €", true,"26.11.        2017");
        //        var item6 = new Item("Molly Mouse", "450,00 €", true,"26.11.        2017");
        //        this.items.push(item1, item2, item3, item4, item5, item6);

        this._http.get("https://c797go5v9i.execute-api.eu-west-1.amazonaws.com/dev/transactions").toPromise().then(this.extractData).catch(this.handleErrorPromise);;

    }

    /**
 * Prompt the user to add a new item. This shows our ItemCreatePage in a
 * modal and then adds the new item to our data source if the user created one.
 */
    addItem() {
        /*let addModal = this.modalCtrl.create('ItemCreatePage');
        addModal.onDidDismiss(item => {
            if (item) {
                this.items.add(item);
            }
        })
        addModal.present();*/
    }

    /**
     * Delete an item from the list of items.
     */
    deleteItem(item) {
        // this.items.delete(item);
    }

    /**
     * Navigate to the detail page for this item.
     */
    openItem(item: Item) {
        /* this.navCtrl.push('ItemDetailPage', {
             item: item
         });*/
    }

    private extractData = (res: Response) => {
        let body = res.json();
        for (let i = 0; i < body.Items.length; i++) {
            let item = body.Items[i];
            let transaction = new Item(item.name, item.amount, item.incoming, item.date);
            this.items.push(transaction);
        }
    }


    handleErrorPromise(error: Response | any) {
        console.error(error.message || error);
        return Promise.reject(error.message || error);
    }
}
