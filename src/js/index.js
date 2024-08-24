import "../css/reset.css";
import "../css/fonts.css";
import "../css/style.css";
import "@fontsource/inter";
import "@fontsource/source-code-pro";

import { Elm } from "../elm/Main.elm";

import context from "../../data/context.json";
import mainText from "../../data/main-text.json";
import posts from "../../data/posts.json";
import messages from "../../data/messages.json";
import images from "../../data/images.json";
import graphs from "../../data/graphs.json";
import terminals from "../../data/terminals.json";
import tickers from "../../data/tickers.json";

if (process.env.NODE_ENV === "development") {
  const ElmDebugTransform = await import("elm-debug-transformer");

  ElmDebugTransform.register({
    simple_mode: true,
  });
}

const root = document.querySelector("#app div");
const app = Elm.Main.init({
  node: root,
  flags: {
    context: context,
    "main-text": mainText,
    posts: posts,
    messages: messages,
    images: images,
    graphs: graphs,
    terminals: terminals,
    tickers: tickers,
  },
});


customElements.define("section-change-tracker", class extends HTMLElement {
  
  constructor() { 
      super(); 
  
      this.hyvorComments = document.querySelector("hyvor-talk-comments");
  }
  
  static get observedAttributes() { return ["section-id"]; }
  
  attributeChangedCallback(name, oldValue, newValue) {
    if (name === "section-id" && oldValue !== newValue) {
      this.hyvorComments = document.querySelector("hyvor-talk-comments");
      if (this.hyvorComments !== null) {
        console.log(this.hyvorComments);
        this.hyvorComments.api.reload();
      }
    }
  }
});


window.addEventListener("scroll", () => {
  app.ports.onScroll.send({ x: window.scrollX, y: window.scrollY });
});

const sizeObserver = new ResizeObserver((entries) => {
  app.ports.onGrow.send(entries[0].borderBoxSize[0].blockSize);
});

sizeObserver.observe(document.body);
