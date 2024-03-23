import { initTerminal } from 'ttty';




class Terminal extends HTMLElement {
    constructor() {
        super();
    }
    connectedCallback() {
        const settings = {
            host: document.querySelector("#ttty-terminal"),
            commands: {
                echo: {
                    name: "echo",
                    description: "a test command with one echo arg",
                    argDescriptions: ["a string to be echoed in console"],
                    func: ({ print }, argument) => { print(argument) }
                },
                test: {
                    name: "test",
                    description: "a test command with no args",
                    func: ({ print }) => { print("foo") }
                },
                multiply: {
                    name: "multiply",
                    description: "Multiply two numbers",
                    argDescriptions: ["number one", "number two"],
                    func: ({ print }, one, two) => { print(Number(one) * Number(two)) }
                }
            }
        }
        const terminalSettings = this.getCommands(); 
        initTerminal({ ...settings,
            welcomeMessage: terminalSettings.welcomeMessage,
            prompt: terminalSettings.prompt
        });
    }
    attributeChangedCallback() {}
    static getObservedAttributes() {
        return ['welcome-message', 'prompt']; 
    }

    // Our function to set the textContent based on attributes.
    getCommands()
    {
        const welcomeMessage = this.getAttribute('welcome-message');
        const prompt = this.getAttribute('prompt');
        return { welcomeMessage, prompt };
    }
}

export default Terminal;
