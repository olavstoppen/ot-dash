import "./styles.scss";
import { Elm } from "./elm/Main";

var app = Elm.Main.init({ flags: { apiKey: process.env.API_KEY } });

// app.ports.toJs.subscribe(data => {
//   console.log(data);
// });
