export const terminal1 = { 
    info: {
      name: 'info',
      description: 'a test command with no arguments that just prints some text',
      func: ({ print }) => { print($test) }
    },
    search: {
      name: 'search',
      description: 'a test command with no arguments that just prints some text',
      func: ({ print }) => { print($search) }
    },
}

const $test = `
<a href="https://googl.com">info</a>
hello`

const $search = `
<a href="https://googl.com">search</a>
hello`
