import { Component } from '@angular/core';
import { NavController } from 'ionic-angular';
import {Contact} from '../../models/contact';
import { Api } from '../../providers/providers';
import { Http, Response } from "@angular/http";
//import { Headers, RequestOptions } from '@angular/http';
//import { Observable } from 'rxjs';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/toPromise';

@Component({
    selector: 'page-contact',
    templateUrl: 'contact.html'
})
export class ContactPage {

    public contacts: Contact[] = [];
    private _http: Http;

    constructor(public navCtrl: NavController, http: Http) {
        this._http = http;
        //        var sth = api.get("contacts");
        //        sth.subscribe((data: any[]) => this.values = data,
        //            error => () => {
        //                console.log('error');
        //            },
        //            () => {
        //                console.log('Yeah!');
        //            });
        this._http.get("https://c797go5v9i.execute-api.eu-west-1.amazonaws.com/dev/contacts").toPromise().then(this.extractData).catch(this.handleErrorPromise);;

        //        var c1 = new Contact("Herrmann", "Klose", "Kundenbetreuer", "+49 211 12345-5", "h.klose@myfinance.de", "assets/imgs/speakers/eagle.jpg");
        //        var c2 = new Contact("Dingeling", "King", "Bankdirektor", "+49 211 12345-1", "chef@myfinance.de", "assets/imgs/speakers/bear.jpg");
        //        this.contacts.push(c1, c2);
    }

    private extractData = (res: Response) => {
        let body = res.json();
        for (let i = 0; i < body.Items.length; i++) {
            let item = body.Items[i];
            let contact = new Contact(item.name, item.lastname, item.title, item.phone, item.email, item.profilePic);
            this.contacts.push(contact);
        }
    }

    handleErrorPromise(error: Response | any) {
        console.error(error.message || error);
        return Promise.reject(error.message || error);
    }
}
