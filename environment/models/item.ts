/**
 * A generic model that our Master-Detail pages list, create, and delete.
 *
 * Change "Item" to the noun your app will use. For example, a "Contact," or a
 * "Customer," or a "Animal," or something like that.
 *
 * The Items service manages creating instances of Item, so go ahead and rename
 * that something that fits your app as well.
 */
export class Item {

    public name: String;
    public amount: String;
    public incoming: boolean;
    public profilePic: String;
    public cssclass: String;
    public date: String;

    constructor(name: String, amount: String, incoming: boolean, date: String) {
        if (incoming == true) {
            this.profilePic = "assets/imgs/incoming.png"
            this.cssclass = "incoming";
        } else {
            this.profilePic = "assets/imgs/outgoing.png"
            this.cssclass = "outgoing";
        }
        this.name = name;
        this.amount = amount;
        this.date = date;
    }

}