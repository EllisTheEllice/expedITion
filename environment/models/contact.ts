export class Contact {

    public name: String;
    public lastname: String;
    public title: String;
    public phone: String;
    public email: String;
    public profilePic: String;

    constructor(name: String, lastname: String, title: String, phone: String, email: String,profilePic:String) {
        this.name = name;
        this.lastname = lastname;
        this.title=title;
        this.phone = phone;
        this.email = email;
        this.profilePic = profilePic;
    }
}
