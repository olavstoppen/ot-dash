import "./index.scss";
import { Elm } from "./elm/Main";


var app = Elm.Main.init({
  flags: {
    apiKey: process.env.API_KEY,
    pageCountdownMillis: parseInt(process.env.PAGE_COUNTDOWN_MILLIS) || 60
  }
});

// app.ports.toJs.subscribe(data => {
//   console.log(data);
// });
