import "./styles.scss";
import { Elm } from "./elm/Main";

var app = Elm.Main.init({ flags: 6 });

app.ports.toJs.subscribe(data => {
    console.log(data);
});
