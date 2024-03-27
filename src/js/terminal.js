import { initTerminal } from 'ttty';
import { terminal1 } from './terminal1';

class Terminal extends HTMLElement {
    constructor() {
        super();
    }
    connectedCallback() {
        const settings = {
            host: document.querySelector('#terminal-1'),
            commands: terminal1,
        }
        const terminalSettings = this.getTerminalSettings();
        initTerminal({ ...settings,
            welcomeMessage: terminalSettings.welcomeMessage,
            prompt: terminalSettings.prompt
        });
    }
    attributeChangedCallback() {}
    static getObservedAttributes() {
        return ['host-id', 'welcome-message', 'prompt', 'command-src']; 
    }

    // Get terminal settings from attributes.
    getTerminalSettings()
    {
        const hostId = this.getAttribute('host-id');
        const welcomeMessage = this.getAttribute('welcome-message');
        const prompt = this.getAttribute('prompt');
        const commandSrc = this.getAttribute('commands');
        return { hostId, welcomeMessage, prompt, commandSrc };
    }
}

export default Terminal;
