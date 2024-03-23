import "../css/reset.css";
import "../css/style.css";
import "@fontsource/inter";

import { Elm } from "../elm/Main.elm";
import Terminal from "./terminal";

import mainText from "../../data/main-text.json"
import posts from "../../data/posts.json"
import messages from "../../data/messages.json"
import images from "../../data/images.json"
import graphs from "../../data/graphs.json"
import tickers from "../../data/tickers.json"

if (process.env.NODE_ENV === "development") {
    const ElmDebugTransform = await import("elm-debug-transformer");

    ElmDebugTransform.register({
        simple_mode: true
    });
}

customElements.define("ttty-terminal", Terminal);

const root = document.querySelector("#app div");
const app = Elm.Main.init({
    node: root,
    flags: {
        "main-text": mainText,
        "posts": posts,
        "messages": messages,
        "images": images,
        "graphs": graphs,
        "tickers": tickers
    }
});

window.addEventListener("scroll", () => {
    app.ports.onScroll.send({x: window.scrollX, y: window.scrollY});
});
