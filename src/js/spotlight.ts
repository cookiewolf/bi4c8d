interface SpotlightOptions {
  innerRadius?: number;
  outerRadius?: number;
  outerColor?: string;
}

class Spotlight {
  active = true;
  el: HTMLElement;
  innerRadius: number;
  outerRadius: number;
  outerColor: string;
  boundEventListener: (event: MouseEvent) => void;

  constructor({
    outerColor = "#000000ee",
    innerRadius = 10,
    outerRadius = 350
  }: SpotlightOptions) {
    this.el = document.querySelector('#spotlight')
    this.outerColor = outerColor;
    this.innerRadius = innerRadius;
    this.outerRadius = outerRadius;

    this.boundEventListener = this.handleMouseMove.bind(this);

    this.switchOn();
  }

  switchOn() {
    if (this.el) {
      this.active = true;

      document.addEventListener("mousemove", this.boundEventListener);

      this.el.style.animation = "enter 1s ease forwards";

      setTimeout(() => {
        this.el.style.animation =
  "pulse 3s ease-in-out infinite alternate forwards";
      }, 1000);
    }
  }

  insertSpotlightElement() {
    const el = document.createElement("div");
    el.classList.add("spotlight");
    document.body.appendChild(el);

    return el;
  }

  handleMouseMove(event: MouseEvent) {
    setTimeout(() => {
      this.updateEl(event.clientX, event.clientY);
    }, 90);
  }

  updateEl(x: number, y: number) {
    if (this.el) {
      this.el.style.background = `radial-gradient(circle at ${x}px ${y}px, #00000000 ${this.innerRadius}px, ${this.outerColor} ${this.outerRadius}px)`;
    }
  }
}

export default Spotlight;
