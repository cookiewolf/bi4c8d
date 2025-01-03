import "../css/reset.css";
import "../css/fonts.css";
import "../css/style.css";
import "@fontsource/inter";
import "@fontsource/source-code-pro";

import TitleAnimation from "../js/scramble";
import Spotlight from "../js/spotlight";

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


customElements.define("hyvor-talk-comments-wrapper", class extends HTMLElement {

  constructor() { 
      super(); 
  }

  static get observedAttributes() { return ["page-id"]; }

  attributeChangedCallback(name, oldValue, newValue) {
    if (name === "page-id" && oldValue !== newValue) {
      const comments = document.createElement("hyvor-talk-comments");
      comments.setAttribute('website-id', "11670");
      comments.setAttribute('page-id', newValue);
      const style = document.createElement('style');
      style.innerHTML = '.reactions-title {display: none;}';
      comments.shadowRoot.appendChild(style);
      this.replaceChildren(comments);
    }
  }
});

new Spotlight({toggleEl: '#light-switch'});

const phrases = ['Bi4c8d', 'Bifurcated', 'Bi4c8d', 'Bifurcated']
const el = document.querySelector('.title-text')
const fx = new TitleAnimation(el)

let counter = 0
let cycles = 0

const next = () => {
  fx.setText(phrases[counter]).then(() => {
    if (cycles < 5) {
      setTimeout(next, 1000)
      cycles++
    }
  })
  counter = (counter + 1) % phrases.length
}

next()

window.addEventListener("scroll", () => {
  app.ports.onScroll.send({ x: window.scrollX, y: window.scrollY });
});

const sizeObserver = new ResizeObserver((entries) => {
  app.ports.onGrow.send(entries[0].borderBoxSize[0].blockSize);
});

sizeObserver.observe(document.body);
