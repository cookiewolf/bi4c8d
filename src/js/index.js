import "../css/reset.css";
import "../css/style.css";
import "@fontsource/inter";

import { Elm } from "../elm/Main.elm";

import mainText from "../../data/main-text.json"
import posts from "../../data/posts.json"
import messages from "../../data/messages.json"
import images from "../../data/images.json"
import graphs from "../../data/graphs.json"
import terminals from "../../data/terminals.json"
import tickers from "../../data/tickers.json"

if (process.env.NODE_ENV === "development") {
    const ElmDebugTransform = await import("elm-debug-transformer");

    ElmDebugTransform.register({
        simple_mode: true
    });
}

const root = document.querySelector("#app div");
const app = Elm.Main.init({
    node: root,
    flags: {
        "main-text": mainText,
        "posts": posts,
        "messages": messages,
        "images": images,
        "graphs": graphs,
        "terminals": terminals,
        "tickers": tickers
    }
});

window.addEventListener("scroll", () => {
    app.ports.onScroll.send({x: window.scrollX, y: window.scrollY});
});
